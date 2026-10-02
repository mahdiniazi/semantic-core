#!/bin/bash
# propose_actions.sh — تبدیل الگوها به اقدام
psql -U monitor_ai -d project_monitor -h localhost << 'SQL'
INSERT INTO feedback_actions (pattern_id, project_id, action_type, proposed_change, rationale)
SELECT pattern_id, project_id,
       CASE severity_avg
         WHEN 'critical' THEN 'fix_schema'
         WHEN 'warn' THEN 'new_task'
         ELSE 'no_action'
       END,
       'رسیدگی به الگو: ' || description,
       'الگو با ' || occurrences || ' رخداد در ۳۰ روز'
FROM feedback_patterns
WHERE NOT EXISTS (SELECT 1 FROM feedback_actions WHERE feedback_actions.pattern_id = feedback_patterns.pattern_id);
SQL
psql -U monitor_ai -d project_monitor -h localhost -A -F' | ' -c "SELECT action_id, action_type, status, scope_check FROM feedback_actions ORDER BY proposed_at DESC LIMIT 5"
