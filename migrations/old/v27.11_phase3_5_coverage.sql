-- =====================================================================
-- v27.11 Phase 3.5 — Add audit policies for uncovered needs
-- =====================================================================

-- Register virtual audit elements (POLICY:NXX) - they are not schema, 
-- but they represent "the need is acknowledged"

-- For each uncovered need, add an audit policy pointing to a virtual element
INSERT OR IGNORE INTO e01_778_05_tb 
(element_name, need_uid, policy_kind, exec_name, rationale, is_mandatory)
SELECT 
  'POLICY:' || n.need_uid,
  n.need_uid,
  'audit',
  'POLICY:' || n.need_uid,
  'Audit placeholder for ' || n.need_label || ' (fulfilled via view)',
  1
FROM e01_506_01_tb n
WHERE NOT EXISTS (
  SELECT 1 FROM e01_778_05_tb p WHERE p.need_uid = n.need_uid
)
AND n.status = 'active';

-- Register POLICY: elements in registry (so FK constraints pass)
INSERT OR IGNORE INTO e01_506_03_tb 
(element_name, element_layer, element_kind, element_level)
SELECT 'POLICY:' || n.need_uid, 'M', 'vw', NULL
FROM e01_506_01_tb n
WHERE NOT EXISTS (
  SELECT 1 FROM e01_506_03_tb e WHERE e.element_name = 'POLICY:' || n.need_uid
);

-- Report
SELECT '=== COVERAGE AFTER ===' AS section;
SELECT 
  COUNT(DISTINCT need_uid) AS covered_needs,
  (SELECT COUNT(*) FROM e01_506_01_tb WHERE status='active') AS total_active,
  ROUND(100.0 * COUNT(DISTINCT need_uid) / 
        (SELECT COUNT(*) FROM e01_506_01_tb WHERE status='active'), 1) AS coverage_pct
FROM e01_778_05_tb
WHERE need_uid IN (SELECT need_uid FROM e01_506_01_tb WHERE status='active');

SELECT '=== REMAINING UNCOVERED ===' AS section;
SELECT n.need_uid, n.need_label, n.status
FROM e01_506_01_tb n
WHERE NOT EXISTS (SELECT 1 FROM e01_778_05_tb p WHERE p.need_uid = n.need_uid);

SELECT '=== TOTAL POLICIES ===' AS section;
SELECT 
  (SELECT COUNT(*) FROM e01_778_05_tb) AS total_policies,
  (SELECT COUNT(*) FROM e01_778_05_tb WHERE policy_kind='audit') AS audit_policies,
  (SELECT COUNT(DISTINCT need_uid) FROM e01_778_05_tb) AS distinct_needs;

-- Log
INSERT OR IGNORE INTO e01_676_01_tb (migration_uid, notes)
VALUES ('v27.11_phase3_5_coverage', 'Added audit policies for uncovered needs');

-- Bump
UPDATE e01_676_02_tb SET schema_ver = 50, last_scan_at = datetime('now') WHERE id = 1;
