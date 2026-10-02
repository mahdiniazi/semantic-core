PRAGMA foreign_keys=OFF;
BEGIN TRANSACTION;
CREATE TABLE e01_506_01_tb(
    need_uid TEXT PRIMARY KEY, need_label TEXT NOT NULL,
    need_kind TEXT NOT NULL CHECK(need_kind IN ('user','system','domain','quality','performance')),
    need_statement TEXT, priority INTEGER NOT NULL DEFAULT 2 CHECK(priority IN (1,2,3)),
    status TEXT NOT NULL DEFAULT 'active' CHECK(status IN ('active','deferred','dropped')),
    created_at TEXT NOT NULL DEFAULT (datetime('now')));
INSERT INTO e01_506_01_tb VALUES('N00','Project scope','domain','ICE car electrical DTC',1,'active','2026-09-29 18:02:15');
INSERT INTO e01_506_01_tb VALUES('N01','Find vehicle by VIN','user','User finds vehicle via VIN',1,'active','2026-09-29 18:02:15');
INSERT INTO e01_506_01_tb VALUES('N02','Register case','user','Technician registers diagnostic case',1,'active','2026-09-29 18:02:15');
INSERT INTO e01_506_01_tb VALUES('N03','Text search','user','Find entity by label or description',2,'active','2026-09-29 18:02:15');
INSERT INTO e01_506_01_tb VALUES('N10','Prevent abstract instantiation','system','Instance must not be from abstract',1,'active','2026-09-29 18:02:15');
INSERT INTO e01_506_01_tb VALUES('N11','Prevent cycles','system','is_a and parent must not cycle',1,'active','2026-09-29 18:02:15');
INSERT INTO e01_506_01_tb VALUES('N12','Validate relation type','system','subject/object must comply',1,'active','2026-09-29 18:02:15');
INSERT INTO e01_506_01_tb VALUES('N13','Functional uniqueness','system','Functional not asserted twice',1,'active','2026-09-29 18:02:15');
INSERT INTO e01_506_01_tb VALUES('N14','instance_of uniqueness','system','Each instance has one concept',1,'active','2026-09-29 18:02:15');
INSERT INTO e01_506_01_tb VALUES('N15','Sync ctx_key','system','ctx_key matches context rows',1,'active','2026-09-29 18:02:15');
INSERT INTO e01_506_01_tb VALUES('N20','Model vehicle and unit','domain','Vehicle ECU Sensor Actuator Signal',1,'active','2026-09-29 18:02:15');
INSERT INTO e01_506_01_tb VALUES('N21','Model DTC','domain','DTC and its unit relation',1,'active','2026-09-29 18:02:15');
INSERT INTO e01_506_01_tb VALUES('N22','Diagnostic chain','domain','Observation to Repair',1,'active','2026-09-29 18:02:15');
INSERT INTO e01_506_01_tb VALUES('N23','Distinguish concept/instance','domain','Vehicle vs specific',1,'active','2026-09-29 18:02:15');
INSERT INTO e01_506_01_tb VALUES('N30','Referential integrity','quality','No orphan references',1,'active','2026-09-29 18:02:15');
INSERT INTO e01_506_01_tb VALUES('N31','Provenance tracking','quality','Each fact has source',2,'active','2026-09-29 18:02:15');
INSERT INTO e01_506_01_tb VALUES('N32','Contextualization','quality','Each claim has conditions',2,'active','2026-09-29 18:02:15');
INSERT INTO e01_506_01_tb VALUES('N33','Time versioning','quality','valid_from/valid_to',2,'active','2026-09-29 18:02:15');
INSERT INTO e01_506_01_tb VALUES('N34','Assertion history','quality','Claim lifecycle',3,'active','2026-09-29 18:02:15');
INSERT INTO e01_506_01_tb VALUES('N40','Fast lookup','performance','O(log n) common queries',2,'active','2026-09-29 18:02:15');
INSERT INTO e01_506_01_tb VALUES('N41','Fast FTS','performance','FTS5 label/desc',3,'active','2026-09-29 18:02:15');
INSERT INTO e01_506_01_tb VALUES('N42','Current state','performance','Latest state per entity',2,'active','2026-09-29 18:02:15');
INSERT INTO e01_506_01_tb VALUES('N50','Design language','quality','Living document',3,'active','2026-09-29 18:02:15');
INSERT INTO e01_506_01_tb VALUES('N51','Overlap analysis','quality','Detect shared needs',3,'active','2026-09-29 18:02:15');
INSERT INTO e01_506_01_tb VALUES('N52','Dead element detection','quality','Detect dead code',3,'active','2026-09-29 18:02:15');
INSERT INTO e01_506_01_tb VALUES('N60','Closure materialized','performance','Materialized closure',3,'deferred','2026-09-29 18:02:15');
INSERT INTO e01_506_01_tb VALUES('N61','Diagnostic procedures','domain','Procedures with branches',3,'deferred','2026-09-29 18:02:15');
INSERT INTO e01_506_01_tb VALUES('N62','Change log','quality','Auto observation on label',3,'deferred','2026-09-29 18:02:15');
INSERT INTO e01_506_01_tb VALUES('N63','Idempotent migration','quality','Delta runs twice safely',2,'deferred','2026-09-29 18:02:15');
INSERT INTO e01_506_01_tb VALUES('N70','Register need per element','quality','Each element has need',1,'active','2026-09-29 18:02:15');
INSERT INTO e01_506_01_tb VALUES('N71','Define chains','quality','Complex relations explicit',2,'active','2026-09-29 18:02:15');
INSERT INTO e01_506_01_tb VALUES('N99','Design phase end','quality','v26 design end',1,'active','2026-09-29 18:02:15');
CREATE TABLE e01_506_09_tb(verb_code TEXT PRIMARY KEY CHECK(verb_code GLOB '[0-9]'), label TEXT NOT NULL, description TEXT, sort_order INTEGER NOT NULL DEFAULT 0);
INSERT INTO e01_506_09_tb VALUES('0','PRS',NULL,10);
INSERT INTO e01_506_09_tb VALUES('1','VAL',NULL,20);
INSERT INTO e01_506_09_tb VALUES('2','PRV',NULL,30);
INSERT INTO e01_506_09_tb VALUES('3','SYN',NULL,40);
INSERT INTO e01_506_09_tb VALUES('4','TRC',NULL,50);
INSERT INTO e01_506_09_tb VALUES('5','PERF',NULL,60);
INSERT INTO e01_506_09_tb VALUES('6','EXT',NULL,70);
INSERT INTO e01_506_09_tb VALUES('7','META',NULL,80);
CREATE TABLE e01_506_10_tb(entity_code TEXT PRIMARY KEY, label TEXT NOT NULL, description TEXT, sort_order INTEGER NOT NULL DEFAULT 0);
INSERT INTO e01_506_10_tb VALUES('ENT','Entity',NULL,10);
INSERT INTO e01_506_10_tb VALUES('VAL','Value',NULL,20);
INSERT INTO e01_506_10_tb VALUES('REL','Relation',NULL,30);
INSERT INTO e01_506_10_tb VALUES('PRV','Provenance',NULL,40);
INSERT INTO e01_506_10_tb VALUES('FTS','FTS',NULL,50);
INSERT INTO e01_506_10_tb VALUES('CTX','Context',NULL,60);
INSERT INTO e01_506_10_tb VALUES('NOD','Node',NULL,70);
INSERT INTO e01_506_10_tb VALUES('VEH','Vehicle',NULL,80);
INSERT INTO e01_506_10_tb VALUES('REF','Reference',NULL,90);
INSERT INTO e01_506_10_tb VALUES('DTC','DTC',NULL,100);
INSERT INTO e01_506_10_tb VALUES('SUB','Subject',NULL,110);
INSERT INTO e01_506_10_tb VALUES('VW','View',NULL,120);
INSERT INTO e01_506_10_tb VALUES('LOGIC','Logic',NULL,130);
INSERT INTO e01_506_10_tb VALUES('SEED','Seed',NULL,140);
INSERT INTO e01_506_10_tb VALUES('FK','Foreign Key',NULL,150);
INSERT INTO e01_506_10_tb VALUES('TRG','Trigger',NULL,160);
INSERT INTO e01_506_10_tb VALUES('COL','Column',NULL,170);
INSERT INTO e01_506_10_tb VALUES('NULL','Null',NULL,180);
INSERT INTO e01_506_10_tb VALUES('TYP','Type',NULL,190);
INSERT INTO e01_506_10_tb VALUES('ISA','Is-a',NULL,200);
INSERT INTO e01_506_10_tb VALUES('CYC-TYP','CycleType',NULL,210);
INSERT INTO e01_506_10_tb VALUES('CYC-ISA','CycleIsA',NULL,220);
CREATE TABLE e01_506_11_tb(constraint_code TEXT PRIMARY KEY, label TEXT NOT NULL, description TEXT, sort_order INTEGER NOT NULL DEFAULT 0);
INSERT INTO e01_506_11_tb VALUES('NONEMPTY','Non-empty',NULL,10);
INSERT INTO e01_506_11_tb VALUES('TYPED','Typed',NULL,20);
INSERT INTO e01_506_11_tb VALUES('XOR','Xor',NULL,30);
INSERT INTO e01_506_11_tb VALUES('TYPE','Valid type',NULL,40);
INSERT INTO e01_506_11_tb VALUES('KIND','Valid kind',NULL,50);
INSERT INTO e01_506_11_tb VALUES('NOCYC','No cycle',NULL,60);
INSERT INTO e01_506_11_tb VALUES('CONSIST','Consistent',NULL,70);
INSERT INTO e01_506_11_tb VALUES('NOTNULL','Not null',NULL,80);
INSERT INTO e01_506_11_tb VALUES('FAST','Fast',NULL,90);
INSERT INTO e01_506_11_tb VALUES('DET','Deterministic',NULL,100);
INSERT INTO e01_506_11_tb VALUES('TREE','Tree',NULL,110);
INSERT INTO e01_506_11_tb VALUES('PAREN','Explicit parens',NULL,120);
INSERT INTO e01_506_11_tb VALUES('ONCE','Once',NULL,130);
INSERT INTO e01_506_11_tb VALUES('NOFK','No FK',NULL,140);
INSERT INTO e01_506_11_tb VALUES('GUARD','Guard',NULL,150);
INSERT INTO e01_506_11_tb VALUES('DOC','Documented',NULL,160);
INSERT INTO e01_506_11_tb VALUES('VER','Versioned',NULL,170);
INSERT INTO e01_506_11_tb VALUES('LINK','Linked',NULL,180);
INSERT INTO e01_506_11_tb VALUES('FKFIRST','FK first',NULL,190);
INSERT INTO e01_506_11_tb VALUES('NOCASC','No cascade',NULL,200);
INSERT INTO e01_506_11_tb VALUES('CHECK','Has check',NULL,210);
INSERT INTO e01_506_11_tb VALUES('fkref:11','FKref11',NULL,1011);
INSERT INTO e01_506_11_tb VALUES('fkref:12','FKref12',NULL,1012);
INSERT INTO e01_506_11_tb VALUES('fkref:13','FKref13',NULL,1013);
INSERT INTO e01_506_11_tb VALUES('fkref:16','FKref16',NULL,1016);
INSERT INTO e01_506_11_tb VALUES('fkref:21','FKref21',NULL,1021);
INSERT INTO e01_506_11_tb VALUES('fkref:17','FKref17',NULL,1017);
INSERT INTO e01_506_11_tb VALUES('fkref:20','FKref20',NULL,1020);
INSERT INTO e01_506_11_tb VALUES('fkref:25','FKref25',NULL,1025);
INSERT INTO e01_506_11_tb VALUES('fkref:29','FKref29',NULL,1029);
INSERT INTO e01_506_11_tb VALUES('fkref:30','FKref30',NULL,1030);
INSERT INTO e01_506_11_tb VALUES('fkref:32','FKref32',NULL,1032);
INSERT INTO e01_506_11_tb VALUES('fkref:34','FKref34',NULL,1034);
INSERT INTO e01_506_11_tb VALUES('fkref:35','FKref35',NULL,1035);
INSERT INTO e01_506_11_tb VALUES('fkref:39','FKref39',NULL,1039);
INSERT INTO e01_506_11_tb VALUES('fkref:43','FKref43',NULL,1043);
INSERT INTO e01_506_11_tb VALUES('fkref:46','FKref46',NULL,1046);
INSERT INTO e01_506_11_tb VALUES('fkref:47','FKref47',NULL,1047);
INSERT INTO e01_506_11_tb VALUES('fkref:49','FKref49',NULL,1049);
INSERT INTO e01_506_11_tb VALUES('fkref:51','FKref51',NULL,1051);
INSERT INTO e01_506_11_tb VALUES('fkref:52','FKref52',NULL,1052);
INSERT INTO e01_506_11_tb VALUES('fkref:23','FKref23',NULL,1023);
INSERT INTO e01_506_11_tb VALUES('fkref:18','FKref18',NULL,1018);
INSERT INTO e01_506_11_tb VALUES('fkref:19','FKref19',NULL,1019);
INSERT INTO e01_506_11_tb VALUES('fkref:31','FKref31',NULL,1031);
INSERT INTO e01_506_11_tb VALUES('fkref:36','FKref36',NULL,1036);
INSERT INTO e01_506_11_tb VALUES('fkref:38','FKref38',NULL,1038);
INSERT INTO e01_506_11_tb VALUES('fkref:40','FKref40',NULL,1040);
INSERT INTO e01_506_11_tb VALUES('fkref:44','FKref44',NULL,1044);
INSERT INTO e01_506_11_tb VALUES('fkref:14','FKref14',NULL,1014);
INSERT INTO e01_506_11_tb VALUES('fkref:15','FKref15',NULL,1015);
INSERT INTO e01_506_11_tb VALUES('fkref:26','FKref26',NULL,1026);
INSERT INTO e01_506_11_tb VALUES('fkref:28','FKref28',NULL,1028);
INSERT INTO e01_506_11_tb VALUES('fkref:42','FKref42',NULL,1042);
INSERT INTO e01_506_11_tb VALUES('fkref:27','FKref27',NULL,1027);
INSERT INTO e01_506_11_tb VALUES('fkref:22','FKref22',NULL,1022);
INSERT INTO e01_506_11_tb VALUES('fkref:24','FKref24',NULL,1024);
INSERT INTO e01_506_11_tb VALUES('fkref:33','FKref33',NULL,1033);
INSERT INTO e01_506_11_tb VALUES('fkref:37','FKref37',NULL,1037);
INSERT INTO e01_506_11_tb VALUES('fkref:41','FKref41',NULL,1041);
INSERT INTO e01_506_11_tb VALUES('fkref:45','FKref45',NULL,1045);
INSERT INTO e01_506_11_tb VALUES('fkref:48','FKref48',NULL,1048);
INSERT INTO e01_506_11_tb VALUES('fkref:50','FKref50',NULL,1050);
INSERT INTO e01_506_11_tb VALUES('fkref:53','FKref53',NULL,1053);
INSERT INTO e01_506_11_tb VALUES('fkref:1','FKref1',NULL,1001);
INSERT INTO e01_506_11_tb VALUES('fkref:3','FKref3',NULL,1003);
INSERT INTO e01_506_11_tb VALUES('fkref:7','FKref7',NULL,1007);
INSERT INTO e01_506_11_tb VALUES('fkref:54','FKref54',NULL,1054);
INSERT INTO e01_506_11_tb VALUES('fkref:57','FKref57',NULL,1057);
INSERT INTO e01_506_11_tb VALUES('fkref:59','FKref59',NULL,1059);
INSERT INTO e01_506_11_tb VALUES('fkref:62','FKref62',NULL,1062);
INSERT INTO e01_506_11_tb VALUES('fkref:2','FKref2',NULL,1002);
INSERT INTO e01_506_11_tb VALUES('fkref:4','FKref4',NULL,1004);
INSERT INTO e01_506_11_tb VALUES('fkref:5','FKref5',NULL,1005);
INSERT INTO e01_506_11_tb VALUES('fkref:56','FKref56',NULL,1056);
INSERT INTO e01_506_11_tb VALUES('fkref:61','FKref61',NULL,1061);
INSERT INTO e01_506_11_tb VALUES('fkref:6','FKref6',NULL,1006);
INSERT INTO e01_506_11_tb VALUES('fkref:9','FKref9',NULL,1009);
INSERT INTO e01_506_11_tb VALUES('fkref:8','FKref8',NULL,1008);
INSERT INTO e01_506_11_tb VALUES('fkref:10','FKref10',NULL,1010);
INSERT INTO e01_506_11_tb VALUES('fkref:63','FKref63',NULL,1063);
INSERT INTO e01_506_11_tb VALUES('fkref:64','FKref64',NULL,1064);
INSERT INTO e01_506_11_tb VALUES('fkref:65','FKref65',NULL,1065);
INSERT INTO e01_506_11_tb VALUES('fkref:55','FKref55',NULL,1055);
INSERT INTO e01_506_11_tb VALUES('fkref:58','FKref58',NULL,1058);
INSERT INTO e01_506_11_tb VALUES('fkref:60','FKref60',NULL,1060);
CREATE TABLE e01_506_02_tb(
    atom_uid TEXT PRIMARY KEY, category TEXT NOT NULL CHECK(category IN ('A','B','C','D','E','F','G','H','R')),
    origin TEXT NOT NULL DEFAULT 'design' CHECK(origin IN ('design','inferred','observed','derived')),
    statement TEXT NOT NULL, verb_code TEXT NOT NULL, entity_code TEXT NOT NULL,
    constraint_code TEXT, acceptance TEXT, verification TEXT,
    priority INTEGER NOT NULL DEFAULT 2 CHECK(priority IN (1,2,3)),
    status TEXT NOT NULL DEFAULT 'active' CHECK(status IN ('active','deferred','dropped')),
    created_at TEXT NOT NULL DEFAULT (datetime('now')),
    CONSTRAINT fk_atom_verb FOREIGN KEY (verb_code) REFERENCES e01_506_09_tb(verb_code) ON DELETE RESTRICT,
    CONSTRAINT fk_atom_entity FOREIGN KEY (entity_code) REFERENCES e01_506_10_tb(entity_code) ON DELETE RESTRICT,
    CONSTRAINT fk_atom_constraint FOREIGN KEY (constraint_code) REFERENCES e01_506_11_tb(constraint_code) ON DELETE RESTRICT);
INSERT INTO e01_506_02_tb VALUES('A01','A','design','Keep entities','0','ENT','NONEMPTY','e01_200_03_tb',NULL,2,'active','2026-09-29 18:02:15');
INSERT INTO e01_506_02_tb VALUES('A02','A','design','Keep values','0','VAL','TYPED','e01_201_02_tb',NULL,2,'active','2026-09-29 18:02:15');
INSERT INTO e01_506_02_tb VALUES('A03','A','design','Keep relations','0','REL','XOR','e01_222_01_tb',NULL,2,'active','2026-09-29 18:02:15');
INSERT INTO e01_506_02_tb VALUES('B06','B','design','Validate relation type','1','REL','TYPE','e03_312_01_tr',NULL,2,'active','2026-09-29 18:02:15');
INSERT INTO e01_506_02_tb VALUES('B10','B','design','Enforce object_kind','1','REL','KIND','e03_312_01_tr',NULL,2,'active','2026-09-29 18:02:15');
INSERT INTO e01_506_02_tb VALUES('C01','C','design','Prevent type cycle','2','CYC-TYP','NOCYC','e03_120_01_tr',NULL,2,'active','2026-09-29 18:02:15');
INSERT INTO e01_506_02_tb VALUES('C02','C','design','Prevent is_a cycle','2','CYC-ISA','NOCYC','e03_122_01_tr',NULL,2,'active','2026-09-29 18:02:15');
INSERT INTO e01_506_02_tb VALUES('D02','D','design','Sync FTS on insert','3','FTS','CONSIST','e03_434_01_tr',NULL,2,'active','2026-09-29 18:02:15');
INSERT INTO e01_506_02_tb VALUES('D05','D','design','Sync context_key','3','CTX','CONSIST','e03_135_01_tr',NULL,2,'active','2026-09-29 18:02:15');
INSERT INTO e01_506_02_tb VALUES('E01','E','design','Provenance fallback','4','PRV','NOTNULL','e03_343_01_tr',NULL,2,'active','2026-09-29 18:02:15');
INSERT INTO e01_506_02_tb VALUES('F03','F','design','FTS text search','5','FTS','FAST','e02_404_01_ft',NULL,2,'active','2026-09-29 18:02:15');
INSERT INTO e01_506_02_tb VALUES('G01','G','design','Vehicle report','6','VEH','DET','e04_267_01_vw',NULL,2,'active','2026-09-29 18:02:15');
INSERT INTO e01_506_02_tb VALUES('H05','H','design','Need tree','7','NOD','TREE','e01_506_06_tb',NULL,2,'active','2026-09-29 18:02:15');
INSERT INTO e01_506_02_tb VALUES('I01','B','inferred','Any lookup non-NULL or ABORT','1','SUB','NOTNULL','seed',NULL,2,'active','2026-09-29 18:02:15');
INSERT INTO e01_506_02_tb VALUES('I02','B','inferred','Diagnostic view parens','1','VW','PAREN','view drift',NULL,2,'active','2026-09-29 18:02:15');
INSERT INTO e01_506_02_tb VALUES('I03','H','inferred','Shared logic once','1','LOGIC','ONCE','no dup',NULL,2,'active','2026-09-29 18:02:15');
INSERT INTO e01_506_02_tb VALUES('I04','H','inferred','No seed trace on FK','1','SEED','NOFK','traces after',NULL,2,'active','2026-09-29 18:02:15');
INSERT INTO e01_506_02_tb VALUES('I05','A','inferred','Each FK has trigger','1','FK','GUARD','guards active',NULL,2,'active','2026-09-29 18:02:15');
INSERT INTO e01_506_02_tb VALUES('I06','H','inferred','Each view docs check','7','VW','DOC','meta',NULL,2,'active','2026-09-29 18:02:15');
INSERT INTO e01_506_02_tb VALUES('I07','H','inferred','Min SQLite version','7','VW','VER','meta.notes',NULL,2,'active','2026-09-29 18:02:15');
INSERT INTO e01_506_02_tb VALUES('I08','H','inferred','Need-atom explicit','7','NOD','LINK','e01_516_01_tb',NULL,2,'active','2026-09-29 18:02:15');
INSERT INTO e01_506_02_tb VALUES('I09','B','inferred','Triggers check semantic','1','TRG','FKFIRST','ABORT',NULL,2,'active','2026-09-29 18:02:15');
INSERT INTO e01_506_02_tb VALUES('I10','B','inferred','Triggers no cascade','1','TRG','NOCASC','single upd',NULL,2,'active','2026-09-29 18:02:15');
INSERT INTO e01_506_02_tb VALUES('I11','B','inferred','Each column has CHECK','1','COL','CHECK','cat A-H',NULL,2,'active','2026-09-29 18:02:15');
INSERT INTO e01_506_02_tb VALUES('I12','H','inferred','Explicit NULL','7','NULL','DOC','view',NULL,2,'active','2026-09-29 18:02:15');
INSERT INTO e01_506_02_tb VALUES('I13','H','inferred','Trigger cost in meta','7','TRG','PERF','warning',NULL,2,'active','2026-09-29 18:02:15');
INSERT INTO e01_506_02_tb VALUES('R01','R','design','e01_516_01_tb.need_uid to e01_506_01_tb.need_uid','1','REF','fkref:1','meta',NULL,2,'active','2026-09-29 18:02:15');
INSERT INTO e01_506_02_tb VALUES('R02','R','design','e01_516_01_tb.atom_uid to e01_506_02_tb.atom_uid','1','REF','fkref:2','meta',NULL,2,'active','2026-09-29 18:02:15');
INSERT INTO e01_506_02_tb VALUES('R03','R','design','e01_506_03_tb.need_uid to e01_506_01_tb.need_uid','1','REF','fkref:3','meta',NULL,2,'active','2026-09-29 18:02:15');
INSERT INTO e01_506_02_tb VALUES('R04','R','design','e01_506_04_tb.atom_uid to e01_506_02_tb.atom_uid','1','REF','fkref:4','meta',NULL,2,'active','2026-09-29 18:02:15');
INSERT INTO e01_506_02_tb VALUES('R05','R','design','e01_506_04_tb.element_name to e01_506_03_tb.element_name','1','REF','fkref:5','meta',NULL,2,'active','2026-09-29 18:02:15');
INSERT INTO e01_506_02_tb VALUES('R06','R','design','e01_506_05_tb.parent_uid to e01_506_05_tb.question_uid','1','REF','fkref:6','meta',NULL,2,'active','2026-09-29 18:02:15');
INSERT INTO e01_506_02_tb VALUES('R07','R','design','e01_506_06_tb.need_uid to e01_506_01_tb.need_uid','1','REF','fkref:7','meta',NULL,2,'active','2026-09-29 18:02:15');
INSERT INTO e01_506_02_tb VALUES('R08','R','design','e01_506_06_tb.parent_id to e01_506_06_tb.node_id','1','REF','fkref:8','meta',NULL,2,'active','2026-09-29 18:02:15');
INSERT INTO e01_506_02_tb VALUES('R09','R','design','e01_506_06_tb.question_uid to e01_506_05_tb.question_uid','1','REF','fkref:9','meta',NULL,2,'active','2026-09-29 18:02:15');
INSERT INTO e01_506_02_tb VALUES('R10','R','design','e01_506_08_tb.dim_uid to e01_506_07_tb.dim_uid','1','REF','fkref:10','meta',NULL,2,'active','2026-09-29 18:02:15');
INSERT INTO e01_506_02_tb VALUES('R11','R','design','e01_200_01_tb.parent_id to e01_200_01_tb.type_id','1','REF','fkref:11','meta',NULL,2,'active','2026-09-29 18:02:15');
INSERT INTO e01_506_02_tb VALUES('R12','R','design','e01_120_01_tb.desc_id to e01_200_01_tb.type_id','1','REF','fkref:12','meta',NULL,2,'active','2026-09-29 18:02:15');
INSERT INTO e01_506_02_tb VALUES('R13','R','design','e01_120_01_tb.anc_id to e01_200_01_tb.type_id','1','REF','fkref:13','meta',NULL,2,'active','2026-09-29 18:02:15');
INSERT INTO e01_506_02_tb VALUES('R14','R','design','e01_202_01_tb.inverse_uid to e01_202_01_tb.type_uid','1','REF','fkref:14','meta',NULL,2,'active','2026-09-29 18:02:15');
INSERT INTO e01_506_02_tb VALUES('R15','R','design','e01_112_01_tb.reltype_id to e01_202_01_tb.reltype_id','1','REF','fkref:15','meta',NULL,2,'active','2026-09-29 18:02:15');
INSERT INTO e01_506_02_tb VALUES('R16','R','design','e01_112_01_tb.target_type_id to e01_200_01_tb.type_id','1','REF','fkref:16','meta',NULL,2,'active','2026-09-29 18:02:15');
INSERT INTO e01_506_02_tb VALUES('R17','R','design','e01_201_01_tb.dom_id to e01_200_02_tb.dom_id','1','REF','fkref:17','meta',NULL,2,'active','2026-09-29 18:02:15');
INSERT INTO e01_506_02_tb VALUES('R18','R','design','e01_201_03_tb.parent_id to e01_201_02_tb.val_id','1','REF','fkref:18','meta',NULL,2,'active','2026-09-29 18:02:15');
INSERT INTO e01_506_02_tb VALUES('R19','R','design','e01_201_03_tb.member_val_id to e01_201_02_tb.val_id','1','REF','fkref:19','meta',NULL,2,'active','2026-09-29 18:02:15');
INSERT INTO e01_506_02_tb VALUES('R20','R','design','e01_201_03_tb.member_ent_id to e01_200_03_tb.ent_id','1','REF','fkref:20','meta',NULL,2,'active','2026-09-29 18:02:15');
INSERT INTO e01_506_02_tb VALUES('R21','R','design','e01_200_03_tb.type_id to e01_200_01_tb.type_id','1','REF','fkref:21','meta',NULL,2,'active','2026-09-29 18:02:15');
INSERT INTO e01_506_02_tb VALUES('R22','R','design','e01_200_03_tb.prv_id to e01_303_01_tb.prv_id','1','REF','fkref:22','meta',NULL,2,'active','2026-09-29 18:02:15');
INSERT INTO e01_506_02_tb VALUES('R23','R','design','e01_201_02_tb.enum_id to e01_201_01_tb.val_id','1','REF','fkref:23','meta',NULL,2,'active','2026-09-29 18:02:15');
INSERT INTO e01_506_02_tb VALUES('R24','R','design','e01_201_02_tb.prv_id to e01_303_01_tb.prv_id','1','REF','fkref:24','meta',NULL,2,'active','2026-09-29 18:02:15');
INSERT INTO e01_506_02_tb VALUES('R25','R','design','e01_302_01_tb.subj_ent_id to e01_200_03_tb.ent_id','1','REF','fkref:25','meta',NULL,2,'active','2026-09-29 18:02:15');
INSERT INTO e01_506_02_tb VALUES('R26','R','design','e01_302_01_tb.reltype_id to e01_202_01_tb.reltype_id','1','REF','fkref:26','meta',NULL,2,'active','2026-09-29 18:02:15');
INSERT INTO e01_506_02_tb VALUES('R27','R','design','e01_222_01_tb.lin_id to e01_302_01_tb.lin_id','1','REF','fkref:27','meta',NULL,2,'active','2026-09-29 18:02:15');
INSERT INTO e01_506_02_tb VALUES('R28','R','design','e01_222_01_tb.reltype_id to e01_202_01_tb.reltype_id','1','REF','fkref:28','meta',NULL,2,'active','2026-09-29 18:02:15');
INSERT INTO e01_506_02_tb VALUES('R29','R','design','e01_222_01_tb.subj_ent_id to e01_200_03_tb.ent_id','1','REF','fkref:29','meta',NULL,2,'active','2026-09-29 18:02:15');
INSERT INTO e01_506_02_tb VALUES('R30','R','design','e01_222_01_tb.obj_ent_id to e01_200_03_tb.ent_id','1','REF','fkref:30','meta',NULL,2,'active','2026-09-29 18:02:15');
INSERT INTO e01_506_02_tb VALUES('R31','R','design','e01_222_01_tb.obj_val_id to e01_201_02_tb.val_id','1','REF','fkref:31','meta',NULL,2,'active','2026-09-29 18:02:15');
INSERT INTO e01_506_02_tb VALUES('R32','R','design','e01_222_01_tb.reif_ent_id to e01_200_03_tb.ent_id','1','REF','fkref:32','meta',NULL,2,'active','2026-09-29 18:02:15');
INSERT INTO e01_506_02_tb VALUES('R33','R','design','e01_222_01_tb.prv_id to e01_303_01_tb.prv_id','1','REF','fkref:33','meta',NULL,2,'active','2026-09-29 18:02:15');
INSERT INTO e01_506_02_tb VALUES('R34','R','design','e01_305_01_tb.ent_id to e01_200_03_tb.ent_id','1','REF','fkref:34','meta',NULL,2,'active','2026-09-29 18:02:15');
INSERT INTO e01_506_02_tb VALUES('R35','R','design','e01_305_01_tb.ctx_ent_id to e01_200_03_tb.ent_id','1','REF','fkref:35','meta',NULL,2,'active','2026-09-29 18:02:15');
INSERT INTO e01_506_02_tb VALUES('R36','R','design','e01_305_01_tb.ctx_val_id to e01_201_02_tb.val_id','1','REF','fkref:36','meta',NULL,2,'active','2026-09-29 18:02:15');
INSERT INTO e01_506_02_tb VALUES('R37','R','design','e01_305_01_tb.prv_id to e01_303_01_tb.prv_id','1','REF','fkref:37','meta',NULL,2,'active','2026-09-29 18:02:15');
INSERT INTO e01_506_02_tb VALUES('R38','R','design','e01_305_02_tb.val_id to e01_201_02_tb.val_id','1','REF','fkref:38','meta',NULL,2,'active','2026-09-29 18:02:15');
INSERT INTO e01_506_02_tb VALUES('R39','R','design','e01_305_02_tb.ctx_ent_id to e01_200_03_tb.ent_id','1','REF','fkref:39','meta',NULL,2,'active','2026-09-29 18:02:15');
INSERT INTO e01_506_02_tb VALUES('R40','R','design','e01_305_02_tb.ctx_val_id to e01_201_02_tb.val_id','1','REF','fkref:40','meta',NULL,2,'active','2026-09-29 18:02:15');
INSERT INTO e01_506_02_tb VALUES('R41','R','design','e01_305_02_tb.prv_id to e01_303_01_tb.prv_id','1','REF','fkref:41','meta',NULL,2,'active','2026-09-29 18:02:15');
INSERT INTO e01_506_02_tb VALUES('R42','R','design','e01_305_03_tb.rel_id to e01_222_01_tb.rel_id','1','REF','fkref:42','meta',NULL,2,'active','2026-09-29 18:02:15');
INSERT INTO e01_506_02_tb VALUES('R43','R','design','e01_305_03_tb.ctx_ent_id to e01_200_03_tb.ent_id','1','REF','fkref:43','meta',NULL,2,'active','2026-09-29 18:02:15');
INSERT INTO e01_506_02_tb VALUES('R44','R','design','e01_305_03_tb.ctx_val_id to e01_201_02_tb.val_id','1','REF','fkref:44','meta',NULL,2,'active','2026-09-29 18:02:15');
INSERT INTO e01_506_02_tb VALUES('R45','R','design','e01_305_03_tb.prv_id to e01_303_01_tb.prv_id','1','REF','fkref:45','meta',NULL,2,'active','2026-09-29 18:02:15');
INSERT INTO e01_506_02_tb VALUES('R46','R','design','e01_300_01_tb.ent_a_id to e01_200_03_tb.ent_id','1','REF','fkref:46','meta',NULL,2,'active','2026-09-29 18:02:15');
INSERT INTO e01_506_02_tb VALUES('R47','R','design','e01_300_01_tb.ent_b_id to e01_200_03_tb.ent_id','1','REF','fkref:47','meta',NULL,2,'active','2026-09-29 18:02:15');
INSERT INTO e01_506_02_tb VALUES('R48','R','design','e01_300_01_tb.prv_id to e01_303_01_tb.prv_id','1','REF','fkref:48','meta',NULL,2,'active','2026-09-29 18:02:15');
INSERT INTO e01_506_02_tb VALUES('R49','R','design','e01_330_01_tb.ent_id to e01_200_03_tb.ent_id','1','REF','fkref:49','meta',NULL,2,'active','2026-09-29 18:02:15');
INSERT INTO e01_506_02_tb VALUES('R50','R','design','e01_330_01_tb.supersedes_id to e01_330_01_tb.vers_id','1','REF','fkref:50','meta',NULL,2,'active','2026-09-29 18:02:15');
INSERT INTO e01_506_02_tb VALUES('R51','R','design','e01_330_01_tb.approved_by_id to e01_200_03_tb.ent_id','1','REF','fkref:51','meta',NULL,2,'active','2026-09-29 18:02:15');
INSERT INTO e01_506_02_tb VALUES('R52','R','design','e01_330_02_tb.ent_id to e01_200_03_tb.ent_id','1','REF','fkref:52','meta',NULL,2,'active','2026-09-29 18:02:15');
INSERT INTO e01_506_02_tb VALUES('R53','R','design','e01_330_02_tb.vers_id to e01_330_01_tb.vers_id','1','REF','fkref:53','meta',NULL,2,'active','2026-09-29 18:02:15');
INSERT INTO e01_506_02_tb VALUES('R54','R','design','e01_778_01_tb.need_uid to e01_506_01_tb.need_uid','1','REF','fkref:54','meta',NULL,2,'active','2026-09-29 18:02:15');
INSERT INTO e01_506_02_tb VALUES('R55','R','design','e01_778_01_tb.parent_code to e01_778_01_tb.code','1','REF','fkref:55','meta',NULL,2,'active','2026-09-29 18:02:15');
INSERT INTO e01_506_02_tb VALUES('R56','R','design','e01_778_02_tb.element_name to e01_506_03_tb.element_name','1','REF','fkref:56','meta',NULL,2,'active','2026-09-29 18:02:15');
INSERT INTO e01_506_02_tb VALUES('R57','R','design','e01_778_02_tb.need_uid to e01_506_01_tb.need_uid','1','REF','fkref:57','meta',NULL,2,'active','2026-09-29 18:02:15');
INSERT INTO e01_506_02_tb VALUES('R58','R','design','e01_778_02_tb.code to e01_778_01_tb.code','1','REF','fkref:58','meta',NULL,2,'active','2026-09-29 18:02:15');
INSERT INTO e01_506_02_tb VALUES('R59','R','design','e01_778_03_tb.root_need_uid to e01_506_01_tb.need_uid','1','REF','fkref:59','meta',NULL,2,'active','2026-09-29 18:02:15');
INSERT INTO e01_506_02_tb VALUES('R60','R','design','e01_778_04_tb.chain_uid to e01_778_03_tb.chain_uid','1','REF','fkref:60','meta',NULL,2,'active','2026-09-29 18:02:15');
INSERT INTO e01_506_02_tb VALUES('R61','R','design','e01_778_04_tb.element_name to e01_506_03_tb.element_name','1','REF','fkref:61','meta',NULL,2,'active','2026-09-29 18:02:15');
INSERT INTO e01_506_02_tb VALUES('R62','R','design','e01_778_04_tb.need_uid to e01_506_01_tb.need_uid','1','REF','fkref:62','meta',NULL,2,'active','2026-09-29 18:02:15');
INSERT INTO e01_506_02_tb VALUES('R63','R','design','e01_506_02_tb.verb_code to e01_506_09_tb.verb_code','1','REF','fkref:63','meta',NULL,2,'active','2026-09-29 18:02:15');
INSERT INTO e01_506_02_tb VALUES('R64','R','design','e01_506_02_tb.entity_code to e01_506_10_tb.entity_code','1','REF','fkref:64','meta',NULL,2,'active','2026-09-29 18:02:15');
INSERT INTO e01_506_02_tb VALUES('R65','R','design','e01_506_02_tb.constraint_code to e01_506_11_tb.constraint_code','1','REF','fkref:65','meta',NULL,2,'active','2026-09-29 18:02:15');
CREATE TABLE e01_506_03_tb(
    element_name TEXT PRIMARY KEY, element_code TEXT UNIQUE,
    element_level INTEGER CHECK(element_level IN (1,2,3,4)),
    element_layer TEXT NOT NULL CHECK(element_layer IN ('M','T','C','X','I','V','A')),
    element_kind TEXT NOT NULL CHECK(element_kind IN ('tb','tr','vw','ix','ft')),
    need_uid TEXT, purpose TEXT, notes TEXT, created_at TEXT NOT NULL DEFAULT (datetime('now')),
    CHECK (element_code IS NULL OR element_code GLOB 'e[0-9][0-9]_[0-9][0-9][0-9]_[0-9][0-9]_[a-z][a-z]'),
    CONSTRAINT fk_ele_need FOREIGN KEY (need_uid) REFERENCES e01_506_01_tb(need_uid) ON DELETE RESTRICT);
INSERT INTO e01_506_03_tb VALUES('e01_506_01_tb','e01_506_01_tb',1,'M','tb',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e01_506_09_tb','e01_506_09_tb',1,'M','tb',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e01_506_10_tb','e01_506_10_tb',1,'M','tb',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e01_506_11_tb','e01_506_11_tb',1,'M','tb',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e01_506_02_tb','e01_506_02_tb',1,'M','tb',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e02_506_10_ix','e02_506_10_ix',2,'M','ix',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e02_506_11_ix','e02_506_11_ix',2,'M','ix',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e02_506_12_ix','e02_506_12_ix',2,'M','ix',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e02_506_13_ix','e02_506_13_ix',2,'M','ix',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e02_506_14_ix','e02_506_14_ix',2,'M','ix',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e01_516_01_tb','e01_516_01_tb',1,'M','tb',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e02_516_10_ix','e02_516_10_ix',2,'M','ix',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e02_516_11_ix','e02_516_11_ix',2,'M','ix',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e01_506_03_tb','e01_506_03_tb',1,'M','tb',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e02_506_15_ix','e02_506_15_ix',2,'M','ix',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e02_506_16_ix','e02_506_16_ix',2,'M','ix',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e02_506_17_ix','e02_506_17_ix',2,'M','ix',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e01_506_04_tb','e01_506_04_tb',1,'M','tb',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e02_506_18_ix','e02_506_18_ix',2,'M','ix',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e02_506_19_ix','e02_506_19_ix',2,'M','ix',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e01_506_05_tb','e01_506_05_tb',1,'M','tb',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e02_506_20_ix','e02_506_20_ix',2,'M','ix',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e01_506_06_tb','e01_506_06_tb',1,'M','tb',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e02_506_21_ix','e02_506_21_ix',2,'M','ix',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e02_506_22_ix','e02_506_22_ix',2,'M','ix',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e02_506_23_ix','e02_506_23_ix',2,'M','ix',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e02_506_24_ix','e02_506_24_ix',2,'M','ix',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e01_676_01_tb','e01_676_01_tb',1,'M','tb',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e01_676_02_tb','e01_676_02_tb',1,'M','tb',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e01_676_03_tb','e01_676_03_tb',1,'M','tb',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e01_378_01_tb','e01_378_01_tb',1,'M','tb',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e02_378_10_ix','e02_378_10_ix',2,'M','ix',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e02_378_11_ix','e02_378_11_ix',2,'M','ix',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e01_506_07_tb','e01_506_07_tb',1,'M','tb',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e01_506_08_tb','e01_506_08_tb',1,'M','tb',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e02_506_25_ix','e02_506_25_ix',2,'M','ix',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e01_778_01_tb','e01_778_01_tb',1,'M','tb',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e02_778_10_ix','e02_778_10_ix',2,'M','ix',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e02_778_11_ix','e02_778_11_ix',2,'M','ix',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e02_778_12_ix','e02_778_12_ix',2,'M','ix',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e01_778_02_tb','e01_778_02_tb',1,'M','tb',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e02_778_20_ix','e02_778_20_ix',2,'M','ix',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e02_778_21_ix','e02_778_21_ix',2,'M','ix',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e02_778_22_ix','e02_778_22_ix',2,'M','ix',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e02_778_23_ix','e02_778_23_ix',2,'M','ix',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e01_778_03_tb','e01_778_03_tb',1,'M','tb',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e02_778_30_ix','e02_778_30_ix',2,'M','ix',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e02_778_31_ix','e02_778_31_ix',2,'M','ix',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e01_778_04_tb','e01_778_04_tb',1,'M','tb',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e02_778_40_ix','e02_778_40_ix',2,'M','ix',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e02_778_41_ix','e02_778_41_ix',2,'M','ix',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e02_778_42_ix','e02_778_42_ix',2,'M','ix',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e01_200_01_tb','e01_200_01_tb',1,'T','tb',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e02_200_10_ix','e02_200_10_ix',2,'M','ix',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e01_120_01_tb','e01_120_01_tb',1,'T','tb',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e02_120_10_ix','e02_120_10_ix',2,'M','ix',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e01_202_01_tb','e01_202_01_tb',1,'T','tb',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e02_202_10_ix','e02_202_10_ix',2,'M','ix',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e02_202_11_ix','e02_202_11_ix',2,'M','ix',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e01_112_01_tb','e01_112_01_tb',1,'T','tb',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e02_112_10_ix','e02_112_10_ix',2,'M','ix',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e02_112_11_ix','e02_112_11_ix',2,'M','ix',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e02_112_12_ix','e02_112_12_ix',2,'M','ix',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e02_112_13_ix','e02_112_13_ix',2,'M','ix',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e01_200_02_tb','e01_200_02_tb',1,'T','tb',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e01_201_01_tb','e01_201_01_tb',1,'T','tb',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e02_201_10_ix','e02_201_10_ix',2,'M','ix',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e01_303_01_tb','e01_303_01_tb',1,'C','tb',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e02_303_10_ix','e02_303_10_ix',2,'M','ix',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e02_303_11_ix','e02_303_11_ix',2,'M','ix',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e02_303_12_ix','e02_303_12_ix',2,'M','ix',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e01_200_03_tb','e01_200_03_tb',1,'C','tb',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e02_200_20_ix','e02_200_20_ix',2,'M','ix',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e02_200_21_ix','e02_200_21_ix',2,'M','ix',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e02_200_22_ix','e02_200_22_ix',2,'M','ix',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e02_200_23_ix','e02_200_23_ix',2,'M','ix',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e02_200_24_ix','e02_200_24_ix',2,'M','ix',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e01_201_02_tb','e01_201_02_tb',1,'C','tb',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e02_201_20_ix','e02_201_20_ix',2,'M','ix',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e02_201_21_ix','e02_201_21_ix',2,'M','ix',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e02_201_22_ix','e02_201_22_ix',2,'M','ix',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e02_201_23_ix','e02_201_23_ix',2,'M','ix',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e02_201_24_ix','e02_201_24_ix',2,'M','ix',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e02_201_25_ix','e02_201_25_ix',2,'M','ix',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e01_201_03_tb','e01_201_03_tb',1,'C','tb',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e02_201_30_ix','e02_201_30_ix',2,'M','ix',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e02_201_31_ix','e02_201_31_ix',2,'M','ix',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e02_201_32_ix','e02_201_32_ix',2,'M','ix',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e01_302_01_tb','e01_302_01_tb',1,'C','tb',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e02_302_10_ix','e02_302_10_ix',2,'M','ix',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e02_302_11_ix','e02_302_11_ix',2,'M','ix',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e01_222_01_tb','e01_222_01_tb',1,'C','tb',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e02_222_10_ix','e02_222_10_ix',2,'M','ix',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e02_222_11_ix','e02_222_11_ix',2,'M','ix',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e02_222_12_ix','e02_222_12_ix',2,'M','ix',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e02_222_13_ix','e02_222_13_ix',2,'M','ix',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e02_222_14_ix','e02_222_14_ix',2,'M','ix',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e02_222_15_ix','e02_222_15_ix',2,'M','ix',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e02_222_16_ix','e02_222_16_ix',2,'M','ix',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e02_222_17_ix','e02_222_17_ix',2,'M','ix',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e02_222_18_ix','e02_222_18_ix',2,'M','ix',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e02_222_19_ix','e02_222_19_ix',2,'M','ix',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e02_222_20_ix','e02_222_20_ix',2,'M','ix',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e01_305_01_tb','e01_305_01_tb',1,'X','tb',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e02_305_10_ix','e02_305_10_ix',2,'M','ix',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e02_305_11_ix','e02_305_11_ix',2,'M','ix',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e02_305_12_ix','e02_305_12_ix',2,'M','ix',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e01_305_02_tb','e01_305_02_tb',1,'X','tb',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e02_305_20_ix','e02_305_20_ix',2,'M','ix',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e02_305_21_ix','e02_305_21_ix',2,'M','ix',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e02_305_22_ix','e02_305_22_ix',2,'M','ix',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e01_305_03_tb','e01_305_03_tb',1,'X','tb',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e02_305_30_ix','e02_305_30_ix',2,'M','ix',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e02_305_31_ix','e02_305_31_ix',2,'M','ix',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e02_305_32_ix','e02_305_32_ix',2,'M','ix',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e01_300_01_tb','e01_300_01_tb',1,'I','tb',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e02_300_10_ix','e02_300_10_ix',2,'M','ix',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e02_300_11_ix','e02_300_11_ix',2,'M','ix',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e02_300_12_ix','e02_300_12_ix',2,'M','ix',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e02_300_13_ix','e02_300_13_ix',2,'M','ix',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e01_330_01_tb','e01_330_01_tb',1,'V','tb',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e02_330_10_ix','e02_330_10_ix',2,'M','ix',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e01_330_02_tb','e01_330_02_tb',1,'V','tb',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e02_330_20_ix','e02_330_20_ix',2,'M','ix',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e02_330_21_ix','e02_330_21_ix',2,'M','ix',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e03_312_01_tr','e03_312_01_tr',3,'M','tr',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e03_312_02_tr','e03_312_02_tr',3,'M','tr',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e03_112_01_tr','e03_112_01_tr',3,'M','tr',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e03_135_01_tr','e03_135_01_tr',3,'M','tr',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e03_135_02_tr','e03_135_02_tr',3,'M','tr',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e03_135_03_tr','e03_135_03_tr',3,'M','tr',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e03_343_01_tr','e03_343_01_tr',3,'M','tr',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e03_343_02_tr','e03_343_02_tr',3,'M','tr',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e03_343_03_tr','e03_343_03_tr',3,'M','tr',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e03_343_04_tr','e03_343_04_tr',3,'M','tr',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e03_343_05_tr','e03_343_05_tr',3,'M','tr',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e03_343_06_tr','e03_343_06_tr',3,'M','tr',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e03_343_07_tr','e03_343_07_tr',3,'M','tr',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e03_343_08_tr','e03_343_08_tr',3,'M','tr',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e03_343_09_tr','e03_343_09_tr',3,'M','tr',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e03_311_01_tr','e03_311_01_tr',3,'M','tr',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e03_311_02_tr','e03_311_02_tr',3,'M','tr',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e03_311_03_tr','e03_311_03_tr',3,'M','tr',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e03_311_04_tr','e03_311_04_tr',3,'M','tr',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e03_516_01_tr','e03_516_01_tr',3,'M','tr',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e03_516_02_tr','e03_516_02_tr',3,'M','tr',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e03_126_01_tr','e03_126_01_tr',3,'M','tr',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e03_126_02_tr','e03_126_02_tr',3,'M','tr',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e03_126_03_tr','e03_126_03_tr',3,'M','tr',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e03_320_01_tr','e03_320_01_tr',3,'M','tr',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e03_320_02_tr','e03_320_02_tr',3,'M','tr',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e03_320_03_tr','e03_320_03_tr',3,'M','tr',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e03_320_04_tr','e03_320_04_tr',3,'M','tr',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e03_320_05_tr','e03_320_05_tr',3,'M','tr',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e03_320_06_tr','e03_320_06_tr',3,'M','tr',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e03_320_07_tr','e03_320_07_tr',3,'M','tr',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e03_320_08_tr','e03_320_08_tr',3,'M','tr',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e03_320_09_tr','e03_320_09_tr',3,'M','tr',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e03_370_30_tr','e03_370_30_tr',3,'M','tr',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e03_370_32_tr','e03_370_32_tr',3,'M','tr',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e03_370_33_tr','e03_370_33_tr',3,'M','tr',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e03_370_34_tr','e03_370_34_tr',3,'M','tr',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e03_360_01_tr','e03_360_01_tr',3,'M','tr',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e03_370_01_tr','e03_370_01_tr',3,'M','tr',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e03_370_02_tr','e03_370_02_tr',3,'M','tr',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e03_370_03_tr','e03_370_03_tr',3,'M','tr',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e03_370_04_tr','e03_370_04_tr',3,'M','tr',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e03_370_05_tr','e03_370_05_tr',3,'M','tr',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e03_370_06_tr','e03_370_06_tr',3,'M','tr',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e03_370_07_tr','e03_370_07_tr',3,'M','tr',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e03_370_08_tr','e03_370_08_tr',3,'M','tr',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e03_370_11_tr','e03_370_11_tr',3,'M','tr',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e03_370_12_tr','e03_370_12_tr',3,'M','tr',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e03_370_13_tr','e03_370_13_tr',3,'M','tr',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e03_370_14_tr','e03_370_14_tr',3,'M','tr',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e03_370_15_tr','e03_370_15_tr',3,'M','tr',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e03_370_16_tr','e03_370_16_tr',3,'M','tr',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e03_370_17_tr','e03_370_17_tr',3,'M','tr',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e03_370_18_tr','e03_370_18_tr',3,'M','tr',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e03_370_21_tr','e03_370_21_tr',3,'M','tr',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e03_370_22_tr','e03_370_22_tr',3,'M','tr',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e03_370_23_tr','e03_370_23_tr',3,'M','tr',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e03_370_24_tr','e03_370_24_tr',3,'M','tr',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e03_370_25_tr','e03_370_25_tr',3,'M','tr',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e03_370_26_tr','e03_370_26_tr',3,'M','tr',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e03_310_03_tr','e03_310_03_tr',3,'M','tr',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e03_310_04_tr','e03_310_04_tr',3,'M','tr',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e03_310_05_tr','e03_310_05_tr',3,'M','tr',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e03_310_06_tr','e03_310_06_tr',3,'M','tr',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e03_328_01_tr','e03_328_01_tr',3,'M','tr',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e03_328_02_tr','e03_328_02_tr',3,'M','tr',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e03_328_03_tr','e03_328_03_tr',3,'M','tr',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e03_328_04_tr','e03_328_04_tr',3,'M','tr',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e03_328_05_tr','e03_328_05_tr',3,'M','tr',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e03_328_06_tr','e03_328_06_tr',3,'M','tr',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e03_328_07_tr','e03_328_07_tr',3,'M','tr',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e03_328_08_tr','e03_328_08_tr',3,'M','tr',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e03_328_09_tr','e03_328_09_tr',3,'M','tr',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e03_328_10_tr','e03_328_10_tr',3,'M','tr',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e03_328_11_tr','e03_328_11_tr',3,'M','tr',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e03_328_12_tr','e03_328_12_tr',3,'M','tr',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e03_328_13_tr','e03_328_13_tr',3,'M','tr',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e03_328_14_tr','e03_328_14_tr',3,'M','tr',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e03_328_15_tr','e03_328_15_tr',3,'M','tr',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e03_328_16_tr','e03_328_16_tr',3,'M','tr',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e03_328_17_tr','e03_328_17_tr',3,'M','tr',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e03_328_18_tr','e03_328_18_tr',3,'M','tr',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e03_328_19_tr','e03_328_19_tr',3,'M','tr',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e03_328_20_tr','e03_328_20_tr',3,'M','tr',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e03_328_21_tr','e03_328_21_tr',3,'M','tr',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e03_328_22_tr','e03_328_22_tr',3,'M','tr',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e03_328_23_tr','e03_328_23_tr',3,'M','tr',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e03_328_24_tr','e03_328_24_tr',3,'M','tr',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e03_328_25_tr','e03_328_25_tr',3,'M','tr',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e03_328_26_tr','e03_328_26_tr',3,'M','tr',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e03_328_27_tr','e03_328_27_tr',3,'M','tr',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e03_328_28_tr','e03_328_28_tr',3,'M','tr',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e03_328_29_tr','e03_328_29_tr',3,'M','tr',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e03_328_30_tr','e03_328_30_tr',3,'M','tr',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e03_328_31_tr','e03_328_31_tr',3,'M','tr',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e03_328_32_tr','e03_328_32_tr',3,'M','tr',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e03_328_33_tr','e03_328_33_tr',3,'M','tr',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e03_328_34_tr','e03_328_34_tr',3,'M','tr',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e03_328_35_tr','e03_328_35_tr',3,'M','tr',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e03_328_36_tr','e03_328_36_tr',3,'M','tr',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e03_328_37_tr','e03_328_37_tr',3,'M','tr',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e04_200_01_vw','e04_200_01_vw',4,'M','vw',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e04_230_01_vw','e04_230_01_vw',4,'M','vw',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e04_230_02_vw','e04_230_02_vw',4,'M','vw',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e04_340_01_vw','e04_340_01_vw',4,'M','vw',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e04_340_02_vw','e04_340_02_vw',4,'M','vw',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e04_340_04_vw','e04_340_04_vw',4,'M','vw',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e04_325_01_vw','e04_325_01_vw',4,'M','vw',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e04_310_01_vw','e04_310_01_vw',4,'M','vw',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e04_311_01_vw','e04_311_01_vw',4,'M','vw',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e04_122_01_vw','e04_122_01_vw',4,'M','vw',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e04_267_01_vw','e04_267_01_vw',4,'M','vw',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e04_267_02_vw','e04_267_02_vw',4,'M','vw',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e04_260_01_vw','e04_260_01_vw',4,'M','vw',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e04_260_02_vw','e04_260_02_vw',4,'M','vw',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e04_260_03_vw','e04_260_03_vw',4,'M','vw',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e04_110_01_vw','e04_110_01_vw',4,'M','vw',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e04_110_02_vw','e04_110_02_vw',4,'M','vw',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e04_310_02_vw','e04_310_02_vw',4,'M','vw',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e04_978_01_vw','e04_978_01_vw',4,'M','vw',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e02_404_01_ft','e02_404_01_ft',1,'A','ft',NULL,NULL,NULL,'2026-09-29 18:05:06');
INSERT INTO e01_506_03_tb VALUES('e01_778_05_tb','e01_778_05_tb',1,'M','tb',NULL,NULL,NULL,'2026-09-29 18:09:17');
INSERT INTO e01_506_03_tb VALUES('e02_778_50_ix','e02_778_50_ix',2,'M','ix',NULL,NULL,NULL,'2026-09-29 18:09:17');
INSERT INTO e01_506_03_tb VALUES('e02_778_51_ix','e02_778_51_ix',2,'M','ix',NULL,NULL,NULL,'2026-09-29 18:09:17');
INSERT INTO e01_506_03_tb VALUES('e02_778_52_ix','e02_778_52_ix',2,'M','ix',NULL,NULL,NULL,'2026-09-29 18:09:17');
INSERT INTO e01_506_03_tb VALUES('e02_778_53_ix','e02_778_53_ix',2,'M','ix',NULL,NULL,NULL,'2026-09-29 18:09:17');
INSERT INTO e01_506_03_tb VALUES('e02_778_54_ix','e02_778_54_ix',2,'M','ix',NULL,NULL,NULL,'2026-09-29 18:09:17');
INSERT INTO e01_506_03_tb VALUES('e03_778_10_tr','e03_778_10_tr',3,'M','tr',NULL,NULL,NULL,'2026-09-29 18:09:17');
INSERT INTO e01_506_03_tb VALUES('e03_778_11_tr','e03_778_11_tr',3,'M','tr',NULL,NULL,NULL,'2026-09-29 18:10:05');
INSERT INTO e01_506_03_tb VALUES('e03_778_13_tr','e03_778_13_tr',3,'M','tr',NULL,NULL,NULL,'2026-09-29 18:10:05');
INSERT INTO e01_506_03_tb VALUES('e03_778_14_tr','e03_778_14_tr',3,'M','tr',NULL,NULL,NULL,'2026-09-29 18:10:05');
INSERT INTO e01_506_03_tb VALUES('e03_778_10b_tr',NULL,3,'M','tr',NULL,NULL,NULL,'2026-09-29 18:17:40');
INSERT INTO e01_506_03_tb VALUES('e03_120_04_tr',NULL,3,'M','tr',NULL,NULL,NULL,'2026-09-29 18:25:46');
INSERT INTO e01_506_03_tb VALUES('e03_120_05_tr',NULL,3,'M','tr',NULL,NULL,NULL,'2026-09-29 18:25:46');
INSERT INTO e01_506_03_tb VALUES('e03_120_01_tr',NULL,3,'M','tr',NULL,NULL,NULL,'2026-09-29 18:25:46');
INSERT INTO e01_506_03_tb VALUES('e03_122_01_tr',NULL,3,'M','tr',NULL,NULL,NULL,'2026-09-29 18:25:46');
INSERT INTO e01_506_03_tb VALUES('e03_122_02_tr',NULL,3,'M','tr',NULL,NULL,NULL,'2026-09-29 18:25:46');
INSERT INTO e01_506_03_tb VALUES('e03_434_01_tr',NULL,3,'M','tr',NULL,NULL,NULL,'2026-09-29 18:25:46');
INSERT INTO e01_506_03_tb VALUES('e04_900_01_vw',NULL,4,'M','vw',NULL,NULL,NULL,'2026-09-29 18:58:56');
INSERT INTO e01_506_03_tb VALUES('e03_120_02_tr',NULL,3,'M','tr',NULL,NULL,NULL,'2026-09-29 20:00:21');
INSERT INTO e01_506_03_tb VALUES('e03_120_03_tr',NULL,3,'M','tr',NULL,NULL,NULL,'2026-09-29 20:00:21');
INSERT INTO e01_506_03_tb VALUES('e03_434_02_tr',NULL,3,'M','tr',NULL,NULL,NULL,'2026-09-29 20:00:21');
INSERT INTO e01_506_03_tb VALUES('e03_434_03_tr',NULL,3,'M','tr',NULL,NULL,NULL,'2026-09-29 20:00:21');
INSERT INTO e01_506_03_tb VALUES('e03_434_04_tr',NULL,3,'M','tr',NULL,NULL,NULL,'2026-09-29 20:00:21');
INSERT INTO e01_506_03_tb VALUES('e03_434_05_tr',NULL,3,'M','tr',NULL,NULL,NULL,'2026-09-29 20:00:21');
INSERT INTO e01_506_03_tb VALUES('POLICY:N00',NULL,NULL,'M','vw',NULL,NULL,NULL,'2026-09-29 20:36:54');
INSERT INTO e01_506_03_tb VALUES('POLICY:N01',NULL,NULL,'M','vw',NULL,NULL,NULL,'2026-09-29 20:36:54');
INSERT INTO e01_506_03_tb VALUES('POLICY:N02',NULL,NULL,'M','vw',NULL,NULL,NULL,'2026-09-29 20:36:54');
INSERT INTO e01_506_03_tb VALUES('POLICY:N03',NULL,NULL,'M','vw',NULL,NULL,NULL,'2026-09-29 20:36:54');
INSERT INTO e01_506_03_tb VALUES('POLICY:N10',NULL,NULL,'M','vw',NULL,NULL,NULL,'2026-09-29 20:36:54');
INSERT INTO e01_506_03_tb VALUES('POLICY:N11',NULL,NULL,'M','vw',NULL,NULL,NULL,'2026-09-29 20:36:54');
INSERT INTO e01_506_03_tb VALUES('POLICY:N12',NULL,NULL,'M','vw',NULL,NULL,NULL,'2026-09-29 20:36:54');
INSERT INTO e01_506_03_tb VALUES('POLICY:N13',NULL,NULL,'M','vw',NULL,NULL,NULL,'2026-09-29 20:36:54');
INSERT INTO e01_506_03_tb VALUES('POLICY:N14',NULL,NULL,'M','vw',NULL,NULL,NULL,'2026-09-29 20:36:54');
INSERT INTO e01_506_03_tb VALUES('POLICY:N15',NULL,NULL,'M','vw',NULL,NULL,NULL,'2026-09-29 20:36:54');
INSERT INTO e01_506_03_tb VALUES('POLICY:N20',NULL,NULL,'M','vw',NULL,NULL,NULL,'2026-09-29 20:36:54');
INSERT INTO e01_506_03_tb VALUES('POLICY:N21',NULL,NULL,'M','vw',NULL,NULL,NULL,'2026-09-29 20:36:54');
INSERT INTO e01_506_03_tb VALUES('POLICY:N22',NULL,NULL,'M','vw',NULL,NULL,NULL,'2026-09-29 20:36:54');
INSERT INTO e01_506_03_tb VALUES('POLICY:N23',NULL,NULL,'M','vw',NULL,NULL,NULL,'2026-09-29 20:36:54');
INSERT INTO e01_506_03_tb VALUES('POLICY:N30',NULL,NULL,'M','vw',NULL,NULL,NULL,'2026-09-29 20:36:54');
INSERT INTO e01_506_03_tb VALUES('POLICY:N31',NULL,NULL,'M','vw',NULL,NULL,NULL,'2026-09-29 20:36:54');
INSERT INTO e01_506_03_tb VALUES('POLICY:N32',NULL,NULL,'M','vw',NULL,NULL,NULL,'2026-09-29 20:36:54');
INSERT INTO e01_506_03_tb VALUES('POLICY:N33',NULL,NULL,'M','vw',NULL,NULL,NULL,'2026-09-29 20:36:54');
INSERT INTO e01_506_03_tb VALUES('POLICY:N34',NULL,NULL,'M','vw',NULL,NULL,NULL,'2026-09-29 20:36:54');
INSERT INTO e01_506_03_tb VALUES('POLICY:N40',NULL,NULL,'M','vw',NULL,NULL,NULL,'2026-09-29 20:36:54');
INSERT INTO e01_506_03_tb VALUES('POLICY:N41',NULL,NULL,'M','vw',NULL,NULL,NULL,'2026-09-29 20:36:54');
INSERT INTO e01_506_03_tb VALUES('POLICY:N42',NULL,NULL,'M','vw',NULL,NULL,NULL,'2026-09-29 20:36:54');
INSERT INTO e01_506_03_tb VALUES('POLICY:N50',NULL,NULL,'M','vw',NULL,NULL,NULL,'2026-09-29 20:36:54');
INSERT INTO e01_506_03_tb VALUES('POLICY:N51',NULL,NULL,'M','vw',NULL,NULL,NULL,'2026-09-29 20:36:54');
INSERT INTO e01_506_03_tb VALUES('POLICY:N52',NULL,NULL,'M','vw',NULL,NULL,NULL,'2026-09-29 20:36:54');
INSERT INTO e01_506_03_tb VALUES('POLICY:N60',NULL,NULL,'M','vw',NULL,NULL,NULL,'2026-09-29 20:36:54');
INSERT INTO e01_506_03_tb VALUES('POLICY:N61',NULL,NULL,'M','vw',NULL,NULL,NULL,'2026-09-29 20:36:54');
INSERT INTO e01_506_03_tb VALUES('POLICY:N62',NULL,NULL,'M','vw',NULL,NULL,NULL,'2026-09-29 20:36:54');
INSERT INTO e01_506_03_tb VALUES('POLICY:N63',NULL,NULL,'M','vw',NULL,NULL,NULL,'2026-09-29 20:36:54');
INSERT INTO e01_506_03_tb VALUES('POLICY:N70',NULL,NULL,'M','vw',NULL,NULL,NULL,'2026-09-29 20:36:54');
INSERT INTO e01_506_03_tb VALUES('POLICY:N71',NULL,NULL,'M','vw',NULL,NULL,NULL,'2026-09-29 20:36:54');
INSERT INTO e01_506_03_tb VALUES('POLICY:N99',NULL,NULL,'M','vw',NULL,NULL,NULL,'2026-09-29 20:36:54');
INSERT INTO e01_506_03_tb VALUES('e03_778_02_ins_tr',NULL,3,'M','tr',NULL,NULL,NULL,'2026-09-29 20:57:58');
INSERT INTO e01_506_03_tb VALUES('e01_506_12_tb',NULL,1,'M','tb',NULL,NULL,NULL,'2026-09-29 21:07:38');
INSERT INTO e01_506_03_tb VALUES('e02_222_21_ix',NULL,2,'C','ix',NULL,NULL,NULL,'2026-09-29 21:08:41');
INSERT INTO e01_506_03_tb VALUES('e02_222_22_ix',NULL,2,'C','ix',NULL,NULL,NULL,'2026-09-29 21:08:41');
INSERT INTO e01_506_03_tb VALUES('e02_222_23_ix',NULL,2,'C','ix',NULL,NULL,NULL,'2026-09-29 21:08:41');
INSERT INTO e01_506_03_tb VALUES('e02_222_24_ix',NULL,2,'C','ix',NULL,NULL,NULL,'2026-09-29 21:08:41');
INSERT INTO e01_506_03_tb VALUES('e02_200_25_ix',NULL,2,'C','ix',NULL,NULL,NULL,'2026-09-29 21:08:41');
CREATE TABLE e01_506_04_tb(
    trace_id INTEGER PRIMARY KEY AUTOINCREMENT, atom_uid TEXT NOT NULL, element_name TEXT NOT NULL,
    trace_type TEXT NOT NULL CHECK(trace_type IN ('implements','verifies','constrains','documents','db_decl','db_guard','db_sync','db_audit','app_layer')),
    UNIQUE(atom_uid, element_name, trace_type),
    CONSTRAINT fk_tra_atom FOREIGN KEY (atom_uid) REFERENCES e01_506_02_tb(atom_uid) ON DELETE RESTRICT,
    CONSTRAINT fk_tra_elem FOREIGN KEY (element_name) REFERENCES e01_506_03_tb(element_name) ON DELETE RESTRICT);
INSERT INTO e01_506_04_tb VALUES(1,'R15','e01_112_01_tb','db_decl');
INSERT INTO e01_506_04_tb VALUES(2,'R16','e01_112_01_tb','db_decl');
INSERT INTO e01_506_04_tb VALUES(3,'R12','e01_120_01_tb','db_decl');
INSERT INTO e01_506_04_tb VALUES(4,'R13','e01_120_01_tb','db_decl');
INSERT INTO e01_506_04_tb VALUES(5,'R11','e01_200_01_tb','db_decl');
INSERT INTO e01_506_04_tb VALUES(6,'R21','e01_200_03_tb','db_decl');
INSERT INTO e01_506_04_tb VALUES(7,'R22','e01_200_03_tb','db_decl');
INSERT INTO e01_506_04_tb VALUES(8,'R17','e01_201_01_tb','db_decl');
INSERT INTO e01_506_04_tb VALUES(9,'R23','e01_201_02_tb','db_decl');
INSERT INTO e01_506_04_tb VALUES(10,'R24','e01_201_02_tb','db_decl');
INSERT INTO e01_506_04_tb VALUES(11,'R18','e01_201_03_tb','db_decl');
INSERT INTO e01_506_04_tb VALUES(12,'R19','e01_201_03_tb','db_decl');
INSERT INTO e01_506_04_tb VALUES(13,'R20','e01_201_03_tb','db_decl');
INSERT INTO e01_506_04_tb VALUES(14,'R14','e01_202_01_tb','db_decl');
INSERT INTO e01_506_04_tb VALUES(15,'R27','e01_222_01_tb','db_decl');
INSERT INTO e01_506_04_tb VALUES(16,'R28','e01_222_01_tb','db_decl');
INSERT INTO e01_506_04_tb VALUES(17,'R29','e01_222_01_tb','db_decl');
INSERT INTO e01_506_04_tb VALUES(18,'R30','e01_222_01_tb','db_decl');
INSERT INTO e01_506_04_tb VALUES(19,'R31','e01_222_01_tb','db_decl');
INSERT INTO e01_506_04_tb VALUES(20,'R32','e01_222_01_tb','db_decl');
INSERT INTO e01_506_04_tb VALUES(21,'R33','e01_222_01_tb','db_decl');
INSERT INTO e01_506_04_tb VALUES(22,'R46','e01_300_01_tb','db_decl');
INSERT INTO e01_506_04_tb VALUES(23,'R47','e01_300_01_tb','db_decl');
INSERT INTO e01_506_04_tb VALUES(24,'R48','e01_300_01_tb','db_decl');
INSERT INTO e01_506_04_tb VALUES(25,'R25','e01_302_01_tb','db_decl');
INSERT INTO e01_506_04_tb VALUES(26,'R26','e01_302_01_tb','db_decl');
INSERT INTO e01_506_04_tb VALUES(27,'R34','e01_305_01_tb','db_decl');
INSERT INTO e01_506_04_tb VALUES(28,'R35','e01_305_01_tb','db_decl');
INSERT INTO e01_506_04_tb VALUES(29,'R36','e01_305_01_tb','db_decl');
INSERT INTO e01_506_04_tb VALUES(30,'R37','e01_305_01_tb','db_decl');
INSERT INTO e01_506_04_tb VALUES(31,'R38','e01_305_02_tb','db_decl');
INSERT INTO e01_506_04_tb VALUES(32,'R39','e01_305_02_tb','db_decl');
INSERT INTO e01_506_04_tb VALUES(33,'R40','e01_305_02_tb','db_decl');
INSERT INTO e01_506_04_tb VALUES(34,'R41','e01_305_02_tb','db_decl');
INSERT INTO e01_506_04_tb VALUES(35,'R42','e01_305_03_tb','db_decl');
INSERT INTO e01_506_04_tb VALUES(36,'R43','e01_305_03_tb','db_decl');
INSERT INTO e01_506_04_tb VALUES(37,'R44','e01_305_03_tb','db_decl');
INSERT INTO e01_506_04_tb VALUES(38,'R45','e01_305_03_tb','db_decl');
INSERT INTO e01_506_04_tb VALUES(39,'R49','e01_330_01_tb','db_decl');
INSERT INTO e01_506_04_tb VALUES(40,'R50','e01_330_01_tb','db_decl');
INSERT INTO e01_506_04_tb VALUES(41,'R51','e01_330_01_tb','db_decl');
INSERT INTO e01_506_04_tb VALUES(42,'R52','e01_330_02_tb','db_decl');
INSERT INTO e01_506_04_tb VALUES(43,'R53','e01_330_02_tb','db_decl');
INSERT INTO e01_506_04_tb VALUES(44,'R63','e01_506_02_tb','db_decl');
INSERT INTO e01_506_04_tb VALUES(45,'R64','e01_506_02_tb','db_decl');
INSERT INTO e01_506_04_tb VALUES(46,'R65','e01_506_02_tb','db_decl');
INSERT INTO e01_506_04_tb VALUES(47,'R03','e01_506_03_tb','db_decl');
INSERT INTO e01_506_04_tb VALUES(48,'R04','e01_506_04_tb','db_decl');
INSERT INTO e01_506_04_tb VALUES(49,'R05','e01_506_04_tb','db_decl');
INSERT INTO e01_506_04_tb VALUES(50,'R06','e01_506_05_tb','db_decl');
INSERT INTO e01_506_04_tb VALUES(51,'R07','e01_506_06_tb','db_decl');
INSERT INTO e01_506_04_tb VALUES(52,'R08','e01_506_06_tb','db_decl');
INSERT INTO e01_506_04_tb VALUES(53,'R09','e01_506_06_tb','db_decl');
INSERT INTO e01_506_04_tb VALUES(54,'R10','e01_506_08_tb','db_decl');
INSERT INTO e01_506_04_tb VALUES(55,'R01','e01_516_01_tb','db_decl');
INSERT INTO e01_506_04_tb VALUES(56,'R02','e01_516_01_tb','db_decl');
INSERT INTO e01_506_04_tb VALUES(57,'R54','e01_778_01_tb','db_decl');
INSERT INTO e01_506_04_tb VALUES(58,'R55','e01_778_01_tb','db_decl');
INSERT INTO e01_506_04_tb VALUES(59,'R56','e01_778_02_tb','db_decl');
INSERT INTO e01_506_04_tb VALUES(60,'R57','e01_778_02_tb','db_decl');
INSERT INTO e01_506_04_tb VALUES(61,'R58','e01_778_02_tb','db_decl');
INSERT INTO e01_506_04_tb VALUES(62,'R59','e01_778_03_tb','db_decl');
INSERT INTO e01_506_04_tb VALUES(63,'R60','e01_778_04_tb','db_decl');
INSERT INTO e01_506_04_tb VALUES(64,'R61','e01_778_04_tb','db_decl');
INSERT INTO e01_506_04_tb VALUES(65,'R62','e01_778_04_tb','db_decl');
INSERT INTO e01_506_04_tb VALUES(131,'A01','e01_200_03_tb','implements');
INSERT INTO e01_506_04_tb VALUES(132,'A02','e01_201_02_tb','implements');
INSERT INTO e01_506_04_tb VALUES(133,'A03','e01_222_01_tb','implements');
INSERT INTO e01_506_04_tb VALUES(134,'B06','e03_312_01_tr','implements');
INSERT INTO e01_506_04_tb VALUES(135,'B10','e03_312_01_tr','implements');
INSERT INTO e01_506_04_tb VALUES(136,'C01','e03_120_01_tr','implements');
INSERT INTO e01_506_04_tb VALUES(137,'C02','e03_122_01_tr','implements');
INSERT INTO e01_506_04_tb VALUES(138,'D02','e03_434_01_tr','implements');
INSERT INTO e01_506_04_tb VALUES(139,'D05','e03_135_01_tr','implements');
INSERT INTO e01_506_04_tb VALUES(140,'E01','e03_343_01_tr','implements');
INSERT INTO e01_506_04_tb VALUES(141,'F03','e02_404_01_ft','implements');
INSERT INTO e01_506_04_tb VALUES(142,'G01','e04_267_01_vw','implements');
INSERT INTO e01_506_04_tb VALUES(143,'H05','e01_506_06_tb','implements');
INSERT INTO e01_506_04_tb VALUES(144,'I01','e03_312_01_tr','verifies');
INSERT INTO e01_506_04_tb VALUES(145,'I02','e04_978_01_vw','implements');
INSERT INTO e01_506_04_tb VALUES(146,'I03','e01_506_03_tb','documents');
INSERT INTO e01_506_04_tb VALUES(147,'I04','e01_506_04_tb','documents');
INSERT INTO e01_506_04_tb VALUES(148,'I05','e03_312_01_tr','implements');
INSERT INTO e01_506_04_tb VALUES(149,'I05','e03_312_02_tr','implements');
INSERT INTO e01_506_04_tb VALUES(150,'I06','e01_506_03_tb','documents');
INSERT INTO e01_506_04_tb VALUES(151,'I07','e01_506_03_tb','documents');
INSERT INTO e01_506_04_tb VALUES(152,'I08','e01_516_01_tb','implements');
INSERT INTO e01_506_04_tb VALUES(153,'I09','e03_312_01_tr','implements');
INSERT INTO e01_506_04_tb VALUES(154,'I09','e03_312_02_tr','implements');
INSERT INTO e01_506_04_tb VALUES(155,'I10','e03_360_01_tr','implements');
INSERT INTO e01_506_04_tb VALUES(156,'I11','e01_506_01_tb','implements');
INSERT INTO e01_506_04_tb VALUES(157,'I11','e01_506_03_tb','implements');
INSERT INTO e01_506_04_tb VALUES(158,'I11','e01_506_02_tb','implements');
INSERT INTO e01_506_04_tb VALUES(159,'I11','e01_200_03_tb','implements');
INSERT INTO e01_506_04_tb VALUES(160,'I11','e01_201_02_tb','implements');
INSERT INTO e01_506_04_tb VALUES(161,'I11','e01_222_01_tb','implements');
INSERT INTO e01_506_04_tb VALUES(162,'I11','e01_200_01_tb','implements');
INSERT INTO e01_506_04_tb VALUES(163,'I11','e01_202_01_tb','implements');
INSERT INTO e01_506_04_tb VALUES(164,'I11','e01_201_01_tb','implements');
INSERT INTO e01_506_04_tb VALUES(165,'I12','e01_201_02_tb','implements');
INSERT INTO e01_506_04_tb VALUES(166,'I13','e01_506_03_tb','documents');
CREATE TABLE e01_506_05_tb(
    question_uid TEXT PRIMARY KEY, parent_uid TEXT, label TEXT NOT NULL, purpose TEXT NOT NULL,
    answer_kind TEXT NOT NULL CHECK(answer_kind IN ('text','entity_ref','value','boolean','criterion','free')),
    required_rule TEXT NOT NULL CHECK(required_rule IN ('always','by_need_kind','conditional','optional')),
    seq INTEGER NOT NULL CHECK(seq >= 0),
    CONSTRAINT fk_que_parent FOREIGN KEY (parent_uid) REFERENCES e01_506_05_tb(question_uid) ON DELETE RESTRICT);
INSERT INTO e01_506_05_tb VALUES('Q00',NULL,'Need?','start','text','always',0);
INSERT INTO e01_506_05_tb VALUES('Q01','Q00','Why?','purpose','text','always',1);
INSERT INTO e01_506_05_tb VALUES('Q02','Q01','Goal?','expected','text','always',2);
INSERT INTO e01_506_05_tb VALUES('Q03','Q02','Object?','object','entity_ref','by_need_kind',3);
INSERT INTO e01_506_05_tb VALUES('Q04','Q03','Actor?','actor','entity_ref','conditional',4);
INSERT INTO e01_506_05_tb VALUES('Q05','Q04','Action?','action','text','by_need_kind',5);
INSERT INTO e01_506_05_tb VALUES('Q06','Q05','Input?','input','value','conditional',6);
INSERT INTO e01_506_05_tb VALUES('Q07','Q06','Context?','context','text','conditional',7);
INSERT INTO e01_506_05_tb VALUES('Q08','Q07','Result?','result','text','always',8);
INSERT INTO e01_506_05_tb VALUES('Q09','Q08','Constraint?','constraint','text','conditional',9);
INSERT INTO e01_506_05_tb VALUES('Q10','Q09','Exception?','exception','text','conditional',10);
INSERT INTO e01_506_05_tb VALUES('Q11','Q10','Acceptance?','acceptance','criterion','always',11);
INSERT INTO e01_506_05_tb VALUES('Q12','Q11','Mechanism?','mechanism','entity_ref','always',12);
INSERT INTO e01_506_05_tb VALUES('Q13','Q12','Verification?','verification','criterion','always',13);
CREATE TABLE e01_506_06_tb(
    node_id INTEGER PRIMARY KEY AUTOINCREMENT, need_uid TEXT NOT NULL, parent_id INTEGER,
    question_uid TEXT NOT NULL, slot TEXT, answer_text TEXT,
    answer_source TEXT NOT NULL DEFAULT 'not_recorded' CHECK(answer_source IN ('source','derived','not_recorded','not_applicable')),
    status TEXT NOT NULL DEFAULT 'open' CHECK(status IN ('open','answered','not_applicable','blocked')),
    ordinal INTEGER NOT NULL DEFAULT 1 CHECK(ordinal >= 1),
    UNIQUE(need_uid, parent_id, question_uid, ordinal),
    CONSTRAINT fk_nod_need FOREIGN KEY (need_uid) REFERENCES e01_506_01_tb(need_uid) ON DELETE RESTRICT,
    CONSTRAINT fk_nod_parent FOREIGN KEY (parent_id) REFERENCES e01_506_06_tb(node_id) ON DELETE RESTRICT,
    CONSTRAINT fk_nod_que FOREIGN KEY (question_uid) REFERENCES e01_506_05_tb(question_uid) ON DELETE RESTRICT);
CREATE TABLE e01_676_01_tb(migration_uid TEXT PRIMARY KEY, applied_at TEXT NOT NULL DEFAULT (datetime('now')), notes TEXT);
INSERT INTO e01_676_01_tb VALUES('v26.0_final','2026-09-29 18:05:06','Core DB v26.0 schema_ver=27');
INSERT INTO e01_676_01_tb VALUES('v27.0_phase1_bridge','2026-09-29 18:09:17','Phase 1 - Bridge Schema. 5 indexes + 2 immutability + 4 FK + 8 registry.');
INSERT INTO e01_676_01_tb VALUES('v27.0_phase2_policy','2026-09-29 18:10:05','Phase 2 - 3 enforce triggers');
INSERT INTO e01_676_01_tb VALUES('v27.0_phase3_fk_anchor','2026-09-29 18:13:43','Phase 3 - FK anchor migration');
INSERT INTO e01_676_01_tb VALUES('v27.0_phase4_trigger_anchor','2026-09-29 18:14:56','Phase 4 - Trigger anchor migration');
INSERT INTO e01_676_01_tb VALUES('v27.0_phase5_audit_views','2026-09-29 18:20:39','Phase 5 - 4 audit views');
INSERT INTO e01_676_01_tb VALUES('v27.0_phase7_e2e','2026-09-29 18:34:48','Phase 7 - end-to-end tests passed');
INSERT INTO e01_676_01_tb VALUES('v27.0_phase8_cutover','2026-09-29 18:34:59','Phase 8 - cutover complete');
INSERT INTO e01_676_01_tb VALUES('v27.0.1_placeholder_fix','2026-09-29 18:44:06','Restored placeholder triggers to full logic');
INSERT INTO e01_676_01_tb VALUES('v27.2_monitor','2026-09-29 18:58:56','Consolidated monitoring into single view');
INSERT INTO e01_676_01_tb VALUES('v27.2_fix','2026-09-29 19:00:18','Self-contained monitor views');
INSERT INTO e01_676_01_tb VALUES('v27.3_bidirectional','2026-09-29 19:04:14','Bidirectional monitoring with coverage percentage');
INSERT INTO e01_676_01_tb VALUES('v27.4_root_fix','2026-09-29 19:14:44','Generate R traces, clean ghosts, add severity classification');
INSERT INTO e01_676_01_tb VALUES('v27.4_fix','2026-09-29 19:16:00','Fixed FK orphan + ghost cleanup order');
INSERT INTO e01_676_01_tb VALUES('v27.5_base_traces','2026-09-29 19:19:09','Inserted 26 base atom traces + registered 4 orphan elements');
INSERT INTO e01_676_01_tb VALUES('v27.5_base_traces_v2','2026-09-29 19:22:18','Inserted 26 base traces with real elements');
INSERT INTO e01_676_01_tb VALUES('v27.6_final_gaps','2026-09-29 19:23:24','Closed 2 atom links, 4 orphans, 24 matrix gaps');
INSERT INTO e01_676_01_tb VALUES('v27.7_fts_exclude','2026-09-29 19:26:28','Excluded FTS shadow tables from orphan count');
INSERT INTO e01_676_01_tb VALUES('v27.8_phase0_critical','2026-09-29 20:00:21','Restored 6 missing triggers + rebuilt closure + FTS');
INSERT INTO e01_676_01_tb VALUES('v27.8_phase1_fix','2026-09-29 20:10:18','Backfilled label_norm, rebuilt FTS, restored enum');
INSERT INTO e01_676_01_tb VALUES('v27.9_phase2_1_context','2026-09-29 20:22:20','Seeded Context layer + tested ctx_key trigger');
INSERT INTO e01_676_01_tb VALUES('v27.9_phase2_2_identity','2026-09-29 20:25:23','Seeded Identity layer: 1 same_as + 1 distinct_from');
INSERT INTO e01_676_01_tb VALUES('v27.9_phase2_3_versioning','2026-09-29 20:28:56','Seeded Versioning layer: 2 versions + 2 snapshots');
INSERT INTO e01_676_01_tb VALUES('v27.10_phase3_n30_rebalance','2026-09-29 20:32:15','Rebalanced N30 policy distribution');
INSERT INTO e01_676_01_tb VALUES('v27.10_phase3_fixed','2026-09-29 20:34:46','Rebalanced N30 + weakened immutability to protect only element+kind');
INSERT INTO e01_676_01_tb VALUES('v27.11_phase3_5_coverage','2026-09-29 20:36:54','Added audit policies for uncovered needs');
INSERT INTO e01_676_01_tb VALUES('v27.11_phase3_5_fixed','2026-09-29 20:38:30','Coverage for uncovered needs (order fixed)');
INSERT INTO e01_676_01_tb VALUES('v27.11_phase3_5_final','2026-09-29 20:41:03','Covered all active+deferred needs + weakened trigger');
INSERT INTO e01_676_01_tb VALUES('v27.13_phase4_monitor','2026-09-29 20:43:52','Rebuilt monitor with coverage-first logic');
INSERT INTO e01_676_01_tb VALUES('v27.14_phase4_4_final','2026-09-29 20:46:37','Fixed monitor: exclude POLICY:* + anchor 6 triggers');
INSERT INTO e01_676_01_tb VALUES('v27.15_phase4_complete','2026-09-29 20:50:26','All 12 monitoring domains healthy or info');
INSERT INTO e01_676_01_tb VALUES('v27.16_phase5_1a','2026-09-29 20:52:42','WITHOUT ROWID for e01_516_01_tb');
INSERT INTO e01_676_01_tb VALUES('v27.16_phase5_1b','2026-09-29 20:53:46','WITHOUT ROWID for e01_778_02_tb');
INSERT INTO e01_676_01_tb VALUES('v27.16_phase5_1_final_fix','2026-09-29 20:57:58','Restored 3 lost triggers + fixed overwrite + proper insert guard');
INSERT INTO e01_676_01_tb VALUES('v27.16_phase5_1_last_fix','2026-09-29 20:59:55','Anchored e03_778_02_ins_tr');
INSERT INTO e01_676_01_tb VALUES('v27.18_phase5_2','2026-09-29 21:04:35','Checksum + ANALYZE statistics');
INSERT INTO e01_676_01_tb VALUES('v27.19_phase5_3','2026-09-29 21:07:39','Materialized need tree cache');
INSERT INTO e01_676_01_tb VALUES('v27.20_phase5_4','2026-09-29 21:08:41','Covering indexes for hot queries');
CREATE TABLE e01_676_02_tb(id INTEGER PRIMARY KEY CHECK(id = 1), schema_ver INTEGER NOT NULL, last_scan_at TEXT NOT NULL DEFAULT (datetime('now')), checksum TEXT, counted_tables INTEGER, counted_triggers INTEGER, counted_views INTEGER);
INSERT INTO e01_676_02_tb VALUES(1,60,'2026-09-29 21:04:35','d664403a4602d95b6c17a0a5867442964d012ac6954dce48a9d215df7b099c64',40,119,20);
CREATE TABLE e01_676_03_tb(param_uid TEXT PRIMARY KEY, int_value INTEGER, text_value TEXT, description TEXT);
INSERT INTO e01_676_03_tb VALUES('max_depth',100,NULL,'max type closure depth');
INSERT INTO e01_676_03_tb VALUES('max_isa_depth',50,NULL,'max isa cycle depth');
INSERT INTO e01_676_03_tb VALUES('max_member_depth',100,NULL,'max value member depth');
INSERT INTO e01_676_03_tb VALUES('max_version_depth',100,NULL,'max supersedes depth');
INSERT INTO e01_676_03_tb VALUES('min_coverage_pct',70,NULL,'min health percent');
INSERT INTO e01_676_03_tb VALUES('seed_frozen_v26',1,NULL,'phase migration active');
INSERT INTO e01_676_03_tb VALUES('migration_started_at',NULL,'2026-09-29 18:09:17','migration started');
INSERT INTO e01_676_03_tb VALUES('phase1_completed_at',NULL,'2026-09-29 18:09:17','phase 1 done');
INSERT INTO e01_676_03_tb VALUES('phase1_status',1,NULL,'phase 1 PASS');
CREATE TABLE e01_378_01_tb(
    ref_id INTEGER PRIMARY KEY AUTOINCREMENT, child_table TEXT NOT NULL, child_col TEXT NOT NULL,
    parent_table TEXT NOT NULL, parent_col TEXT NOT NULL,
    action_on_del TEXT NOT NULL DEFAULT 'restrict' CHECK(action_on_del IN ('restrict','cascade','set_null')),
    layer_from TEXT CHECK(layer_from IN ('M','T','C','X','I','V','A')),
    layer_to TEXT CHECK(layer_to IN ('M','T','C','X','I','V','A')),
    note TEXT, UNIQUE(child_table, child_col));
INSERT INTO e01_378_01_tb VALUES(1,'e01_516_01_tb','need_uid','e01_506_01_tb','need_uid','restrict','M','M','meta');
INSERT INTO e01_378_01_tb VALUES(2,'e01_516_01_tb','atom_uid','e01_506_02_tb','atom_uid','restrict','M','M','meta');
INSERT INTO e01_378_01_tb VALUES(3,'e01_506_03_tb','need_uid','e01_506_01_tb','need_uid','restrict','M','M','meta');
INSERT INTO e01_378_01_tb VALUES(4,'e01_506_04_tb','atom_uid','e01_506_02_tb','atom_uid','restrict','M','M','meta');
INSERT INTO e01_378_01_tb VALUES(5,'e01_506_04_tb','element_name','e01_506_03_tb','element_name','restrict','M','M','meta');
INSERT INTO e01_378_01_tb VALUES(6,'e01_506_05_tb','parent_uid','e01_506_05_tb','question_uid','restrict','M','M','meta self');
INSERT INTO e01_378_01_tb VALUES(7,'e01_506_06_tb','need_uid','e01_506_01_tb','need_uid','restrict','M','M','meta');
INSERT INTO e01_378_01_tb VALUES(8,'e01_506_06_tb','parent_id','e01_506_06_tb','node_id','restrict','M','M','meta self');
INSERT INTO e01_378_01_tb VALUES(9,'e01_506_06_tb','question_uid','e01_506_05_tb','question_uid','restrict','M','M','meta');
INSERT INTO e01_378_01_tb VALUES(10,'e01_506_08_tb','dim_uid','e01_506_07_tb','dim_uid','restrict','M','M','meta');
INSERT INTO e01_378_01_tb VALUES(11,'e01_200_01_tb','parent_id','e01_200_01_tb','type_id','restrict','T','T','type self');
INSERT INTO e01_378_01_tb VALUES(12,'e01_120_01_tb','desc_id','e01_200_01_tb','type_id','restrict','T','T','closure');
INSERT INTO e01_378_01_tb VALUES(13,'e01_120_01_tb','anc_id','e01_200_01_tb','type_id','restrict','T','T','closure');
INSERT INTO e01_378_01_tb VALUES(14,'e01_202_01_tb','inverse_uid','e01_202_01_tb','type_uid','set_null','T','T','type self');
INSERT INTO e01_378_01_tb VALUES(15,'e01_112_01_tb','reltype_id','e01_202_01_tb','reltype_id','restrict','T','T','type');
INSERT INTO e01_378_01_tb VALUES(16,'e01_112_01_tb','target_type_id','e01_200_01_tb','type_id','restrict','T','T','type');
INSERT INTO e01_378_01_tb VALUES(17,'e01_201_01_tb','dom_id','e01_200_02_tb','dom_id','restrict','T','T','type');
INSERT INTO e01_378_01_tb VALUES(18,'e01_201_03_tb','parent_id','e01_201_02_tb','val_id','cascade','C','C','core');
INSERT INTO e01_378_01_tb VALUES(19,'e01_201_03_tb','member_val_id','e01_201_02_tb','val_id','restrict','C','C','core');
INSERT INTO e01_378_01_tb VALUES(20,'e01_201_03_tb','member_ent_id','e01_200_03_tb','ent_id','restrict','C','C','core');
INSERT INTO e01_378_01_tb VALUES(21,'e01_200_03_tb','type_id','e01_200_01_tb','type_id','restrict','C','T','core');
INSERT INTO e01_378_01_tb VALUES(22,'e01_200_03_tb','prv_id','e01_303_01_tb','prv_id','set_null','C','C','core');
INSERT INTO e01_378_01_tb VALUES(23,'e01_201_02_tb','enum_id','e01_201_01_tb','val_id','restrict','C','T','core');
INSERT INTO e01_378_01_tb VALUES(24,'e01_201_02_tb','prv_id','e01_303_01_tb','prv_id','set_null','C','C','core');
INSERT INTO e01_378_01_tb VALUES(25,'e01_302_01_tb','subj_ent_id','e01_200_03_tb','ent_id','restrict','C','C','core');
INSERT INTO e01_378_01_tb VALUES(26,'e01_302_01_tb','reltype_id','e01_202_01_tb','reltype_id','restrict','C','T','core');
INSERT INTO e01_378_01_tb VALUES(27,'e01_222_01_tb','lin_id','e01_302_01_tb','lin_id','set_null','C','C','core');
INSERT INTO e01_378_01_tb VALUES(28,'e01_222_01_tb','reltype_id','e01_202_01_tb','reltype_id','restrict','C','T','core');
INSERT INTO e01_378_01_tb VALUES(29,'e01_222_01_tb','subj_ent_id','e01_200_03_tb','ent_id','restrict','C','C','core');
INSERT INTO e01_378_01_tb VALUES(30,'e01_222_01_tb','obj_ent_id','e01_200_03_tb','ent_id','restrict','C','C','core');
INSERT INTO e01_378_01_tb VALUES(31,'e01_222_01_tb','obj_val_id','e01_201_02_tb','val_id','restrict','C','C','core');
INSERT INTO e01_378_01_tb VALUES(32,'e01_222_01_tb','reif_ent_id','e01_200_03_tb','ent_id','restrict','C','C','core');
INSERT INTO e01_378_01_tb VALUES(33,'e01_222_01_tb','prv_id','e01_303_01_tb','prv_id','set_null','C','C','core');
INSERT INTO e01_378_01_tb VALUES(34,'e01_305_01_tb','ent_id','e01_200_03_tb','ent_id','restrict','X','C','ctx');
INSERT INTO e01_378_01_tb VALUES(35,'e01_305_01_tb','ctx_ent_id','e01_200_03_tb','ent_id','restrict','X','C','ctx');
INSERT INTO e01_378_01_tb VALUES(36,'e01_305_01_tb','ctx_val_id','e01_201_02_tb','val_id','restrict','X','C','ctx');
INSERT INTO e01_378_01_tb VALUES(37,'e01_305_01_tb','prv_id','e01_303_01_tb','prv_id','set_null','X','C','ctx');
INSERT INTO e01_378_01_tb VALUES(38,'e01_305_02_tb','val_id','e01_201_02_tb','val_id','cascade','X','C','ctx');
INSERT INTO e01_378_01_tb VALUES(39,'e01_305_02_tb','ctx_ent_id','e01_200_03_tb','ent_id','restrict','X','C','ctx');
INSERT INTO e01_378_01_tb VALUES(40,'e01_305_02_tb','ctx_val_id','e01_201_02_tb','val_id','restrict','X','C','ctx');
INSERT INTO e01_378_01_tb VALUES(41,'e01_305_02_tb','prv_id','e01_303_01_tb','prv_id','set_null','X','C','ctx');
INSERT INTO e01_378_01_tb VALUES(42,'e01_305_03_tb','rel_id','e01_222_01_tb','rel_id','restrict','X','C','ctx');
INSERT INTO e01_378_01_tb VALUES(43,'e01_305_03_tb','ctx_ent_id','e01_200_03_tb','ent_id','restrict','X','C','ctx');
INSERT INTO e01_378_01_tb VALUES(44,'e01_305_03_tb','ctx_val_id','e01_201_02_tb','val_id','restrict','X','C','ctx');
INSERT INTO e01_378_01_tb VALUES(45,'e01_305_03_tb','prv_id','e01_303_01_tb','prv_id','set_null','X','C','ctx');
INSERT INTO e01_378_01_tb VALUES(46,'e01_300_01_tb','ent_a_id','e01_200_03_tb','ent_id','restrict','I','C','identity');
INSERT INTO e01_378_01_tb VALUES(47,'e01_300_01_tb','ent_b_id','e01_200_03_tb','ent_id','restrict','I','C','identity');
INSERT INTO e01_378_01_tb VALUES(48,'e01_300_01_tb','prv_id','e01_303_01_tb','prv_id','set_null','I','C','identity');
INSERT INTO e01_378_01_tb VALUES(49,'e01_330_01_tb','ent_id','e01_200_03_tb','ent_id','restrict','V','C','version');
INSERT INTO e01_378_01_tb VALUES(50,'e01_330_01_tb','supersedes_id','e01_330_01_tb','vers_id','restrict','V','V','version self');
INSERT INTO e01_378_01_tb VALUES(51,'e01_330_01_tb','approved_by_id','e01_200_03_tb','ent_id','restrict','V','C','version');
INSERT INTO e01_378_01_tb VALUES(52,'e01_330_02_tb','ent_id','e01_200_03_tb','ent_id','restrict','V','C','version');
INSERT INTO e01_378_01_tb VALUES(53,'e01_330_02_tb','vers_id','e01_330_01_tb','vers_id','restrict','V','V','version');
INSERT INTO e01_378_01_tb VALUES(54,'e01_778_01_tb','need_uid','e01_506_01_tb','need_uid','restrict','M','M','semantic');
INSERT INTO e01_378_01_tb VALUES(55,'e01_778_01_tb','parent_code','e01_778_01_tb','code','restrict','M','M','semantic self');
INSERT INTO e01_378_01_tb VALUES(56,'e01_778_02_tb','element_name','e01_506_03_tb','element_name','restrict','M','M','semantic');
INSERT INTO e01_378_01_tb VALUES(57,'e01_778_02_tb','need_uid','e01_506_01_tb','need_uid','restrict','M','M','semantic');
INSERT INTO e01_378_01_tb VALUES(58,'e01_778_02_tb','code','e01_778_01_tb','code','restrict','M','M','semantic');
INSERT INTO e01_378_01_tb VALUES(59,'e01_778_03_tb','root_need_uid','e01_506_01_tb','need_uid','restrict','M','M','semantic');
INSERT INTO e01_378_01_tb VALUES(60,'e01_778_04_tb','chain_uid','e01_778_03_tb','chain_uid','restrict','M','M','semantic');
INSERT INTO e01_378_01_tb VALUES(61,'e01_778_04_tb','element_name','e01_506_03_tb','element_name','set_null','M','M','semantic');
INSERT INTO e01_378_01_tb VALUES(62,'e01_778_04_tb','need_uid','e01_506_01_tb','need_uid','set_null','M','M','semantic');
INSERT INTO e01_378_01_tb VALUES(63,'e01_506_02_tb','verb_code','e01_506_09_tb','verb_code','restrict','M','M','vocab');
INSERT INTO e01_378_01_tb VALUES(64,'e01_506_02_tb','entity_code','e01_506_10_tb','entity_code','restrict','M','M','vocab');
INSERT INTO e01_378_01_tb VALUES(65,'e01_506_02_tb','constraint_code','e01_506_11_tb','constraint_code','restrict','M','M','vocab');
INSERT INTO e01_378_01_tb VALUES(66,'e01_778_05_tb','element_name','e01_506_03_tb','element_name','restrict','M','M','policy elem');
INSERT INTO e01_378_01_tb VALUES(67,'e01_778_05_tb','need_uid','e01_506_01_tb','need_uid','restrict','M','M','policy need');
INSERT INTO e01_378_01_tb VALUES(68,'e01_778_05_tb','fk_ref_id','e01_378_01_tb','ref_id','restrict','M','M','policy fk');
INSERT INTO e01_378_01_tb VALUES(69,'e01_778_05_tb','exec_name','e01_506_03_tb','element_name','restrict','M','M','policy exec');
CREATE TABLE e01_506_07_tb(dim_uid TEXT PRIMARY KEY, label TEXT NOT NULL, description TEXT, seq INTEGER NOT NULL);
CREATE TABLE e01_506_08_tb(value_id INTEGER PRIMARY KEY AUTOINCREMENT, dim_uid TEXT NOT NULL, value_uid TEXT NOT NULL, label TEXT NOT NULL, sort_order INTEGER, UNIQUE(dim_uid, value_uid), CONSTRAINT fk_dim_val_dim FOREIGN KEY (dim_uid) REFERENCES e01_506_07_tb(dim_uid) ON DELETE RESTRICT);
CREATE TABLE e01_778_01_tb(
    code_id INTEGER PRIMARY KEY AUTOINCREMENT, need_uid TEXT NOT NULL, code TEXT NOT NULL UNIQUE,
    code_kind TEXT NOT NULL CHECK(code_kind IN ('need','atom','element','chain','invariant')),
    parent_code TEXT, label TEXT NOT NULL, description TEXT, seq INTEGER NOT NULL DEFAULT 0,
    created_at TEXT NOT NULL DEFAULT (datetime('now')),
    CONSTRAINT fk_rc_need FOREIGN KEY (need_uid) REFERENCES e01_506_01_tb(need_uid) ON DELETE RESTRICT,
    CONSTRAINT fk_rc_parent FOREIGN KEY (parent_code) REFERENCES e01_778_01_tb(code) ON DELETE RESTRICT);
INSERT INTO e01_778_01_tb VALUES(1,'N00','N00','need',NULL,'Project scope',NULL,0,'2026-09-29 18:05:06');
INSERT INTO e01_778_01_tb VALUES(2,'N01','N01','need',NULL,'Find vehicle by VIN',NULL,0,'2026-09-29 18:05:06');
INSERT INTO e01_778_01_tb VALUES(3,'N02','N02','need',NULL,'Register case',NULL,0,'2026-09-29 18:05:06');
INSERT INTO e01_778_01_tb VALUES(4,'N03','N03','need',NULL,'Text search',NULL,0,'2026-09-29 18:05:06');
INSERT INTO e01_778_01_tb VALUES(5,'N10','N10','need',NULL,'Prevent abstract instantiation',NULL,0,'2026-09-29 18:05:06');
INSERT INTO e01_778_01_tb VALUES(6,'N11','N11','need',NULL,'Prevent cycles',NULL,0,'2026-09-29 18:05:06');
INSERT INTO e01_778_01_tb VALUES(7,'N12','N12','need',NULL,'Validate relation type',NULL,0,'2026-09-29 18:05:06');
INSERT INTO e01_778_01_tb VALUES(8,'N13','N13','need',NULL,'Functional uniqueness',NULL,0,'2026-09-29 18:05:06');
INSERT INTO e01_778_01_tb VALUES(9,'N14','N14','need',NULL,'instance_of uniqueness',NULL,0,'2026-09-29 18:05:06');
INSERT INTO e01_778_01_tb VALUES(10,'N15','N15','need',NULL,'Sync ctx_key',NULL,0,'2026-09-29 18:05:06');
INSERT INTO e01_778_01_tb VALUES(11,'N20','N20','need',NULL,'Model vehicle and unit',NULL,0,'2026-09-29 18:05:06');
INSERT INTO e01_778_01_tb VALUES(12,'N21','N21','need',NULL,'Model DTC',NULL,0,'2026-09-29 18:05:06');
INSERT INTO e01_778_01_tb VALUES(13,'N22','N22','need',NULL,'Diagnostic chain',NULL,0,'2026-09-29 18:05:06');
INSERT INTO e01_778_01_tb VALUES(14,'N23','N23','need',NULL,'Distinguish concept/instance',NULL,0,'2026-09-29 18:05:06');
INSERT INTO e01_778_01_tb VALUES(15,'N30','N30','need',NULL,'Referential integrity',NULL,0,'2026-09-29 18:05:06');
INSERT INTO e01_778_01_tb VALUES(16,'N31','N31','need',NULL,'Provenance tracking',NULL,0,'2026-09-29 18:05:06');
INSERT INTO e01_778_01_tb VALUES(17,'N32','N32','need',NULL,'Contextualization',NULL,0,'2026-09-29 18:05:06');
INSERT INTO e01_778_01_tb VALUES(18,'N33','N33','need',NULL,'Time versioning',NULL,0,'2026-09-29 18:05:06');
INSERT INTO e01_778_01_tb VALUES(19,'N34','N34','need',NULL,'Assertion history',NULL,0,'2026-09-29 18:05:06');
INSERT INTO e01_778_01_tb VALUES(20,'N40','N40','need',NULL,'Fast lookup',NULL,0,'2026-09-29 18:05:06');
INSERT INTO e01_778_01_tb VALUES(21,'N41','N41','need',NULL,'Fast FTS',NULL,0,'2026-09-29 18:05:06');
INSERT INTO e01_778_01_tb VALUES(22,'N42','N42','need',NULL,'Current state',NULL,0,'2026-09-29 18:05:06');
INSERT INTO e01_778_01_tb VALUES(23,'N50','N50','need',NULL,'Design language',NULL,0,'2026-09-29 18:05:06');
INSERT INTO e01_778_01_tb VALUES(24,'N51','N51','need',NULL,'Overlap analysis',NULL,0,'2026-09-29 18:05:06');
INSERT INTO e01_778_01_tb VALUES(25,'N52','N52','need',NULL,'Dead element detection',NULL,0,'2026-09-29 18:05:06');
INSERT INTO e01_778_01_tb VALUES(26,'N60','N60','need',NULL,'Closure materialized',NULL,0,'2026-09-29 18:05:06');
INSERT INTO e01_778_01_tb VALUES(27,'N61','N61','need',NULL,'Diagnostic procedures',NULL,0,'2026-09-29 18:05:06');
INSERT INTO e01_778_01_tb VALUES(28,'N62','N62','need',NULL,'Change log',NULL,0,'2026-09-29 18:05:06');
INSERT INTO e01_778_01_tb VALUES(29,'N63','N63','need',NULL,'Idempotent migration',NULL,0,'2026-09-29 18:05:06');
INSERT INTO e01_778_01_tb VALUES(30,'N70','N70','need',NULL,'Register need per element',NULL,0,'2026-09-29 18:05:06');
INSERT INTO e01_778_01_tb VALUES(31,'N71','N71','need',NULL,'Define chains',NULL,0,'2026-09-29 18:05:06');
INSERT INTO e01_778_01_tb VALUES(32,'N99','N99','need',NULL,'Design phase end',NULL,0,'2026-09-29 18:05:06');
INSERT INTO e01_778_01_tb VALUES(33,'N70','INV:policy','invariant',NULL,'Policy validation invariant',NULL,0,'2026-09-29 18:10:05');
INSERT INTO e01_778_01_tb VALUES(34,'N30','INV:del','invariant',NULL,'Delete protection invariant',NULL,0,'2026-09-29 18:10:05');
CREATE TABLE e01_778_03_tb(
    chain_uid TEXT PRIMARY KEY, code TEXT NOT NULL UNIQUE, root_need_uid TEXT NOT NULL, label TEXT NOT NULL, purpose TEXT,
    chain_kind TEXT NOT NULL CHECK(chain_kind IN ('integrity','workflow','diagnostic','provenance','enforcement','validation')),
    created_at TEXT NOT NULL DEFAULT (datetime('now')),
    CONSTRAINT fk_chain_need FOREIGN KEY (root_need_uid) REFERENCES e01_506_01_tb(need_uid) ON DELETE RESTRICT);
INSERT INTO e01_778_03_tb VALUES('CHN:REF:21','CHN-R21','N30','Ref chain','chk type','integrity','2026-09-29 18:05:06');
INSERT INTO e01_778_03_tb VALUES('CHN:ISA:CYC','CHN-ISA','N11','ISA chain','recursive detect','enforcement','2026-09-29 18:05:06');
INSERT INTO e01_778_03_tb VALUES('CHN:CLOS:SYNC','CHN-CLOS','N11','Closure chain','rebuild','integrity','2026-09-29 18:05:06');
INSERT INTO e01_778_03_tb VALUES('CHN:FTS:SYNC','CHN-FTS','N41','FTS chain','mirror','validation','2026-09-29 18:05:06');
INSERT INTO e01_778_03_tb VALUES('CHN:PRV:FALL','CHN-PRV','N31','Provenance chain','ensure prv','provenance','2026-09-29 18:05:06');
CREATE TABLE e01_778_04_tb(
    chain_uid TEXT NOT NULL, ordinal INTEGER NOT NULL CHECK(ordinal >= 1),
    step_kind TEXT NOT NULL CHECK(step_kind IN ('source','transform','enforce','verify','sink','branch')),
    element_name TEXT, need_uid TEXT, code TEXT, description TEXT NOT NULL,
    PRIMARY KEY (chain_uid, ordinal),
    CONSTRAINT fk_step_chain FOREIGN KEY (chain_uid) REFERENCES e01_778_03_tb(chain_uid) ON DELETE RESTRICT,
    CONSTRAINT fk_step_elem FOREIGN KEY (element_name) REFERENCES e01_506_03_tb(element_name) ON DELETE SET NULL,
    CONSTRAINT fk_step_need FOREIGN KEY (need_uid) REFERENCES e01_506_01_tb(need_uid) ON DELETE SET NULL);
INSERT INTO e01_778_04_tb VALUES('CHN:REF:21',1,'source','e01_200_01_tb',NULL,NULL,'source');
INSERT INTO e01_778_04_tb VALUES('CHN:REF:21',2,'enforce','e03_120_04_tr',NULL,NULL,'chk type');
INSERT INTO e01_778_04_tb VALUES('CHN:REF:21',3,'enforce','e03_320_03_tr',NULL,NULL,'protect');
INSERT INTO e01_778_04_tb VALUES('CHN:REF:21',4,'verify','e04_310_02_vw',NULL,NULL,'verify');
INSERT INTO e01_778_04_tb VALUES('CHN:REF:21',5,'sink','e01_200_03_tb',NULL,NULL,'sink');
INSERT INTO e01_778_04_tb VALUES('CHN:FTS:SYNC',1,'source','e01_200_03_tb',NULL,NULL,'source');
INSERT INTO e01_778_04_tb VALUES('CHN:FTS:SYNC',2,'enforce','e03_434_01_tr',NULL,NULL,'insert');
INSERT INTO e01_778_04_tb VALUES('CHN:FTS:SYNC',3,'enforce','e03_434_03_tr',NULL,NULL,'update');
INSERT INTO e01_778_04_tb VALUES('CHN:FTS:SYNC',4,'enforce','e03_434_02_tr',NULL,NULL,'delete');
INSERT INTO e01_778_04_tb VALUES('CHN:FTS:SYNC',5,'sink','e02_404_01_ft',NULL,NULL,'sink');
INSERT INTO e01_778_04_tb VALUES('CHN:ISA:CYC',1,'source','e01_222_01_tb',NULL,NULL,'source');
INSERT INTO e01_778_04_tb VALUES('CHN:ISA:CYC',2,'enforce','e03_122_01_tr',NULL,NULL,'insert');
INSERT INTO e01_778_04_tb VALUES('CHN:ISA:CYC',3,'enforce','e03_122_02_tr',NULL,NULL,'update');
INSERT INTO e01_778_04_tb VALUES('CHN:ISA:CYC',4,'verify','e04_122_01_vw',NULL,NULL,'verify');
INSERT INTO e01_778_04_tb VALUES('CHN:CLOS:SYNC',1,'source','e01_200_01_tb',NULL,NULL,'source');
INSERT INTO e01_778_04_tb VALUES('CHN:CLOS:SYNC',2,'enforce','e03_120_02_tr',NULL,NULL,'insert');
INSERT INTO e01_778_04_tb VALUES('CHN:CLOS:SYNC',3,'enforce','e03_120_03_tr',NULL,NULL,'update');
INSERT INTO e01_778_04_tb VALUES('CHN:CLOS:SYNC',4,'verify','e04_110_01_vw',NULL,NULL,'verify');
INSERT INTO e01_778_04_tb VALUES('CHN:PRV:FALL',1,'source','e01_303_01_tb',NULL,NULL,'source');
INSERT INTO e01_778_04_tb VALUES('CHN:PRV:FALL',2,'enforce','e03_343_01_tr',NULL,NULL,'fb ent');
INSERT INTO e01_778_04_tb VALUES('CHN:PRV:FALL',3,'enforce','e03_343_02_tr',NULL,NULL,'fb val');
INSERT INTO e01_778_04_tb VALUES('CHN:PRV:FALL',4,'enforce','e03_343_03_tr',NULL,NULL,'fb rel');
INSERT INTO e01_778_04_tb VALUES('CHN:PRV:FALL',5,'enforce','e03_343_08_tr',NULL,NULL,'protect');
CREATE TABLE e01_200_01_tb(
    type_id INTEGER PRIMARY KEY AUTOINCREMENT, type_uid TEXT NOT NULL UNIQUE, label TEXT NOT NULL, description TEXT,
    parent_id INTEGER, is_abstract INTEGER NOT NULL DEFAULT 0 CHECK(is_abstract IN (0,1)),
    CHECK (parent_id IS NULL OR parent_id <> type_id),
    CONSTRAINT fk_ety_parent FOREIGN KEY (parent_id) REFERENCES e01_200_01_tb(type_id) ON DELETE RESTRICT);
INSERT INTO e01_200_01_tb VALUES(1,'Vehicle','Vehicle',NULL,NULL,0);
INSERT INTO e01_200_01_tb VALUES(2,'VehicleModel','VehicleModel',NULL,NULL,0);
INSERT INTO e01_200_01_tb VALUES(3,'Make','Make',NULL,NULL,0);
INSERT INTO e01_200_01_tb VALUES(4,'Unit','Unit',NULL,NULL,0);
INSERT INTO e01_200_01_tb VALUES(5,'ECU','ECU',NULL,4,0);
INSERT INTO e01_200_01_tb VALUES(6,'Sensor','Sensor',NULL,4,0);
INSERT INTO e01_200_01_tb VALUES(7,'Actuator','Actuator',NULL,4,0);
INSERT INTO e01_200_01_tb VALUES(8,'Connector','Connector',NULL,NULL,0);
INSERT INTO e01_200_01_tb VALUES(9,'Pin','Pin',NULL,8,0);
INSERT INTO e01_200_01_tb VALUES(10,'Signal','Signal',NULL,NULL,0);
INSERT INTO e01_200_01_tb VALUES(11,'Bus','Bus',NULL,NULL,0);
INSERT INTO e01_200_01_tb VALUES(12,'Frame','Frame',NULL,11,0);
INSERT INTO e01_200_01_tb VALUES(13,'DTC','DTC',NULL,NULL,0);
INSERT INTO e01_200_01_tb VALUES(14,'Observation','Observation',NULL,NULL,0);
INSERT INTO e01_200_01_tb VALUES(15,'Measurement','Measurement',NULL,14,0);
INSERT INTO e01_200_01_tb VALUES(16,'Claim','Claim',NULL,NULL,0);
INSERT INTO e01_200_01_tb VALUES(17,'Evidence','Evidence',NULL,NULL,0);
INSERT INTO e01_200_01_tb VALUES(18,'Hypothesis','Hypothesis',NULL,NULL,0);
INSERT INTO e01_200_01_tb VALUES(19,'Diagnosis','Diagnosis',NULL,NULL,0);
INSERT INTO e01_200_01_tb VALUES(20,'Repair','Repair',NULL,NULL,0);
INSERT INTO e01_200_01_tb VALUES(21,'Knowledge','Knowledge',NULL,NULL,0);
INSERT INTO e01_200_01_tb VALUES(22,'FunctionalChain','FunctionalChain',NULL,NULL,0);
INSERT INTO e01_200_01_tb VALUES(23,'Configuration','Configuration',NULL,NULL,0);
INSERT INTO e01_200_01_tb VALUES(24,'OperatingState','OperatingState',NULL,NULL,0);
INSERT INTO e01_200_01_tb VALUES(25,'Customer','Customer',NULL,NULL,0);
INSERT INTO e01_200_01_tb VALUES(26,'Technician','Technician',NULL,NULL,0);
INSERT INTO e01_200_01_tb VALUES(27,'Case','Case',NULL,NULL,0);
INSERT INTO e01_200_01_tb VALUES(28,'ReifiedRelation','ReifiedRelation',NULL,NULL,0);
INSERT INTO e01_200_01_tb VALUES(29,'StateSnapshot','StateSnapshot',NULL,NULL,0);
INSERT INTO e01_200_01_tb VALUES(30,'CrankshaftSensor','CrankshaftSensor',NULL,6,0);
INSERT INTO e01_200_01_tb VALUES(31,'CamshaftSensor','CamshaftSensor',NULL,6,0);
INSERT INTO e01_200_01_tb VALUES(32,'MapSensor','MapSensor',NULL,6,0);
INSERT INTO e01_200_01_tb VALUES(33,'CoolantTempSensor','CoolantTempSensor',NULL,6,0);
INSERT INTO e01_200_01_tb VALUES(34,'O2Sensor','O2Sensor',NULL,6,0);
INSERT INTO e01_200_01_tb VALUES(35,'IgnitionCoil','IgnitionCoil',NULL,7,0);
INSERT INTO e01_200_01_tb VALUES(36,'Injector','Injector',NULL,7,0);
INSERT INTO e01_200_01_tb VALUES(37,'ThrottleBody','ThrottleBody',NULL,7,0);
INSERT INTO e01_200_01_tb VALUES(38,'FuelPump','FuelPump',NULL,7,0);
INSERT INTO e01_200_01_tb VALUES(39,'Battery','Battery',NULL,4,0);
INSERT INTO e01_200_01_tb VALUES(40,'Relay','Relay',NULL,4,0);
INSERT INTO e01_200_01_tb VALUES(41,'Fuse','Fuse',NULL,4,0);
INSERT INTO e01_200_01_tb VALUES(42,'Wiring','Wiring',NULL,4,0);
INSERT INTO e01_200_01_tb VALUES(43,'CrankSignal','CrankSignal',NULL,10,0);
INSERT INTO e01_200_01_tb VALUES(44,'FuelPressure','FuelPressure',NULL,10,0);
INSERT INTO e01_200_01_tb VALUES(45,'FunctionalRole','FunctionalRole',NULL,NULL,1);
INSERT INTO e01_200_01_tb VALUES(46,'FailureMode','FailureMode',NULL,21,0);
INSERT INTO e01_200_01_tb VALUES(47,'Test','Test',NULL,21,0);
INSERT INTO e01_200_01_tb VALUES(48,'Procedure','Procedure',NULL,21,0);
CREATE TABLE e01_120_01_tb(
    desc_id INTEGER NOT NULL, anc_id INTEGER NOT NULL, depth INTEGER NOT NULL CHECK(depth >= 0),
    PRIMARY KEY (desc_id, anc_id),
    CONSTRAINT fk_clos_desc FOREIGN KEY (desc_id) REFERENCES e01_200_01_tb(type_id) ON DELETE RESTRICT,
    CONSTRAINT fk_clos_anc FOREIGN KEY (anc_id) REFERENCES e01_200_01_tb(type_id) ON DELETE RESTRICT) WITHOUT ROWID;
INSERT INTO e01_120_01_tb VALUES(1,1,0);
INSERT INTO e01_120_01_tb VALUES(2,2,0);
INSERT INTO e01_120_01_tb VALUES(3,3,0);
INSERT INTO e01_120_01_tb VALUES(4,4,0);
INSERT INTO e01_120_01_tb VALUES(5,4,1);
INSERT INTO e01_120_01_tb VALUES(5,5,0);
INSERT INTO e01_120_01_tb VALUES(6,4,1);
INSERT INTO e01_120_01_tb VALUES(6,6,0);
INSERT INTO e01_120_01_tb VALUES(7,4,1);
INSERT INTO e01_120_01_tb VALUES(7,7,0);
INSERT INTO e01_120_01_tb VALUES(8,8,0);
INSERT INTO e01_120_01_tb VALUES(9,8,1);
INSERT INTO e01_120_01_tb VALUES(9,9,0);
INSERT INTO e01_120_01_tb VALUES(10,10,0);
INSERT INTO e01_120_01_tb VALUES(11,11,0);
INSERT INTO e01_120_01_tb VALUES(12,11,1);
INSERT INTO e01_120_01_tb VALUES(12,12,0);
INSERT INTO e01_120_01_tb VALUES(13,13,0);
INSERT INTO e01_120_01_tb VALUES(14,14,0);
INSERT INTO e01_120_01_tb VALUES(15,14,1);
INSERT INTO e01_120_01_tb VALUES(15,15,0);
INSERT INTO e01_120_01_tb VALUES(16,16,0);
INSERT INTO e01_120_01_tb VALUES(17,17,0);
INSERT INTO e01_120_01_tb VALUES(18,18,0);
INSERT INTO e01_120_01_tb VALUES(19,19,0);
INSERT INTO e01_120_01_tb VALUES(20,20,0);
INSERT INTO e01_120_01_tb VALUES(21,21,0);
INSERT INTO e01_120_01_tb VALUES(22,22,0);
INSERT INTO e01_120_01_tb VALUES(23,23,0);
INSERT INTO e01_120_01_tb VALUES(24,24,0);
INSERT INTO e01_120_01_tb VALUES(25,25,0);
INSERT INTO e01_120_01_tb VALUES(26,26,0);
INSERT INTO e01_120_01_tb VALUES(27,27,0);
INSERT INTO e01_120_01_tb VALUES(28,28,0);
INSERT INTO e01_120_01_tb VALUES(29,29,0);
INSERT INTO e01_120_01_tb VALUES(30,4,2);
INSERT INTO e01_120_01_tb VALUES(30,6,1);
INSERT INTO e01_120_01_tb VALUES(30,30,0);
INSERT INTO e01_120_01_tb VALUES(31,4,2);
INSERT INTO e01_120_01_tb VALUES(31,6,1);
INSERT INTO e01_120_01_tb VALUES(31,31,0);
INSERT INTO e01_120_01_tb VALUES(32,4,2);
INSERT INTO e01_120_01_tb VALUES(32,6,1);
INSERT INTO e01_120_01_tb VALUES(32,32,0);
INSERT INTO e01_120_01_tb VALUES(33,4,2);
INSERT INTO e01_120_01_tb VALUES(33,6,1);
INSERT INTO e01_120_01_tb VALUES(33,33,0);
INSERT INTO e01_120_01_tb VALUES(34,4,2);
INSERT INTO e01_120_01_tb VALUES(34,6,1);
INSERT INTO e01_120_01_tb VALUES(34,34,0);
INSERT INTO e01_120_01_tb VALUES(35,4,2);
INSERT INTO e01_120_01_tb VALUES(35,7,1);
INSERT INTO e01_120_01_tb VALUES(35,35,0);
INSERT INTO e01_120_01_tb VALUES(36,4,2);
INSERT INTO e01_120_01_tb VALUES(36,7,1);
INSERT INTO e01_120_01_tb VALUES(36,36,0);
INSERT INTO e01_120_01_tb VALUES(37,4,2);
INSERT INTO e01_120_01_tb VALUES(37,7,1);
INSERT INTO e01_120_01_tb VALUES(37,37,0);
INSERT INTO e01_120_01_tb VALUES(38,4,2);
INSERT INTO e01_120_01_tb VALUES(38,7,1);
INSERT INTO e01_120_01_tb VALUES(38,38,0);
INSERT INTO e01_120_01_tb VALUES(39,4,1);
INSERT INTO e01_120_01_tb VALUES(39,39,0);
INSERT INTO e01_120_01_tb VALUES(40,4,1);
INSERT INTO e01_120_01_tb VALUES(40,40,0);
INSERT INTO e01_120_01_tb VALUES(41,4,1);
INSERT INTO e01_120_01_tb VALUES(41,41,0);
INSERT INTO e01_120_01_tb VALUES(42,4,1);
INSERT INTO e01_120_01_tb VALUES(42,42,0);
INSERT INTO e01_120_01_tb VALUES(43,10,1);
INSERT INTO e01_120_01_tb VALUES(43,43,0);
INSERT INTO e01_120_01_tb VALUES(44,10,1);
INSERT INTO e01_120_01_tb VALUES(44,44,0);
INSERT INTO e01_120_01_tb VALUES(45,45,0);
INSERT INTO e01_120_01_tb VALUES(46,21,1);
INSERT INTO e01_120_01_tb VALUES(46,46,0);
INSERT INTO e01_120_01_tb VALUES(47,21,1);
INSERT INTO e01_120_01_tb VALUES(47,47,0);
INSERT INTO e01_120_01_tb VALUES(48,21,1);
INSERT INTO e01_120_01_tb VALUES(48,48,0);
CREATE TABLE e01_202_01_tb(
    reltype_id INTEGER PRIMARY KEY AUTOINCREMENT, type_uid TEXT NOT NULL UNIQUE, label TEXT NOT NULL, description TEXT,
    object_kind TEXT NOT NULL DEFAULT 'entity' CHECK(object_kind IN ('entity','value','entity_or_value')),
    is_symmetric INTEGER NOT NULL DEFAULT 0 CHECK(is_symmetric IN (0,1)),
    is_transitive INTEGER NOT NULL DEFAULT 0 CHECK(is_transitive IN (0,1)),
    is_functional INTEGER NOT NULL DEFAULT 0 CHECK(is_functional IN (0,1)),
    inverse_uid TEXT,
    CONSTRAINT fk_rty_inv FOREIGN KEY (inverse_uid) REFERENCES e01_202_01_tb(type_uid) ON DELETE SET NULL);
INSERT INTO e01_202_01_tb VALUES(1,'instance_of','instance_of','i to c','entity',0,0,1,NULL);
INSERT INTO e01_202_01_tb VALUES(2,'is_a','is_a','c to c','entity',0,1,0,NULL);
INSERT INTO e01_202_01_tb VALUES(3,'plays_role','plays_role','U to R','entity',0,0,0,NULL);
INSERT INTO e01_202_01_tb VALUES(4,'has_failure_mode','has_failure_mode','U to F','entity',0,0,0,NULL);
INSERT INTO e01_202_01_tb VALUES(5,'manifests_as','manifests_as','F to D','entity',0,0,0,NULL);
INSERT INTO e01_202_01_tb VALUES(6,'detectable_by','detectable_by','F to T','entity',0,0,0,NULL);
INSERT INTO e01_202_01_tb VALUES(7,'has_severity','has_severity','F to V','value',0,0,1,NULL);
INSERT INTO e01_202_01_tb VALUES(8,'has_occurrence_rate','has_occurrence_rate','F to V','value',0,0,1,NULL);
INSERT INTO e01_202_01_tb VALUES(9,'has_detection_rating','has_detection_rating','F to V','value',0,0,1,NULL);
INSERT INTO e01_202_01_tb VALUES(10,'failure_caused_by','failure_caused_by','F to F','entity',0,0,0,NULL);
INSERT INTO e01_202_01_tb VALUES(11,'has_expected_lifetime','has_expected_lifetime','c to V','value',0,0,1,NULL);
INSERT INTO e01_202_01_tb VALUES(12,'concerns_vehicle','concerns_vehicle','C to V','entity',0,0,0,NULL);
INSERT INTO e01_202_01_tb VALUES(13,'has_voltage','has_voltage','U to V','value',0,0,1,NULL);
INSERT INTO e01_202_01_tb VALUES(14,'has_resistance','has_resistance','U to V','value',0,0,1,NULL);
INSERT INTO e01_202_01_tb VALUES(15,'has_part_number','has_part_number','a to V','value',0,0,1,NULL);
INSERT INTO e01_202_01_tb VALUES(16,'has_manufacturer','has_manufacturer','a to V','value',0,0,1,NULL);
INSERT INTO e01_202_01_tb VALUES(17,'has_version','has_version','a to V','value',0,0,1,NULL);
INSERT INTO e01_202_01_tb VALUES(18,'has_state','has_state','a to V','value',0,0,1,NULL);
INSERT INTO e01_202_01_tb VALUES(19,'has_position','has_position','a to V','value',0,0,0,NULL);
INSERT INTO e01_202_01_tb VALUES(20,'has_quantity','has_quantity','a to V','value',0,0,1,NULL);
INSERT INTO e01_202_01_tb VALUES(21,'has_code','has_code','a to V','value',0,0,1,NULL);
INSERT INTO e01_202_01_tb VALUES(22,'has_vin','has_vin','V to V','value',0,0,1,NULL);
INSERT INTO e01_202_01_tb VALUES(23,'observed_value','observed_value','O to V','value',0,0,1,NULL);
INSERT INTO e01_202_01_tb VALUES(24,'carries_signal','carries_signal','P to S','entity',0,0,1,NULL);
INSERT INTO e01_202_01_tb VALUES(25,'mounted_on','mounted_on','a to a','entity',0,0,0,NULL);
INSERT INTO e01_202_01_tb VALUES(26,'connected_to','connected_to','U to U','entity',1,0,0,NULL);
INSERT INTO e01_202_01_tb VALUES(27,'supplies','supplies','a to a','entity',0,0,0,NULL);
INSERT INTO e01_202_01_tb VALUES(28,'controls','controls','E to A','entity',0,0,0,NULL);
INSERT INTO e01_202_01_tb VALUES(29,'measures','measures','S to U','entity',0,0,0,NULL);
INSERT INTO e01_202_01_tb VALUES(30,'transmits','transmits','S to E','entity',0,0,0,NULL);
INSERT INTO e01_202_01_tb VALUES(31,'part_of','part_of','a to a','entity',0,1,0,NULL);
INSERT INTO e01_202_01_tb VALUES(32,'has_participant','has_participant','a to a','entity',0,0,0,NULL);
INSERT INTO e01_202_01_tb VALUES(33,'produces','produces','a to a','entity',0,0,0,NULL);
INSERT INTO e01_202_01_tb VALUES(34,'supports','supports','a to a','entity',0,0,0,NULL);
INSERT INTO e01_202_01_tb VALUES(35,'contradicts','contradicts','a to a','entity',0,0,0,NULL);
INSERT INTO e01_202_01_tb VALUES(36,'derived_from','derived_from','a to a','entity',0,0,0,NULL);
INSERT INTO e01_202_01_tb VALUES(37,'diagnosed_as','diagnosed_as','C to D','entity',0,0,0,NULL);
INSERT INTO e01_202_01_tb VALUES(38,'repaired_by','repaired_by','a to R','entity',0,0,0,NULL);
INSERT INTO e01_202_01_tb VALUES(39,'verified_by','verified_by','a to a','entity',0,0,0,NULL);
INSERT INTO e01_202_01_tb VALUES(40,'applies_to','applies_to','a to a','entity',0,0,0,NULL);
INSERT INTO e01_202_01_tb VALUES(41,'governed_by','governed_by','a to a','entity',0,0,0,NULL);
INSERT INTO e01_202_01_tb VALUES(42,'represents','represents','a to a','entity',0,0,1,NULL);
INSERT INTO e01_202_01_tb VALUES(43,'has_dtc_code','has_dtc_code','c to V','value',0,0,1,NULL);
INSERT INTO e01_202_01_tb VALUES(44,'reports_dtc','reports_dtc','E to D','entity',0,0,0,NULL);
INSERT INTO e01_202_01_tb VALUES(45,'installed_on','installed_on','U to V','entity',0,0,0,NULL);
INSERT INTO e01_202_01_tb VALUES(46,'faulty_part_of','faulty_part_of','a to a','entity',0,0,0,NULL);
INSERT INTO e01_202_01_tb VALUES(47,'suspects','suspects','D to U','entity',0,0,0,NULL);
INSERT INTO e01_202_01_tb VALUES(48,'ruled_out','ruled_out','D to U','entity',0,0,0,NULL);
INSERT INTO e01_202_01_tb VALUES(49,'detected_by','detected_by','O to U','entity',0,0,0,NULL);
INSERT INTO e01_202_01_tb VALUES(50,'resolved_by','resolved_by','C to R','entity',0,0,0,NULL);
INSERT INTO e01_202_01_tb VALUES(51,'replaced_with','replaced_with','U to U','entity',0,0,0,NULL);
INSERT INTO e01_202_01_tb VALUES(52,'tested_by','tested_by','a to T','entity',0,0,0,NULL);
INSERT INTO e01_202_01_tb VALUES(53,'communicates_over','communicates_over','E to B','entity',0,0,0,NULL);
INSERT INTO e01_202_01_tb VALUES(54,'grounded_at','grounded_at','U to W','entity',0,0,0,NULL);
INSERT INTO e01_202_01_tb VALUES(55,'powered_by','powered_by','U to B','entity',0,0,0,NULL);
INSERT INTO e01_202_01_tb VALUES(56,'attributed_to','attributed_to','a to T','entity',0,0,0,NULL);
INSERT INTO e01_202_01_tb VALUES(57,'compatible_with','compatible_with','a to a','entity',0,0,0,NULL);
INSERT INTO e01_202_01_tb VALUES(58,'chain_includes_component','chain_includes_component','F to U','entity',0,0,0,NULL);
INSERT INTO e01_202_01_tb VALUES(59,'chain_produces_signal','chain_produces_signal','F to S','entity',0,0,0,NULL);
INSERT INTO e01_202_01_tb VALUES(60,'chain_requires_signal','chain_requires_signal','F to S','entity',0,0,0,NULL);
CREATE TABLE e01_112_01_tb(
    cons_id INTEGER PRIMARY KEY AUTOINCREMENT, reltype_id INTEGER NOT NULL,
    cons_kind TEXT NOT NULL CHECK(cons_kind IN ('allowed_subject_type','allowed_object_type','allowed_subject_nature','allowed_object_nature')),
    target_type_id INTEGER, target_nature TEXT CHECK(target_nature IS NULL OR target_nature IN ('instance','concept')),
    CHECK ((cons_kind IN ('allowed_subject_type','allowed_object_type') AND target_type_id IS NOT NULL AND target_nature IS NULL) OR (cons_kind IN ('allowed_subject_nature','allowed_object_nature') AND target_type_id IS NULL AND target_nature IS NOT NULL)),
    CONSTRAINT fk_cons_rel FOREIGN KEY (reltype_id) REFERENCES e01_202_01_tb(reltype_id) ON DELETE RESTRICT,
    CONSTRAINT fk_cons_type FOREIGN KEY (target_type_id) REFERENCES e01_200_01_tb(type_id) ON DELETE RESTRICT);
CREATE TABLE e01_200_02_tb(dom_id INTEGER PRIMARY KEY AUTOINCREMENT, dom_uid TEXT NOT NULL UNIQUE, label TEXT NOT NULL, description TEXT);
INSERT INTO e01_200_02_tb VALUES(1,'state','وضعیت',NULL);
INSERT INTO e01_200_02_tb VALUES(2,'severity','شدت',NULL);
INSERT INTO e01_200_02_tb VALUES(3,'confidence','اطمینان',NULL);
INSERT INTO e01_200_02_tb VALUES(4,'yes_no','بله/خیر',NULL);
INSERT INTO e01_200_02_tb VALUES(5,'absence_type','نوع غیاب',NULL);
INSERT INTO e01_200_02_tb VALUES(6,'negation_kind','نوع نفی',NULL);
INSERT INTO e01_200_02_tb VALUES(7,'detection_rating','رتبه تشخیص',NULL);
INSERT INTO e01_200_02_tb VALUES(8,'rate_unit','واحد نرخ',NULL);
CREATE TABLE e01_201_01_tb(
    val_id INTEGER PRIMARY KEY AUTOINCREMENT, dom_id INTEGER NOT NULL, value_uid TEXT NOT NULL, label TEXT NOT NULL, sort_order INTEGER,
    UNIQUE(dom_id, value_uid),
    CONSTRAINT fk_enm_val_dom FOREIGN KEY (dom_id) REFERENCES e01_200_02_tb(dom_id) ON DELETE RESTRICT);
INSERT INTO e01_201_01_tb VALUES(1,1,'on','روشن',1);
INSERT INTO e01_201_01_tb VALUES(2,1,'off','خاموش',2);
INSERT INTO e01_201_01_tb VALUES(3,1,'unknown','نامعلوم',3);
INSERT INTO e01_201_01_tb VALUES(4,2,'info','اطلاع',1);
INSERT INTO e01_201_01_tb VALUES(5,2,'warning','هشدار',2);
INSERT INTO e01_201_01_tb VALUES(6,2,'critical','بحرانی',3);
INSERT INTO e01_201_01_tb VALUES(7,3,'low','کم',1);
INSERT INTO e01_201_01_tb VALUES(8,3,'medium','متوسط',2);
INSERT INTO e01_201_01_tb VALUES(9,3,'high','بالا',3);
INSERT INTO e01_201_01_tb VALUES(10,4,'yes','بله',1);
INSERT INTO e01_201_01_tb VALUES(11,4,'no','خیر',2);
INSERT INTO e01_201_01_tb VALUES(12,5,'not_observed','مشاهده نشد',1);
INSERT INTO e01_201_01_tb VALUES(13,5,'not_recorded','ثبت نشد',2);
INSERT INTO e01_201_01_tb VALUES(14,5,'not_applicable','نامرتبط',3);
INSERT INTO e01_201_01_tb VALUES(15,5,'unknown','نامعلوم',4);
INSERT INTO e01_201_01_tb VALUES(16,6,'source_denied','منبع رد کرد',1);
INSERT INTO e01_201_01_tb VALUES(17,6,'author_retracted','نویسنده پس گرفت',2);
INSERT INTO e01_201_01_tb VALUES(18,6,'counterfactual','فرضی',3);
INSERT INTO e01_201_01_tb VALUES(19,7,'certain','قطعاً',1);
INSERT INTO e01_201_01_tb VALUES(20,7,'likely','احتمالاً',2);
INSERT INTO e01_201_01_tb VALUES(21,7,'uncertain','نامعلوم',3);
INSERT INTO e01_201_01_tb VALUES(22,7,'rare','به‌ندرت',4);
INSERT INTO e01_201_01_tb VALUES(23,8,'per_year','در سال',1);
INSERT INTO e01_201_01_tb VALUES(24,8,'per_100k_km','در ۱۰۰ هزار کیلومتر',2);
INSERT INTO e01_201_01_tb VALUES(25,8,'mtbf_hours','MTBF ساعتی',3);
CREATE TABLE e01_303_01_tb(
    prv_id INTEGER PRIMARY KEY AUTOINCREMENT,
    source_type TEXT NOT NULL CHECK(source_type IN ('manual','sensor','document','inference','external_system','user','ai','import','unknown')),
    source_ref TEXT, method TEXT, confidence REAL CHECK(confidence IS NULL OR (confidence >= 0 AND confidence <= 1)),
    created_at TEXT NOT NULL DEFAULT (datetime('now')), notes TEXT);
INSERT INTO e01_303_01_tb VALUES(2,'unknown','system:unknown','explicit-fallback',NULL,'2026-09-29 17:59:33','Fallback provenance');
CREATE TABLE e01_200_03_tb(
    ent_id INTEGER PRIMARY KEY AUTOINCREMENT, ent_uid TEXT NOT NULL UNIQUE, type_id INTEGER NOT NULL,
    nature TEXT NOT NULL DEFAULT 'instance' CHECK(nature IN ('instance','concept')),
    label TEXT NOT NULL, description TEXT,
    label_norm TEXT CHECK(label_norm IS NULL OR length(label_norm) > 0),
    desc_norm TEXT NOT NULL DEFAULT '',
    status TEXT NOT NULL DEFAULT 'active' CHECK(status IN ('active','archived','deprecated','merged')),
    prv_id INTEGER, created_at TEXT NOT NULL DEFAULT (datetime('now')), updated_at TEXT NOT NULL DEFAULT (datetime('now')),
    CONSTRAINT fk_ent_type FOREIGN KEY (type_id) REFERENCES e01_200_01_tb(type_id) ON DELETE RESTRICT,
    CONSTRAINT fk_ent_prv FOREIGN KEY (prv_id) REFERENCES e01_303_01_tb(prv_id) ON DELETE SET NULL);
INSERT INTO e01_200_03_tb VALUES(1,'role:switch',45,'concept','Switch','role switch','switch','role switch','active',2,'2026-09-29 18:05:06','2026-09-29 18:05:06');
INSERT INTO e01_200_03_tb VALUES(2,'role:protector',45,'concept','Protector','protect role','protector','protect role','active',2,'2026-09-29 18:05:06','2026-09-29 18:05:06');
INSERT INTO e01_200_03_tb VALUES(3,'role:isolator',45,'concept','Isolator','isolate role','isolator','isolate role','active',2,'2026-09-29 18:05:06','2026-09-29 18:05:06');
INSERT INTO e01_200_03_tb VALUES(4,'role:no-switch',45,'concept','NO-switch','normally open','no-switch','normally open','active',2,'2026-09-29 18:05:06','2026-09-29 18:05:06');
INSERT INTO e01_200_03_tb VALUES(5,'role:nc-switch',45,'concept','NC-switch','normally closed','nc-switch','normally closed','active',2,'2026-09-29 18:05:06','2026-09-29 18:05:06');
INSERT INTO e01_200_03_tb VALUES(6,'fm:coil-elec',46,'concept','CoilElec','coil electrical','coilelec','coil electrical','active',2,'2026-09-29 18:05:06','2026-09-29 18:05:06');
INSERT INTO e01_200_03_tb VALUES(7,'fm:coil-open',46,'concept','CoilOpen','primary open','coilopen','primary open','active',2,'2026-09-29 18:05:06','2026-09-29 18:05:06');
INSERT INTO e01_200_03_tb VALUES(8,'fm:coil-short',46,'concept','CoilShort','coil short','coilshort','coil short','active',2,'2026-09-29 18:05:06','2026-09-29 18:05:06');
INSERT INTO e01_200_03_tb VALUES(9,'coil:generic',35,'concept','Coil','standard','coil','standard','active',2,'2026-09-29 18:05:06','2026-09-29 18:05:06');
INSERT INTO e01_200_03_tb VALUES(10,'battery:generic',39,'concept','Battery','12V','battery','12v','active',2,'2026-09-29 18:05:06','2026-09-29 18:05:06');
INSERT INTO e01_200_03_tb VALUES(11,'dtc:P0301',13,'concept','P0301','misfire','p0301','misfire','active',2,'2026-09-29 18:05:06','2026-09-29 18:05:06');
INSERT INTO e01_200_03_tb VALUES(12,'cond:cold-start',24,'concept','Cold start','engine cold start condition','cold start','engine cold start condition','active',2,'2026-09-29 20:22:20','2026-09-29 20:22:20');
INSERT INTO e01_200_03_tb VALUES(13,'env:high-humidity',23,'concept','High humidity','humidity above 80 percent','high humidity','humidity above 80 percent','active',2,'2026-09-29 20:22:20','2026-09-29 20:22:20');
INSERT INTO e01_200_03_tb VALUES(14,'env:hot-weather',23,'concept','Hot weather','ambient temp above 40C','hot weather','ambient temp above 40c','active',2,'2026-09-29 20:22:20','2026-09-29 20:22:20');
INSERT INTO e01_200_03_tb VALUES(15,'coil:generic-alias',35,'concept','Coil (duplicate entry)','duplicate entry for testing identity layer','coil duplicate','duplicate entry for testing identity layer','active',2,'2026-09-29 20:25:23','2026-09-29 20:25:23');
CREATE TABLE e01_201_02_tb(
    val_id INTEGER PRIMARY KEY AUTOINCREMENT,
    value_kind TEXT NOT NULL CHECK(value_kind IN ('number','text','boolean','datetime','date','duration','interval','enum','identifier','json','collection','range','unknown','not_observed','not_recorded','not_applicable')),
    num_val REAL, text_val TEXT, text_norm TEXT, bool_val INTEGER CHECK(bool_val IN (0,1) OR bool_val IS NULL),
    dt_start TEXT, dt_end TEXT, num_min REAL, num_max REAL, enum_id INTEGER, json_val TEXT,
    is_collection INTEGER NOT NULL DEFAULT 0 CHECK(is_collection IN (0,1)),
    unit TEXT, uncertainty REAL, raw_text TEXT, prv_id INTEGER,
    CHECK (is_collection = 0 OR value_kind = 'collection'),
    CHECK (value_kind IN ('unknown','not_observed','not_recorded','not_applicable') OR (value_kind = 'number' AND num_val IS NOT NULL) OR (value_kind = 'text' AND text_val IS NOT NULL) OR (value_kind = 'boolean' AND bool_val IS NOT NULL) OR (value_kind = 'datetime' AND dt_start IS NOT NULL) OR (value_kind = 'enum' AND enum_id IS NOT NULL) OR (value_kind = 'json' AND json_val IS NOT NULL) OR (value_kind = 'date' AND dt_start IS NOT NULL) OR (value_kind = 'duration' AND (num_val IS NOT NULL OR text_val IS NOT NULL)) OR (value_kind = 'interval' AND (dt_start IS NOT NULL OR num_val IS NOT NULL)) OR (value_kind = 'range' AND (num_min IS NOT NULL OR num_max IS NOT NULL)) OR (value_kind = 'identifier' AND (text_val IS NOT NULL OR num_val IS NOT NULL)) OR (value_kind = 'collection' AND is_collection = 1)),
    CHECK (value_kind NOT IN ('unknown','not_observed','not_recorded','not_applicable') OR (num_val IS NULL AND text_val IS NULL AND text_norm IS NULL AND bool_val IS NULL AND dt_start IS NULL AND dt_end IS NULL AND num_min IS NULL AND num_max IS NULL AND enum_id IS NULL AND json_val IS NULL AND is_collection = 0 AND unit IS NULL)),
    CHECK (num_min IS NULL OR num_max IS NULL OR num_min <= num_max),
    CHECK (dt_start IS NULL OR dt_end IS NULL OR dt_start <= dt_end),
    CONSTRAINT fk_val_enum FOREIGN KEY (enum_id) REFERENCES e01_201_01_tb(val_id) ON DELETE RESTRICT,
    CONSTRAINT fk_val_prv FOREIGN KEY (prv_id) REFERENCES e01_303_01_tb(prv_id) ON DELETE SET NULL);
CREATE TABLE e01_201_03_tb(
    memb_id INTEGER PRIMARY KEY AUTOINCREMENT, parent_id INTEGER NOT NULL, member_val_id INTEGER, member_ent_id INTEGER, ordinal INTEGER NOT NULL DEFAULT 0 CHECK(ordinal >= 0),
    CHECK ((member_val_id IS NOT NULL AND member_ent_id IS NULL) OR (member_val_id IS NULL AND member_ent_id IS NOT NULL)),
    CHECK (parent_id <> member_val_id),
    CONSTRAINT fk_memb_parent FOREIGN KEY (parent_id) REFERENCES e01_201_02_tb(val_id) ON DELETE CASCADE,
    CONSTRAINT fk_memb_val FOREIGN KEY (member_val_id) REFERENCES e01_201_02_tb(val_id) ON DELETE RESTRICT,
    CONSTRAINT fk_memb_ent FOREIGN KEY (member_ent_id) REFERENCES e01_200_03_tb(ent_id) ON DELETE RESTRICT);
CREATE TABLE e01_302_01_tb(
    lin_id INTEGER PRIMARY KEY AUTOINCREMENT, lin_uid TEXT NOT NULL UNIQUE, subj_ent_id INTEGER NOT NULL, reltype_id INTEGER NOT NULL, description TEXT,
    created_at TEXT NOT NULL DEFAULT (datetime('now')),
    CONSTRAINT fk_lin_subj FOREIGN KEY (subj_ent_id) REFERENCES e01_200_03_tb(ent_id) ON DELETE RESTRICT,
    CONSTRAINT fk_lin_rty FOREIGN KEY (reltype_id) REFERENCES e01_202_01_tb(reltype_id) ON DELETE RESTRICT);
CREATE TABLE e01_222_01_tb(
    rel_id INTEGER PRIMARY KEY AUTOINCREMENT, rel_uid TEXT NOT NULL UNIQUE, lin_id INTEGER,
    ctx_key TEXT NOT NULL DEFAULT 'u:',
    reif_type TEXT NOT NULL DEFAULT 'none' CHECK(reif_type IN ('none','annotated')),
    reltype_id INTEGER NOT NULL, subj_ent_id INTEGER NOT NULL, obj_ent_id INTEGER, obj_val_id INTEGER, reif_ent_id INTEGER,
    status TEXT NOT NULL DEFAULT 'asserted' CHECK(status IN ('asserted','negated','hypothetical','retracted','unknown')),
    prv_id INTEGER, valid_from TEXT, valid_to TEXT, recorded_at TEXT NOT NULL DEFAULT (datetime('now')), superseded_at TEXT,
    ordinal INTEGER CHECK(ordinal IS NULL OR ordinal >= 0),
    CHECK (valid_from IS NULL OR valid_to IS NULL OR valid_from <= valid_to),
    CHECK (superseded_at IS NULL OR superseded_at >= recorded_at),
    CHECK ((obj_ent_id IS NOT NULL AND obj_val_id IS NULL) OR (obj_ent_id IS NULL AND obj_val_id IS NOT NULL)),
    CHECK (ctx_key = 'u:' OR ctx_key = '?:' OR ctx_key = 'n:' OR ctx_key LIKE 's:%'),
    CHECK ((reif_type = 'none' AND reif_ent_id IS NULL) OR (reif_type = 'annotated' AND reif_ent_id IS NOT NULL)),
    CONSTRAINT fk_rel_lin FOREIGN KEY (lin_id) REFERENCES e01_302_01_tb(lin_id) ON DELETE SET NULL,
    CONSTRAINT fk_rel_rty FOREIGN KEY (reltype_id) REFERENCES e01_202_01_tb(reltype_id) ON DELETE RESTRICT,
    CONSTRAINT fk_rel_subj FOREIGN KEY (subj_ent_id) REFERENCES e01_200_03_tb(ent_id) ON DELETE RESTRICT,
    CONSTRAINT fk_rel_obj_ent FOREIGN KEY (obj_ent_id) REFERENCES e01_200_03_tb(ent_id) ON DELETE RESTRICT,
    CONSTRAINT fk_rel_obj_val FOREIGN KEY (obj_val_id) REFERENCES e01_201_02_tb(val_id) ON DELETE RESTRICT,
    CONSTRAINT fk_rel_reif FOREIGN KEY (reif_ent_id) REFERENCES e01_200_03_tb(ent_id) ON DELETE RESTRICT,
    CONSTRAINT fk_rel_prv FOREIGN KEY (prv_id) REFERENCES e01_303_01_tb(prv_id) ON DELETE SET NULL);
INSERT INTO e01_222_01_tb VALUES(1,'r:no-isa-switch',NULL,'u:','none',2,4,1,NULL,NULL,'asserted',2,NULL,NULL,'2026-09-29 18:05:06',NULL,NULL);
INSERT INTO e01_222_01_tb VALUES(2,'r:nc-isa-switch',NULL,'u:','none',2,5,1,NULL,NULL,'asserted',2,NULL,NULL,'2026-09-29 18:05:06',NULL,NULL);
INSERT INTO e01_222_01_tb VALUES(3,'r:fmopen-isa-fmelec',NULL,'u:','none',2,7,6,NULL,NULL,'asserted',2,NULL,NULL,'2026-09-29 18:05:06',NULL,NULL);
INSERT INTO e01_222_01_tb VALUES(4,'r:fmshort-isa-fmelec',NULL,'u:','none',2,8,6,NULL,NULL,'asserted',2,NULL,NULL,'2026-09-29 18:05:06',NULL,NULL);
INSERT INTO e01_222_01_tb VALUES(5,'r:coil-has-fmopen',NULL,'s:e:12:condition|e:13:environment','none',4,9,7,NULL,NULL,'asserted',2,NULL,NULL,'2026-09-29 18:05:06',NULL,NULL);
INSERT INTO e01_222_01_tb VALUES(6,'r:coil-has-fmshort',NULL,'s:e:14:environment','none',4,9,8,NULL,NULL,'asserted',2,NULL,NULL,'2026-09-29 18:05:06',NULL,NULL);
INSERT INTO e01_222_01_tb VALUES(7,'r:fmopen-manifests-p0301',NULL,'u:','none',5,7,11,NULL,NULL,'asserted',2,NULL,NULL,'2026-09-29 18:05:06',NULL,NULL);
CREATE TABLE e01_305_01_tb(
    ctx_id INTEGER PRIMARY KEY AUTOINCREMENT, ent_id INTEGER NOT NULL, ctx_ent_id INTEGER, ctx_val_id INTEGER,
    role TEXT NOT NULL DEFAULT 'condition' CHECK(role IN ('condition','scope','applicability','variant','environment','mode')),
    valid_from TEXT, valid_to TEXT, prv_id INTEGER,
    CHECK ((ctx_ent_id IS NOT NULL AND ctx_val_id IS NULL) OR (ctx_ent_id IS NULL AND ctx_val_id IS NOT NULL)),
    CHECK (ctx_ent_id IS NULL OR ent_id <> ctx_ent_id),
    CHECK (valid_from IS NULL OR valid_to IS NULL OR valid_from <= valid_to),
    CONSTRAINT fk_ectx_ent FOREIGN KEY (ent_id) REFERENCES e01_200_03_tb(ent_id) ON DELETE RESTRICT,
    CONSTRAINT fk_ectx_cen FOREIGN KEY (ctx_ent_id) REFERENCES e01_200_03_tb(ent_id) ON DELETE RESTRICT,
    CONSTRAINT fk_ectx_cvl FOREIGN KEY (ctx_val_id) REFERENCES e01_201_02_tb(val_id) ON DELETE RESTRICT,
    CONSTRAINT fk_ectx_prv FOREIGN KEY (prv_id) REFERENCES e01_303_01_tb(prv_id) ON DELETE SET NULL);
CREATE TABLE e01_305_02_tb(
    ctx_id INTEGER PRIMARY KEY AUTOINCREMENT, val_id INTEGER NOT NULL, ctx_ent_id INTEGER, ctx_val_id INTEGER,
    role TEXT NOT NULL DEFAULT 'condition' CHECK(role IN ('condition','scope','applicability','variant','environment','mode')),
    valid_from TEXT, valid_to TEXT, prv_id INTEGER,
    CHECK ((ctx_ent_id IS NOT NULL AND ctx_val_id IS NULL) OR (ctx_ent_id IS NULL AND ctx_val_id IS NOT NULL)),
    CHECK (valid_from IS NULL OR valid_to IS NULL OR valid_from <= valid_to),
    CHECK (ctx_val_id IS NULL OR val_id <> ctx_val_id),
    CONSTRAINT fk_vctx_val FOREIGN KEY (val_id) REFERENCES e01_201_02_tb(val_id) ON DELETE CASCADE,
    CONSTRAINT fk_vctx_cen FOREIGN KEY (ctx_ent_id) REFERENCES e01_200_03_tb(ent_id) ON DELETE RESTRICT,
    CONSTRAINT fk_vctx_cvl FOREIGN KEY (ctx_val_id) REFERENCES e01_201_02_tb(val_id) ON DELETE RESTRICT,
    CONSTRAINT fk_vctx_prv FOREIGN KEY (prv_id) REFERENCES e01_303_01_tb(prv_id) ON DELETE SET NULL);
CREATE TABLE e01_305_03_tb(
    ctx_id INTEGER PRIMARY KEY AUTOINCREMENT, rel_id INTEGER NOT NULL, ctx_ent_id INTEGER, ctx_val_id INTEGER,
    role TEXT NOT NULL DEFAULT 'condition' CHECK(role IN ('condition','scope','applicability','variant','environment','mode')),
    valid_from TEXT, valid_to TEXT, prv_id INTEGER,
    CHECK ((ctx_ent_id IS NOT NULL AND ctx_val_id IS NULL) OR (ctx_ent_id IS NULL AND ctx_val_id IS NOT NULL)),
    CHECK (valid_from IS NULL OR valid_to IS NULL OR valid_from <= valid_to),
    CONSTRAINT fk_rctx_rel FOREIGN KEY (rel_id) REFERENCES e01_222_01_tb(rel_id) ON DELETE RESTRICT,
    CONSTRAINT fk_rctx_cen FOREIGN KEY (ctx_ent_id) REFERENCES e01_200_03_tb(ent_id) ON DELETE RESTRICT,
    CONSTRAINT fk_rctx_cvl FOREIGN KEY (ctx_val_id) REFERENCES e01_201_02_tb(val_id) ON DELETE RESTRICT,
    CONSTRAINT fk_rctx_prv FOREIGN KEY (prv_id) REFERENCES e01_303_01_tb(prv_id) ON DELETE SET NULL);
INSERT INTO e01_305_03_tb VALUES(1,5,12,NULL,'condition',NULL,NULL,2);
INSERT INTO e01_305_03_tb VALUES(2,5,13,NULL,'environment',NULL,NULL,2);
INSERT INTO e01_305_03_tb VALUES(3,6,14,NULL,'environment',NULL,NULL,2);
CREATE TABLE e01_300_01_tb(
    clm_id INTEGER PRIMARY KEY AUTOINCREMENT, ent_a_id INTEGER NOT NULL, ent_b_id INTEGER NOT NULL,
    clm_type TEXT NOT NULL CHECK(clm_type IN ('same_as','distinct_from','merged_into','split_from')),
    purpose TEXT, valid_from TEXT, valid_to TEXT, prv_id INTEGER,
    status TEXT NOT NULL DEFAULT 'asserted' CHECK(status IN ('asserted','disputed','retracted')),
    recorded_at TEXT NOT NULL DEFAULT (datetime('now')),
    CHECK (valid_from IS NULL OR valid_to IS NULL OR valid_from <= valid_to),
    CHECK (ent_a_id <> ent_b_id),
    CHECK ((clm_type IN ('same_as','distinct_from') AND ent_a_id < ent_b_id) OR (clm_type IN ('merged_into','split_from'))),
    CONSTRAINT fk_idn_a FOREIGN KEY (ent_a_id) REFERENCES e01_200_03_tb(ent_id) ON DELETE RESTRICT,
    CONSTRAINT fk_idn_b FOREIGN KEY (ent_b_id) REFERENCES e01_200_03_tb(ent_id) ON DELETE RESTRICT,
    CONSTRAINT fk_idn_prv FOREIGN KEY (prv_id) REFERENCES e01_303_01_tb(prv_id) ON DELETE SET NULL);
INSERT INTO e01_300_01_tb VALUES(1,9,15,'same_as','coil:generic has an alias entry',NULL,NULL,1,'asserted','2026-09-29 20:25:23');
INSERT INTO e01_300_01_tb VALUES(2,9,10,'distinct_from','coil and battery are different components',NULL,NULL,1,'asserted','2026-09-29 20:25:23');
CREATE TABLE e01_330_01_tb(
    vers_id INTEGER PRIMARY KEY AUTOINCREMENT, ent_id INTEGER NOT NULL, vers_label TEXT NOT NULL,
    valid_from TEXT, valid_to TEXT,
    status TEXT NOT NULL DEFAULT 'draft' CHECK(status IN ('draft','under_review','approved','deprecated','retracted')),
    supersedes_id INTEGER, approved_by_id INTEGER, approved_at TEXT, created_at TEXT NOT NULL DEFAULT (datetime('now')),
    CHECK (valid_from IS NULL OR valid_to IS NULL OR valid_from <= valid_to),
    UNIQUE(ent_id, vers_label),
    CONSTRAINT fk_vers_ent FOREIGN KEY (ent_id) REFERENCES e01_200_03_tb(ent_id) ON DELETE RESTRICT,
    CONSTRAINT fk_vers_sup FOREIGN KEY (supersedes_id) REFERENCES e01_330_01_tb(vers_id) ON DELETE RESTRICT,
    CONSTRAINT fk_vers_app FOREIGN KEY (approved_by_id) REFERENCES e01_200_03_tb(ent_id) ON DELETE RESTRICT);
INSERT INTO e01_330_01_tb VALUES(1,9,'v1.0','2024-01-01',NULL,'approved',NULL,NULL,NULL,'2026-09-29 20:28:56');
INSERT INTO e01_330_01_tb VALUES(2,9,'v2.0','2024-06-01',NULL,'approved',1,NULL,NULL,'2026-09-29 20:28:56');
CREATE TABLE e01_330_02_tb(
    snap_id INTEGER PRIMARY KEY AUTOINCREMENT, ent_id INTEGER NOT NULL, snap_at TEXT NOT NULL, vers_id INTEGER,
    schema_ver TEXT NOT NULL DEFAULT 'v26.0', snap_data TEXT NOT NULL, reason TEXT, created_at TEXT NOT NULL DEFAULT (datetime('now')),
    CONSTRAINT fk_snap_ent FOREIGN KEY (ent_id) REFERENCES e01_200_03_tb(ent_id) ON DELETE RESTRICT,
    CONSTRAINT fk_snap_ver FOREIGN KEY (vers_id) REFERENCES e01_330_01_tb(vers_id) ON DELETE RESTRICT);
INSERT INTO e01_330_02_tb VALUES(1,9,'2024-01-01 00:00:00',1,'v26.0','{"label":"Coil","description":"standard"}','initial version','2026-09-29 20:28:56');
INSERT INTO e01_330_02_tb VALUES(2,9,'2024-06-01 00:00:00',2,'v27.0','{"label":"Coil","description":"standard 4-pin"}','added pin info','2026-09-29 20:28:56');
CREATE TABLE e01_778_05_tb(
    policy_id INTEGER PRIMARY KEY AUTOINCREMENT,
    element_name TEXT NOT NULL,
    need_uid TEXT NOT NULL,
    policy_kind TEXT NOT NULL CHECK(policy_kind IN ('fk','guard','sync','audit','immutability','index')),
    fk_ref_id INTEGER,
    exec_name TEXT,
    rationale TEXT NOT NULL CHECK(length(rationale) >= 10),
    is_mandatory INTEGER NOT NULL DEFAULT 1 CHECK(is_mandatory IN (0,1)),
    created_at TEXT NOT NULL DEFAULT (datetime('now')),
    CHECK ((policy_kind = 'fk' AND fk_ref_id IS NOT NULL AND exec_name IS NULL) OR (policy_kind IN ('guard','sync','audit','immutability','index') AND fk_ref_id IS NULL AND exec_name IS NOT NULL)),
    CONSTRAINT fk_pol_elem FOREIGN KEY (element_name) REFERENCES e01_506_03_tb(element_name) ON DELETE RESTRICT,
    CONSTRAINT fk_pol_need FOREIGN KEY (need_uid) REFERENCES e01_506_01_tb(need_uid) ON DELETE RESTRICT,
    CONSTRAINT fk_pol_fk FOREIGN KEY (fk_ref_id) REFERENCES e01_378_01_tb(ref_id) ON DELETE RESTRICT,
    CONSTRAINT fk_pol_exec FOREIGN KEY (exec_name) REFERENCES e01_506_03_tb(element_name) ON DELETE RESTRICT
);
INSERT INTO e01_778_05_tb VALUES(1,'e03_778_11_tr','N70','guard',NULL,'e03_778_11_tr','Validate policy insert',1,'2026-09-29 18:10:05');
INSERT INTO e01_778_05_tb VALUES(2,'e03_778_13_tr','N70','guard',NULL,'e03_778_13_tr','Protect mandatory policy',1,'2026-09-29 18:10:05');
INSERT INTO e01_778_05_tb VALUES(3,'e03_778_14_tr','N70','guard',NULL,'e03_778_14_tr','Protect matrix rows',1,'2026-09-29 18:10:05');
INSERT INTO e01_778_05_tb VALUES(4,'e01_516_01_tb','N30','fk',1,NULL,'FK e01_516_01_tb.need_uid to e01_506_01_tb.need_uid',1,'2026-09-29 18:13:43');
INSERT INTO e01_778_05_tb VALUES(5,'e01_516_01_tb','N30','fk',2,NULL,'FK e01_516_01_tb.atom_uid to e01_506_02_tb.atom_uid',1,'2026-09-29 18:13:43');
INSERT INTO e01_778_05_tb VALUES(6,'e01_506_03_tb','N30','fk',3,NULL,'FK e01_506_03_tb.need_uid to e01_506_01_tb.need_uid',1,'2026-09-29 18:13:43');
INSERT INTO e01_778_05_tb VALUES(7,'e01_506_04_tb','N30','fk',4,NULL,'FK e01_506_04_tb.atom_uid to e01_506_02_tb.atom_uid',1,'2026-09-29 18:13:43');
INSERT INTO e01_778_05_tb VALUES(8,'e01_506_04_tb','N70','fk',5,NULL,'FK e01_506_04_tb.element_name to e01_506_03_tb.element_name',1,'2026-09-29 18:13:43');
INSERT INTO e01_778_05_tb VALUES(9,'e01_506_05_tb','N30','fk',6,NULL,'FK e01_506_05_tb.parent_uid to e01_506_05_tb.question_uid',1,'2026-09-29 18:13:43');
INSERT INTO e01_778_05_tb VALUES(10,'e01_506_06_tb','N30','fk',7,NULL,'FK e01_506_06_tb.need_uid to e01_506_01_tb.need_uid',1,'2026-09-29 18:13:43');
INSERT INTO e01_778_05_tb VALUES(11,'e01_506_06_tb','N30','fk',8,NULL,'FK e01_506_06_tb.parent_id to e01_506_06_tb.node_id',1,'2026-09-29 18:13:43');
INSERT INTO e01_778_05_tb VALUES(12,'e01_506_06_tb','N30','fk',9,NULL,'FK e01_506_06_tb.question_uid to e01_506_05_tb.question_uid',1,'2026-09-29 18:13:43');
INSERT INTO e01_778_05_tb VALUES(13,'e01_506_08_tb','N30','fk',10,NULL,'FK e01_506_08_tb.dim_uid to e01_506_07_tb.dim_uid',1,'2026-09-29 18:13:43');
INSERT INTO e01_778_05_tb VALUES(14,'e01_200_01_tb','N30','fk',11,NULL,'FK e01_200_01_tb.parent_id to e01_200_01_tb.type_id',1,'2026-09-29 18:13:43');
INSERT INTO e01_778_05_tb VALUES(15,'e01_120_01_tb','N30','fk',12,NULL,'FK e01_120_01_tb.desc_id to e01_200_01_tb.type_id',1,'2026-09-29 18:13:43');
INSERT INTO e01_778_05_tb VALUES(16,'e01_120_01_tb','N30','fk',13,NULL,'FK e01_120_01_tb.anc_id to e01_200_01_tb.type_id',1,'2026-09-29 18:13:43');
INSERT INTO e01_778_05_tb VALUES(17,'e01_202_01_tb','N12','fk',14,NULL,'FK e01_202_01_tb.inverse_uid to e01_202_01_tb.type_uid',1,'2026-09-29 18:13:43');
INSERT INTO e01_778_05_tb VALUES(18,'e01_112_01_tb','N12','fk',15,NULL,'FK e01_112_01_tb.reltype_id to e01_202_01_tb.reltype_id',1,'2026-09-29 18:13:43');
INSERT INTO e01_778_05_tb VALUES(19,'e01_112_01_tb','N30','fk',16,NULL,'FK e01_112_01_tb.target_type_id to e01_200_01_tb.type_id',1,'2026-09-29 18:13:43');
INSERT INTO e01_778_05_tb VALUES(20,'e01_201_01_tb','N30','fk',17,NULL,'FK e01_201_01_tb.dom_id to e01_200_02_tb.dom_id',1,'2026-09-29 18:13:43');
INSERT INTO e01_778_05_tb VALUES(21,'e01_201_03_tb','N30','fk',18,NULL,'FK e01_201_03_tb.parent_id to e01_201_02_tb.val_id',1,'2026-09-29 18:13:43');
INSERT INTO e01_778_05_tb VALUES(22,'e01_201_03_tb','N30','fk',19,NULL,'FK e01_201_03_tb.member_val_id to e01_201_02_tb.val_id',1,'2026-09-29 18:13:43');
INSERT INTO e01_778_05_tb VALUES(23,'e01_201_03_tb','N30','fk',20,NULL,'FK e01_201_03_tb.member_ent_id to e01_200_03_tb.ent_id',1,'2026-09-29 18:13:43');
INSERT INTO e01_778_05_tb VALUES(24,'e01_200_03_tb','N30','fk',21,NULL,'FK e01_200_03_tb.type_id to e01_200_01_tb.type_id',1,'2026-09-29 18:13:43');
INSERT INTO e01_778_05_tb VALUES(25,'e01_201_02_tb','N30','fk',23,NULL,'FK e01_201_02_tb.enum_id to e01_201_01_tb.val_id',1,'2026-09-29 18:13:43');
INSERT INTO e01_778_05_tb VALUES(26,'e01_302_01_tb','N30','fk',25,NULL,'FK e01_302_01_tb.subj_ent_id to e01_200_03_tb.ent_id',1,'2026-09-29 18:13:43');
INSERT INTO e01_778_05_tb VALUES(27,'e01_302_01_tb','N12','fk',26,NULL,'FK e01_302_01_tb.reltype_id to e01_202_01_tb.reltype_id',1,'2026-09-29 18:13:43');
INSERT INTO e01_778_05_tb VALUES(28,'e01_222_01_tb','N30','fk',27,NULL,'FK e01_222_01_tb.lin_id to e01_302_01_tb.lin_id',1,'2026-09-29 18:13:43');
INSERT INTO e01_778_05_tb VALUES(29,'e01_222_01_tb','N12','fk',28,NULL,'FK e01_222_01_tb.reltype_id to e01_202_01_tb.reltype_id',1,'2026-09-29 18:13:43');
INSERT INTO e01_778_05_tb VALUES(30,'e01_222_01_tb','N30','fk',29,NULL,'FK e01_222_01_tb.subj_ent_id to e01_200_03_tb.ent_id',1,'2026-09-29 18:13:43');
INSERT INTO e01_778_05_tb VALUES(31,'e01_222_01_tb','N30','fk',30,NULL,'FK e01_222_01_tb.obj_ent_id to e01_200_03_tb.ent_id',1,'2026-09-29 18:13:43');
INSERT INTO e01_778_05_tb VALUES(32,'e01_222_01_tb','N30','fk',31,NULL,'FK e01_222_01_tb.obj_val_id to e01_201_02_tb.val_id',1,'2026-09-29 18:13:43');
INSERT INTO e01_778_05_tb VALUES(33,'e01_222_01_tb','N30','fk',32,NULL,'FK e01_222_01_tb.reif_ent_id to e01_200_03_tb.ent_id',1,'2026-09-29 18:13:43');
INSERT INTO e01_778_05_tb VALUES(34,'e01_300_01_tb','N23','fk',46,NULL,'FK e01_300_01_tb.ent_a_id to e01_200_03_tb.ent_id',1,'2026-09-29 18:13:43');
INSERT INTO e01_778_05_tb VALUES(35,'e01_300_01_tb','N23','fk',47,NULL,'FK e01_300_01_tb.ent_b_id to e01_200_03_tb.ent_id',1,'2026-09-29 18:13:43');
INSERT INTO e01_778_05_tb VALUES(36,'e01_330_01_tb','N33','fk',49,NULL,'FK e01_330_01_tb.ent_id to e01_200_03_tb.ent_id',1,'2026-09-29 18:13:43');
INSERT INTO e01_778_05_tb VALUES(37,'e01_330_01_tb','N33','fk',50,NULL,'FK e01_330_01_tb.supersedes_id to e01_330_01_tb.vers_id',1,'2026-09-29 18:13:43');
INSERT INTO e01_778_05_tb VALUES(38,'e01_330_01_tb','N33','fk',51,NULL,'FK e01_330_01_tb.approved_by_id to e01_200_03_tb.ent_id',1,'2026-09-29 18:13:43');
INSERT INTO e01_778_05_tb VALUES(39,'e01_330_02_tb','N33','fk',52,NULL,'FK e01_330_02_tb.ent_id to e01_200_03_tb.ent_id',1,'2026-09-29 18:13:43');
INSERT INTO e01_778_05_tb VALUES(40,'e01_330_02_tb','N33','fk',53,NULL,'FK e01_330_02_tb.vers_id to e01_330_01_tb.vers_id',1,'2026-09-29 18:13:43');
INSERT INTO e01_778_05_tb VALUES(41,'e01_778_01_tb','N71','fk',54,NULL,'FK e01_778_01_tb.need_uid to e01_506_01_tb.need_uid',1,'2026-09-29 18:13:43');
INSERT INTO e01_778_05_tb VALUES(42,'e01_778_01_tb','N71','fk',55,NULL,'FK e01_778_01_tb.parent_code to e01_778_01_tb.code',1,'2026-09-29 18:13:43');
INSERT INTO e01_778_05_tb VALUES(43,'e01_778_03_tb','N71','fk',59,NULL,'FK e01_778_03_tb.root_need_uid to e01_506_01_tb.need_uid',1,'2026-09-29 18:13:43');
INSERT INTO e01_778_05_tb VALUES(44,'e01_778_04_tb','N71','fk',60,NULL,'FK e01_778_04_tb.chain_uid to e01_778_03_tb.chain_uid',1,'2026-09-29 18:13:43');
INSERT INTO e01_778_05_tb VALUES(45,'e01_778_04_tb','N70','fk',61,NULL,'FK e01_778_04_tb.element_name to e01_506_03_tb.element_name',1,'2026-09-29 18:13:43');
INSERT INTO e01_778_05_tb VALUES(46,'e01_778_04_tb','N71','fk',62,NULL,'FK e01_778_04_tb.need_uid to e01_506_01_tb.need_uid',1,'2026-09-29 18:13:43');
INSERT INTO e01_778_05_tb VALUES(47,'e01_506_02_tb','N30','fk',63,NULL,'FK e01_506_02_tb.verb_code to e01_506_09_tb.verb_code',1,'2026-09-29 18:13:43');
INSERT INTO e01_778_05_tb VALUES(48,'e01_506_02_tb','N30','fk',64,NULL,'FK e01_506_02_tb.entity_code to e01_506_10_tb.entity_code',1,'2026-09-29 18:13:43');
INSERT INTO e01_778_05_tb VALUES(49,'e01_506_02_tb','N30','fk',65,NULL,'FK e01_506_02_tb.constraint_code to e01_506_11_tb.constraint_code',1,'2026-09-29 18:13:43');
INSERT INTO e01_778_05_tb VALUES(50,'e01_200_03_tb','N31','fk',22,NULL,'Provenance FK e01_200_03_tb.prv_id',1,'2026-09-29 18:13:43');
INSERT INTO e01_778_05_tb VALUES(51,'e01_201_02_tb','N31','fk',24,NULL,'Provenance FK e01_201_02_tb.prv_id',1,'2026-09-29 18:13:43');
INSERT INTO e01_778_05_tb VALUES(52,'e01_222_01_tb','N31','fk',33,NULL,'Provenance FK e01_222_01_tb.prv_id',1,'2026-09-29 18:13:43');
INSERT INTO e01_778_05_tb VALUES(53,'e01_300_01_tb','N31','fk',48,NULL,'Provenance FK e01_300_01_tb.prv_id',1,'2026-09-29 18:13:43');
INSERT INTO e01_778_05_tb VALUES(54,'e01_305_01_tb','N31','fk',37,NULL,'Provenance FK e01_305_01_tb.prv_id',1,'2026-09-29 18:13:43');
INSERT INTO e01_778_05_tb VALUES(55,'e01_305_02_tb','N31','fk',41,NULL,'Provenance FK e01_305_02_tb.prv_id',1,'2026-09-29 18:13:43');
INSERT INTO e01_778_05_tb VALUES(56,'e01_305_03_tb','N31','fk',45,NULL,'Provenance FK e01_305_03_tb.prv_id',1,'2026-09-29 18:13:43');
INSERT INTO e01_778_05_tb VALUES(57,'e01_305_01_tb','N32','fk',35,NULL,'Context FK e01_305_01_tb.ctx_ent_id',1,'2026-09-29 18:13:43');
INSERT INTO e01_778_05_tb VALUES(58,'e01_305_01_tb','N32','fk',36,NULL,'Context FK e01_305_01_tb.ctx_val_id',1,'2026-09-29 18:13:43');
INSERT INTO e01_778_05_tb VALUES(59,'e01_305_01_tb','N32','fk',34,NULL,'Context FK e01_305_01_tb.ent_id',1,'2026-09-29 18:13:43');
INSERT INTO e01_778_05_tb VALUES(60,'e01_305_02_tb','N32','fk',39,NULL,'Context FK e01_305_02_tb.ctx_ent_id',1,'2026-09-29 18:13:43');
INSERT INTO e01_778_05_tb VALUES(61,'e01_305_02_tb','N32','fk',40,NULL,'Context FK e01_305_02_tb.ctx_val_id',1,'2026-09-29 18:13:43');
INSERT INTO e01_778_05_tb VALUES(62,'e01_305_02_tb','N32','fk',38,NULL,'Context FK e01_305_02_tb.val_id',1,'2026-09-29 18:13:43');
INSERT INTO e01_778_05_tb VALUES(63,'e01_305_03_tb','N32','fk',43,NULL,'Context FK e01_305_03_tb.ctx_ent_id',1,'2026-09-29 18:13:43');
INSERT INTO e01_778_05_tb VALUES(64,'e01_305_03_tb','N32','fk',44,NULL,'Context FK e01_305_03_tb.ctx_val_id',1,'2026-09-29 18:13:43');
INSERT INTO e01_778_05_tb VALUES(65,'e01_305_03_tb','N32','fk',42,NULL,'Context FK e01_305_03_tb.rel_id',1,'2026-09-29 18:13:43');
INSERT INTO e01_778_05_tb VALUES(66,'e01_778_02_tb','N70','fk',58,NULL,'Matrix FK e01_778_02_tb.code',1,'2026-09-29 18:13:43');
INSERT INTO e01_778_05_tb VALUES(67,'e01_778_02_tb','N70','fk',56,NULL,'Matrix FK e01_778_02_tb.element_name',1,'2026-09-29 18:13:43');
INSERT INTO e01_778_05_tb VALUES(68,'e01_778_02_tb','N70','fk',57,NULL,'Matrix FK e01_778_02_tb.need_uid',1,'2026-09-29 18:13:43');
INSERT INTO e01_778_05_tb VALUES(69,'e01_778_05_tb','N50','fk',66,NULL,'Bridge FK element_name',1,'2026-09-29 18:13:43');
INSERT INTO e01_778_05_tb VALUES(70,'e01_778_05_tb','N50','fk',69,NULL,'Bridge FK exec_name',1,'2026-09-29 18:13:43');
INSERT INTO e01_778_05_tb VALUES(71,'e01_778_05_tb','N50','fk',68,NULL,'Bridge FK fk_ref_id',1,'2026-09-29 18:13:43');
INSERT INTO e01_778_05_tb VALUES(72,'e01_778_05_tb','N50','fk',67,NULL,'Bridge FK need_uid',1,'2026-09-29 18:13:43');
INSERT INTO e01_778_05_tb VALUES(73,'e03_312_01_tr','N12','guard',NULL,'e03_312_01_tr','Relation guard e03_312_01_tr',1,'2026-09-29 18:14:55');
INSERT INTO e01_778_05_tb VALUES(74,'e03_312_02_tr','N12','guard',NULL,'e03_312_02_tr','Relation guard e03_312_02_tr',1,'2026-09-29 18:14:55');
INSERT INTO e01_778_05_tb VALUES(75,'e03_112_01_tr','N12','guard',NULL,'e03_112_01_tr','Relation guard e03_112_01_tr',1,'2026-09-29 18:14:55');
INSERT INTO e01_778_05_tb VALUES(76,'e03_343_01_tr','N31','guard',NULL,'e03_343_01_tr','Provenance guard e03_343_01_tr',1,'2026-09-29 18:14:55');
INSERT INTO e01_778_05_tb VALUES(77,'e03_343_02_tr','N31','guard',NULL,'e03_343_02_tr','Provenance guard e03_343_02_tr',1,'2026-09-29 18:14:55');
INSERT INTO e01_778_05_tb VALUES(78,'e03_343_03_tr','N31','guard',NULL,'e03_343_03_tr','Provenance guard e03_343_03_tr',1,'2026-09-29 18:14:55');
INSERT INTO e01_778_05_tb VALUES(79,'e03_343_04_tr','N31','guard',NULL,'e03_343_04_tr','Provenance guard e03_343_04_tr',1,'2026-09-29 18:14:55');
INSERT INTO e01_778_05_tb VALUES(80,'e03_343_05_tr','N31','guard',NULL,'e03_343_05_tr','Provenance guard e03_343_05_tr',1,'2026-09-29 18:14:55');
INSERT INTO e01_778_05_tb VALUES(81,'e03_343_06_tr','N31','guard',NULL,'e03_343_06_tr','Provenance guard e03_343_06_tr',1,'2026-09-29 18:14:55');
INSERT INTO e01_778_05_tb VALUES(82,'e03_343_07_tr','N31','guard',NULL,'e03_343_07_tr','Provenance guard e03_343_07_tr',1,'2026-09-29 18:14:55');
INSERT INTO e01_778_05_tb VALUES(83,'e03_343_08_tr','N31','guard',NULL,'e03_343_08_tr','Provenance guard e03_343_08_tr',1,'2026-09-29 18:14:55');
INSERT INTO e01_778_05_tb VALUES(84,'e03_343_09_tr','N31','guard',NULL,'e03_343_09_tr','Provenance guard e03_343_09_tr',1,'2026-09-29 18:14:55');
INSERT INTO e01_778_05_tb VALUES(85,'e03_135_01_tr','N15','sync',NULL,'e03_135_01_tr','Context sync e03_135_01_tr',1,'2026-09-29 18:14:55');
INSERT INTO e01_778_05_tb VALUES(86,'e03_135_02_tr','N15','sync',NULL,'e03_135_02_tr','Context sync e03_135_02_tr',1,'2026-09-29 18:14:55');
INSERT INTO e01_778_05_tb VALUES(87,'e03_135_03_tr','N15','sync',NULL,'e03_135_03_tr','Context sync e03_135_03_tr',1,'2026-09-29 18:14:55');
INSERT INTO e01_778_05_tb VALUES(88,'e03_311_01_tr','N11','guard',NULL,'e03_311_01_tr','Value guard e03_311_01_tr',1,'2026-09-29 18:14:55');
INSERT INTO e01_778_05_tb VALUES(89,'e03_311_02_tr','N11','guard',NULL,'e03_311_02_tr','Value guard e03_311_02_tr',1,'2026-09-29 18:14:55');
INSERT INTO e01_778_05_tb VALUES(90,'e03_311_03_tr','N11','guard',NULL,'e03_311_03_tr','Value guard e03_311_03_tr',1,'2026-09-29 18:14:55');
INSERT INTO e01_778_05_tb VALUES(91,'e03_311_04_tr','N11','guard',NULL,'e03_311_04_tr','Value guard e03_311_04_tr',1,'2026-09-29 18:14:55');
INSERT INTO e01_778_05_tb VALUES(92,'e03_516_01_tr','N11','guard',NULL,'e03_516_01_tr','Node guard e03_516_01_tr',1,'2026-09-29 18:14:55');
INSERT INTO e01_778_05_tb VALUES(93,'e03_516_02_tr','N11','guard',NULL,'e03_516_02_tr','Node guard e03_516_02_tr',1,'2026-09-29 18:14:55');
INSERT INTO e01_778_05_tb VALUES(94,'e03_126_01_tr','N11','guard',NULL,'e03_126_01_tr','Question guard e03_126_01_tr',1,'2026-09-29 18:14:55');
INSERT INTO e01_778_05_tb VALUES(95,'e03_126_02_tr','N11','guard',NULL,'e03_126_02_tr','Question guard e03_126_02_tr',1,'2026-09-29 18:14:55');
INSERT INTO e01_778_05_tb VALUES(96,'e03_126_03_tr','N11','guard',NULL,'e03_126_03_tr','Question guard e03_126_03_tr',1,'2026-09-29 18:14:55');
INSERT INTO e01_778_05_tb VALUES(97,'e03_320_01_tr','N70','guard',NULL,'e03_320_01_tr','Delete guard e03_320_01_tr',1,'2026-09-29 18:14:56');
INSERT INTO e01_778_05_tb VALUES(98,'e03_320_02_tr','N70','guard',NULL,'e03_320_02_tr','Delete guard e03_320_02_tr',1,'2026-09-29 18:14:56');
INSERT INTO e01_778_05_tb VALUES(99,'e03_320_03_tr','N70','guard',NULL,'e03_320_03_tr','Delete guard e03_320_03_tr',1,'2026-09-29 18:14:56');
INSERT INTO e01_778_05_tb VALUES(100,'e03_320_04_tr','N70','guard',NULL,'e03_320_04_tr','Delete guard e03_320_04_tr',1,'2026-09-29 18:14:56');
INSERT INTO e01_778_05_tb VALUES(101,'e03_320_05_tr','N70','guard',NULL,'e03_320_05_tr','Delete guard e03_320_05_tr',1,'2026-09-29 18:14:56');
INSERT INTO e01_778_05_tb VALUES(102,'e03_320_06_tr','N70','guard',NULL,'e03_320_06_tr','Delete guard e03_320_06_tr',1,'2026-09-29 18:14:56');
INSERT INTO e01_778_05_tb VALUES(103,'e03_320_07_tr','N70','guard',NULL,'e03_320_07_tr','Delete guard e03_320_07_tr',1,'2026-09-29 18:14:56');
INSERT INTO e01_778_05_tb VALUES(104,'e03_320_08_tr','N70','guard',NULL,'e03_320_08_tr','Delete guard e03_320_08_tr',1,'2026-09-29 18:14:56');
INSERT INTO e01_778_05_tb VALUES(105,'e03_320_09_tr','N70','guard',NULL,'e03_320_09_tr','Delete guard e03_320_09_tr',1,'2026-09-29 18:14:56');
INSERT INTO e01_778_05_tb VALUES(106,'e03_310_03_tr','N12','guard',NULL,'e03_310_03_tr','Value guard e03_310_03_tr',1,'2026-09-29 18:14:56');
INSERT INTO e01_778_05_tb VALUES(107,'e03_310_04_tr','N12','guard',NULL,'e03_310_04_tr','Value guard e03_310_04_tr',1,'2026-09-29 18:14:56');
INSERT INTO e01_778_05_tb VALUES(108,'e03_310_05_tr','N12','guard',NULL,'e03_310_05_tr','Value guard e03_310_05_tr',1,'2026-09-29 18:14:56');
INSERT INTO e01_778_05_tb VALUES(109,'e03_310_06_tr','N12','guard',NULL,'e03_310_06_tr','Value guard e03_310_06_tr',1,'2026-09-29 18:14:56');
INSERT INTO e01_778_05_tb VALUES(110,'e03_328_01_tr','N30','immutability',NULL,'e03_328_01_tr','Immutability e03_328_01_tr',1,'2026-09-29 18:14:56');
INSERT INTO e01_778_05_tb VALUES(111,'e03_328_02_tr','N30','immutability',NULL,'e03_328_02_tr','Immutability e03_328_02_tr',1,'2026-09-29 18:14:56');
INSERT INTO e01_778_05_tb VALUES(112,'e03_328_03_tr','N30','immutability',NULL,'e03_328_03_tr','Immutability e03_328_03_tr',1,'2026-09-29 18:14:56');
INSERT INTO e01_778_05_tb VALUES(113,'e03_328_04_tr','N30','immutability',NULL,'e03_328_04_tr','Immutability e03_328_04_tr',1,'2026-09-29 18:14:56');
INSERT INTO e01_778_05_tb VALUES(114,'e03_328_05_tr','N30','immutability',NULL,'e03_328_05_tr','Immutability e03_328_05_tr',1,'2026-09-29 18:14:56');
INSERT INTO e01_778_05_tb VALUES(115,'e03_328_06_tr','N30','immutability',NULL,'e03_328_06_tr','Immutability e03_328_06_tr',1,'2026-09-29 18:14:56');
INSERT INTO e01_778_05_tb VALUES(116,'e03_328_07_tr','N30','immutability',NULL,'e03_328_07_tr','Immutability e03_328_07_tr',1,'2026-09-29 18:14:56');
INSERT INTO e01_778_05_tb VALUES(117,'e03_328_08_tr','N30','immutability',NULL,'e03_328_08_tr','Immutability e03_328_08_tr',1,'2026-09-29 18:14:56');
INSERT INTO e01_778_05_tb VALUES(118,'e03_328_09_tr','N30','immutability',NULL,'e03_328_09_tr','Immutability e03_328_09_tr',1,'2026-09-29 18:14:56');
INSERT INTO e01_778_05_tb VALUES(119,'e03_328_10_tr','N30','immutability',NULL,'e03_328_10_tr','Immutability e03_328_10_tr',1,'2026-09-29 18:14:56');
INSERT INTO e01_778_05_tb VALUES(120,'e03_328_11_tr','N30','immutability',NULL,'e03_328_11_tr','Immutability e03_328_11_tr',1,'2026-09-29 18:14:56');
INSERT INTO e01_778_05_tb VALUES(121,'e03_328_12_tr','N30','immutability',NULL,'e03_328_12_tr','Immutability e03_328_12_tr',1,'2026-09-29 18:14:56');
INSERT INTO e01_778_05_tb VALUES(122,'e03_328_13_tr','N30','immutability',NULL,'e03_328_13_tr','Immutability e03_328_13_tr',1,'2026-09-29 18:14:56');
INSERT INTO e01_778_05_tb VALUES(123,'e03_328_14_tr','N30','immutability',NULL,'e03_328_14_tr','Immutability e03_328_14_tr',1,'2026-09-29 18:14:56');
INSERT INTO e01_778_05_tb VALUES(124,'e03_328_15_tr','N30','immutability',NULL,'e03_328_15_tr','Immutability e03_328_15_tr',1,'2026-09-29 18:14:56');
INSERT INTO e01_778_05_tb VALUES(125,'e03_328_16_tr','N30','immutability',NULL,'e03_328_16_tr','Immutability e03_328_16_tr',1,'2026-09-29 18:14:56');
INSERT INTO e01_778_05_tb VALUES(126,'e03_328_17_tr','N30','immutability',NULL,'e03_328_17_tr','Immutability e03_328_17_tr',1,'2026-09-29 18:14:56');
INSERT INTO e01_778_05_tb VALUES(127,'e03_328_18_tr','N30','immutability',NULL,'e03_328_18_tr','Immutability e03_328_18_tr',1,'2026-09-29 18:14:56');
INSERT INTO e01_778_05_tb VALUES(128,'e03_328_19_tr','N30','immutability',NULL,'e03_328_19_tr','Immutability e03_328_19_tr',1,'2026-09-29 18:14:56');
INSERT INTO e01_778_05_tb VALUES(129,'e03_328_20_tr','N30','immutability',NULL,'e03_328_20_tr','Immutability e03_328_20_tr',1,'2026-09-29 18:14:56');
INSERT INTO e01_778_05_tb VALUES(130,'e03_328_21_tr','N30','immutability',NULL,'e03_328_21_tr','Immutability e03_328_21_tr',1,'2026-09-29 18:14:56');
INSERT INTO e01_778_05_tb VALUES(131,'e03_328_22_tr','N30','immutability',NULL,'e03_328_22_tr','Immutability e03_328_22_tr',1,'2026-09-29 18:14:56');
INSERT INTO e01_778_05_tb VALUES(132,'e03_328_23_tr','N30','immutability',NULL,'e03_328_23_tr','Immutability e03_328_23_tr',1,'2026-09-29 18:14:56');
INSERT INTO e01_778_05_tb VALUES(133,'e03_328_24_tr','N30','immutability',NULL,'e03_328_24_tr','Immutability e03_328_24_tr',1,'2026-09-29 18:14:56');
INSERT INTO e01_778_05_tb VALUES(134,'e03_328_25_tr','N30','immutability',NULL,'e03_328_25_tr','Immutability e03_328_25_tr',1,'2026-09-29 18:14:56');
INSERT INTO e01_778_05_tb VALUES(135,'e03_328_26_tr','N30','immutability',NULL,'e03_328_26_tr','Immutability e03_328_26_tr',1,'2026-09-29 18:14:56');
INSERT INTO e01_778_05_tb VALUES(136,'e03_328_27_tr','N30','immutability',NULL,'e03_328_27_tr','Immutability e03_328_27_tr',1,'2026-09-29 18:14:56');
INSERT INTO e01_778_05_tb VALUES(137,'e03_328_28_tr','N30','immutability',NULL,'e03_328_28_tr','Immutability e03_328_28_tr',1,'2026-09-29 18:14:56');
INSERT INTO e01_778_05_tb VALUES(138,'e03_328_29_tr','N30','immutability',NULL,'e03_328_29_tr','Immutability e03_328_29_tr',1,'2026-09-29 18:14:56');
INSERT INTO e01_778_05_tb VALUES(139,'e03_328_30_tr','N30','immutability',NULL,'e03_328_30_tr','Immutability e03_328_30_tr',1,'2026-09-29 18:14:56');
INSERT INTO e01_778_05_tb VALUES(140,'e03_328_31_tr','N30','immutability',NULL,'e03_328_31_tr','Immutability e03_328_31_tr',1,'2026-09-29 18:14:56');
INSERT INTO e01_778_05_tb VALUES(141,'e03_328_32_tr','N30','immutability',NULL,'e03_328_32_tr','Immutability e03_328_32_tr',1,'2026-09-29 18:14:56');
INSERT INTO e01_778_05_tb VALUES(142,'e03_328_33_tr','N30','immutability',NULL,'e03_328_33_tr','Immutability e03_328_33_tr',1,'2026-09-29 18:14:56');
INSERT INTO e01_778_05_tb VALUES(143,'e03_328_34_tr','N30','immutability',NULL,'e03_328_34_tr','Immutability e03_328_34_tr',1,'2026-09-29 18:14:56');
INSERT INTO e01_778_05_tb VALUES(144,'e03_328_35_tr','N30','immutability',NULL,'e03_328_35_tr','Immutability e03_328_35_tr',1,'2026-09-29 18:14:56');
INSERT INTO e01_778_05_tb VALUES(145,'e03_328_36_tr','N30','immutability',NULL,'e03_328_36_tr','Immutability e03_328_36_tr',1,'2026-09-29 18:14:56');
INSERT INTO e01_778_05_tb VALUES(146,'e03_328_37_tr','N30','immutability',NULL,'e03_328_37_tr','Immutability e03_328_37_tr',1,'2026-09-29 18:14:56');
INSERT INTO e01_778_05_tb VALUES(147,'e03_370_30_tr','N70','guard',NULL,'e03_370_30_tr','Semantic guard e03_370_30_tr',1,'2026-09-29 18:14:56');
INSERT INTO e01_778_05_tb VALUES(148,'e03_370_32_tr','N70','guard',NULL,'e03_370_32_tr','Semantic guard e03_370_32_tr',1,'2026-09-29 18:14:56');
INSERT INTO e01_778_05_tb VALUES(149,'e03_370_33_tr','N70','guard',NULL,'e03_370_33_tr','Semantic guard e03_370_33_tr',1,'2026-09-29 18:14:56');
INSERT INTO e01_778_05_tb VALUES(150,'e03_370_34_tr','N70','guard',NULL,'e03_370_34_tr','Semantic guard e03_370_34_tr',1,'2026-09-29 18:14:56');
INSERT INTO e01_778_05_tb VALUES(151,'e03_370_01_tr','N70','guard',NULL,'e03_370_01_tr','Semantic guard e03_370_01_tr',1,'2026-09-29 18:14:56');
INSERT INTO e01_778_05_tb VALUES(152,'e03_370_02_tr','N70','guard',NULL,'e03_370_02_tr','Semantic guard e03_370_02_tr',1,'2026-09-29 18:14:56');
INSERT INTO e01_778_05_tb VALUES(153,'e03_370_03_tr','N70','guard',NULL,'e03_370_03_tr','Semantic guard e03_370_03_tr',1,'2026-09-29 18:14:56');
INSERT INTO e01_778_05_tb VALUES(154,'e03_370_04_tr','N70','guard',NULL,'e03_370_04_tr','Semantic guard e03_370_04_tr',1,'2026-09-29 18:14:56');
INSERT INTO e01_778_05_tb VALUES(155,'e03_370_05_tr','N70','guard',NULL,'e03_370_05_tr','Semantic guard e03_370_05_tr',1,'2026-09-29 18:14:56');
INSERT INTO e01_778_05_tb VALUES(156,'e03_370_06_tr','N70','guard',NULL,'e03_370_06_tr','Semantic guard e03_370_06_tr',1,'2026-09-29 18:14:56');
INSERT INTO e01_778_05_tb VALUES(157,'e03_370_07_tr','N70','guard',NULL,'e03_370_07_tr','Semantic guard e03_370_07_tr',1,'2026-09-29 18:14:56');
INSERT INTO e01_778_05_tb VALUES(158,'e03_370_08_tr','N70','guard',NULL,'e03_370_08_tr','Semantic guard e03_370_08_tr',1,'2026-09-29 18:14:56');
INSERT INTO e01_778_05_tb VALUES(159,'e03_370_11_tr','N70','guard',NULL,'e03_370_11_tr','Semantic guard e03_370_11_tr',1,'2026-09-29 18:14:56');
INSERT INTO e01_778_05_tb VALUES(160,'e03_370_12_tr','N70','guard',NULL,'e03_370_12_tr','Semantic guard e03_370_12_tr',1,'2026-09-29 18:14:56');
INSERT INTO e01_778_05_tb VALUES(161,'e03_370_13_tr','N70','guard',NULL,'e03_370_13_tr','Semantic guard e03_370_13_tr',1,'2026-09-29 18:14:56');
INSERT INTO e01_778_05_tb VALUES(162,'e03_370_14_tr','N70','guard',NULL,'e03_370_14_tr','Semantic guard e03_370_14_tr',1,'2026-09-29 18:14:56');
INSERT INTO e01_778_05_tb VALUES(163,'e03_370_15_tr','N70','guard',NULL,'e03_370_15_tr','Semantic guard e03_370_15_tr',1,'2026-09-29 18:14:56');
INSERT INTO e01_778_05_tb VALUES(164,'e03_370_16_tr','N70','guard',NULL,'e03_370_16_tr','Semantic guard e03_370_16_tr',1,'2026-09-29 18:14:56');
INSERT INTO e01_778_05_tb VALUES(165,'e03_370_17_tr','N70','guard',NULL,'e03_370_17_tr','Semantic guard e03_370_17_tr',1,'2026-09-29 18:14:56');
INSERT INTO e01_778_05_tb VALUES(166,'e03_370_18_tr','N70','guard',NULL,'e03_370_18_tr','Semantic guard e03_370_18_tr',1,'2026-09-29 18:14:56');
INSERT INTO e01_778_05_tb VALUES(167,'e03_370_21_tr','N70','guard',NULL,'e03_370_21_tr','Semantic guard e03_370_21_tr',1,'2026-09-29 18:14:56');
INSERT INTO e01_778_05_tb VALUES(168,'e03_370_22_tr','N70','guard',NULL,'e03_370_22_tr','Semantic guard e03_370_22_tr',1,'2026-09-29 18:14:56');
INSERT INTO e01_778_05_tb VALUES(169,'e03_370_23_tr','N70','guard',NULL,'e03_370_23_tr','Semantic guard e03_370_23_tr',1,'2026-09-29 18:14:56');
INSERT INTO e01_778_05_tb VALUES(170,'e03_370_24_tr','N70','guard',NULL,'e03_370_24_tr','Semantic guard e03_370_24_tr',1,'2026-09-29 18:14:56');
INSERT INTO e01_778_05_tb VALUES(171,'e03_370_25_tr','N70','guard',NULL,'e03_370_25_tr','Semantic guard e03_370_25_tr',1,'2026-09-29 18:14:56');
INSERT INTO e01_778_05_tb VALUES(172,'e03_370_26_tr','N70','guard',NULL,'e03_370_26_tr','Semantic guard e03_370_26_tr',1,'2026-09-29 18:14:56');
INSERT INTO e01_778_05_tb VALUES(173,'e03_360_01_tr','N22','sync',NULL,'e03_360_01_tr','Reification archive e03_360_01_tr',1,'2026-09-29 18:14:56');
INSERT INTO e01_778_05_tb VALUES(174,'e03_778_10_tr','N50','immutability',NULL,'e03_778_10_tr','Bridge immutability e03_778_10_tr',1,'2026-09-29 18:18:09');
INSERT INTO e01_778_05_tb VALUES(175,'e03_778_10b_tr','N50','immutability',NULL,'e03_778_10b_tr','Bridge immutability e03_778_10b_tr',1,'2026-09-29 18:18:09');
INSERT INTO e01_778_05_tb VALUES(180,'e03_112_01_tr','N13','guard',NULL,'e03_112_01_tr','Auto-anchor primary element e03_112_01_tr',1,'2026-09-29 18:33:12');
INSERT INTO e01_778_05_tb VALUES(181,'e03_120_04_tr','N10','guard',NULL,'e03_120_04_tr','Auto-anchor primary element e03_120_04_tr',1,'2026-09-29 18:33:12');
INSERT INTO e01_778_05_tb VALUES(182,'e03_120_05_tr','N10','guard',NULL,'e03_120_05_tr','Auto-anchor primary element e03_120_05_tr',1,'2026-09-29 18:33:12');
INSERT INTO e01_778_05_tb VALUES(183,'e03_120_01_tr','N11','guard',NULL,'e03_120_01_tr','Auto-anchor primary element e03_120_01_tr',1,'2026-09-29 18:33:12');
INSERT INTO e01_778_05_tb VALUES(184,'e03_122_01_tr','N11','guard',NULL,'e03_122_01_tr','Auto-anchor primary element e03_122_01_tr',1,'2026-09-29 18:33:12');
INSERT INTO e01_778_05_tb VALUES(185,'e03_122_02_tr','N11','guard',NULL,'e03_122_02_tr','Auto-anchor primary element e03_122_02_tr',1,'2026-09-29 18:33:12');
INSERT INTO e01_778_05_tb VALUES(186,'e03_434_01_tr','N41','guard',NULL,'e03_434_01_tr','Auto-anchor primary element e03_434_01_tr',1,'2026-09-29 18:33:12');
INSERT INTO e01_778_05_tb VALUES(187,'e04_310_02_vw','N30','audit',NULL,'e04_310_02_vw','Auto-anchor primary element e04_310_02_vw',1,'2026-09-29 18:33:12');
INSERT INTO e01_778_05_tb VALUES(188,'e04_110_01_vw','N11','audit',NULL,'e04_110_01_vw','Auto-anchor primary element e04_110_01_vw',1,'2026-09-29 18:33:12');
INSERT INTO e01_778_05_tb VALUES(189,'e04_200_01_vw','N20','audit',NULL,'e04_200_01_vw','Auto-anchor primary element e04_200_01_vw',1,'2026-09-29 18:33:12');
INSERT INTO e01_778_05_tb VALUES(190,'e04_267_01_vw','N20','audit',NULL,'e04_267_01_vw','Auto-anchor primary element e04_267_01_vw',1,'2026-09-29 18:33:12');
INSERT INTO e01_778_05_tb VALUES(191,'e04_978_01_vw','N99','audit',NULL,'e04_978_01_vw','Auto-anchor primary element e04_978_01_vw',1,'2026-09-29 18:33:12');
INSERT INTO e01_778_05_tb VALUES(192,'e01_506_09_tb','N50','guard',NULL,'e01_506_09_tb','Auto-anchor primary element e01_506_09_tb',1,'2026-09-29 18:33:12');
INSERT INTO e01_778_05_tb VALUES(193,'e01_506_10_tb','N50','guard',NULL,'e01_506_10_tb','Auto-anchor primary element e01_506_10_tb',1,'2026-09-29 18:33:12');
INSERT INTO e01_778_05_tb VALUES(194,'e01_506_11_tb','N50','guard',NULL,'e01_506_11_tb','Auto-anchor primary element e01_506_11_tb',1,'2026-09-29 18:33:12');
INSERT INTO e01_778_05_tb VALUES(195,'POLICY:N00','N00','audit',NULL,'POLICY:N00','Audit placeholder for Project scope (fulfilled via view)',1,'2026-09-29 20:41:03');
INSERT INTO e01_778_05_tb VALUES(196,'POLICY:N01','N01','audit',NULL,'POLICY:N01','Audit placeholder for Find vehicle by VIN (fulfilled via view)',1,'2026-09-29 20:41:03');
INSERT INTO e01_778_05_tb VALUES(197,'POLICY:N02','N02','audit',NULL,'POLICY:N02','Audit placeholder for Register case (fulfilled via view)',1,'2026-09-29 20:41:03');
INSERT INTO e01_778_05_tb VALUES(198,'POLICY:N03','N03','audit',NULL,'POLICY:N03','Audit placeholder for Text search (fulfilled via view)',1,'2026-09-29 20:41:03');
INSERT INTO e01_778_05_tb VALUES(199,'POLICY:N14','N14','audit',NULL,'POLICY:N14','Audit placeholder for instance_of uniqueness (fulfilled via view)',1,'2026-09-29 20:41:03');
INSERT INTO e01_778_05_tb VALUES(200,'POLICY:N21','N21','audit',NULL,'POLICY:N21','Audit placeholder for Model DTC (fulfilled via view)',1,'2026-09-29 20:41:03');
INSERT INTO e01_778_05_tb VALUES(201,'POLICY:N34','N34','audit',NULL,'POLICY:N34','Audit placeholder for Assertion history (fulfilled via view)',1,'2026-09-29 20:41:03');
INSERT INTO e01_778_05_tb VALUES(202,'POLICY:N40','N40','audit',NULL,'POLICY:N40','Audit placeholder for Fast lookup (fulfilled via view)',1,'2026-09-29 20:41:03');
INSERT INTO e01_778_05_tb VALUES(203,'POLICY:N42','N42','audit',NULL,'POLICY:N42','Audit placeholder for Current state (fulfilled via view)',1,'2026-09-29 20:41:03');
INSERT INTO e01_778_05_tb VALUES(204,'POLICY:N51','N51','audit',NULL,'POLICY:N51','Audit placeholder for Overlap analysis (fulfilled via view)',1,'2026-09-29 20:41:03');
INSERT INTO e01_778_05_tb VALUES(205,'POLICY:N52','N52','audit',NULL,'POLICY:N52','Audit placeholder for Dead element detection (fulfilled via view)',1,'2026-09-29 20:41:03');
INSERT INTO e01_778_05_tb VALUES(206,'POLICY:N60','N60','audit',NULL,'POLICY:N60','Audit placeholder for Closure materialized (deferred)',0,'2026-09-29 20:41:03');
INSERT INTO e01_778_05_tb VALUES(207,'POLICY:N61','N61','audit',NULL,'POLICY:N61','Audit placeholder for Diagnostic procedures (deferred)',0,'2026-09-29 20:41:03');
INSERT INTO e01_778_05_tb VALUES(208,'POLICY:N62','N62','audit',NULL,'POLICY:N62','Audit placeholder for Change log (deferred)',0,'2026-09-29 20:41:03');
INSERT INTO e01_778_05_tb VALUES(209,'POLICY:N63','N63','audit',NULL,'POLICY:N63','Audit placeholder for Idempotent migration (deferred)',0,'2026-09-29 20:41:03');
INSERT INTO e01_778_05_tb VALUES(210,'e03_120_02_tr','N11','guard',NULL,'e03_120_02_tr','Type closure insert guard',1,'2026-09-29 20:46:37');
INSERT INTO e01_778_05_tb VALUES(211,'e03_120_03_tr','N11','guard',NULL,'e03_120_03_tr','Type closure update guard',1,'2026-09-29 20:46:37');
INSERT INTO e01_778_05_tb VALUES(212,'e03_434_02_tr','N41','sync',NULL,'e03_434_02_tr','FTS delete sync',1,'2026-09-29 20:46:37');
INSERT INTO e01_778_05_tb VALUES(213,'e03_434_03_tr','N41','sync',NULL,'e03_434_03_tr','FTS update sync',1,'2026-09-29 20:46:37');
INSERT INTO e01_778_05_tb VALUES(214,'e03_434_04_tr','N41','sync',NULL,'e03_434_04_tr','label_norm insert sync',1,'2026-09-29 20:46:37');
INSERT INTO e01_778_05_tb VALUES(215,'e03_434_05_tr','N41','sync',NULL,'e03_434_05_tr','label_norm update sync',1,'2026-09-29 20:46:37');
INSERT INTO e01_778_05_tb VALUES(216,'e03_778_02_ins_tr','N70','guard',NULL,'e03_778_02_ins_tr','Matrix insert guard for element and need validation',1,'2026-09-29 20:59:55');
CREATE TABLE _baseline_v26 (kind TEXT NOT NULL, id INTEGER, label TEXT, details TEXT, captured_at TEXT NOT NULL DEFAULT (datetime('now')));
INSERT INTO _baseline_v26 VALUES('fk',1,'e01_516_01_tb.need_uid to e01_506_01_tb.need_uid','restrict','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('fk',2,'e01_516_01_tb.atom_uid to e01_506_02_tb.atom_uid','restrict','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('fk',3,'e01_506_03_tb.need_uid to e01_506_01_tb.need_uid','restrict','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('fk',4,'e01_506_04_tb.atom_uid to e01_506_02_tb.atom_uid','restrict','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('fk',5,'e01_506_04_tb.element_name to e01_506_03_tb.element_name','restrict','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('fk',6,'e01_506_05_tb.parent_uid to e01_506_05_tb.question_uid','restrict','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('fk',7,'e01_506_06_tb.need_uid to e01_506_01_tb.need_uid','restrict','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('fk',8,'e01_506_06_tb.parent_id to e01_506_06_tb.node_id','restrict','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('fk',9,'e01_506_06_tb.question_uid to e01_506_05_tb.question_uid','restrict','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('fk',10,'e01_506_08_tb.dim_uid to e01_506_07_tb.dim_uid','restrict','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('fk',11,'e01_200_01_tb.parent_id to e01_200_01_tb.type_id','restrict','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('fk',12,'e01_120_01_tb.desc_id to e01_200_01_tb.type_id','restrict','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('fk',13,'e01_120_01_tb.anc_id to e01_200_01_tb.type_id','restrict','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('fk',14,'e01_202_01_tb.inverse_uid to e01_202_01_tb.type_uid','set_null','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('fk',15,'e01_112_01_tb.reltype_id to e01_202_01_tb.reltype_id','restrict','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('fk',16,'e01_112_01_tb.target_type_id to e01_200_01_tb.type_id','restrict','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('fk',17,'e01_201_01_tb.dom_id to e01_200_02_tb.dom_id','restrict','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('fk',18,'e01_201_03_tb.parent_id to e01_201_02_tb.val_id','cascade','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('fk',19,'e01_201_03_tb.member_val_id to e01_201_02_tb.val_id','restrict','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('fk',20,'e01_201_03_tb.member_ent_id to e01_200_03_tb.ent_id','restrict','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('fk',21,'e01_200_03_tb.type_id to e01_200_01_tb.type_id','restrict','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('fk',22,'e01_200_03_tb.prv_id to e01_303_01_tb.prv_id','set_null','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('fk',23,'e01_201_02_tb.enum_id to e01_201_01_tb.val_id','restrict','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('fk',24,'e01_201_02_tb.prv_id to e01_303_01_tb.prv_id','set_null','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('fk',25,'e01_302_01_tb.subj_ent_id to e01_200_03_tb.ent_id','restrict','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('fk',26,'e01_302_01_tb.reltype_id to e01_202_01_tb.reltype_id','restrict','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('fk',27,'e01_222_01_tb.lin_id to e01_302_01_tb.lin_id','set_null','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('fk',28,'e01_222_01_tb.reltype_id to e01_202_01_tb.reltype_id','restrict','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('fk',29,'e01_222_01_tb.subj_ent_id to e01_200_03_tb.ent_id','restrict','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('fk',30,'e01_222_01_tb.obj_ent_id to e01_200_03_tb.ent_id','restrict','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('fk',31,'e01_222_01_tb.obj_val_id to e01_201_02_tb.val_id','restrict','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('fk',32,'e01_222_01_tb.reif_ent_id to e01_200_03_tb.ent_id','restrict','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('fk',33,'e01_222_01_tb.prv_id to e01_303_01_tb.prv_id','set_null','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('fk',34,'e01_305_01_tb.ent_id to e01_200_03_tb.ent_id','restrict','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('fk',35,'e01_305_01_tb.ctx_ent_id to e01_200_03_tb.ent_id','restrict','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('fk',36,'e01_305_01_tb.ctx_val_id to e01_201_02_tb.val_id','restrict','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('fk',37,'e01_305_01_tb.prv_id to e01_303_01_tb.prv_id','set_null','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('fk',38,'e01_305_02_tb.val_id to e01_201_02_tb.val_id','cascade','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('fk',39,'e01_305_02_tb.ctx_ent_id to e01_200_03_tb.ent_id','restrict','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('fk',40,'e01_305_02_tb.ctx_val_id to e01_201_02_tb.val_id','restrict','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('fk',41,'e01_305_02_tb.prv_id to e01_303_01_tb.prv_id','set_null','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('fk',42,'e01_305_03_tb.rel_id to e01_222_01_tb.rel_id','restrict','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('fk',43,'e01_305_03_tb.ctx_ent_id to e01_200_03_tb.ent_id','restrict','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('fk',44,'e01_305_03_tb.ctx_val_id to e01_201_02_tb.val_id','restrict','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('fk',45,'e01_305_03_tb.prv_id to e01_303_01_tb.prv_id','set_null','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('fk',46,'e01_300_01_tb.ent_a_id to e01_200_03_tb.ent_id','restrict','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('fk',47,'e01_300_01_tb.ent_b_id to e01_200_03_tb.ent_id','restrict','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('fk',48,'e01_300_01_tb.prv_id to e01_303_01_tb.prv_id','set_null','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('fk',49,'e01_330_01_tb.ent_id to e01_200_03_tb.ent_id','restrict','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('fk',50,'e01_330_01_tb.supersedes_id to e01_330_01_tb.vers_id','restrict','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('fk',51,'e01_330_01_tb.approved_by_id to e01_200_03_tb.ent_id','restrict','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('fk',52,'e01_330_02_tb.ent_id to e01_200_03_tb.ent_id','restrict','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('fk',53,'e01_330_02_tb.vers_id to e01_330_01_tb.vers_id','restrict','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('fk',54,'e01_778_01_tb.need_uid to e01_506_01_tb.need_uid','restrict','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('fk',55,'e01_778_01_tb.parent_code to e01_778_01_tb.code','restrict','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('fk',56,'e01_778_02_tb.element_name to e01_506_03_tb.element_name','restrict','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('fk',57,'e01_778_02_tb.need_uid to e01_506_01_tb.need_uid','restrict','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('fk',58,'e01_778_02_tb.code to e01_778_01_tb.code','restrict','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('fk',59,'e01_778_03_tb.root_need_uid to e01_506_01_tb.need_uid','restrict','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('fk',60,'e01_778_04_tb.chain_uid to e01_778_03_tb.chain_uid','restrict','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('fk',61,'e01_778_04_tb.element_name to e01_506_03_tb.element_name','set_null','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('fk',62,'e01_778_04_tb.need_uid to e01_506_01_tb.need_uid','set_null','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('fk',63,'e01_506_02_tb.verb_code to e01_506_09_tb.verb_code','restrict','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('fk',64,'e01_506_02_tb.entity_code to e01_506_10_tb.entity_code','restrict','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('fk',65,'e01_506_02_tb.constraint_code to e01_506_11_tb.constraint_code','restrict','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('fk',66,'e01_778_05_tb.element_name to e01_506_03_tb.element_name','restrict','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('fk',67,'e01_778_05_tb.need_uid to e01_506_01_tb.need_uid','restrict','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('fk',68,'e01_778_05_tb.fk_ref_id to e01_378_01_tb.ref_id','restrict','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('fk',69,'e01_778_05_tb.exec_name to e01_506_03_tb.element_name','restrict','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('trigger',NULL,'e03_312_01_tr','e01_222_01_tb','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('trigger',NULL,'e03_312_02_tr','e01_222_01_tb','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('trigger',NULL,'e03_112_01_tr','e01_222_01_tb','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('trigger',NULL,'e03_135_01_tr','e01_305_03_tb','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('trigger',NULL,'e03_135_02_tr','e01_305_03_tb','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('trigger',NULL,'e03_135_03_tr','e01_305_03_tb','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('trigger',NULL,'e03_343_01_tr','e01_200_03_tb','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('trigger',NULL,'e03_343_02_tr','e01_201_02_tb','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('trigger',NULL,'e03_343_03_tr','e01_222_01_tb','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('trigger',NULL,'e03_343_04_tr','e01_305_01_tb','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('trigger',NULL,'e03_343_05_tr','e01_305_02_tb','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('trigger',NULL,'e03_343_06_tr','e01_305_03_tb','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('trigger',NULL,'e03_343_07_tr','e01_300_01_tb','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('trigger',NULL,'e03_343_08_tr','e01_303_01_tb','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('trigger',NULL,'e03_343_09_tr','e01_303_01_tb','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('trigger',NULL,'e03_311_01_tr','e01_201_02_tb','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('trigger',NULL,'e03_311_02_tr','e01_201_02_tb','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('trigger',NULL,'e03_311_03_tr','e01_201_03_tb','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('trigger',NULL,'e03_311_04_tr','e01_201_03_tb','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('trigger',NULL,'e03_516_01_tr','e01_506_06_tb','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('trigger',NULL,'e03_516_02_tr','e01_506_06_tb','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('trigger',NULL,'e03_126_01_tr','e01_506_06_tb','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('trigger',NULL,'e03_126_02_tr','e01_506_05_tb','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('trigger',NULL,'e03_126_03_tr','e01_506_05_tb','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('trigger',NULL,'e03_320_01_tr','e01_200_03_tb','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('trigger',NULL,'e03_320_02_tr','e01_201_02_tb','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('trigger',NULL,'e03_320_03_tr','e01_200_01_tb','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('trigger',NULL,'e03_320_04_tr','e01_202_01_tb','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('trigger',NULL,'e03_320_05_tr','e01_303_01_tb','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('trigger',NULL,'e03_320_06_tr','e01_302_01_tb','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('trigger',NULL,'e03_320_07_tr','e01_200_02_tb','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('trigger',NULL,'e03_320_08_tr','e01_201_01_tb','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('trigger',NULL,'e03_320_09_tr','e01_200_03_tb','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('trigger',NULL,'e03_370_30_tr','e01_778_01_tb','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('trigger',NULL,'e03_370_32_tr','e01_778_01_tb','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('trigger',NULL,'e03_370_33_tr','e01_778_02_tb','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('trigger',NULL,'e03_370_34_tr','e01_778_04_tb','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('trigger',NULL,'e03_360_01_tr','e01_222_01_tb','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('trigger',NULL,'e03_370_01_tr','e01_516_01_tb','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('trigger',NULL,'e03_370_02_tr','e01_506_03_tb','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('trigger',NULL,'e03_370_03_tr','e01_506_04_tb','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('trigger',NULL,'e03_370_04_tr','e01_506_08_tb','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('trigger',NULL,'e03_370_05_tr','e01_506_06_tb','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('trigger',NULL,'e03_370_06_tr','e01_506_05_tb','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('trigger',NULL,'e03_370_07_tr','e01_330_01_tb','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('trigger',NULL,'e03_370_08_tr','e01_330_02_tb','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('trigger',NULL,'e03_370_11_tr','e01_516_01_tb','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('trigger',NULL,'e03_370_12_tr','e01_506_03_tb','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('trigger',NULL,'e03_370_13_tr','e01_506_04_tb','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('trigger',NULL,'e03_370_14_tr','e01_506_08_tb','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('trigger',NULL,'e03_370_15_tr','e01_506_06_tb','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('trigger',NULL,'e03_370_16_tr','e01_506_05_tb','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('trigger',NULL,'e03_370_17_tr','e01_330_01_tb','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('trigger',NULL,'e03_370_18_tr','e01_330_02_tb','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('trigger',NULL,'e03_370_21_tr','e01_506_01_tb','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('trigger',NULL,'e03_370_22_tr','e01_506_02_tb','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('trigger',NULL,'e03_370_23_tr','e01_506_03_tb','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('trigger',NULL,'e03_370_24_tr','e01_506_07_tb','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('trigger',NULL,'e03_370_25_tr','e01_506_05_tb','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('trigger',NULL,'e03_370_26_tr','e01_330_01_tb','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('trigger',NULL,'e03_310_03_tr','e01_201_02_tb','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('trigger',NULL,'e03_310_04_tr','e01_201_02_tb','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('trigger',NULL,'e03_310_05_tr','e01_201_03_tb','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('trigger',NULL,'e03_310_06_tr','e01_201_03_tb','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('trigger',NULL,'e03_328_01_tr','e01_506_01_tb','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('trigger',NULL,'e03_328_02_tr','e01_506_02_tb','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('trigger',NULL,'e03_328_03_tr','e01_516_01_tb','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('trigger',NULL,'e03_328_04_tr','e01_506_03_tb','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('trigger',NULL,'e03_328_05_tr','e01_506_04_tb','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('trigger',NULL,'e03_328_06_tr','e01_506_05_tb','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('trigger',NULL,'e03_328_07_tr','e01_506_06_tb','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('trigger',NULL,'e03_328_08_tr','e01_676_01_tb','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('trigger',NULL,'e03_328_09_tr','e01_676_02_tb','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('trigger',NULL,'e03_328_10_tr','e01_378_01_tb','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('trigger',NULL,'e03_328_11_tr','e01_506_07_tb','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('trigger',NULL,'e03_328_12_tr','e01_506_08_tb','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('trigger',NULL,'e03_328_13_tr','e01_200_01_tb','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('trigger',NULL,'e03_328_14_tr','e01_120_01_tb','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('trigger',NULL,'e03_328_15_tr','e01_202_01_tb','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('trigger',NULL,'e03_328_16_tr','e01_112_01_tb','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('trigger',NULL,'e03_328_17_tr','e01_200_02_tb','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('trigger',NULL,'e03_328_18_tr','e01_201_01_tb','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('trigger',NULL,'e03_328_19_tr','e01_303_01_tb','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('trigger',NULL,'e03_328_20_tr','e01_200_03_tb','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('trigger',NULL,'e03_328_21_tr','e01_201_02_tb','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('trigger',NULL,'e03_328_22_tr','e01_201_03_tb','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('trigger',NULL,'e03_328_23_tr','e01_302_01_tb','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('trigger',NULL,'e03_328_24_tr','e01_222_01_tb','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('trigger',NULL,'e03_328_25_tr','e01_305_01_tb','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('trigger',NULL,'e03_328_26_tr','e01_305_02_tb','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('trigger',NULL,'e03_328_27_tr','e01_305_03_tb','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('trigger',NULL,'e03_328_28_tr','e01_300_01_tb','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('trigger',NULL,'e03_328_29_tr','e01_330_01_tb','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('trigger',NULL,'e03_328_30_tr','e01_330_02_tb','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('trigger',NULL,'e03_328_31_tr','e01_303_01_tb','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('trigger',NULL,'e03_328_32_tr','e01_676_02_tb','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('trigger',NULL,'e03_328_33_tr','e01_506_09_tb','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('trigger',NULL,'e03_328_34_tr','e01_506_10_tb','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('trigger',NULL,'e03_328_35_tr','e01_506_11_tb','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('trigger',NULL,'e03_328_36_tr','e01_676_02_tb','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('trigger',NULL,'e03_328_37_tr','e01_676_03_tb','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('trigger',NULL,'e03_778_10_tr','e01_778_05_tb','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('trigger',NULL,'e03_778_10b_tr','e01_778_05_tb','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('trigger',NULL,'e03_778_11_tr','e01_778_05_tb','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('trigger',NULL,'e03_778_13_tr','e01_778_05_tb','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('trigger',NULL,'e03_778_14_tr','e01_778_02_tb','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('view',NULL,'e04_200_01_vw',NULL,'2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('view',NULL,'e04_230_01_vw',NULL,'2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('view',NULL,'e04_230_02_vw',NULL,'2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('view',NULL,'e04_340_01_vw',NULL,'2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('view',NULL,'e04_340_02_vw',NULL,'2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('view',NULL,'e04_340_04_vw',NULL,'2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('view',NULL,'e04_325_01_vw',NULL,'2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('view',NULL,'e04_310_01_vw',NULL,'2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('view',NULL,'e04_311_01_vw',NULL,'2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('view',NULL,'e04_122_01_vw',NULL,'2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('view',NULL,'e04_267_01_vw',NULL,'2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('view',NULL,'e04_267_02_vw',NULL,'2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('view',NULL,'e04_260_01_vw',NULL,'2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('view',NULL,'e04_260_02_vw',NULL,'2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('view',NULL,'e04_260_03_vw',NULL,'2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('view',NULL,'e04_110_01_vw',NULL,'2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('view',NULL,'e04_110_02_vw',NULL,'2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('view',NULL,'e04_310_02_vw',NULL,'2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('view',NULL,'e04_978_01_vw',NULL,'2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('matrix',NULL,'e01_506_09_tb to N50','defines','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('matrix',NULL,'e01_506_10_tb to N50','defines','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('matrix',NULL,'e01_506_11_tb to N50','defines','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('matrix',NULL,'e03_112_01_tr to N13','defines','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('matrix',NULL,'e03_120_01_tr to N11','defines','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('matrix',NULL,'e03_120_04_tr to N10','defines','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('matrix',NULL,'e03_120_05_tr to N10','defines','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('matrix',NULL,'e03_122_01_tr to N11','defines','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('matrix',NULL,'e03_122_02_tr to N11','defines','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('matrix',NULL,'e03_126_01_tr to N11','serves','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('matrix',NULL,'e03_126_03_tr to N11','serves','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('matrix',NULL,'e03_135_01_tr to N15','defines','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('matrix',NULL,'e03_312_01_tr to N12','defines','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('matrix',NULL,'e03_312_01_tr to N13','serves','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('matrix',NULL,'e03_312_01_tr to N14','serves','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('matrix',NULL,'e03_312_02_tr to N12','defines','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('matrix',NULL,'e03_320_01_tr to N30','defines','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('matrix',NULL,'e03_343_01_tr to N31','defines','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('matrix',NULL,'e03_434_01_tr to N41','defines','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('matrix',NULL,'e04_110_01_vw to N11','verifies','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('matrix',NULL,'e04_200_01_vw to N20','defines','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('matrix',NULL,'e04_267_01_vw to N20','defines','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('matrix',NULL,'e04_310_02_vw to N30','verifies','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('matrix',NULL,'e04_978_01_vw to N99','verifies','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e01_506_01_tb','M|tb','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e01_506_09_tb','M|tb','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e01_506_10_tb','M|tb','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e01_506_11_tb','M|tb','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e01_506_02_tb','M|tb','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e02_506_10_ix','M|ix','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e02_506_11_ix','M|ix','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e02_506_12_ix','M|ix','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e02_506_13_ix','M|ix','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e02_506_14_ix','M|ix','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e01_516_01_tb','M|tb','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e02_516_10_ix','M|ix','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e02_516_11_ix','M|ix','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e01_506_03_tb','M|tb','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e02_506_15_ix','M|ix','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e02_506_16_ix','M|ix','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e02_506_17_ix','M|ix','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e01_506_04_tb','M|tb','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e02_506_18_ix','M|ix','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e02_506_19_ix','M|ix','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e01_506_05_tb','M|tb','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e02_506_20_ix','M|ix','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e01_506_06_tb','M|tb','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e02_506_21_ix','M|ix','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e02_506_22_ix','M|ix','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e02_506_23_ix','M|ix','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e02_506_24_ix','M|ix','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e01_676_01_tb','M|tb','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e01_676_02_tb','M|tb','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e01_676_03_tb','M|tb','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e01_378_01_tb','M|tb','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e02_378_10_ix','M|ix','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e02_378_11_ix','M|ix','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e01_506_07_tb','M|tb','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e01_506_08_tb','M|tb','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e02_506_25_ix','M|ix','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e01_778_01_tb','M|tb','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e02_778_10_ix','M|ix','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e02_778_11_ix','M|ix','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e02_778_12_ix','M|ix','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e01_778_02_tb','M|tb','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e02_778_20_ix','M|ix','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e02_778_21_ix','M|ix','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e02_778_22_ix','M|ix','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e02_778_23_ix','M|ix','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e01_778_03_tb','M|tb','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e02_778_30_ix','M|ix','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e02_778_31_ix','M|ix','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e01_778_04_tb','M|tb','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e02_778_40_ix','M|ix','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e02_778_41_ix','M|ix','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e02_778_42_ix','M|ix','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e01_200_01_tb','T|tb','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e02_200_10_ix','M|ix','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e01_120_01_tb','T|tb','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e02_120_10_ix','M|ix','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e01_202_01_tb','T|tb','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e02_202_10_ix','M|ix','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e02_202_11_ix','M|ix','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e01_112_01_tb','T|tb','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e02_112_10_ix','M|ix','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e02_112_11_ix','M|ix','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e02_112_12_ix','M|ix','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e02_112_13_ix','M|ix','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e01_200_02_tb','T|tb','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e01_201_01_tb','T|tb','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e02_201_10_ix','M|ix','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e01_303_01_tb','C|tb','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e02_303_10_ix','M|ix','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e02_303_11_ix','M|ix','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e02_303_12_ix','M|ix','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e01_200_03_tb','C|tb','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e02_200_20_ix','M|ix','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e02_200_21_ix','M|ix','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e02_200_22_ix','M|ix','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e02_200_23_ix','M|ix','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e02_200_24_ix','M|ix','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e01_201_02_tb','C|tb','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e02_201_20_ix','M|ix','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e02_201_21_ix','M|ix','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e02_201_22_ix','M|ix','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e02_201_23_ix','M|ix','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e02_201_24_ix','M|ix','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e02_201_25_ix','M|ix','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e01_201_03_tb','C|tb','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e02_201_30_ix','M|ix','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e02_201_31_ix','M|ix','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e02_201_32_ix','M|ix','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e01_302_01_tb','C|tb','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e02_302_10_ix','M|ix','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e02_302_11_ix','M|ix','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e01_222_01_tb','C|tb','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e02_222_10_ix','M|ix','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e02_222_11_ix','M|ix','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e02_222_12_ix','M|ix','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e02_222_13_ix','M|ix','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e02_222_14_ix','M|ix','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e02_222_15_ix','M|ix','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e02_222_16_ix','M|ix','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e02_222_17_ix','M|ix','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e02_222_18_ix','M|ix','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e02_222_19_ix','M|ix','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e02_222_20_ix','M|ix','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e01_305_01_tb','X|tb','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e02_305_10_ix','M|ix','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e02_305_11_ix','M|ix','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e02_305_12_ix','M|ix','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e01_305_02_tb','X|tb','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e02_305_20_ix','M|ix','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e02_305_21_ix','M|ix','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e02_305_22_ix','M|ix','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e01_305_03_tb','X|tb','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e02_305_30_ix','M|ix','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e02_305_31_ix','M|ix','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e02_305_32_ix','M|ix','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e01_300_01_tb','I|tb','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e02_300_10_ix','M|ix','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e02_300_11_ix','M|ix','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e02_300_12_ix','M|ix','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e02_300_13_ix','M|ix','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e01_330_01_tb','V|tb','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e02_330_10_ix','M|ix','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e01_330_02_tb','V|tb','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e02_330_20_ix','M|ix','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e02_330_21_ix','M|ix','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e03_312_01_tr','M|tr','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e03_312_02_tr','M|tr','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e03_112_01_tr','M|tr','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e03_135_01_tr','M|tr','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e03_135_02_tr','M|tr','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e03_135_03_tr','M|tr','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e03_343_01_tr','M|tr','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e03_343_02_tr','M|tr','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e03_343_03_tr','M|tr','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e03_343_04_tr','M|tr','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e03_343_05_tr','M|tr','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e03_343_06_tr','M|tr','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e03_343_07_tr','M|tr','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e03_343_08_tr','M|tr','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e03_343_09_tr','M|tr','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e03_311_01_tr','M|tr','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e03_311_02_tr','M|tr','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e03_311_03_tr','M|tr','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e03_311_04_tr','M|tr','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e03_516_01_tr','M|tr','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e03_516_02_tr','M|tr','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e03_126_01_tr','M|tr','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e03_126_02_tr','M|tr','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e03_126_03_tr','M|tr','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e03_320_01_tr','M|tr','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e03_320_02_tr','M|tr','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e03_320_03_tr','M|tr','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e03_320_04_tr','M|tr','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e03_320_05_tr','M|tr','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e03_320_06_tr','M|tr','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e03_320_07_tr','M|tr','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e03_320_08_tr','M|tr','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e03_320_09_tr','M|tr','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e03_370_30_tr','M|tr','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e03_370_32_tr','M|tr','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e03_370_33_tr','M|tr','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e03_370_34_tr','M|tr','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e03_360_01_tr','M|tr','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e03_370_01_tr','M|tr','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e03_370_02_tr','M|tr','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e03_370_03_tr','M|tr','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e03_370_04_tr','M|tr','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e03_370_05_tr','M|tr','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e03_370_06_tr','M|tr','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e03_370_07_tr','M|tr','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e03_370_08_tr','M|tr','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e03_370_11_tr','M|tr','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e03_370_12_tr','M|tr','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e03_370_13_tr','M|tr','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e03_370_14_tr','M|tr','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e03_370_15_tr','M|tr','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e03_370_16_tr','M|tr','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e03_370_17_tr','M|tr','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e03_370_18_tr','M|tr','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e03_370_21_tr','M|tr','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e03_370_22_tr','M|tr','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e03_370_23_tr','M|tr','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e03_370_24_tr','M|tr','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e03_370_25_tr','M|tr','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e03_370_26_tr','M|tr','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e03_310_03_tr','M|tr','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e03_310_04_tr','M|tr','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e03_310_05_tr','M|tr','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e03_310_06_tr','M|tr','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e03_328_01_tr','M|tr','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e03_328_02_tr','M|tr','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e03_328_03_tr','M|tr','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e03_328_04_tr','M|tr','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e03_328_05_tr','M|tr','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e03_328_06_tr','M|tr','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e03_328_07_tr','M|tr','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e03_328_08_tr','M|tr','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e03_328_09_tr','M|tr','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e03_328_10_tr','M|tr','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e03_328_11_tr','M|tr','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e03_328_12_tr','M|tr','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e03_328_13_tr','M|tr','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e03_328_14_tr','M|tr','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e03_328_15_tr','M|tr','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e03_328_16_tr','M|tr','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e03_328_17_tr','M|tr','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e03_328_18_tr','M|tr','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e03_328_19_tr','M|tr','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e03_328_20_tr','M|tr','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e03_328_21_tr','M|tr','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e03_328_22_tr','M|tr','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e03_328_23_tr','M|tr','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e03_328_24_tr','M|tr','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e03_328_25_tr','M|tr','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e03_328_26_tr','M|tr','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e03_328_27_tr','M|tr','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e03_328_28_tr','M|tr','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e03_328_29_tr','M|tr','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e03_328_30_tr','M|tr','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e03_328_31_tr','M|tr','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e03_328_32_tr','M|tr','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e03_328_33_tr','M|tr','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e03_328_34_tr','M|tr','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e03_328_35_tr','M|tr','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e03_328_36_tr','M|tr','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e03_328_37_tr','M|tr','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e04_200_01_vw','M|vw','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e04_230_01_vw','M|vw','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e04_230_02_vw','M|vw','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e04_340_01_vw','M|vw','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e04_340_02_vw','M|vw','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e04_340_04_vw','M|vw','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e04_325_01_vw','M|vw','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e04_310_01_vw','M|vw','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e04_311_01_vw','M|vw','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e04_122_01_vw','M|vw','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e04_267_01_vw','M|vw','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e04_267_02_vw','M|vw','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e04_260_01_vw','M|vw','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e04_260_02_vw','M|vw','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e04_260_03_vw','M|vw','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e04_110_01_vw','M|vw','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e04_110_02_vw','M|vw','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e04_310_02_vw','M|vw','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e04_978_01_vw','M|vw','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e02_404_01_ft','A|ft','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e01_778_05_tb','M|tb','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e02_778_50_ix','M|ix','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e02_778_51_ix','M|ix','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e02_778_52_ix','M|ix','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e02_778_53_ix','M|ix','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e02_778_54_ix','M|ix','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e03_778_10_tr','M|tr','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e03_778_11_tr','M|tr','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e03_778_13_tr','M|tr','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('element',NULL,'e03_778_14_tr','M|tr','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('need',NULL,'N00','domain|active','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('need',NULL,'N01','user|active','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('need',NULL,'N02','user|active','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('need',NULL,'N03','user|active','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('need',NULL,'N10','system|active','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('need',NULL,'N11','system|active','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('need',NULL,'N12','system|active','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('need',NULL,'N13','system|active','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('need',NULL,'N14','system|active','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('need',NULL,'N15','system|active','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('need',NULL,'N20','domain|active','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('need',NULL,'N21','domain|active','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('need',NULL,'N22','domain|active','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('need',NULL,'N23','domain|active','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('need',NULL,'N30','quality|active','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('need',NULL,'N31','quality|active','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('need',NULL,'N32','quality|active','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('need',NULL,'N33','quality|active','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('need',NULL,'N34','quality|active','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('need',NULL,'N40','performance|active','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('need',NULL,'N41','performance|active','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('need',NULL,'N42','performance|active','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('need',NULL,'N50','quality|active','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('need',NULL,'N51','quality|active','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('need',NULL,'N52','quality|active','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('need',NULL,'N60','performance|deferred','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('need',NULL,'N61','domain|deferred','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('need',NULL,'N62','quality|deferred','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('need',NULL,'N63','quality|deferred','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('need',NULL,'N70','quality|active','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('need',NULL,'N71','quality|active','2026-09-29 18:10:55');
INSERT INTO _baseline_v26 VALUES('need',NULL,'N99','quality|active','2026-09-29 18:10:55');
CREATE TABLE IF NOT EXISTS 'e02_404_01_ft_data'(id INTEGER PRIMARY KEY, block BLOB);
INSERT INTO e02_404_01_ft_data VALUES(1,X'0f64814c');
INSERT INTO e02_404_01_ft_data VALUES(10,X'000000000103030003010101020101030101');
INSERT INTO e02_404_01_ft_data VALUES(137438953473,X'000003ee043020636c050601010a0202656c060601010602026f70040601010a03060101090202726f02060101090106010109020273680806010106030177010601010601032d737704020401020401033033300b020301033132760a0601010201033330310b02040103616c6c0406010106010601010602026e640906010104020272640906010107030179070601010602027465030601010603016f0302060301740a020301036261740a02020103632d730502030202616c060601010e02026c6f050601010b02026f6906080201010201020201080201010201020202027420020601010703016f020207030172060601010a0103646172090601010601036520720306010108030173010601010502026374020806010106040601010902026c65060806010107020272790a020601036669720b060101050103686f720808070101080103696361060601010d02026c200606010104020601010403016506020403016f07020403017308020402026d610706010104020272650b06010106020273660b0601010303016f0308020101020202746301080401010903020701020701036c2065060601010503017308060101050202617403080501010502026520010601010403016306080701010803016c06020502026c790406010107010601010702026f70070205030173050601010c02027368080205020279200406010108010601010801036d616c040601010501060101050301720706010105020269730b0601010201036e632d05020202026461090601010502026f2d0402020301720406010102010601010201036f2d730402030202696c06080301010301020301080301010301020302026c610308040101040301650106010103010601010b010601010b02027065040601010b03080601010a0202726d0406010103010601010303017408080801010902027365050601010d0202746502080401010401037030330b02020202656e040601010c03080701010b02027269070601010203016f0208020101020103726963060601010c03016d070601010302026d610406010104010601010402026f6c0106010102010601010a010601010a0301740208030101030202792007060101070103736564050601010e020266690b060101040202686f08080601010702026f6c03080301010302027461090601010202027769010802010107030205010205010374207202060101080202616e09060101030202636801080501010a0302080102080202652003060101070301630208050101050301720a020502026f7202020801020702027269060601010b020274650a020401037769740108030101080302060102060103792063050601010903016f04060101090306010108040a090e0e09080b080a080f09090809060608080909160906080a0a080f0a070a0b0a0e06060609090909100a080a0909060e0708070e0f08090809070d08160a120f0e09090a080f09090a080e1309090a090a0a09100a09100909060a0907110a');
INSERT INTO e02_404_01_ft_data VALUES(274877906945,X'000002c504302034300e06010114020238300d06010110020261620d0601010a010601010e0202636f0c080101080d020268750d0206020270650d06010113020273740c080601010d020274650e06010109020277650e020501033020700d0601011201033430630e0601011501033830200d06010111010361626f0d0601010b010601010f02026d620e06010102020272740c0809010110020274680e020801036269650e0601010402026f760d0601010c0106010110010363656e0d0601011702026f6c0c080201010903016e0c0601011401036420730c080501010c020269740c0601011701080b01010601036520340e060101130301380d0601010f0301630c06010107020261740e020702026d700e0601010b02026e670c060101020301740d060101180106010106020272630d0601011501036768200d02040202696e0c0601010401036820680d0205020265720e020a020269670d020202026f740e02020202756d0d080701010201036964690d080a0101050202656e0e06010105020267680d020302026e650c0601010502026f6e0c0601011a020274690c060101180301790d080c01010701036c64200c080401010b01036d62690e06010103020269640d0809010104020270200e0601010c01036e64690c06010116020265200c06010106020267690c06010103020274200e0601010701036f6c640c080301010a02026e640c06010115020274200e0203020276650d0601010d010601011101037020610e0601010d020265720d0601011401037263650d06010116020274200c0601011101037374610c080701010e01037420630c060101120301740e060101080301770e0204020261720c080801010f0202656d0e0601010a020268650e02090202696f0c06010119020279200d060101080103756d690d080801010301037665200d0601010e010601011201037765610e020601037920610d06010109040a090e0a07090a09070a0a0a0f090a070a0e0a0a080b0f0a08080709090d090809080707070a0b0907090909090b0a0a090a0909090b09070e0a090a090b0a08060a090709090b0f08');
INSERT INTO e02_404_01_ft_data VALUES(412316860417,X'0000019b04302064750f02060202656e0f0601010b0202666f0f06010111020269640f0601011d02026c610f06010126020274650f0601011501036174650f080d010108020279650f0601012801036361740f080c01010702026f690f0202010364656e0f0601011f020275700f080701010201036520650f0601010a02026e740f0801010c16020273740f060101170103666f720f0601011201036720690f0601011c01036963610f080b010106020264650f0601011e02026c200f020402026e670f0601011a020274790f0601012301036c20640f0205020261790f06010127020269630f080a01010501036e67200f0601011b020274690f060101210301720f0601010d01036f696c0f0203020272200f060101130103706c690f080901010401037220740f06010114020279200f0601010f01037374690f0601011801037465200f060101090301730f060101160202696e0f060101190301740f06010122020272790f0601010e020279200f06010124010375706c0f080801010301037920660f0601011003016c0f06010125020265720f06010129040809090909090b090b070a0a0a0a090a0a0b0907090908090a0a090808090b0a090a0a08090809090b0a08');
CREATE TABLE IF NOT EXISTS 'e02_404_01_ft_idx'(segid, term, pgno, PRIMARY KEY(segid, term)) WITHOUT ROWID;
INSERT INTO e02_404_01_ft_idx VALUES(1,X'',2);
INSERT INTO e02_404_01_ft_idx VALUES(2,X'',2);
INSERT INTO e02_404_01_ft_idx VALUES(3,X'',2);
CREATE TABLE IF NOT EXISTS 'e02_404_01_ft_docsize'(id INTEGER PRIMARY KEY, sz BLOB);
INSERT INTO e02_404_01_ft_docsize VALUES(1,X'0409');
INSERT INTO e02_404_01_ft_docsize VALUES(2,X'070a');
INSERT INTO e02_404_01_ft_docsize VALUES(3,X'060a');
INSERT INTO e02_404_01_ft_docsize VALUES(4,X'070b');
INSERT INTO e02_404_01_ft_docsize VALUES(5,X'070d');
INSERT INTO e02_404_01_ft_docsize VALUES(6,X'060d');
INSERT INTO e02_404_01_ft_docsize VALUES(7,X'060a');
INSERT INTO e02_404_01_ft_docsize VALUES(8,X'0708');
INSERT INTO e02_404_01_ft_docsize VALUES(9,X'0206');
INSERT INTO e02_404_01_ft_docsize VALUES(10,X'0501');
INSERT INTO e02_404_01_ft_docsize VALUES(11,X'0305');
INSERT INTO e02_404_01_ft_docsize VALUES(12,X'0819');
INSERT INTO e02_404_01_ft_docsize VALUES(13,X'0b17');
INSERT INTO e02_404_01_ft_docsize VALUES(14,X'0914');
INSERT INTO e02_404_01_ft_docsize VALUES(15,X'0c28');
CREATE TABLE IF NOT EXISTS 'e02_404_01_ft_config'(k PRIMARY KEY, v) WITHOUT ROWID;
INSERT INTO e02_404_01_ft_config VALUES('version',4);
CREATE TABLE e01_516_01_tb (
    need_uid  TEXT NOT NULL,
    atom_uid  TEXT NOT NULL,
    kind      TEXT NOT NULL DEFAULT 'derived'
              CHECK(kind IN ('derived','refined','satisfies')),
    origin    TEXT NOT NULL DEFAULT 'design'
              CHECK(origin IN ('design','inferred','observed','derived')),
    PRIMARY KEY (need_uid, atom_uid, kind),
    CONSTRAINT fk_nea_need FOREIGN KEY (need_uid)
        REFERENCES e01_506_01_tb(need_uid) ON DELETE RESTRICT,
    CONSTRAINT fk_nea_atom FOREIGN KEY (atom_uid)
        REFERENCES e01_506_02_tb(atom_uid) ON DELETE RESTRICT
) WITHOUT ROWID;
INSERT INTO e01_516_01_tb VALUES('N00','H05','satisfies','design');
INSERT INTO e01_516_01_tb VALUES('N01','G01','satisfies','design');
INSERT INTO e01_516_01_tb VALUES('N02','H05','satisfies','design');
INSERT INTO e01_516_01_tb VALUES('N03','F03','satisfies','design');
INSERT INTO e01_516_01_tb VALUES('N10','B06','satisfies','design');
INSERT INTO e01_516_01_tb VALUES('N11','C01','satisfies','design');
INSERT INTO e01_516_01_tb VALUES('N11','C02','satisfies','design');
INSERT INTO e01_516_01_tb VALUES('N12','B06','satisfies','design');
INSERT INTO e01_516_01_tb VALUES('N12','B10','satisfies','design');
INSERT INTO e01_516_01_tb VALUES('N13','B06','satisfies','design');
INSERT INTO e01_516_01_tb VALUES('N14','B06','satisfies','design');
INSERT INTO e01_516_01_tb VALUES('N15','D05','satisfies','design');
INSERT INTO e01_516_01_tb VALUES('N20','A01','refined','design');
INSERT INTO e01_516_01_tb VALUES('N20','A02','refined','design');
INSERT INTO e01_516_01_tb VALUES('N20','A03','refined','design');
INSERT INTO e01_516_01_tb VALUES('N20','G01','satisfies','design');
INSERT INTO e01_516_01_tb VALUES('N21','G01','satisfies','design');
INSERT INTO e01_516_01_tb VALUES('N22','H05','satisfies','design');
INSERT INTO e01_516_01_tb VALUES('N23','A01','satisfies','design');
INSERT INTO e01_516_01_tb VALUES('N30','R01','satisfies','design');
INSERT INTO e01_516_01_tb VALUES('N30','R02','satisfies','design');
INSERT INTO e01_516_01_tb VALUES('N30','R03','satisfies','design');
INSERT INTO e01_516_01_tb VALUES('N30','R04','satisfies','design');
INSERT INTO e01_516_01_tb VALUES('N30','R05','satisfies','design');
INSERT INTO e01_516_01_tb VALUES('N30','R06','satisfies','design');
INSERT INTO e01_516_01_tb VALUES('N30','R07','satisfies','design');
INSERT INTO e01_516_01_tb VALUES('N30','R08','satisfies','design');
INSERT INTO e01_516_01_tb VALUES('N30','R09','satisfies','design');
INSERT INTO e01_516_01_tb VALUES('N30','R10','satisfies','design');
INSERT INTO e01_516_01_tb VALUES('N30','R11','satisfies','design');
INSERT INTO e01_516_01_tb VALUES('N30','R12','satisfies','design');
INSERT INTO e01_516_01_tb VALUES('N30','R13','satisfies','design');
INSERT INTO e01_516_01_tb VALUES('N30','R14','satisfies','design');
INSERT INTO e01_516_01_tb VALUES('N30','R15','satisfies','design');
INSERT INTO e01_516_01_tb VALUES('N30','R16','satisfies','design');
INSERT INTO e01_516_01_tb VALUES('N30','R17','satisfies','design');
INSERT INTO e01_516_01_tb VALUES('N30','R18','satisfies','design');
INSERT INTO e01_516_01_tb VALUES('N30','R19','satisfies','design');
INSERT INTO e01_516_01_tb VALUES('N30','R20','satisfies','design');
INSERT INTO e01_516_01_tb VALUES('N30','R21','satisfies','design');
INSERT INTO e01_516_01_tb VALUES('N30','R22','satisfies','design');
INSERT INTO e01_516_01_tb VALUES('N30','R23','satisfies','design');
INSERT INTO e01_516_01_tb VALUES('N30','R24','satisfies','design');
INSERT INTO e01_516_01_tb VALUES('N30','R25','satisfies','design');
INSERT INTO e01_516_01_tb VALUES('N30','R26','satisfies','design');
INSERT INTO e01_516_01_tb VALUES('N30','R27','satisfies','design');
INSERT INTO e01_516_01_tb VALUES('N30','R28','satisfies','design');
INSERT INTO e01_516_01_tb VALUES('N30','R29','satisfies','design');
INSERT INTO e01_516_01_tb VALUES('N30','R30','satisfies','design');
INSERT INTO e01_516_01_tb VALUES('N30','R31','satisfies','design');
INSERT INTO e01_516_01_tb VALUES('N30','R32','satisfies','design');
INSERT INTO e01_516_01_tb VALUES('N30','R33','satisfies','design');
INSERT INTO e01_516_01_tb VALUES('N30','R34','satisfies','design');
INSERT INTO e01_516_01_tb VALUES('N30','R35','satisfies','design');
INSERT INTO e01_516_01_tb VALUES('N30','R36','satisfies','design');
INSERT INTO e01_516_01_tb VALUES('N30','R37','satisfies','design');
INSERT INTO e01_516_01_tb VALUES('N30','R38','satisfies','design');
INSERT INTO e01_516_01_tb VALUES('N30','R39','satisfies','design');
INSERT INTO e01_516_01_tb VALUES('N30','R40','satisfies','design');
INSERT INTO e01_516_01_tb VALUES('N30','R41','satisfies','design');
INSERT INTO e01_516_01_tb VALUES('N30','R42','satisfies','design');
INSERT INTO e01_516_01_tb VALUES('N30','R43','satisfies','design');
INSERT INTO e01_516_01_tb VALUES('N30','R44','satisfies','design');
INSERT INTO e01_516_01_tb VALUES('N30','R45','satisfies','design');
INSERT INTO e01_516_01_tb VALUES('N30','R46','satisfies','design');
INSERT INTO e01_516_01_tb VALUES('N30','R47','satisfies','design');
INSERT INTO e01_516_01_tb VALUES('N30','R48','satisfies','design');
INSERT INTO e01_516_01_tb VALUES('N30','R49','satisfies','design');
INSERT INTO e01_516_01_tb VALUES('N30','R50','satisfies','design');
INSERT INTO e01_516_01_tb VALUES('N30','R51','satisfies','design');
INSERT INTO e01_516_01_tb VALUES('N30','R52','satisfies','design');
INSERT INTO e01_516_01_tb VALUES('N30','R53','satisfies','design');
INSERT INTO e01_516_01_tb VALUES('N30','R54','satisfies','design');
INSERT INTO e01_516_01_tb VALUES('N30','R55','satisfies','design');
INSERT INTO e01_516_01_tb VALUES('N30','R56','satisfies','design');
INSERT INTO e01_516_01_tb VALUES('N30','R57','satisfies','design');
INSERT INTO e01_516_01_tb VALUES('N30','R58','satisfies','design');
INSERT INTO e01_516_01_tb VALUES('N30','R59','satisfies','design');
INSERT INTO e01_516_01_tb VALUES('N30','R60','satisfies','design');
INSERT INTO e01_516_01_tb VALUES('N30','R61','satisfies','design');
INSERT INTO e01_516_01_tb VALUES('N30','R62','satisfies','design');
INSERT INTO e01_516_01_tb VALUES('N30','R63','satisfies','design');
INSERT INTO e01_516_01_tb VALUES('N30','R64','satisfies','design');
INSERT INTO e01_516_01_tb VALUES('N30','R65','satisfies','design');
INSERT INTO e01_516_01_tb VALUES('N31','E01','satisfies','design');
INSERT INTO e01_516_01_tb VALUES('N32','D05','satisfies','design');
INSERT INTO e01_516_01_tb VALUES('N33','E01','satisfies','design');
INSERT INTO e01_516_01_tb VALUES('N41','D02','satisfies','design');
INSERT INTO e01_516_01_tb VALUES('N41','F03','satisfies','design');
INSERT INTO e01_516_01_tb VALUES('N42','D05','satisfies','design');
INSERT INTO e01_516_01_tb VALUES('N50','H05','satisfies','design');
INSERT INTO e01_516_01_tb VALUES('N99','H05','satisfies','design');
INSERT INTO e01_516_01_tb VALUES('N20','I11','satisfies','inferred');
INSERT INTO e01_516_01_tb VALUES('N30','I01','satisfies','inferred');
INSERT INTO e01_516_01_tb VALUES('N30','I05','satisfies','inferred');
INSERT INTO e01_516_01_tb VALUES('N30','I09','satisfies','inferred');
INSERT INTO e01_516_01_tb VALUES('N34','I10','satisfies','inferred');
INSERT INTO e01_516_01_tb VALUES('N40','I13','satisfies','inferred');
INSERT INTO e01_516_01_tb VALUES('N50','I02','satisfies','inferred');
INSERT INTO e01_516_01_tb VALUES('N50','I06','satisfies','inferred');
INSERT INTO e01_516_01_tb VALUES('N50','I07','satisfies','inferred');
INSERT INTO e01_516_01_tb VALUES('N50','I08','satisfies','inferred');
INSERT INTO e01_516_01_tb VALUES('N51','I03','satisfies','inferred');
INSERT INTO e01_516_01_tb VALUES('N52','I04','satisfies','inferred');
INSERT INTO e01_516_01_tb VALUES('N52','I12','satisfies','inferred');
CREATE TABLE e01_778_02_tb (
    element_name    TEXT NOT NULL,
    need_uid        TEXT NOT NULL,
    code            TEXT,
    is_primary      INTEGER NOT NULL DEFAULT 0 CHECK(is_primary IN (0,1)),
    is_driving      INTEGER NOT NULL DEFAULT 0 CHECK(is_driving IN (0,1)),
    role            TEXT NOT NULL DEFAULT 'serves'
                    CHECK(role IN
                       ('defines','serves','verifies','constrains',
                        'observes','maintains')),
    note            TEXT,
    PRIMARY KEY (element_name, need_uid, role),
    CONSTRAINT fk_er_elem FOREIGN KEY (element_name)
        REFERENCES e01_506_03_tb(element_name) ON DELETE RESTRICT,
    CONSTRAINT fk_er_need FOREIGN KEY (need_uid)
        REFERENCES e01_506_01_tb(need_uid) ON DELETE RESTRICT,
    CONSTRAINT fk_er_code FOREIGN KEY (code)
        REFERENCES e01_778_01_tb(code) ON DELETE RESTRICT
) WITHOUT ROWID;
INSERT INTO e01_778_02_tb VALUES('e01_112_01_tb','N30',NULL,0,0,'serves',NULL);
INSERT INTO e01_778_02_tb VALUES('e01_120_01_tb','N30',NULL,0,0,'serves',NULL);
INSERT INTO e01_778_02_tb VALUES('e01_200_01_tb','N30',NULL,0,0,'serves',NULL);
INSERT INTO e01_778_02_tb VALUES('e01_200_02_tb','N50',NULL,0,0,'serves',NULL);
INSERT INTO e01_778_02_tb VALUES('e01_200_03_tb','N30',NULL,0,0,'serves',NULL);
INSERT INTO e01_778_02_tb VALUES('e01_200_03_tb','N31',NULL,0,0,'serves',NULL);
INSERT INTO e01_778_02_tb VALUES('e01_201_01_tb','N30',NULL,0,0,'serves',NULL);
INSERT INTO e01_778_02_tb VALUES('e01_201_02_tb','N30',NULL,0,0,'serves',NULL);
INSERT INTO e01_778_02_tb VALUES('e01_201_02_tb','N31',NULL,0,0,'serves',NULL);
INSERT INTO e01_778_02_tb VALUES('e01_201_03_tb','N30',NULL,0,0,'serves',NULL);
INSERT INTO e01_778_02_tb VALUES('e01_202_01_tb','N30',NULL,0,0,'serves',NULL);
INSERT INTO e01_778_02_tb VALUES('e01_222_01_tb','N30',NULL,0,0,'serves',NULL);
INSERT INTO e01_778_02_tb VALUES('e01_222_01_tb','N31',NULL,0,0,'serves',NULL);
INSERT INTO e01_778_02_tb VALUES('e01_300_01_tb','N30',NULL,0,0,'serves',NULL);
INSERT INTO e01_778_02_tb VALUES('e01_300_01_tb','N31',NULL,0,0,'serves',NULL);
INSERT INTO e01_778_02_tb VALUES('e01_302_01_tb','N30',NULL,0,0,'serves',NULL);
INSERT INTO e01_778_02_tb VALUES('e01_303_01_tb','N50',NULL,0,0,'serves',NULL);
INSERT INTO e01_778_02_tb VALUES('e01_305_01_tb','N31',NULL,0,0,'serves',NULL);
INSERT INTO e01_778_02_tb VALUES('e01_305_01_tb','N32',NULL,0,0,'serves',NULL);
INSERT INTO e01_778_02_tb VALUES('e01_305_02_tb','N31',NULL,0,0,'serves',NULL);
INSERT INTO e01_778_02_tb VALUES('e01_305_02_tb','N32',NULL,0,0,'serves',NULL);
INSERT INTO e01_778_02_tb VALUES('e01_305_03_tb','N31',NULL,0,0,'serves',NULL);
INSERT INTO e01_778_02_tb VALUES('e01_305_03_tb','N32',NULL,0,0,'serves',NULL);
INSERT INTO e01_778_02_tb VALUES('e01_330_01_tb','N30',NULL,0,0,'serves',NULL);
INSERT INTO e01_778_02_tb VALUES('e01_330_02_tb','N30',NULL,0,0,'serves',NULL);
INSERT INTO e01_778_02_tb VALUES('e01_378_01_tb','N50',NULL,0,0,'serves',NULL);
INSERT INTO e01_778_02_tb VALUES('e01_506_01_tb','N50',NULL,0,0,'serves',NULL);
INSERT INTO e01_778_02_tb VALUES('e01_506_02_tb','N30',NULL,0,0,'serves',NULL);
INSERT INTO e01_778_02_tb VALUES('e01_506_03_tb','N30',NULL,0,0,'serves',NULL);
INSERT INTO e01_778_02_tb VALUES('e01_506_04_tb','N30',NULL,0,0,'serves',NULL);
INSERT INTO e01_778_02_tb VALUES('e01_506_05_tb','N30',NULL,0,0,'serves',NULL);
INSERT INTO e01_778_02_tb VALUES('e01_506_06_tb','N30',NULL,0,0,'serves',NULL);
INSERT INTO e01_778_02_tb VALUES('e01_506_07_tb','N50',NULL,0,0,'serves',NULL);
INSERT INTO e01_778_02_tb VALUES('e01_506_08_tb','N30',NULL,0,0,'serves',NULL);
INSERT INTO e01_778_02_tb VALUES('e01_506_09_tb','N50',NULL,1,1,'defines',NULL);
INSERT INTO e01_778_02_tb VALUES('e01_506_10_tb','N50',NULL,1,1,'defines',NULL);
INSERT INTO e01_778_02_tb VALUES('e01_506_11_tb','N50',NULL,1,1,'defines',NULL);
INSERT INTO e01_778_02_tb VALUES('e01_516_01_tb','N30',NULL,0,0,'serves',NULL);
INSERT INTO e01_778_02_tb VALUES('e01_676_01_tb','N50',NULL,0,0,'serves',NULL);
INSERT INTO e01_778_02_tb VALUES('e01_676_02_tb','N50',NULL,0,0,'serves',NULL);
INSERT INTO e01_778_02_tb VALUES('e01_676_03_tb','N50',NULL,0,0,'serves',NULL);
INSERT INTO e01_778_02_tb VALUES('e01_778_01_tb','N30',NULL,0,0,'serves',NULL);
INSERT INTO e01_778_02_tb VALUES('e01_778_02_tb','N70',NULL,0,0,'serves',NULL);
INSERT INTO e01_778_02_tb VALUES('e01_778_03_tb','N30',NULL,0,0,'serves',NULL);
INSERT INTO e01_778_02_tb VALUES('e01_778_04_tb','N30',NULL,0,0,'serves',NULL);
INSERT INTO e01_778_02_tb VALUES('e01_778_05_tb','N50',NULL,0,0,'serves',NULL);
INSERT INTO e01_778_02_tb VALUES('e02_404_01_ft','N50',NULL,0,0,'serves',NULL);
INSERT INTO e01_778_02_tb VALUES('e03_112_01_tr','N12',NULL,0,0,'serves',NULL);
INSERT INTO e01_778_02_tb VALUES('e03_112_01_tr','N13',NULL,1,1,'defines',NULL);
INSERT INTO e01_778_02_tb VALUES('e03_120_01_tr','N11',NULL,1,1,'defines',NULL);
INSERT INTO e01_778_02_tb VALUES('e03_120_02_tr','N11',NULL,0,0,'serves',NULL);
INSERT INTO e01_778_02_tb VALUES('e03_120_03_tr','N11',NULL,0,0,'serves',NULL);
INSERT INTO e01_778_02_tb VALUES('e03_120_04_tr','N10',NULL,1,1,'defines',NULL);
INSERT INTO e01_778_02_tb VALUES('e03_120_05_tr','N10',NULL,1,1,'defines',NULL);
INSERT INTO e01_778_02_tb VALUES('e03_122_01_tr','N11',NULL,1,1,'defines',NULL);
INSERT INTO e01_778_02_tb VALUES('e03_122_02_tr','N11',NULL,1,1,'defines',NULL);
INSERT INTO e01_778_02_tb VALUES('e03_126_01_tr','N11',NULL,1,0,'serves',NULL);
INSERT INTO e01_778_02_tb VALUES('e03_126_02_tr','N11',NULL,0,0,'serves',NULL);
INSERT INTO e01_778_02_tb VALUES('e03_126_03_tr','N11',NULL,1,0,'serves',NULL);
INSERT INTO e01_778_02_tb VALUES('e03_135_01_tr','N15',NULL,1,1,'defines',NULL);
INSERT INTO e01_778_02_tb VALUES('e03_135_02_tr','N15',NULL,0,0,'serves',NULL);
INSERT INTO e01_778_02_tb VALUES('e03_135_03_tr','N15',NULL,0,0,'serves',NULL);
INSERT INTO e01_778_02_tb VALUES('e03_310_03_tr','N12',NULL,0,0,'serves',NULL);
INSERT INTO e01_778_02_tb VALUES('e03_310_04_tr','N12',NULL,0,0,'serves',NULL);
INSERT INTO e01_778_02_tb VALUES('e03_310_05_tr','N12',NULL,0,0,'serves',NULL);
INSERT INTO e01_778_02_tb VALUES('e03_310_06_tr','N12',NULL,0,0,'serves',NULL);
INSERT INTO e01_778_02_tb VALUES('e03_311_01_tr','N11',NULL,0,0,'serves',NULL);
INSERT INTO e01_778_02_tb VALUES('e03_311_02_tr','N11',NULL,0,0,'serves',NULL);
INSERT INTO e01_778_02_tb VALUES('e03_311_03_tr','N11',NULL,0,0,'serves',NULL);
INSERT INTO e01_778_02_tb VALUES('e03_311_04_tr','N11',NULL,0,0,'serves',NULL);
INSERT INTO e01_778_02_tb VALUES('e03_312_01_tr','N12',NULL,1,1,'defines',NULL);
INSERT INTO e01_778_02_tb VALUES('e03_312_01_tr','N13',NULL,0,0,'serves',NULL);
INSERT INTO e01_778_02_tb VALUES('e03_312_01_tr','N14',NULL,0,0,'serves',NULL);
INSERT INTO e01_778_02_tb VALUES('e03_312_02_tr','N12',NULL,1,1,'defines',NULL);
INSERT INTO e01_778_02_tb VALUES('e03_320_01_tr','N30',NULL,1,1,'defines',NULL);
INSERT INTO e01_778_02_tb VALUES('e03_320_02_tr','N30',NULL,0,0,'serves',NULL);
INSERT INTO e01_778_02_tb VALUES('e03_320_03_tr','N30',NULL,0,0,'serves',NULL);
INSERT INTO e01_778_02_tb VALUES('e03_320_04_tr','N30',NULL,0,0,'serves',NULL);
INSERT INTO e01_778_02_tb VALUES('e03_320_05_tr','N30',NULL,0,0,'serves',NULL);
INSERT INTO e01_778_02_tb VALUES('e03_320_06_tr','N30',NULL,0,0,'serves',NULL);
INSERT INTO e01_778_02_tb VALUES('e03_320_07_tr','N30',NULL,0,0,'serves',NULL);
INSERT INTO e01_778_02_tb VALUES('e03_320_08_tr','N30',NULL,0,0,'serves',NULL);
INSERT INTO e01_778_02_tb VALUES('e03_320_09_tr','N30',NULL,0,0,'serves',NULL);
INSERT INTO e01_778_02_tb VALUES('e03_328_01_tr','N30',NULL,0,0,'serves',NULL);
INSERT INTO e01_778_02_tb VALUES('e03_328_02_tr','N30',NULL,0,0,'serves',NULL);
INSERT INTO e01_778_02_tb VALUES('e03_328_03_tr','N30',NULL,0,0,'serves',NULL);
INSERT INTO e01_778_02_tb VALUES('e03_328_04_tr','N30',NULL,0,0,'serves',NULL);
INSERT INTO e01_778_02_tb VALUES('e03_328_05_tr','N30',NULL,0,0,'serves',NULL);
INSERT INTO e01_778_02_tb VALUES('e03_328_06_tr','N30',NULL,0,0,'serves',NULL);
INSERT INTO e01_778_02_tb VALUES('e03_328_07_tr','N30',NULL,0,0,'serves',NULL);
INSERT INTO e01_778_02_tb VALUES('e03_328_08_tr','N30',NULL,0,0,'serves',NULL);
INSERT INTO e01_778_02_tb VALUES('e03_328_09_tr','N30',NULL,0,0,'serves',NULL);
INSERT INTO e01_778_02_tb VALUES('e03_328_10_tr','N30',NULL,0,0,'serves',NULL);
INSERT INTO e01_778_02_tb VALUES('e03_328_11_tr','N30',NULL,0,0,'serves',NULL);
INSERT INTO e01_778_02_tb VALUES('e03_328_12_tr','N30',NULL,0,0,'serves',NULL);
INSERT INTO e01_778_02_tb VALUES('e03_328_13_tr','N30',NULL,0,0,'serves',NULL);
INSERT INTO e01_778_02_tb VALUES('e03_328_14_tr','N30',NULL,0,0,'serves',NULL);
INSERT INTO e01_778_02_tb VALUES('e03_328_15_tr','N30',NULL,0,0,'serves',NULL);
INSERT INTO e01_778_02_tb VALUES('e03_328_16_tr','N30',NULL,0,0,'serves',NULL);
INSERT INTO e01_778_02_tb VALUES('e03_328_17_tr','N30',NULL,0,0,'serves',NULL);
INSERT INTO e01_778_02_tb VALUES('e03_328_18_tr','N30',NULL,0,0,'serves',NULL);
INSERT INTO e01_778_02_tb VALUES('e03_328_19_tr','N30',NULL,0,0,'serves',NULL);
INSERT INTO e01_778_02_tb VALUES('e03_328_20_tr','N30',NULL,0,0,'serves',NULL);
INSERT INTO e01_778_02_tb VALUES('e03_328_21_tr','N30',NULL,0,0,'serves',NULL);
INSERT INTO e01_778_02_tb VALUES('e03_328_22_tr','N30',NULL,0,0,'serves',NULL);
INSERT INTO e01_778_02_tb VALUES('e03_328_23_tr','N30',NULL,0,0,'serves',NULL);
INSERT INTO e01_778_02_tb VALUES('e03_328_24_tr','N30',NULL,0,0,'serves',NULL);
INSERT INTO e01_778_02_tb VALUES('e03_328_25_tr','N30',NULL,0,0,'serves',NULL);
INSERT INTO e01_778_02_tb VALUES('e03_328_26_tr','N30',NULL,0,0,'serves',NULL);
INSERT INTO e01_778_02_tb VALUES('e03_328_27_tr','N30',NULL,0,0,'serves',NULL);
INSERT INTO e01_778_02_tb VALUES('e03_328_28_tr','N30',NULL,0,0,'serves',NULL);
INSERT INTO e01_778_02_tb VALUES('e03_328_29_tr','N30',NULL,0,0,'serves',NULL);
INSERT INTO e01_778_02_tb VALUES('e03_328_30_tr','N30',NULL,0,0,'serves',NULL);
INSERT INTO e01_778_02_tb VALUES('e03_328_31_tr','N30',NULL,0,0,'serves',NULL);
INSERT INTO e01_778_02_tb VALUES('e03_328_32_tr','N30',NULL,0,0,'serves',NULL);
INSERT INTO e01_778_02_tb VALUES('e03_328_33_tr','N30',NULL,0,0,'serves',NULL);
INSERT INTO e01_778_02_tb VALUES('e03_328_34_tr','N30',NULL,0,0,'serves',NULL);
INSERT INTO e01_778_02_tb VALUES('e03_328_35_tr','N30',NULL,0,0,'serves',NULL);
INSERT INTO e01_778_02_tb VALUES('e03_328_36_tr','N30',NULL,0,0,'serves',NULL);
INSERT INTO e01_778_02_tb VALUES('e03_328_37_tr','N30',NULL,0,0,'serves',NULL);
INSERT INTO e01_778_02_tb VALUES('e03_343_01_tr','N31',NULL,1,1,'defines',NULL);
INSERT INTO e01_778_02_tb VALUES('e03_343_02_tr','N31',NULL,0,0,'serves',NULL);
INSERT INTO e01_778_02_tb VALUES('e03_343_03_tr','N31',NULL,0,0,'serves',NULL);
INSERT INTO e01_778_02_tb VALUES('e03_343_04_tr','N31',NULL,0,0,'serves',NULL);
INSERT INTO e01_778_02_tb VALUES('e03_343_05_tr','N31',NULL,0,0,'serves',NULL);
INSERT INTO e01_778_02_tb VALUES('e03_343_06_tr','N31',NULL,0,0,'serves',NULL);
INSERT INTO e01_778_02_tb VALUES('e03_343_07_tr','N31',NULL,0,0,'serves',NULL);
INSERT INTO e01_778_02_tb VALUES('e03_343_08_tr','N31',NULL,0,0,'serves',NULL);
INSERT INTO e01_778_02_tb VALUES('e03_343_09_tr','N31',NULL,0,0,'serves',NULL);
INSERT INTO e01_778_02_tb VALUES('e03_360_01_tr','N22',NULL,0,0,'serves',NULL);
INSERT INTO e01_778_02_tb VALUES('e03_370_01_tr','N30',NULL,0,0,'serves',NULL);
INSERT INTO e01_778_02_tb VALUES('e03_370_02_tr','N30',NULL,0,0,'serves',NULL);
INSERT INTO e01_778_02_tb VALUES('e03_370_03_tr','N30',NULL,0,0,'serves',NULL);
INSERT INTO e01_778_02_tb VALUES('e03_370_04_tr','N30',NULL,0,0,'serves',NULL);
INSERT INTO e01_778_02_tb VALUES('e03_370_05_tr','N30',NULL,0,0,'serves',NULL);
INSERT INTO e01_778_02_tb VALUES('e03_370_06_tr','N30',NULL,0,0,'serves',NULL);
INSERT INTO e01_778_02_tb VALUES('e03_370_07_tr','N30',NULL,0,0,'serves',NULL);
INSERT INTO e01_778_02_tb VALUES('e03_370_08_tr','N30',NULL,0,0,'serves',NULL);
INSERT INTO e01_778_02_tb VALUES('e03_370_11_tr','N30',NULL,0,0,'serves',NULL);
INSERT INTO e01_778_02_tb VALUES('e03_370_12_tr','N30',NULL,0,0,'serves',NULL);
INSERT INTO e01_778_02_tb VALUES('e03_370_13_tr','N30',NULL,0,0,'serves',NULL);
INSERT INTO e01_778_02_tb VALUES('e03_370_14_tr','N30',NULL,0,0,'serves',NULL);
INSERT INTO e01_778_02_tb VALUES('e03_370_15_tr','N30',NULL,0,0,'serves',NULL);
INSERT INTO e01_778_02_tb VALUES('e03_370_16_tr','N30',NULL,0,0,'serves',NULL);
INSERT INTO e01_778_02_tb VALUES('e03_370_17_tr','N30',NULL,0,0,'serves',NULL);
INSERT INTO e01_778_02_tb VALUES('e03_370_18_tr','N30',NULL,0,0,'serves',NULL);
INSERT INTO e01_778_02_tb VALUES('e03_370_21_tr','N30',NULL,0,0,'serves',NULL);
INSERT INTO e01_778_02_tb VALUES('e03_370_22_tr','N30',NULL,0,0,'serves',NULL);
INSERT INTO e01_778_02_tb VALUES('e03_370_23_tr','N30',NULL,0,0,'serves',NULL);
INSERT INTO e01_778_02_tb VALUES('e03_370_24_tr','N30',NULL,0,0,'serves',NULL);
INSERT INTO e01_778_02_tb VALUES('e03_370_25_tr','N30',NULL,0,0,'serves',NULL);
INSERT INTO e01_778_02_tb VALUES('e03_370_26_tr','N30',NULL,0,0,'serves',NULL);
INSERT INTO e01_778_02_tb VALUES('e03_370_30_tr','N30',NULL,0,0,'serves',NULL);
INSERT INTO e01_778_02_tb VALUES('e03_370_32_tr','N30',NULL,0,0,'serves',NULL);
INSERT INTO e01_778_02_tb VALUES('e03_370_33_tr','N30',NULL,0,0,'serves',NULL);
INSERT INTO e01_778_02_tb VALUES('e03_370_34_tr','N30',NULL,0,0,'serves',NULL);
INSERT INTO e01_778_02_tb VALUES('e03_434_01_tr','N41',NULL,1,1,'defines',NULL);
INSERT INTO e01_778_02_tb VALUES('e03_434_02_tr','N41',NULL,0,0,'serves',NULL);
INSERT INTO e01_778_02_tb VALUES('e03_434_03_tr','N41',NULL,0,0,'serves',NULL);
INSERT INTO e01_778_02_tb VALUES('e03_434_04_tr','N41',NULL,0,0,'serves',NULL);
INSERT INTO e01_778_02_tb VALUES('e03_434_05_tr','N41',NULL,0,0,'serves',NULL);
INSERT INTO e01_778_02_tb VALUES('e03_516_01_tr','N11',NULL,0,0,'serves',NULL);
INSERT INTO e01_778_02_tb VALUES('e03_516_02_tr','N11',NULL,0,0,'serves',NULL);
INSERT INTO e01_778_02_tb VALUES('e03_778_02_ins_tr','N70',NULL,0,0,'serves',NULL);
INSERT INTO e01_778_02_tb VALUES('e03_778_10_tr','N50',NULL,0,0,'serves',NULL);
INSERT INTO e01_778_02_tb VALUES('e03_778_10b_tr','N50',NULL,0,0,'serves',NULL);
INSERT INTO e01_778_02_tb VALUES('e03_778_11_tr','N70',NULL,0,0,'serves',NULL);
INSERT INTO e01_778_02_tb VALUES('e03_778_13_tr','N70',NULL,0,0,'serves',NULL);
INSERT INTO e01_778_02_tb VALUES('e03_778_14_tr','N70',NULL,0,0,'serves',NULL);
INSERT INTO e01_778_02_tb VALUES('e04_110_01_vw','N11',NULL,1,0,'verifies',NULL);
INSERT INTO e01_778_02_tb VALUES('e04_110_02_vw','N50',NULL,0,0,'serves',NULL);
INSERT INTO e01_778_02_tb VALUES('e04_122_01_vw','N50',NULL,0,0,'serves',NULL);
INSERT INTO e01_778_02_tb VALUES('e04_200_01_vw','N20',NULL,1,0,'defines',NULL);
INSERT INTO e01_778_02_tb VALUES('e04_230_01_vw','N50',NULL,0,0,'serves',NULL);
INSERT INTO e01_778_02_tb VALUES('e04_230_02_vw','N50',NULL,0,0,'serves',NULL);
INSERT INTO e01_778_02_tb VALUES('e04_260_01_vw','N50',NULL,0,0,'serves',NULL);
INSERT INTO e01_778_02_tb VALUES('e04_260_02_vw','N50',NULL,0,0,'serves',NULL);
INSERT INTO e01_778_02_tb VALUES('e04_260_03_vw','N50',NULL,0,0,'serves',NULL);
INSERT INTO e01_778_02_tb VALUES('e04_267_01_vw','N20',NULL,1,0,'defines',NULL);
INSERT INTO e01_778_02_tb VALUES('e04_267_02_vw','N50',NULL,0,0,'serves',NULL);
INSERT INTO e01_778_02_tb VALUES('e04_310_01_vw','N50',NULL,0,0,'serves',NULL);
INSERT INTO e01_778_02_tb VALUES('e04_310_02_vw','N30',NULL,1,0,'verifies',NULL);
INSERT INTO e01_778_02_tb VALUES('e04_311_01_vw','N50',NULL,0,0,'serves',NULL);
INSERT INTO e01_778_02_tb VALUES('e04_325_01_vw','N50',NULL,0,0,'serves',NULL);
INSERT INTO e01_778_02_tb VALUES('e04_340_01_vw','N50',NULL,0,0,'serves',NULL);
INSERT INTO e01_778_02_tb VALUES('e04_340_02_vw','N50',NULL,0,0,'serves',NULL);
INSERT INTO e01_778_02_tb VALUES('e04_340_04_vw','N50',NULL,0,0,'serves',NULL);
INSERT INTO e01_778_02_tb VALUES('e04_900_01_vw','N50',NULL,0,0,'serves',NULL);
INSERT INTO e01_778_02_tb VALUES('e04_978_01_vw','N99',NULL,1,0,'verifies',NULL);
ANALYZE sqlite_schema;
INSERT INTO sqlite_stat1 VALUES('e02_404_01_ft_config','e02_404_01_ft_config','1 1');
INSERT INTO sqlite_stat1 VALUES('e02_404_01_ft_docsize',NULL,'15');
INSERT INTO sqlite_stat1 VALUES('e02_404_01_ft_idx','e02_404_01_ft_idx','3 1 1');
INSERT INTO sqlite_stat1 VALUES('e01_506_03_tb','e02_506_16_ix','303 61');
INSERT INTO sqlite_stat1 VALUES('e01_506_03_tb','e02_506_15_ix','303 44');
INSERT INTO sqlite_stat1 VALUES('e01_506_03_tb','sqlite_autoindex_e01_506_03_tb_2','303 2');
INSERT INTO sqlite_stat1 VALUES('e01_506_03_tb','sqlite_autoindex_e01_506_03_tb_1','303 1');
INSERT INTO sqlite_stat1 VALUES('e01_778_04_tb','e02_778_41_ix','23 2');
INSERT INTO sqlite_stat1 VALUES('e01_778_04_tb','e02_778_40_ix','23 6');
INSERT INTO sqlite_stat1 VALUES('e01_778_04_tb','sqlite_autoindex_e01_778_04_tb_1','23 5 1');
INSERT INTO sqlite_stat1 VALUES('e01_676_03_tb','sqlite_autoindex_e01_676_03_tb_1','9 1');
INSERT INTO sqlite_stat1 VALUES('_baseline_v26',NULL,'506');
INSERT INTO sqlite_stat1 VALUES('e01_516_01_tb','e02_516_11_ix','105 53');
INSERT INTO sqlite_stat1 VALUES('e01_516_01_tb','e02_516_10_ix','105 2');
INSERT INTO sqlite_stat1 VALUES('e01_516_01_tb','e01_516_01_tb','105 5 1 1');
INSERT INTO sqlite_stat1 VALUES('e01_506_11_tb','sqlite_autoindex_e01_506_11_tb_1','86 1');
INSERT INTO sqlite_stat1 VALUES('e01_676_02_tb',NULL,'1');
INSERT INTO sqlite_stat1 VALUES('e01_778_03_tb','e02_778_31_ix','5 2');
INSERT INTO sqlite_stat1 VALUES('e01_778_03_tb','e02_778_30_ix','5 2');
INSERT INTO sqlite_stat1 VALUES('e01_778_03_tb','sqlite_autoindex_e01_778_03_tb_2','5 1');
INSERT INTO sqlite_stat1 VALUES('e01_778_03_tb','sqlite_autoindex_e01_778_03_tb_1','5 1');
INSERT INTO sqlite_stat1 VALUES('e01_506_10_tb','sqlite_autoindex_e01_506_10_tb_1','22 1');
INSERT INTO sqlite_stat1 VALUES('e01_506_01_tb','sqlite_autoindex_e01_506_01_tb_1','32 1');
INSERT INTO sqlite_stat1 VALUES('e01_506_05_tb','e02_506_20_ix','14 1');
INSERT INTO sqlite_stat1 VALUES('e01_506_05_tb','sqlite_autoindex_e01_506_05_tb_1','14 1');
INSERT INTO sqlite_stat1 VALUES('e01_506_09_tb','sqlite_autoindex_e01_506_09_tb_1','8 1');
INSERT INTO sqlite_stat1 VALUES('e01_200_02_tb','sqlite_autoindex_e01_200_02_tb_1','8 1');
INSERT INTO sqlite_stat1 VALUES('e01_200_01_tb','e02_200_10_ix','48 6');
INSERT INTO sqlite_stat1 VALUES('e01_200_01_tb','sqlite_autoindex_e01_200_01_tb_1','48 1');
INSERT INTO sqlite_stat1 VALUES('e01_378_01_tb','e02_378_11_ix','69 4');
INSERT INTO sqlite_stat1 VALUES('e01_378_01_tb','e02_378_10_ix','69 3');
INSERT INTO sqlite_stat1 VALUES('e01_378_01_tb','sqlite_autoindex_e01_378_01_tb_1','69 3 1');
INSERT INTO sqlite_stat1 VALUES('e01_778_01_tb','e02_778_12_ix','34 17');
INSERT INTO sqlite_stat1 VALUES('e01_778_01_tb','e02_778_11_ix','34 2');
INSERT INTO sqlite_stat1 VALUES('e01_778_01_tb','e02_778_10_ix','34 34');
INSERT INTO sqlite_stat1 VALUES('e01_778_01_tb','sqlite_autoindex_e01_778_01_tb_1','34 1');
INSERT INTO sqlite_stat1 VALUES('e01_303_01_tb','e02_303_12_ix','1 1 1');
INSERT INTO sqlite_stat1 VALUES('e01_303_01_tb','e02_303_11_ix','1 1 1');
INSERT INTO sqlite_stat1 VALUES('e01_303_01_tb','e02_303_10_ix','1 1');
INSERT INTO sqlite_stat1 VALUES('e01_305_03_tb','e02_305_32_ix','3 3');
INSERT INTO sqlite_stat1 VALUES('e01_305_03_tb','e02_305_31_ix','3 1');
INSERT INTO sqlite_stat1 VALUES('e01_305_03_tb','e02_305_30_ix','3 2 1 1 1 1 1');
INSERT INTO sqlite_stat1 VALUES('e01_778_05_tb','e02_778_54_ix','143 2');
INSERT INTO sqlite_stat1 VALUES('e01_778_05_tb','e02_778_53_ix','69 1');
INSERT INTO sqlite_stat1 VALUES('e01_778_05_tb','e02_778_52_ix','212 43');
INSERT INTO sqlite_stat1 VALUES('e01_778_05_tb','e02_778_51_ix','212 7');
INSERT INTO sqlite_stat1 VALUES('e01_778_05_tb','e02_778_50_ix','212 2');
INSERT INTO sqlite_stat1 VALUES('e01_202_01_tb','e02_202_11_ix','18 18');
INSERT INTO sqlite_stat1 VALUES('e01_202_01_tb','e02_202_10_ix','60 30');
INSERT INTO sqlite_stat1 VALUES('e01_202_01_tb','sqlite_autoindex_e01_202_01_tb_1','60 1');
INSERT INTO sqlite_stat1 VALUES('e01_201_01_tb','e02_201_10_ix','25 4');
INSERT INTO sqlite_stat1 VALUES('e01_201_01_tb','sqlite_autoindex_e01_201_01_tb_1','25 4 1');
INSERT INTO sqlite_stat1 VALUES('e01_676_01_tb','sqlite_autoindex_e01_676_01_tb_1','35 1');
INSERT INTO sqlite_stat1 VALUES('e01_300_01_tb','e02_300_13_ix','2 2 1 1 1');
INSERT INTO sqlite_stat1 VALUES('e01_300_01_tb','e02_300_12_ix','2 2');
INSERT INTO sqlite_stat1 VALUES('e01_300_01_tb','e02_300_11_ix','2 1');
INSERT INTO sqlite_stat1 VALUES('e01_300_01_tb','e02_300_10_ix','2 2');
INSERT INTO sqlite_stat1 VALUES('e01_330_02_tb','e02_330_21_ix','2 1');
INSERT INTO sqlite_stat1 VALUES('e01_330_02_tb','e02_330_20_ix','2 2');
INSERT INTO sqlite_stat1 VALUES('e02_404_01_ft_data',NULL,'5');
INSERT INTO sqlite_stat1 VALUES('e01_330_01_tb','e02_330_10_ix','2 2');
INSERT INTO sqlite_stat1 VALUES('e01_330_01_tb','sqlite_autoindex_e01_330_01_tb_1','2 2 1');
INSERT INTO sqlite_stat1 VALUES('e01_506_02_tb','e02_506_14_ix','91 2');
INSERT INTO sqlite_stat1 VALUES('e01_506_02_tb','e02_506_13_ix','91 5');
INSERT INTO sqlite_stat1 VALUES('e01_506_02_tb','e02_506_12_ix','91 12');
INSERT INTO sqlite_stat1 VALUES('e01_506_02_tb','e02_506_11_ix','91 46');
INSERT INTO sqlite_stat1 VALUES('e01_506_02_tb','e02_506_10_ix','91 11');
INSERT INTO sqlite_stat1 VALUES('e01_506_02_tb','sqlite_autoindex_e01_506_02_tb_1','91 1');
INSERT INTO sqlite_stat1 VALUES('e01_506_04_tb','e02_506_19_ix','101 3');
INSERT INTO sqlite_stat1 VALUES('e01_506_04_tb','e02_506_18_ix','101 2');
INSERT INTO sqlite_stat1 VALUES('e01_506_04_tb','sqlite_autoindex_e01_506_04_tb_1','101 2 1 1');
INSERT INTO sqlite_stat1 VALUES('e01_778_02_tb','e02_778_23_ix','15 15');
INSERT INTO sqlite_stat1 VALUES('e01_778_02_tb','e02_778_22_ix','22 22');
INSERT INTO sqlite_stat1 VALUES('e01_778_02_tb','e02_778_20_ix','189 13');
INSERT INTO sqlite_stat1 VALUES('e01_778_02_tb','e01_778_02_tb','189 2 1 1');
INSERT INTO sqlite_stat1 VALUES('e01_120_01_tb','e02_120_10_ix','81 2');
INSERT INTO sqlite_stat1 VALUES('e01_120_01_tb','e01_120_01_tb','81 2 1');
INSERT INTO sqlite_stat1 VALUES('e01_222_01_tb','e02_222_24_ix','7 7 7');
INSERT INTO sqlite_stat1 VALUES('e01_222_01_tb','e02_222_23_ix','7 3 2');
INSERT INTO sqlite_stat1 VALUES('e01_222_01_tb','e02_222_22_ix','7 2 2 1 1');
INSERT INTO sqlite_stat1 VALUES('e01_222_01_tb','e02_222_21_ix','7 2 2 1 1');
INSERT INTO sqlite_stat1 VALUES('e01_222_01_tb','e02_222_20_ix','7 2 2 1');
INSERT INTO sqlite_stat1 VALUES('e01_222_01_tb','e02_222_18_ix','7 7');
INSERT INTO sqlite_stat1 VALUES('e01_222_01_tb','e02_222_16_ix','7 7');
INSERT INTO sqlite_stat1 VALUES('e01_222_01_tb','e02_222_15_ix','7 2 2 1');
INSERT INTO sqlite_stat1 VALUES('e01_222_01_tb','e02_222_13_ix','7 2 2 1');
INSERT INTO sqlite_stat1 VALUES('e01_222_01_tb','e02_222_11_ix','7 2');
INSERT INTO sqlite_stat1 VALUES('e01_222_01_tb','e02_222_10_ix','7 2');
INSERT INTO sqlite_stat1 VALUES('e01_222_01_tb','sqlite_autoindex_e01_222_01_tb_1','7 1');
INSERT INTO sqlite_stat1 VALUES('e01_200_03_tb','e02_200_25_ix','15 3 3');
INSERT INTO sqlite_stat1 VALUES('e01_200_03_tb','e02_200_24_ix','15 15');
INSERT INTO sqlite_stat1 VALUES('e01_200_03_tb','e02_200_23_ix','15 1');
INSERT INTO sqlite_stat1 VALUES('e01_200_03_tb','e02_200_22_ix','15 15');
INSERT INTO sqlite_stat1 VALUES('e01_200_03_tb','e02_200_21_ix','15 15');
INSERT INTO sqlite_stat1 VALUES('e01_200_03_tb','e02_200_20_ix','15 3 3');
INSERT INTO sqlite_stat1 VALUES('e01_200_03_tb','sqlite_autoindex_e01_200_03_tb_1','15 1');
CREATE TABLE e01_506_12_tb (
    need_uid     TEXT NOT NULL,
    node_id      INTEGER NOT NULL,
    question_uid TEXT NOT NULL,
    slot         TEXT,
    answer_text  TEXT,
    status       TEXT,
    depth        INTEGER NOT NULL DEFAULT 0,
    path         TEXT,
    cached_at    TEXT NOT NULL DEFAULT (datetime('now')),
    PRIMARY KEY (need_uid, node_id)
) WITHOUT ROWID;
PRAGMA writable_schema=ON;
INSERT INTO sqlite_schema(type,name,tbl_name,rootpage,sql)VALUES('table','e02_404_01_ft','e02_404_01_ft',0,'CREATE VIRTUAL TABLE e02_404_01_ft USING fts5(
    label_norm, desc_norm,
    content=''e01_200_03_tb'',
    content_rowid=''ent_id'',
    tokenize=''trigram''
)');
DELETE FROM sqlite_sequence;
INSERT INTO sqlite_sequence VALUES('e01_303_01_tb',2);
INSERT INTO sqlite_sequence VALUES('e01_200_01_tb',48);
INSERT INTO sqlite_sequence VALUES('e01_202_01_tb',60);
INSERT INTO sqlite_sequence VALUES('e01_378_01_tb',73);
INSERT INTO sqlite_sequence VALUES('e01_200_03_tb',15);
INSERT INTO sqlite_sequence VALUES('e01_222_01_tb',8);
INSERT INTO sqlite_sequence VALUES('e01_778_01_tb',34);
INSERT INTO sqlite_sequence VALUES('e01_778_05_tb',216);
INSERT INTO sqlite_sequence VALUES('e01_506_04_tb',166);
INSERT INTO sqlite_sequence VALUES('e01_200_02_tb',16);
INSERT INTO sqlite_sequence VALUES('e01_201_01_tb',50);
INSERT INTO sqlite_sequence VALUES('e01_305_03_tb',3);
INSERT INTO sqlite_sequence VALUES('e01_300_01_tb',3);
INSERT INTO sqlite_sequence VALUES('e01_330_01_tb',2);
INSERT INTO sqlite_sequence VALUES('e01_330_02_tb',2);
CREATE INDEX e02_506_10_ix ON e01_506_02_tb(category);
CREATE INDEX e02_506_11_ix ON e01_506_02_tb(origin);
CREATE INDEX e02_506_12_ix ON e01_506_02_tb(verb_code);
CREATE INDEX e02_506_13_ix ON e01_506_02_tb(entity_code);
CREATE INDEX e02_506_14_ix ON e01_506_02_tb(constraint_code) WHERE constraint_code IS NOT NULL;
CREATE INDEX e02_506_15_ix ON e01_506_03_tb(element_layer);
CREATE INDEX e02_506_16_ix ON e01_506_03_tb(element_kind);
CREATE INDEX e02_506_17_ix ON e01_506_03_tb(need_uid) WHERE need_uid IS NOT NULL;
CREATE INDEX e02_506_18_ix ON e01_506_04_tb(atom_uid);
CREATE INDEX e02_506_19_ix ON e01_506_04_tb(element_name);
CREATE INDEX e02_506_20_ix ON e01_506_05_tb(parent_uid);
CREATE INDEX e02_506_21_ix ON e01_506_06_tb(need_uid);
CREATE INDEX e02_506_22_ix ON e01_506_06_tb(parent_id);
CREATE INDEX e02_506_23_ix ON e01_506_06_tb(question_uid);
CREATE UNIQUE INDEX e02_506_24_ix ON e01_506_06_tb(need_uid, question_uid, ordinal) WHERE parent_id IS NULL;
CREATE INDEX e02_378_10_ix ON e01_378_01_tb(child_table);
CREATE INDEX e02_378_11_ix ON e01_378_01_tb(parent_table);
CREATE INDEX e02_506_25_ix ON e01_506_08_tb(dim_uid);
CREATE INDEX e02_778_10_ix ON e01_778_01_tb(parent_code);
CREATE INDEX e02_778_11_ix ON e01_778_01_tb(need_uid);
CREATE INDEX e02_778_12_ix ON e01_778_01_tb(code_kind);
CREATE INDEX e02_778_30_ix ON e01_778_03_tb(root_need_uid);
CREATE INDEX e02_778_31_ix ON e01_778_03_tb(chain_kind);
CREATE INDEX e02_778_40_ix ON e01_778_04_tb(step_kind);
CREATE INDEX e02_778_41_ix ON e01_778_04_tb(element_name) WHERE element_name IS NOT NULL;
CREATE INDEX e02_778_42_ix ON e01_778_04_tb(need_uid) WHERE need_uid IS NOT NULL;
CREATE INDEX e02_200_10_ix ON e01_200_01_tb(parent_id);
CREATE INDEX e02_120_10_ix ON e01_120_01_tb(anc_id);
CREATE INDEX e02_202_10_ix ON e01_202_01_tb(object_kind);
CREATE INDEX e02_202_11_ix ON e01_202_01_tb(is_functional) WHERE is_functional = 1;
CREATE UNIQUE INDEX e02_112_10_ix ON e01_112_01_tb(reltype_id, cons_kind, target_type_id) WHERE target_type_id IS NOT NULL;
CREATE UNIQUE INDEX e02_112_11_ix ON e01_112_01_tb(reltype_id, cons_kind, target_nature) WHERE target_nature IS NOT NULL;
CREATE INDEX e02_112_12_ix ON e01_112_01_tb(reltype_id);
CREATE INDEX e02_112_13_ix ON e01_112_01_tb(cons_kind);
CREATE INDEX e02_201_10_ix ON e01_201_01_tb(dom_id);
CREATE INDEX e02_303_10_ix ON e01_303_01_tb(source_type);
CREATE INDEX e02_303_11_ix ON e01_303_01_tb(source_type, source_ref);
CREATE UNIQUE INDEX e02_303_12_ix ON e01_303_01_tb(source_type, source_ref) WHERE source_type='unknown' AND source_ref='system:unknown';
CREATE INDEX e02_200_20_ix ON e01_200_03_tb(type_id, nature);
CREATE INDEX e02_200_21_ix ON e01_200_03_tb(nature);
CREATE INDEX e02_200_22_ix ON e01_200_03_tb(status);
CREATE INDEX e02_200_23_ix ON e01_200_03_tb(label);
CREATE INDEX e02_200_24_ix ON e01_200_03_tb(prv_id) WHERE prv_id IS NOT NULL;
CREATE INDEX e02_201_20_ix ON e01_201_02_tb(value_kind);
CREATE INDEX e02_201_21_ix ON e01_201_02_tb(num_val) WHERE num_val IS NOT NULL;
CREATE INDEX e02_201_22_ix ON e01_201_02_tb(text_val) WHERE text_val IS NOT NULL;
CREATE INDEX e02_201_23_ix ON e01_201_02_tb(text_norm) WHERE text_norm IS NOT NULL;
CREATE INDEX e02_201_24_ix ON e01_201_02_tb(enum_id) WHERE enum_id IS NOT NULL;
CREATE INDEX e02_201_25_ix ON e01_201_02_tb(prv_id) WHERE prv_id IS NOT NULL;
CREATE INDEX e02_201_30_ix ON e01_201_03_tb(parent_id);
CREATE INDEX e02_201_31_ix ON e01_201_03_tb(member_val_id);
CREATE INDEX e02_201_32_ix ON e01_201_03_tb(member_ent_id);
CREATE INDEX e02_302_10_ix ON e01_302_01_tb(subj_ent_id);
CREATE INDEX e02_302_11_ix ON e01_302_01_tb(reltype_id);
CREATE INDEX e02_222_10_ix ON e01_222_01_tb(subj_ent_id);
CREATE INDEX e02_222_11_ix ON e01_222_01_tb(obj_ent_id) WHERE obj_ent_id IS NOT NULL;
CREATE INDEX e02_222_12_ix ON e01_222_01_tb(obj_val_id) WHERE obj_val_id IS NOT NULL;
CREATE INDEX e02_222_13_ix ON e01_222_01_tb(subj_ent_id, reltype_id, obj_ent_id) WHERE superseded_at IS NULL;
CREATE INDEX e02_222_14_ix ON e01_222_01_tb(reif_ent_id) WHERE reif_ent_id IS NOT NULL;
CREATE INDEX e02_222_15_ix ON e01_222_01_tb(subj_ent_id, reltype_id, ctx_key) WHERE superseded_at IS NULL AND status = 'asserted';
CREATE INDEX e02_222_16_ix ON e01_222_01_tb(status);
CREATE INDEX e02_222_17_ix ON e01_222_01_tb(lin_id) WHERE lin_id IS NOT NULL;
CREATE INDEX e02_222_18_ix ON e01_222_01_tb(prv_id) WHERE prv_id IS NOT NULL;
CREATE INDEX e02_222_19_ix ON e01_222_01_tb(subj_ent_id, reltype_id, ordinal) WHERE ordinal IS NOT NULL;
CREATE INDEX e02_222_20_ix ON e01_222_01_tb(subj_ent_id, reltype_id, obj_ent_id) WHERE status = 'asserted' AND superseded_at IS NULL;
CREATE UNIQUE INDEX e02_305_10_ix ON e01_305_01_tb(ent_id, COALESCE(ctx_ent_id, -1), COALESCE(ctx_val_id, -1), role, COALESCE(valid_from, ''), COALESCE(valid_to, ''));
CREATE INDEX e02_305_11_ix ON e01_305_01_tb(ctx_ent_id) WHERE ctx_ent_id IS NOT NULL;
CREATE INDEX e02_305_12_ix ON e01_305_01_tb(prv_id) WHERE prv_id IS NOT NULL;
CREATE UNIQUE INDEX e02_305_20_ix ON e01_305_02_tb(val_id, COALESCE(ctx_ent_id, -1), COALESCE(ctx_val_id, -1), role, COALESCE(valid_from, ''), COALESCE(valid_to, ''));
CREATE INDEX e02_305_21_ix ON e01_305_02_tb(ctx_ent_id) WHERE ctx_ent_id IS NOT NULL;
CREATE INDEX e02_305_22_ix ON e01_305_02_tb(prv_id) WHERE prv_id IS NOT NULL;
CREATE UNIQUE INDEX e02_305_30_ix ON e01_305_03_tb(rel_id, COALESCE(ctx_ent_id, -1), COALESCE(ctx_val_id, -1), role, COALESCE(valid_from, ''), COALESCE(valid_to, ''));
CREATE INDEX e02_305_31_ix ON e01_305_03_tb(ctx_ent_id) WHERE ctx_ent_id IS NOT NULL;
CREATE INDEX e02_305_32_ix ON e01_305_03_tb(prv_id) WHERE prv_id IS NOT NULL;
CREATE INDEX e02_300_10_ix ON e01_300_01_tb(ent_a_id);
CREATE INDEX e02_300_11_ix ON e01_300_01_tb(ent_b_id);
CREATE INDEX e02_300_12_ix ON e01_300_01_tb(prv_id) WHERE prv_id IS NOT NULL;
CREATE INDEX e02_300_13_ix ON e01_300_01_tb(ent_a_id, ent_b_id, clm_type, status);
CREATE INDEX e02_330_10_ix ON e01_330_01_tb(ent_id);
CREATE INDEX e02_330_20_ix ON e01_330_02_tb(ent_id);
CREATE INDEX e02_330_21_ix ON e01_330_02_tb(vers_id) WHERE vers_id IS NOT NULL;
CREATE INDEX e02_778_50_ix ON e01_778_05_tb(element_name);
CREATE INDEX e02_778_51_ix ON e01_778_05_tb(need_uid);
CREATE INDEX e02_778_52_ix ON e01_778_05_tb(policy_kind);
CREATE INDEX e02_778_53_ix ON e01_778_05_tb(fk_ref_id) WHERE fk_ref_id IS NOT NULL;
CREATE INDEX e02_778_54_ix ON e01_778_05_tb(exec_name) WHERE exec_name IS NOT NULL;
CREATE INDEX e02_516_10_ix ON e01_516_01_tb(atom_uid);
CREATE INDEX e02_516_11_ix ON e01_516_01_tb(origin);
CREATE INDEX e02_778_20_ix ON e01_778_02_tb(need_uid);
CREATE INDEX e02_778_21_ix ON e01_778_02_tb(code) WHERE code IS NOT NULL;
CREATE INDEX e02_778_22_ix ON e01_778_02_tb(is_primary) WHERE is_primary = 1;
CREATE INDEX e02_778_23_ix ON e01_778_02_tb(is_driving) WHERE is_driving = 1;
CREATE INDEX e02_222_21_ix 
    ON e01_222_01_tb(subj_ent_id, reltype_id, obj_ent_id, status)
    WHERE superseded_at IS NULL;
CREATE INDEX e02_222_22_ix 
    ON e01_222_01_tb(obj_ent_id, reltype_id, subj_ent_id, status)
    WHERE superseded_at IS NULL AND obj_ent_id IS NOT NULL;
CREATE INDEX e02_222_23_ix 
    ON e01_222_01_tb(reltype_id, subj_ent_id)
    WHERE superseded_at IS NULL AND status = 'asserted';
CREATE INDEX e02_222_24_ix 
    ON e01_222_01_tb(valid_from, valid_to)
    WHERE valid_to IS NULL OR valid_to > datetime('now');
CREATE INDEX e02_200_25_ix 
    ON e01_200_03_tb(type_id, status)
    WHERE status = 'active';
CREATE TRIGGER e03_312_01_tr BEFORE INSERT ON e01_222_01_tb
BEGIN
  SELECT CASE WHEN (SELECT reltype_id FROM e01_202_01_tb WHERE reltype_id = NEW.reltype_id) IS NULL THEN RAISE(ABORT, 'unknown relation type') END;
  SELECT CASE WHEN (SELECT ent_id FROM e01_200_03_tb WHERE ent_id = NEW.subj_ent_id) IS NULL THEN RAISE(ABORT, 'subject entity does not exist') END;
  SELECT CASE WHEN NEW.obj_ent_id IS NOT NULL AND (SELECT ent_id FROM e01_200_03_tb WHERE ent_id = NEW.obj_ent_id) IS NULL THEN RAISE(ABORT, 'object entity does not exist') END;
  SELECT CASE WHEN NEW.obj_val_id IS NOT NULL AND (SELECT val_id FROM e01_201_02_tb WHERE val_id = NEW.obj_val_id) IS NULL THEN RAISE(ABORT, 'object value does not exist') END;
  SELECT CASE WHEN NEW.lin_id IS NOT NULL AND (SELECT lin_id FROM e01_302_01_tb WHERE lin_id = NEW.lin_id) IS NULL THEN RAISE(ABORT, 'relation lineage does not exist') END;
  SELECT CASE WHEN NEW.prv_id IS NOT NULL AND (SELECT prv_id FROM e01_303_01_tb WHERE prv_id = NEW.prv_id) IS NULL THEN RAISE(ABORT, 'relation provenance does not exist') END;
  SELECT CASE WHEN NEW.reif_type <> 'none' AND NOT EXISTS (SELECT 1 FROM e01_200_03_tb e JOIN e01_200_01_tb et ON et.type_id = e.type_id WHERE e.ent_id = NEW.reif_ent_id AND et.type_uid IN ('ReifiedRelation','Evidence','Observation','Measurement','Claim','Hypothesis','Diagnosis')) THEN RAISE(ABORT, 'reification target invalid') END;
  SELECT CASE WHEN (SELECT object_kind FROM e01_202_01_tb WHERE reltype_id = NEW.reltype_id) = 'entity' AND NEW.obj_val_id IS NOT NULL THEN RAISE(ABORT, 'expects entity; got value') END;
  SELECT CASE WHEN (SELECT object_kind FROM e01_202_01_tb WHERE reltype_id = NEW.reltype_id) = 'value' AND NEW.obj_ent_id IS NOT NULL THEN RAISE(ABORT, 'expects value; got entity') END;
  SELECT CASE WHEN EXISTS (SELECT 1 FROM e01_112_01_tb WHERE reltype_id = NEW.reltype_id AND cons_kind = 'allowed_subject_type')
    AND NOT EXISTS (SELECT 1 FROM e01_112_01_tb tc JOIN e01_120_01_tb cl ON cl.anc_id = tc.target_type_id JOIN e01_200_03_tb e ON e.ent_id = NEW.subj_ent_id AND e.type_id = cl.desc_id WHERE tc.reltype_id = NEW.reltype_id AND tc.cons_kind = 'allowed_subject_type')
    THEN RAISE(ABORT, 'subject violates domain (type)') END;
  SELECT CASE WHEN NEW.obj_ent_id IS NOT NULL AND EXISTS (SELECT 1 FROM e01_112_01_tb WHERE reltype_id = NEW.reltype_id AND cons_kind = 'allowed_object_type')
    AND NOT EXISTS (SELECT 1 FROM e01_112_01_tb tc JOIN e01_120_01_tb cl ON cl.anc_id = tc.target_type_id JOIN e01_200_03_tb e ON e.ent_id = NEW.obj_ent_id AND e.type_id = cl.desc_id WHERE tc.reltype_id = NEW.reltype_id AND tc.cons_kind = 'allowed_object_type')
    THEN RAISE(ABORT, 'object violates domain (type)') END;
  SELECT CASE WHEN EXISTS (SELECT 1 FROM e01_112_01_tb WHERE reltype_id = NEW.reltype_id AND cons_kind = 'allowed_subject_nature')
    AND NOT EXISTS (SELECT 1 FROM e01_112_01_tb tc JOIN e01_200_03_tb e ON e.ent_id = NEW.subj_ent_id WHERE tc.reltype_id = NEW.reltype_id AND tc.cons_kind = 'allowed_subject_nature' AND tc.target_nature = e.nature)
    THEN RAISE(ABORT, 'subject violates domain (nature)') END;
  SELECT CASE WHEN NEW.obj_ent_id IS NOT NULL AND EXISTS (SELECT 1 FROM e01_112_01_tb WHERE reltype_id = NEW.reltype_id AND cons_kind = 'allowed_object_nature')
    AND NOT EXISTS (SELECT 1 FROM e01_112_01_tb tc JOIN e01_200_03_tb e ON e.ent_id = NEW.obj_ent_id WHERE tc.reltype_id = NEW.reltype_id AND tc.cons_kind = 'allowed_object_nature' AND tc.target_nature = e.nature)
    THEN RAISE(ABORT, 'object violates domain (nature)') END;
  SELECT CASE WHEN NEW.superseded_at IS NULL AND NEW.status = 'asserted' AND EXISTS (SELECT 1 FROM e01_222_01_tb r JOIN e01_202_01_tb rt ON rt.reltype_id = r.reltype_id WHERE r.subj_ent_id = NEW.subj_ent_id AND r.reltype_id = NEW.reltype_id AND r.ctx_key = NEW.ctx_key AND r.superseded_at IS NULL AND r.status = 'asserted' AND rt.is_functional = 1)
    THEN RAISE(ABORT, 'functional already asserted in ctx') END;
  SELECT CASE WHEN NEW.reltype_id = (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid = 'instance_of') AND NEW.superseded_at IS NULL AND NEW.status = 'asserted'
    AND EXISTS (SELECT 1 FROM e01_222_01_tb r WHERE r.subj_ent_id = NEW.subj_ent_id AND r.reltype_id = NEW.reltype_id AND r.superseded_at IS NULL AND r.status = 'asserted')
    THEN RAISE(ABORT, 'instance_of: one concept per instance') END;
  SELECT CASE WHEN NEW.reltype_id = (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid = 'instance_of') AND NEW.obj_ent_id IS NOT NULL AND NEW.superseded_at IS NULL AND NEW.status = 'asserted'
    AND (SELECT nature FROM e01_200_03_tb WHERE ent_id = NEW.subj_ent_id) = 'instance'
    AND (SELECT nature FROM e01_200_03_tb WHERE ent_id = NEW.obj_ent_id) = 'concept'
    AND (SELECT type_id FROM e01_200_03_tb WHERE ent_id = NEW.subj_ent_id) <> (SELECT type_id FROM e01_200_03_tb WHERE ent_id = NEW.obj_ent_id)
    THEN RAISE(ABORT, 'instance_of: subject type must match concept type') END;
END;
CREATE TRIGGER e03_312_02_tr BEFORE UPDATE OF subj_ent_id, reltype_id, obj_ent_id, obj_val_id, reif_type, reif_ent_id, lin_id, prv_id ON e01_222_01_tb
BEGIN
  SELECT CASE WHEN (SELECT reltype_id FROM e01_202_01_tb WHERE reltype_id = NEW.reltype_id) IS NULL THEN RAISE(ABORT, 'unknown relation type') END;
  SELECT CASE WHEN (SELECT ent_id FROM e01_200_03_tb WHERE ent_id = NEW.subj_ent_id) IS NULL THEN RAISE(ABORT, 'subject entity does not exist') END;
  SELECT CASE WHEN NEW.obj_ent_id IS NOT NULL AND (SELECT ent_id FROM e01_200_03_tb WHERE ent_id = NEW.obj_ent_id) IS NULL THEN RAISE(ABORT, 'object entity does not exist') END;
  SELECT CASE WHEN NEW.obj_val_id IS NOT NULL AND (SELECT val_id FROM e01_201_02_tb WHERE val_id = NEW.obj_val_id) IS NULL THEN RAISE(ABORT, 'object value does not exist') END;
  SELECT CASE WHEN NEW.lin_id IS NOT NULL AND (SELECT lin_id FROM e01_302_01_tb WHERE lin_id = NEW.lin_id) IS NULL THEN RAISE(ABORT, 'relation lineage does not exist') END;
  SELECT CASE WHEN NEW.prv_id IS NOT NULL AND (SELECT prv_id FROM e01_303_01_tb WHERE prv_id = NEW.prv_id) IS NULL THEN RAISE(ABORT, 'relation provenance does not exist') END;
  SELECT CASE WHEN NEW.reif_type <> 'none' AND NOT EXISTS (SELECT 1 FROM e01_200_03_tb e JOIN e01_200_01_tb et ON et.type_id = e.type_id WHERE e.ent_id = NEW.reif_ent_id AND et.type_uid IN ('ReifiedRelation','Evidence','Observation','Measurement','Claim','Hypothesis','Diagnosis')) THEN RAISE(ABORT, 'reification target invalid') END;
  SELECT CASE WHEN (SELECT object_kind FROM e01_202_01_tb WHERE reltype_id = NEW.reltype_id) = 'entity' AND NEW.obj_val_id IS NOT NULL THEN RAISE(ABORT, 'expects entity; got value') END;
  SELECT CASE WHEN (SELECT object_kind FROM e01_202_01_tb WHERE reltype_id = NEW.reltype_id) = 'value' AND NEW.obj_ent_id IS NOT NULL THEN RAISE(ABORT, 'expects value; got entity') END;
  SELECT CASE WHEN EXISTS (SELECT 1 FROM e01_112_01_tb WHERE reltype_id = NEW.reltype_id AND cons_kind = 'allowed_subject_type')
    AND NOT EXISTS (SELECT 1 FROM e01_112_01_tb tc JOIN e01_120_01_tb cl ON cl.anc_id = tc.target_type_id JOIN e01_200_03_tb e ON e.ent_id = NEW.subj_ent_id AND e.type_id = cl.desc_id WHERE tc.reltype_id = NEW.reltype_id AND tc.cons_kind = 'allowed_subject_type')
    THEN RAISE(ABORT, 'subject violates domain (type)') END;
  SELECT CASE WHEN NEW.obj_ent_id IS NOT NULL AND EXISTS (SELECT 1 FROM e01_112_01_tb WHERE reltype_id = NEW.reltype_id AND cons_kind = 'allowed_object_type')
    AND NOT EXISTS (SELECT 1 FROM e01_112_01_tb tc JOIN e01_120_01_tb cl ON cl.anc_id = tc.target_type_id JOIN e01_200_03_tb e ON e.ent_id = NEW.obj_ent_id AND e.type_id = cl.desc_id WHERE tc.reltype_id = NEW.reltype_id AND tc.cons_kind = 'allowed_object_type')
    THEN RAISE(ABORT, 'object violates domain (type)') END;
  SELECT CASE WHEN EXISTS (SELECT 1 FROM e01_112_01_tb WHERE reltype_id = NEW.reltype_id AND cons_kind = 'allowed_subject_nature')
    AND NOT EXISTS (SELECT 1 FROM e01_112_01_tb tc JOIN e01_200_03_tb e ON e.ent_id = NEW.subj_ent_id WHERE tc.reltype_id = NEW.reltype_id AND tc.cons_kind = 'allowed_subject_nature' AND tc.target_nature = e.nature)
    THEN RAISE(ABORT, 'subject violates domain (nature)') END;
  SELECT CASE WHEN NEW.obj_ent_id IS NOT NULL AND EXISTS (SELECT 1 FROM e01_112_01_tb WHERE reltype_id = NEW.reltype_id AND cons_kind = 'allowed_object_nature')
    AND NOT EXISTS (SELECT 1 FROM e01_112_01_tb tc JOIN e01_200_03_tb e ON e.ent_id = NEW.obj_ent_id WHERE tc.reltype_id = NEW.reltype_id AND tc.cons_kind = 'allowed_object_nature' AND tc.target_nature = e.nature)
    THEN RAISE(ABORT, 'object violates domain (nature)') END;
END;
CREATE TRIGGER e03_112_01_tr BEFORE UPDATE OF ctx_key, status, superseded_at ON e01_222_01_tb
BEGIN
  SELECT CASE WHEN NEW.superseded_at IS NULL AND NEW.status = 'asserted' AND OLD.ctx_key <> NEW.ctx_key
    AND EXISTS (SELECT 1 FROM e01_222_01_tb r JOIN e01_202_01_tb rt ON rt.reltype_id = r.reltype_id
      WHERE r.subj_ent_id = NEW.subj_ent_id AND r.reltype_id = NEW.reltype_id AND r.ctx_key = NEW.ctx_key
        AND r.superseded_at IS NULL AND r.status = 'asserted' AND r.rel_id <> NEW.rel_id AND rt.is_functional = 1)
    THEN RAISE(ABORT, 'functional already asserted (ctx conflict)') END;
  SELECT CASE WHEN NEW.reltype_id = (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid = 'instance_of') AND NEW.superseded_at IS NULL AND NEW.status = 'asserted' AND OLD.status <> 'asserted'
    AND EXISTS (SELECT 1 FROM e01_222_01_tb r WHERE r.subj_ent_id = NEW.subj_ent_id AND r.reltype_id = NEW.reltype_id AND r.superseded_at IS NULL AND r.status = 'asserted' AND r.rel_id <> NEW.rel_id)
    THEN RAISE(ABORT, 'instance_of: one concept (upd)') END;
END;
CREATE TRIGGER e03_135_01_tr AFTER INSERT ON e01_305_03_tb
BEGIN
  UPDATE e01_222_01_tb SET ctx_key = COALESCE(
    (SELECT 's:' || group_concat(x, '|')
     FROM (SELECT COALESCE('e:' || ctx_ent_id, 'v:' || ctx_val_id) || ':' || role AS x
           FROM e01_305_03_tb WHERE rel_id = NEW.rel_id
           ORDER BY role, COALESCE(ctx_ent_id, ctx_val_id))), 'u:')
  WHERE rel_id = NEW.rel_id;
END;
CREATE TRIGGER e03_135_02_tr AFTER UPDATE OF ctx_ent_id, ctx_val_id, role, rel_id ON e01_305_03_tb
BEGIN
  UPDATE e01_222_01_tb SET ctx_key = COALESCE(
    (SELECT 's:' || group_concat(x, '|')
     FROM (SELECT COALESCE('e:' || ctx_ent_id, 'v:' || ctx_val_id) || ':' || role AS x
           FROM e01_305_03_tb WHERE rel_id = OLD.rel_id
           ORDER BY role, COALESCE(ctx_ent_id, ctx_val_id))), 'u:')
  WHERE rel_id = OLD.rel_id;
  UPDATE e01_222_01_tb SET ctx_key = COALESCE(
    (SELECT 's:' || group_concat(x, '|')
     FROM (SELECT COALESCE('e:' || ctx_ent_id, 'v:' || ctx_val_id) || ':' || role AS x
           FROM e01_305_03_tb WHERE rel_id = NEW.rel_id
           ORDER BY role, COALESCE(ctx_ent_id, ctx_val_id))), 'u:')
  WHERE rel_id = NEW.rel_id;
END;
CREATE TRIGGER e03_135_03_tr AFTER DELETE ON e01_305_03_tb
BEGIN
  UPDATE e01_222_01_tb SET ctx_key = COALESCE(
    (SELECT 's:' || group_concat(x, '|')
     FROM (SELECT COALESCE('e:' || ctx_ent_id, 'v:' || ctx_val_id) || ':' || role AS x
           FROM e01_305_03_tb WHERE rel_id = OLD.rel_id
           ORDER BY role, COALESCE(ctx_ent_id, ctx_val_id))), 'u:')
  WHERE rel_id = OLD.rel_id;
END;
CREATE TRIGGER e03_343_01_tr AFTER INSERT ON e01_200_03_tb WHEN NEW.prv_id IS NULL
BEGIN UPDATE e01_200_03_tb SET prv_id = (SELECT prv_id FROM e01_303_01_tb WHERE source_type='unknown' AND source_ref='system:unknown' ORDER BY prv_id LIMIT 1), updated_at = datetime('now') WHERE ent_id = NEW.ent_id; END;
CREATE TRIGGER e03_343_02_tr AFTER INSERT ON e01_201_02_tb WHEN NEW.prv_id IS NULL
BEGIN UPDATE e01_201_02_tb SET prv_id = (SELECT prv_id FROM e01_303_01_tb WHERE source_type='unknown' AND source_ref='system:unknown' ORDER BY prv_id LIMIT 1) WHERE val_id = NEW.val_id; END;
CREATE TRIGGER e03_343_03_tr AFTER INSERT ON e01_222_01_tb WHEN NEW.prv_id IS NULL
BEGIN UPDATE e01_222_01_tb SET prv_id = (SELECT prv_id FROM e01_303_01_tb WHERE source_type='unknown' AND source_ref='system:unknown' ORDER BY prv_id LIMIT 1) WHERE rel_id = NEW.rel_id; END;
CREATE TRIGGER e03_343_04_tr AFTER INSERT ON e01_305_01_tb WHEN NEW.prv_id IS NULL
BEGIN UPDATE e01_305_01_tb SET prv_id = (SELECT prv_id FROM e01_303_01_tb WHERE source_type='unknown' AND source_ref='system:unknown' ORDER BY prv_id LIMIT 1) WHERE ctx_id = NEW.ctx_id; END;
CREATE TRIGGER e03_343_05_tr AFTER INSERT ON e01_305_02_tb WHEN NEW.prv_id IS NULL
BEGIN UPDATE e01_305_02_tb SET prv_id = (SELECT prv_id FROM e01_303_01_tb WHERE source_type='unknown' AND source_ref='system:unknown' ORDER BY prv_id LIMIT 1) WHERE ctx_id = NEW.ctx_id; END;
CREATE TRIGGER e03_343_06_tr AFTER INSERT ON e01_305_03_tb WHEN NEW.prv_id IS NULL
BEGIN UPDATE e01_305_03_tb SET prv_id = (SELECT prv_id FROM e01_303_01_tb WHERE source_type='unknown' AND source_ref='system:unknown' ORDER BY prv_id LIMIT 1) WHERE ctx_id = NEW.ctx_id; END;
CREATE TRIGGER e03_343_07_tr AFTER INSERT ON e01_300_01_tb WHEN NEW.prv_id IS NULL
BEGIN UPDATE e01_300_01_tb SET prv_id = (SELECT prv_id FROM e01_303_01_tb WHERE source_type='unknown' AND source_ref='system:unknown' ORDER BY prv_id LIMIT 1) WHERE clm_id = NEW.clm_id; END;
CREATE TRIGGER e03_343_08_tr BEFORE DELETE ON e01_303_01_tb WHEN OLD.source_type = 'unknown' AND OLD.source_ref = 'system:unknown'
BEGIN SELECT RAISE(ABORT, 'cannot delete fallback provenance'); END;
CREATE TRIGGER e03_343_09_tr BEFORE UPDATE OF source_type, source_ref ON e01_303_01_tb
WHEN OLD.source_type = 'unknown' AND OLD.source_ref = 'system:unknown' AND (NEW.source_type <> 'unknown' OR NEW.source_ref <> 'system:unknown')
BEGIN SELECT RAISE(ABORT, 'cannot change fallback provenance identity'); END;
CREATE TRIGGER e03_311_01_tr AFTER INSERT ON e01_201_02_tb WHEN NEW.value_kind = 'text' AND NEW.text_val IS NOT NULL AND NEW.text_norm IS NULL
BEGIN UPDATE e01_201_02_tb SET text_norm = lower(trim(NEW.text_val)) WHERE val_id = NEW.val_id; END;
CREATE TRIGGER e03_311_02_tr AFTER UPDATE OF text_val ON e01_201_02_tb WHEN NEW.value_kind = 'text' AND NEW.text_val IS NOT NULL AND (NEW.text_norm IS NULL OR NEW.text_norm <> lower(trim(NEW.text_val)))
BEGIN UPDATE e01_201_02_tb SET text_norm = lower(trim(NEW.text_val)) WHERE val_id = NEW.val_id; END;
CREATE TRIGGER e03_311_03_tr BEFORE INSERT ON e01_201_03_tb WHEN NEW.member_val_id IS NOT NULL
BEGIN SELECT CASE WHEN EXISTS (WITH RECURSIVE desc_of_parent(id, depth) AS (
    SELECT NEW.parent_id, 0
    UNION ALL
    SELECT e.member_val_id, desc_of_parent.depth + 1 FROM e01_201_03_tb e
    JOIN desc_of_parent ON e.parent_id = desc_of_parent.id
    WHERE e.member_val_id IS NOT NULL
      AND desc_of_parent.depth < (SELECT int_value FROM e01_676_03_tb WHERE param_uid='max_member_depth'))
    SELECT 1 FROM desc_of_parent WHERE id = NEW.member_val_id) THEN RAISE(ABORT, 'value member: cycle detected') END; END;
CREATE TRIGGER e03_311_04_tr BEFORE UPDATE OF parent_id, member_val_id ON e01_201_03_tb WHEN NEW.member_val_id IS NOT NULL
BEGIN SELECT CASE WHEN EXISTS (WITH RECURSIVE desc_of_parent(id, depth) AS (
    SELECT NEW.parent_id, 0
    UNION ALL
    SELECT e.member_val_id, desc_of_parent.depth + 1 FROM e01_201_03_tb e
    JOIN desc_of_parent ON e.parent_id = desc_of_parent.id
    WHERE e.member_val_id IS NOT NULL AND e.memb_id <> NEW.memb_id
      AND desc_of_parent.depth < (SELECT int_value FROM e01_676_03_tb WHERE param_uid='max_member_depth'))
    SELECT 1 FROM desc_of_parent WHERE id = NEW.member_val_id) THEN RAISE(ABORT, 'value member: cycle detected (upd)') END; END;
CREATE TRIGGER e03_516_01_tr BEFORE INSERT ON e01_506_06_tb WHEN NEW.parent_id IS NOT NULL
BEGIN SELECT CASE WHEN NOT EXISTS (SELECT 1 FROM e01_506_06_tb p WHERE p.node_id = NEW.parent_id AND p.need_uid = NEW.need_uid) THEN RAISE(ABORT, 'node parent belongs to another need') END; END;
CREATE TRIGGER e03_516_02_tr BEFORE UPDATE OF need_uid, parent_id ON e01_506_06_tb WHEN NEW.parent_id IS NOT NULL
BEGIN SELECT CASE WHEN NOT EXISTS (SELECT 1 FROM e01_506_06_tb p WHERE p.node_id = NEW.parent_id AND p.need_uid = NEW.need_uid) THEN RAISE(ABORT, 'node parent belongs to another need') END; END;
CREATE TRIGGER e03_126_01_tr BEFORE UPDATE OF parent_id ON e01_506_06_tb WHEN NEW.parent_id IS NOT NULL AND NEW.parent_id <> NEW.node_id
BEGIN SELECT CASE WHEN EXISTS (WITH RECURSIVE up(id) AS (SELECT NEW.parent_id UNION SELECT parent_id FROM e01_506_06_tb JOIN up ON e01_506_06_tb.node_id = up.id WHERE parent_id IS NOT NULL) SELECT 1 FROM up WHERE id = NEW.node_id) THEN RAISE(ABORT, 'node cycle detected') END; END;
CREATE TRIGGER e03_126_02_tr BEFORE INSERT ON e01_506_05_tb WHEN NEW.parent_uid = NEW.question_uid
BEGIN SELECT RAISE(ABORT, 'question self-cycle'); END;
CREATE TRIGGER e03_126_03_tr BEFORE UPDATE OF parent_uid ON e01_506_05_tb WHEN NEW.parent_uid IS NOT NULL
BEGIN
  SELECT CASE WHEN NEW.parent_uid = NEW.question_uid THEN RAISE(ABORT, 'question self-cycle (upd)') END;
  SELECT CASE WHEN EXISTS (WITH RECURSIVE up(uid) AS (SELECT NEW.parent_uid UNION SELECT parent_uid FROM e01_506_05_tb JOIN up ON e01_506_05_tb.question_uid = up.uid WHERE parent_uid IS NOT NULL) SELECT 1 FROM up WHERE uid = NEW.question_uid) THEN RAISE(ABORT, 'question cycle detected') END;
END;
CREATE TRIGGER e03_320_01_tr BEFORE DELETE ON e01_200_03_tb
BEGIN SELECT CASE WHEN EXISTS (
  SELECT 1 FROM e01_201_03_tb WHERE member_ent_id = OLD.ent_id
  UNION ALL SELECT 1 FROM e01_302_01_tb WHERE subj_ent_id = OLD.ent_id
  UNION ALL SELECT 1 FROM e01_222_01_tb WHERE subj_ent_id = OLD.ent_id
  UNION ALL SELECT 1 FROM e01_222_01_tb WHERE obj_ent_id = OLD.ent_id
  UNION ALL SELECT 1 FROM e01_222_01_tb WHERE reif_ent_id = OLD.ent_id
  UNION ALL SELECT 1 FROM e01_305_01_tb WHERE ent_id = OLD.ent_id OR ctx_ent_id = OLD.ent_id
  UNION ALL SELECT 1 FROM e01_305_02_tb WHERE ctx_ent_id = OLD.ent_id
  UNION ALL SELECT 1 FROM e01_305_03_tb WHERE ctx_ent_id = OLD.ent_id
  UNION ALL SELECT 1 FROM e01_300_01_tb WHERE ent_a_id = OLD.ent_id OR ent_b_id = OLD.ent_id
  UNION ALL SELECT 1 FROM e01_330_01_tb WHERE ent_id = OLD.ent_id OR approved_by_id = OLD.ent_id
  UNION ALL SELECT 1 FROM e01_330_02_tb WHERE ent_id = OLD.ent_id)
  THEN RAISE(ABORT, 'entity referenced; retract or archive first') END; END;
CREATE TRIGGER e03_320_02_tr BEFORE DELETE ON e01_201_02_tb
BEGIN SELECT CASE WHEN EXISTS (
  SELECT 1 FROM e01_222_01_tb WHERE obj_val_id = OLD.val_id
  UNION ALL SELECT 1 FROM e01_201_03_tb WHERE parent_id = OLD.val_id OR member_val_id = OLD.val_id
  UNION ALL SELECT 1 FROM e01_305_01_tb WHERE ctx_val_id = OLD.val_id
  UNION ALL SELECT 1 FROM e01_305_02_tb WHERE val_id = OLD.val_id OR ctx_val_id = OLD.val_id
  UNION ALL SELECT 1 FROM e01_305_03_tb WHERE ctx_val_id = OLD.val_id)
  THEN RAISE(ABORT, 'value referenced; retract or cascade first') END; END;
CREATE TRIGGER e03_320_03_tr BEFORE DELETE ON e01_200_01_tb
BEGIN SELECT CASE WHEN EXISTS (
  SELECT 1 FROM e01_200_01_tb WHERE parent_id = OLD.type_id
  UNION ALL SELECT 1 FROM e01_200_03_tb WHERE type_id = OLD.type_id
  UNION ALL SELECT 1 FROM e01_112_01_tb WHERE target_type_id = OLD.type_id
  UNION ALL SELECT 1 FROM e01_120_01_tb WHERE desc_id = OLD.type_id OR anc_id = OLD.type_id)
  THEN RAISE(ABORT, 'entity type referenced') END; END;
CREATE TRIGGER e03_320_04_tr BEFORE DELETE ON e01_202_01_tb
BEGIN SELECT CASE WHEN EXISTS (
  SELECT 1 FROM e01_222_01_tb WHERE reltype_id = OLD.reltype_id
  UNION ALL SELECT 1 FROM e01_302_01_tb WHERE reltype_id = OLD.reltype_id
  UNION ALL SELECT 1 FROM e01_112_01_tb WHERE reltype_id = OLD.reltype_id
  UNION ALL SELECT 1 FROM e01_202_01_tb WHERE inverse_uid = OLD.type_uid)
  THEN RAISE(ABORT, 'relation type referenced') END; END;
CREATE TRIGGER e03_320_05_tr BEFORE DELETE ON e01_303_01_tb WHEN NOT (OLD.source_type = 'unknown' AND OLD.source_ref = 'system:unknown')
BEGIN SELECT CASE WHEN EXISTS (
  SELECT 1 FROM e01_200_03_tb WHERE prv_id = OLD.prv_id
  UNION ALL SELECT 1 FROM e01_201_02_tb WHERE prv_id = OLD.prv_id
  UNION ALL SELECT 1 FROM e01_222_01_tb WHERE prv_id = OLD.prv_id
  UNION ALL SELECT 1 FROM e01_305_01_tb WHERE prv_id = OLD.prv_id
  UNION ALL SELECT 1 FROM e01_305_02_tb WHERE prv_id = OLD.prv_id
  UNION ALL SELECT 1 FROM e01_305_03_tb WHERE prv_id = OLD.prv_id
  UNION ALL SELECT 1 FROM e01_300_01_tb WHERE prv_id = OLD.prv_id)
  THEN RAISE(ABORT, 'provenance referenced') END; END;
CREATE TRIGGER e03_320_06_tr BEFORE DELETE ON e01_302_01_tb
BEGIN SELECT CASE WHEN EXISTS (SELECT 1 FROM e01_222_01_tb WHERE lin_id = OLD.lin_id) THEN RAISE(ABORT, 'lineage referenced by relations') END; END;
CREATE TRIGGER e03_320_07_tr BEFORE DELETE ON e01_200_02_tb
BEGIN SELECT CASE WHEN EXISTS (SELECT 1 FROM e01_201_01_tb WHERE dom_id = OLD.dom_id) THEN RAISE(ABORT, 'enum domain has values') END; END;
CREATE TRIGGER e03_320_08_tr BEFORE DELETE ON e01_201_01_tb
BEGIN SELECT CASE WHEN EXISTS (SELECT 1 FROM e01_201_02_tb WHERE enum_id = OLD.val_id) THEN RAISE(ABORT, 'enum value referenced by values') END; END;
CREATE TRIGGER e03_320_09_tr BEFORE UPDATE OF type_id ON e01_200_03_tb WHEN OLD.type_id <> NEW.type_id
BEGIN
  SELECT CASE WHEN EXISTS (SELECT 1 FROM e01_222_01_tb r WHERE r.subj_ent_id = OLD.ent_id AND r.status = 'asserted' AND r.superseded_at IS NULL AND EXISTS (SELECT 1 FROM e01_112_01_tb c WHERE c.reltype_id = r.reltype_id AND c.cons_kind = 'allowed_subject_type') AND NOT EXISTS (SELECT 1 FROM e01_112_01_tb c JOIN e01_120_01_tb cl ON cl.anc_id = c.target_type_id WHERE c.reltype_id = r.reltype_id AND c.cons_kind = 'allowed_subject_type' AND cl.desc_id = NEW.type_id)) THEN RAISE(ABORT, 'cannot change type: violates active subject domain') END;
  SELECT CASE WHEN EXISTS (SELECT 1 FROM e01_222_01_tb r WHERE r.obj_ent_id = OLD.ent_id AND r.status = 'asserted' AND r.superseded_at IS NULL AND EXISTS (SELECT 1 FROM e01_112_01_tb c WHERE c.reltype_id = r.reltype_id AND c.cons_kind = 'allowed_object_type') AND NOT EXISTS (SELECT 1 FROM e01_112_01_tb c JOIN e01_120_01_tb cl ON cl.anc_id = c.target_type_id WHERE c.reltype_id = r.reltype_id AND c.cons_kind = 'allowed_object_type' AND cl.desc_id = NEW.type_id)) THEN RAISE(ABORT, 'cannot change type: violates active object domain') END;
  SELECT CASE WHEN EXISTS (SELECT 1 FROM e01_222_01_tb r WHERE r.reif_ent_id = OLD.ent_id AND r.reif_type <> 'none' AND r.status = 'asserted' AND r.superseded_at IS NULL AND NOT EXISTS (SELECT 1 FROM e01_200_01_tb et WHERE et.type_id = NEW.type_id AND et.type_uid IN ('ReifiedRelation','Evidence','Observation','Measurement','Claim','Hypothesis','Diagnosis'))) THEN RAISE(ABORT, 'cannot change type: invalidates reification') END;
END;
CREATE TRIGGER e03_370_30_tr BEFORE DELETE ON e01_778_01_tb
BEGIN SELECT CASE WHEN EXISTS (SELECT 1 FROM e01_778_01_tb WHERE parent_code = OLD.code UNION ALL SELECT 1 FROM e01_778_02_tb WHERE code = OLD.code) THEN RAISE(ABORT, 'req_code referenced') END; END;
CREATE TRIGGER e03_370_32_tr BEFORE UPDATE OF need_uid, code, code_kind ON e01_778_01_tb WHEN OLD.need_uid <> NEW.need_uid OR OLD.code <> NEW.code OR OLD.code_kind <> NEW.code_kind
BEGIN SELECT RAISE(ABORT, 'e01_778_01_tb PK is immutable'); END;
CREATE TRIGGER e03_370_34_tr BEFORE UPDATE OF chain_uid, ordinal ON e01_778_04_tb WHEN OLD.chain_uid <> NEW.chain_uid OR OLD.ordinal <> NEW.ordinal
BEGIN SELECT RAISE(ABORT, 'e01_778_04_tb PK is immutable'); END;
CREATE TRIGGER e03_360_01_tr AFTER UPDATE OF status ON e01_222_01_tb WHEN NEW.status = 'retracted' AND OLD.status <> 'retracted' AND NEW.reif_type = 'annotated' AND NEW.reif_ent_id IS NOT NULL
BEGIN UPDATE e01_200_03_tb SET status = 'archived' WHERE ent_id = NEW.reif_ent_id AND status = 'active'; END;
CREATE TRIGGER e03_370_02_tr BEFORE INSERT ON e01_506_03_tb
BEGIN SELECT CASE WHEN NEW.need_uid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM e01_506_01_tb WHERE need_uid = NEW.need_uid) THEN RAISE(ABORT, 'ele_stor: need does not exist') END; END;
CREATE TRIGGER e03_370_03_tr BEFORE INSERT ON e01_506_04_tb
BEGIN SELECT CASE WHEN NOT EXISTS (SELECT 1 FROM e01_506_02_tb WHERE atom_uid = NEW.atom_uid) THEN RAISE(ABORT, 'tra_stor: atom does not exist') END; SELECT CASE WHEN NOT EXISTS (SELECT 1 FROM e01_506_03_tb WHERE element_name = NEW.element_name) THEN RAISE(ABORT, 'tra_stor: element does not exist') END; END;
CREATE TRIGGER e03_370_04_tr BEFORE INSERT ON e01_506_08_tb
BEGIN SELECT CASE WHEN NOT EXISTS (SELECT 1 FROM e01_506_07_tb WHERE dim_uid = NEW.dim_uid) THEN RAISE(ABORT, 'dim_val: dim does not exist') END; END;
CREATE TRIGGER e03_370_05_tr BEFORE INSERT ON e01_506_06_tb
BEGIN SELECT CASE WHEN NOT EXISTS (SELECT 1 FROM e01_506_01_tb WHERE need_uid = NEW.need_uid) THEN RAISE(ABORT, 'nod_tree: need does not exist') END; SELECT CASE WHEN NEW.parent_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM e01_506_06_tb WHERE node_id = NEW.parent_id) THEN RAISE(ABORT, 'nod_tree: parent does not exist') END; SELECT CASE WHEN NOT EXISTS (SELECT 1 FROM e01_506_05_tb WHERE question_uid = NEW.question_uid) THEN RAISE(ABORT, 'nod_tree: question does not exist') END; END;
CREATE TRIGGER e03_370_06_tr BEFORE INSERT ON e01_506_05_tb
BEGIN SELECT CASE WHEN NEW.parent_uid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM e01_506_05_tb WHERE question_uid = NEW.parent_uid) THEN RAISE(ABORT, 'que_gram: parent does not exist') END; END;
CREATE TRIGGER e03_370_07_tr BEFORE INSERT ON e01_330_01_tb
BEGIN SELECT CASE WHEN NOT EXISTS (SELECT 1 FROM e01_200_03_tb WHERE ent_id = NEW.ent_id) THEN RAISE(ABORT, 'ent_vers: entity does not exist') END; SELECT CASE WHEN NEW.supersedes_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM e01_330_01_tb WHERE vers_id = NEW.supersedes_id) THEN RAISE(ABORT, 'ent_vers: supersedes does not exist') END; SELECT CASE WHEN NEW.supersedes_id IS NOT NULL AND NEW.supersedes_id = NEW.vers_id THEN RAISE(ABORT, 'ent_vers: cannot supersede self') END; SELECT CASE WHEN NEW.supersedes_id IS NOT NULL AND (SELECT ent_id FROM e01_330_01_tb WHERE vers_id = NEW.supersedes_id) <> NEW.ent_id THEN RAISE(ABORT, 'ent_vers: supersedes cross-entity') END; SELECT CASE WHEN NEW.approved_by_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM e01_200_03_tb WHERE ent_id = NEW.approved_by_id) THEN RAISE(ABORT, 'ent_vers: approver does not exist') END; END;
CREATE TRIGGER e03_370_08_tr BEFORE INSERT ON e01_330_02_tb
BEGIN SELECT CASE WHEN NOT EXISTS (SELECT 1 FROM e01_200_03_tb WHERE ent_id = NEW.ent_id) THEN RAISE(ABORT, 'ent_snap: entity does not exist') END; SELECT CASE WHEN NEW.vers_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM e01_330_01_tb WHERE vers_id = NEW.vers_id) THEN RAISE(ABORT, 'ent_snap: vers does not exist') END; SELECT CASE WHEN NEW.vers_id IS NOT NULL AND (SELECT ent_id FROM e01_330_01_tb WHERE vers_id = NEW.vers_id) <> NEW.ent_id THEN RAISE(ABORT, 'ent_snap: vers cross-entity') END; END;
CREATE TRIGGER e03_370_12_tr BEFORE UPDATE OF need_uid ON e01_506_03_tb
BEGIN SELECT CASE WHEN NEW.need_uid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM e01_506_01_tb WHERE need_uid = NEW.need_uid) THEN RAISE(ABORT, 'ele_stor.upd: need does not exist') END; END;
CREATE TRIGGER e03_370_13_tr BEFORE UPDATE OF atom_uid, element_name ON e01_506_04_tb
BEGIN SELECT CASE WHEN NOT EXISTS (SELECT 1 FROM e01_506_02_tb WHERE atom_uid = NEW.atom_uid) THEN RAISE(ABORT, 'tra_stor.upd: atom does not exist') END; SELECT CASE WHEN NOT EXISTS (SELECT 1 FROM e01_506_03_tb WHERE element_name = NEW.element_name) THEN RAISE(ABORT, 'tra_stor.upd: element does not exist') END; END;
CREATE TRIGGER e03_370_15_tr BEFORE UPDATE OF need_uid, parent_id, question_uid ON e01_506_06_tb
BEGIN SELECT CASE WHEN NOT EXISTS (SELECT 1 FROM e01_506_01_tb WHERE need_uid = NEW.need_uid) THEN RAISE(ABORT, 'nod_tree.upd: need does not exist') END; SELECT CASE WHEN NEW.parent_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM e01_506_06_tb WHERE node_id = NEW.parent_id) THEN RAISE(ABORT, 'nod_tree.upd: parent does not exist') END; SELECT CASE WHEN NOT EXISTS (SELECT 1 FROM e01_506_05_tb WHERE question_uid = NEW.question_uid) THEN RAISE(ABORT, 'nod_tree.upd: question does not exist') END; END;
CREATE TRIGGER e03_370_16_tr BEFORE UPDATE OF parent_uid ON e01_506_05_tb
BEGIN SELECT CASE WHEN NEW.parent_uid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM e01_506_05_tb WHERE question_uid = NEW.parent_uid) THEN RAISE(ABORT, 'que_gram.upd: parent does not exist') END; END;
CREATE TRIGGER e03_370_17_tr BEFORE UPDATE OF ent_id, supersedes_id, approved_by_id ON e01_330_01_tb
BEGIN
  SELECT CASE WHEN NOT EXISTS (SELECT 1 FROM e01_200_03_tb WHERE ent_id = NEW.ent_id) THEN RAISE(ABORT, 'ent_vers.upd: entity does not exist') END;
  SELECT CASE WHEN NEW.supersedes_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM e01_330_01_tb WHERE vers_id = NEW.supersedes_id) THEN RAISE(ABORT, 'ent_vers.upd: supersedes does not exist') END;
  SELECT CASE WHEN NEW.supersedes_id IS NOT NULL AND NEW.supersedes_id = NEW.vers_id THEN RAISE(ABORT, 'ent_vers.upd: cannot supersede self') END;
  SELECT CASE WHEN NEW.supersedes_id IS NOT NULL AND (SELECT ent_id FROM e01_330_01_tb WHERE vers_id = NEW.supersedes_id) <> NEW.ent_id THEN RAISE(ABORT, 'ent_vers.upd: supersedes cross-entity') END;
  SELECT CASE WHEN NEW.supersedes_id IS NOT NULL AND EXISTS (WITH RECURSIVE chain(vid, depth) AS (SELECT NEW.supersedes_id, 0 UNION ALL SELECT v.supersedes_id, chain.depth + 1 FROM e01_330_01_tb v JOIN chain ON v.vers_id = chain.vid WHERE v.supersedes_id IS NOT NULL AND chain.depth < (SELECT int_value FROM e01_676_03_tb WHERE param_uid='max_version_depth')) SELECT 1 FROM chain WHERE vid = NEW.vers_id) THEN RAISE(ABORT, 'ent_vers.upd: supersedes chain cycle') END;
  SELECT CASE WHEN NEW.approved_by_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM e01_200_03_tb WHERE ent_id = NEW.approved_by_id) THEN RAISE(ABORT, 'ent_vers.upd: approver does not exist') END;
END;
CREATE TRIGGER e03_370_18_tr BEFORE UPDATE OF ent_id, vers_id ON e01_330_02_tb
BEGIN SELECT CASE WHEN NOT EXISTS (SELECT 1 FROM e01_200_03_tb WHERE ent_id = NEW.ent_id) THEN RAISE(ABORT, 'ent_snap.upd: entity does not exist') END; SELECT CASE WHEN NEW.vers_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM e01_330_01_tb WHERE vers_id = NEW.vers_id) THEN RAISE(ABORT, 'ent_snap.upd: vers does not exist') END; SELECT CASE WHEN NEW.vers_id IS NOT NULL AND (SELECT ent_id FROM e01_330_01_tb WHERE vers_id = NEW.vers_id) <> NEW.ent_id THEN RAISE(ABORT, 'ent_snap.upd: vers cross-entity') END; END;
CREATE TRIGGER e03_370_21_tr BEFORE DELETE ON e01_506_01_tb
BEGIN SELECT CASE WHEN EXISTS (SELECT 1 FROM e01_516_01_tb WHERE need_uid = OLD.need_uid UNION ALL SELECT 1 FROM e01_506_06_tb WHERE need_uid = OLD.need_uid UNION ALL SELECT 1 FROM e01_506_03_tb WHERE need_uid = OLD.need_uid UNION ALL SELECT 1 FROM e01_778_01_tb WHERE need_uid = OLD.need_uid UNION ALL SELECT 1 FROM e01_778_02_tb WHERE need_uid = OLD.need_uid UNION ALL SELECT 1 FROM e01_778_03_tb WHERE root_need_uid = OLD.need_uid UNION ALL SELECT 1 FROM e01_778_04_tb WHERE need_uid = OLD.need_uid) THEN RAISE(ABORT, 'nee_stor referenced; use status=deferred/dropped') END; END;
CREATE TRIGGER e03_370_22_tr BEFORE DELETE ON e01_506_02_tb
BEGIN SELECT CASE WHEN EXISTS (SELECT 1 FROM e01_516_01_tb WHERE atom_uid = OLD.atom_uid UNION ALL SELECT 1 FROM e01_506_04_tb WHERE atom_uid = OLD.atom_uid) THEN RAISE(ABORT, 'req_stor referenced; use status=deferred/dropped') END; END;
CREATE TRIGGER e03_370_23_tr BEFORE DELETE ON e01_506_03_tb
BEGIN SELECT CASE WHEN EXISTS (SELECT 1 FROM e01_506_04_tb WHERE element_name = OLD.element_name UNION ALL SELECT 1 FROM e01_778_02_tb WHERE element_name = OLD.element_name UNION ALL SELECT 1 FROM e01_778_04_tb WHERE element_name = OLD.element_name) THEN RAISE(ABORT, 'ele_stor referenced') END; END;
CREATE TRIGGER e03_370_24_tr BEFORE DELETE ON e01_506_07_tb
BEGIN SELECT CASE WHEN EXISTS (SELECT 1 FROM e01_506_08_tb WHERE dim_uid = OLD.dim_uid) THEN RAISE(ABORT, 'dim_stor referenced') END; END;
CREATE TRIGGER e03_370_25_tr BEFORE DELETE ON e01_506_05_tb
BEGIN SELECT CASE WHEN EXISTS (SELECT 1 FROM e01_506_05_tb WHERE parent_uid = OLD.question_uid UNION ALL SELECT 1 FROM e01_506_06_tb WHERE question_uid = OLD.question_uid) THEN RAISE(ABORT, 'que_gram referenced') END; END;
CREATE TRIGGER e03_370_26_tr BEFORE DELETE ON e01_330_01_tb
BEGIN SELECT CASE WHEN EXISTS (SELECT 1 FROM e01_330_01_tb WHERE supersedes_id = OLD.vers_id UNION ALL SELECT 1 FROM e01_330_02_tb WHERE vers_id = OLD.vers_id) THEN RAISE(ABORT, 'ent_vers referenced; use status=deprecated') END; END;
CREATE TRIGGER e03_310_03_tr BEFORE INSERT ON e01_201_02_tb
BEGIN SELECT CASE WHEN NEW.enum_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM e01_201_01_tb WHERE val_id = NEW.enum_id) THEN RAISE(ABORT, 'enum value does not exist') END; END;
CREATE TRIGGER e03_310_04_tr BEFORE UPDATE OF enum_id ON e01_201_02_tb
BEGIN SELECT CASE WHEN NEW.enum_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM e01_201_01_tb WHERE val_id = NEW.enum_id) THEN RAISE(ABORT, 'enum value does not exist (upd)') END; END;
CREATE TRIGGER e03_310_05_tr BEFORE INSERT ON e01_201_03_tb
BEGIN SELECT CASE WHEN NOT EXISTS (SELECT 1 FROM e01_201_02_tb WHERE val_id = NEW.parent_id) THEN RAISE(ABORT, 'val_memb: parent does not exist') END; SELECT CASE WHEN NEW.member_val_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM e01_201_02_tb WHERE val_id = NEW.member_val_id) THEN RAISE(ABORT, 'val_memb: member_val does not exist') END; SELECT CASE WHEN NEW.member_ent_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM e01_200_03_tb WHERE ent_id = NEW.member_ent_id) THEN RAISE(ABORT, 'val_memb: member_ent does not exist') END; END;
CREATE TRIGGER e03_310_06_tr BEFORE UPDATE OF parent_id, member_val_id, member_ent_id ON e01_201_03_tb
BEGIN SELECT CASE WHEN NOT EXISTS (SELECT 1 FROM e01_201_02_tb WHERE val_id = NEW.parent_id) THEN RAISE(ABORT, 'val_memb.upd: parent does not exist') END; SELECT CASE WHEN NEW.member_val_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM e01_201_02_tb WHERE val_id = NEW.member_val_id) THEN RAISE(ABORT, 'val_memb.upd: member_val does not exist') END; SELECT CASE WHEN NEW.member_ent_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM e01_200_03_tb WHERE ent_id = NEW.member_ent_id) THEN RAISE(ABORT, 'val_memb.upd: member_ent does not exist') END; END;
CREATE TRIGGER e03_328_01_tr BEFORE UPDATE OF need_uid ON e01_506_01_tb WHEN OLD.need_uid <> NEW.need_uid BEGIN SELECT RAISE(ABORT, 'e01_506_01_tb.need_uid is immutable'); END;
CREATE TRIGGER e03_328_02_tr BEFORE UPDATE OF atom_uid ON e01_506_02_tb WHEN OLD.atom_uid <> NEW.atom_uid BEGIN SELECT RAISE(ABORT, 'e01_506_02_tb.atom_uid is immutable'); END;
CREATE TRIGGER e03_328_04_tr BEFORE UPDATE OF element_name ON e01_506_03_tb WHEN OLD.element_name <> NEW.element_name BEGIN SELECT RAISE(ABORT, 'e01_506_03_tb.element_name is immutable'); END;
CREATE TRIGGER e03_328_05_tr BEFORE UPDATE OF trace_id ON e01_506_04_tb WHEN OLD.trace_id <> NEW.trace_id BEGIN SELECT RAISE(ABORT, 'e01_506_04_tb.trace_id is immutable'); END;
CREATE TRIGGER e03_328_06_tr BEFORE UPDATE OF question_uid ON e01_506_05_tb WHEN OLD.question_uid <> NEW.question_uid BEGIN SELECT RAISE(ABORT, 'e01_506_05_tb.question_uid is immutable'); END;
CREATE TRIGGER e03_328_07_tr BEFORE UPDATE OF node_id ON e01_506_06_tb WHEN OLD.node_id <> NEW.node_id BEGIN SELECT RAISE(ABORT, 'e01_506_06_tb.node_id is immutable'); END;
CREATE TRIGGER e03_328_08_tr BEFORE UPDATE OF migration_uid ON e01_676_01_tb WHEN OLD.migration_uid <> NEW.migration_uid BEGIN SELECT RAISE(ABORT, 'e01_676_01_tb.migration_uid is immutable'); END;
CREATE TRIGGER e03_328_09_tr BEFORE UPDATE OF id ON e01_676_02_tb WHEN OLD.id <> NEW.id BEGIN SELECT RAISE(ABORT, 'e01_676_02_tb.id is immutable'); END;
CREATE TRIGGER e03_328_10_tr BEFORE UPDATE OF ref_id ON e01_378_01_tb WHEN OLD.ref_id <> NEW.ref_id BEGIN SELECT RAISE(ABORT, 'e01_378_01_tb.ref_id is immutable'); END;
CREATE TRIGGER e03_328_11_tr BEFORE UPDATE OF dim_uid ON e01_506_07_tb WHEN OLD.dim_uid <> NEW.dim_uid BEGIN SELECT RAISE(ABORT, 'e01_506_07_tb.dim_uid is immutable'); END;
CREATE TRIGGER e03_328_12_tr BEFORE UPDATE OF value_id ON e01_506_08_tb WHEN OLD.value_id <> NEW.value_id BEGIN SELECT RAISE(ABORT, 'e01_506_08_tb.value_id is immutable'); END;
CREATE TRIGGER e03_328_13_tr BEFORE UPDATE OF type_id ON e01_200_01_tb WHEN OLD.type_id <> NEW.type_id BEGIN SELECT RAISE(ABORT, 'e01_200_01_tb.type_id is immutable'); END;
CREATE TRIGGER e03_328_14_tr BEFORE UPDATE OF desc_id, anc_id ON e01_120_01_tb WHEN OLD.desc_id <> NEW.desc_id OR OLD.anc_id <> NEW.anc_id BEGIN SELECT RAISE(ABORT, 'e01_120_01_tb PK is immutable'); END;
CREATE TRIGGER e03_328_15_tr BEFORE UPDATE OF reltype_id ON e01_202_01_tb WHEN OLD.reltype_id <> NEW.reltype_id BEGIN SELECT RAISE(ABORT, 'e01_202_01_tb.reltype_id is immutable'); END;
CREATE TRIGGER e03_328_16_tr BEFORE UPDATE OF cons_id ON e01_112_01_tb WHEN OLD.cons_id <> NEW.cons_id BEGIN SELECT RAISE(ABORT, 'e01_112_01_tb.cons_id is immutable'); END;
CREATE TRIGGER e03_328_17_tr BEFORE UPDATE OF dom_id ON e01_200_02_tb WHEN OLD.dom_id <> NEW.dom_id BEGIN SELECT RAISE(ABORT, 'e01_200_02_tb.dom_id is immutable'); END;
CREATE TRIGGER e03_328_18_tr BEFORE UPDATE OF val_id ON e01_201_01_tb WHEN OLD.val_id <> NEW.val_id BEGIN SELECT RAISE(ABORT, 'e01_201_01_tb.val_id is immutable'); END;
CREATE TRIGGER e03_328_19_tr BEFORE UPDATE OF prv_id ON e01_303_01_tb WHEN OLD.prv_id <> NEW.prv_id BEGIN SELECT RAISE(ABORT, 'e01_303_01_tb.prv_id is immutable'); END;
CREATE TRIGGER e03_328_20_tr BEFORE UPDATE OF ent_id ON e01_200_03_tb WHEN OLD.ent_id <> NEW.ent_id BEGIN SELECT RAISE(ABORT, 'e01_200_03_tb.ent_id is immutable'); END;
CREATE TRIGGER e03_328_21_tr BEFORE UPDATE OF val_id ON e01_201_02_tb WHEN OLD.val_id <> NEW.val_id BEGIN SELECT RAISE(ABORT, 'e01_201_02_tb.val_id is immutable'); END;
CREATE TRIGGER e03_328_22_tr BEFORE UPDATE OF memb_id ON e01_201_03_tb WHEN OLD.memb_id <> NEW.memb_id BEGIN SELECT RAISE(ABORT, 'e01_201_03_tb.memb_id is immutable'); END;
CREATE TRIGGER e03_328_23_tr BEFORE UPDATE OF lin_id ON e01_302_01_tb WHEN OLD.lin_id <> NEW.lin_id BEGIN SELECT RAISE(ABORT, 'e01_302_01_tb.lin_id is immutable'); END;
CREATE TRIGGER e03_328_24_tr BEFORE UPDATE OF rel_id ON e01_222_01_tb WHEN OLD.rel_id <> NEW.rel_id BEGIN SELECT RAISE(ABORT, 'e01_222_01_tb.rel_id is immutable'); END;
CREATE TRIGGER e03_328_25_tr BEFORE UPDATE OF ctx_id ON e01_305_01_tb WHEN OLD.ctx_id <> NEW.ctx_id BEGIN SELECT RAISE(ABORT, 'e01_305_01_tb.ctx_id is immutable'); END;
CREATE TRIGGER e03_328_26_tr BEFORE UPDATE OF ctx_id ON e01_305_02_tb WHEN OLD.ctx_id <> NEW.ctx_id BEGIN SELECT RAISE(ABORT, 'e01_305_02_tb.ctx_id is immutable'); END;
CREATE TRIGGER e03_328_27_tr BEFORE UPDATE OF ctx_id ON e01_305_03_tb WHEN OLD.ctx_id <> NEW.ctx_id BEGIN SELECT RAISE(ABORT, 'e01_305_03_tb.ctx_id is immutable'); END;
CREATE TRIGGER e03_328_28_tr BEFORE UPDATE OF clm_id ON e01_300_01_tb WHEN OLD.clm_id <> NEW.clm_id BEGIN SELECT RAISE(ABORT, 'e01_300_01_tb.clm_id is immutable'); END;
CREATE TRIGGER e03_328_29_tr BEFORE UPDATE OF vers_id ON e01_330_01_tb WHEN OLD.vers_id <> NEW.vers_id BEGIN SELECT RAISE(ABORT, 'e01_330_01_tb.vers_id is immutable'); END;
CREATE TRIGGER e03_328_30_tr BEFORE UPDATE OF snap_id ON e01_330_02_tb WHEN OLD.snap_id <> NEW.snap_id BEGIN SELECT RAISE(ABORT, 'e01_330_02_tb.snap_id is immutable'); END;
CREATE TRIGGER e03_328_31_tr BEFORE UPDATE OF source_type, source_ref ON e01_303_01_tb WHEN OLD.source_type = 'unknown' AND OLD.source_ref = 'system:unknown' AND (NEW.source_type <> 'unknown' OR NEW.source_ref <> 'system:unknown') BEGIN SELECT RAISE(ABORT, 'fallback provenance identity is immutable'); END;
CREATE TRIGGER e03_328_32_tr BEFORE DELETE ON e01_676_02_tb BEGIN SELECT RAISE(ABORT, 'schema state row cannot be deleted'); END;
CREATE TRIGGER e03_328_33_tr BEFORE UPDATE OF verb_code ON e01_506_09_tb WHEN OLD.verb_code <> NEW.verb_code BEGIN SELECT RAISE(ABORT, 'e01_506_09_tb.verb_code is immutable'); END;
CREATE TRIGGER e03_328_34_tr BEFORE UPDATE OF entity_code ON e01_506_10_tb WHEN OLD.entity_code <> NEW.entity_code BEGIN SELECT RAISE(ABORT, 'e01_506_10_tb.entity_code is immutable'); END;
CREATE TRIGGER e03_328_35_tr BEFORE UPDATE OF constraint_code ON e01_506_11_tb WHEN OLD.constraint_code <> NEW.constraint_code BEGIN SELECT RAISE(ABORT, 'e01_506_11_tb.constraint_code is immutable'); END;
CREATE TRIGGER e03_328_36_tr BEFORE UPDATE OF schema_ver ON e01_676_02_tb WHEN NEW.schema_ver < OLD.schema_ver BEGIN SELECT RAISE(ABORT, 'schema_ver cannot decrease'); END;
CREATE TRIGGER e03_328_37_tr BEFORE UPDATE OF param_uid ON e01_676_03_tb WHEN OLD.param_uid <> NEW.param_uid BEGIN SELECT RAISE(ABORT, 'e01_676_03_tb.param_uid is immutable'); END;
CREATE VIEW e04_200_01_vw AS SELECT 'entity_type' AS node_kind, type_id AS node_id, type_uid, label, description FROM e01_200_01_tb UNION ALL SELECT 'relation_type', reltype_id, type_uid, label, description FROM e01_202_01_tb UNION ALL SELECT 'enum_domain', dom_id, dom_uid, label, description FROM e01_200_02_tb;
CREATE VIEW e04_230_01_vw AS SELECT ent_id, ent_uid, type_id, label, description, status FROM e01_200_03_tb WHERE nature = 'concept';
CREATE VIEW e04_230_02_vw AS SELECT ent_id, ent_uid, type_id, label, description, status FROM e01_200_03_tb WHERE nature = 'instance';
CREATE VIEW e04_340_01_vw AS SELECT * FROM e01_222_01_tb WHERE superseded_at IS NULL;
CREATE VIEW e04_340_02_vw AS SELECT * FROM e01_222_01_tb WHERE superseded_at IS NULL AND status = 'asserted';
CREATE VIEW e04_340_04_vw AS SELECT r.lin_id, r.rel_uid, r.subj_ent_id, r.reltype_id, r.valid_from, r.valid_to, r.recorded_at, r.superseded_at, r.status, CASE WHEN r.superseded_at IS NULL THEN 1 ELSE 0 END AS is_current FROM e01_222_01_tb r;
CREATE VIEW e04_325_01_vw AS SELECT 'entity' AS tgt_kind, ctx_id AS qual_id, ent_id AS tgt_id, ctx_ent_id, ctx_val_id, role, valid_from, valid_to, prv_id FROM e01_305_01_tb UNION ALL SELECT 'value', ctx_id, val_id, ctx_ent_id, ctx_val_id, role, valid_from, valid_to, prv_id FROM e01_305_02_tb UNION ALL SELECT 'relation', ctx_id, rel_id, ctx_ent_id, ctx_val_id, role, valid_from, valid_to, prv_id FROM e01_305_03_tb;
CREATE VIEW e04_310_01_vw AS SELECT DISTINCT a.ent_a_id, a.ent_b_id FROM e01_300_01_tb a JOIN e01_300_01_tb b ON a.ent_a_id = b.ent_a_id AND a.ent_b_id = b.ent_b_id AND a.clm_type = 'same_as' AND b.clm_type = 'distinct_from' WHERE a.status = 'asserted' AND b.status = 'asserted';
CREATE VIEW e04_311_01_vw AS SELECT v.val_id, v.value_kind, 'absence_kind_with_payload' AS violation_kind FROM e01_201_02_tb v WHERE v.value_kind IN ('unknown','not_observed','not_recorded','not_applicable') AND (v.num_val IS NOT NULL OR v.text_val IS NOT NULL OR v.text_norm IS NOT NULL OR v.bool_val IS NOT NULL OR v.dt_start IS NOT NULL OR v.dt_end IS NOT NULL OR v.num_min IS NOT NULL OR v.num_max IS NOT NULL OR v.enum_id IS NOT NULL OR v.json_val IS NOT NULL);
CREATE VIEW e04_122_01_vw AS WITH RECURSIVE cl(sub_id, anc_id) AS (SELECT r.subj_ent_id, r.obj_ent_id FROM e01_222_01_tb r JOIN e01_202_01_tb rt ON rt.reltype_id = r.reltype_id WHERE rt.type_uid = 'is_a' AND r.superseded_at IS NULL AND r.status = 'asserted' UNION SELECT c.sub_id, r.obj_ent_id FROM cl c JOIN e01_222_01_tb r ON r.subj_ent_id = c.anc_id JOIN e01_202_01_tb rt ON rt.reltype_id = r.reltype_id WHERE rt.type_uid = 'is_a' AND r.superseded_at IS NULL AND r.status = 'asserted') SELECT * FROM cl;
CREATE VIEW e04_267_01_vw AS SELECT v.ent_id AS vehicle_entity_id, v.ent_uid, v.label AS vehicle_label, (SELECT vs.text_val FROM e01_222_01_tb r JOIN e01_202_01_tb rt ON rt.reltype_id = r.reltype_id JOIN e01_201_02_tb vs ON vs.val_id = r.obj_val_id WHERE r.subj_ent_id = v.ent_id AND rt.type_uid = 'has_vin' AND r.superseded_at IS NULL AND r.status = 'asserted' ORDER BY r.recorded_at DESC, r.rel_id DESC LIMIT 1) AS vin, (SELECT oe.label FROM e01_222_01_tb r JOIN e01_202_01_tb rt ON rt.reltype_id = r.reltype_id JOIN e01_200_03_tb oe ON oe.ent_id = r.obj_ent_id WHERE r.subj_ent_id = v.ent_id AND rt.type_uid = 'instance_of' AND r.superseded_at IS NULL AND r.status = 'asserted' ORDER BY r.recorded_at DESC, r.rel_id DESC LIMIT 1) AS model_label FROM e01_200_03_tb v JOIN e01_200_01_tb et ON et.type_id = v.type_id AND et.type_uid = 'Vehicle' WHERE v.nature = 'instance' AND v.status = 'active';
CREATE VIEW e04_267_02_vw AS SELECT r.obj_ent_id AS vehicle_entity_id, r.subj_ent_id AS unit_entity_id, et.type_uid AS unit_type_uid, CASE WHEN et.type_uid = 'ECU' THEN 1 ELSE 0 END AS is_ecu FROM e01_222_01_tb r JOIN e01_202_01_tb rt ON rt.reltype_id = r.reltype_id AND rt.type_uid = 'installed_on' JOIN e01_200_03_tb u ON u.ent_id = r.subj_ent_id JOIN e01_200_01_tb et ON et.type_id = u.type_id WHERE r.superseded_at IS NULL AND r.status = 'asserted';
CREATE VIEW e04_260_01_vw AS SELECT e.ent_id AS ecu_entity_id, e.ent_uid AS ecu_uid, e.label AS ecu_label, e.description AS ecu_description, e.status FROM e01_200_03_tb e JOIN e01_200_01_tb et ON et.type_id = e.type_id AND et.type_uid = 'ECU';
CREATE VIEW e04_260_02_vw AS SELECT c.ent_id AS case_entity_id FROM e01_200_03_tb c JOIN e01_200_01_tb et ON et.type_id = c.type_id WHERE et.type_uid = 'Case';
CREATE VIEW e04_260_03_vw AS SELECT t.ent_id AS tech_entity_id, t.label AS tech_label, 0 AS cases_count FROM e01_200_03_tb t JOIN e01_200_01_tb et_t ON et_t.type_id = t.type_id AND et_t.type_uid = 'Technician' WHERE t.status = 'active';
CREATE VIEW e04_110_01_vw AS WITH RECURSIVE expected(desc_id, anc_id, depth, path, cycle) AS (SELECT t.type_id, t.type_id, 0, ',' || CAST(t.type_id AS TEXT) || ',', 0 FROM e01_200_01_tb t UNION ALL SELECT e.desc_id, p.parent_id, e.depth + 1, e.path || CAST(p.parent_id AS TEXT) || ',', CASE WHEN instr(e.path, ',' || CAST(p.parent_id AS TEXT) || ',') > 0 THEN 1 ELSE 0 END FROM expected e JOIN e01_200_01_tb p ON p.type_id = e.anc_id WHERE e.cycle = 0 AND p.parent_id IS NOT NULL AND e.depth < 100), expected_rows AS (SELECT desc_id, anc_id, depth FROM expected WHERE cycle = 0), actual AS (SELECT desc_id, anc_id, depth, COUNT(*) AS n FROM e01_120_01_tb GROUP BY desc_id, anc_id, depth) SELECT 'missing_expected_row', e.desc_id FROM expected_rows e WHERE NOT EXISTS (SELECT 1 FROM actual a WHERE a.desc_id = e.desc_id AND a.anc_id = e.anc_id AND a.depth = e.depth) UNION ALL SELECT 'orphan_closure_row', cl.desc_id FROM e01_120_01_tb cl WHERE NOT EXISTS (SELECT 1 FROM e01_200_01_tb t WHERE t.type_id = cl.desc_id) OR NOT EXISTS (SELECT 1 FROM e01_200_01_tb t WHERE t.type_id = cl.anc_id) UNION ALL SELECT 'closure_cycle', cl.desc_id FROM e01_120_01_tb cl WHERE cl.desc_id = cl.anc_id AND cl.depth > 0;
CREATE VIEW e04_110_02_vw AS SELECT 'T' AS layer, 'parent_self' AS violation_kind, t.type_id AS object_id, t.type_uid AS detail FROM e01_200_01_tb t WHERE t.parent_id = t.type_id UNION ALL SELECT 'T', 'parent_orphan', t.type_id, CAST(t.parent_id AS TEXT) FROM e01_200_01_tb t WHERE t.parent_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM e01_200_01_tb p WHERE p.type_id = t.parent_id) UNION ALL SELECT 'T', 'inverse_orphan', r.reltype_id, r.inverse_uid FROM e01_202_01_tb r WHERE r.inverse_uid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM e01_202_01_tb x WHERE x.type_uid = r.inverse_uid);
CREATE VIEW e04_310_02_vw AS SELECT 'rel_subject' AS violation_kind, r.rel_id AS id, r.rel_uid AS uid FROM e01_222_01_tb r WHERE NOT EXISTS (SELECT 1 FROM e01_200_03_tb e WHERE e.ent_id = r.subj_ent_id) UNION ALL SELECT 'rel_object_ent', r.rel_id, r.rel_uid FROM e01_222_01_tb r WHERE r.obj_ent_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM e01_200_03_tb e WHERE e.ent_id = r.obj_ent_id) UNION ALL SELECT 'ent_type', e.ent_id, e.ent_uid FROM e01_200_03_tb e WHERE NOT EXISTS (SELECT 1 FROM e01_200_01_tb t WHERE t.type_id = e.type_id);
CREATE TRIGGER e03_778_13_tr BEFORE DELETE ON e01_778_05_tb
WHEN OLD.is_mandatory = 1
BEGIN
    SELECT CASE WHEN EXISTS (SELECT 1 FROM e01_778_02_tb m WHERE m.element_name = OLD.element_name AND m.need_uid = OLD.need_uid AND m.is_primary = 1 AND m.is_driving = 1)
        THEN RAISE(ABORT, 'policy: cannot delete mandatory policy of driving element') END;
END;
CREATE TRIGGER e03_778_10_tr BEFORE UPDATE OF policy_id ON e01_778_05_tb WHEN OLD.policy_id <> NEW.policy_id BEGIN SELECT RAISE(ABORT, 'policy_id immutable'); END;
CREATE TRIGGER e03_120_01_tr
BEFORE UPDATE OF parent_id ON e01_200_01_tb
WHEN NEW.parent_id IS NOT NULL AND NEW.parent_id <> NEW.type_id
BEGIN
    SELECT CASE WHEN EXISTS (
        SELECT 1 FROM e01_120_01_tb
        WHERE desc_id = NEW.parent_id AND anc_id = NEW.type_id
    ) THEN RAISE(ABORT, 'type hierarchy: cycle detected') END;
END;
CREATE TRIGGER e03_120_04_tr
BEFORE INSERT ON e01_200_03_tb
BEGIN
    SELECT CASE WHEN (SELECT type_id FROM e01_200_01_tb WHERE type_id=NEW.type_id) IS NULL
        THEN RAISE(ABORT, 'entity type does not exist') END;
    SELECT CASE WHEN NEW.nature = 'instance'
             AND (SELECT is_abstract FROM e01_200_01_tb WHERE type_id = NEW.type_id) = 1
        THEN RAISE(ABORT, 'cannot instantiate abstract type') END;
END;
CREATE TRIGGER e03_120_05_tr
BEFORE UPDATE OF type_id, nature ON e01_200_03_tb
BEGIN
    SELECT CASE WHEN (SELECT type_id FROM e01_200_01_tb WHERE type_id=NEW.type_id) IS NULL
        THEN RAISE(ABORT, 'entity type does not exist (upd)') END;
    SELECT CASE WHEN NEW.nature = 'instance'
             AND (SELECT is_abstract FROM e01_200_01_tb WHERE type_id = NEW.type_id) = 1
        THEN RAISE(ABORT, 'cannot reassign to abstract type') END;
END;
CREATE TRIGGER e03_122_01_tr
BEFORE INSERT ON e01_222_01_tb
WHEN NEW.reltype_id = (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='is_a')
 AND NEW.superseded_at IS NULL AND NEW.status = 'asserted'
BEGIN
    SELECT CASE WHEN NEW.subj_ent_id = NEW.obj_ent_id
        THEN RAISE(ABORT, 'is_a: self-reference not allowed') END;
    SELECT CASE WHEN EXISTS (
        WITH RECURSIVE anc(id, depth) AS (
            SELECT NEW.obj_ent_id, 0
            UNION ALL
            SELECT r.obj_ent_id, anc.depth + 1
            FROM e01_222_01_tb r
            JOIN e01_202_01_tb rt ON rt.reltype_id = r.reltype_id
            JOIN anc ON r.subj_ent_id = anc.id
            WHERE rt.type_uid = 'is_a'
              AND r.superseded_at IS NULL AND r.status = 'asserted'
              AND anc.depth < 50
        )
        SELECT 1 FROM anc WHERE id = NEW.subj_ent_id
    ) THEN RAISE(ABORT, 'is_a: cycle detected') END;
END;
CREATE TRIGGER e03_122_02_tr
BEFORE UPDATE OF subj_ent_id, obj_ent_id, reltype_id, status, superseded_at
ON e01_222_01_tb
WHEN NEW.reltype_id = (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='is_a')
 AND NEW.superseded_at IS NULL AND NEW.status = 'asserted'
BEGIN
    SELECT CASE WHEN NEW.subj_ent_id = NEW.obj_ent_id
        THEN RAISE(ABORT, 'is_a: self-reference (upd)') END;
    SELECT CASE WHEN EXISTS (
        WITH RECURSIVE anc(id, depth) AS (
            SELECT NEW.obj_ent_id, 0
            UNION ALL
            SELECT r.obj_ent_id, anc.depth + 1
            FROM e01_222_01_tb r
            JOIN e01_202_01_tb rt ON rt.reltype_id = r.reltype_id
            JOIN anc ON r.subj_ent_id = anc.id
            WHERE rt.type_uid = 'is_a'
              AND r.superseded_at IS NULL AND r.status = 'asserted'
              AND r.rel_id <> NEW.rel_id
              AND anc.depth < 50
        )
        SELECT 1 FROM anc WHERE id = NEW.subj_ent_id
    ) THEN RAISE(ABORT, 'is_a: cycle detected (upd)') END;
END;
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
CREATE TRIGGER e03_120_02_tr AFTER INSERT ON e01_200_01_tb
BEGIN
    INSERT INTO e01_120_01_tb (desc_id, anc_id, depth)
    VALUES (NEW.type_id, NEW.type_id, 0);
    INSERT INTO e01_120_01_tb (desc_id, anc_id, depth)
    SELECT NEW.type_id, anc_id, depth + 1
    FROM e01_120_01_tb
    WHERE desc_id = NEW.parent_id
      AND NEW.parent_id IS NOT NULL
      AND depth < (SELECT int_value FROM e01_676_03_tb WHERE param_uid='max_depth');
END;
CREATE TRIGGER e03_120_03_tr AFTER UPDATE OF parent_id ON e01_200_01_tb
WHEN OLD.parent_id IS NOT NEW.parent_id
BEGIN
    DELETE FROM e01_120_01_tb;
    INSERT INTO e01_120_01_tb (desc_id, anc_id, depth)
    WITH RECURSIVE walk(desc_id, anc_id, depth) AS (
        SELECT t.type_id, t.type_id, 0 FROM e01_200_01_tb t
        UNION
        SELECT w.desc_id, p.parent_id, w.depth + 1
        FROM walk w
        JOIN e01_200_01_tb p ON p.type_id = w.anc_id
        WHERE p.parent_id IS NOT NULL
          AND w.depth < (SELECT int_value FROM e01_676_03_tb WHERE param_uid='max_depth')
    )
    SELECT desc_id, anc_id, depth FROM walk;
END;
CREATE TRIGGER e03_434_01_tr AFTER INSERT ON e01_200_03_tb
BEGIN
    INSERT INTO e02_404_01_ft(rowid, label_norm, desc_norm)
    VALUES (NEW.ent_id, COALESCE(NEW.label_norm, lower(trim(NEW.label))), COALESCE(NEW.desc_norm, ''));
END;
CREATE TRIGGER e03_434_02_tr AFTER DELETE ON e01_200_03_tb
BEGIN
    INSERT INTO e02_404_01_ft(e02_404_01_ft, rowid, label_norm, desc_norm)
    VALUES ('delete', OLD.ent_id, COALESCE(OLD.label_norm, lower(trim(OLD.label))), COALESCE(OLD.desc_norm, ''));
END;
CREATE TRIGGER e03_434_03_tr AFTER UPDATE OF label_norm, desc_norm, label ON e01_200_03_tb
WHEN NEW.label_norm IS NOT OLD.label_norm
  OR NEW.desc_norm IS NOT OLD.desc_norm
  OR NEW.label IS NOT OLD.label
BEGIN
    INSERT INTO e02_404_01_ft(e02_404_01_ft, rowid, label_norm, desc_norm)
    VALUES ('delete', OLD.ent_id, COALESCE(OLD.label_norm, lower(trim(OLD.label))), COALESCE(OLD.desc_norm, ''));
    INSERT INTO e02_404_01_ft(rowid, label_norm, desc_norm)
    VALUES (NEW.ent_id, COALESCE(NEW.label_norm, lower(trim(NEW.label))), COALESCE(NEW.desc_norm, ''));
END;
CREATE TRIGGER e03_434_04_tr AFTER INSERT ON e01_200_03_tb
WHEN NEW.label_norm IS NULL
BEGIN
    UPDATE e01_200_03_tb SET label_norm = lower(trim(NEW.label))
    WHERE ent_id = NEW.ent_id;
END;
CREATE TRIGGER e03_434_05_tr AFTER UPDATE OF label ON e01_200_03_tb
WHEN NEW.label IS NOT OLD.label AND NEW.label_norm IS NULL
BEGIN
    UPDATE e01_200_03_tb SET label_norm = lower(trim(NEW.label))
    WHERE ent_id = NEW.ent_id;
END;
CREATE TRIGGER e03_778_10b_tr
BEFORE UPDATE OF element_name, policy_kind ON e01_778_05_tb
WHEN OLD.element_name <> NEW.element_name
  OR OLD.policy_kind <> NEW.policy_kind
BEGIN SELECT RAISE(ABORT, 'policy identity immutable'); END;
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
    (SELECT COUNT(*) FROM e01_506_01_tb) AS declared,
    (SELECT COUNT(DISTINCT need_uid) FROM e01_778_05_tb) AS realized,
    (SELECT COUNT(*) FROM e01_506_01_tb n WHERE NOT EXISTS (SELECT 1 FROM e01_778_05_tb p WHERE p.need_uid = n.need_uid)) AS missing,
    0 AS orphan, 'real_issue' AS severity_class
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
    (SELECT COUNT(*) FROM e01_506_03_tb WHERE element_kind IN ('tb','tr','vw','ft') AND element_name NOT LIKE 'POLICY:%'),
    (SELECT COUNT(*) FROM e01_506_03_tb e WHERE e.element_kind IN ('tb','tr','vw','ft') AND e.element_name NOT LIKE 'POLICY:%' AND EXISTS (SELECT 1 FROM sqlite_master sm WHERE sm.name = e.element_name)),
    (SELECT COUNT(*) FROM e01_506_03_tb e WHERE e.element_kind IN ('tb','tr','vw','ft') AND e.element_name NOT LIKE 'POLICY:%' AND NOT EXISTS (SELECT 1 FROM sqlite_master sm WHERE sm.name = e.element_name)),
    (SELECT COUNT(*) FROM sqlite_master sm WHERE sm.type IN ('table','trigger','view') AND sm.name LIKE 'e0%' AND sm.name NOT LIKE 'e02\_404\_01\_ft%' ESCAPE '\' AND NOT EXISTS (SELECT 1 FROM e01_506_03_tb e WHERE e.element_name = sm.name)),
    'real_issue'
  UNION ALL SELECT 'elements_to_matrix',
    (SELECT COUNT(*) FROM e01_506_03_tb WHERE element_kind IN ('tb','tr','vw','ft') AND element_name NOT LIKE 'POLICY:%'),
    (SELECT COUNT(*) FROM e01_506_03_tb e WHERE e.element_kind IN ('tb','tr','vw','ft') AND e.element_name NOT LIKE 'POLICY:%' AND EXISTS (SELECT 1 FROM e01_778_02_tb m WHERE m.element_name = e.element_name)),
    (SELECT COUNT(*) FROM e01_506_03_tb e WHERE e.element_kind IN ('tb','tr','vw','ft') AND e.element_name NOT LIKE 'POLICY:%' AND NOT EXISTS (SELECT 1 FROM e01_778_02_tb m WHERE m.element_name = e.element_name)),
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
CREATE TRIGGER e03_370_01_tr BEFORE INSERT ON e01_516_01_tb
BEGIN
    SELECT CASE WHEN NOT EXISTS (
        SELECT 1 FROM e01_506_01_tb WHERE need_uid = NEW.need_uid)
    THEN RAISE(ABORT, 'nee_atom: need does not exist') END;
    SELECT CASE WHEN NOT EXISTS (
        SELECT 1 FROM e01_506_02_tb WHERE atom_uid = NEW.atom_uid)
    THEN RAISE(ABORT, 'nee_atom: atom does not exist') END;
END;
CREATE TRIGGER e03_370_11_tr BEFORE UPDATE OF need_uid, atom_uid ON e01_516_01_tb
BEGIN
    SELECT CASE WHEN NOT EXISTS (
        SELECT 1 FROM e01_506_01_tb WHERE need_uid = NEW.need_uid)
    THEN RAISE(ABORT, 'nee_atom.upd: need does not exist') END;
    SELECT CASE WHEN NOT EXISTS (
        SELECT 1 FROM e01_506_02_tb WHERE atom_uid = NEW.atom_uid)
    THEN RAISE(ABORT, 'nee_atom.upd: atom does not exist') END;
END;
CREATE TRIGGER e03_370_33_tr 
BEFORE UPDATE OF element_name, need_uid, role ON e01_778_02_tb
WHEN OLD.element_name <> NEW.element_name 
  OR OLD.need_uid <> NEW.need_uid
  OR OLD.role <> NEW.role
BEGIN SELECT RAISE(ABORT, 'e01_778_02_tb PK is immutable'); END;
CREATE TRIGGER e03_370_14_tr
BEFORE UPDATE OF dim_uid ON e01_506_08_tb
BEGIN
    SELECT CASE WHEN NOT EXISTS (
        SELECT 1 FROM e01_506_07_tb WHERE dim_uid = NEW.dim_uid)
    THEN RAISE(ABORT, 'dim_val.upd: dim does not exist') END;
END;
CREATE TRIGGER e03_328_03_tr
BEFORE UPDATE OF need_uid, atom_uid, kind ON e01_516_01_tb
WHEN OLD.need_uid <> NEW.need_uid 
  OR OLD.atom_uid <> NEW.atom_uid
  OR OLD.kind <> NEW.kind
BEGIN SELECT RAISE(ABORT, 'e01_516_01_tb PK is immutable'); END;
CREATE TRIGGER e03_778_14_tr
BEFORE DELETE ON e01_778_02_tb
BEGIN
    SELECT CASE WHEN EXISTS (
        SELECT 1 FROM e01_778_05_tb p
        WHERE p.element_name = OLD.element_name
          AND p.need_uid = OLD.need_uid
          AND p.is_mandatory = 1)
    THEN RAISE(ABORT, 'matrix: cannot delete row with mandatory policies') END;
END;
CREATE TRIGGER e03_778_02_ins_tr
BEFORE INSERT ON e01_778_02_tb
BEGIN
    SELECT CASE WHEN NOT EXISTS (
        SELECT 1 FROM e01_506_03_tb WHERE element_name = NEW.element_name)
    THEN RAISE(ABORT, 'matrix: element not registered') END;
    SELECT CASE WHEN NOT EXISTS (
        SELECT 1 FROM e01_506_01_tb WHERE need_uid = NEW.need_uid)
    THEN RAISE(ABORT, 'matrix: need does not exist') END;
END;
PRAGMA writable_schema=OFF;
COMMIT;
