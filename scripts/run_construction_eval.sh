#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
JOB_NAME="${1:-real-deepseek-full}"
if [[ -z "${DEEPSEEK_API_KEY:-}" ]]; then
  if ! command -v security >/dev/null 2>&1; then
    echo "Set DEEPSEEK_API_KEY or use the macOS Keychain service spreadsheetbench-v2-deepseek." >&2
    exit 2
  fi
  export DEEPSEEK_API_KEY="$(security find-generic-password -a "$USER" -s spreadsheetbench-v2-deepseek -w)"
fi

cd "$ROOT"
exec harbor run \
  -p SpreadsheetEval \
  -a terminus-2 \
  -m deepseek/deepseek-chat \
  --job-name "$JOB_NAME" \
  -o jobs \
  -n 1 \
  --memory ignore \
  --cpus ignore \
  --artifact /workspace/output.xlsx \
  --agent-include-logs '**/*' \
  -y
