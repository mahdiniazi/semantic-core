-- =====================================================================
-- PHASE 3 — FK Anchor Migration
-- =====================================================================

-- 3.1 — Anchor general FKs to N30 (referential integrity)
INSERT OR IGNORE INTO e01_778_05_tb (element_name, need_uid, policy_kind, fk_ref_id, rationale, is_mandatory)
SELECT f.child_table, 'N30', 'fk', f.ref_id,
       'FK ' || f.child_table || '.' || f.child_col || ' to ' || f.parent_table || '.' || f.parent_col,
       1
FROM e01_378_01_tb f
WHERE f.child_table != 'e01_778_05_tb'
  AND f.parent_table != 'e01_778_05_tb'
  AND f.child_col NOT LIKE '%prv_id%'
  AND f.child_table NOT LIKE 'e01_305%'
  AND f.child_table NOT LIKE 'e01_778_02%'
  AND NOT EXISTS (SELECT 1 FROM e01_778_05_tb p WHERE p.fk_ref_id = f.ref_id);

-- 3.2 — Anchor provenance FKs to N31
INSERT OR IGNORE INTO e01_778_05_tb (element_name, need_uid, policy_kind, fk_ref_id, rationale, is_mandatory)
SELECT f.child_table, 'N31', 'fk', f.ref_id,
       'Provenance FK ' || f.child_table || '.' || f.child_col,
       1
FROM e01_378_01_tb f
WHERE f.child_table != 'e01_778_05_tb'
  AND f.child_col = 'prv_id'
  AND NOT EXISTS (SELECT 1 FROM e01_778_05_tb p WHERE p.fk_ref_id = f.ref_id);

-- 3.3 — Anchor context FKs to N32
INSERT OR IGNORE INTO e01_778_05_tb (element_name, need_uid, policy_kind, fk_ref_id, rationale, is_mandatory)
SELECT f.child_table, 'N32', 'fk', f.ref_id,
       'Context FK ' || f.child_table || '.' || f.child_col,
       1
FROM e01_378_01_tb f
WHERE f.child_table LIKE 'e01_305%'
  AND NOT EXISTS (SELECT 1 FROM e01_778_05_tb p WHERE p.fk_ref_id = f.ref_id);

-- 3.4 — Anchor matrix FK to N70
INSERT OR IGNORE INTO e01_778_05_tb (element_name, need_uid, policy_kind, fk_ref_id, rationale, is_mandatory)
SELECT f.child_table, 'N70', 'fk', f.ref_id,
       'Matrix FK ' || f.child_table || '.' || f.child_col,
       1
FROM e01_378_01_tb f
WHERE f.child_table = 'e01_778_02_tb'
  AND NOT EXISTS (SELECT 1 FROM e01_778_05_tb p WHERE p.fk_ref_id = f.ref_id);

-- 3.5 — Anchor bridge FKs to N50 (design language)
INSERT OR IGNORE INTO e01_778_05_tb (element_name, need_uid, policy_kind, fk_ref_id, rationale, is_mandatory)
SELECT 'e01_778_05_tb', 'N50', 'fk', f.ref_id,
       'Bridge FK ' || f.child_col,
       1
FROM e01_378_01_tb f
WHERE f.child_table = 'e01_778_05_tb'
  AND NOT EXISTS (SELECT 1 FROM e01_778_05_tb p WHERE p.fk_ref_id = f.ref_id);

-- 3.6 — Migration log
INSERT OR IGNORE INTO e01_676_01_tb (migration_uid, notes) VALUES
('v27.0_phase3_fk_anchor', 'Phase 3 - FK anchor migration');

-- 3.7 — Bump schema_ver
UPDATE e01_676_02_tb SET schema_ver = 30, last_scan_at = datetime('now') WHERE id = 1;
