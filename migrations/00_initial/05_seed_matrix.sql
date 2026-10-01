-- ============ Questions (14) ============
INSERT OR IGNORE INTO e01_506_05_tb (question_uid, parent_uid, label, purpose, answer_kind, required_rule, seq) VALUES
('Q00',NULL,'Need?','start','text','always',0),
('Q01','Q00','Why?','purpose','text','always',1),
('Q02','Q01','Goal?','expected','text','always',2),
('Q03','Q02','Object?','object','entity_ref','by_need_kind',3),
('Q04','Q03','Actor?','actor','entity_ref','conditional',4),
('Q05','Q04','Action?','action','text','by_need_kind',5),
('Q06','Q05','Input?','input','value','conditional',6),
('Q07','Q06','Context?','context','text','conditional',7),
('Q08','Q07','Result?','result','text','always',8),
('Q09','Q08','Constraint?','constraint','text','conditional',9),
('Q10','Q09','Exception?','exception','text','conditional',10),
('Q11','Q10','Acceptance?','acceptance','criterion','always',11),
('Q12','Q11','Mechanism?','mechanism','entity_ref','always',12),
('Q13','Q12','Verification?','verification','criterion','always',13);

-- ============ Sample entities (11) ============
INSERT OR IGNORE INTO e01_200_03_tb (ent_uid, type_id, nature, label, description) VALUES
('role:switch',(SELECT type_id FROM e01_200_01_tb WHERE type_uid='FunctionalRole'),'concept','Switch','role switch'),
('role:protector',(SELECT type_id FROM e01_200_01_tb WHERE type_uid='FunctionalRole'),'concept','Protector','protect role'),
('role:isolator',(SELECT type_id FROM e01_200_01_tb WHERE type_uid='FunctionalRole'),'concept','Isolator','isolate role'),
('role:no-switch',(SELECT type_id FROM e01_200_01_tb WHERE type_uid='FunctionalRole'),'concept','NO-switch','normally open'),
('role:nc-switch',(SELECT type_id FROM e01_200_01_tb WHERE type_uid='FunctionalRole'),'concept','NC-switch','normally closed'),
('fm:coil-elec',(SELECT type_id FROM e01_200_01_tb WHERE type_uid='FailureMode'),'concept','CoilElec','coil electrical'),
('fm:coil-open',(SELECT type_id FROM e01_200_01_tb WHERE type_uid='FailureMode'),'concept','CoilOpen','primary open'),
('fm:coil-short',(SELECT type_id FROM e01_200_01_tb WHERE type_uid='FailureMode'),'concept','CoilShort','coil short'),
('coil:generic',(SELECT type_id FROM e01_200_01_tb WHERE type_uid='IgnitionCoil'),'concept','Coil','standard'),
('battery:generic',(SELECT type_id FROM e01_200_01_tb WHERE type_uid='Battery'),'concept','Battery','12V'),
('dtc:P0301',(SELECT type_id FROM e01_200_01_tb WHERE type_uid='DTC'),'concept','P0301','misfire');

-- ============ Sample relations (7) ============
INSERT OR IGNORE INTO e01_222_01_tb (rel_uid, reltype_id, subj_ent_id, obj_ent_id, status) VALUES
('r:no-isa-switch',(SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='is_a'),(SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='role:no-switch'),(SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='role:switch'),'asserted'),
('r:nc-isa-switch',(SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='is_a'),(SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='role:nc-switch'),(SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='role:switch'),'asserted'),
('r:fmopen-isa-fmelec',(SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='is_a'),(SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='fm:coil-open'),(SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='fm:coil-elec'),'asserted'),
('r:fmshort-isa-fmelec',(SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='is_a'),(SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='fm:coil-short'),(SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='fm:coil-elec'),'asserted'),
('r:coil-has-fmopen',(SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='has_failure_mode'),(SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='coil:generic'),(SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='fm:coil-open'),'asserted'),
('r:coil-has-fmshort',(SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='has_failure_mode'),(SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='coil:generic'),(SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='fm:coil-short'),'asserted'),
('r:fmopen-manifests-p0301',(SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='manifests_as'),(SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='fm:coil-open'),(SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='dtc:P0301'),'asserted');

