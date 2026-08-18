#!/usr/bin/env bash
set -u

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
RUN_ID="${1:?usage: monitor_full_run.sh RUN_ID [INTERVAL_SECONDS]}"
INTERVAL="${2:-300}"
RUN_ROOT="$ROOT_DIR/trajectories/deepseek-chat/$RUN_ID"
OUTPUT_ROOT="$ROOT_DIR/SWE-agent/trajectories/output_excel"
LOG_DIR="$ROOT_DIR/trajectories/deepseek-chat/full-run"
STATUS_LOG="$LOG_DIR/$RUN_ID-monitor-v2.csv"

mkdir -p "$LOG_DIR"
if [[ ! -f "$STATUS_LOG" ]]; then
  echo 'timestamp_utc,state,trajectory_files,submitted,free_gib,current_category' > "$STATUS_LOG"
fi

while true; do
  timestamp="$(date -u +%Y-%m-%dT%H:%M:%SZ)"
  trajectories="$(find "$RUN_ROOT" -type f -name '*.traj' 2>/dev/null | wc -l | tr -d ' ')"
  submitted="$(find "$OUTPUT_ROOT" -type f -name '*_output.xlsx' 2>/dev/null | wc -l | tr -d ' ')"
  free_kib="$(df -Pk /System/Volumes/Data | awk 'NR==2 {print $4}')"
  free_gib="$(awk -v kib="$free_kib" 'BEGIN {printf "%.2f", kib/1024/1024}')"
  current_category="$(find "$RUN_ROOT" -mindepth 1 -maxdepth 1 -type d ! -name failed-attempts -print 2>/dev/null | sort | tail -1 | xargs basename 2>/dev/null || true)"

  if pgrep -f 'bootstrap_and_run_all.sh' >/dev/null 2>&1; then
    state=running
  else
    state=stopped
  fi
  if (( free_kib < 8 * 1024 * 1024 )); then
    state="${state}_disk_warning"
  fi

  echo "$timestamp,$state,$trajectories,$submitted,$free_gib,$current_category" >> "$STATUS_LOG"
  [[ "$state" == stopped ]] && exit 0
  sleep "$INTERVAL"
done
