#!/usr/bin/env python3
from __future__ import annotations

import json
import sys
from collections import Counter
from datetime import datetime
from pathlib import Path


def parse_verifier(path: Path) -> dict:
    if not path.exists():
        return {"reason": "verifier-output-missing"}
    try:
        return json.loads(path.read_text(errors="replace"))
    except json.JSONDecodeError:
        return {
            "reason": "verifier-output-unparseable",
            "raw": path.read_text(errors="replace"),
        }


def failure_patterns(detail: dict, reward: float | None) -> list[str]:
    if reward == 1:
        return []
    reason = detail.get("reason")
    missing = detail.get("missing", [])
    extra = detail.get("extra", [])
    patterns: list[str] = []
    if reason == "modified_set_mismatch":
        if missing:
            patterns.append("incomplete-target-coverage")
        if extra:
            patterns.append("over-editing")
        if missing and extra:
            patterns.append("precision-recall-tradeoff")
    if detail.get("value_errors"):
        patterns.append("semantic-formula-error")
    if reason in {"output-missing", "verifier-output-missing"}:
        patterns.append("no-deliverable")
    return patterns or [reason or "strict-verifier-failure"]


def seconds_between(start: str | None, finish: str | None) -> float | None:
    if not start or not finish:
        return None
    return (
        datetime.fromisoformat(finish) - datetime.fromisoformat(start)
    ).total_seconds()


def main() -> None:
    root = Path(__file__).resolve().parents[1]
    job_name = sys.argv[1] if len(sys.argv) > 1 else "real-deepseek-full"
    job = root / "jobs" / job_name
    rows: list[dict] = []
    for result_path in sorted(job.glob("*/result.json")):
        result = json.loads(result_path.read_text())
        trial = result_path.parent
        detail = parse_verifier(trial / "verifier/test-stdout.txt")
        trajectory_path = trial / "agent/trajectory.json"
        trajectory = (
            json.loads(trajectory_path.read_text()) if trajectory_path.exists() else {}
        )
        steps = trajectory.get("steps", [])
        agent_steps = [step for step in steps if step.get("source") == "agent"]
        tool_calls = sum(len(step.get("tool_calls", [])) for step in agent_steps)
        usage = result.get("agent_result") or {}
        reward = (result.get("verifier_result") or {}).get("rewards", {}).get("reward")
        task_slug = result["task_name"].split("/")[-1]
        manifest_path = root / "SpreadsheetEval" / task_slug / "tests/manifest.json"
        manifest = (
            json.loads(manifest_path.read_text()) if manifest_path.exists() else {}
        )
        final_message = agent_steps[-1].get("message", "") if agent_steps else ""
        patterns = failure_patterns(detail, reward)
        if reward == 0 and "task is complete" in final_message.lower():
            patterns.append("false-completion-confidence")
        rows.append(
            {
                "task": result["task_name"],
                "trial": result["trial_name"],
                "reward": reward,
                "source_original_cases": manifest.get("source_original_cases", []),
                "target_weaknesses": manifest.get("weaknesses", []),
                "required_edits": len(manifest.get("required_cells", [])),
                "steps": len(steps),
                "agent_steps": len(agent_steps),
                "tool_calls": tool_calls,
                "input_tokens": usage.get("n_input_tokens", 0),
                "cache_tokens": usage.get("n_cache_tokens", 0),
                "output_tokens": usage.get("n_output_tokens", 0),
                "cost_usd": usage.get("cost_usd", 0),
                "runtime_seconds": seconds_between(
                    result.get("started_at"), result.get("finished_at")
                ),
                "observed_model_names": sorted(
                    {
                        step["model_name"]
                        for step in agent_steps
                        if step.get("model_name")
                    }
                ),
                "failure_patterns": sorted(set(patterns)),
                "verifier_detail": detail,
                "final_agent_message": final_message,
                "trajectory": f"evaluation_artifacts/{job_name}/{task_slug}/trajectory.json",
            }
        )

    aggregate = Counter(pattern for row in rows for pattern in row["failure_patterns"])
    report = root / "reports" / f"{job_name}-case-analysis.md"
    lines = [
        f"# {job_name}: case-by-case failure analysis",
        "",
        "This report joins each complete model trajectory to the strict verifier result and the original SpreadsheetBench V2 cases that motivated the task.",
        "",
        "## Aggregate bad patterns",
        "",
    ]
    lines.extend(
        f"- `{pattern}`: {count}/10" for pattern, count in aggregate.most_common()
    )
    lines.append("")
    for row in rows:
        detail = row["verifier_detail"]
        missing = detail.get("missing", [])
        extra = detail.get("extra", [])
        value_errors = detail.get("value_errors", {})
        lines += [
            f"## `{row['task']}`",
            "",
            f"- Reward: `{row['reward']}`; required edits: {row['required_edits']}; trajectory steps/tool calls: {row['steps']}/{row['tool_calls']}",
            f"- Original evidence cases: {', '.join(row['source_original_cases'])}; target weaknesses: {', '.join(row['target_weaknesses'])}",
            f"- Tokens: {row['input_tokens']:,} input ({row['cache_tokens']:,} cached) / {row['output_tokens']:,} output; cost: ${row['cost_usd']:.6f}",
            f"- Observed bad patterns: {', '.join(row['failure_patterns']) or 'none'}",
            f"- Exact verifier delta: {len(missing)} missing, {len(extra)} extra, {len(value_errors)} value errors.",
            f"- Complete trajectory: `{row['trajectory']}`",
            "",
            "<details><summary>Full verifier evidence</summary>",
            "",
            "```json",
            json.dumps(detail, indent=2, ensure_ascii=False),
            "```",
            "",
            "</details>",
            "",
        ]
    report.write_text("\n".join(lines) + "\n")
    (root / "reports" / f"{job_name}-case-analysis.json").write_text(
        json.dumps(rows, indent=2, ensure_ascii=False) + "\n"
    )
    print(f"Analyzed {len(rows)} completed trials")


if __name__ == "__main__":
    main()
