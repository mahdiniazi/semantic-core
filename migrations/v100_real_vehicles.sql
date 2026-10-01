-- v100 — ۱۰ خودروی واقعی با VIN (فضای فعلیت)
.mode column
.headers on

BEGIN;

-- ═══════════════════════════════════════════════════════
-- ۱. ساخت ۱۰ نمونه
-- ═══════════════════════════════════════════════════════
INSERT OR IGNORE INTO e01_200_03_tb (ent_uid, type_id, nature, label, description, prv_id)
SELECT p.uid,
       (SELECT type_id FROM e01_200_01_tb WHERE type_uid = p.type_uid),
       'instance',
       p.label,
       p.descr,
       2
FROM (
  SELECT 'vehicle:pride-24IR12345' AS uid, 'Pride' AS type_uid, 'پراید ۱۴۰۳' AS label, 'VIN IR12345 — کاربر احمدی' AS descr UNION ALL
  SELECT 'vehicle:206-22IR54321', 'Peugeot206', 'پژو ۲۰۶ ۱۴۰۱', 'VIN IR54321' UNION ALL
  SELECT 'vehicle:samand-21IR98765', 'Samand', 'سمند ۱۴۰۰', 'VIN IR98765' UNION ALL
  SELECT 'vehicle:dena-23IR11111', 'Dena', 'دنا ۱۴۰۲', 'VIN IR11111' UNION ALL
  SELECT 'vehicle:shahin-24IR22222', 'Shahin', 'شاهین ۱۴۰۳', 'VIN IR22222' UNION ALL
  SELECT 'vehicle:corolla-23JP33333', 'ToyotaCorolla', 'کرولا ۲۰۲۳', 'VIN JP33333 — هیبرید' UNION ALL
  SELECT 'vehicle:tesla-m3-24US44444', 'TeslaModel3', 'تسلا مدل ۳ ۲۰۲۴', 'VIN US44444 — برقی' UNION ALL
  SELECT 'vehicle:tucson-22KR55555', 'HyundaiTucson', 'توسان ۲۰۲۲', 'VIN KR55555' UNION ALL
  SELECT 'vehicle:bmw-x5-23DE66666', 'BMWX5', 'BMW X5 ۲۰۲۳', 'VIN DE66666' UNION ALL
  SELECT 'vehicle:hilux-22JP77777', 'ToyotaHilux', 'هایلوکس ۲۰۲۲', 'VIN JP77777 — وانت' UNION ALL
  SELECT 'vehicle:pride-24IR99999', 'Pride', 'پراید ۱۴۰۳ (بدون کولر)', 'VIN IR99999' 
) p;

-- ═══════════════════════════════════════════════════════
-- ۲. instance_of به مفهوم
-- ═══════════════════════════════════════════════════════
INSERT OR IGNORE INTO e01_222_01_tb (rel_uid, reltype_id, subj_ent_id, obj_ent_id, status, prv_id)
SELECT
  'r:' || REPLACE(p.uid, ':', '-') || '-instance-of',
  (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='instance_of'),
  (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid=p.uid),
  (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid=p.concept),
  'asserted', 2
FROM (
  SELECT 'vehicle:pride-24IR12345' AS uid, 'concept:pride' AS concept UNION ALL
  SELECT 'vehicle:206-22IR54321', 'concept:206' UNION ALL
  SELECT 'vehicle:samand-21IR98765', 'concept:samand' UNION ALL
  SELECT 'vehicle:dena-23IR11111', 'concept:dena' UNION ALL
  SELECT 'vehicle:shahin-24IR22222', 'concept:shahin' UNION ALL
  SELECT 'vehicle:corolla-23JP33333', 'concept:toyota-corolla' UNION ALL
  SELECT 'vehicle:tesla-m3-24US44444', 'concept:tesla-model-3' UNION ALL
  SELECT 'vehicle:tucson-22KR55555', 'concept:hyundai-tucson' UNION ALL
  SELECT 'vehicle:bmw-x5-23DE66666', 'concept:bmw-x5' UNION ALL
  SELECT 'vehicle:hilux-22JP77777', 'concept:toyota-hilux' UNION ALL
  SELECT 'vehicle:pride-24IR99999', 'concept:pride'
) p
WHERE EXISTS (SELECT 1 FROM e01_200_03_tb WHERE ent_uid=p.uid)
  AND EXISTS (SELECT 1 FROM e01_200_03_tb WHERE ent_uid=p.concept)
  AND NOT EXISTS (
    SELECT 1 FROM e01_222_01_tb r
    WHERE r.rel_uid = 'r:' || REPLACE(p.uid, ':', '-') || '-instance-of'
  );

