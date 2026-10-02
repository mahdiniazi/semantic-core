#!/bin/bash
# feedback_report.sh — گزارش چرخه فیدبک
psql -U monitor_ai -d project_monitor -h localhost -P pager=off << 'SQL'
\echo '═══ Feedback Summary ═══'
SELECT * FROM v_feedback_summary;
\echo ''
\echo '═══ Top Patterns (30d) ═══'
SELECT pattern_uid, occurrences, severity_avg, last_seen FROM feedback_patterns ORDER BY occurrences DESC LIMIT 10;
\echo ''
\echo '═══ Pending Actions ═══'
SELECT action_id, action_type, LEFT(proposed_change,50), scope_check FROM feedback_actions WHERE status='proposed' LIMIT 10;
\echo ''
\echo '═══ Recent Mirror Reviews ═══'
SELECT project_id, phase_current, reviewed_at, boundaries_respected FROM mirror_reviews ORDER BY reviewed_at DESC LIMIT 5;
SQL
