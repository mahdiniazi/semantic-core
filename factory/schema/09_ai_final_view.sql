CREATE OR REPLACE VIEW v_ai_roadmap_full AS
SELECT
    wt.task_code,
    wt.task_name,
    wt.level,
    wt.is_atomic,
    st.status_code AS task_status,
    wt.verification_cmd,
    ap.prop_code,
    ap.proposition,
    l.link_type
FROM wbs_tasks wt
LEFT JOIN statuses st ON wt.status_id = st.status_id
LEFT JOIN proposition_task_link l ON l.task_id = wt.task_id
LEFT JOIN atomic_propositions ap ON ap.prop_id = l.prop_id
WHERE wt.project_id = 'semantic-core'
ORDER BY wt.task_code, ap.prop_code;

-- نمای dashboard: شمارش به تفکیک وضعیت
CREATE OR REPLACE VIEW v_ai_dashboard AS
SELECT
    'tasks' AS entity, st.status_code, COUNT(*) AS n
FROM wbs_tasks wt
JOIN statuses st ON wt.status_id = st.status_id
WHERE wt.project_id = 'semantic-core'
GROUP BY st.status_code
UNION ALL
SELECT 'propositions', st.status_code, COUNT(*)
FROM atomic_propositions ap
JOIN statuses st ON ap.status_id = st.status_id
WHERE ap.project_id = 'semantic-core'
GROUP BY st.status_code;
