-- Drop scattered audit views
DROP VIEW IF EXISTS e04_778_10_vw;
DROP VIEW IF EXISTS e04_778_11_vw;
DROP VIEW IF EXISTS e04_778_12_vw;
DROP VIEW IF EXISTS e04_778_13_vw;

-- Create single unified monitor view
DROP VIEW IF EXISTS e04_900_01_vw;
CREATE VIEW e04_900_01_vw AS
SELECT 'declarations' AS category, 'needs' AS metric, COUNT(*) AS value, 'neutral' AS status FROM e01_506_01_tb
UNION ALL SELECT 'declarations', 'atoms', COUNT(*), 'neutral' FROM e01_506_02_tb
UNION ALL SELECT 'declarations', 'entity_types', COUNT(*), 'neutral' FROM e01_200_01_tb
UNION ALL SELECT 'declarations', 'relation_types', COUNT(*), 'neutral' FROM e01_202_01_tb
UNION ALL SELECT 'declarations', 'policies', COUNT(*), 'neutral' FROM e01_778_05_tb
UNION ALL SELECT 'reality', 'tables', COUNT(*), 'neutral' FROM sqlite_master WHERE type='table'
UNION ALL SELECT 'reality', 'triggers', COUNT(*), 'neutral' FROM sqlite_master WHERE type='trigger'
UNION ALL SELECT 'reality', 'views', COUNT(*), 'neutral' FROM sqlite_master WHERE type='view'
UNION ALL SELECT 'gaps', 'needs_without_policy', (SELECT COUNT(*) FROM e01_506_01_tb n WHERE NOT EXISTS (SELECT 1 FROM e01_778_05_tb p WHERE p.need_uid = n.need_uid)), 'watch'
UNION ALL SELECT 'gaps', 'elements_without_matrix', (SELECT COUNT(*) FROM e01_506_03_tb e WHERE NOT EXISTS (SELECT 1 FROM e01_778_02_tb m WHERE m.element_name = e.element_name)), 'watch'
UNION ALL SELECT 'gaps', 'policies_without_real_element', (SELECT COUNT(*) FROM e01_778_05_tb p WHERE NOT EXISTS (SELECT 1 FROM sqlite_master sm WHERE sm.name = p.element_name)), 'critical'
UNION ALL SELECT 'gaps', 'orphan_matrix_rows', (SELECT COUNT(*) FROM e01_778_02_tb m WHERE NOT EXISTS (SELECT 1 FROM e01_506_03_tb e WHERE e.element_name = m.element_name)), 'critical'
UNION ALL SELECT 'health', 'self_check_fails', (SELECT COUNT(*) FROM e04_978_01_vw WHERE has_violation = 1), 'critical'
UNION ALL SELECT 'health', 'overall', CASE WHEN (SELECT COUNT(*) FROM e04_978_01_vw WHERE has_violation = 1) = 0 THEN 0 ELSE 1 END, CASE WHEN (SELECT COUNT(*) FROM e04_978_01_vw WHERE has_violation = 1) = 0 THEN 'healthy' ELSE 'attention' END;

-- Register the view
INSERT OR IGNORE INTO e01_506_03_tb (element_name, element_layer, element_kind, element_level)
VALUES ('e04_900_01_vw', 'M', 'vw', 4);

-- Migration log
INSERT OR IGNORE INTO e01_676_01_tb (migration_uid, notes)
VALUES ('v27.2_monitor', 'Consolidated monitoring into single view');

-- Bump version
UPDATE e01_676_02_tb SET schema_ver = 38, last_scan_at = datetime('now') WHERE id = 1;
