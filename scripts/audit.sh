#!/usr/bin/env bash
# ============================================================
# Semantic Core — Full Deep Audit
# Extracts everything: schema, data, health, gaps, samples
# ============================================================
set -u
export LC_ALL=C.UTF-8
export LANG=C.UTF-8
export LESSCHARSET=utf-8

DB="$HOME/semantic_core/semantic_core.db"
STAMP=$(date +%Y%m%d_%H%M)
OUT="$HOME/semantic_core/audit_${STAMP}.txt"

[ ! -f "$DB" ] && { echo "ERROR: $DB not found"; exit 1; }

sec() {
  echo "" >> "$OUT"
  echo "=================================================================" >> "$OUT"
  echo "# $1" >> "$OUT"
  echo "=================================================================" >> "$OUT"
}

q() {
  echo "" >> "$OUT"
  echo "--- $1 ---" >> "$OUT"
  sqlite3 -header -column "$DB" "$2" >> "$OUT" 2>&1
}

qt() {
  echo "" >> "$OUT"
  echo "--- $1 (TSV) ---" >> "$OUT"
  sqlite3 -header -separator $'\t' "$DB" "$2" >> "$OUT" 2>&1
}

ql() {
  echo "" >> "$OUT"
  echo "--- $1 (line) ---" >> "$OUT"
  sqlite3 -line "$DB" "$2" >> "$OUT" 2>&1
}

# ============================================================
{
echo "#################################################################"
echo "# SEMANTIC CORE — FULL DEEP AUDIT"
echo "# Generated: $(date)"
echo "# DB:        $DB"
echo "# DB size:   $(du -h "$DB" | cut -f1)"
echo "#################################################################"
} > "$OUT"

# ============================================================
sec "SECTION 0 — META & VERSION"
q "Schema version"            "SELECT * FROM e01_676_02_tb;"
q "Last 40 migrations"        "SELECT migration_uid, applied_at, substr(notes,1,120) AS note FROM e01_676_01_tb ORDER BY applied_at DESC LIMIT 40;"
q "Object counts"             "SELECT type, COUNT(*) AS n FROM sqlite_master WHERE name NOT LIKE 'sqlite_%' GROUP BY type;"
q "Integrity check"           "PRAGMA integrity_check;"
q "Foreign key check"         "PRAGMA foreign_key_check;"

# ============================================================
sec "SECTION 1 — FULL SCHEMA (DDL)"
echo "" >> "$OUT"
sqlite3 "$DB" ".schema" >> "$OUT" 2>&1

# ============================================================
sec "SECTION 2 — ROW COUNTS PER TABLE"
{
  echo ""
  echo "table_name                          | row_count"
  echo "------------------------------------|----------"
  tables=$(sqlite3 "$DB" "SELECT name FROM sqlite_master WHERE type='table' AND name NOT LIKE 'sqlite_%' ORDER BY name;")
  while IFS= read -r t; do
    [ -z "$t" ] && continue
    n=$(sqlite3 "$DB" "SELECT COUNT(*) FROM \"$t\";" 2>/dev/null)
    printf '%-35s | %s\n' "$t" "$n"
  done <<< "$tables"
} >> "$OUT" 2>&1

# ============================================================
sec "SECTION 3 — ONTOLOGY"
q "Entity types (all 507)"    "SELECT type_id, type_uid, label, parent_id FROM e01_200_01_tb ORDER BY type_uid;"
q "Relation types (all 73)"   "SELECT reltype_id, type_uid, label, is_transitive, inverse_uid FROM e01_202_01_tb ORDER BY type_uid;"
q "Enum domains"              "SELECT * FROM e01_200_02_tb ORDER BY 1;"
q "Enum values"               "SELECT * FROM e01_201_01_tb ORDER BY 1;"
q "Constraints"               "SELECT * FROM e01_112_01_tb ORDER BY 1;"
q "Provenances"               "SELECT * FROM e01_303_01_tb ORDER BY 1;"

