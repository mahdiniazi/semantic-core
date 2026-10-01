-- =====================================================================
-- v27.4 root fix
-- 1. Generate R-atom traces from FK catalog
-- 2. Clean ghost elements and policies
-- 3. Add severity classification to monitor
-- =====================================================================

-- STEP 1: Generate R-atom traces (db_decl + db_audit)
INSERT OR IGNORE INTO e01_506_04_tb (atom_uid, element_name, trace_type)
SELECT 'R' || substr('0' || ref_id, -2), child_table, 'db_decl'
FROM e01_378_01_tb
WHERE 'R' || substr('0' || ref_id, -2) IN (SELECT atom_uid FROM e01_506_02_tb)
  AND child_table IN (SELECT name FROM sqlite_master WHERE type='table');

INSERT OR IGNORE INTO e01_506_04_tb (atom_uid, element_name, trace_type)
SELECT 'R' || substr('0' || ref_id, -2), 'e04_378_01_vw', 'db_audit'
FROM e01_378_01_tb
WHERE 'R' || substr('0' || ref_id, -2) IN (SELECT atom_uid FROM e01_506_02_tb);

-- STEP 2: Clean ghost elements and policies
DELETE FROM e01_778_05_tb
WHERE element_name NOT IN (SELECT name FROM sqlite_master)
  AND element_name NOT LIKE 'POLICY:%';

DELETE FROM e01_506_03_tb
WHERE element_kind IN ('tb','tr','vw','ft')
  AND element_name NOT IN (SELECT name FROM sqlite_master)
  AND element_name NOT IN (SELECT element_name FROM e01_778_05_tb)
  AND element_name NOT LIKE 'POLICY:%';

-- STEP 3: Recreate monitor with severity classification
DROP VIEW IF EXISTS e04_900_01_vw;
CREATE VIEW e04_900_01_vw AS
SELECT
  domain,
  declared,
  realized,
  CASE WHEN declared > 0 THEN ROUND(100.0 * realized / declared, 1) ELSE 100.0 END AS coverage_pct,
  missing,
  orphan,
  severity_class,
  CASE
    WHEN severity_class = 'expected' THEN 'info'
    WHEN declared = 0 THEN 'na'
    WHEN realized >= declared AND missing = 0 AND orphan = 0 THEN 'healthy'
    WHEN 100.0 * realized / declared >= 80 THEN 'watch'
    ELSE 'critical'
  END AS status
