SELECT 'shell' AS component, 'گزاره‌ها' AS title, 'fa' AS lang, 'rtl' AS direction;
SELECT 'table' AS component, 'آخرین ۲۰ گزاره' AS title;
SELECT prop_code AS کد, LEFT(proposition,60) AS گزاره, prop_type AS نوع
FROM atomic_propositions WHERE project_id='semantic-core'
ORDER BY prop_id DESC LIMIT 20;
