# Semantic Core v1.0.0 — هسته معنایی برق خودرو

## وضعیت
- **تگ:** v1.0.0
- **تاریخ:** 1405/07/10
- **۵ فاز:** زیرساخت، مدل دامنه، حاکمیت دانش، موتور تشخیص، کسب‌وکار
- **۸۷ تسک:** ۶۳ اتمی + ۲۴ غیراتمی — همه verified

## محتوا
- 526 نوع | 1179 موجودیت | 2160 رابطه
- 3 Claim + 3 Evidence + 1 Hypothesis + 1 Episode
- 20 Attribute + 26 Unit
- 21 View | 125 Trigger | 164 Migration

## معماری
- **محصول:** SQLite در `products/semantic_core/db/semantic_core.db`
- **کارخانه:** PostgreSQL در `project_monitor` (8 جدول)
- **API:** `products/semantic_core/api/server.py` — localhost:8888
- **Webhook:** `products/semantic_core/api/webhook.py` — localhost:8889

## منابع
- AI_HANDOFF.md — قانون اساسی پروژه
- factory/CHANGELOG.md — تاریخ نسخه‌ها
- factory/scripts/dashboard.sh — داشبورد
