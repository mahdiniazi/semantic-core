# زیرسیستم فیدبک از اجرا به طراحی (قانون ۱۱)

## چرخه
execution → events → patterns → actions → design

## جداول
- feedback_events: رخداد خام
- feedback_patterns: الگوهای تجمیعی
- feedback_actions: اقدامات اصلاحی
- mirror_reviews: آینه‌نگری دوره‌ای
- scope_guards: نگهبان دامنه

## اسکریپت‌ها
- capture_feedback.sh: ثبت رخداد
- analyze_feedback.sh: تجمیع
- propose_actions.sh: پیشنهاد
- scope_check.sh: تأیید دامنه
- feedback_apply.sh / feedback_reject.sh: اعمال/رد
- mirror_review.sh / weekly_mirror.sh: آینه‌نگری
- cycle.sh: چرخه کامل
- feedback_report.sh: گزارش

## صفحات وب
- /feedback.sql /patterns.sql /actions.sql /mirror.sql

## قوانین
- ۳ فاز آینده بیشینه
- بدون out_of_scope
- بدون ساده‌سازی به‌جای بهینه‌سازی
- آینه‌نگری الزامی در هر بازنگری
