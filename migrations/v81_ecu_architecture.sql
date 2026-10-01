-- v81 — بازسازی معماری ECU بر اساس AUTOSAR
.mode column
.headers on

BEGIN;

-- ═══════════════════════════════════════════════════════
-- ۱. انواع جدید
-- ═══════════════════════════════════════════════════════
INSERT OR IGNORE INTO e01_200_01_tb (type_uid, label, is_abstract) VALUES
('VehicleDomain',    'دامنه خودرو',         1),
('DomainController','مدیر دامنه (DCU)',    1),
('EEArchitecture',  'معماری برق و الکترونیک',1);

-- ═══════════════════════════════════════════════════════
-- ۲. پنج دامنه اصلی + معماری E/E
-- ═══════════════════════════════════════════════════════
INSERT OR IGNORE INTO e01_200_03_tb (ent_uid, type_id, nature, label, description, prv_id) VALUES
('concept:powertrain-domain',    (SELECT type_id FROM e01_200_01_tb WHERE type_uid='VehicleDomain'),'concept','دامنه پیشرانه','Powertrain Domain',2),
('concept:chassis-domain',       (SELECT type_id FROM e01_200_01_tb WHERE type_uid='VehicleDomain'),'concept','دامنه شاسی','Chassis Domain',2),
('concept:body-domain',          (SELECT type_id FROM e01_200_01_tb WHERE type_uid='VehicleDomain'),'concept','دامنه بدنه','Body Domain',2),
('concept:adas-domain',          (SELECT type_id FROM e01_200_01_tb WHERE type_uid='VehicleDomain'),'concept','دامنه ADAS','ADAS Domain',2),
('concept:infotainment-domain',  (SELECT type_id FROM e01_200_01_tb WHERE type_uid='VehicleDomain'),'concept','دامنه سرگرمی','Infotainment Domain',2),
('concept:ee-architecture',      (SELECT type_id FROM e01_200_01_tb WHERE type_uid='EEArchitecture'),'concept','معماری E/E','EE Architecture',2),
-- DCU ها
('concept:engine-ecu-dcu',       (SELECT type_id FROM e01_200_01_tb WHERE type_uid='DomainController'),'concept','DCU موتور','Engine DCU',2),
('concept:chassis-ecu-dcu',      (SELECT type_id FROM e01_200_01_tb WHERE type_uid='DomainController'),'concept','DCU شاسی','Chassis DCU',2),
('concept:body-ecu-dcu',         (SELECT type_id FROM e01_200_01_tb WHERE type_uid='DomainController'),'concept','DCU بدنه','Body DCU',2),
('concept:adas-ecu-dcu',         (SELECT type_id FROM e01_200_01_tb WHERE type_uid='DomainController'),'concept','DCU ADAS','ADAS DCU',2),
('concept:infotainment-ecu-dcu', (SELECT type_id FROM e01_200_01_tb WHERE type_uid='DomainController'),'concept','DCU سرگرمی','Infotainment DCU',2),
('concept:gateway-ecu',          (SELECT type_id FROM e01_200_01_tb WHERE type_uid='DomainController'),'concept','Gateway مرکزی','Central Gateway',2);

-- ═══════════════════════════════════════════════════════
-- ۳. بازنشستگی روابط قدیمی سیستم
-- ═══════════════════════════════════════════════════════
-- بازنشستگی: vehicle → system (پنج سیستم قبلی)
UPDATE e01_222_01_tb 
SET status = 'retracted', superseded_at = datetime('now')
WHERE reltype_id = (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='has_part')
  AND subj_ent_id = (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='concept:vehicle')
  AND status = 'asserted'
  AND superseded_at IS NULL;

-- ═══════════════════════════════════════════════════════
-- ۴. vehicle → domain (پنج دامنه + ee-architecture)
-- ═══════════════════════════════════════════════════════
INSERT OR IGNORE INTO e01_222_01_tb (rel_uid, reltype_id, subj_ent_id, obj_ent_id, status, prv_id)
SELECT
  'r:vehicle-has-' || REPLACE(d.uid, 'concept:', ''),
  (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='has_part'),
  (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='concept:vehicle'),
  (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid=d.uid),
  'asserted', 2
