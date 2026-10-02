# محصول ۲ — کارخانه مدیریت پروژه

## این محصول چیست

یک پایگاه داده مدیریتی که همه محصولات نرم‌افزاری را در یک ساختار مشترک نگه می‌دارد. هر محصول، یک سطر در جدول projects است و با project_id از بقیه جدا می‌شود.

هدف: بدون ساختن دیتابیس جدید برای هر محصول، همه پروژه‌ها در یک جا مدیریت شوند.

## محل فیزیکی

- دیتابیس: PostgreSQL server — project_monitor
- کاربر: monitor_ai
- طرحواره: ../schema/*.sql

## جدول‌های اصلی

- projects — فهرست همه محصولات
- atomic_propositions — گزاره‌های اتمی هر محصول
- wbs_tasks — وظایف شکست‌کار (WBS)
- sources — منابع گزاره‌ها
- scopes — دامنه اعتبار
- statuses — وضعیت‌ها
- proposition_task_link — اتصال گزاره به وظیفه
- change_log — تاریخچه تغییرات

## Viewهای آماده

- ai_roadmap — لیست گزاره‌های فعال هر پروژه
- v_ai_roadmap_full — گزاره‌ها + وظایف مرتبط
- v_ai_dashboard — آمار به تفکیک وضعیت

## چطور به دیتابیس وصل شویم

psql -U monitor_ai -d project_monitor -h localhost

پسورد در ~/.pgpass ذخیره شده.

## چطور محصول جدید بسازیم

فقط یک سطر به جدول projects اضافه کن. همه گزاره‌ها و وظایف آن محصول با همان project_id در همان جداول مشترک درج می‌شوند.

## چطور از صفر بسازیم

psql -U monitor_ai -d project_monitor -h localhost -f ../schema/bootstrap.sql

## فایل‌های طرحواره

- bootstrap.sql — بازسازی کامل
- 02_constitution_props.sql — ۸۱ گزاره قانون اساسی
- 03_domain_props.sql — ۱۰۵ گزاره مدل دامنه
- 04_governance_props.sql — ۱۲۰ گزاره حاکمیت دانش
- 05_diagnostic_props.sql — ۱۳۰ گزاره مدل تشخیص
- 05b_diagnostic_remaining.sql — ۳۰ گزاره باقیمانده
- 06_business_props.sql — ۷۵ گزاره کسب‌وکار
- 07_task_link.sql — جدول اتصال گزاره-وظیفه
- 07b_wbs_l1.sql — WBS سطح ۱ و ۲
- 07c_wbs_l3.sql — ۶۳ وظیفه اتمی
- 08_prop_task_links.sql — ۴۵ لینک گزاره-وظیفه
- 09_ai_final_view.sql — Viewهای نهایی

## وضعیت فعلی

- ۵۵۱ گزاره اتمی
- ۸۷ وظیفه WBS
- ۴۵ لینک گزاره-وظیفه
- ۳ View

## اسکریپت‌های مرتبط

- ../scripts/dashboard.sh — نمای کلی
- ../scripts/roadmap.sh — لیست گزاره‌های فعال
- ../scripts/task.sh stats — آمار

## منابع مرتبط

- ../AI_HANDOFF.md — راهنمای کار با AI
- ../product/README.md — محصول اول (هسته خودرو)
- ../docs/reference/database_schema.md — مرجع کامل طرحواره
