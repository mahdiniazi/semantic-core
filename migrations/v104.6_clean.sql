-- v104.6 — گزارش با ستون معنادار
.mode column
.headers on

WITH RECURSIVE walk(uid, kind, depth) AS (
  SELECT 'concept:pride', 'ancestor', 0
  UNION ALL
  SELECT 'vehicle:pride-24IR12345', 'instance', 0
  UNION ALL
  SELECT obj.ent_uid, 'ancestor', w.depth + 1
  FROM walk w
  JOIN e01_200_03_tb sub ON sub.ent_uid = w.uid
  JOIN e01_222_01_tb r ON r.subj_ent_id = sub.ent_id 
    AND r.status='asserted' AND r.superseded_at IS NULL
  JOIN e01_202_01_tb rt ON rt.reltype_id = r.reltype_id AND rt.type_uid='is_a'
  JOIN e01_200_03_tb obj ON obj.ent_id = r.obj_ent_id
  WHERE w.kind IN ('ancestor','instance') AND w.depth < 5
  UNION ALL
  SELECT obj.ent_uid, 'inherent', w.depth + 1
  FROM walk w
  JOIN e01_200_03_tb sub ON sub.ent_uid = w.uid
  JOIN e01_222_01_tb r ON r.subj_ent_id = sub.ent_id 
    AND r.status='asserted' AND r.superseded_at IS NULL
  JOIN e01_202_01_tb rt ON rt.reltype_id = r.reltype_id AND rt.type_uid='inherent_to'
  JOIN e01_200_03_tb obj ON obj.ent_id = r.obj_ent_id
  WHERE w.kind IN ('ancestor','inherent') AND w.depth < 8
  UNION ALL
  SELECT obj.ent_uid, 'chosen', 99
  FROM walk w
  JOIN e01_222_01_tb r ON r.subj_ent_id = (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid=w.uid)
    AND r.status='asserted' AND r.superseded_at IS NULL
  JOIN e01_202_01_tb rt ON rt.reltype_id = r.reltype_id AND rt.type_uid='has_direct_part'
  JOIN e01_200_03_tb obj ON obj.ent_id = r.obj_ent_id
  WHERE w.kind = 'instance'
)
-- ═══ هر گزارش با ستون معنادار ═══
-- آمار
SELECT '۱-آمار' AS report, kind AS item, CAST(COUNT(DISTINCT uid) AS TEXT) AS detail
FROM walk GROUP BY kind

UNION ALL

-- اجداد: با label فارسی
SELECT '۲-اجداد', uid, 
       (SELECT label FROM e01_200_03_tb WHERE ent_uid = uid)
FROM walk WHERE kind='ancestor' GROUP BY uid

UNION ALL

-- لاجرم‌ها: با label فارسی
SELECT '۳-لاجرم', uid, 
       (SELECT label FROM e01_200_03_tb WHERE ent_uid = uid)
FROM walk WHERE kind='inherent' GROUP BY uid

UNION ALL

-- انتخاب‌ها: با label فارسی
SELECT '۴-انتخاب', uid, 
       (SELECT label FROM e01_200_03_tb WHERE ent_uid = uid)
FROM walk WHERE kind='chosen' GROUP BY uid

ORDER BY report, item;
