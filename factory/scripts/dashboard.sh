#!/bin/bash
# dashboard.sh — نمای کلی وضعیت پروژه

echo "═══════════════════════════════════════════════════"
echo "  Project: semantic-core"
echo "═══════════════════════════════════════════════════"
echo ""

echo "📊 شمارش کلی:"
psql -U monitor_ai -d project_monitor -h localhost -P pager=off -c "
SELECT entity AS نوع, status_code AS وضعیت, n AS تعداد
FROM v_ai_dashboard
ORDER BY entity, status_code;
"

echo ""
echo "📋 وظایف اتمی آماده برای اجرا (draft):"
psql -U monitor_ai -d project_monitor -h localhost -P pager=off -c "
SELECT task_code AS کد, task_name AS وظیفه, verification_cmd AS تأیید
FROM wbs_tasks wt
JOIN statuses st ON wt.status_id = st.status_id
WHERE wt.project_id='semantic-core'
  AND wt.is_atomic = TRUE
  AND st.status_code = 'draft'
ORDER BY task_code
LIMIT 20;
"

echo ""
echo "💡 راهنما:"
echo "  ./scripts/roadmap.sh         — لیست گزاره‌های فعال"
echo "  ./scripts/task.sh stats      — آمار"
echo "  ./scripts/task.sh done CODE  — علامت‌گذاری انجام‌شده"
