# Semantic Core — هسته معنایی دانش برق خودرو

یک پروژه دو-محصولی برای مدیریت دانش و تشخیص عیب برق خودرو.

## دو محصول

### محصول ۱ — هسته معنایی خودرو
دیتابیس SQLite با ۵۱۷ نوع، ۱٬۱۷۶ موجودیت، و ۲٬۱۵۹ رابطه.
محل: db/semantic_core.db
مستند: product/README.md

### محصول ۲ — کارخانه مدیریت پروژه
دیتابیس PostgreSQL با ۵۵۱ گزاره اتمی، ۸۷ وظیفه WBS، ۳ View.
محل: PostgreSQL server — project_monitor
مستند: factory/README.md

## شروع سریع

برای دیدن وضعیت پروژه:

    ./scripts/dashboard.sh

برای دیدن نقشه راه:

    ./scripts/roadmap.sh

برای کار با پروژه، اول این را بخوان:

    AI_HANDOFF.md

## ساختار

    product/      — محصول اول
    factory/      — محصول دوم
    schema/       — طرحواره PostgreSQL
    migrations/   — تغییرات SQLite
    scripts/      — ابزارهای اجرایی
    docs/
      ├── strategic/   — پنج سند راهبردی HTML
      ├── guides/      — چهار راهنمای کاربری
      └── reference/   — سه مرجع فنی

## پنج سند راهبردی

در docs/strategic/:

1. قانون اساسی (v5.0)
2. مدل دامنه (v2.0)
3. حاکمیت دانش (v2.0)
4. مدل تشخیص (v2.0)
5. کسب‌وکار (v2.0)

## مستندات

- AI_HANDOFF.md — راهنمای AI (نقطه ورود)
- docs/guides/ — شروع، جریان کار، محصول جدید، حل مشکلات
- docs/reference/ — طرحواره، اسکریپت‌ها، ادغام AI
- product/README.md — محصول اول
- factory/README.md — محصول دوم

## مخزن

github.com/mahdiniazi/semantic-core
