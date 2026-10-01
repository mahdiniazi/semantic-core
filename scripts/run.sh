#!/bin/bash
set -u
DB="$HOME/semantic_core/semantic_core.db"
RUNS="$HOME/semantic_core/runs"
mkdir -p "$RUNS"

ID="${1:-untitled}"
SRC="${2:-}"
OUT="$RUNS/${ID}.txt"

{
  echo "═══════════════════════════════════════════════════════"
  echo "  RUN: $ID"
  echo "  TIME: $(date '+%Y-%m-%d %H:%M:%S')"
  echo "═══════════════════════════════════════════════════════"
  echo ""
} > "$OUT"

if [ -z "$SRC" ] || [ "$SRC" = "-" ]; then
  sqlite3 -column -header "$DB" 2>&1 | tee -a "$OUT"
elif [ -f "$SRC" ]; then
  sqlite3 -column -header "$DB" < "$SRC" 2>&1 | tee -a "$OUT"
else
  sqlite3 -column -header "$DB" "$SRC" 2>&1 | tee -a "$OUT"
fi

echo "" | tee -a "$OUT"
echo "═══════════════════════════════════════════════════════" | tee -a "$OUT"
echo "  END: $ID" | tee -a "$OUT"
echo "  FILE: $OUT" | tee -a "$OUT"
echo "═══════════════════════════════════════════════════════" | tee -a "$OUT"
