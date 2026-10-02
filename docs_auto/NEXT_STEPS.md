# گام‌های بعدی — پیشنهادی برای AI بعدی

## اولویت ۱ (فوری)
- خواندن `ai_clues` — 11 نسک ثبت‌شده
- اجرای `handoff.sh` برای وضعیت کامل
- بررسی `v_project_progress` هر دو پروژه

## اولویت ۲ (کوتاه‌مدت)
- پردازش 42 reltype صفر (v163 با نمونه‌های واقعی)
- افزودن README نسخه‌دار به محصولات در پوشه‌های اصلی
- ساخت widget برای همه 13 صفحه SQLPage

## اولویت ۳ (میان‌مدت)
- پروژه سوم با همان الگو
- تعمیق SC: chain کامل P0301 + DTC های بیشتر
- Multi-tenant check

## الگوهای موفق قابل تکرار
- 5 فاز → 1 commit + tag
- check_task.sh با rule per code
- capture_feedback → analyze → propose → apply
- capture_clue برای نکات بین AI ها
