#!/usr/bin/env bash
set -u
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
RUN="$ROOT/trajectories/deepseek-chat/full-20260816T032000Z"
printf 'timestamp=%s\n' "$(date -u +%Y-%m-%dT%H:%M:%SZ)"
if pgrep -f 'sweagent run.*full-20260816T032000Z' >/dev/null; then echo 'state=running'; else echo 'state=stopped'; fi
printf 'trajectories=%s\n' "$(find "$RUN" -name '*.traj' -type f 2>/dev/null | wc -l | tr -d ' ')"
printf 'submitted=%s\n' "$(find "$ROOT/SWE-agent/trajectories/output_excel" -name '*_output.xlsx' -type f 2>/dev/null | wc -l | tr -d ' ')"
printf 'free_gib=%s\n' "$(df -Pk /System/Volumes/Data | awk 'NR==2 {printf "%.2f", $4/1024/1024}')"
