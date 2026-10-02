# حل مشکلات رایج

## ۱. اتصال به PostgreSQL برقرار نمی‌شود

اگر خطای password authentication دیدی:

psql -U monitor_ai -d project_monitor -h localhost -c "SELECT 1;"

اگر پسورد خواست، بررسی کن که ~/.pgpass وجود دارد:

cat ~/.pgpass

اگر نیست، بساز:

echo "localhost:5432:*:monitor_ai:monitor_secure_1405" > ~/.pgpass
chmod 600 ~/.pgpass

## ۲. جدول یا view وجود ندارد

اگر خطای relation does not exist دیدی، طرحواره را از صفر بساز:

sudo -u postgres psql -c "DROP DATABASE project_monitor;"
sudo -u postgres psql -c "CREATE DATABASE project_monitor OWNER monitor_ai;"
sudo -u postgres psql -d project_monitor -c "ALTER SCHEMA public OWNER TO monitor_ai;"
psql -U monitor_ai -d project_monitor -h localhost -f ~/semantic_core/schema/bootstrap.sql

## ۳. خطای duplicate key در گزاره‌ها

اگر روی گزاره‌های تکراری خطا خورد، بی‌خطر است. چون فایل‌ها با ON CONFLICT DO NOTHING نوشته شده‌اند.

## ۴. پایگاه داده کار نمی‌کند

بررسی کن که سرویس PostgreSQL اجرا می‌شود:

sudo systemctl status postgresql

اگر متوقف بود:

sudo systemctl start postgresql

## ۵. اسکریپت اجرا نمی‌شود

اگر permission denied دیدی:

chmod +x ~/semantic_core/scripts/*.sh

## ۶. ترمینال در heredoc گیر کرده

اگر prompt به shape heredoc> یا bquote> تغییر کرد:

Ctrl+C را سه بار بزن، سپس clear.

## ۷. فایل ساخته نمی‌شود

اگر heredoc کار نکرد، از nano استفاده کن:

nano /path/to/file.md

## ۸. Git push رد می‌شود

اگر خطای rejected دیدی:

git pull --rebase origin main
git push

## ۹. فایل .db در Git commit شده

اگر اشتباها commit شد:

git rm --cached path/to/file.db
echo "path/to/file.db" >> .gitignore
git commit -m "Remove accidentally committed db file"

## ۱۰. چه کسی را صدا بزنم؟

اگر هیچ‌کدام از این راه‌حل‌ها کار نکرد، در AI_HANDOFF.md به بخش «اگر سؤالی داری» مراجعه کن.
