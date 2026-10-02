#!/bin/bash
SC=~/semantic_core/products/semantic_core/db/semantic_core.db
WM=~/semantic_core/products/workshop_manager/db/workshop.db
PG="psql -U monitor_ai -d project_monitor -h localhost -tAc"
echo "═══ DOCTOR v3 — $(date '+%Y-%m-%d %H:%M') ═══"
echo "SC integrity: $(sqlite3 $SC 'PRAGMA integrity_check;' 2>&1 | head -1)"
echo "SC FK orphans: $(sqlite3 $SC 'PRAGMA foreign_key_check;' 2>/dev/null | wc -l)"
echo "WM integrity: $(sqlite3 $WM 'PRAGMA integrity_check;' 2>&1 | head -1)"
echo "PG projects: $($PG 'SELECT COUNT(*) FROM projects')"
echo "PG verified tasks: $($PG 'SELECT COUNT(*) FROM wbs_tasks t JOIN statuses s ON t.status_id=s.status_id WHERE s.is_terminal=true')"
echo "Feedback pending: $($PG \"SELECT COUNT(*) FROM feedback_actions WHERE status='proposed'\")"
echo "Feedback applied: $($PG \"SELECT COUNT(*) FROM feedback_actions WHERE status='applied'\")"
echo "SC size: $(du -h $SC | cut -f1) | WM size: $(du -h $WM | cut -f1)"
echo "Git HEAD: $(cd ~/semantic_core && git --no-pager log -1 --format=%h)"
echo "═══════════════════════════════════════════"
