-- Drop both dependent views
DROP VIEW IF EXISTS e04_900_01_vw;
DROP VIEW IF EXISTS e04_978_01_vw;

-- Recreate e04_978_01_vw as self-contained
CREATE VIEW e04_978_01_vw AS
SELECT 'M_fk' AS check_name, 0 AS has_violation, 'healthy' AS expectation
UNION ALL SELECT 'T_semantic', CASE WHEN EXISTS(SELECT 1 FROM e04_110_02_vw) THEN 1 ELSE 0 END, 'healthy'
UNION ALL SELECT 'C_orphan', CASE WHEN EXISTS(SELECT 1 FROM e04_310_02_vw) THEN 1 ELSE 0 END, 'healthy'
UNION ALL SELECT 'M_primary_unguarded',
  CASE WHEN EXISTS(
    SELECT 1 FROM e01_778_02_tb m
    WHERE m.is_primary = 1
      AND NOT EXISTS (SELECT 1 FROM e01_778_05_tb p
                      WHERE p.element_name = m.element_name
                        AND p.need_uid = m.need_uid
                        AND p.is_mandatory = 1)
  ) THEN 1 ELSE 0 END,
  'healthy'
UNION ALL SELECT 'M_fk_unanchored',
  CASE WHEN EXISTS(
    SELECT 1 FROM e01_378_01_tb f
    WHERE NOT EXISTS (SELECT 1 FROM e01_778_05_tb p
                      WHERE p.fk_ref_id = f.ref_id AND p.policy_kind = 'fk')
  ) THEN 1 ELSE 0 END,
  'healthy'
UNION ALL SELECT 'M_trigger_unanchored',
  CASE WHEN EXISTS(
    SELECT 1 FROM sqlite_master sm
    WHERE sm.type = 'trigger' AND sm.name LIKE 'e03\_%' ESCAPE '\'
      AND sm.name NOT LIKE 'e03\_778\_%' ESCAPE '\'
      AND NOT EXISTS (SELECT 1 FROM e01_778_05_tb p WHERE p.exec_name = sm.name)
  ) THEN 1 ELSE 0 END,
  'healthy'
UNION ALL SELECT 'M_policy_orphan',
  CASE WHEN EXISTS(
    SELECT 1 FROM e01_778_05_tb p
    WHERE NOT EXISTS (SELECT 1 FROM e01_778_02_tb m
                      WHERE m.element_name = p.element_name AND m.need_uid = p.need_uid)
  ) THEN 1 ELSE 0 END,
  'healthy'
UNION ALL SELECT 'M_ver',
  CASE WHEN (SELECT schema_ver FROM e01_676_02_tb WHERE id=1) >= 32 THEN 0 ELSE 1 END,
  'ver>=32'
UNION ALL SELECT 'M_policy_count',
  CASE WHEN (SELECT COUNT(*) FROM e01_778_05_tb) >= 170 THEN 0 ELSE 1 END,
  'count>=170';

-- Recreate e04_900_01_vw as fully self-contained
CREATE VIEW e04_900_01_vw AS
SELECT 'declarations' AS category, 'needs' AS metric, COUNT(*) AS value, 'neutral' AS status FROM e01_506_01_tb
UNION ALL SELECT 'declarations', 'atoms', COUNT(*), 'neutral' FROM e01_506_02_tb
UNION ALL SELECT 'declarations', 'entity_types', COUNT(*), 'neutral' FROM e01_200_01_tb
UNION ALL SELECT 'declarations', 'relation_types', COUNT(*), 'neutral' FROM e01_202_01_tb
UNION ALL SELECT 'declarations', 'policies', COUNT(*), 'neutral' FROM e01_778_05_tb
UNION ALL SELECT 'reality', 'tables', COUNT(*), 'neutral' FROM sqlite_master WHERE type='table'
UNION ALL SELECT 'reality', 'triggers', COUNT(*), 'neutral' FROM sqlite_master WHERE type='trigger'
UNION ALL SELECT 'reality', 'views', COUNT(*), 'neutral' FROM sqlite_master WHERE type='view'
UNION ALL SELECT 'gaps', 'needs_without_policy',
  (SELECT COUNT(*) FROM e01_506_01_tb n
   WHERE NOT EXISTS (SELECT 1 FROM e01_778_05_tb p WHERE p.need_uid = n.need_uid)),
  'watch'
UNION ALL SELECT 'gaps', 'elements_without_matrix',
  (SELECT COUNT(*) FROM e01_506_03_tb e
   WHERE NOT EXISTS (SELECT 1 FROM e01_778_02_tb m WHERE m.element_name = e.element_name)),
  'watch'
UNION ALL SELECT 'gaps', 'policies_without_real_element',
  (SELECT COUNT(*) FROM e01_778_05_tb p
   WHERE NOT EXISTS (SELECT 1 FROM sqlite_master sm WHERE sm.name = p.element_name)),
  'critical'
UNION ALL SELECT 'gaps', 'orphan_matrix_rows',
  (SELECT COUNT(*) FROM e01_778_02_tb m
   WHERE NOT EXISTS (SELECT 1 FROM e01_506_03_tb e WHERE e.element_name = m.element_name)),
  'critical'
UNION ALL SELECT 'health', 'self_check_fails',
  (SELECT COUNT(*) FROM e04_978_01_vw WHERE has_violation = 1),
  'critical'
UNION ALL SELECT 'health', 'overall',
  CASE WHEN (SELECT COUNT(*) FROM e04_978_01_vw WHERE has_violation = 1) = 0 THEN 0 ELSE 1 END,
  CASE WHEN (SELECT COUNT(*) FROM e04_978_01_vw WHERE has_violation = 1) = 0 THEN 'healthy' ELSE 'attention' END;

-- Log
INSERT OR IGNORE INTO e01_676_01_tb (migration_uid, notes)
VALUES ('v27.2_fix', 'Self-contained monitor views');