-- ============ Element registry (auto) ============
INSERT OR IGNORE INTO e01_506_03_tb (element_name, element_layer, element_kind)
SELECT sm.name,
  CASE
    WHEN sm.name IN ('e01_200_01_tb','e01_200_02_tb','e01_201_01_tb','e01_120_01_tb','e01_112_01_tb','e01_202_01_tb') THEN 'T'
    WHEN sm.name IN ('e01_200_03_tb','e01_201_02_tb','e01_201_03_tb','e01_303_01_tb','e01_302_01_tb','e01_222_01_tb') THEN 'C'
    WHEN sm.name IN ('e01_305_01_tb','e01_305_02_tb','e01_305_03_tb') THEN 'X'
    WHEN sm.name = 'e01_300_01_tb' THEN 'I'
    WHEN sm.name IN ('e01_330_01_tb','e01_330_02_tb') THEN 'V'
    ELSE 'M'
  END,
  CASE
    WHEN lower(ltrim(coalesce(sm.sql, ''))) LIKE 'create virtual table%' AND lower(coalesce(sm.sql, '')) LIKE '%using fts5%' THEN 'ft'
    WHEN sm.type = 'table' THEN 'tb'
    WHEN sm.type = 'view' THEN 'vw'
    WHEN sm.type = 'index' THEN 'ix'
    WHEN sm.type = 'trigger' THEN 'tr'
    ELSE sm.type
  END
