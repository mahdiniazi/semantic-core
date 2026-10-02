#!/bin/bash
# handoff.sh — اسنپ‌شات کامل برای AI بعدی
PG="psql -U monitor_ai -d project_monitor -h localhost -A -F' | ' -c"
echo "═══ AI HANDOFF — $(date '+%Y-%m-%d %H:%M') ═══"
echo ""
echo "─── 1. پروژه‌ها ───"
$PG "SELECT * FROM v_project_progress"
echo ""
echo "─── 2. نسک‌های باز (برای AI بعدی) ───"
$PG "SELECT clue_id, severity, title FROM v_clues_open LIMIT 15"
echo ""
echo "─── 3. فیدبک اخیر ───"
$PG "SELECT * FROM v_feedback_summary"
echo ""
echo "─── 4. یکپارچگی ───"
$PG "SELECT * FROM v_integrity_report"
echo ""
echo "─── 5. Git ───"
cd ~/semantic_core && git --no-pager log --oneline -5 | cat
echo ""
echo "─── 6. Tags ───"
git --no-pager tag | cat
echo ""
echo "═══════════════════════════════════════════"
