# ساخت محصول جدید

## هدف

افزودن یک محصول نرم‌افزاری جدید به کارخانه، بدون ساختن دیتابیس جدید.

## گام ۱ — افزودن سطر در جدول projects

psql -U monitor_ai -d project_monitor -h localhost -c "
INSERT INTO projects (project_id, display_name, description, repo_url)
VALUES ('product-2', 'نام محصول دوم', 'توضیح کوتاه', 'https://github.com/...');
"

## گام ۲ — افزودن وضعیت‌های پایه

psql -U monitor_ai -d project_monitor -h localhost -c "
INSERT INTO statuses (project_id, status_code, label, is_terminal) VALUES
('product-2', 'draft', 'پیش‌نویس', FALSE),
('product-2', 'active', 'فعال', FALSE),
('product-2', 'verified', 'تأییدشده', TRUE),
('product-2', 'deprecated', 'منسوخ', TRUE);
"

## گام ۳ — افزودن منابع

منابع، همان اسناد راهبردی محصول جدید است.

psql -U monitor_ai -d project_monitor -h localhost -c "
INSERT INTO sources (project_id, source_type, source_ref, confidence)
VALUES ('product-2', 'constitution', 'PRINCIPLE-01', 1.00);
"

## گام ۴ — افزودن گزاره‌های اتمی

از اسناد راهبردی محصول، گزاره‌های تک‌جمله‌ای استخراج کن و درج کن.

## گام ۵ — افزودن WBS

ساختار شکست کار را در سه سطح بساز:

- سطح ۱: فازهای اصلی
- سطح ۲: زیرفازها
- سطح ۳: وظایف اتمی

## گام ۶ — اتصال گزاره‌ها به وظایف

از جدول proposition_task_link استفاده کن.

## قاعده طلایی

هر محصول، فقط یک سطر در projects است. بقیه چیزها با project_id به آن وصل می‌شوند.
