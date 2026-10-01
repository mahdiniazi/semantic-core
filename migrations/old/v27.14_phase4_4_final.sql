-- =====================================================================
-- v27.14 Phase 4.4 — Fix monitor view + anchor 6 missing triggers
-- =====================================================================

-- Step 1: Anchor 6 triggers
INSERT OR IGNORE INTO e01_778_05_tb 
(element_name, need_uid, policy_kind, exec_name, rationale, is_mandatory)
VALUES
  ('e03_120_02_tr','N11','guard','e03_120_02_tr','Type closure insert guard',1),
  ('e03_120_03_tr','N11','guard','e03_120_03_tr','Type closure update guard',1),
  ('e03_434_02_tr','N41','sync','e03_434_02_tr','FTS delete sync',1),
  ('e03_434_03_tr','N41','sync','e03_434_03_tr','FTS update sync',1),
  ('e03_434_04_tr','N41','sync','e03_434_04_tr','label_norm insert sync',1),
  ('e03_434_05_tr','N41','sync','e03_434_05_tr','label_norm update sync',1);

-- Step 2: Rebuild monitor view with POLICY:* excluded from elements counts
DROP VIEW IF EXISTS e04_900_01_vw;
CREATE VIEW e04_900_01_vw AS
SELECT domain, declared, realized,
  CASE WHEN declared > 0 THEN ROUND(100.0 * realized / declared, 1) ELSE 100.0 END AS coverage_pct,
  missing, orphan, severity_class,
  CASE
    WHEN declared = 0 THEN 'na'
    WHEN realized >= declared AND missing = 0 AND orphan = 0 THEN 'healthy'
    WHEN severity_class = 'expected' THEN 'info'
    WHEN 100.0 * realized / declared >= 80 THEN 'watch'
    ELSE 'critical'
  END AS status
