SELECT 'shell' AS component, 'متریک کارخانه' AS title, 'fa' AS lang, 'rtl' AS direction;
SELECT 'table' AS component, 'پیشرفت روزانه' AS title;
SELECT p.project_id AS پروژه,
       (SELECT COUNT(*) FROM wbs_tasks WHERE project_id=p.project_id AND is_atomic=true) AS اتمی,
       (SELECT COUNT(*) FROM wbs_tasks t JOIN statuses s ON t.status_id=s.status_id WHERE t.project_id=p.project_id AND t.is_atomic=true AND s.is_terminal=true) AS تمام,
       (SELECT COUNT(*) FROM change_log WHERE project_id=p.project_id AND changed_at > NOW() - INTERVAL '24 hours') AS تغییر_۲۴س
FROM projects p WHERE p.enabled=true ORDER BY p.project_id;
