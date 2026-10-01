-- v121.1 — رفع coverage_pct در بخش B
.mode column
.headers on

BEGIN;

DROP VIEW IF EXISTS e04_900_01_vw;

CREATE VIEW e04_900_01_vw AS
-- بخش A: ۹ چک ساختاری
SELECT 
  'self_check' AS category,
  check_name AS domain,
  has_violation AS issues,
  CASE WHEN has_violation = 0 THEN 100.0 ELSE 0.0 END AS coverage_pct,
  violating_entities AS details,
  CASE WHEN has_violation = 0 THEN 'healthy' ELSE 'critical' END AS status
FROM e04_978_01_vw

UNION ALL

-- بخش B: ۱۲ دامنه پوشش
SELECT 
  'coverage' AS category,
  domain,
  missing + orphan AS issues,
  CASE WHEN declared > 0 THEN ROUND(100.0 * realized / declared, 1) ELSE 100.0 END AS coverage_pct,
  CASE 
    WHEN missing_items = '—' AND orphan_items = '—' THEN '—'
    WHEN missing_items = '—' THEN 'orphan: ' || orphan_items
    WHEN orphan_items = '—' THEN 'missing: ' || missing_items
    ELSE 'missing: ' || missing_items || ' | orphan: ' || orphan_items
  END AS details,
  CASE
    WHEN declared = 0 THEN 'na'
    WHEN realized >= declared AND missing = 0 AND orphan = 0 THEN 'healthy'
    WHEN severity_class = 'expected' THEN 'info'
    WHEN 100.0 * realized / declared >= 80 THEN 'watch'
    ELSE 'critical'
  END AS status
