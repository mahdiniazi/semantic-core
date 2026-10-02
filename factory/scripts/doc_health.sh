#!/bin/bash
PG="psql -U monitor_ai -d project_monitor -h localhost -tAc"
echo "─── Docs registered ───"
$PG "SELECT COUNT(*) FROM auto_doc_state"
echo "─── Docs stale ───"
$PG "SELECT COUNT(*) FROM auto_doc_state WHERE is_stale=true"
echo "─── Relations ───"
$PG "SELECT COUNT(*) FROM doc_relations"
echo "─── Files exist ───"
while IFS= read -r f; do
  [ -f "$f" ] && echo "✅ $f" || echo "❌ $f"
done < <($PG "SELECT target_path FROM auto_doc_state")
