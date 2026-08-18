#!/usr/bin/env bash
set -u

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
JOB_NAME="${1:-real-deepseek-full}"
INTERVAL="${2:-60}"
RESULT="$ROOT/jobs/$JOB_NAME/result.json"
STATUS="$ROOT/reports/$JOB_NAME-monitor.csv"

mkdir -p "$ROOT/reports"
if [[ ! -f "$STATUS" ]]; then
  echo 'timestamp_utc,state,completed,running,pending,errors,mean,free_gib' > "$STATUS"
fi

while true; do
  timestamp="$(date -u +%Y-%m-%dT%H:%M:%SZ)"
  if pgrep -f "harbor run.*--job-name $JOB_NAME" >/dev/null 2>&1; then state=running; else state=stopped; fi
  if [[ -f "$RESULT" ]]; then
    completed="$(jq -r '.stats.n_completed_trials // 0' "$RESULT")"
    running="$(jq -r '.stats.n_running_trials // 0' "$RESULT")"
    pending="$(jq -r '.stats.n_pending_trials // 0' "$RESULT")"
    errors="$(jq -r '.stats.n_errored_trials // 0' "$RESULT")"
    mean="$(jq -r '[.stats.evals[].metrics[]?.mean] | if length then add/length else "" end' "$RESULT")"
  else
    completed=0; running=0; pending=0; errors=0; mean=""
  fi
  free_gib="$(df -Pk /System/Volumes/Data | awk 'NR==2 {printf "%.2f", $4/1024/1024}')"
  echo "$timestamp,$state,$completed,$running,$pending,$errors,$mean,$free_gib" >> "$STATUS"
  [[ "$state" == stopped && "$completed" -gt 0 ]] && exit 0
  sleep "$INTERVAL"
done
