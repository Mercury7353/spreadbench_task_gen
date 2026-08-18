#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TMP="$ROOT/.tmp/oracle-check"
rm -rf "$TMP"
mkdir -p "$TMP"
for task in "$ROOT"/SpreadsheetEval/*; do
  name="$(basename "$task")"
  mkdir -p "$TMP/$name"
  cp "$task/solution/reference.xlsx" "$TMP/$name/output.xlsx"
  reward="$(docker run --rm -v "$task/tests:/tests:ro" -v "$TMP/$name:/workspace" spreadsheetbench-v2 sh -lc 'python3 /tests/verifier.py >/tmp/verifier.log && cat /logs/verifier/reward.txt')"
  printf '%s\t%s\n' "$name" "$reward"
  [[ "$reward" == "1" ]]
done

