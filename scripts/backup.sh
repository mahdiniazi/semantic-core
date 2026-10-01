#!/bin/bash
# backup.sh — بکاپ هوشمند دیتابیس semantic_core
# 
# استفاده:
#   ./scripts/backup.sh              # بکاپ به backups/manual/
#   ./scripts/backup.sh daily        # بکاپ به backups/daily/
#   ./scripts/backup.sh milestone "پایان لایه Attribute"  # بکاپ نقطه‌عطف

set -e

# مسیرها
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
DB_FILE="$PROJECT_ROOT/db/semantic_core.db"

# تنظیمات
BACKUP_TYPE="${1:-manual}"
NOTE="${2:-}"
STAMP=$(date +%Y%m%d-%H%M%S)
BACKUP_DIR="$PROJECT_ROOT/backups/$BACKUP_TYPE"

# بررسی دیتابیس
if [ ! -f "$DB_FILE" ]; then
    echo "❌ دیتابیس پیدا نشد: $DB_FILE"
    exit 1
fi

# ساخت پوشه بکاپ
mkdir -p "$BACKUP_DIR"

# نام فایل بکاپ
if [ -n "$NOTE" ]; then
    SAFE_NOTE=$(echo "$NOTE" | tr ' ' '-' | tr -cd '[:alnum:]-_')
    BACKUP_FILE="$BACKUP_DIR/semantic_core-${STAMP}-${SAFE_NOTE}.db"
else
    BACKUP_FILE="$BACKUP_DIR/semantic_core-${STAMP}.db"
fi

# بکاپ با استفاده از SQLite backup (سالم و سازگار)
echo "📦 در حال ساخت بکاپ..."
sqlite3 "$DB_FILE" ".backup '$BACKUP_FILE'"

# بررسی سلامت
INTEGRITY=$(sqlite3 "$BACKUP_FILE" "PRAGMA integrity_check;")
if [ "$INTEGRITY" != "ok" ]; then
    echo "❌ بکاپ سالم نیست: $INTEGRITY"
    rm -f "$BACKUP_FILE"
    exit 1
fi

# آمار
ENTITIES=$(sqlite3 "$BACKUP_FILE" "SELECT COUNT(*) FROM e01_200_03_tb;")
RELATIONS=$(sqlite3 "$BACKUP_FILE" "SELECT COUNT(*) FROM e01_222_01_tb;")
TYPES=$(sqlite3 "$BACKUP_FILE" "SELECT COUNT(*) FROM e01_200_01_tb;")
SIZE=$(du -h "$BACKUP_FILE" | cut -f1)

echo "✅ بکاپ ساخته شد:"
echo "   مسیر:     $BACKUP_FILE"
echo "   اندازه:   $SIZE"
echo "   types:    $TYPES"
echo "   entities: $ENTITIES"
echo "   relations: $RELATIONS"
echo "   وضعیت:    سالم (integrity check ok)"
