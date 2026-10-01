.mode column
.headers on

BEGIN;

-- ═══ گام ۱: ساخت نوع Attribute ═══
INSERT OR IGNORE INTO e01_200_01_tb (type_uid, label, is_abstract)
VALUES ('Attribute', 'ویژگی', 1);

-- ═══ گام ۲: موجودیت پایه `attribute` ═══
INSERT OR IGNORE INTO e01_200_03_tb (ent_uid, type_id, nature, label, description, prv_id)
VALUES ('attribute',
  (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Attribute'),
  'concept', 'ویژگی', 'ویژگی — مفهوم پایه', 2);

-- ═══ گام ۳: پنج نمونه ویژگی ═══
INSERT OR IGNORE INTO e01_200_03_tb (ent_uid, type_id, nature, label, description, prv_id)
VALUES 
  ('attribute:temperature', (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Attribute'), 'instance', 'دما', 'کمیت دما', 2),
  ('attribute:voltage',     (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Attribute'), 'instance', 'ولتاژ', 'کمیت ولتاژ', 2),
  ('attribute:pressure',    (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Attribute'), 'instance', 'فشار', 'کمیت فشار', 2),
  ('attribute:rpm',         (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Attribute'), 'instance', 'دور موتور', 'سرعت دورانی', 2),
  ('attribute:humidity',    (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Attribute'), 'instance', 'رطوبت', 'رطوبت هوا', 2);

-- ═══ گام ۴: رابطه instance_of ═══
INSERT OR IGNORE INTO e01_222_01_tb (rel_uid, reltype_id, subj_ent_id, obj_ent_id, status, prv_id)
SELECT 
  'r:' || REPLACE(e.ent_uid, ':', '-') || '-instance-of-attribute',
  (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='instance_of'),
  e.ent_id,
  (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='attribute'),
  'asserted', 2
FROM e01_200_03_tb e
WHERE e.ent_uid IN ('attribute:temperature', 'attribute:voltage', 'attribute:pressure', 'attribute:rpm', 'attribute:humidity');

-- ═══ گام ۵: قاعده‌ی جای‌گذاری ═══
INSERT OR IGNORE INTO e01_200_04_tb (type_id, target_uid, placement_kind, is_default, note)
VALUES ((SELECT type_id FROM e01_200_01_tb WHERE type_uid='Attribute'), 'concept:vehicle', 'inherent_to', 1, 'rule for Attribute');

-- ═══ گام ۶: log + bump ═══
INSERT OR IGNORE INTO e01_676_01_tb (migration_uid, notes)
VALUES ('v156_attribute_type', 'Created Attribute type + 5 attribute instances (temperature, voltage, pressure, rpm, humidity)');

UPDATE e01_676_02_tb SET schema_ver = schema_ver + 1 WHERE id = 1;

COMMIT;

-- ═══ POST-CHECK ═══
SELECT '═══ ۱. Attribute type + instances ═══' AS section;
SELECT e.ent_uid, e.nature, e.label FROM e01_200_03_tb e WHERE e.ent_uid='attribute' OR e.ent_uid LIKE 'attribute:%' ORDER BY e.ent_uid;

SELECT '' AS x;
SELECT '═══ ۲. instance_of relations ═══' AS section;
SELECT subj.ent_uid AS instance, obj.ent_uid AS concept
FROM e01_222_01_tb r
JOIN e01_202_01_tb rt ON rt.reltype_id=r.reltype_id AND rt.type_uid='instance_of'
JOIN e01_200_03_tb subj ON subj.ent_id=r.subj_ent_id
JOIN e01_200_03_tb obj ON obj.ent_id=r.obj_ent_id
WHERE obj.ent_uid='attribute'
ORDER BY subj.ent_uid;

SELECT '' AS x;
SELECT '═══ ۳. health ═══' AS section;
SELECT severity, COUNT(*) AS n FROM e04_900_02_vw GROUP BY severity;
