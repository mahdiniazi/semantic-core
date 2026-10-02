# Semantic Core — v1.3.0

## وضعیت
- 2 پروژه فعال: semantic-core + workshop-manager
- 131 تسک verified (63+44 SC، 25+19 WM)
- زیرسیستم فیدبک فعال: 5 جدول + 9 اسکریپت + 12 صفحه وب + 3 cron
- 5 View یکپارچه جدید
- 7 FK یتیم رفع شد (v161)
- قوانین ۱۲ و ۱۳ فعال

## معماری یکپارچه
- PostgreSQL `project_monitor` — کارخانه
- SQLite `semantic_core.db` — محصول ۱
- SQLite `workshop.db` — محصول ۲
- SQLPage `http://localhost:8080` — داشبورد وب

## Views جدید
- v_project_progress: پیشرفت هر پروژه
- v_task_health: سلامت هر تسک
- v_feedback_summary: خلاصه فیدبک
- v_unified_timeline: تایم‌لاین رخدادها
- v_scope_with_guard: scope+guard

## Tags
- v1.0.0 — پایه SC
- v1.1.0 — systemd + cron + workshop scripts
- v1.2.0 — feedback subsystem
- v1.3.0 — قانون ۱۲+۱۳ + view یکپارچه + FK رفع
