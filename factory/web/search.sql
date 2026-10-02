SELECT 'shell' AS component, 'جستجو' AS title, 'fa' AS lang, 'rtl' AS direction;
SELECT 'form' AS component, 'جستجو در گزاره‌ها' AS title;
SELECT 'q' AS name, 'متن' AS label, 'text' AS type;
SELECT 'table' AS component, 'نتایج' AS title;
SELECT prop_code AS کد, LEFT(proposition,80) AS گزاره
FROM atomic_propositions
WHERE (:q IS NULL OR proposition ILIKE '%' || :q || '%')
LIMIT 30;
