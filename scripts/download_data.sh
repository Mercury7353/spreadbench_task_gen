#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CACHE_DIR="${TMPDIR:-/tmp}/spreadsheetbench-v2-download"
ZIP_PATH="$CACHE_DIR/spreadsheetbench-v2.zip"

mkdir -p "$CACHE_DIR" "$ROOT_DIR/data"

if command -v hf >/dev/null 2>&1; then
  hf download KAKA22/SpreadsheetBench-v2 spreadsheetbench-v2.zip \
    --repo-type dataset --local-dir "$CACHE_DIR"
elif command -v huggingface-cli >/dev/null 2>&1; then
  huggingface-cli download KAKA22/SpreadsheetBench-v2 spreadsheetbench-v2.zip \
    --repo-type dataset --local-dir "$CACHE_DIR"
else
  echo "Install huggingface_hub or activate the ssb-v2 Conda environment first." >&2
  exit 2
fi

rm -rf "$ROOT_DIR/data/spreadsheetbench-v2"
unzip -q "$ZIP_PATH" -d "$ROOT_DIR/data"

if [[ ! -d "$ROOT_DIR/data/spreadsheetbench-v2" ]]; then
  found="$(find "$ROOT_DIR/data" -maxdepth 2 -type d -name Debugging -print -quit)"
  if [[ -n "$found" ]]; then
    parent="$(dirname "$found")"
    mv "$parent" "$ROOT_DIR/data/spreadsheetbench-v2"
  fi
fi

test -f "$ROOT_DIR/data/spreadsheetbench-v2/Template/dataset.json"
echo "Dataset ready at $ROOT_DIR/data/spreadsheetbench-v2"
