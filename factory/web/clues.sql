SELECT 'shell' AS component, 'نسک‌ها — برای AI بعدی' AS title, 'fa' AS lang, 'rtl' AS direction;
SELECT 'table' AS component, 'نسک‌های باز' AS title;
SELECT project_id AS پروژه, clue_type AS نوع, severity AS شدت, title AS عنوان, LEFT(body,80) AS خلاصه, created_at AS تاریخ
FROM ai_clues WHERE resolved=false AND for_next_ai=true
ORDER BY CASE severity WHEN 'critical' THEN 1 WHEN 'high' THEN 2 WHEN 'medium' THEN 3 ELSE 4 END;
