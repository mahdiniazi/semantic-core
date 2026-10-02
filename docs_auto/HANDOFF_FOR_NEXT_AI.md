# HANDOFF — برای AI بعدی
نسخه: v1.4.0 | تاریخ: $(date '+%Y-%m-%d %H:%M')

## 🎯 خلاصه یک‌خطی
پروژه‌ی Semantic Core = کارخانه‌ی نرم‌افزارسازی که با WBS + AI + فیدبک،
دو محصول (SC و WM) را ساخته، با 16 قانون حاکمیت، 13 صفحه وب، 5 tag.

## 🚀 شروع سریع (۵ دستور)


## 📂 ساختار
- `~/semantic_core/factory/` — کارخانه (PostgreSQL project_monitor)
- `~/semantic_core/products/semantic_core/` — محصول 1
- `~/semantic_core/products/workshop_manager/` — محصول 2
- `~/semantic_core/docs_auto/` — اسناد خودکار
- Git tags: v1.0.0 → v1.4.0

## 🧠 نسک‌های کلیدی (ai_clues)

## 🎨 ویجت‌ها
- `/clues.sql` — نسک‌ها برای AI بعدی (اول این را بخوان)
- `/widgets.sql` — فهرست کامل
- 13 صفحه SQLPage فعال روی localhost:8080

## 📜 16 قانون
11 قانون قدیم + 12 (integrity) + 13 (reuse) + 14 (widget) + 15 (readme) + 16 (clue)
متن کامل: `factory/AI_HANDOFF.md` بخش 12-14

## ⚙️ فیدبک
`capture_feedback.sh` → `analyze` → `propose` → `apply`
+cron روزانه cycle.sh

## 🧩 Clue System
`capture_clue.sh <project> <type> <severity> <title> <body>`
جدول: `ai_clues` (11 نسک باز)

## ⚠️ نکات مهم
- git log با `--no-pager` بزن
- SQLPage با `DATABASE_URL` env
- هر تغییر: بکاپ + integrity_check (قانون 12)
- اگر جدول از قبل هست، بازاستفاده کن (قانون 13)
- هر فاز = 1 commit + tag

## 📊 وضعیت
- SC: 66/66 verified (100%)
- WM: 26/26 verified (100%)
- 5 tag منتشر شده
- 0 FK orphans

## 🔗 لینک‌های مرتبط
- GitHub: github.com/mahdiniazi/semantic-core
- SQLPage: http://localhost:8080
- PostgreSQL: monitor_ai@localhost/project_monitor
