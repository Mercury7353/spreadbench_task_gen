#!/usr/bin/env python3
from __future__ import annotations

import json
import subprocess
import sys
from pathlib import Path


def main() -> None:
    root = Path(__file__).resolve().parents[1]
    job_name = sys.argv[1] if len(sys.argv) > 1 else "real-deepseek-full"
    artifacts = root / "evaluation_artifacts" / job_name
    rows = []
    for task in sorted(
        path for path in (root / "SpreadsheetEval").iterdir() if path.is_dir()
    ):
        workspace = artifacts / task.name
        if not (workspace / "output.xlsx").exists():
            raise SystemExit(f"candidate missing for {task.name}")
        command = [
            "docker",
            "run",
            "--rm",
            "-v",
            f"{task / 'tests'}:/tests:ro",
            "-v",
            f"{workspace}:/workspace:ro",
            "spreadsheetbench-v2",
            "sh",
            "-lc",
            "python3 /tests/verifier.py; printf '\\nFINAL_REWARD='; cat /logs/verifier/reward.txt",
        ]
        result = subprocess.run(command, check=True, capture_output=True, text=True)
        prefix, reward = result.stdout.rsplit("FINAL_REWARD=", 1)
        rows.append(
            {
                "task": task.name,
                "reward": float(reward.strip()),
                "verifier_stdout": prefix.strip(),
            }
        )
    output = root / "reports" / f"{job_name}-final-verifier-replay.json"
    output.write_text(json.dumps(rows, indent=2, ensure_ascii=False) + "\n")
    mean = sum(row["reward"] for row in rows) / len(rows)
    print(f"Replayed {len(rows)} candidates with final verifier; mean={mean:.3f}")


if __name__ == "__main__":
    main()
