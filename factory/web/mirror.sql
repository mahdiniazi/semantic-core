SELECT 'shell' AS component, 'آینه‌نگری' AS title, 'fa' AS lang, 'rtl' AS direction;
SELECT 'table' AS component, 'بازنگری‌ها' AS title;
SELECT project_id, phase_current, boundaries_respected, reviewed_at FROM mirror_reviews ORDER BY reviewed_at DESC LIMIT 20;
