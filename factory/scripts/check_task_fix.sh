#!/bin/bash
DB=/home/cs/semantic_core/products/semantic_core/db/semantic_core.db
case "$1" in
  2.3.2) [ "$(sqlite3 "$DB" "SELECT COUNT(*) FROM e01_222_01_tb WHERE rel_uid LIKE 'r:applies-%'")" -ge 20 ] ;;
  2.3.3) [ "$(sqlite3 "$DB" "SELECT COUNT(*) FROM e01_202_01_tb WHERE type_uid='has_value'")" -ge 1 ] && [ "$(sqlite3 "$DB" "SELECT COUNT(*) FROM e01_112_01_tb WHERE reltype_id=(SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='has_value')")" -ge 2 ] ;;
  2.3.4) [ "$(sqlite3 "$DB" "SELECT COUNT(*) FROM e01_222_01_tb WHERE rel_uid LIKE '%measures%' OR rel_uid LIKE '%measured%'")" -ge 1 ] ;;
  *) exit 2 ;;
esac
