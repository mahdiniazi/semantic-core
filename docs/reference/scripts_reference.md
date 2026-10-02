# مرجع اسکریپت‌های اجرایی

## scripts/dashboard.sh

نمای کلی پروژه در یک نگاه.

خروجی:
- شمارش گزاره‌ها و وظایف به تفکیک وضعیت
- لیست ۲۰ وظیفه draft اول
- راهنمای سریع

استفاده:
  ./scripts/dashboard.sh

## scripts/roadmap.sh

لیست گزاره‌های فعال و draft.

خروجی:
- کد گزاره
- وضعیت
- متن گزاره

استفاده:
  ./scripts/roadmap.sh

## scripts/task.sh

مدیریت وضعیت گزاره‌ها و وظایف.

استفاده:
  ./scripts/task.sh stats               — آمار کلی
  ./scripts/task.sh done CODE           — علامت‌گذاری انجام‌شده
  ./scripts/task.sh active CODE         — بازگرداندن به فعال
  ./scripts/task.sh add CODE "متن" type — افزودن گزاره جدید

مثال:
  ./scripts/task.sh stats
  ./scripts/task.sh done T-001

## scripts/backup.sh

بکاپ از دیتابیس محصول.

استفاده:
  ./scripts/backup.sh                — بکاپ پیش‌فرض
  ./scripts/backup.sh daily          — بکاپ روزانه
  ./scripts/backup.sh milestone "توضیح" — بکاپ نقطه‌عطف

خروجی:
- فایل .db در backups/
- بررسی سلامت با integrity_check
- گزارش اندازه و آمار

## scripts/migrate.sh

اجرای یک migration روی دیتابیس محصول.

استفاده:
  ./scripts/migrate.sh migrations/vNNN.sql
  ./scripts/migrate.sh migrations/vNNN.sql --no-backup
  ./scripts/migrate.sh migrations/vNNN.sql --dry-run

قابلیت‌ها:
- بکاپ خودکار قبل از اجرا
- حالت dry-run برای بررسی
- گزارش آمار پس از اجرا

## scripts/audit.sh

بازرسی دیتابیس محصول.

خروجی:
- بررسی سلامت جداول
- گزارش آنومالی
- بررسی ارجاعات

## اسکریپت‌های آینده

- search.sh — جستجوی معنایی در گزاره‌ها
- report.sh — خلاصه هفتگی
- restore.sh — بازگرداندن از بکاپ
