#!/bin/bash
# report.sh — خلاصه هفتگی کارخانه
psql -U monitor_ai -d project_monitor -h localhost -P pager=off -c "
SELECT s.status_code AS وضعیت, COUNT(*) AS تعداد
FROM wbs_tasks t JOIN statuses s ON t.status_id=s.status_id
WHERE t.project_id='semantic-core' AND t.is_atomic=true
GROUP BY s.status_code ORDER BY 2 DESC;"
psql -U monitor_ai -d project_monitor -h localhost -P pager=off -c "
SELECT DATE(changed_at) AS روز, COUNT(*) AS تغییرات
FROM change_log WHERE project_id='semantic-core'
GROUP BY DATE(changed_at) ORDER BY 1 DESC LIMIT 7;"
