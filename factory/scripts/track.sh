#!/bin/bash
PG="psql -U monitor_ai -d project_monitor -h localhost -A -F' | ' -c"
LOG=~/semantic_core/factory/docs/logs/progress_$(date +%Y%m%d).log
mkdir -p $(dirname $LOG)
{ echo "=== $(date '+%Y-%m-%d %H:%M') ==="
  $PG "SELECT t.project_id, s.status_code, COUNT(*) FROM wbs_tasks t JOIN statuses s ON t.status_id=s.status_id WHERE t.is_atomic=true GROUP BY t.project_id, s.status_code ORDER BY project_id, status_code"
} >> $LOG
tail -10 $LOG
