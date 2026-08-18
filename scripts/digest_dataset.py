#!/usr/bin/env python3
from __future__ import annotations

import argparse
import json
from pathlib import Path

from spreadsheet_eval.provenance import canonical_dataset_digests


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--dataset", type=Path, default=Path("SpreadsheetEval"))
    parser.add_argument("--output", type=Path)
    arguments = parser.parse_args()
    payload = (
        json.dumps(
            canonical_dataset_digests(arguments.dataset), indent=2, sort_keys=True
        )
        + "\n"
    )
    if arguments.output:
        arguments.output.parent.mkdir(parents=True, exist_ok=True)
        arguments.output.write_text(payload)
    else:
        print(payload, end="")


if __name__ == "__main__":
    main()
