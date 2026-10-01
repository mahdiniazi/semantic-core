-- v54 — خودروهای ژاپنی
.mode column
.headers on

BEGIN;

-- =====================================================================
-- ۱. انواع خودروی ژاپنی
-- =====================================================================
INSERT OR IGNORE INTO e01_200_01_tb (type_uid, label, is_abstract) VALUES
-- تویوتا
('ToyotaCorolla',  'تویوتا کرولا',    0),
('ToyotaCamry',    'تویوتا کمری',     0),
('ToyotaRAV4',     'تویوتا راو۴',     0),
('ToyotaLandCruiser','تویوتا لندکروزر',0),
-- هوندا
('HondaCivic',     'هوندا سیویک',     0),
('HondaAccord',    'هوندا اکورد',     0),
('HondaCRV',       'هوندا CR-V',      0),
-- نیسان
('NissanSunny',    'نیسان سانی',       0),
('NissanAltima',   'نیسان آلتیما',     0),
('NissanXTrail',   'نیسان ایکس‌تریل',  0);

UPDATE e01_200_01_tb 
SET parent_id = (SELECT type_id FROM e01_200_01_tb WHERE type_uid='PassengerCar')
WHERE type_uid IN (
  'ToyotaCorolla','ToyotaCamry','ToyotaRAV4','ToyotaLandCruiser',
  'HondaCivic','HondaAccord','HondaCRV',
  'NissanSunny','NissanAltima','NissanXTrail'
);

-- =====================================================================
-- ۲. مفهوم‌های خودروی ژاپنی
-- =====================================================================
INSERT OR IGNORE INTO e01_200_03_tb (ent_uid, type_id, nature, label, description, prv_id) VALUES
('concept:toyota-corolla',    (SELECT type_id FROM e01_200_01_tb WHERE type_uid='ToyotaCorolla'),'concept','تویوتا کرولا','Toyota Corolla',2),
('concept:toyota-camry',      (SELECT type_id FROM e01_200_01_tb WHERE type_uid='ToyotaCamry'),'concept','تویوتا کمری','Toyota Camry',2),
('concept:toyota-rav4',       (SELECT type_id FROM e01_200_01_tb WHERE type_uid='ToyotaRAV4'),'concept','تویوتا راو۴','Toyota RAV4 SUV',2),
('concept:toyota-landcruiser',(SELECT type_id FROM e01_200_01_tb WHERE type_uid='ToyotaLandCruiser'),'concept','تویوتا لندکروزر','Toyota Land Cruiser',2),

('concept:honda-civic',   (SELECT type_id FROM e01_200_01_tb WHERE type_uid='HondaCivic'),'concept','هوندا سیویک','Honda Civic',2),
('concept:honda-accord',  (SELECT type_id FROM e01_200_01_tb WHERE type_uid='HondaAccord'),'concept','هوندا اکورد','Honda Accord',2),
('concept:honda-crv',     (SELECT type_id FROM e01_200_01_tb WHERE type_uid='HondaCRV'),'concept','هوندا CR-V','Honda CR-V SUV',2),

('concept:nissan-sunny',  (SELECT type_id FROM e01_200_01_tb WHERE type_uid='NissanSunny'),'concept','نیسان سانی','Nissan Sunny',2),
('concept:nissan-altima', (SELECT type_id FROM e01_200_01_tb WHERE type_uid='NissanAltima'),'concept','نیسان آلتیما','Nissan Altima',2),
('concept:nissan-xtrail', (SELECT type_id FROM e01_200_01_tb WHERE type_uid='NissanXTrail'),'concept','نیسان ایکس‌تریل','Nissan X-Trail SUV',2);

-- =====================================================================
-- ۳. is_a
-- =====================================================================
INSERT INTO e01_222_01_tb (rel_uid, reltype_id, subj_ent_id, obj_ent_id, status, prv_id)
SELECT
  'r:' || REPLACE(p.sub_uid, ':', '-') || '-is-a',
  (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='is_a'),
  (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid=p.sub_uid),
  (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='concept:passenger-car'),
  'asserted', 2
FROM (
  SELECT 'concept:toyota-corolla' AS sub_uid UNION ALL
  SELECT 'concept:toyota-camry' UNION ALL
  SELECT 'concept:toyota-rav4' UNION ALL
  SELECT 'concept:toyota-landcruiser' UNION ALL
  SELECT 'concept:honda-civic' UNION ALL
  SELECT 'concept:honda-accord' UNION ALL
  SELECT 'concept:honda-crv' UNION ALL
  SELECT 'concept:nissan-sunny' UNION ALL
  SELECT 'concept:nissan-altima' UNION ALL
  SELECT 'concept:nissan-xtrail'
) p
WHERE NOT EXISTS (
  SELECT 1 FROM e01_222_01_tb r
  WHERE r.rel_uid = 'r:' || REPLACE(p.sub_uid, ':', '-') || '-is-a'
);

-- =====================================================================
-- ۴. manufactured_by
-- =====================================================================
INSERT INTO e01_222_01_tb (rel_uid, reltype_id, subj_ent_id, obj_ent_id, status, prv_id)
SELECT
  'r:' || REPLACE(p.product, ':', '-') || '-by-' || REPLACE(p.maker, ':', '-'),
  (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='manufactured_by'),
  (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid=p.product),
  (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid=p.maker),
  'asserted', 2
