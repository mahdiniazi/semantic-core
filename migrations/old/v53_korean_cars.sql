-- v53 — خودروهای کره‌ای: هیوندای، کیا
.mode column
.headers on

BEGIN;

-- =====================================================================
-- ۱. انواع خودروی کره‌ای (به‌عنوان زیرگروه PassengerCar)
-- =====================================================================
INSERT OR IGNORE INTO e01_200_01_tb (type_uid, label, is_abstract) VALUES
-- هیوندای
('HyundaiAccent',   'هیوندای اکسنت',     0),
('HyundaiElantra',  'هیوندای النترا',    0),
('HyundaiTucson',   'هیوندای توسان',     0),
('HyundaiSantaFe',  'هیوندای سانتافه',   0),
('HyundaiSonata',   'هیوندای سوناتا',    0),
-- کیا
('KiaRio',          'کیا ریو',            0),
('KiaCerato',       'کیا سراتو',          0),
('KiaSportage',     'کیا اسپورتیج',       0),
('KiaSorento',      'کیا سورنتو',         0),
('KiaOptima',       'کیا اپتیما',         0);

UPDATE e01_200_01_tb 
SET parent_id = (SELECT type_id FROM e01_200_01_tb WHERE type_uid='PassengerCar')
WHERE type_uid IN (
  'HyundaiAccent','HyundaiElantra','HyundaiTucson','HyundaiSantaFe','HyundaiSonata',
  'KiaRio','KiaCerato','KiaSportage','KiaSorento','KiaOptima'
);

-- =====================================================================
-- ۲. مفهوم‌های خودروی کره‌ای
-- =====================================================================
INSERT OR IGNORE INTO e01_200_03_tb (ent_uid, type_id, nature, label, description, prv_id) VALUES
('concept:hyundai-accent',   (SELECT type_id FROM e01_200_01_tb WHERE type_uid='HyundaiAccent'),'concept','هیوندای اکسنت','Hyundai Accent',2),
('concept:hyundai-elantra',  (SELECT type_id FROM e01_200_01_tb WHERE type_uid='HyundaiElantra'),'concept','هیوندای النترا','Hyundai Elantra',2),
('concept:hyundai-tucson',   (SELECT type_id FROM e01_200_01_tb WHERE type_uid='HyundaiTucson'),'concept','هیوندای توسان','Hyundai Tucson SUV',2),
('concept:hyundai-santafe',  (SELECT type_id FROM e01_200_01_tb WHERE type_uid='HyundaiSantaFe'),'concept','هیوندای سانتافه','Hyundai Santa Fe SUV',2),
('concept:hyundai-sonata',   (SELECT type_id FROM e01_200_01_tb WHERE type_uid='HyundaiSonata'),'concept','هیوندای سوناتا','Hyundai Sonata',2),

('concept:kia-rio',          (SELECT type_id FROM e01_200_01_tb WHERE type_uid='KiaRio'),'concept','کیا ریو','Kia Rio',2),
('concept:kia-cerato',       (SELECT type_id FROM e01_200_01_tb WHERE type_uid='KiaCerato'),'concept','کیا سراتو','Kia Cerato',2),
('concept:kia-sportage',     (SELECT type_id FROM e01_200_01_tb WHERE type_uid='KiaSportage'),'concept','کیا اسپورتیج','Kia Sportage SUV',2),
('concept:kia-sorento',      (SELECT type_id FROM e01_200_01_tb WHERE type_uid='KiaSorento'),'concept','کیا سورنتو','Kia Sorento SUV',2),
('concept:kia-optima',       (SELECT type_id FROM e01_200_01_tb WHERE type_uid='KiaOptima'),'concept','کیا اپتیما','Kia Optima',2);

