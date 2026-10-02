# Semantic Workspace

این یک Workspace است که شامل کارخانه و محصولات می‌شود.

## ساختار

    factory/                   — کارخانه (مدیریت همه محصولات)
      AI_HANDOFF.md           — راهنمای AI
      CHANGELOG.md
      README.md
      schema/                 — طرح‌واره PostgreSQL
      scripts/                — dashboard, roadmap, task, search
      web/                    — پنل وب SQLPage
      docs/
        guides/
        reference/
        audits/
        logs/

    products/                  — محصولات
      semantic_core/          — محصول ۱: پایگاه دانش خودرو
        README.md
        db/                   — semantic_core.db (SQLite)
        migrations/
        backups/
        snapshots/
        scripts/              — backup, migrate, audit, run
        docs/
          strategic/          — پنج سند راهبردی HTML

## کارخانه

کارخانه، همه محصولات را در یک دیتابیس PostgreSQL به نام project_monitor مدیریت می‌کند.

- ۵۵۱ گزاره اتمی
- ۸۷ وظیفه WBS
- ۴۵ لینک گزاره-وظیفه
- ۳ View آماده

مستندات: factory/README.md و factory/AI_HANDOFF.md

## محصول ۱ — هسته معنایی خودرو

پایگاه دانش خودرو با ۵۱۷ نوع، ۱۱۷۶ موجودیت، ۲۱۶۰ رابطه.

مستندات: products/semantic_core/README.md و products/semantic_core/docs/strategic/

## شروع سریع

وضعیت کلی کارخانه:

    ~/semantic_core/factory/scripts/dashboard.sh

نقشه راه پروژه:

    ~/semantic_core/factory/scripts/roadmap.sh

بکاپ محصول:

    ~/semantic_core/products/semantic_core/scripts/backup.sh

## پنج سند راهبردی محصول

در products/semantic_core/docs/strategic/:

1. قانون اساسی
2. مدل دامنه
3. حاکمیت دانش
4. مدل تشخیص
5. کسب‌وکار

## مخزن

github.com/mahdiniazi/semantic-core
