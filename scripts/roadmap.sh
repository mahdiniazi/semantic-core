#!/bin/bash
# roadmap.sh — چاپ نقشه راه پروژه از دیتابیس project_monitor
# استفاده: ./scripts/roadmap.sh
# خروجی را کپی کن و به AI چت بده

psql -U monitor_ai -d project_monitor -h localhost -P pager=off -c "
SELECT
    prop_code AS کد,
    status_code AS وضعیت,
    proposition AS گزاره
FROM ai_roadmap
ORDER BY prop_code;
"
