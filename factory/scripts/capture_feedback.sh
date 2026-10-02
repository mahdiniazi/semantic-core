#!/bin/bash
# capture_feedback.sh — ثبت رخداد فیدبک
# usage: capture_feedback.sh <project> <source> <type> <severity> <issue> [hint]
P="${1:-semantic-core}"; SRC="${2:-execution}"; TYPE="${3:-unknown}"; SEV="${4:-info}"; ISSUE="${5:-بدون شرح}"; HINT="${6:-}"
psql -U monitor_ai -d project_monitor -h localhost -tAc "INSERT INTO feedback_events (project_id, source, event_type, severity, observed_issue, proposed_hint, captured_by) VALUES ('$P','$SRC','$TYPE','$SEV','$(echo "$ISSUE" | sed "s/'/''/g")','$(echo "$HINT" | sed "s/'/''/g")','AI_AGENT') RETURNING event_id" 