FROM (
  SELECT 'concept:toyota-corolla' AS product, 'concept:toyota' AS maker UNION ALL
  SELECT 'concept:toyota-camry',              'concept:toyota' UNION ALL
  SELECT 'concept:toyota-rav4',               'concept:toyota' UNION ALL
  SELECT 'concept:toyota-landcruiser',        'concept:toyota' UNION ALL
  SELECT 'concept:honda-civic',               'concept:honda' UNION ALL
  SELECT 'concept:honda-accord',              'concept:honda' UNION ALL
  SELECT 'concept:honda-crv',                 'concept:honda' UNION ALL
  SELECT 'concept:nissan-sunny',              'concept:nissan' UNION ALL
  SELECT 'concept:nissan-altima',             'concept:nissan' UNION ALL
  SELECT 'concept:nissan-xtrail',             'concept:nissan'
) p
WHERE EXISTS (SELECT 1 FROM e01_200_03_tb WHERE ent_uid=p.product)
  AND EXISTS (SELECT 1 FROM e01_200_03_tb WHERE ent_uid=p.maker)
  AND NOT EXISTS (
    SELECT 1 FROM e01_222_01_tb r
    WHERE r.rel_uid = 'r:' || REPLACE(p.product, ':', '-') || '-by-' || REPLACE(p.maker, ':', '-')
  );

-- =====================================================================
-- ۵. نمونه‌های واقعی
-- =====================================================================
INSERT OR IGNORE INTO e01_200_03_tb (ent_uid, type_id, nature, label, description, prv_id) VALUES
('vehicle:corolla-1',   (SELECT type_id FROM e01_200_01_tb WHERE type_uid='ToyotaCorolla'),'instance','کرولا نمونه','تویوتا کرولا',2),
('vehicle:camry-1',     (SELECT type_id FROM e01_200_01_tb WHERE type_uid='ToyotaCamry'),'instance','کمری نمونه','تویوتا کمری',2),
('vehicle:civic-1',     (SELECT type_id FROM e01_200_01_tb WHERE type_uid='HondaCivic'),'instance','سیویک نمونه','هوندا سیویک',2),
('vehicle:accord-1',    (SELECT type_id FROM e01_200_01_tb WHERE type_uid='HondaAccord'),'instance','اکورد نمونه','هوندا اکورد',2),
('vehicle:sunny-1',     (SELECT type_id FROM e01_200_01_tb WHERE type_uid='NissanSunny'),'instance','سانی نمونه','نیسان سانی',2),
('vehicle:altima-1',    (SELECT type_id FROM e01_200_01_tb WHERE type_uid='NissanAltima'),'instance','آلتیما نمونه','نیسان آلتیما',2);

-- =====================================================================
-- ۶. instance_of
-- =====================================================================
INSERT INTO e01_222_01_tb (rel_uid, reltype_id, subj_ent_id, obj_ent_id, status, prv_id)
SELECT
  'r:' || REPLACE(v.ent_uid, ':', '-') || '-instance-of',
  (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='instance_of'),
  v.ent_id,
  (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid =
    CASE 
      WHEN v.ent_uid='vehicle:corolla-1' THEN 'concept:toyota-corolla'
      WHEN v.ent_uid='vehicle:camry-1'   THEN 'concept:toyota-camry'
      WHEN v.ent_uid='vehicle:civic-1'   THEN 'concept:honda-civic'
      WHEN v.ent_uid='vehicle:accord-1'  THEN 'concept:honda-accord'
      WHEN v.ent_uid='vehicle:sunny-1'   THEN 'concept:nissan-sunny'
      WHEN v.ent_uid='vehicle:altima-1'  THEN 'concept:nissan-altima'
    END),
  'asserted', 2
FROM e01_200_03_tb v
WHERE v.ent_uid IN ('vehicle:corolla-1','vehicle:camry-1','vehicle:civic-1',
                     'vehicle:accord-1','vehicle:sunny-1','vehicle:altima-1')
AND NOT EXISTS (
  SELECT 1 FROM e01_222_01_tb r 
  WHERE r.rel_uid = 'r:' || REPLACE(v.ent_uid, ':', '-') || '-instance-of'
);

-- =====================================================================
-- ۷. لاگ
-- =====================================================================
INSERT OR IGNORE INTO e01_676_01_tb (migration_uid, notes)
VALUES ('v54_japanese_cars','Japanese cars: Toyota (4), Honda (3), Nissan (3) + 6 instances');

UPDATE e01_676_02_tb SET schema_ver = schema_ver + 1 WHERE id = 1;

COMMIT;

-- =====================================================================
-- گزارش
-- =====================================================================
SELECT 'entities' AS k, COUNT(*) AS n FROM e01_200_03_tb
UNION ALL SELECT 'relations', COUNT(*) FROM e01_222_01_tb
UNION ALL SELECT 'total_manufacturers', COUNT(*) FROM e01_200_03_tb WHERE ent_uid LIKE 'concept:%' AND type_id IN (
  SELECT type_id FROM e01_200_01_tb WHERE type_uid LIKE '%Manufacturer%'
);

SELECT '=== خودروهای ژاپنی ===' AS section;
SELECT 
  p.ent_uid AS product,
  m.label AS maker
FROM e01_222_01_tb r
JOIN e01_202_01_tb rt ON rt.reltype_id = r.reltype_id AND rt.type_uid='manufactured_by'
JOIN e01_200_03_tb p ON p.ent_id = r.subj_ent_id
JOIN e01_200_03_tb m ON m.ent_id = r.obj_ent_id
WHERE m.ent_uid IN ('concept:toyota','concept:honda','concept:nissan')
ORDER BY m.ent_uid, p.ent_uid;
