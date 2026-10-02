#!/bin/bash
# report.sh — گزارش مشتری از پایگاه دانش خودرو
DB=/home/cs/semantic_core/products/semantic_core/db/semantic_core.db
echo "═══════════════════════════════════════"
echo " گزارش پایگاه دانش برق خودرو"
echo " تاریخ: $(date '+%Y-%m-%d %H:%M')"
echo "═══════════════════════════════════════"
sqlite3 "$DB" "SELECT ' انواع: '||COUNT(*) FROM e01_200_01_tb;"
sqlite3 "$DB" "SELECT ' موجودیت‌ها: '||COUNT(*) FROM e01_200_03_tb;"
sqlite3 "$DB" "SELECT ' روابط: '||COUNT(*) FROM e01_222_01_tb;"
sqlite3 "$DB" "SELECT ' attr/unit: '||COUNT(*) FROM e01_200_03_tb WHERE ent_uid LIKE 'attribute:%' OR ent_uid LIKE 'unit:%';"
sqlite3 "$DB" "SELECT ' claims: '||COUNT(*) FROM e01_200_03_tb WHERE ent_uid LIKE 'claim:%';"
echo "═══════════════════════════════════════"