FROM (
  SELECT 'needs_to_policy' AS domain,
    (SELECT COUNT(*) FROM e01_506_01_tb),
    (SELECT COUNT(DISTINCT need_uid) FROM e01_778_05_tb),
    (SELECT COUNT(*) FROM e01_506_01_tb n WHERE NOT EXISTS (SELECT 1 FROM e01_778_05_tb p WHERE p.need_uid = n.need_uid)),
    0, 'real_issue'
  UNION ALL SELECT 'atoms_to_link',
    (SELECT COUNT(*) FROM e01_506_02_tb),
    (SELECT COUNT(DISTINCT atom_uid) FROM e01_516_01_tb),
    (SELECT COUNT(*) FROM e01_506_02_tb a WHERE NOT EXISTS (SELECT 1 FROM e01_516_01_tb l WHERE l.atom_uid = a.atom_uid)),
    0, 'real_issue'
  UNION ALL SELECT 'atoms_to_trace',
    (SELECT COUNT(*) FROM e01_506_02_tb),
    (SELECT COUNT(DISTINCT atom_uid) FROM e01_506_04_tb),
    (SELECT COUNT(*) FROM e01_506_02_tb a WHERE NOT EXISTS (SELECT 1 FROM e01_506_04_tb t WHERE t.atom_uid = a.atom_uid)),
    0, 'real_issue'
  UNION ALL SELECT 'elements_to_schema',
    -- Exclude POLICY:* (virtual elements, not real schema)
    (SELECT COUNT(*) FROM e01_506_03_tb 
     WHERE element_kind IN ('tb','tr','vw','ft') 
       AND element_name NOT LIKE 'POLICY:%'),
    (SELECT COUNT(*) FROM e01_506_03_tb e 
     WHERE e.element_kind IN ('tb','tr','vw','ft') 
       AND e.element_name NOT LIKE 'POLICY:%'
       AND EXISTS (SELECT 1 FROM sqlite_master sm WHERE sm.name = e.element_name)),
    (SELECT COUNT(*) FROM e01_506_03_tb e 
     WHERE e.element_kind IN ('tb','tr','vw','ft') 
       AND e.element_name NOT LIKE 'POLICY:%'
       AND NOT EXISTS (SELECT 1 FROM sqlite_master sm WHERE sm.name = e.element_name)),
    (SELECT COUNT(*) FROM sqlite_master sm 
     WHERE sm.type IN ('table','trigger','view') 
       AND sm.name LIKE 'e0%' 
       AND sm.name NOT LIKE 'e02\_404\_01\_ft%' ESCAPE '\'
       AND NOT EXISTS (SELECT 1 FROM e01_506_03_tb e WHERE e.element_name = sm.name)),
    'real_issue'
  UNION ALL SELECT 'elements_to_matrix',
    (SELECT COUNT(*) FROM e01_506_03_tb 
     WHERE element_kind IN ('tb','tr','vw','ft') 
       AND element_name NOT LIKE 'POLICY:%'),
    (SELECT COUNT(*) FROM e01_506_03_tb e 
     WHERE e.element_kind IN ('tb','tr','vw','ft') 
       AND e.element_name NOT LIKE 'POLICY:%'
       AND EXISTS (SELECT 1 FROM e01_778_02_tb m WHERE m.element_name = e.element_name)),
    (SELECT COUNT(*) FROM e01_506_03_tb e 
     WHERE e.element_kind IN ('tb','tr','vw','ft') 
       AND e.element_name NOT LIKE 'POLICY:%'
       AND NOT EXISTS (SELECT 1 FROM e01_778_02_tb m WHERE m.element_name = e.element_name)),
    0, 'real_issue'
  UNION ALL SELECT 'entity_types_to_instances',
    (SELECT COUNT(*) FROM e01_200_01_tb),
    (SELECT COUNT(DISTINCT type_id) FROM e01_200_03_tb),
    (SELECT COUNT(*) FROM e01_200_01_tb t WHERE NOT EXISTS (SELECT 1 FROM e01_200_03_tb e WHERE e.type_id = t.type_id)),
    0, 'expected'
  UNION ALL SELECT 'relation_types_to_relations',
    (SELECT COUNT(*) FROM e01_202_01_tb),
    (SELECT COUNT(DISTINCT reltype_id) FROM e01_222_01_tb),
    (SELECT COUNT(*) FROM e01_202_01_tb t WHERE NOT EXISTS (SELECT 1 FROM e01_222_01_tb r WHERE r.reltype_id = t.reltype_id)),
    0, 'expected'
  UNION ALL SELECT 'policies_to_elements',
    (SELECT COUNT(*) FROM e01_778_05_tb),
    (SELECT COUNT(*) FROM e01_778_05_tb p WHERE EXISTS (SELECT 1 FROM e01_506_03_tb e WHERE e.element_name = p.element_name)),
    (SELECT COUNT(*) FROM e01_778_05_tb p WHERE NOT EXISTS (SELECT 1 FROM e01_506_03_tb e WHERE e.element_name = p.element_name)),
    0, 'real_issue'
  UNION ALL SELECT 'triggers_to_registry',
    (SELECT COUNT(*) FROM sqlite_master WHERE type='trigger' AND name LIKE 'e03%'),
    (SELECT COUNT(*) FROM sqlite_master sm WHERE sm.type='trigger' AND sm.name LIKE 'e03%' AND EXISTS (SELECT 1 FROM e01_506_03_tb e WHERE e.element_name = sm.name)),
    (SELECT COUNT(*) FROM sqlite_master sm WHERE sm.type='trigger' AND sm.name LIKE 'e03%' AND NOT EXISTS (SELECT 1 FROM e01_506_03_tb e WHERE e.element_name = sm.name)),
    0, 'real_issue'
  UNION ALL SELECT 'triggers_to_anchor',
    (SELECT COUNT(*) FROM sqlite_master WHERE type='trigger' AND name LIKE 'e03%'),
    (SELECT COUNT(*) FROM sqlite_master sm WHERE sm.type='trigger' AND sm.name LIKE 'e03%' AND EXISTS (SELECT 1 FROM e01_778_05_tb p WHERE p.exec_name = sm.name)),
    (SELECT COUNT(*) FROM sqlite_master sm WHERE sm.type='trigger' AND sm.name LIKE 'e03%' AND NOT EXISTS (SELECT 1 FROM e01_778_05_tb p WHERE p.exec_name = sm.name)),
    0, 'real_issue'
  UNION ALL SELECT 'fk_to_anchor',
    (SELECT COUNT(*) FROM e01_378_01_tb),
    (SELECT COUNT(*) FROM e01_378_01_tb f WHERE EXISTS (SELECT 1 FROM e01_778_05_tb p WHERE p.fk_ref_id = f.ref_id AND p.policy_kind='fk')),
    (SELECT COUNT(*) FROM e01_378_01_tb f WHERE NOT EXISTS (SELECT 1 FROM e01_778_05_tb p WHERE p.fk_ref_id = f.ref_id AND p.policy_kind='fk')),
    0, 'real_issue'
  UNION ALL SELECT 'matrix_to_needs',
    (SELECT COUNT(*) FROM e01_778_02_tb),
    (SELECT COUNT(*) FROM e01_778_02_tb m WHERE EXISTS (SELECT 1 FROM e01_506_01_tb n WHERE n.need_uid = m.need_uid)),
    (SELECT COUNT(*) FROM e01_778_02_tb m WHERE NOT EXISTS (SELECT 1 FROM e01_506_01_tb n WHERE n.need_uid = m.need_uid)),
    0, 'real_issue'
) t;

-- Log
INSERT OR IGNORE INTO e01_676_01_tb (migration_uid, notes)
VALUES ('v27.14_phase4_4_final', 'Fixed monitor: exclude POLICY:* + anchor 6 triggers');

-- Bump
UPDATE e01_676_02_tb SET schema_ver = 52, last_scan_at = datetime('now') WHERE id = 1;
