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
  2.3.2) [ "$(sqlite3 "$DB" "SELECT COUNT(*) FROM e01_222_01_tb WHERE rel_uid LIKE 'r:applies-%'")" -ge 20 ] ;;
  2.3.3) [ "$(sqlite3 "$DB" "SELECT COUNT(*) FROM e01_202_01_tb WHERE type_uid='has_value'")" -ge 1 ] ;;
  2.3.4) [ "$(sqlite3 "$DB" "SELECT COUNT(*) FROM e01_222_01_tb WHERE rel_uid LIKE '%measures%' OR rel_uid LIKE '%measured%'")" -ge 1 ] ;;
  2.3.5) [ "$(sqlite3 "$DB" "SELECT COUNT(*) FROM e01_222_01_tb WHERE rel_uid LIKE '%verified_by%'")" -ge 1 ] ;;
  2.4.1) sqlite3 "$DB" "SELECT sql FROM sqlite_master WHERE name='e01_305_01_tb'" | grep -q variant ;;
  2.4.2) [ "$(sqlite3 "$DB" "SELECT COUNT(*) FROM e01_305_01_tb WHERE role='condition'")" -ge 2 ] ;;
  2.4.3) sqlite3 "$DB" "PRAGMA table_info(e01_305_01_tb)" | grep -q valid_from ;;
  3.1.1) [ "$(sqlite3 "$DB" "SELECT COUNT(*) FROM e01_200_03_tb WHERE type_id=(SELECT type_id FROM e01_200_01_tb WHERE type_uid='Claim')")" -ge 1 ] ;;
  3.1.2) [ "$(sqlite3 "$DB" "SELECT COUNT(*) FROM e01_200_01_tb WHERE parent_id=(SELECT type_id FROM e01_200_01_tb WHERE type_uid='Claim')")" -ge 1 ] ;;
  3.1.3) [ "$(sqlite3 "$DB" "SELECT COUNT(*) FROM e01_305_01_tb")" -ge 1 ] && [ "$(sqlite3 "$DB" "SELECT COUNT(*) FROM e01_305_02_tb")" -ge 1 ] ;;
  3.1.4) [ "$(sqlite3 "$DB" "SELECT COUNT(*) FROM e01_303_01_tb")" -ge 1 ] ;;
  3.2.1) [ "$(sqlite3 "$DB" "SELECT COUNT(*) FROM e01_200_03_tb WHERE type_id=(SELECT type_id FROM e01_200_01_tb WHERE type_uid='Evidence')")" -ge 1 ] ;;
  3.2.2) [ "$(sqlite3 "$DB" "SELECT COUNT(*) FROM e01_222_01_tb r JOIN e01_202_01_tb rt ON r.reltype_id=rt.reltype_id WHERE rt.type_uid='supports'")" -ge 1 ] ;;
  3.2.3) [ "$(sqlite3 "$DB" "SELECT COUNT(*) FROM e01_222_01_tb r JOIN e01_202_01_tb rt ON r.reltype_id=rt.reltype_id WHERE rt.type_uid='contradicts'")" -ge 1 ] ;;
  3.2.4) [ "$(sqlite3 "$DB" "SELECT COUNT(*) FROM e01_202_01_tb WHERE type_uid IN ('has_severity','has_occurrence_rate','has_detection_rating')")" -ge 1 ] ;;
  3.3.1) [ "$(sqlite3 "$DB" "SELECT COUNT(*) FROM e01_330_01_tb")" -ge 1 ] ;;
  3.3.2) sqlite3 "$DB" ".schema e01_330_01_tb" | grep -q supersedes_id ;;
  3.3.3) [ "$(sqlite3 "$DB" "SELECT COUNT(*) FROM sqlite_master WHERE name='e01_302_01_tb'")" -ge 1 ] ;;
  3.4.1) [ "$(sqlite3 "$DB" "SELECT COUNT(*) FROM e01_222_01_tb r JOIN e01_202_01_tb rt ON r.reltype_id=rt.reltype_id WHERE rt.type_uid='contradicts'")" -ge 1 ] ;;
  3.4.2) sqlite3 "$DB" ".schema e01_300_01_tb" | grep -q disputed ;;
  *) exit 2 ;;
esac
