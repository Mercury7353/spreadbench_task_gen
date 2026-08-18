#!/usr/bin/env python3
from __future__ import annotations

import json
import shutil
import sys
from pathlib import Path


def copy_if_present(source: Path, destination: Path) -> None:
    if source.exists():
        destination.parent.mkdir(parents=True, exist_ok=True)
        shutil.copy2(source, destination)


def main() -> None:
    root = Path(__file__).resolve().parents[1]
    job_name = sys.argv[1] if len(sys.argv) > 1 else "real-deepseek-full"
    job = root / "jobs" / job_name
    aggregate = json.loads((job / "result.json").read_text())
    completed = aggregate.get("stats", {}).get("n_completed_trials", 0)
    errors = aggregate.get("stats", {}).get("n_errored_trials", 0)
    if completed != 10 or errors:
        raise SystemExit(
            f"refusing partial export: completed={completed}, errors={errors}"
        )

    destination = root / "evaluation_artifacts" / job_name
    if destination.exists():
        shutil.rmtree(destination)
    destination.mkdir(parents=True)
    copy_if_present(job / "result.json", destination / "aggregate-result.json")
    copy_if_present(
        root / "reports" / f"{job_name}-monitor.csv", destination / "monitor.csv"
    )
    copy_if_present(root / "reports" / f"{job_name}.log", destination / "run.log")

    exported = []
    for trial_result in sorted(job.glob("*/result.json")):
        trial = trial_result.parent
        result = json.loads(trial_result.read_text())
        task_slug = result["task_name"].split("/")[-1]
        output = destination / task_slug
        output.mkdir()
        files = {
            trial / "agent/trajectory.json": output / "trajectory.json",
            trial / "agent/recording.cast": output / "terminal-recording.cast",
            trial / "agent/terminus_2.pane": output / "terminal-pane.txt",
            trial / "artifacts/workspace/output.xlsx": output / "output.xlsx",
            trial / "artifacts/manifest.json": output / "artifact-manifest.json",
            trial / "config.json": output / "trial-config.json",
            trial / "result.json": output / "trial-result.json",
            trial / "trial.log": output / "trial.log",
            trial / "verifier/test-stdout.txt": output / "verifier.json",
            trial / "verifier/reward.txt": output / "reward.txt",
        }
        for source, target in files.items():
            copy_if_present(source, target)
        exported.append({"task": task_slug, "trial": result["trial_name"]})

    (destination / "README.md").write_text(
        "# Complete DeepSeek evaluation artifacts\n\n"
        "Each task directory contains the unabridged ATIF trajectory, terminal "
        "recording, final terminal pane, trial metadata, candidate workbook, and "
        "strict verifier evidence. No API credentials are stored here.\n\n"
        f"Exported trials: {len(exported)}.\n"
    )
    print(f"Exported {len(exported)} complete trials to {destination}")


if __name__ == "__main__":
    main()
