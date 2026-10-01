-- =====================================================================
-- v27.6: close remaining gaps (2 atoms, 4 orphans, 24 matrix)
-- =====================================================================

-- GAP 1: atoms without link (2)
INSERT OR IGNORE INTO e01_516_01_tb (need_uid, atom_uid, kind, origin)
SELECT 'N50', atom_uid, 'satisfies', 'inferred'
FROM e01_506_02_tb a
WHERE NOT EXISTS (SELECT 1 FROM e01_516_01_tb l WHERE l.atom_uid = a.atom_uid);

-- GAP 2: register 4 orphan elements (in sqlite_master but not registry)
INSERT OR IGNORE INTO e01_506_03_tb (element_name, element_layer, element_kind, element_level)
SELECT sm.name, 'M',
  CASE WHEN sm.type='trigger' THEN 'tr'
       WHEN sm.type='view' THEN 'vw'
       WHEN sm.type='index' THEN 'ix'
       ELSE 'tb' END,
  CASE WHEN sm.type='trigger' THEN 3
       WHEN sm.type='view' THEN 4
       WHEN sm.type='index' THEN 2
       ELSE 1 END
FROM sqlite_master sm
WHERE sm.name LIKE 'e0%'
  AND sm.type IN ('table','trigger','view','index')
  AND sm.name NOT LIKE 'e02_404_01_ft%'
  AND NOT EXISTS (SELECT 1 FROM e01_506_03_tb e WHERE e.element_name = sm.name);

-- GAP 3: register 24 elements in matrix (link to N50 design language)
INSERT OR IGNORE INTO e01_778_02_tb (element_name, need_uid, is_primary, is_driving, role)
SELECT e.element_name, 'N50', 0, 0, 'serves'
FROM e01_506_03_tb e
WHERE e.element_kind IN ('tb','tr','vw','ft')
  AND NOT EXISTS (SELECT 1 FROM e01_778_02_tb m WHERE m.element_name = e.element_name)
  AND EXISTS (SELECT 1 FROM sqlite_master sm WHERE sm.name = e.element_name);

-- Migration log
INSERT OR IGNORE INTO e01_676_01_tb (migration_uid, notes)
VALUES ('v27.6_final_gaps', 'Closed 2 atom links, 4 orphans, 24 matrix gaps');

-- Bump
UPDATE e01_676_02_tb SET schema_ver = 42, last_scan_at = datetime('now') WHERE id = 1;
