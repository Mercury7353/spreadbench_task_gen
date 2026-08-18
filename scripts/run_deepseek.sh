#!/usr/bin/env bash
set -euo pipefail

# macOS does not provide the Linux-style C.UTF-8 locale. Utilities such as
# shasum are Perl-based and abort before evaluation when it leaks from Conda.
export LANG=C
export LC_ALL=C

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CATEGORY="${1:-Template}"
WORKERS="${NUM_WORKERS:-1}"
DATA_ROOT="${DATA_ROOT:-$ROOT_DIR/data/spreadsheetbench-v2}"
IMAGE="${SSB_DOCKER_IMAGE:-spreadsheetbench-v2}"
SWEAGENT_BIN="${SWEAGENT_BIN:-$HOME/miniconda3/envs/ssb-v2/bin/sweagent}"
RUN_ID="${RUN_ID:-$(date -u +%Y%m%dT%H%M%SZ)}"
TRAJECTORY_ROOT="${TRAJECTORY_ROOT:-$ROOT_DIR/trajectories/deepseek-chat}"
RUN_DIR="$TRAJECTORY_ROOT/$RUN_ID/$CATEGORY"
TMPDIR="${SSB_TMPDIR:-$ROOT_DIR/.tmp/sweagent}"
export TMPDIR

case "$CATEGORY" in
  Debugging|Financial_Model|Template|Visualization) ;;
  *) echo "Unknown category: $CATEGORY" >&2; exit 2 ;;
esac

if [[ -z "${DEEPSEEK_API_KEY:-}" ]]; then
  DEEPSEEK_API_KEY="$(security find-generic-password -a "$USER" -s spreadsheetbench-v2-deepseek -w 2>/dev/null || true)"
fi
if [[ -z "$DEEPSEEK_API_KEY" ]]; then
  echo "DEEPSEEK_API_KEY is unset and no macOS Keychain entry was found." >&2
  exit 2
fi
export DEEPSEEK_API_KEY

if ! command -v docker >/dev/null 2>&1; then
  echo "Docker is required. Install/start Docker Desktop or Colima first." >&2
  exit 2
fi
if [[ ! -x "$SWEAGENT_BIN" ]]; then
  SWEAGENT_BIN="$(command -v sweagent 2>/dev/null || true)"
fi
if [[ -z "$SWEAGENT_BIN" || ! -x "$SWEAGENT_BIN" ]]; then
  echo "sweagent executable not found; expected the ssb-v2 Conda environment." >&2
  exit 2
fi
if ! docker image inspect "$IMAGE" >/dev/null 2>&1; then
  echo "Docker image '$IMAGE' is missing. Run scripts/setup_local.sh first." >&2
  exit 2
fi
if [[ ! -f "$DATA_ROOT/$CATEGORY/dataset.json" ]]; then
  echo "Dataset not found at $DATA_ROOT/$CATEGORY" >&2
  exit 2
fi

CONFIG="config/spreadsheet.yaml"
[[ "$CATEGORY" == "Visualization" ]] && CONFIG="config/visualisation.yaml"

mkdir -p "$RUN_DIR" "$TMPDIR"
DATASET_SHA256="$(shasum -a 256 "$DATA_ROOT/$CATEGORY/dataset.json" | awk '{print $1}')"
cat > "$RUN_DIR/run-manifest.txt" <<EOF
run_id=$RUN_ID
started_utc=$(date -u +%Y-%m-%dT%H:%M:%SZ)
model_alias=deepseek/deepseek-chat
category=$CATEGORY
workers=$WORKERS
dataset_path=$DATA_ROOT/$CATEGORY
dataset_json_sha256=$DATASET_SHA256
repository_commit=$(git -C "$ROOT_DIR" rev-parse HEAD 2>/dev/null || echo unavailable)
docker_image=$IMAGE
EOF

cd "$ROOT_DIR/SWE-agent"
set +e
"$SWEAGENT_BIN" run \
  --config "$CONFIG" \
  --env.deployment.image "$IMAGE" \
  --agent.model.name='deepseek/deepseek-chat' \
  --agent.model.api_key='$DEEPSEEK_API_KEY' \
  --output_dir "$RUN_DIR" \
  --num_workers "$WORKERS" \
  --dataset_path "$DATA_ROOT/$CATEGORY" \
  2>&1 | tee "$RUN_DIR/console.log"
exit_code=${PIPESTATUS[0]}
set -e

{
  echo "finished_utc=$(date -u +%Y-%m-%dT%H:%M:%SZ)"
  echo "exit_code=$exit_code"
  echo "trajectory_files=$(find "$RUN_DIR" -name '*.traj' -type f | wc -l | tr -d ' ')"
} >> "$RUN_DIR/run-manifest.txt"

ln -sfn "$RUN_DIR" "$TRAJECTORY_ROOT/latest-$CATEGORY"
exit "$exit_code"