FROM sqlite_master sm
WHERE sm.name NOT LIKE 'sqlite\_%' ESCAPE '\'
  AND sm.name NOT LIKE 'e02_404_01_ft\_%' ESCAPE '\'
  AND sm.name <> 'e02_404_01_ft'
  AND sm.type IN ('table','view','index','trigger')
  AND (sm.name LIKE 'e01\_%' ESCAPE '\' OR sm.name LIKE 'e02\_%' ESCAPE '\' OR sm.name LIKE 'e03\_%' ESCAPE '\' OR sm.name LIKE 'e04\_%' ESCAPE '\');

INSERT OR IGNORE INTO e01_506_03_tb (element_name, element_layer, element_kind)
SELECT 'e02_404_01_ft', 'A', 'ft'
WHERE NOT EXISTS (SELECT 1 FROM e01_506_03_tb WHERE element_name='e02_404_01_ft');

UPDATE e01_506_03_tb SET element_code = element_name,
  element_level = CASE
    WHEN element_kind IN ('tb','ft') THEN 1
    WHEN element_kind = 'ix' THEN 2
    WHEN element_kind = 'tr' THEN 3
    WHEN element_kind = 'vw' THEN 4
    ELSE NULL
  END
WHERE element_code IS NULL;

-- ============ req_code (32) ============
INSERT OR IGNORE INTO e01_778_01_tb (need_uid, code, code_kind, label)
SELECT need_uid, need_uid, 'need', need_label FROM e01_506_01_tb;

-- ============ elem_req matrix (24) ============
INSERT OR IGNORE INTO e01_778_02_tb (element_name, need_uid, is_primary, is_driving, role) VALUES
('e03_312_01_tr','N12',1,1,'defines'),
('e03_312_01_tr','N13',0,0,'serves'),
('e03_312_01_tr','N14',0,0,'serves'),
('e03_312_02_tr','N12',1,1,'defines'),
('e03_112_01_tr','N13',1,1,'defines'),
('e03_120_04_tr','N10',1,1,'defines'),
('e03_120_05_tr','N10',1,1,'defines'),
('e03_120_01_tr','N11',1,1,'defines'),
('e03_122_01_tr','N11',1,1,'defines'),
('e03_122_02_tr','N11',1,1,'defines'),
('e03_126_01_tr','N11',1,0,'serves'),
('e03_126_03_tr','N11',1,0,'serves'),
('e03_135_01_tr','N15',1,1,'defines'),
('e03_434_01_tr','N41',1,1,'defines'),
('e03_343_01_tr','N31',1,1,'defines'),
('e03_320_01_tr','N30',1,1,'defines'),
('e04_310_02_vw','N30',1,0,'verifies'),
('e04_110_01_vw','N11',1,0,'verifies'),
('e04_200_01_vw','N20',1,0,'defines'),
('e04_267_01_vw','N20',1,0,'defines'),
('e04_978_01_vw','N99',1,0,'verifies'),
('e01_506_09_tb','N50',1,1,'defines'),
('e01_506_10_tb','N50',1,1,'defines'),
('e01_506_11_tb','N50',1,1,'defines');

-- ============ Semantic chains (5) ============
INSERT OR IGNORE INTO e01_778_03_tb (chain_uid, code, root_need_uid, label, purpose, chain_kind) VALUES
('CHN:REF:21','CHN-R21','N30','Ref chain','chk type','integrity'),
('CHN:ISA:CYC','CHN-ISA','N11','ISA chain','recursive detect','enforcement'),
('CHN:CLOS:SYNC','CHN-CLOS','N11','Closure chain','rebuild','integrity'),
('CHN:FTS:SYNC','CHN-FTS','N41','FTS chain','mirror','validation'),
('CHN:PRV:FALL','CHN-PRV','N31','Provenance chain','ensure prv','provenance');

-- ============ Chain steps (23) ============
INSERT OR IGNORE INTO e01_778_04_tb (chain_uid, ordinal, step_kind, element_name, description) VALUES
('CHN:REF:21',1,'source','e01_200_01_tb','source'),
('CHN:REF:21',2,'enforce','e03_120_04_tr','chk type'),
('CHN:REF:21',3,'enforce','e03_320_03_tr','protect'),
('CHN:REF:21',4,'verify','e04_310_02_vw','verify'),
('CHN:REF:21',5,'sink','e01_200_03_tb','sink'),
('CHN:FTS:SYNC',1,'source','e01_200_03_tb','source'),
('CHN:FTS:SYNC',2,'enforce','e03_434_01_tr','insert'),
('CHN:FTS:SYNC',3,'enforce','e03_434_03_tr','update'),
('CHN:FTS:SYNC',4,'enforce','e03_434_02_tr','delete'),
('CHN:FTS:SYNC',5,'sink','e02_404_01_ft','sink'),
('CHN:ISA:CYC',1,'source','e01_222_01_tb','source'),
('CHN:ISA:CYC',2,'enforce','e03_122_01_tr','insert'),
('CHN:ISA:CYC',3,'enforce','e03_122_02_tr','update'),
('CHN:ISA:CYC',4,'verify','e04_122_01_vw','verify'),
('CHN:CLOS:SYNC',1,'source','e01_200_01_tb','source'),
('CHN:CLOS:SYNC',2,'enforce','e03_120_02_tr','insert'),
('CHN:CLOS:SYNC',3,'enforce','e03_120_03_tr','update'),
('CHN:CLOS:SYNC',4,'verify','e04_110_01_vw','verify'),
('CHN:PRV:FALL',1,'source','e01_303_01_tb','source'),
('CHN:PRV:FALL',2,'enforce','e03_343_01_tr','fb ent'),
('CHN:PRV:FALL',3,'enforce','e03_343_02_tr','fb val'),
('CHN:PRV:FALL',4,'enforce','e03_343_03_tr','fb rel'),
('CHN:PRV:FALL',5,'enforce','e03_343_08_tr','protect');

-- ============ FTS rebuild ============
INSERT INTO e02_404_01_ft(e02_404_01_ft) VALUES('rebuild');

-- ============ Schema state ============
INSERT OR IGNORE INTO e01_676_02_tb (id, schema_ver) VALUES (1, 27);
UPDATE e01_676_02_tb SET schema_ver = 27, last_scan_at = datetime('now') WHERE id = 1;

INSERT OR IGNORE INTO e01_676_01_tb (migration_uid, notes) VALUES ('v26.0_final', 'Core DB v26.0 schema_ver=27');