FROM (
  SELECT 'concept:powertrain-domain' AS uid UNION ALL
  SELECT 'concept:chassis-domain' UNION ALL
  SELECT 'concept:body-domain' UNION ALL
  SELECT 'concept:adas-domain' UNION ALL
  SELECT 'concept:infotainment-domain' UNION ALL
  SELECT 'concept:ee-architecture'
) d
WHERE NOT EXISTS (SELECT 1 FROM e01_222_01_tb r WHERE r.rel_uid = 'r:vehicle-has-' || REPLACE(d.uid, 'concept:', ''));

-- ═══════════════════════════════════════════════════════
-- ۵. domain → subsystem
-- ═══════════════════════════════════════════════════════
INSERT OR IGNORE INTO e01_222_01_tb (rel_uid, reltype_id, subj_ent_id, obj_ent_id, status, prv_id)
SELECT
  'r:' || REPLACE(m.dom, 'concept:', '') || '-has-' || REPLACE(m.sub, 'concept:', ''),
  (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='has_part'),
  (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid=m.dom),
  (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid=m.sub),
  'asserted', 2
FROM (
  -- Powertrain
  SELECT 'concept:powertrain-domain' AS dom, 'concept:ignition-subsystem' AS sub UNION ALL
  SELECT 'concept:powertrain-domain', 'concept:fuel-subsystem' UNION ALL
  SELECT 'concept:powertrain-domain', 'concept:cooling-subsystem' UNION ALL
  SELECT 'concept:powertrain-domain', 'concept:exhaust-subsystem' UNION ALL
  SELECT 'concept:powertrain-domain', 'concept:transmission-subsystem' UNION ALL
  SELECT 'concept:powertrain-domain', 'concept:special-cargo-subsystem' UNION ALL
  -- Chassis
  SELECT 'concept:chassis-domain', 'concept:braking-subsystem' UNION ALL
  SELECT 'concept:chassis-domain', 'concept:steering-subsystem' UNION ALL
  SELECT 'concept:chassis-domain', 'concept:suspension-subsystem' UNION ALL
  SELECT 'concept:chassis-domain', 'concept:wheel-subsystem' UNION ALL
  SELECT 'concept:chassis-domain', 'concept:abs-subsystem' UNION ALL
  -- Body
  SELECT 'concept:body-domain', 'concept:lighting-subsystem' UNION ALL
  SELECT 'concept:body-domain', 'concept:comfort-subsystem' UNION ALL
  SELECT 'concept:body-domain', 'concept:hvac-subsystem' UNION ALL
  SELECT 'concept:body-domain', 'concept:airbag-subsystem' UNION ALL
  SELECT 'concept:body-domain', 'concept:dashboard-subsystem' UNION ALL
  SELECT 'concept:body-domain', 'concept:emergency-subsystem' UNION ALL
  -- ADAS
  SELECT 'concept:adas-domain', 'concept:adas-subsystem' UNION ALL
  -- Infotainment
  SELECT 'concept:infotainment-domain', 'concept:audio-subsystem' UNION ALL
  -- EE Architecture
  SELECT 'concept:ee-architecture', 'concept:power-supply-subsystem' UNION ALL
  SELECT 'concept:ee-architecture', 'concept:starting-subsystem' UNION ALL
  SELECT 'concept:ee-architecture', 'concept:bus-subsystem' UNION ALL
  SELECT 'concept:ee-architecture', 'concept:sensor-subsystem' UNION ALL
  SELECT 'concept:ee-architecture', 'concept:ev-subsystem'
) m
WHERE EXISTS (SELECT 1 FROM e01_200_03_tb WHERE ent_uid=m.dom)
  AND EXISTS (SELECT 1 FROM e01_200_03_tb WHERE ent_uid=m.sub)
  AND NOT EXISTS (SELECT 1 FROM e01_222_01_tb r WHERE r.rel_uid = 'r:' || REPLACE(m.dom, 'concept:', '') || '-has-' || REPLACE(m.sub, 'concept:', ''));

