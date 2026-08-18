from __future__ import annotations

import json
from collections import Counter
from pathlib import Path


def analyze_template(root: Path) -> list[dict]:
    dataset = json.loads(
        (root / "data/spreadsheetbench-v2/Template/dataset.json").read_text()
    )
    score_file = (
        root
        / "results/Template/deepseek-chat_Template__20260817-232829_regression.json"
    )
    scores = {str(x["id"]): x for x in json.loads(score_file.read_text())["scores"]}
    trajectory_root = root / "trajectories/deepseek-chat/full-20260816T032000Z/Template"
    rows = []
    for item in dataset:
        case_id = str(item["id"])
        score = scores[case_id]
        path = trajectory_root / case_id / f"{case_id}.traj"
        trajectory = json.loads(path.read_text())
        info = trajectory.get("info", {})
        corpus = json.dumps(trajectory, ensure_ascii=False).lower()
        labels, evidence = [], []
        if score["error_message"] == "output file not exist":
            labels.append("no-deliverable")
            evidence.append(f"No output workbook; exit={info.get('exit_status')}")
        if score["modification_accuracy"] == 0:
            labels.append("zero-target-coverage")
            evidence.append("Official modification accuracy is 0.0")
        elif score["modification_accuracy"] < 1:
            labels.append("incomplete-target-coverage")
            evidence.append(
                f"Official modification accuracy is {score['modification_accuracy']:.4f}"
            )
        if (
            score["regression_accuracy"] < 1
            and score["error_message"] != "output file not exist"
        ):
            labels.append("over-editing")
            evidence.append(
                f"Official regression accuracy is {score['regression_accuracy']:.4f}"
            )
        if (
            score["accuracy"] == 0
            and score["regression_accuracy"] >= 0.99
            and score["modification_accuracy"] >= 0.9
        ):
            labels.append("exactness-near-miss")
        if info.get("exit_status") == "exit_format":
            labels.append("tool-protocol")
        if info.get("exit_status") == "exit_cost":
            labels.append("budget-exhaustion")
        if corpus.count("bisection") >= 4 or corpus.count("irr") >= 30:
            labels.append("numerical-looping")
        stats = info.get("model_stats", {})
        if stats.get("tokens_sent", 0) >= 500_000:
            labels.append("context-bloat")
        evidence.append(score.get("error_message", "")[:300])
        rows.append(
            {
                "case_id": case_id,
                "instruction": item.get("instruction", ""),
                "input": item.get("spreadsheet_path"),
                "golden": item.get("golden_response_path"),
                "exit_status": info.get("exit_status"),
                "api_calls": stats.get("api_calls", 0),
                "tokens_sent": stats.get("tokens_sent", 0),
                "regression_accuracy": score["regression_accuracy"],
                "modification_accuracy": score["modification_accuracy"],
                "accuracy": score["accuracy"],
                "first_error": score.get("error_message", ""),
                "weaknesses": sorted(set(labels)),
                "evidence": evidence,
                "trajectory": str(path.relative_to(root)),
            }
        )
    return rows


def write_reports(rows: list[dict], report_dir: Path) -> None:
    report_dir.mkdir(parents=True, exist_ok=True)
    (report_dir / "original_template_97_cases.json").write_text(
        json.dumps(rows, indent=2, ensure_ascii=False) + "\n"
    )
    counts = Counter(tag for row in rows for tag in row["weaknesses"])
    lines = [
        "# Original SpreadsheetBench V2 Template: all 97 cases",
        "",
        "This report uses only original task instructions, trajectories, candidate outputs, and the official evaluator.",
        "",
        "## Aggregate",
        "",
    ]
    for tag, count in counts.most_common():
        lines.append(f"- `{tag}`: {count} cases")
    lines += ["", "## Case-by-case evidence", ""]
    for row in rows:
        lines += [
            f"### `{row['case_id']}`",
            "",
            f"- Score: pass={int(row['accuracy'])}; regression={row['regression_accuracy']:.4f}; modification={row['modification_accuracy']:.4f}",
            f"- Exit/API/tokens: `{row['exit_status']}` / {row['api_calls']} / {row['tokens_sent']:,}",
            f"- Weaknesses: {', '.join(row['weaknesses']) or 'none (passed)'}",
            f"- Evaluator evidence: {row['first_error'] or 'PASS'}",
            f"- Trajectory: `{row['trajectory']}`",
            "",
        ]
    (report_dir / "original_template_97_cases.md").write_text("\n".join(lines))
