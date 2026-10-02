#!/bin/bash
# capture_clue.sh <project> <type> <severity> <title> <body>
P="${1:-semantic-core}"; T="${2:-hint}"; S="${3:-medium}"; TITLE="${4:-?}"; BODY="${5:-}"
psql -U monitor_ai -d project_monitor -h localhost -tAc "INSERT INTO ai_clues (project_id, clue_type, severity, title, body, created_by) VALUES ('$P','$T','$S','$(echo "$TITLE" | sed "s/'/''/g")','$(echo "$BODY" | sed "s/'/''/g")','AI_AGENT') RETURNING clue_id"
