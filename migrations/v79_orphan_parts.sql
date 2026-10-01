-- v79 — اتصال ۲۱ قطعه‌ی یتیم به زیرسیستم‌هایشان
.mode column
.headers on

BEGIN;

-- ═══════════════════════════════════════════════════════
-- ۱. قطعات EV → ev-subsystem
-- ═══════════════════════════════════════════════════════
INSERT OR IGNORE INTO e01_222_01_tb (rel_uid, reltype_id, subj_ent_id, obj_ent_id, status, prv_id)
SELECT
  'r:ev-subsystem-has-' || REPLACE(p.part, 'concept:', ''),
  (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='has_part'),
  (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='concept:ev-subsystem'),
  (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid=p.part),
  'asserted', 2
FROM (
  SELECT 'concept:traction-motor' AS part UNION ALL
  SELECT 'concept:inverter' UNION ALL
  SELECT 'concept:battery-pack' UNION ALL
  SELECT 'concept:onboard-charger' UNION ALL
  SELECT 'concept:charging-port' UNION ALL
  SELECT 'concept:bms' UNION ALL
  SELECT 'concept:dcdc' UNION ALL
  SELECT 'concept:regen-brake' UNION ALL
  SELECT 'concept:thermal-mgmt' UNION ALL
  SELECT 'concept:hv-cable'
) p
WHERE EXISTS (SELECT 1 FROM e01_200_03_tb WHERE ent_uid=p.part)
  AND NOT EXISTS (SELECT 1 FROM e01_222_01_tb r WHERE r.rel_uid = 'r:ev-subsystem-has-' || REPLACE(p.part, 'concept:', ''));

-- ═══════════════════════════════════════════════════════
-- ۲. battery-cell و battery-module → زیر battery-pack (composed_of)
-- ═══════════════════════════════════════════════════════
INSERT OR IGNORE INTO e01_222_01_tb (rel_uid, reltype_id, subj_ent_id, obj_ent_id, status, prv_id)
VALUES
('r:battery-pack-composed-of-module',
 (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='composed_of'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='concept:battery-pack'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='concept:battery-module'),
 'asserted', 2),
('r:battery-module-composed-of-cell',
 (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='composed_of'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='concept:battery-module'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='concept:battery-cell'),
 'asserted', 2);

-- ═══════════════════════════════════════════════════════
-- ۳. قطعات خودروهای ویژه
-- ═══════════════════════════════════════════════════════

-- زیرسیستم جدید: هشدار و امداد
INSERT OR IGNORE INTO e01_200_03_tb (ent_uid, type_id, nature, label, description, prv_id) VALUES
('concept:emergency-subsystem',
 (SELECT type_id FROM e01_200_01_tb WHERE type_uid='VehicleSubsystem'),
 'concept','هشدار و امداد','Emergency / Warning',2);

-- اتصال به safety-system
INSERT OR IGNORE INTO e01_222_01_tb (rel_uid, reltype_id, subj_ent_id, obj_ent_id, status, prv_id)
VALUES
('r:safety-system-has-emergency',
 (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='has_part'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='concept:safety-system'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='concept:emergency-subsystem'),
 'asserted', 2);

-- قطعات هشدار و امداد
INSERT OR IGNORE INTO e01_222_01_tb (rel_uid, reltype_id, subj_ent_id, obj_ent_id, status, prv_id)
SELECT
  'r:emergency-subsystem-has-' || REPLACE(p.part, 'concept:', ''),
  (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='has_part'),
  (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='concept:emergency-subsystem'),
  (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid=p.part),
  'asserted', 2
FROM (
  SELECT 'concept:siren' AS part UNION ALL
  SELECT 'concept:warning-light' UNION ALL
  SELECT 'concept:wheelchair-ramp' UNION ALL
  SELECT 'concept:fire-pump' UNION ALL
  SELECT 'concept:ladder' UNION ALL
  SELECT 'concept:hydraulic-lift'
) p
WHERE EXISTS (SELECT 1 FROM e01_200_03_tb WHERE ent_uid=p.part)
  AND NOT EXISTS (SELECT 1 FROM e01_222_01_tb r WHERE r.rel_uid = 'r:emergency-subsystem-has-' || REPLACE(p.part, 'concept:', ''));

