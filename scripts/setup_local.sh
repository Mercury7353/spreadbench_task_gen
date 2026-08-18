#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ENV_NAME="${SSB_CONDA_ENV:-ssb-v2}"

mkdir -p "$ROOT_DIR/SWE-agent/trajectories" "$ROOT_DIR/results" "$ROOT_DIR/output_excel"

if ! command -v conda >/dev/null 2>&1; then
  echo "conda is required." >&2
  exit 2
fi

if ! conda env list | awk '{print $1}' | grep -qx "$ENV_NAME"; then
  conda create -n "$ENV_NAME" python=3.11 -y
fi

conda run -n "$ENV_NAME" python -m pip install --editable "$ROOT_DIR/SWE-agent"

if command -v docker >/dev/null 2>&1; then
  if docker info >/dev/null 2>&1; then
    docker build -f "$ROOT_DIR/SWE-agent/spreadsheet.Dockerfile" -t spreadsheetbench-v2 "$ROOT_DIR/SWE-agent/docker-context"
  else
    echo "Dependencies installed. Start Docker, then rerun this script to build the image."
  fi
else
  echo "Dependencies installed. Docker is not installed; install Docker Desktop or Docker CLI + Colima, then rerun."
fi
