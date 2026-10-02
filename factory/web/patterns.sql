SELECT 'shell' AS component, 'الگوهای فیدبک' AS title, 'fa' AS lang, 'rtl' AS direction;
SELECT 'table' AS component, 'الگوها' AS title;
SELECT pattern_uid, occurrences, severity_avg, first_seen, last_seen FROM feedback_patterns ORDER BY occurrences DESC LIMIT 25;
