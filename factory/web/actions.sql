SELECT 'shell' AS component, 'اقدامات فیدبک' AS title, 'fa' AS lang, 'rtl' AS direction;
SELECT 'table' AS component, 'اقدامات' AS title;
SELECT action_id, project_id, action_type, status, scope_check, LEFT(proposed_change,70) AS change, proposed_at
FROM feedback_actions ORDER BY proposed_at DESC LIMIT 30;
