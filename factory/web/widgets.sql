SELECT 'shell' AS component, 'ویجت‌ها — فهرست کامل' AS title, 'fa' AS lang, 'rtl' AS direction;
SELECT 'list' AS component, 'ویجت‌های فعال' AS title;
SELECT title AS title, intro_text AS description, url_path AS link
FROM widget_registry WHERE is_active=true ORDER BY category, slug;
