-- v65 — لیسانس و پلتفرم خودروهای ایرانی
.mode column
.headers on

BEGIN;

-- =====================================================================
-- ۱. انواع رابطه جدید
-- =====================================================================
INSERT OR IGNORE INTO e01_202_01_tb (type_uid, label, description, object_kind) VALUES
('licensed_from', 'تحت لیسانس از', 'خودرو تحت لیسانس سازنده دیگر', 'entity'),
('based_on',      'مبتنی بر',       'خودرو مبتنی بر پلتفرم دیگر',    'entity'),
('platform_of',   'پلتفرمِ',        'پلتفرم → خودرو',                'entity');

-- قواعد چیزسازی
INSERT OR IGNORE INTO e01_202_02_tb (reltype_id, reify_rule, category, reason)
SELECT reltype_id, 'when_data', 'structural', 'لیسانس — چیزسازی اگر تاریخ/قرارداد دارد'
FROM e01_202_01_tb WHERE type_uid IN ('licensed_from','based_on','platform_of');

-- =====================================================================
-- ۲. خودروهای جدید ایرانی
-- =====================================================================
INSERT OR IGNORE INTO e01_200_01_tb (type_uid, label, is_abstract) VALUES
('IKCORana',   'رانا',            0),
('IKCORunna',  'رانا پلاس',       0),
('SAIPATondar','تندر ۹۰',         0),
('SAIPASaina', 'ساینا',           0),
('ParsKhodroTondar','پارس تندر',  0);

UPDATE e01_200_01_tb 
SET parent_id = (SELECT type_id FROM e01_200_01_tb WHERE type_uid='PassengerCar')
WHERE type_uid IN ('IKCORana','IKCORunna','SAIPATondar','SAIPASaina','ParsKhodroTondar');

INSERT OR IGNORE INTO e01_200_03_tb (ent_uid, type_id, nature, label, description, prv_id) VALUES
('concept:rana',      (SELECT type_id FROM e01_200_01_tb WHERE type_uid='IKCORana'),'concept','رانا','IKCO Rana',2),
('concept:runna',     (SELECT type_id FROM e01_200_01_tb WHERE type_uid='IKCORunna'),'concept','رانا پلاس','IKCO Runna',2),
('concept:tondar-90', (SELECT type_id FROM e01_200_01_tb WHERE type_uid='SAIPATondar'),'concept','تندر ۹۰','Tondar 90 (Renault L90)',2),
('concept:saina',     (SELECT type_id FROM e01_200_01_tb WHERE type_uid='SAIPASaina'),'concept','ساینا','SAIPA Saina',2),
('concept:pars-tondar',(SELECT type_id FROM e01_200_01_tb WHERE type_uid='ParsKhodroTondar'),'concept','پارس تندر','Pars Khodro Tondar',2);

-- is_a: سواری
INSERT INTO e01_222_01_tb (rel_uid, reltype_id, subj_ent_id, obj_ent_id, status, prv_id)
SELECT
  'r:' || REPLACE(p.sub_uid, ':', '-') || '-is-a',
  (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='is_a'),
  (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid=p.sub_uid),
  (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='concept:passenger-car'),
  'asserted', 2
FROM (
  SELECT 'concept:rana' AS sub_uid UNION ALL
  SELECT 'concept:runna' UNION ALL
  SELECT 'concept:tondar-90' UNION ALL
  SELECT 'concept:saina' UNION ALL
  SELECT 'concept:pars-tondar'
) p
WHERE NOT EXISTS (SELECT 1 FROM e01_222_01_tb r WHERE r.rel_uid = 'r:' || REPLACE(p.sub_uid, ':', '-') || '-is-a');

-- manufactured_by
INSERT INTO e01_222_01_tb (rel_uid, reltype_id, subj_ent_id, obj_ent_id, status, prv_id)
SELECT
  'r:' || REPLACE(p.product, ':', '-') || '-by-' || REPLACE(p.maker, ':', '-'),
  (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='manufactured_by'),
  (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid=p.product),
  (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid=p.maker),
  'asserted', 2
FROM (
  SELECT 'concept:rana' AS product, 'concept:ikco' AS maker UNION ALL
  SELECT 'concept:runna',              'concept:ikco' UNION ALL
  SELECT 'concept:tondar-90',          'concept:saipa' UNION ALL
  SELECT 'concept:saina',              'concept:saipa' UNION ALL
  SELECT 'concept:pars-tondar',        'concept:parskhodro'
) p
WHERE EXISTS (SELECT 1 FROM e01_200_03_tb WHERE ent_uid=p.product)
  AND EXISTS (SELECT 1 FROM e01_200_03_tb WHERE ent_uid=p.maker)
  AND NOT EXISTS (SELECT 1 FROM e01_222_01_tb r WHERE r.rel_uid = 'r:' || REPLACE(p.product, ':', '-') || '-by-' || REPLACE(p.maker, ':', '-'));

