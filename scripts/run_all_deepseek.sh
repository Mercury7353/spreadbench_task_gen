#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
RUN_GROUP_ID="${RUN_GROUP_ID:-$(date -u +%Y%m%dT%H%M%SZ)-full}"
MIN_FREE_GIB="${MIN_FREE_GIB:-8}"
WORKERS="${NUM_WORKERS:-1}"
CATEGORIES=(Template Financial_Model Debugging Visualization)

free_gib() {
  df -k /System/Volumes/Data | awk 'NR==2 {printf "%d", $4/1024/1024}'
}

echo "Full run group: $RUN_GROUP_ID"
echo "Workers: $WORKERS"

for category in "${CATEGORIES[@]}"; do
  free="$(free_gib)"
  if (( free < MIN_FREE_GIB )); then
    echo "Stopping before $category: only ${free} GiB free (minimum ${MIN_FREE_GIB} GiB)." >&2
    exit 3
  fi
  echo "[$(date -u +%Y-%m-%dT%H:%M:%SZ)] Starting $category (${free} GiB free)"
  RUN_ID="$RUN_GROUP_ID" NUM_WORKERS="$WORKERS" "$ROOT_DIR/scripts/run_deepseek.sh" "$category"
done

echo "[$(date -u +%Y-%m-%dT%H:%M:%SZ)] Full inference run completed."
