#!/bin/bash
SC=~/semantic_core/products/semantic_core/db/semantic_core.db
WM=~/semantic_core/products/workshop_manager/db/workshop.db
PG="psql -U monitor_ai -d project_monitor -h localhost -tAc"
fb_pending=$($PG "SELECT COUNT(*) FROM feedback_actions WHERE status='proposed'")
fb_applied=$($PG "SELECT COUNT(*) FROM feedback_actions WHERE status='applied'")
pg_proj=$($PG "SELECT COUNT(*) FROM projects")
pg_verified=$($PG "SELECT COUNT(*) FROM wbs_tasks t JOIN statuses s ON t.status_id=s.status_id WHERE s.is_terminal=true")
sc_int=$(sqlite3 $SC 'PRAGMA integrity_check;' 2>&1 | head -1)
sc_fk=$(sqlite3 $SC 'PRAGMA foreign_key_check;' 2>/dev/null | wc -l)
wm_int=$(sqlite3 $WM 'PRAGMA integrity_check;' 2>&1 | head -1)
git_head=$(cd ~/semantic_core && git --no-pager log -1 --format=%h)
echo "═══ DOCTOR v4 — $(date '+%Y-%m-%d %H:%M') ═══"
echo "SC integrity: $sc_int"
echo "SC FK orphans: $sc_fk"
echo "WM integrity: $wm_int"
echo "PG projects: $pg_proj"
echo "PG verified tasks: $pg_verified"
echo "Feedback pending: $fb_pending"
echo "Feedback applied: $fb_applied"
echo "SC size: $(du -h $SC | cut -f1) | WM size: $(du -h $WM | cut -f1)"
echo "Git HEAD: $git_head"
echo "═══════════════════════════════════════════"