-- =====================================================================
-- ۳. روابط لیسانس
-- =====================================================================
INSERT INTO e01_222_01_tb (rel_uid, reltype_id, subj_ent_id, obj_ent_id, status, prv_id)
SELECT
  'r:' || REPLACE(p.sub_uid, ':', '-') || '-licensed-from-' || REPLACE(p.obj_uid, ':', '-'),
  (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='licensed_from'),
  (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid=p.sub_uid),
  (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid=p.obj_uid),
  'asserted', 2
FROM (
  SELECT 'concept:206' AS sub_uid, 'concept:peugeot' AS obj_uid UNION ALL
  SELECT 'concept:405', 'concept:peugeot' UNION ALL
  SELECT 'concept:tondar-90', 'concept:renault' UNION ALL
  SELECT 'concept:pars-tondar', 'concept:renault'
) p
WHERE EXISTS (SELECT 1 FROM e01_200_03_tb WHERE ent_uid=p.sub_uid)
  AND EXISTS (SELECT 1 FROM e01_200_03_tb WHERE ent_uid=p.obj_uid)
  AND NOT EXISTS (SELECT 1 FROM e01_222_01_tb r WHERE r.rel_uid = 'r:' || REPLACE(p.sub_uid, ':', '-') || '-licensed-from-' || REPLACE(p.obj_uid, ':', '-'));

-- =====================================================================
-- ۴. روابط پلتفرم (based_on)
-- =====================================================================
INSERT INTO e01_222_01_tb (rel_uid, reltype_id, subj_ent_id, obj_ent_id, status, prv_id)
SELECT
  'r:' || REPLACE(p.sub_uid, ':', '-') || '-based-on-' || REPLACE(p.obj_uid, ':', '-'),
  (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='based_on'),
  (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid=p.sub_uid),
  (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid=p.obj_uid),
  'asserted', 2
FROM (
  -- سمند بر پایه پژو ۴۰۵
  SELECT 'concept:samand' AS sub_uid, 'concept:405' AS obj_uid UNION ALL
  -- دنا بر پایه سمند
  SELECT 'concept:dena', 'concept:samand' UNION ALL
  -- رانا بر پایه پژو ۲۰۶
  SELECT 'concept:rana', 'concept:206' UNION ALL
  -- رانا پلاس بر پایه رانا
  SELECT 'concept:runna', 'concept:rana' UNION ALL
  -- پراید بر پایه کیا ریو (Pride origin)
  SELECT 'concept:pride', 'concept:kia-rio' UNION ALL
  -- تیبا بر پایه پراید
  SELECT 'concept:tiba', 'concept:pride' UNION ALL
  -- ساینا بر پایه تیبا
  SELECT 'concept:saina', 'concept:tiba' UNION ALL
  -- کوییک بر پایه تیبا
  SELECT 'concept:quick', 'concept:tiba'
) p
WHERE EXISTS (SELECT 1 FROM e01_200_03_tb WHERE ent_uid=p.sub_uid)
  AND EXISTS (SELECT 1 FROM e01_200_03_tb WHERE ent_uid=p.obj_uid)
  AND NOT EXISTS (SELECT 1 FROM e01_222_01_tb r WHERE r.rel_uid = 'r:' || REPLACE(p.sub_uid, ':', '-') || '-based-on-' || REPLACE(p.obj_uid, ':', '-'));

-- =====================================================================
-- ۵. لاگ
-- =====================================================================
INSERT OR IGNORE INTO e01_676_01_tb (migration_uid, notes)
VALUES ('v65_license_platform','License and platform relations for Iranian cars');

UPDATE e01_676_02_tb SET schema_ver = schema_ver + 1 WHERE id = 1;

COMMIT;

-- =====================================================================
-- گزارش
-- =====================================================================
SELECT 'entities' AS k, COUNT(*) AS n FROM e01_200_03_tb
UNION ALL SELECT 'relations', COUNT(*) FROM e01_222_01_tb;

SELECT '=== لیسانس‌ها ===' AS section;
SELECT 
  p.label AS car,
  m.label AS licensor
FROM e01_222_01_tb r
JOIN e01_202_01_tb rt ON rt.reltype_id = r.reltype_id AND rt.type_uid='licensed_from'
JOIN e01_200_03_tb p ON p.ent_id = r.subj_ent_id
JOIN e01_200_03_tb m ON m.ent_id = r.obj_ent_id
ORDER BY p.ent_uid;

SELECT '=== پلتفرم‌ها ===' AS section;
SELECT 
  p.label AS car,
  m.label AS platform_origin
FROM e01_222_01_tb r
JOIN e01_202_01_tb rt ON rt.reltype_id = r.reltype_id AND rt.type_uid='based_on'
JOIN e01_200_03_tb p ON p.ent_id = r.subj_ent_id
JOIN e01_200_03_tb m ON m.ent_id = r.obj_ent_id
ORDER BY p.ent_uid;
