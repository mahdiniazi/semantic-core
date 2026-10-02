SELECT 'shell' AS component, 'صف تسک‌ها' AS title, 'fa' AS lang, 'rtl' AS direction;
SELECT 'table' AS component, 'تسک‌ها به تفکیک پروژه' AS title;
SELECT t.project_id AS پروژه, t.task_code AS کد, LEFT(t.task_name,40) AS عنوان, s.status_code AS وضعیت
FROM wbs_tasks t JOIN statuses s ON t.status_id=s.status_id
WHERE t.is_atomic=true
ORDER BY t.project_id, t.task_code LIMIT 40;
