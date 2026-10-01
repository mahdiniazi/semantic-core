# Semantic Core — هسته معنایی دانش برق خودرو

یک پایگاه دانش معنایی (semantic knowledge base) برای دامنه برق و الکترونیک خودرو، بنا شده بر پنج سند راهبردی:

1. **قانون اساسی** — چارچوب بنیادین پروژه
2. **مدل دامنه** — هستی‌شناسی (Entity, Role, Path, Signal, Context)
3. **حاکمیت دانش** — پذیرش، نسخه‌بندی و حل تعارض
4. **مدل تشخیص** — موتور استدلال تشخیصی
5. **کسب‌وکار** — مدل ترکیبی مرحله‌ای

## ساختار پروژه

semantic_core/
  db/                          دیتابیس و dumpها
    semantic_core.db           دیتابیس اصلی (SQLite)
    stable/                    نسخه‌های پایدار نسخه‌بندی‌شده
    dumps/                     dumpهای SQL
  migrations/                  اسکریپت‌های تغییر دیتابیس
    00_initial/                اسکریپت‌های ساخت اولیه
    old/                       تاریخچه (v27 تا v64)
    v65...v157.sql             migrationهای مدرن
  backups/                     بکاپ‌های دیتابیس
  snapshots/                   آرشیوهای کامل پروژه (tar.gz)
  scripts/                     ابزارهای کمکی
  docs/                        مستندات و گزارش‌ها
  .gitignore

## آمار فعلی

| مورد | تعداد |
|---|---|
| Type | 517 |
| Entity | 1,176 |
| Relation | 2,159 |
| Migration | ~190 |
| آخرین نسخه | v157_attribute_hierarchy |

## اجرا

### مشاهده محتوای دیتابیس
    sqlite3 db/semantic_core.db

### اجرای یک migration
    sqlite3 db/semantic_core.db < migrations/vXXX.sql

### ساخت بکاپ
    cp db/semantic_core.db backups/manual/semantic_core-$(date +%Y%m%d-%H%M%S).db

## نسخه‌بندی

migrationها با الگوی زیر نام‌گذاری می‌شوند:

- v27.x — فاز ۲ تا ۵ (Context, Identity, Versioning, Monitor)
- v28-v64 — گسترش دامنه (خودروها، قطعات، سیستم‌ها)
- v65-v99 — لایه‌بندی و روابط (chain, inherent, direct-part)
- v100-v139 — لایه‌های پیشرفته (health, gate, roles)
- v141-v157 — لایه ویژگی‌ها (Attribute, Unit, has_value)

## اسناد راهبردی

پنج سند راهبردی پروژه در docs/ نگهداری می‌شوند:

1. قانون اساسی
2. مدل دامنه
3. حاکمیت دانش
4. مدل تشخیص
5. کسب‌وکار

## وضعیت فعلی

- [x] لایه مدل دامنه (Attribute + Unit) پیاده‌سازی شده
- [ ] لایه حاکمیت دانش در حال ساخت
- [ ] لایه تشخیص در دست طراحی
- [ ] کسب‌وکار در مرحله برنامه‌ریزی

## مجوز

Internal project — all rights reserved.