-- ═══════════════════════════════════════════════════════
-- ۶. domain → DCU (مدیر دامنه)
-- ═══════════════════════════════════════════════════════
INSERT OR IGNORE INTO e01_222_01_tb (rel_uid, reltype_id, subj_ent_id, obj_ent_id, status, prv_id)
VALUES
('r:powertrain-domain-has-engine-dcu',
 (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='has_part'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='concept:powertrain-domain'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='concept:engine-ecu-dcu'),'asserted',2),
('r:chassis-domain-has-chassis-dcu',
 (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='has_part'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='concept:chassis-domain'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='concept:chassis-ecu-dcu'),'asserted',2),
('r:body-domain-has-body-dcu',
 (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='has_part'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='concept:body-domain'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='concept:body-ecu-dcu'),'asserted',2),
('r:adas-domain-has-adas-dcu',
 (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='has_part'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='concept:adas-domain'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='concept:adas-ecu-dcu'),'asserted',2),
('r:infotainment-domain-has-infotainment-dcu',
 (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='has_part'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='concept:infotainment-domain'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='concept:infotainment-ecu-dcu'),'asserted',2),
('r:ee-architecture-has-gateway',
 (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='has_part'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='concept:ee-architecture'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='concept:gateway-ecu'),'asserted',2);

-- ═══════════════════════════════════════════════════════
-- ۷. DCU → ECUهای زیرمجموعه
-- ═══════════════════════════════════════════════════════
INSERT OR IGNORE INTO e01_222_01_tb (rel_uid, reltype_id, subj_ent_id, obj_ent_id, status, prv_id)
VALUES
-- موتور → transmission-ecu (زیرمجموعه پیشرانه)
('r:engine-dcu-has-transmission-ecu',
 (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='has_part'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='concept:engine-ecu-dcu'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='concept:transmission-ecu'),'asserted',2),
-- شاسی → abs-ecu
('r:chassis-dcu-has-abs-ecu',
 (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='has_part'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='concept:chassis-ecu-dcu'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='concept:abs-ecu'),'asserted',2),
-- بدنه → body-ecu (خودش)
-- (قبلاً در v68 body-ecu ساخته شد)

-- ═══════════════════════════════════════════════════════
-- ۸. Gateway ↔ bus-subsystem
-- ═══════════════════════════════════════════════════════
INSERT OR IGNORE INTO e01_222_01_tb (rel_uid, reltype_id, subj_ent_id, obj_ent_id, status, prv_id)
VALUES
('r:gateway-connects-bus',
 (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='communicates_over'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='concept:gateway-ecu'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='concept:can-bus'),
 'asserted', 2);

-- ═══════════════════════════════════════════════════════
-- ۹. لاگ
-- ═══════════════════════════════════════════════════════
INSERT OR IGNORE INTO e01_676_01_tb (migration_uid, notes)
VALUES ('v81_ecu_architecture','Reorganized into AUTOSAR domains: 5 domains + EE architecture + 6 DCUs');

UPDATE e01_676_02_tb SET schema_ver = schema_ver + 1 WHERE id = 1;

COMMIT;

-- ═══════════════════════════════════════════════════════
-- گزارش
-- ═══════════════════════════════════════════════════════
SELECT 'entities' AS k, COUNT(*) AS n FROM e01_200_03_tb
UNION ALL SELECT 'relations', COUNT(*) FROM e01_222_01_tb;

SELECT '=== ساختار جدید: domain → subsystem ===' AS section;
SELECT 
  dom.label AS domain,
  sub.label AS subsystem
FROM e01_222_01_tb r
JOIN e01_202_01_tb rt ON rt.reltype_id = r.reltype_id AND rt.type_uid='has_part'
JOIN e01_200_03_tb dom ON dom.ent_id = r.subj_ent_id
JOIN e01_200_03_tb sub ON sub.ent_id = r.obj_ent_id
WHERE dom.ent_uid LIKE 'concept:%-domain' OR dom.ent_uid='concept:ee-architecture'
  AND r.status='asserted' AND r.superseded_at IS NULL
ORDER BY dom.label, sub.label;
