#!/bin/bash
# feedback_reject.sh <action_id> — رد یک اقدام با دلیل
A="${1:-0}"; R="${2:-no reason}"
psql -U monitor_ai -d project_monitor -h localhost -tAc "UPDATE feedback_actions SET status='rejected', rationale=rationale||' | REJECTED: $R' WHERE action_id=$A RETURNING action_id"
