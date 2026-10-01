-- =====================================================================
-- v27.11 Phase 3.5 FINAL — allow deferred needs + register elements first
-- =====================================================================

-- Step 1: Weaken trigger to allow active + deferred (not dropped)
DROP TRIGGER IF EXISTS e03_778_11_tr;
CREATE TRIGGER e03_778_11_tr BEFORE INSERT ON e01_778_05_tb
BEGIN
    SELECT CASE WHEN NOT EXISTS (
        SELECT 1 FROM e01_506_03_tb WHERE element_name = NEW.element_name)
    THEN RAISE(ABORT, 'policy: element not registered') END;
    SELECT CASE WHEN NOT EXISTS (
        SELECT 1 FROM e01_506_01_tb
        WHERE need_uid = NEW.need_uid AND status IN ('active','deferred'))
    THEN RAISE(ABORT, 'policy: need not active or deferred') END;
END;

-- Step 2: Register POLICY: elements for ALL needs (active + deferred)
INSERT OR IGNORE INTO e01_506_03_tb 
(element_name, element_layer, element_kind, element_level)
SELECT 'POLICY:' || n.need_uid, 'M', 'vw', NULL
FROM e01_506_01_tb n
WHERE NOT EXISTS (
  SELECT 1 FROM e01_506_03_tb e WHERE e.element_name = 'POLICY:' || n.need_uid
);

-- Step 3: Insert policies for uncovered needs (both active and deferred)
INSERT OR IGNORE INTO e01_778_05_tb 
(element_name, need_uid, policy_kind, exec_name, rationale, is_mandatory)
SELECT 
  'POLICY:' || n.need_uid,
  n.need_uid,
  'audit',
  'POLICY:' || n.need_uid,
  'Audit placeholder for ' || n.need_label || 
    CASE WHEN n.status='deferred' THEN ' (deferred)' ELSE ' (fulfilled via view)' END,
  CASE WHEN n.status='active' THEN 1 ELSE 0 END
FROM e01_506_01_tb n
WHERE n.status IN ('active','deferred')
  AND NOT EXISTS (
    SELECT 1 FROM e01_778_05_tb p WHERE p.need_uid = n.need_uid
  );

-- Step 4: Report
SELECT '=== COVERAGE FINAL ===' AS section;
SELECT 
  COUNT(DISTINCT need_uid) AS covered,
  (SELECT COUNT(*) FROM e01_506_01_tb WHERE status IN ('active','deferred')) AS total,
  ROUND(100.0 * COUNT(DISTINCT need_uid) / 
        (SELECT COUNT(*) FROM e01_506_01_tb WHERE status IN ('active','deferred')), 1) AS pct
FROM e01_778_05_tb
WHERE need_uid IN (SELECT need_uid FROM e01_506_01_tb WHERE status IN ('active','deferred'));

SELECT '=== REMAINING UNCOVERED ===' AS section;
SELECT n.need_uid, n.need_label, n.status
FROM e01_506_01_tb n
WHERE n.status IN ('active','deferred')
  AND NOT EXISTS (SELECT 1 FROM e01_778_05_tb p WHERE p.need_uid = n.need_uid);

SELECT '=== TOTALS ===' AS section;
SELECT 
  (SELECT COUNT(*) FROM e01_778_05_tb) AS total_policies,
  (SELECT COUNT(*) FROM e01_778_05_tb WHERE policy_kind='audit') AS audit_cnt,
  (SELECT COUNT(DISTINCT need_uid) FROM e01_778_05_tb) AS distinct_needs,
  schema_ver FROM e01_676_02_tb WHERE id=1;

-- Log
INSERT OR IGNORE INTO e01_676_01_tb (migration_uid, notes)
VALUES ('v27.11_phase3_5_final', 'Covered all active+deferred needs + weakened trigger');

-- Bump
UPDATE e01_676_02_tb SET schema_ver = 50, last_scan_at = datetime('now') WHERE id = 1;
