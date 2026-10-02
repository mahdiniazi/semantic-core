#!/bin/bash
# restore.sh — بازگردانی بکاپ محصول
SRC="$1"
[ -z "$SRC" ] && SRC=$(ls -t ~/semantic_core/products/semantic_core/backups/manual/*.db 2>/dev/null | head -1)
[ -z "$SRC" ] && { echo "no backup"; exit 1; }
DST=~/semantic_core/products/semantic_core/db/semantic_core.db
cp "$DST" "$DST.before_restore.$(date +%Y%m%d_%H%M%S)"
cp "$SRC" "$DST"
echo "restored from $SRC"
