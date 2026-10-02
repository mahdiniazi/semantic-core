SELECT 'shell' AS component, 'کارخانه — داشبورد' AS title, 'fa' AS lang, 'rtl' AS direction;
SELECT 'table' AS component, 'وضعیت پروژه‌ها' AS title;
SELECT p.project_id AS شناسه, p.display_name AS نام,
       (SELECT COUNT(*) FROM atomic_propositions WHERE project_id=p.project_id) AS گزاره,
       (SELECT COUNT(*) FROM wbs_tasks WHERE project_id=p.project_id) AS تسک,
       (SELECT COUNT(*) FROM wbs_tasks t JOIN statuses s ON t.status_id=s.status_id WHERE t.project_id=p.project_id AND s.is_terminal=true) AS تمام
FROM projects p WHERE p.enabled=true ORDER BY p.project_id;
SELECT 'table' AS component, 'تغییرات اخیر' AS title;
SELECT entity_type, entity_id, field_changed, new_value, changed_at FROM change_log ORDER BY changed_at DESC LIMIT 10;
