#!/bin/bash
# mirror_review.sh — آینه‌نگری فاز جاری + 3 فاز بعدی
P="${1:-semantic-core}"
psql -U monitor_ai -d project_monitor -h localhost << SQL
INSERT INTO mirror_reviews (project_id, phase_current, phases_considered, findings, recommendations, boundaries_respected, reviewer)
VALUES ('$P',
  (SELECT SUBSTRING(MIN(task_code) FROM '^[0-9]+') FROM wbs_tasks WHERE project_id='$P' AND is_atomic=true AND status_id<>3),
  (SELECT jsonb_agg(DISTINCT SUBSTRING(task_code FROM '^[0-9]+')) FROM wbs_tasks WHERE project_id='$P' AND is_atomic=true),
  (SELECT jsonb_agg(jsonb_build_object('pattern', pattern_uid, 'occurrences', occurrences)) FROM feedback_patterns WHERE project_id='$P' AND last_seen > NOW() - INTERVAL '7 days'),
  (SELECT jsonb_agg(jsonb_build_object('action', action_type, 'change', proposed_change)) FROM feedback_actions WHERE project_id='$P' AND status='proposed'),
  TRUE,
  'AI_AGENT');
SQL
psql -U monitor_ai -d project_monitor -h localhost -A -F' | ' -c "SELECT review_id, project_id, phase_current, boundaries_respected FROM mirror_reviews ORDER BY reviewed_at DESC LIMIT 5"