# ============================================================
sec "SECTION 4 — HIERARCHY (4-layer tree)"
q "Domains"                   "SELECT ent_uid, label FROM e01_200_03_tb WHERE ent_uid LIKE 'concept:%-domain' ORDER BY ent_uid;"
q "Subsystems"                "SELECT ent_uid, label FROM e01_200_03_tb WHERE ent_uid LIKE 'concept:%-subsystem' ORDER BY ent_uid;"
q "DCUs"                      "SELECT ent_uid, label FROM e01_200_03_tb WHERE ent_uid LIKE 'concept:%-dcu' OR ent_uid LIKE 'concept:%-ecu%' ORDER BY ent_uid;"
q "Full hierarchy (if view exists)" "SELECT * FROM v_full_hierarchy LIMIT 800;"

# ============================================================
sec "SECTION 5 — OBLIGATIONS (inherent / design / chosen)"

q "ALL inherent_to relations" "
SELECT subj.ent_uid AS from_entity, obj.ent_uid AS to_entity, subj.label AS from_label, obj.label AS to_label
FROM e01_222_01_tb r
JOIN e01_202_01_tb rt ON rt.reltype_id=r.reltype_id AND rt.type_uid='inherent_to'
JOIN e01_200_03_tb subj ON subj.ent_id=r.subj_ent_id
JOIN e01_200_03_tb obj  ON obj.ent_id =r.obj_ent_id
WHERE r.status='asserted' AND r.superseded_at IS NULL
ORDER BY subj.ent_uid, obj.ent_uid;"

q "ALL designed_with relations" "
SELECT subj.ent_uid AS model, obj.ent_uid AS feature, subj.label AS model_label, obj.label AS feature_label
FROM e01_222_01_tb r
JOIN e01_202_01_tb rt ON rt.reltype_id=r.reltype_id AND rt.type_uid='designed_with'
JOIN e01_200_03_tb subj ON subj.ent_id=r.subj_ent_id
JOIN e01_200_03_tb obj  ON obj.ent_id =r.obj_ent_id
WHERE r.status='asserted' AND r.superseded_at IS NULL
ORDER BY subj.ent_uid, obj.ent_uid;"

q "ALL chosen (instance has_direct_part)" "
SELECT subj.ent_uid AS instance, obj.ent_uid AS chosen_item, obj.label AS chosen_label
FROM e01_222_01_tb r
JOIN e01_202_01_tb rt ON rt.reltype_id=r.reltype_id AND rt.type_uid='has_direct_part'
JOIN e01_200_03_tb subj ON subj.ent_id=r.subj_ent_id
JOIN e01_200_03_tb obj  ON obj.ent_id =r.obj_ent_id
WHERE subj.ent_uid LIKE 'vehicle:%' AND r.status='asserted' AND r.superseded_at IS NULL
ORDER BY subj.ent_uid, obj.ent_uid;"

# ============================================================
sec "SECTION 6 — FUNCTIONAL CHAINS"

q "All chains (fn:*)"         "SELECT ent_uid, label FROM e01_200_03_tb WHERE ent_uid LIKE 'fn:%' ORDER BY ent_uid;"
q "Chain members (plays_role_in)" "
SELECT chain.ent_uid AS chain, chain.label AS chain_label, part.ent_uid AS role_entity, part.label AS role_label
FROM e01_222_01_tb r
JOIN e01_202_01_tb rt ON rt.reltype_id=r.reltype_id AND rt.type_uid='plays_role_in'
JOIN e01_200_03_tb part  ON part.ent_id =r.subj_ent_id
JOIN e01_200_03_tb chain ON chain.ent_id=r.obj_ent_id
WHERE chain.ent_uid LIKE 'fn:%' AND r.status='asserted' AND r.superseded_at IS NULL
ORDER BY chain.ent_uid, part.ent_uid;"

# ============================================================
sec "SECTION 7 — REAL INSTANCES"

q "All vehicles"               "SELECT ent_uid, label, description, nature, status FROM e01_200_03_tb WHERE ent_uid LIKE 'vehicle:%' ORDER BY ent_uid;"
q "Vehicle → concept"          "
SELECT v.ent_uid AS vehicle, c.ent_uid AS concept, c.label AS concept_label
FROM e01_222_01_tb r
JOIN e01_202_01_tb rt ON rt.reltype_id=r.reltype_id AND rt.type_uid='instance_of'
JOIN e01_200_03_tb v ON v.ent_id=r.subj_ent_id
JOIN e01_200_03_tb c ON c.ent_id=r.obj_ent_id
WHERE v.ent_uid LIKE 'vehicle:%'
ORDER BY v.ent_uid;"

