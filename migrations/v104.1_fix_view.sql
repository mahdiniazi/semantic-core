-- v104.1 — رفع circular reference
.mode column
.headers on

-- ═══════════════════════════════════════════════════════
-- view ۱: اجداد concept:pride (فقط is_a)
-- ═══════════════════════════════════════════════════════
DROP VIEW IF EXISTS v_pride_ancestors;
CREATE VIEW v_pride_ancestors AS
WITH RECURSIVE anc(uid, depth) AS (
  SELECT 'concept:pride', 0
  UNION
  SELECT obj.ent_uid, anc.depth + 1
  FROM anc
  JOIN e01_200_03_tb sub ON sub.ent_uid = anc.uid
  JOIN e01_222_01_tb r ON r.subj_ent_id = sub.ent_id 
    AND r.status='asserted' AND r.superseded_at IS NULL
  JOIN e01_202_01_tb rt ON rt.reltype_id = r.reltype_id AND rt.type_uid='is_a'
  JOIN e01_200_03_tb obj ON obj.ent_id = r.obj_ent_id
  WHERE anc.depth < 10
)
SELECT uid, depth FROM anc;

-- ═══════════════════════════════════════════════════════
-- view ۲: درخت پراید — لاجرم‌ها + انتخاب‌ها
-- ═══════════════════════════════════════════════════════
DROP VIEW IF EXISTS v_vehicle_tree;
CREATE VIEW v_vehicle_tree AS
-- بخش ۱: لاجرم‌های سطح ۱ (از اجداد)
SELECT 
  'concept:pride' AS from_entity,
  obj.ent_uid AS item_uid,
  obj.label AS item_label,
  'inherent' AS obligation,
  1 AS depth
FROM v_pride_ancestors a
JOIN e01_200_03_tb sub ON sub.ent_uid = a.uid
JOIN e01_222_01_tb r ON r.subj_ent_id = sub.ent_id 
  AND r.status='asserted' AND r.superseded_at IS NULL
JOIN e01_202_01_tb rt ON rt.reltype_id = r.reltype_id AND rt.type_uid='inherent_to'
JOIN e01_200_03_tb obj ON obj.ent_id = r.obj_ent_id

UNION

-- بخش ۲: انتخاب‌های احمدی
SELECT
  'vehicle:pride-24IR12345' AS from_entity,
  obj.ent_uid AS item_uid,
  obj.label AS item_label,
  'chosen' AS obligation,
  99 AS depth
FROM e01_222_01_tb r
JOIN e01_202_01_tb rt ON rt.reltype_id = r.reltype_id AND rt.type_uid='has_direct_part'
JOIN e01_200_03_tb obj ON obj.ent_id = r.obj_ent_id
WHERE r.subj_ent_id = (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='vehicle:pride-24IR12345')
  AND r.status='asserted' AND r.superseded_at IS NULL;

-- ═══════════════════════════════════════════════════════
-- گزارش
-- ═══════════════════════════════════════════════════════
SELECT '═══ آمار کلی ═══' AS section;
SELECT obligation, COUNT(*) AS n FROM v_vehicle_tree GROUP BY obligation;

SELECT '' AS x;
SELECT '═══ لاجرم‌ها (نمونه) ═══' AS section;
SELECT item_label FROM v_vehicle_tree 
WHERE obligation='inherent' 
ORDER BY item_label LIMIT 25;

SELECT '' AS x;
SELECT '═══ انتخاب‌های احمدی ═══' AS section;
SELECT item_label FROM v_vehicle_tree WHERE obligation='chosen';
