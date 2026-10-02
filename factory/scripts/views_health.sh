#!/bin/bash
PG="psql -U monitor_ai -d project_monitor -h localhost -tAc"
for v in v_project_progress v_task_health v_feedback_summary v_unified_timeline v_scope_with_guard; do
  echo "$v: $($PG "SELECT COUNT(*) FROM $v") rows"
done
