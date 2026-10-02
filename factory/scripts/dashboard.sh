#!/bin/bash
# dashboard.sh — نمای کلی کارخانه
echo "═══ کارخانه ═══"
psql -U monitor_ai -d project_monitor -h localhost -P pager=off -c "
SELECT p.display_name AS پروژه,
  (SELECT COUNT(*) FROM atomic_propositions WHERE project_id=p.project_id) AS گزاره,
  (SELECT COUNT(*) FROM wbs_tasks WHERE project_id=p.project_id) AS تسک,
  (SELECT COUNT(*) FROM wbs_tasks t JOIN statuses s ON t.status_id=s.status_id WHERE t.project_id=p.project_id AND s.is_terminal=true) AS تمام
FROM projects p WHERE p.enabled=true;"
echo ""
echo "═══ تغییرات اخیر ═══"
psql -U monitor_ai -d project_monitor -h localhost -P pager=off -c "
SELECT entity_type, entity_id, field_changed, new_value, changed_at
FROM change_log ORDER BY changed_at DESC LIMIT 10;"
