-- v111 — چهار لایه: inherent + design + may_have + chosen
.mode column
.headers on

WITH RECURSIVE walk(root_uid, uid, kind, depth) AS (
  -- Seed: BMW X5 instance → concept
  SELECT 'vehicle:bmw-x5-23DE66666', 'concept:bmw-x5', 'ancestor', 0
  UNION ALL
  -- Ancestors via is_a
  SELECT w.root_uid, obj.ent_uid, 'ancestor', w.depth + 1
  FROM walk w
  JOIN e01_200_03_tb sub ON sub.ent_uid = w.uid
  JOIN e01_222_01_tb r ON r.subj_ent_id = sub.ent_id 
    AND r.status='asserted' AND r.superseded_at IS NULL
  JOIN e01_202_01_tb rt ON rt.reltype_id = r.reltype_id AND rt.type_uid='is_a'
  JOIN e01_200_03_tb obj ON obj.ent_id = r.obj_ent_id
  WHERE w.kind='ancestor' AND w.depth < 5
  UNION ALL
  -- Inherent chain
  SELECT w.root_uid, obj.ent_uid, 'inherent', w.depth + 1
  FROM walk w
  JOIN e01_200_03_tb sub ON sub.ent_uid = w.uid
  JOIN e01_222_01_tb r ON r.subj_ent_id = sub.ent_id 
    AND r.status='asserted' AND r.superseded_at IS NULL
  JOIN e01_202_01_tb rt ON rt.reltype_id = r.reltype_id AND rt.type_uid='inherent_to'
  JOIN e01_200_03_tb obj ON obj.ent_id = r.obj_ent_id
  WHERE w.kind IN ('ancestor','inherent') AND w.depth < 8
  UNION ALL
  -- Design (فقط از concept اصلی BMW X5)
  SELECT w.root_uid, obj.ent_uid, 'design', 50
  FROM walk w
  JOIN e01_222_01_tb r ON r.subj_ent_id = (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='concept:bmw-x5')
    AND r.status='asserted' AND r.superseded_at IS NULL
  JOIN e01_202_01_tb rt ON rt.reltype_id = r.reltype_id AND rt.type_uid='designed_with'
  JOIN e01_200_03_tb obj ON obj.ent_id = r.obj_ent_id
  WHERE w.kind='ancestor' AND w.depth=0
  UNION ALL
  -- Chosen (فقط instance)
  SELECT w.root_uid, obj.ent_uid, 'chosen', 99
  FROM walk w
  JOIN e01_222_01_tb r ON r.subj_ent_id = (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='vehicle:bmw-x5-23DE66666')
    AND r.status='asserted' AND r.superseded_at IS NULL
  JOIN e01_202_01_tb rt ON rt.reltype_id = r.reltype_id AND rt.type_uid='has_direct_part'
  JOIN e01_200_03_tb obj ON obj.ent_id = r.obj_ent_id
  WHERE w.kind='ancestor' AND w.depth=0
)
-- ═══ گزارش در یک SELECT ═══
SELECT '۱-آمار' AS report, kind AS item, CAST(COUNT(DISTINCT uid) AS TEXT) AS detail
FROM walk GROUP BY kind

UNION ALL

SELECT '۲-اجداد', uid, (SELECT label FROM e01_200_03_tb WHERE ent_uid = uid)
FROM walk WHERE kind='ancestor' GROUP BY uid

UNION ALL

SELECT '۳-لاجرم (نمونه)', uid, (SELECT label FROM e01_200_03_tb WHERE ent_uid = uid)
FROM walk WHERE kind='inherent' GROUP BY uid LIMIT 15

UNION ALL

SELECT '۴-طراحی BMW X5', uid, (SELECT label FROM e01_200_03_tb WHERE ent_uid = uid)
FROM walk WHERE kind='design' GROUP BY uid

UNION ALL

SELECT '۵-انتخاب نمونه', uid, (SELECT label FROM e01_200_03_tb WHERE ent_uid = uid)
FROM walk WHERE kind='chosen' GROUP BY uid

ORDER BY report, item;