-- ═══════════════════════════════════════════════════════
-- ۳. انتخاب‌های طراحی در سطح instance
-- ═══════════════════════════════════════════════════════
INSERT OR IGNORE INTO e01_222_01_tb (rel_uid, reltype_id, subj_ent_id, obj_ent_id, status, prv_id)
SELECT
  'r:' || REPLACE(p.vehicle, ':', '-') || '-opt-' || REPLACE(p.part, ':', '-'),
  (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='has_direct_part'),
  (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid=p.vehicle),
  (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid=p.part),
  'asserted', 2
FROM (
  -- پراید اولی: کولر دارد
  SELECT 'vehicle:pride-24IR12345' AS vehicle, 'concept:ac-compressor' AS part UNION ALL
  SELECT 'vehicle:pride-24IR12345', 'concept:abs-subsystem' UNION ALL
  -- ۲۰۶: کولر + ABS
  SELECT 'vehicle:206-22IR54321', 'concept:ac-compressor' UNION ALL
  SELECT 'vehicle:206-22IR54321', 'concept:abs-subsystem' UNION ALL
  -- سمند: کولر
  SELECT 'vehicle:samand-21IR98765', 'concept:ac-compressor' UNION ALL
  -- دنا: کولر + ایربگ
  SELECT 'vehicle:dena-23IR11111', 'concept:ac-compressor' UNION ALL
  SELECT 'vehicle:dena-23IR11111', 'concept:airbag-subsystem' UNION ALL
  -- شاهین: کولر + ایربگ + ABS + کروز
  SELECT 'vehicle:shahin-24IR22222', 'concept:ac-compressor' UNION ALL
  SELECT 'vehicle:shahin-24IR22222', 'concept:airbag-subsystem' UNION ALL
  SELECT 'vehicle:shahin-24IR22222', 'concept:abs-subsystem' UNION ALL
  SELECT 'vehicle:shahin-24IR22222', 'concept:cruise-control' UNION ALL
  -- کورولا: همه چیز + ADAS
  SELECT 'vehicle:corolla-23JP33333', 'concept:adas-subsystem' UNION ALL
  SELECT 'vehicle:corolla-23JP33333', 'concept:ac-compressor' UNION ALL
  -- تسلا: فقط برقی‌هایش
  SELECT 'vehicle:tesla-m3-24US44444', 'concept:adas-subsystem' UNION ALL
  SELECT 'vehicle:tesla-m3-24US44444', 'concept:infotainment' UNION ALL
  -- توسان: کولر + ADAS
  SELECT 'vehicle:tucson-22KR55555', 'concept:ac-compressor' UNION ALL
  SELECT 'vehicle:tucson-22KR55555', 'concept:adas-subsystem' UNION ALL
  -- BMW: همه چیز
  SELECT 'vehicle:bmw-x5-23DE66666', 'concept:adas-subsystem' UNION ALL
  SELECT 'vehicle:bmw-x5-23DE66666', 'concept:infotainment' UNION ALL
  -- هایلوکس: کولر
  SELECT 'vehicle:hilux-22JP77777', 'concept:ac-compressor'
) p
WHERE EXISTS (SELECT 1 FROM e01_200_03_tb WHERE ent_uid=p.vehicle)
  AND EXISTS (SELECT 1 FROM e01_200_03_tb WHERE ent_uid=p.part)
  AND NOT EXISTS (
    SELECT 1 FROM e01_222_01_tb r
    WHERE r.rel_uid = 'r:' || REPLACE(p.vehicle, ':', '-') || '-opt-' || REPLACE(p.part, ':', '-')
  );

INSERT OR IGNORE INTO e01_676_01_tb (migration_uid, notes)
VALUES ('v100_real_vehicles','10 real vehicle instances with VIN (space of actuality)');

UPDATE e01_676_02_tb SET schema_ver = schema_ver + 1 WHERE id = 1;

COMMIT;

-- ═══════════════════════════════════════════════════════
-- گزارش
-- ═══════════════════════════════════════════════════════
SELECT 'entities' AS k, COUNT(*) AS n FROM e01_200_03_tb
UNION ALL SELECT 'relations', COUNT(*) FROM e01_222_01_tb
UNION ALL SELECT 'instances', COUNT(*) FROM e01_200_03_tb WHERE ent_uid LIKE 'vehicle:%-%';

SELECT '=== خودروهای واقعی ===' AS section;
SELECT 
  v.ent_uid AS vehicle,
  c.label AS concept,
  v.description AS info
FROM e01_222_01_tb r
JOIN e01_202_01_tb rt ON rt.reltype_id = r.reltype_id AND rt.type_uid='instance_of'
JOIN e01_200_03_tb v ON v.ent_id = r.subj_ent_id
JOIN e01_200_03_tb c ON c.ent_id = r.obj_ent_id
WHERE v.ent_uid LIKE 'vehicle:%-%'
ORDER BY v.ent_uid;