FROM (
  SELECT 'needs_to_policy' AS domain,
    (SELECT COUNT(*) FROM e01_506_01_tb) AS declared,
    (SELECT COUNT(DISTINCT need_uid) FROM e01_778_05_tb) AS realized,
    (SELECT COUNT(*) FROM e01_506_01_tb n WHERE NOT EXISTS (SELECT 1 FROM e01_778_05_tb p WHERE p.need_uid = n.need_uid)) AS missing,
    (SELECT COUNT(*) FROM e01_778_05_tb p WHERE NOT EXISTS (SELECT 1 FROM e01_506_01_tb n WHERE n.need_uid = p.need_uid)) AS orphan,
    'expected' AS severity_class
  UNION ALL
  SELECT 'atoms_to_link',
    (SELECT COUNT(*) FROM e01_506_02_tb),
    (SELECT COUNT(DISTINCT atom_uid) FROM e01_516_01_tb),
    (SELECT COUNT(*) FROM e01_506_02_tb a WHERE NOT EXISTS (SELECT 1 FROM e01_516_01_tb l WHERE l.atom_uid = a.atom_uid)),
    0,
    'real_issue'
  UNION ALL
  SELECT 'atoms_to_trace',
    (SELECT COUNT(*) FROM e01_506_02_tb),
    (SELECT COUNT(DISTINCT atom_uid) FROM e01_506_04_tb),
    (SELECT COUNT(*) FROM e01_506_02_tb a WHERE NOT EXISTS (SELECT 1 FROM e01_506_04_tb t WHERE t.atom_uid = a.atom_uid)),
    0,
    'real_issue'
  UNION ALL
  SELECT 'elements_to_schema',
    (SELECT COUNT(*) FROM e01_506_03_tb WHERE element_kind IN ('tb','tr','vw','ft')),
    (SELECT COUNT(*) FROM e01_506_03_tb e WHERE e.element_kind IN ('tb','tr','vw','ft') AND EXISTS (SELECT 1 FROM sqlite_master sm WHERE sm.name = e.element_name)),
    (SELECT COUNT(*) FROM e01_506_03_tb e WHERE e.element_kind IN ('tb','tr','vw','ft') AND NOT EXISTS (SELECT 1 FROM sqlite_master sm WHERE sm.name = e.element_name)),
    (SELECT COUNT(*) FROM sqlite_master sm WHERE sm.type IN ('table','trigger','view') AND sm.name LIKE 'e0%' AND NOT EXISTS (SELECT 1 FROM e01_506_03_tb e WHERE e.element_name = sm.name)),
    'real_issue'
  UNION ALL
  SELECT 'elements_to_matrix',
    (SELECT COUNT(*) FROM e01_506_03_tb WHERE element_kind IN ('tb','tr','vw','ft')),
    (SELECT COUNT(*) FROM e01_506_03_tb e WHERE e.element_kind IN ('tb','tr','vw','ft') AND EXISTS (SELECT 1 FROM e01_778_02_tb m WHERE m.element_name = e.element_name)),
    (SELECT COUNT(*) FROM e01_506_03_tb e WHERE e.element_kind IN ('tb','tr','vw','ft') AND NOT EXISTS (SELECT 1 FROM e01_778_02_tb m WHERE m.element_name = e.element_name)),
    0,
    'real_issue'
  UNION ALL
  SELECT 'entity_types_to_instances',
    (SELECT COUNT(*) FROM e01_200_01_tb),
    (SELECT COUNT(DISTINCT type_id) FROM e01_200_03_tb),
    (SELECT COUNT(*) FROM e01_200_01_tb t WHERE NOT EXISTS (SELECT 1 FROM e01_200_03_tb e WHERE e.type_id = t.type_id)),
    0,
    'expected'
  UNION ALL
  SELECT 'relation_types_to_relations',
    (SELECT COUNT(*) FROM e01_202_01_tb),
    (SELECT COUNT(DISTINCT reltype_id) FROM e01_222_01_tb),
    (SELECT COUNT(*) FROM e01_202_01_tb t WHERE NOT EXISTS (SELECT 1 FROM e01_222_01_tb r WHERE r.reltype_id = t.reltype_id)),
    0,
    'expected'
  UNION ALL
  SELECT 'policies_to_elements',
    (SELECT COUNT(*) FROM e01_778_05_tb),
    (SELECT COUNT(*) FROM e01_778_05_tb p WHERE EXISTS (SELECT 1 FROM e01_506_03_tb e WHERE e.element_name = p.element_name)),
    (SELECT COUNT(*) FROM e01_778_05_tb p WHERE NOT EXISTS (SELECT 1 FROM e01_506_03_tb e WHERE e.element_name = p.element_name)),
    0,
    'real_issue'
  UNION ALL
  SELECT 'triggers_to_registry',
    (SELECT COUNT(*) FROM sqlite_master WHERE type='trigger' AND name LIKE 'e03%'),
    (SELECT COUNT(*) FROM sqlite_master sm WHERE sm.type='trigger' AND sm.name LIKE 'e03%' AND EXISTS (SELECT 1 FROM e01_506_03_tb e WHERE e.element_name = sm.name)),
    (SELECT COUNT(*) FROM sqlite_master sm WHERE sm.type='trigger' AND sm.name LIKE 'e03%' AND NOT EXISTS (SELECT 1 FROM e01_506_03_tb e WHERE e.element_name = sm.name)),
    0,
    'real_issue'
  UNION ALL
  SELECT 'triggers_to_anchor',
    (SELECT COUNT(*) FROM sqlite_master WHERE type='trigger' AND name LIKE 'e03%'),
    (SELECT COUNT(*) FROM sqlite_master sm WHERE sm.type='trigger' AND sm.name LIKE 'e03%' AND EXISTS (SELECT 1 FROM e01_778_05_tb p WHERE p.exec_name = sm.name)),
    0,
    0,
    'real_issue'
  UNION ALL
  SELECT 'fk_to_anchor',
    (SELECT COUNT(*) FROM e01_378_01_tb),
    (SELECT COUNT(*) FROM e01_378_01_tb f WHERE EXISTS (SELECT 1 FROM e01_778_05_tb p WHERE p.fk_ref_id = f.ref_id AND p.policy_kind='fk')),
    (SELECT COUNT(*) FROM e01_378_01_tb f WHERE NOT EXISTS (SELECT 1 FROM e01_778_05_tb p WHERE p.fk_ref_id = f.ref_id AND p.policy_kind='fk')),
    0,
    'real_issue'
  UNION ALL
  SELECT 'matrix_to_needs',
    (SELECT COUNT(*) FROM e01_778_02_tb),
    (SELECT COUNT(*) FROM e01_778_02_tb m WHERE EXISTS (SELECT 1 FROM e01_506_01_tb n WHERE n.need_uid = m.need_uid)),
    (SELECT COUNT(*) FROM e01_778_02_tb m WHERE NOT EXISTS (SELECT 1 FROM e01_506_01_tb n WHERE n.need_uid = m.need_uid)),
    0,
    'real_issue'
) t;

INSERT OR IGNORE INTO e01_676_01_tb (migration_uid, notes)
VALUES ('v27.4_root_fix', 'Generate R traces, clean ghosts, add severity classification');

UPDATE e01_676_02_tb SET schema_ver = 40, last_scan_at = datetime('now') WHERE id = 1;

