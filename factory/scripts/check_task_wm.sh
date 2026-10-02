#!/bin/bash
BASE=/home/cs/semantic_core/products/workshop_manager
DB=$BASE/db/workshop.db
case "$1" in
  1.1.1|1.1.2|1.1.3|3.3.1|4.1.1|4.1.2) test -f "$DB" ;;
  1.2.1) test -f "$BASE/scripts/barcode.py" ;;
  1.2.2) test -f "$BASE/scripts/vin_check.py" ;;
  1.3.1) test -f "$BASE/scripts/history.py" ;;
  2.1.1) test -f "$BASE/scripts/sc_bridge.py" ;;
  2.1.2) test -f "$BASE/scripts/dtc_api.py" ;;
  2.2.1) test -f "$BASE/scripts/tree_builder.py" ;;
  2.2.2) test -f "$BASE/scripts/ranker.py" ;;
  2.3.1) test -f "$BASE/scripts/hypothesis_rank.py" ;;
  3.1.1) test -f "$BASE/scripts/skill_levels.py" ;;
  3.1.2) test -f "$BASE/scripts/assign.py" ;;
  3.2.1|3.2.2) test -f "$BASE/scripts/refer.py" ;;
  3.3.2) test -f "$BASE/scripts/step_timing.py" ;;
  4.2.1) test -f "$BASE/scripts/cross_branch.py" ;;
  4.3.1) test -f "$BASE/scripts/vehicle_report.py" ;;
  5.1.1|5.1.2) test -f "$BASE/scripts/warranty.py" ;;
  5.2.1) test -f "$BASE/scripts/pricing.py" ;;
  5.2.2) test -f "$BASE/scripts/quote_pdf.py" ;;
  *) exit 2 ;;
esac
