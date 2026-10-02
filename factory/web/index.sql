SELECT 'shell' AS component, 'کارخانه معنایی v1.3.1' AS title, 'fa' AS lang, 'rtl' AS direction;
SELECT 'button' AS component;
SELECT 'پروژه‌ها' AS title, '/projects.sql' AS link
UNION ALL SELECT 'داشبورد', '/dashboard.sql'
UNION ALL SELECT 'متریک', '/metrics.sql'
UNION ALL SELECT 'یکپارچگی', '/integrity.sql'
UNION ALL SELECT 'گزاره‌ها', '/propositions.sql'
UNION ALL SELECT 'تسک‌ها', '/tasks.sql'
UNION ALL SELECT 'جستجو', '/search.sql'
UNION ALL SELECT 'فیدبک', '/feedback.sql'
UNION ALL SELECT 'الگوها', '/patterns.sql'
UNION ALL SELECT 'اقدامات', '/actions.sql'
UNION ALL SELECT 'آینه‌نگری', '/mirror.sql'
UNION ALL SELECT 'رخدادها', '/timeline.sql';
