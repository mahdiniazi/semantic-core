-- v76 — رفع تداخل concept:seat + افزودن صندلی واقعی
.mode column
.headers on

BEGIN;

-- =====================================================================
-- ۱. تغییر نام برند SEAT به concept:seat-brand
-- =====================================================================
UPDATE e01_200_03_tb 
SET ent_uid = 'concept:seat-brand',
    label = 'سئات (برند)',
    updated_at = datetime('now')
WHERE ent_uid = 'concept:seat'
  AND label = 'سئات';

-- =====================================================================
-- ۲. حالا concept:seat واقعاً برای صندلی
-- =====================================================================
INSERT OR IGNORE INTO e01_200_03_tb (ent_uid, type_id, nature, label, description, prv_id) VALUES
('concept:seat',
 (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Seat'),
 'concept','صندلی','صندلی خودرو',2);

-- =====================================================================
-- ۳. اگر concept:seat هنوز وجود دارد (به‌عنوان صندلی)
-- =====================================================================
SELECT 'seat_uid' AS k, ent_uid AS v FROM e01_200_03_tb WHERE ent_uid IN ('concept:seat','concept:seat-brand');

-- =====================================================================
-- ۴. اتصال صندلی به vehicle
-- =====================================================================
INSERT OR IGNORE INTO e01_222_01_tb (rel_uid, reltype_id, subj_ent_id, obj_ent_id, status, prv_id)
VALUES
('r:vehicle-has-seat',
 (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='has_part'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='concept:vehicle'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='concept:seat'),
 'asserted', 2);

-- =====================================================================
-- ۵. تشخیص تداخل‌های دیگر
-- =====================================================================
SELECT '=== بررسی تداخل برندها و قطعات ===' AS section;
SELECT 
  e.ent_uid,
  e.label,
  t.type_uid AS type
FROM e01_200_03_tb e
JOIN e01_200_01_tb t ON t.type_id = e.type_id
WHERE e.ent_uid IN ('concept:seat','concept:seat-brand','concept:mini','concept:mg')
ORDER BY e.ent_uid;

-- =====================================================================
-- ۶. لاگ
-- =====================================================================
INSERT OR IGNORE INTO e01_676_01_tb (migration_uid, notes)
VALUES ('v76_fix_seat_collision','Fixed concept:seat collision (SEAT brand vs car seat)');

UPDATE e01_676_02_tb SET schema_ver = schema_ver + 1 WHERE id = 1;

COMMIT;

-- =====================================================================
-- گزارش
-- =====================================================================
SELECT 'entities' AS k, COUNT(*) AS n FROM e01_200_03_tb
UNION ALL SELECT 'relations', COUNT(*) FROM e01_222_01_tb;

SELECT '=== بررسی نهایی صندلی ===' AS section;
SELECT 
  e.ent_uid,
  e.label,
  CASE WHEN e.ent_id IN (
    SELECT obj.ent_id FROM e01_222_01_tb r
    JOIN e01_202_01_tb rt ON rt.reltype_id = r.reltype_id AND rt.type_uid='has_part'
    JOIN e01_200_03_tb obj ON obj.ent_id = r.obj_ent_id
  ) THEN 'مضاف' ELSE 'یتیم' END AS status
FROM e01_200_03_tb e
WHERE e.ent_uid IN ('concept:seat','concept:seat-brand')
ORDER BY e.ent_uid;
