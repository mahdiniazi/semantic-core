#!/bin/bash
# feedback_apply.sh <action_id> — تأیید و اعمال یک اقدام
A="${1:-0}"
psql -U monitor_ai -d project_monitor -h localhost -tAc "UPDATE feedback_actions SET status='applied', applied_at=NOW() WHERE action_id=$A AND scope_check='in_scope' RETURNING action_id"
