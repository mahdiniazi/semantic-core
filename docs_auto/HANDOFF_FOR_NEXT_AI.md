# HANDOFF — برای AI بعدی

نسخه: v1.4.0
تاریخ: 2026-10-02

## خلاصه یک‌خطی
پروژه Semantic Core = کارخانه‌ی نرم‌افزارسازی که با WBS + AI + فیدبک،
دو محصول (SC و WM) را ساخته، با 16 قانون حاکمیت، 15 صفحه وب، 6 tag.

## شروع سریع — ۵ دستور
1. bash ~/semantic_core/factory/scripts/welcome.sh
2. bash ~/semantic_core/factory/scripts/handoff.sh
3. cat ~/semantic_core/factory/AI_HANDOFF.md
4. bash ~/semantic_core/factory/scripts/doctor.sh
5. bash ~/semantic_core/factory/scripts/cycle.sh

## ساختار
- ~/semantic_core/factory/         — کارخانه (PostgreSQL project_monitor)
- ~/semantic_core/products/semantic_core/    — محصول ۱
- ~/semantic_core/products/workshop_manager/ — محصول ۲
- ~/semantic_core/docs_auto/       — اسناد خودکار
- Git tags: v1.0.0 → v1.4.0

## نسک‌های کلیدی
SELECT * FROM v_clues_open;
11 نسک باز در ai_clues

## ویجت‌ها (localhost:8080)
- /clues.sql    — نسک‌ها برای AI بعدی (اول این)
- /widgets.sql  — فهرست کامل 13 ویجت
- /projects.sql — وضعیت پروژه‌ها
- /feedback.sql — رخدادهای فیدبک
- /integrity.sql — یکپارچگی

## 16 قانون
11 قانون قدیم + 12 (integrity) + 13 (reuse)
+ 14 (widget) + 15 (readme) + 16 (clue)
متن کامل: factory/AI_HANDOFF.md بخش 12-14

## زیرسیستم‌های فعال
- Feedback (Law 11): 5 جدول، 4 applied
- Clue System (Law 16): ai_clues، 11 نسک
- Auto-Doc (Law 15): 4 README نسخه‌دار
- Widget Registry (Law 14): 13 widget
- AI Handoff (Law 16): ai_handoff_log، 2 handoff

## نکات مهم
- git log با --no-pager
- SQLPage با DATABASE_URL env (نه sqlpage.json)
- هر تغییر: بکاپ + integrity_check (قانون 12)
- اگر جدول هست، بازاستفاده کن (قانون 13)
- هر فاز = 1 commit + tag

## وضعیت
- SC: 66/66 verified (100%)
- WM: 26/26 verified (100%)
- 6 tag منتشر شده
- 0 FK orphans

## لینک‌های مرتبط
- GitHub: github.com/mahdiniazi/semantic-core
- SQLPage: http://localhost:8080
- PostgreSQL: monitor_ai@localhost/project_monitor
