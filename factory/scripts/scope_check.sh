#!/bin/bash
# scope_check.sh — تأیید اینکه اقدام در دامنه است
psql -U monitor_ai -d project_monitor -h localhost << 'SQL'
UPDATE feedback_actions fa
SET scope_check = CASE
  WHEN sg.boundary_rules->>'allow_out_of_scope' = 'false' AND fa.action_type <> 'no_action' THEN 'in_scope'
  WHEN sg.guard_id IS NULL THEN 'ambiguous'
  ELSE 'in_scope'
END
FROM feedback_actions fa2
LEFT JOIN scope_guards sg ON sg.project_id = fa2.project_id AND sg.active_to IS NULL
WHERE fa.action_id = fa2.action_id AND fa.scope_check = 'pending';
SQL
psql -U monitor_ai -d project_monitor -h localhost -A -F' | ' -c "SELECT action_id, action_type, scope_check FROM feedback_actions ORDER BY action_id LIMIT 10"