-- reefer و tank → زیرسیستم انتقال قدرت مخصوص کامیون
INSERT OR IGNORE INTO e01_200_03_tb (ent_uid, type_id, nature, label, description, prv_id) VALUES
('concept:special-cargo-subsystem',
 (SELECT type_id FROM e01_200_01_tb WHERE type_uid='VehicleSubsystem'),
 'concept','حمل ویژه','Special Cargo',2);

-- اتصال به powertrain
INSERT OR IGNORE INTO e01_222_01_tb (rel_uid, reltype_id, subj_ent_id, obj_ent_id, status, prv_id)
VALUES
('r:powertrain-system-has-special-cargo',
 (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='has_part'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='concept:powertrain-system'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='concept:special-cargo-subsystem'),
 'asserted', 2);

INSERT OR IGNORE INTO e01_222_01_tb (rel_uid, reltype_id, subj_ent_id, obj_ent_id, status, prv_id)
SELECT
  'r:special-cargo-subsystem-has-' || REPLACE(p.part, 'concept:', ''),
  (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='has_part'),
  (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='concept:special-cargo-subsystem'),
  (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid=p.part),
  'asserted', 2
FROM (
  SELECT 'concept:reefer' AS part UNION ALL
  SELECT 'concept:tank'
) p
WHERE EXISTS (SELECT 1 FROM e01_200_03_tb WHERE ent_uid=p.part)
  AND NOT EXISTS (SELECT 1 FROM e01_222_01_tb r WHERE r.rel_uid = 'r:special-cargo-subsystem-has-' || REPLACE(p.part, 'concept:', ''));

-- ═══════════════════════════════════════════════════════
-- ۴. turbocharger → زیرسیستم پیشرانه
-- ═══════════════════════════════════════════════════════
INSERT OR IGNORE INTO e01_222_01_tb (rel_uid, reltype_id, subj_ent_id, obj_ent_id, status, prv_id)
VALUES
('r:powertrain-system-has-turbo',
 (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='has_part'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='concept:powertrain-system'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='concept:turbocharger'),
 'asserted', 2);

-- ═══════════════════════════════════════════════════════
-- ۵. لاگ
-- ═══════════════════════════════════════════════════════
INSERT OR IGNORE INTO e01_676_01_tb (migration_uid, notes)
VALUES ('v79_orphan_parts','Attached 21 orphan parts to subsystems + created emergency-subsystem + special-cargo-subsystem');

UPDATE e01_676_02_tb SET schema_ver = schema_ver + 1 WHERE id = 1;

COMMIT;

-- ═══════════════════════════════════════════════════════
-- گزارش
-- ═══════════════════════════════════════════════════════
SELECT 'entities' AS k, COUNT(*) AS n FROM e01_200_03_tb
UNION ALL SELECT 'relations', COUNT(*) FROM e01_222_01_tb
UNION ALL SELECT 'subsystems', COUNT(*) FROM e01_200_03_tb WHERE ent_uid LIKE 'concept:%-subsystem';

SELECT '=== شمارش زیرسیستم‌ها ===' AS section;
SELECT 
  subj.ent_uid AS subsystem,
  COUNT(*) AS n_parts
FROM e01_222_01_tb r
JOIN e01_202_01_tb rt ON rt.reltype_id = r.reltype_id AND rt.type_uid='has_part'
JOIN e01_200_03_tb subj ON subj.ent_id = r.subj_ent_id
WHERE subj.ent_uid LIKE 'concept:%-subsystem'
  AND r.status='asserted' AND r.superseded_at IS NULL
GROUP BY subj.ent_uid
ORDER BY n_parts DESC;
