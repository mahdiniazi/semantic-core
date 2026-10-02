-- v94 — زنجیره‌های ADAS، سرگرمی، و زنجیره کل خودرو
.mode column
.headers on

BEGIN;

-- ═══════════════════════════════════════════════════════
-- ۱. ساخت ۵ زنجیره جدید
-- ═══════════════════════════════════════════════════════
INSERT OR IGNORE INTO e01_200_03_tb (ent_uid, type_id, nature, label, description, prv_id)
SELECT 'fn:' || p.uid, 
       (SELECT type_id FROM e01_200_01_tb WHERE type_uid='FunctionalChain'),
       'concept', p.label, p.descr, 2
FROM (
  SELECT 'adas-chain' AS uid, 'زنجیره ADAS' AS label, 'Advanced Driver Assistance' AS descr UNION ALL
  SELECT 'infotainment-chain', 'زنجیره سرگرمی', 'Infotainment flow' UNION ALL
  SELECT 'cruise-chain', 'زنجیره کروز کنترل', 'Cruise control flow' UNION ALL
  SELECT 'parking-chain', 'زنجیره پارکینگ', 'Parking assistance' UNION ALL
  SELECT 'vehicle-super-chain', 'زنجیره کل خودرو', 'Whole vehicle super chain'
) p;

-- ═══════════════════════════════════════════════════════
-- ۲. اتصال قطعات به زنجیره‌ها
-- ═══════════════════════════════════════════════════════
INSERT OR IGNORE INTO e01_222_01_tb (rel_uid, reltype_id, subj_ent_id, obj_ent_id, status, prv_id)
SELECT
  'r:' || REPLACE(p.part, ':', '-') || '-plays-in-' || REPLACE(p.chain, ':', '-'),
  (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='plays_role_in'),
  (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid=p.part),
  (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid=p.chain),
  'asserted', 2
FROM (
  -- زنجیره ADAS
  SELECT 'concept:adas-ecu-dcu' AS part, 'fn:adas-chain' AS chain UNION ALL
  SELECT 'concept:radar',                    'fn:adas-chain' UNION ALL
  SELECT 'concept:lidar',                    'fn:adas-chain' UNION ALL
  SELECT 'concept:reverse-camera',           'fn:adas-chain' UNION ALL
  SELECT 'concept:wheel-speed',              'fn:adas-chain' UNION ALL
  -- زنجیره سرگرمی
  SELECT 'concept:infotainment-ecu-dcu',     'fn:infotainment-chain' UNION ALL
  SELECT 'concept:infotainment',             'fn:infotainment-chain' UNION ALL
  SELECT 'concept:touchscreen',              'fn:infotainment-chain' UNION ALL
  SELECT 'concept:amplifier',                'fn:infotainment-chain' UNION ALL
  SELECT 'concept:speaker',                  'fn:infotainment-chain' UNION ALL
  SELECT 'concept:antenna',                  'fn:infotainment-chain' UNION ALL
  SELECT 'concept:automotive-ethernet',      'fn:infotainment-chain' UNION ALL
  -- زنجیره کروز
  SELECT 'concept:cruise-control',           'fn:cruise-chain' UNION ALL
  SELECT 'concept:engine-ecu',               'fn:cruise-chain' UNION ALL
  SELECT 'concept:vss',                      'fn:cruise-chain' UNION ALL
  SELECT 'concept:tps',                      'fn:cruise-chain' UNION ALL
  -- زنجیره پارکینگ
  SELECT 'concept:parking-sensor',           'fn:parking-chain' UNION ALL
  SELECT 'concept:reverse-camera',           'fn:parking-chain' UNION ALL
  SELECT 'concept:body-ecu',                 'fn:parking-chain' UNION ALL
  SELECT 'concept:warning-light',            'fn:parking-chain'
) p
WHERE EXISTS (SELECT 1 FROM e01_200_03_tb WHERE ent_uid=p.part)
  AND EXISTS (SELECT 1 FROM e01_200_03_tb WHERE ent_uid=p.chain)
  AND NOT EXISTS (
    SELECT 1 FROM e01_222_01_tb r
    WHERE r.rel_uid = 'r:' || REPLACE(p.part, ':', '-') || '-plays-in-' || REPLACE(p.chain, ':', '-')
  );

