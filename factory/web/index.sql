SELECT 'shell' AS component, 'کارخانه معنایی' AS title, 'fa' AS lang, 'rtl' AS direction;
SELECT 'button' AS component;
SELECT 'داشبورد' AS title, '/dashboard.sql' AS link
UNION ALL SELECT 'متریک', '/metrics.sql'
UNION ALL SELECT 'گزاره‌ها', '/propositions.sql'
UNION ALL SELECT 'تسک‌ها', '/tasks.sql'
UNION ALL SELECT 'جستجو', '/search.sql'
UNION ALL SELECT 'فیدبک', '/feedback.sql'
UNION ALL SELECT 'الگوها', '/patterns.sql'
UNION ALL SELECT 'اقدامات', '/actions.sql'
UNION ALL SELECT 'آینه‌نگری', '/mirror.sql';
