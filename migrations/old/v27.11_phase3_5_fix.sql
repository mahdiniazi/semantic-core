-- =====================================================================
-- v27.11 Phase 3.5 FIXED — register POLICY: elements BEFORE inserting policies
-- =====================================================================

-- Step 1: Register virtual elements first
INSERT OR IGNORE INTO e01_506_03_tb 
(element_name, element_layer, element_kind, element_level)
SELECT 'POLICY:' || n.need_uid, 'M', 'vw', NULL
FROM e01_506_01_tb n
WHERE NOT EXISTS (
  SELECT 1 FROM e01_506_03_tb e WHERE e.element_name = 'POLICY:' || n.need_uid
);

-- Step 2: Now insert policies (both FK sides exist)
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
);

-- Step 3: Report
SELECT '=== COVERAGE ===' AS section;
SELECT 
  COUNT(DISTINCT need_uid) AS covered,
  (SELECT COUNT(*) FROM e01_506_01_tb WHERE status='active') AS active_total,
  ROUND(100.0 * COUNT(DISTINCT need_uid) / 
        (SELECT COUNT(*) FROM e01_506_01_tb WHERE status='active'), 1) AS pct
FROM e01_778_05_tb
WHERE need_uid IN (SELECT need_uid FROM e01_506_01_tb WHERE status='active');

SELECT '=== REMAINING UNCOVERED ===' AS section;
SELECT n.need_uid, n.need_label
FROM e01_506_01_tb n
WHERE NOT EXISTS (SELECT 1 FROM e01_778_05_tb p WHERE p.need_uid = n.need_uid);

SELECT '=== TOTALS ===' AS section;
SELECT 
  (SELECT COUNT(*) FROM e01_778_05_tb) AS total,
  (SELECT COUNT(*) FROM e01_778_05_tb WHERE policy_kind='audit') AS audit_cnt,
  (SELECT COUNT(DISTINCT need_uid) FROM e01_778_05_tb) AS distinct_needs,
  schema_ver FROM e01_676_02_tb WHERE id=1;

-- Log
INSERT OR IGNORE INTO e01_676_01_tb (migration_uid, notes)
VALUES ('v27.11_phase3_5_fixed', 'Coverage for uncovered needs (order fixed)');

-- Bump
UPDATE e01_676_02_tb SET schema_ver = 50, last_scan_at = datetime('now') WHERE id = 1;
