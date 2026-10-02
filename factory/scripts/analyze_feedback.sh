#!/bin/bash
# analyze_feedback.sh — تجمیع رخدادها به الگو
psql -U monitor_ai -d project_monitor -h localhost << 'SQL'
INSERT INTO feedback_patterns (project_id, pattern_uid, description, occurrences, severity_avg, first_seen, last_seen, related_events)
SELECT project_id,
       'pat_' || event_type || '_' || severity,
       event_type || ' در سطح ' || severity,
       COUNT(*),
       severity,
       MIN(captured_at),
       MAX(captured_at),
       ARRAY_AGG(event_id)
FROM feedback_events
WHERE captured_at > NOW() - INTERVAL '30 days'
GROUP BY project_id, event_type, severity
ON CONFLICT (pattern_uid) DO UPDATE SET
  occurrences = EXCLUDED.occurrences,
  last_seen = EXCLUDED.last_seen,
  related_events = EXCLUDED.related_events;
SQL
psql -U monitor_ai -d project_monitor -h localhost -A -F' | ' -c "SELECT pattern_uid, occurrences, severity_avg FROM feedback_patterns ORDER BY last_seen DESC LIMIT 10"