# ============================================================
sec "SECTION 8 — KNOWLEDGE LANDSCAPE"

q "Entities by nature"         "SELECT nature, COUNT(*) AS n FROM e01_200_03_tb GROUP BY nature ORDER BY n DESC;"
q "Entities by status"         "SELECT status, COUNT(*) AS n FROM e01_200_03_tb GROUP BY status ORDER BY n DESC;"
q "Entities by type (top 40)"  "SELECT t.type_uid, COUNT(*) AS n FROM e01_200_03_tb e JOIN e01_200_01_tb t ON t.type_id=e.type_id GROUP BY t.type_uid ORDER BY n DESC LIMIT 40;"
q "Relations by reltype"       "SELECT rt.type_uid, COUNT(*) AS n FROM e01_222_01_tb r JOIN e01_202_01_tb rt ON rt.reltype_id=r.reltype_id GROUP BY rt.type_uid ORDER BY n DESC;"
q "Relations by status"        "SELECT status, COUNT(*) AS n FROM e01_222_01_tb GROUP BY status;"
q "Values by kind"             "SELECT value_kind, COUNT(*) AS n FROM e01_201_02_tb GROUP BY value_kind;"

# ============================================================
sec "SECTION 9 — HEALTH"

q "e04_900_02_vw (issues only)"  "SELECT * FROM e04_900_02_vw;"
q "Health summary"               "SELECT severity, COUNT(*) AS n FROM e04_900_02_vw GROUP BY severity;"
q "Self-check (if exists)"       "SELECT * FROM e04_978_01_vw;"
q "Orphan gate (if exists)"      "SELECT * FROM v_orphan_gate;"

# ============================================================
sec "SECTION 10 — GOVERNANCE (registry / matrix / policy)"

q "Registry by layer+kind"      "SELECT element_layer, element_kind, COUNT(*) AS n FROM e01_506_03_tb GROUP BY element_layer, element_kind ORDER BY element_layer, element_kind;"
q "Matrix counts by need"       "SELECT need_uid, COUNT(*) AS n FROM e01_778_02_tb GROUP BY need_uid ORDER BY n DESC;"
q "Policy counts by kind"       "SELECT policy_kind, COUNT(*) AS n FROM e01_778_05_tb GROUP BY policy_kind;"
q "Needs (all)"                 "SELECT need_uid, need_label FROM e01_506_01_tb ORDER BY need_uid;"
q "All policies"                "
SELECT element_name, need_uid, policy_kind, substr(rationale,1,80) AS rationale
FROM e01_778_05_tb
ORDER BY element_name, need_uid;"

# ============================================================
sec "SECTION 11 — MECHANICS"

q "All triggers"                "SELECT name, tbl_name FROM sqlite_master WHERE type='trigger' ORDER BY name;"
q "All views"                   "SELECT name FROM sqlite_master WHERE type='view' ORDER BY name;"
q "All indexes"                 "SELECT name, tbl_name FROM sqlite_master WHERE type='index' AND name NOT LIKE 'sqlite_%' ORDER BY tbl_name, name;"
q "Placement rules summary"     "SELECT placement_kind, COUNT(*) AS n FROM e01_200_04_tb GROUP BY placement_kind;"
q "Placement rules (all)"       "SELECT t.type_uid AS type, r.target_uid AS target, r.placement_kind FROM e01_200_04_tb r JOIN e01_200_01_tb t ON t.type_id=r.type_id ORDER BY t.type_uid;"
q "Pending queue (all)"         "SELECT * FROM e01_200_05_tb;"

# ============================================================
sec "SECTION 12 — GAPS & UNUSED (the interesting part)"