-- ═══════════════════════════════════════════════════════
-- ۳. زنجیره کل خودرو: زیرزنجیره‌ها (سوپرجان)
-- ═══════════════════════════════════════════════════════
INSERT OR IGNORE INTO e01_222_01_tb (rel_uid, reltype_id, subj_ent_id, obj_ent_id, status, prv_id)
SELECT
  'r:' || REPLACE(p.sub, ':', '-') || '-plays-in-' || REPLACE(p.super, ':', '-'),
  (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='plays_role_in'),
  (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid=p.sub),
  (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid=p.super),
  'asserted', 2
FROM (
  SELECT 'fn:powertrain-super-chain' AS sub, 'fn:vehicle-super-chain' AS super UNION ALL
  SELECT 'fn:chassis-super-chain',              'fn:vehicle-super-chain' UNION ALL
  SELECT 'fn:body-super-chain',                 'fn:vehicle-super-chain' UNION ALL
  SELECT 'fn:ee-super-chain',                   'fn:vehicle-super-chain' UNION ALL
  SELECT 'fn:adas-chain',                       'fn:vehicle-super-chain' UNION ALL
  SELECT 'fn:infotainment-chain',               'fn:vehicle-super-chain'
) p
WHERE EXISTS (SELECT 1 FROM e01_200_03_tb WHERE ent_uid=p.sub)
  AND EXISTS (SELECT 1 FROM e01_200_03_tb WHERE ent_uid=p.super)
  AND NOT EXISTS (
    SELECT 1 FROM e01_222_01_tb r
    WHERE r.rel_uid = 'r:' || REPLACE(p.sub, ':', '-') || '-plays-in-' || REPLACE(p.super, ':', '-')
  );

-- ═══════════════════════════════════════════════════════
-- ۴. اتصال زنجیره کل خودرو به concept:vehicle
-- ═══════════════════════════════════════════════════════
INSERT OR IGNORE INTO e01_222_01_tb (rel_uid, reltype_id, subj_ent_id, obj_ent_id, status, prv_id)
VALUES
('r:vehicle-plays-in-super-chain',
 (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='plays_role_in'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='concept:vehicle'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='fn:vehicle-super-chain'),
 'asserted', 2);

INSERT OR IGNORE INTO e01_676_01_tb (migration_uid, notes)
VALUES ('v94_adas_info_vehicle','ADAS + infotainment chains + vehicle super chain');

UPDATE e01_676_02_tb SET schema_ver = schema_ver + 1 WHERE id = 1;

COMMIT;

-- ═══════════════════════════════════════════════════════
-- گزارش
-- ═══════════════════════════════════════════════════════
SELECT 'entities' AS k, COUNT(*) AS n FROM e01_200_03_tb
UNION ALL SELECT 'relations', COUNT(*) FROM e01_222_01_tb
UNION ALL SELECT 'total_chains', COUNT(*) FROM e01_200_03_tb WHERE ent_uid LIKE 'fn:%';

SELECT '=== زنجیره‌های جدید ===' AS section;
SELECT 
  chain.label AS chain,
  GROUP_CONCAT(part.label, ' → ') AS roles
FROM e01_222_01_tb r
JOIN e01_202_01_tb rt ON rt.reltype_id = r.reltype_id AND rt.type_uid='plays_role_in'
JOIN e01_200_03_tb part ON part.ent_id = r.subj_ent_id
JOIN e01_200_03_tb chain ON chain.ent_id = r.obj_ent_id
WHERE chain.ent_uid IN ('fn:adas-chain','fn:infotainment-chain','fn:cruise-chain','fn:parking-chain','fn:vehicle-super-chain')
  AND r.status='asserted' AND r.superseded_at IS NULL
GROUP BY chain.ent_uid
ORDER BY chain.ent_uid;
