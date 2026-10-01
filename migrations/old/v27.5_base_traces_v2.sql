-- =====================================================================
-- v27.5 v2: base atom traces with real elements + register orphans
-- =====================================================================

-- Register orphan real elements
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

-- Base atom traces (13 design + 13 inferred) with real elements
INSERT OR IGNORE INTO e01_506_04_tb (atom_uid, element_name, trace_type) VALUES
('A01','e01_200_03_tb','implements'),
('A02','e01_201_02_tb','implements'),
('A03','e01_222_01_tb','implements'),
('B06','e03_312_01_tr','implements'),
('B10','e03_312_01_tr','implements'),
('C01','e03_120_01_tr','implements'),
('C02','e03_122_01_tr','implements'),
('D02','e03_434_01_tr','implements'),
('D05','e03_135_01_tr','implements'),
('E01','e03_343_01_tr','implements'),
('F03','e02_404_01_ft','implements'),
('G01','e04_267_01_vw','implements'),
('H05','e01_506_06_tb','implements'),
('I01','e03_312_01_tr','verifies'),
('I02','e04_978_01_vw','implements'),
('I03','e01_506_03_tb','documents'),
('I04','e01_506_04_tb','documents'),
('I05','e03_312_01_tr','implements'),
('I05','e03_312_02_tr','implements'),
('I06','e01_506_03_tb','documents'),
('I07','e01_506_03_tb','documents'),
('I08','e01_516_01_tb','implements'),
('I09','e03_312_01_tr','implements'),
('I09','e03_312_02_tr','implements'),
('I10','e03_360_01_tr','implements'),
('I11','e01_506_01_tb','implements'),
('I11','e01_506_03_tb','implements'),
('I11','e01_506_02_tb','implements'),
('I11','e01_200_03_tb','implements'),
('I11','e01_201_02_tb','implements'),
('I11','e01_222_01_tb','implements'),
('I11','e01_200_01_tb','implements'),
('I11','e01_202_01_tb','implements'),
('I11','e01_201_01_tb','implements'),
('I12','e01_201_02_tb','implements'),
('I13','e01_506_03_tb','documents');

-- Migration log
INSERT OR IGNORE INTO e01_676_01_tb (migration_uid, notes)
VALUES ('v27.5_base_traces_v2', 'Inserted 26 base traces with real elements');

-- Bump
UPDATE e01_676_02_tb SET schema_ver = 41, last_scan_at = datetime('now') WHERE id = 1;