-- =====================================================================
-- ۳. is_a: هر مفهوم زیر PassengerCar
-- =====================================================================
INSERT INTO e01_222_01_tb (rel_uid, reltype_id, subj_ent_id, obj_ent_id, status, prv_id)
SELECT
  'r:' || REPLACE(p.sub_uid, ':', '-') || '-is-a',
  (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='is_a'),
  (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid=p.sub_uid),
  (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='concept:passenger-car'),
  'asserted', 2
FROM (
  SELECT 'concept:hyundai-accent' AS sub_uid UNION ALL
  SELECT 'concept:hyundai-elantra' UNION ALL
  SELECT 'concept:hyundai-tucson' UNION ALL
  SELECT 'concept:hyundai-santafe' UNION ALL
  SELECT 'concept:hyundai-sonata' UNION ALL
  SELECT 'concept:kia-rio' UNION ALL
  SELECT 'concept:kia-cerato' UNION ALL
  SELECT 'concept:kia-sportage' UNION ALL
  SELECT 'concept:kia-sorento' UNION ALL
  SELECT 'concept:kia-optima'
) p
WHERE NOT EXISTS (
  SELECT 1 FROM e01_222_01_tb r
  WHERE r.rel_uid = 'r:' || REPLACE(p.sub_uid, ':', '-') || '-is-a'
);

-- =====================================================================
-- ۴. manufactured_by: هر خودرو به سازنده‌اش
-- =====================================================================
INSERT INTO e01_222_01_tb (rel_uid, reltype_id, subj_ent_id, obj_ent_id, status, prv_id)
SELECT
  'r:' || REPLACE(p.product, ':', '-') || '-by-' || REPLACE(p.maker, ':', '-'),
  (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='manufactured_by'),
  (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid=p.product),
  (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid=p.maker),
  'asserted', 2
FROM (
  SELECT 'concept:hyundai-accent'  AS product, 'concept:hyundai' AS maker UNION ALL
  SELECT 'concept:hyundai-elantra',           'concept:hyundai' UNION ALL
  SELECT 'concept:hyundai-tucson',            'concept:hyundai' UNION ALL
  SELECT 'concept:hyundai-santafe',           'concept:hyundai' UNION ALL
  SELECT 'concept:hyundai-sonata',            'concept:hyundai' UNION ALL
  SELECT 'concept:kia-rio',                   'concept:kia' UNION ALL
  SELECT 'concept:kia-cerato',                'concept:kia' UNION ALL
  SELECT 'concept:kia-sportage',              'concept:kia' UNION ALL
  SELECT 'concept:kia-sorento',               'concept:kia' UNION ALL
  SELECT 'concept:kia-optima',                'concept:kia'
) p
WHERE EXISTS (SELECT 1 FROM e01_200_03_tb WHERE ent_uid=p.product)
  AND EXISTS (SELECT 1 FROM e01_200_03_tb WHERE ent_uid=p.maker)
  AND NOT EXISTS (
    SELECT 1 FROM e01_222_01_tb r
    WHERE r.rel_uid = 'r:' || REPLACE(p.product, ':', '-') || '-by-' || REPLACE(p.maker, ':', '-')
  );

-- =====================================================================
-- ۵. نمونه‌های واقعی خودروی کره‌ای (instance)
-- =====================================================================
INSERT OR IGNORE INTO e01_200_03_tb (ent_uid, type_id, nature, label, description, prv_id) VALUES
('vehicle:accent-1',  (SELECT type_id FROM e01_200_01_tb WHERE type_uid='HyundaiAccent'),'instance','اکسنت نمونه','هیوندای اکسنت ۱.۴ لیتر',2),
('vehicle:elantra-1', (SELECT type_id FROM e01_200_01_tb WHERE type_uid='HyundaiElantra'),'instance','النترا نمونه','هیوندای النترا',2),
('vehicle:tucson-1',  (SELECT type_id FROM e01_200_01_tb WHERE type_uid='HyundaiTucson'),'instance','توسان نمونه','هیوندای توسان',2),
('vehicle:rio-1',     (SELECT type_id FROM e01_200_01_tb WHERE type_uid='KiaRio'),'instance','ریو نمونه','کیا ریو',2),
('vehicle:cerato-1',  (SELECT type_id FROM e01_200_01_tb WHERE type_uid='KiaCerato'),'instance','سراتو نمونه','کیا سراتو',2),
('vehicle:sportage-1',(SELECT type_id FROM e01_200_01_tb WHERE type_uid='KiaSportage'),'instance','اسپورتیج نمونه','کیا اسپورتیج',2);

