#!/bin/bash
# migrate.sh — اجرای یک migration روی دیتابیس semantic_core
# 
# استفاده:
#   ./scripts/migrate.sh migrations/v158.sql
#   ./scripts/migrate.sh migrations/v158.sql --no-backup
#   ./scripts/migrate.sh migrations/v158.sql --dry-run

set -e

if [ $# -lt 1 ]; then
    echo "استفاده: $0 <migration_file> [--no-backup|--dry-run]"
    exit 1
fi

MIGRATION_FILE="$1"
MODE="${2:-}"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
DB_FILE="$PROJECT_ROOT/db/semantic_core.db"

if [ ! -f "$MIGRATION_FILE" ]; then
    echo "❌ فایل migration پیدا نشد: $MIGRATION_FILE"
    exit 1
fi

if [ ! -f "$DB_FILE" ]; then
    echo "❌ دیتابیس پیدا نشد: $DB_FILE"
    exit 1
fi

MIGRATION_NAME=$(basename "$MIGRATION_FILE" .sql)
echo "🔄 اجرای migration: $MIGRATION_NAME"

if [ "$MODE" != "--no-backup" ] && [ "$MODE" != "--dry-run" ]; then
    echo "📦 بکاپ پیش از اجرا..."
    "$SCRIPT_DIR/backup.sh" manual "before-${MIGRATION_NAME}"
fi

if [ "$MODE" = "--dry-run" ]; then
    echo "🧪 حالت آزمایشی (dry-run)"
    echo "   فایل: $MIGRATION_FILE"
    echo "   تعداد خط: $(wc -l < "$MIGRATION_FILE")"
    echo ""
    echo "   محتوا (۵۰ خط اول):"
    head -50 "$MIGRATION_FILE"
    exit 0
fi

echo "⚙️  اجرای SQL..."
if sqlite3 "$DB_FILE" < "$MIGRATION_FILE"; then
    echo "✅ migration با موفقیت اجرا شد"
    
    ENTITIES=$(sqlite3 "$DB_FILE" "SELECT COUNT(*) FROM e01_200_03_tb;")
    RELATIONS=$(sqlite3 "$DB_FILE" "SELECT COUNT(*) FROM e01_222_01_tb;")
    TYPES=$(sqlite3 "$DB_FILE" "SELECT COUNT(*) FROM e01_200_01_tb;")
    
    echo ""
    echo "📊 آمار دیتابیس پس از اجرا:"
    echo "   types:     $TYPES"
    echo "   entities:  $ENTITIES"
    echo "   relations: $RELATIONS"
else
    echo "❌ خطا در اجرای migration"
    exit 1
fi
