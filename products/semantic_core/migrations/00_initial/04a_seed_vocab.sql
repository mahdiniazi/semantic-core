-- ============ Provenance fallback ============
INSERT OR IGNORE INTO e01_303_01_tb (source_type, source_ref, method, notes)
VALUES ('unknown', 'system:unknown', 'explicit-fallback', 'Fallback provenance');

-- ============ Runtime params ============
INSERT OR IGNORE INTO e01_676_03_tb (param_uid, int_value, description) VALUES
('max_depth', 100, 'max type closure depth'),
('max_isa_depth', 50, 'max isa cycle depth'),
('max_member_depth', 100, 'max value member depth'),
('max_version_depth', 100, 'max supersedes depth'),
('min_coverage_pct', 70, 'min health percent');

-- ============ Vocab: verbs ============
INSERT OR IGNORE INTO e01_506_09_tb (verb_code, label, sort_order) VALUES
('0','PRS',10),('1','VAL',20),('2','PRV',30),('3','SYN',40),
('4','TRC',50),('5','PERF',60),('6','EXT',70),('7','META',80);

-- ============ Vocab: entities ============
INSERT OR IGNORE INTO e01_506_10_tb (entity_code, label, sort_order) VALUES
('ENT','Entity',10),('VAL','Value',20),('REL','Relation',30),
('PRV','Provenance',40),('FTS','FTS',50),('CTX','Context',60),
('NOD','Node',70),('VEH','Vehicle',80),('REF','Reference',90),
('DTC','DTC',100),('SUB','Subject',110),('VW','View',120),
('LOGIC','Logic',130),('SEED','Seed',140),('FK','Foreign Key',150),
('TRG','Trigger',160),('COL','Column',170),('NULL','Null',180),
('TYP','Type',190),('ISA','Is-a',200),('CYC-TYP','CycleType',210),
('CYC-ISA','CycleIsA',220);

-- ============ Vocab: constraints ============
INSERT OR IGNORE INTO e01_506_11_tb (constraint_code, label, sort_order) VALUES
('NONEMPTY','Non-empty',10),('TYPED','Typed',20),('XOR','Xor',30),
('TYPE','Valid type',40),('KIND','Valid kind',50),('NOCYC','No cycle',60),
('CONSIST','Consistent',70),('NOTNULL','Not null',80),('FAST','Fast',90),
('DET','Deterministic',100),('TREE','Tree',110),('PAREN','Explicit parens',120),
('ONCE','Once',130),('NOFK','No FK',140),('GUARD','Guard',150),
('DOC','Documented',160),('VER','Versioned',170),('LINK','Linked',180),
('FKFIRST','FK first',190),('NOCASC','No cascade',200),('CHECK','Has check',210);

-- ============ Entity types (48) ============
INSERT OR IGNORE INTO e01_200_01_tb (type_uid, label, is_abstract) VALUES
('Vehicle','Vehicle',0),('VehicleModel','VehicleModel',0),('Make','Make',0),
('Unit','Unit',0),('ECU','ECU',0),('Sensor','Sensor',0),
('Actuator','Actuator',0),('Connector','Connector',0),('Pin','Pin',0),
('Signal','Signal',0),('Bus','Bus',0),('Frame','Frame',0),
('DTC','DTC',0),('Observation','Observation',0),('Measurement','Measurement',0),
('Claim','Claim',0),('Evidence','Evidence',0),('Hypothesis','Hypothesis',0),
('Diagnosis','Diagnosis',0),('Repair','Repair',0),('Knowledge','Knowledge',0),
('FunctionalChain','FunctionalChain',0),('Configuration','Configuration',0),
('OperatingState','OperatingState',0),('Customer','Customer',0),
('Technician','Technician',0),('Case','Case',0),
('ReifiedRelation','ReifiedRelation',0),('StateSnapshot','StateSnapshot',0),
('CrankshaftSensor','CrankshaftSensor',0),
('CamshaftSensor','CamshaftSensor',0),
('MapSensor','MapSensor',0),('CoolantTempSensor','CoolantTempSensor',0),
('O2Sensor','O2Sensor',0),('IgnitionCoil','IgnitionCoil',0),
('Injector','Injector',0),('ThrottleBody','ThrottleBody',0),
('FuelPump','FuelPump',0),('Battery','Battery',0),('Relay','Relay',0),
('Fuse','Fuse',0),('Wiring','Wiring',0),('CrankSignal','CrankSignal',0),
('FuelPressure','FuelPressure',0),('FunctionalRole','FunctionalRole',1),
('FailureMode','FailureMode',0),('Test','Test',0),('Procedure','Procedure',0);

-- ============ Parent updates ============
UPDATE e01_200_01_tb SET parent_id = (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Unit') WHERE type_uid IN ('Sensor','Actuator','Battery','Relay','Fuse','Wiring','ECU');
UPDATE e01_200_01_tb SET parent_id = (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Connector') WHERE type_uid = 'Pin';
UPDATE e01_200_01_tb SET parent_id = (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Bus') WHERE type_uid = 'Frame';
UPDATE e01_200_01_tb SET parent_id = (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Observation') WHERE type_uid = 'Measurement';
UPDATE e01_200_01_tb SET parent_id = (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Sensor') WHERE type_uid IN ('CrankshaftSensor','CamshaftSensor','MapSensor','CoolantTempSensor','O2Sensor');
UPDATE e01_200_01_tb SET parent_id = (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Actuator') WHERE type_uid IN ('IgnitionCoil','Injector','ThrottleBody','FuelPump');
UPDATE e01_200_01_tb SET parent_id = (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Signal') WHERE type_uid IN ('CrankSignal','FuelPressure');
UPDATE e01_200_01_tb SET parent_id = (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Knowledge') WHERE type_uid IN ('FailureMode','Test','Procedure');