-- =====================================================================
-- ۶. instance_of: هر نمونه به مفهوم
-- =====================================================================
INSERT INTO e01_222_01_tb (rel_uid, reltype_id, subj_ent_id, obj_ent_id, status, prv_id)
SELECT
  'r:' || REPLACE(v.ent_uid, ':', '-') || '-instance-of',
  (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='instance_of'),
  v.ent_id,
  (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid =
    CASE 
      WHEN v.ent_uid='vehicle:accent-1'   THEN 'concept:hyundai-accent'
      WHEN v.ent_uid='vehicle:elantra-1'  THEN 'concept:hyundai-elantra'
      WHEN v.ent_uid='vehicle:tucson-1'   THEN 'concept:hyundai-tucson'
      WHEN v.ent_uid='vehicle:rio-1'      THEN 'concept:kia-rio'
      WHEN v.ent_uid='vehicle:cerato-1'   THEN 'concept:kia-cerato'
      WHEN v.ent_uid='vehicle:sportage-1' THEN 'concept:kia-sportage'
    END),
  'asserted', 2
FROM e01_200_03_tb v
WHERE v.ent_uid IN ('vehicle:accent-1','vehicle:elantra-1','vehicle:tucson-1',
                     'vehicle:rio-1','vehicle:cerato-1','vehicle:sportage-1')
AND NOT EXISTS (
  SELECT 1 FROM e01_222_01_tb r 
  WHERE r.rel_uid = 'r:' || REPLACE(v.ent_uid, ':', '-') || '-instance-of'
);

-- =====================================================================
-- ۷. لاگ
-- =====================================================================
INSERT OR IGNORE INTO e01_676_01_tb (migration_uid, notes)
VALUES ('v53_korean_cars','Korean cars: Hyundai (5), Kia (5) + 6 instances');

UPDATE e01_676_02_tb SET schema_ver = schema_ver + 1 WHERE id = 1;

COMMIT;

-- =====================================================================
-- گزارش
-- =====================================================================
SELECT 'entities' AS k, COUNT(*) AS n FROM e01_200_03_tb
UNION ALL SELECT 'relations', COUNT(*) FROM e01_222_01_tb;

SELECT '=== خودروهای کره‌ای ===' AS section;
SELECT 
  p.ent_uid AS product,
  p.label AS product_label,
  m.label AS maker
FROM e01_222_01_tb r
JOIN e01_202_01_tb rt ON rt.reltype_id = r.reltype_id AND rt.type_uid='manufactured_by'
JOIN e01_200_03_tb p ON p.ent_id = r.subj_ent_id
JOIN e01_200_03_tb m ON m.ent_id = r.obj_ent_id
WHERE m.ent_uid IN ('concept:hyundai','concept:kia')
ORDER BY m.ent_uid, p.ent_uid;

SELECT '=== نمونه‌های کره‌ای ===' AS section;
SELECT 
  v.ent_uid AS instance,
  obj.ent_uid AS concept
FROM e01_222_01_tb r
JOIN e01_202_01_tb rt ON rt.reltype_id = r.reltype_id AND rt.type_uid='instance_of'
JOIN e01_200_03_tb v ON v.ent_id = r.subj_ent_id
JOIN e01_200_03_tb obj ON obj.ent_id = r.obj_ent_id
WHERE obj.ent_uid LIKE 'concept:hyundai-%' OR obj.ent_uid LIKE 'concept:kia-%'
ORDER BY v.ent_uid;
