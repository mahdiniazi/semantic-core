SELECT 'shell' AS component, 'فیدبک — خلاصه' AS title, 'fa' AS lang, 'rtl' AS direction;
SELECT 'table' AS component, 'خلاصه' AS title;
SELECT * FROM v_feedback_summary;
SELECT 'table' AS component, 'رخدادهای اخیر' AS title;
SELECT project_id, source, event_type, severity, LEFT(observed_issue,60) AS issue, captured_at
FROM feedback_events ORDER BY captured_at DESC LIMIT 15;
