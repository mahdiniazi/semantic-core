#!/bin/bash
DB=/home/cs/semantic_core/products/semantic_core/db/semantic_core.db
case "$1" in
  2.1.1) [ "$(sqlite3 "$DB" "SELECT COUNT(*) FROM e01_200_01_tb WHERE parent_id=575")" -ge 3 ] ;;
  2.1.2) [ "$(sqlite3 "$DB" "SELECT COUNT(*) FROM e01_200_01_tb WHERE parent_id=575 AND type_uid IN ('PhysicalQuantity','QualitativeProperty','Identifier')")" -ge 3 ] ;;
  2.1.3) [ "$(sqlite3 "$DB" "SELECT COUNT(*) FROM e01_200_03_tb WHERE ent_uid LIKE 'unit:%'")" -ge 20 ] ;;
  2.2.1) [ "$(sqlite3 "$DB" "SELECT COUNT(*) FROM e01_200_03_tb WHERE ent_uid LIKE 'attribute:%'")" -ge 20 ] ;;
  2.2.2) [ "$(sqlite3 "$DB" "SELECT COUNT(*) FROM e01_200_03_tb WHERE ent_uid LIKE 'unit:%'")" -ge 26 ] ;;
  2.2.3) [ "$(sqlite3 "$DB" "SELECT COUNT(*) FROM e01_200_03_tb WHERE ent_uid LIKE 'measurement:%'")" -ge 1 ] ;;
  2.2.4) [ "$(sqlite3 "$DB" "SELECT COUNT(*) FROM e01_200_03_tb WHERE ent_uid LIKE 'observation:%'")" -ge 1 ] ;;
  2.2.5) [ "$(sqlite3 "$DB" "SELECT COUNT(*) FROM e01_200_03_tb WHERE ent_uid LIKE 'evidence:%'")" -ge 2 ] ;;
  2.3.1) [ "$(sqlite3 "$DB" "SELECT COUNT(*) FROM e01_222_01_tb WHERE rel_uid LIKE '%has_unit%'")" -ge 5 ] ;;
  2.3.2) [ "$(sqlite3 "$DB" "SELECT COUNT(*) FROM e01_222_01_tb WHERE rel_uid LIKE '%applies_to%'")" -ge 5 ] ;;
  2.3.3) [ "$(sqlite3 "$DB" "SELECT COUNT(*) FROM e01_222_01_tb WHERE rel_uid LIKE '%has_value%'")" -ge 1 ] ;;
  2.3.4) [ "$(sqlite3 "$DB" "SELECT COUNT(*) FROM e01_222_01_tb WHERE rel_uid LIKE '%measured_on%'")" -ge 1 ] ;;
  2.3.5) [ "$(sqlite3 "$DB" "SELECT COUNT(*) FROM e01_222_01_tb WHERE rel_uid LIKE '%verified_by%'")" -ge 1 ] ;;
  2.4.1) sqlite3 "$DB" "SELECT sql FROM sqlite_master WHERE name='e01_305_01_tb'" | grep -q variant ;;
  2.4.2) [ "$(sqlite3 "$DB" "SELECT COUNT(*) FROM e01_305_01_tb WHERE role='condition'")" -ge 2 ] ;;
  2.4.3) sqlite3 "$DB" "PRAGMA table_info(e01_305_01_tb)" | grep -q valid_from ;;
  *) echo "unknown task code: $1" >&2; exit 2 ;;
esac
