# محصول ۱ — هسته معنایی برق خودرو

## این محصول چیست

یک پایگاه دانش معنایی که دانش فنی برق خودرو را سازمان‌دهی می‌کند. هدف: هم انسان و هم نرم‌افزار بتوانند درباره خودرو بدون ابهام صحبت کنند.

## محل فیزیکی

- دیتابیس: ../db/semantic_core.db (SQLite)
- migrationها: ../migrations/
- بکاپ‌ها: ../backups/

## ساختار دیتابیس

سه لایه اصلی:

1. Types — سلسله‌مراتب انواع با parent_id
2. Entities — موجودیت‌های مشخص با ent_uid، type_id، nature
3. Relations — روابط در جدول e01_222_01_tb

## پنج سند راهبردی

در ../docs/strategic/:

1. قانون اساسی (01_constitution.html)
2. مدل دامنه (02_domain_model.html)
3. حاکمیت دانش (03_knowledge_governance.html)
4. مدل تشخیص (04_diagnostic_model.html)
5. کسب‌وکار (05_business_plan.html)

## وضعیت فعلی

- ۵۱۷ Type
- ۱٬۱۷۶ Entity
- ۲٬۱۵۹ Relation
- ۲۰ ویژگی (Attribute)
- ۲۶ واحد (Unit)
- ۱۶ رابطه has_unit
- ۳۳ رابطه applies_to

## چطور کار کنیم

بکاپ:
  ../scripts/backup.sh

اجرای migration جدید:
  ../scripts/migrate.sh ../migrations/vNNN_*.sql

بررسی سریع:
  sqlite3 ../db/semantic_core.db "SELECT COUNT(*) FROM e01_200_03_tb;"

## منابع مرتبط

- ../AI_HANDOFF.md — راهنمای کار با AI
- ../factory/README.md — کارخانه ساخت این محصول
- ../docs/strategic/ — پنج سند راهبردی
