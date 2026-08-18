#!/usr/bin/env bash
set -euo pipefail

export LANG=C
export LC_ALL=C

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DOCKER_SOCKET="unix://$HOME/.colima/default/docker.sock"
MIRROR_IMAGE="docker.m.daocloud.io/library/python:3.11.10-bullseye"
BASE_IMAGE="python:3.11.10-bullseye"
RUN_ID="${RUN_ID:-$(date -u +%Y%m%dT%H%M%SZ)}"
MIN_FREE_KIB=$((8 * 1024 * 1024))

check_disk() {
  local free_kib
  free_kib="$(df -Pk /System/Volumes/Data | awk 'NR==2 {print $4}')"
  if (( free_kib < MIN_FREE_KIB )); then
    echo "Insufficient disk space: ${free_kib} KiB available; stopping at the 8 GiB safety threshold." >&2
    exit 3
  fi
}

echo "run_id=$RUN_ID"
echo "started_utc=$(date -u +%Y-%m-%dT%H:%M:%SZ)"
check_disk

if ! docker image inspect "$BASE_IMAGE" >/dev/null 2>&1; then
  mkdir -p /tmp/dhome/.docker
  HOME=/tmp/dhome docker -H "$DOCKER_SOCKET" pull "$MIRROR_IMAGE"
  docker tag "$MIRROR_IMAGE" "$BASE_IMAGE"
fi

check_disk
# The image recipe does not COPY repository files. A minimal context avoids
# failures when macOS offloads unrelated repository files during long builds.
docker build --pull=false -f "$ROOT_DIR/SWE-agent/spreadsheet.Dockerfile" -t spreadsheetbench-v2 "$ROOT_DIR/SWE-agent/docker-context"
docker run --rm spreadsheetbench-v2 python -c 'import openpyxl, pandas; print("container-smoke-ok")'

for category in Template Financial_Model Debugging Visualization; do
  check_disk
  echo "category_started=$category $(date -u +%Y-%m-%dT%H:%M:%SZ)"
  RUN_ID="$RUN_ID" NUM_WORKERS="${NUM_WORKERS:-1}" "$ROOT_DIR/scripts/run_deepseek.sh" "$category"
done

echo "finished_utc=$(date -u +%Y-%m-%dT%H:%M:%SZ)"
