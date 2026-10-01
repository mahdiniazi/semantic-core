.mode column
.headers on

BEGIN;

-- ۱. موجودیت‌های اختصاصی فرمان با نام متفاوت
INSERT OR IGNORE INTO e01_200_03_tb (ent_uid, type_id, nature, label, description, prv_id) VALUES
('procedure:replace-steering-pump',
 (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Procedure'),
 'instance','رویه: تعویض پمپ هیدرولیک فرمان','تعویض پمپ هیدرولیک فرمان',2),
('repair:steering-pump-replaced',
 (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Repair'),
 'instance','تعمیر: پمپ فرمان تعویض شد','پمپ هیدرولیک فرمان تعویض شد',2);

-- ۲. اصلاح relation که به ABS اشاره می‌کرد
UPDATE e01_222_01_tb
SET obj_ent_id = (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='procedure:replace-steering-pump')
WHERE rel_uid = 'r:hard-resolved-pump';

-- ۳. رابطه جدید: procedure → repair برای فرمان
INSERT OR IGNORE INTO e01_222_01_tb (rel_uid, reltype_id, subj_ent_id, obj_ent_id, status, prv_id) VALUES
('r:proc-steering-pump-repair',
 (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='resolved_by'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='procedure:replace-steering-pump'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='repair:steering-pump-replaced'),'asserted',2);

-- ۴. رابطه‌ای که در v50 رد شد را حالا با نام جدید بساز
INSERT OR IGNORE INTO e01_222_01_tb (rel_uid, reltype_id, subj_ent_id, obj_ent_id, status, prv_id) VALUES
('r:proc-steering-pump-repair-done',
 (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='resolved_by'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='procedure:replace-steering-pump'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='repair:steering-pump-replaced'),'asserted',2);

-- ۵. لاگ
INSERT OR IGNORE INTO e01_676_01_tb (migration_uid, notes)
VALUES ('v50.1_fix_pump_collision','Fixed name collision: pump (ABS) vs steering pump');

UPDATE e01_676_02_tb SET schema_ver = schema_ver + 1 WHERE id = 1;

COMMIT;

-- ========== گزارش ==========
SELECT 'entities' AS k, COUNT(*) AS n FROM e01_200_03_tb
UNION ALL SELECT 'relations', COUNT(*) FROM e01_222_01_tb;

SELECT '=== زنجیره فرمان (پمپ) ===' AS section;
SELECT 
  se.ent_uid AS from_entity,
  rt.type_uid AS relation,
  oe.ent_uid AS to_entity
FROM e01_222_01_tb r
JOIN e01_202_01_tb rt ON rt.reltype_id = r.reltype_id
JOIN e01_200_03_tb se ON se.ent_id = r.subj_ent_id
JOIN e01_200_03_tb oe ON oe.ent_id = r.obj_ent_id
WHERE se.ent_uid = 'diagnosis:hard-pump'
   OR oe.ent_uid LIKE '%steering-pump%'
   OR se.ent_uid LIKE '%steering-pump%'
ORDER BY se.ent_uid;
