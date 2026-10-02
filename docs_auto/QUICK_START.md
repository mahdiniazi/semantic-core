# QUICK START — 5 گام برای AI بعدی

نسخه: v1.4.0

## گام 1: پیام خوشامد
bash ~/semantic_core/factory/scripts/welcome.sh

## گام 2: دیدن نسک‌ها
psql -U monitor_ai -d project_monitor -h localhost -c "SELECT * FROM v_clues_open"

## گام 3: وضعیت کامل
bash ~/semantic_core/factory/scripts/handoff.sh

## گام 4: بررسی سلامت
bash ~/semantic_core/factory/scripts/doctor.sh

## گام 5: آماده کار
- باز کردن: http://localhost:8080
- دیدن تسک‌ها: SELECT * FROM v_project_progress;
- خواندن: ~/semantic_core/factory/AI_HANDOFF.md

## در صورت ابهام
- bash ~/semantic_core/factory/scripts/widgets.sh  (فهرست ویجت‌ها)
- http://localhost:8080/clues.sql  (نسک‌های باز)

## MCP فعال — Continue
1. API key: docs_auto/GET_API_KEY.md
2. Config: bash factory/scripts/setup_continue.sh
3. VS Code: F1 → Continue: Focus on Continue View
