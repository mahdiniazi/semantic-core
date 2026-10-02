# گام‌های بعدی — پیشنهادی برای AI بعدی

نسخه: v1.4.0

## اولویت ۱ (فوری)
- خواندن ai_clues (11 نسک)
- اجرای handoff.sh
- بررسی v_project_progress

## اولویت ۲ (کوتاه‌مدت)
- پردازش 42 reltype صفر (v163/v164)
- افزودن README نسخه‌دار به پوشه‌های اصلی محصولات
- widget برای همه صفحات (13 → 20)

## اولویت ۳ (میان‌مدت)
- پروژه سوم (اثبات کامل عمومیت)
- تعمیق SC: chain کامل P0301 + DTC بیشتر
- Multi-tenant check

## الگوهای موفق قابل تکرار
- 5 فاز → 1 commit + tag
- check_task.sh با rule per code
- capture_feedback → analyze → propose → apply
- capture_clue برای نکات بین AI ها
- welcome.sh در ابتدای هر گفتگو