q "Types with 0 instances"      "SELECT t.type_uid, t.label FROM e01_200_01_tb t WHERE NOT EXISTS (SELECT 1 FROM e01_200_03_tb e WHERE e.type_id=t.type_id) ORDER BY t.type_uid;"
q "Relation types with 0 relations" "SELECT rt.type_uid, rt.label FROM e01_202_01_tb rt WHERE NOT EXISTS (SELECT 1 FROM e01_222_01_tb r WHERE r.reltype_id=rt.reltype_id) ORDER BY rt.type_uid;"
q "Entities without provenance" "SELECT ent_uid, label FROM e01_200_03_tb WHERE prv_id IS NULL LIMIT 200;"
q "Entities without any relation" "
SELECT e.ent_uid, e.label
FROM e01_200_03_tb e
WHERE NOT EXISTS (SELECT 1 FROM e01_222_01_tb r WHERE r.subj_ent_id=e.ent_id OR r.obj_ent_id=e.ent_id)
ORDER BY e.ent_uid LIMIT 200;"
q "Domains without subsystems" "
SELECT d.ent_uid
FROM e01_200_03_tb d
WHERE d.ent_uid LIKE 'concept:%-domain'
  AND NOT EXISTS (
    SELECT 1 FROM e01_222_01_tb r
    JOIN e01_202_01_tb rt ON rt.reltype_id=r.reltype_id AND rt.type_uid IN ('inherent_to','has_direct_part','designed_with')
    WHERE r.subj_ent_id=d.ent_id)
ORDER BY d.ent_uid;"
q "Subsystems without parts" "
SELECT s.ent_uid
FROM e01_200_03_tb s
WHERE s.ent_uid LIKE 'concept:%-subsystem'
  AND NOT EXISTS (
    SELECT 1 FROM e01_222_01_tb r
    JOIN e01_202_01_tb rt ON rt.reltype_id=r.reltype_id AND rt.type_uid IN ('inherent_to','has_direct_part','may_have_direct_part')
    WHERE r.subj_ent_id=s.ent_id)
ORDER BY s.ent_uid;"
q "Chains without members" "
SELECT c.ent_uid
FROM e01_200_03_tb c
WHERE c.ent_uid LIKE 'fn:%'
  AND NOT EXISTS (
    SELECT 1 FROM e01_222_01_tb r
    JOIN e01_202_01_tb rt ON rt.reltype_id=r.reltype_id AND rt.type_uid='plays_role_in'
    WHERE r.obj_ent_id=c.ent_id)
ORDER BY c.ent_uid;"
q "Vehicles without VIN (heuristic)" "
SELECT ent_uid FROM e01_200_03_tb
WHERE ent_uid LIKE 'vehicle:%'
  AND ent_uid NOT GLOB 'vehicle:*-[0-9][0-9]*'
ORDER BY ent_uid;"

# ============================================================
sec "SECTION 13 — SAMPLES"

q "20 random entities"       "SELECT ent_uid, label, nature, status FROM e01_200_03_tb ORDER BY RANDOM() LIMIT 20;"
q "20 random relations"      "
SELECT r.rel_uid, subj.ent_uid AS subject, rt.type_uid AS reltype,
       COALESCE(obj.ent_uid, 'val:'||r.obj_val_id) AS object
FROM e01_222_01_tb r
JOIN e01_202_01_tb rt ON rt.reltype_id=r.reltype_id
JOIN e01_200_03_tb subj ON subj.ent_id=r.subj_ent_id
LEFT JOIN e01_200_03_tb obj ON obj.ent_id=r.obj_ent_id
ORDER BY RANDOM() LIMIT 20;"

# ============================================================
sec "SECTION 14 — RAW DATA (entities + relations, TSV)"

qt "All entities (full)"       "SELECT ent_id, ent_uid, type_id, label, nature, status, prv_id FROM e01_200_03_tb ORDER BY ent_id;"
qt "All relations (full)"      "SELECT rel_id, rel_uid, subj_ent_id, reltype_id, obj_ent_id, obj_val_id, status, superseded_at FROM e01_222_01_tb ORDER BY rel_id;"
qt "All values (full)"         "SELECT val_id, value_kind, num_val, text_val, bool_val, dt_start, unit FROM e01_201_02_tb ORDER BY val_id;"

# ============================================================
echo "" >> "$OUT"
echo "#################################################################" >> "$OUT"
echo "# END OF AUDIT" >> "$OUT"
echo "# File size: $(du -h "$OUT" | cut -f1)" >> "$OUT"
echo "# Lines:     $(wc -l < "$OUT")" >> "$OUT"
echo "#################################################################" >> "$OUT"

echo ""
echo "════════════════════════════════════════════════"
echo "  AUDIT COMPLETE"
echo "════════════════════════════════════════════════"
echo "  File:  $OUT"
echo "  Size:  $(du -h "$OUT" | cut -f1)"
echo "  Lines: $(wc -l < "$OUT")"
echo "════════════════════════════════════════════════"
