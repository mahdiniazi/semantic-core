# راهنمای شروع

## در ۵ دقیقه اول چه کار کنیم؟

### ۱. نمای کلی پروژه را ببین

cd ~/semantic_core
./scripts/dashboard.sh

### ۲. ساختار پروژه را بشناس

product/      — محصول اول (هسته خودرو، SQLite)
factory/      — محصول دوم (کارخانه، PostgreSQL)
schema/       — طرحواره‌های کارخانه
migrations/   — تغییرات دیتابیس محصول
scripts/      — ابزارهای اجرایی
docs/         — مستندات

### ۳. وضعیت دیتابیس کارخانه

psql -U monitor_ai -d project_monitor -h localhost -c "\dt"

### ۴. اولین کار

اولین وظیفه draft را از dashboard.sh بردار و انجام بده.

## دو دیتابیس، دو نقش

- semantic_core (SQLite) — خودِ محصول
- project_monitor (PostgreSQL) — کارخانه ساخت

هرگز این دو را قاطی نکن.

## اگر مشکلی پیش آمد

به docs/guides/04_troubleshooting.md مراجعه کن.
