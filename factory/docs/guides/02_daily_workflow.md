# جریان کار روزمره

## چرخه شش گامی

### گام ۱ — نمای کلی

./scripts/dashboard.sh

این دستور، آمار کلی و لیست وظایف draft را نشان می‌دهد.

### گام ۲ — انتخاب وظیفه

از خروجی dashboard، اولین وظیفه atomic با وضعیت draft را بردار. کد آن شبیه 1.1.1 یا 2.3.2 است.

### گام ۳ — اجرا

دستور verification_cmd همان وظیفه را اجرا کن.

مثال:
  psql --version
  ls -la ~/semantic_core/scripts/backup.sh

### گام ۴ — تأیید

اگر دستور تأیید موفق بود، وظیفه انجام شده.

### گام ۵ — ثبت در دیتابیس

psql -U monitor_ai -d project_monitor -h localhost -c "
UPDATE wbs_tasks
SET status_id = (SELECT status_id FROM statuses WHERE project_id='semantic-core' AND status_code='verified')
WHERE project_id='semantic-core' AND task_code='1.1.1';
"

### گام ۶ — commit در Git

git add .
git commit -m "Complete task 1.1.1: verify PostgreSQL installation"
git push

## قاعده طلایی

- یک وظیفه در هر چرخه
- قبل از شروع، وضعیت را از dashboard چک کن
- بعد از پایان، در دیتابیس و Git ثبت کن
- اگر گیر کردی، به troubleshooting برو

## چک لیست روزانه

- [ ] dashboard.sh را زدم
- [ ] یک وظیفه draft را انتخاب کردم
- [ ] verification_cmd را اجرا کردم
- [ ] وضعیت را در دیتابیس آپدیت کردم
- [ ] تغییرات را در Git پوش کردم
