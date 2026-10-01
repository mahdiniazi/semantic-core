.mode column
.headers on

BEGIN;

-- ========== ۱. شش تست گمشده ==========
INSERT OR IGNORE INTO e01_200_03_tb (ent_uid, type_id, nature, label, description, prv_id) VALUES
('test:shock-leak-visual',(SELECT type_id FROM e01_200_01_tb WHERE type_uid='Test'),'instance','بازرسی چشمی نشت','بررسی چشمی کمک‌فنر',2),
('test:spring-height',    (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Test'),'instance','تست ارتفاع فنر','اندازه‌گیری ارتفاع خودرو',2),
('test:balljoint-play',   (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Test'),'instance','تست لقی سیبک','تکان دادن چرخ در هوا',2),
('test:bushing-visual',   (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Test'),'instance','بازرسی چشمی بوش','بررسی ترک و پارگی',2),
('test:wheel-alignment',  (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Test'),'instance','تست تنظیم فرمان','اندازه‌گیری زاویه چرخ',2),
('test:road-test',        (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Test'),'instance','تست جاده','رانندگی و گوش دادن به صدا',2);

-- ========== ۲. هفت رابطه tested_by ==========
INSERT INTO e01_222_01_tb (rel_uid, reltype_id, subj_ent_id, obj_ent_id, status, prv_id) VALUES
('r:shock-tested-bounce',(SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='tested_by'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='diagnosis:shock-failed'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='test:shock-bounce'),'asserted',2),
('r:shock-tested-leak',(SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='tested_by'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='diagnosis:shock-failed'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='test:shock-leak-visual'),'asserted',2),
('r:shock-tested-road',(SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='tested_by'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='diagnosis:shock-failed'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='test:road-test'),'asserted',2),
('r:spring-tested-height',(SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='tested_by'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='diagnosis:spring-failed'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='test:spring-height'),'asserted',2),
('r:balljoint-tested-play',(SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='tested_by'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='diagnosis:balljoint-failed'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='test:balljoint-play'),'asserted',2),
('r:bushing-tested-visual',(SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='tested_by'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='diagnosis:bushing-failed'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='test:bushing-visual'),'asserted',2),
('r:align-tested-wheel',(SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='tested_by'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='diagnosis:align-failed'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='test:wheel-alignment'),'asserted',2)
ON CONFLICT(rel_uid) DO NOTHING;

UPDATE e01_676_02_tb SET schema_ver = schema_ver + 1 WHERE id = 1;

COMMIT;

-- ========== گزارش ==========
SELECT 'entities' AS k, COUNT(*) AS n FROM e01_200_03_tb
UNION ALL SELECT 'relations', COUNT(*) FROM e01_222_01_tb;

SELECT '=== زنجیره تعلیق — تست‌ها ===' AS section;
SELECT 
  se.ent_uid AS from_entity,
  'tested_by' AS relation,
  oe.ent_uid AS to_entity
FROM e01_222_01_tb r
JOIN e01_202_01_tb rt ON rt.reltype_id = r.reltype_id AND rt.type_uid='tested_by'
JOIN e01_200_03_tb se ON se.ent_id = r.subj_ent_id
JOIN e01_200_03_tb oe ON oe.ent_id = r.obj_ent_id
WHERE se.ent_uid IN ('diagnosis:shock-failed','diagnosis:spring-failed','diagnosis:balljoint-failed','diagnosis:bushing-failed','diagnosis:align-failed')
ORDER BY se.ent_uid, oe.ent_uid;