FROM (
  SELECT 
    'needs_to_policy' AS domain,
    (SELECT COUNT(*) FROM e01_506_01_tb) AS declared,
    (SELECT COUNT(DISTINCT need_uid) FROM e01_778_05_tb) AS realized,
    (SELECT COUNT(*) FROM e01_506_01_tb n WHERE NOT EXISTS (
      SELECT 1 FROM e01_778_05_tb p WHERE p.need_uid = n.need_uid)) AS missing,
    0 AS orphan,
    COALESCE((SELECT GROUP_CONCAT(n.need_uid, ', ')
      FROM e01_506_01_tb n WHERE NOT EXISTS (
        SELECT 1 FROM e01_778_05_tb p WHERE p.need_uid = n.need_uid)), '—') AS missing_items,
    '—' AS orphan_items,
    'real_issue' AS severity_class
  UNION ALL
  SELECT 'atoms_to_link',
    (SELECT COUNT(*) FROM e01_506_02_tb),
    (SELECT COUNT(DISTINCT atom_uid) FROM e01_516_01_tb),
    (SELECT COUNT(*) FROM e01_506_02_tb a WHERE NOT EXISTS (
      SELECT 1 FROM e01_516_01_tb l WHERE l.atom_uid = a.atom_uid)),
    0,
    COALESCE((SELECT GROUP_CONCAT(a.atom_uid, ', ')
      FROM e01_506_02_tb a WHERE NOT EXISTS (
        SELECT 1 FROM e01_516_01_tb l WHERE l.atom_uid = a.atom_uid)), '—'),
    '—', 'real_issue'
  UNION ALL
  SELECT 'atoms_to_trace',
    (SELECT COUNT(*) FROM e01_506_02_tb),
    (SELECT COUNT(DISTINCT atom_uid) FROM e01_506_04_tb),
    (SELECT COUNT(*) FROM e01_506_02_tb a WHERE NOT EXISTS (
      SELECT 1 FROM e01_506_04_tb t WHERE t.atom_uid = a.atom_uid)),
    0,
    COALESCE((SELECT GROUP_CONCAT(a.atom_uid, ', ')
      FROM e01_506_02_tb a WHERE NOT EXISTS (
        SELECT 1 FROM e01_506_04_tb t WHERE t.atom_uid = a.atom_uid)), '—'),
    '—', 'real_issue'
  UNION ALL
  SELECT 'elements_to_schema',
    (SELECT COUNT(*) FROM e01_506_03_tb WHERE element_kind IN ('tb','tr','vw','ft') 
      AND element_name NOT LIKE 'POLICY:%'),
    (SELECT COUNT(*) FROM e01_506_03_tb e WHERE e.element_kind IN ('tb','tr','vw','ft') 
      AND e.element_name NOT LIKE 'POLICY:%' 
      AND EXISTS (SELECT 1 FROM sqlite_master sm WHERE sm.name = e.element_name)),
    (SELECT COUNT(*) FROM e01_506_03_tb e WHERE e.element_kind IN ('tb','tr','vw','ft') 
      AND e.element_name NOT LIKE 'POLICY:%' 
      AND NOT EXISTS (SELECT 1 FROM sqlite_master sm WHERE sm.name = e.element_name)),
    (SELECT COUNT(*) FROM sqlite_master sm WHERE sm.type IN ('table','trigger','view') 
      AND sm.name LIKE 'e0%' 
      AND sm.name NOT LIKE '%_data' AND sm.name NOT LIKE '%_idx' 
      AND sm.name NOT LIKE '%_docsize' AND sm.name NOT LIKE '%_config'
      AND NOT EXISTS (SELECT 1 FROM e01_506_03_tb e WHERE e.element_name = sm.name)),
    COALESCE((SELECT GROUP_CONCAT(e.element_name, ', ')
      FROM e01_506_03_tb e WHERE e.element_kind IN ('tb','tr','vw','ft') 
      AND e.element_name NOT LIKE 'POLICY:%' 
      AND NOT EXISTS (SELECT 1 FROM sqlite_master sm WHERE sm.name = e.element_name)), '—'),
    COALESCE((SELECT GROUP_CONCAT(sm.name, ', ')
      FROM sqlite_master sm WHERE sm.type IN ('table','trigger','view') 
      AND sm.name LIKE 'e0%' 
      AND sm.name NOT LIKE '%_data' AND sm.name NOT LIKE '%_idx' 
      AND sm.name NOT LIKE '%_docsize' AND sm.name NOT LIKE '%_config'
      AND NOT EXISTS (SELECT 1 FROM e01_506_03_tb e WHERE e.element_name = sm.name)), '—'),
    'real_issue'
  UNION ALL
  SELECT 'elements_to_matrix',
    (SELECT COUNT(*) FROM e01_506_03_tb WHERE element_kind IN ('tb','tr','vw','ft') 
      AND element_name NOT LIKE 'POLICY:%'),
    (SELECT COUNT(*) FROM e01_506_03_tb e WHERE e.element_kind IN ('tb','tr','vw','ft') 
      AND e.element_name NOT LIKE 'POLICY:%' 
      AND EXISTS (SELECT 1 FROM e01_778_02_tb m WHERE m.element_name = e.element_name)),
    (SELECT COUNT(*) FROM e01_506_03_tb e WHERE e.element_kind IN ('tb','tr','vw','ft') 
      AND e.element_name NOT LIKE 'POLICY:%' 
      AND NOT EXISTS (SELECT 1 FROM e01_778_02_tb m WHERE m.element_name = e.element_name)),
    0,
    COALESCE((SELECT GROUP_CONCAT(e.element_name, ', ')
      FROM e01_506_03_tb e WHERE e.element_kind IN ('tb','tr','vw','ft') 
      AND e.element_name NOT LIKE 'POLICY:%' 
      AND NOT EXISTS (SELECT 1 FROM e01_778_02_tb m WHERE m.element_name = e.element_name)), '—'),
    '—', 'real_issue'
  UNION ALL
  SELECT 'entity_types_to_instances',
    (SELECT COUNT(*) FROM e01_200_01_tb),
    (SELECT COUNT(DISTINCT type_id) FROM e01_200_03_tb),
    (SELECT COUNT(*) FROM e01_200_01_tb t WHERE NOT EXISTS (
      SELECT 1 FROM e01_200_03_tb e WHERE e.type_id = t.type_id)),
    0,
    COALESCE((SELECT GROUP_CONCAT(t.type_uid, ', ')
      FROM e01_200_01_tb t WHERE NOT EXISTS (
        SELECT 1 FROM e01_200_03_tb e WHERE e.type_id = t.type_id)), '—'),
    '—', 'expected'
  UNION ALL
  SELECT 'relation_types_to_relations',
    (SELECT COUNT(*) FROM e01_202_01_tb),
    (SELECT COUNT(DISTINCT reltype_id) FROM e01_222_01_tb),
    (SELECT COUNT(*) FROM e01_202_01_tb t WHERE NOT EXISTS (
      SELECT 1 FROM e01_222_01_tb r WHERE r.reltype_id = t.reltype_id)),
    0,
    COALESCE((SELECT GROUP_CONCAT(t.type_uid, ', ')
      FROM e01_202_01_tb t WHERE NOT EXISTS (
        SELECT 1 FROM e01_222_01_tb r WHERE r.reltype_id = t.reltype_id)), '—'),
    '—', 'expected'
  UNION ALL
  SELECT 'policies_to_elements',
    (SELECT COUNT(*) FROM e01_778_05_tb),
    (SELECT COUNT(*) FROM e01_778_05_tb p WHERE EXISTS (
      SELECT 1 FROM e01_506_03_tb e WHERE e.element_name = p.element_name)),
    (SELECT COUNT(*) FROM e01_778_05_tb p WHERE NOT EXISTS (
      SELECT 1 FROM e01_506_03_tb e WHERE e.element_name = p.element_name)),
    0,
    COALESCE((SELECT GROUP_CONCAT(p.element_name, ', ')
      FROM e01_778_05_tb p WHERE NOT EXISTS (
        SELECT 1 FROM e01_506_03_tb e WHERE e.element_name = p.element_name)), '—'),
    '—', 'real_issue'
  UNION ALL
  SELECT 'triggers_to_registry',
    (SELECT COUNT(*) FROM sqlite_master WHERE type='trigger' AND name LIKE 'e03%'),
    (SELECT COUNT(*) FROM sqlite_master sm WHERE sm.type='trigger' AND sm.name LIKE 'e03%' 
      AND EXISTS (SELECT 1 FROM e01_506_03_tb e WHERE e.element_name = sm.name)),
    (SELECT COUNT(*) FROM sqlite_master sm WHERE sm.type='trigger' AND sm.name LIKE 'e03%' 
      AND NOT EXISTS (SELECT 1 FROM e01_506_03_tb e WHERE e.element_name = sm.name)),
    0,
    COALESCE((SELECT GROUP_CONCAT(sm.name, ', ')
      FROM sqlite_master sm WHERE sm.type='trigger' AND sm.name LIKE 'e03%' 
      AND NOT EXISTS (SELECT 1 FROM e01_506_03_tb e WHERE e.element_name = sm.name)), '—'),
    '—', 'real_issue'
  UNION ALL
  SELECT 'triggers_to_anchor',
    (SELECT COUNT(*) FROM sqlite_master WHERE type='trigger' AND name LIKE 'e03%'),
    (SELECT COUNT(*) FROM sqlite_master sm WHERE sm.type='trigger' AND sm.name LIKE 'e03%' 
      AND EXISTS (SELECT 1 FROM e01_778_05_tb p WHERE p.exec_name = sm.name)),
    (SELECT COUNT(*) FROM sqlite_master sm WHERE sm.type='trigger' AND sm.name LIKE 'e03%' 
      AND NOT EXISTS (SELECT 1 FROM e01_778_05_tb p WHERE p.exec_name = sm.name)),
    0,
    COALESCE((SELECT GROUP_CONCAT(sm.name, ', ')
      FROM sqlite_master sm WHERE sm.type='trigger' AND sm.name LIKE 'e03%' 
      AND NOT EXISTS (SELECT 1 FROM e01_778_05_tb p WHERE p.exec_name = sm.name)), '—'),
    '—', 'real_issue'
  UNION ALL
  SELECT 'fk_to_anchor',
    (SELECT COUNT(*) FROM e01_378_01_tb),
    (SELECT COUNT(*) FROM e01_378_01_tb f WHERE EXISTS (
      SELECT 1 FROM e01_778_05_tb p WHERE p.fk_ref_id = f.ref_id AND p.policy_kind='fk')),
    (SELECT COUNT(*) FROM e01_378_01_tb f WHERE NOT EXISTS (
      SELECT 1 FROM e01_778_05_tb p WHERE p.fk_ref_id = f.ref_id AND p.policy_kind='fk')),
    0,
    COALESCE((SELECT GROUP_CONCAT(f.child_table || '.' || f.child_col, ', ')
      FROM e01_378_01_tb f WHERE NOT EXISTS (
        SELECT 1 FROM e01_778_05_tb p WHERE p.fk_ref_id = f.ref_id AND p.policy_kind='fk')), '—'),
    '—', 'real_issue'
  UNION ALL
  SELECT 'matrix_to_needs',
    (SELECT COUNT(*) FROM e01_778_02_tb),
    (SELECT COUNT(*) FROM e01_778_02_tb m WHERE EXISTS (
      SELECT 1 FROM e01_506_01_tb n WHERE n.need_uid = m.need_uid)),
    (SELECT COUNT(*) FROM e01_778_02_tb m WHERE NOT EXISTS (
      SELECT 1 FROM e01_506_01_tb n WHERE n.need_uid = m.need_uid)),
    0,
    COALESCE((SELECT GROUP_CONCAT(m.element_name || '→' || m.need_uid, ', ')
      FROM e01_778_02_tb m WHERE NOT EXISTS (
        SELECT 1 FROM e01_506_01_tb n WHERE n.need_uid = m.need_uid)), '—'),
    '—', 'real_issue'
) t;

INSERT OR IGNORE INTO e01_676_01_tb (migration_uid, notes)
VALUES ('v121.1_fix','Fixed coverage_pct computation in unified health view');

UPDATE e01_676_02_tb SET schema_ver = schema_ver + 1 WHERE id = 1;

COMMIT;

SELECT '═══ گزارش سلامت یکپارچه ═══' AS section;
SELECT category, domain, issues, coverage_pct, status
FROM e04_900_01_vw
ORDER BY 
  CASE status WHEN 'critical' THEN 1 WHEN 'watch' THEN 2 
              WHEN 'healthy' THEN 3 ELSE 4 END,
  category, domain;
