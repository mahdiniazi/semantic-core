-- صفحه اصلی: داشبورد کارخانه
SELECT 'shell' AS component,
       'کارخانه معنایی — داشبورد' AS title,
       'fa' AS lang,
       'rtl' AS direction;

-- جدول خلاصه وضعیت
SELECT 'table' AS component,
       'وضعیت کلی' AS title;

SELECT entity AS نوع, status_code AS وضعیت, n AS تعداد
FROM v_ai_dashboard
ORDER BY entity, status_code;

-- دکمه‌های ناوبری
SELECT 'button' AS component;

SELECT 'گزاره‌ها' AS title, '/propositions.sql' AS link
UNION ALL
SELECT 'وظایف' AS title, '/tasks.sql' AS link
UNION ALL
SELECT 'جستجو' AS title, '/search.sql' AS link;
