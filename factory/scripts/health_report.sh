#!/bin/bash
PG="psql -U monitor_ai -d project_monitor -h localhost -A -F' | ' -c"
$PG "SELECT * FROM v_project_progress"
echo "---"
$PG "SELECT * FROM v_integrity_report"
echo "---"
$PG "SELECT * FROM v_feedback_summary"
