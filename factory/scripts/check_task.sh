#!/bin/bash
DB=/home/cs/semantic_core/products/semantic_core/db/semantic_core.db
rec() { sqlite3 "$DB" "WITH RECURSIVE c(id) AS (SELECT type_id FROM e01_200_01_tb WHERE type_uid='$1' UNION ALL SELECT t.type_id FROM e01_200_01_tb t JOIN c ON t.parent_id=c.id) SELECT COUNT(*) FROM e01_200_03_tb WHERE type_id IN (SELECT id FROM c)"; }
case "$1" in
  3.1.1) [ "$(rec Claim)" -ge 1 ] ;;
  3.1.2) [ "$(sqlite3 "$DB" "SELECT COUNT(*) FROM e01_200_01_tb WHERE parent_id=(SELECT type_id FROM e01_200_01_tb WHERE type_uid='Claim')")" -ge 1 ] ;;
  4.1.1) [ "$(sqlite3 "$DB" "SELECT COUNT(*) FROM e01_200_01_tb WHERE type_uid IN ('Episode','DiagnosticEpisode')")" -ge 1 ] && [ "$(sqlite3 "$DB" "SELECT COUNT(*) FROM e01_200_03_tb WHERE ent_uid LIKE 'episode:%'")" -ge 1 ] ;;
  4.1.2) [ "$(sqlite3 "$DB" "SELECT COUNT(*) FROM e01_200_03_tb WHERE ent_uid LIKE 'state:%'")" -ge 3 ] ;;
  4.1.3) [ "$(sqlite3 "$DB" "SELECT COUNT(*) FROM e01_200_03_tb WHERE ent_uid LIKE 'episode:%'")" -ge 1 ] ;;
  4.2.1) [ "$(sqlite3 "$DB" "SELECT COUNT(*) FROM e01_200_03_tb WHERE ent_uid LIKE 'hypothesis:%'")" -ge 1 ] ;;
  4.2.2) [ "$(sqlite3 "$DB" "SELECT COUNT(*) FROM e01_202_01_tb WHERE type_uid='predicts'")" -ge 1 ] ;;
  4.2.3) [ "$(sqlite3 "$DB" "SELECT COUNT(*) FROM e01_222_01_tb r JOIN e01_202_01_tb rt ON r.reltype_id=rt.reltype_id WHERE rt.type_uid IN ('supports','contradicts') AND r.rel_uid LIKE '%hypothesis%'")" -ge 2 ] ;;
  4.2.4) [ "$(sqlite3 "$DB" "SELECT COUNT(*) FROM e01_222_01_tb r JOIN e01_202_01_tb rt ON r.reltype_id=rt.reltype_id WHERE rt.type_uid='ruled_out'")" -ge 1 ] ;;
  4.3.1) [ "$(sqlite3 "$DB" "SELECT COUNT(*) FROM e01_200_01_tb WHERE type_uid='Test'")" -ge 1 ] && [ "$(sqlite3 "$DB" "SELECT COUNT(*) FROM e01_200_03_tb WHERE ent_uid LIKE 'test:%'")" -ge 40 ] ;;
  4.3.2) [ "$(sqlite3 "$DB" "SELECT COUNT(*) FROM e01_202_01_tb WHERE type_uid='interprets'")" -ge 1 ] ;;
  4.3.3) [ "$(sqlite3 "$DB" "SELECT COUNT(*) FROM e01_222_01_tb r JOIN e01_202_01_tb rt ON r.reltype_id=rt.reltype_id WHERE rt.type_uid='tested_by'")" -ge 20 ] ;;
  4.4.1) [ "$(sqlite3 "$DB" "SELECT COUNT(*) FROM e01_200_01_tb WHERE type_uid IN ('Decision','Diagnosis')")" -ge 1 ] ;;
  4.4.2) [ "$(sqlite3 "$DB" "SELECT COUNT(*) FROM e01_200_01_tb WHERE parent_id=(SELECT type_id FROM e01_200_01_tb WHERE type_uid='Decision') OR type_uid='Decision'")" -ge 1 ] ;;
  4.4.3) [ "$(sqlite3 "$DB" "SELECT COUNT(*) FROM e01_202_01_tb WHERE type_uid='refer_to'")" -ge 1 ] ;;
  4.5.1) [ "$(sqlite3 "$DB" "SELECT COUNT(*) FROM e01_200_01_tb WHERE type_uid='Verification'")" -ge 1 ] && [ "$(sqlite3 "$DB" "SELECT COUNT(*) FROM e01_200_03_tb WHERE ent_uid LIKE 'verification:%'")" -ge 1 ] ;;
  4.5.2) [ "$(sqlite3 "$DB" "SELECT COUNT(*) FROM e01_202_01_tb WHERE type_uid='counterfactual_of'")" -ge 1 ] ;;
  *) exit 2 ;;
esac
