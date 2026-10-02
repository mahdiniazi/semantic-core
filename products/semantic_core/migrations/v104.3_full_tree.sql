-- v104.3 — درخت کامل با CTE واحد و قاعده اصلاح‌شده
.mode column
.headers on

WITH RECURSIVE walk(uid, kind, depth) AS (
  -- ═══ Seed: خود پراید (مفهوم) + خودروی احمدی (نمونه) ═══
  SELECT 'concept:pride', 'ancestor', 0
  UNION ALL
  SELECT 'vehicle:pride-24IR12345', 'instance', 0
  UNION ALL
  -- ═══ قاعده A: اجداد (از طریق is_a) — هم از root و هم از ancestor ═══
  SELECT obj.ent_uid, 'ancestor', w.depth + 1
  FROM walk w
  JOIN e01_200_03_tb sub ON sub.ent_uid = w.uid
  JOIN e01_222_01_tb r ON r.subj_ent_id = sub.ent_id 
    AND r.status='asserted' AND r.superseded_at IS NULL
  JOIN e01_202_01_tb rt ON rt.reltype_id = r.reltype_id AND rt.type_uid='is_a'
  JOIN e01_200_03_tb obj ON obj.ent_id = r.obj_ent_id
  WHERE w.kind IN ('ancestor','instance')    -- ← اضافه شد
    AND w.depth < 5
  UNION ALL
  -- ═══ قاعده B: لاجرم‌ها (از طریق inherent_to) ═══
  SELECT obj.ent_uid, 'inherent', w.depth + 1
  FROM walk w
  JOIN e01_200_03_tb sub ON sub.ent_uid = w.uid
  JOIN e01_222_01_tb r ON r.subj_ent_id = sub.ent_id 
    AND r.status='asserted' AND r.superseded_at IS NULL
  JOIN e01_202_01_tb rt ON rt.reltype_id = r.reltype_id AND rt.type_uid='inherent_to'
  JOIN e01_200_03_tb obj ON obj.ent_id = r.obj_ent_id
  WHERE w.kind IN ('ancestor','inherent')
    AND w.depth < 8
  UNION ALL
  -- ═══ قاعده C: انتخاب‌های احمدی ═══
  SELECT obj.ent_uid, 'chosen', 99
  FROM walk w
  JOIN e01_222_01_tb r ON r.subj_ent_id = (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid=w.uid)
    AND r.status='asserted' AND r.superseded_at IS NULL
  JOIN e01_202_01_tb rt ON rt.reltype_id = r.reltype_id AND rt.type_uid='has_direct_part'
  JOIN e01_200_03_tb obj ON obj.ent_id = r.obj_ent_id
  WHERE w.kind = 'instance'
)
SELECT kind, COUNT(DISTINCT uid) AS n
FROM walk
GROUP BY kind;

SELECT '' AS x;
SELECT '═══ اجداد پراید ═══' AS section;
SELECT DISTINCT uid FROM walk WHERE kind='ancestor' ORDER BY uid;

SELECT '' AS x;
SELECT '═══ نمونه‌ای از لاجرم‌ها ═══' AS section;
SELECT DISTINCT uid FROM walk WHERE kind='inherent' ORDER BY uid LIMIT 20;

SELECT '' AS x;
SELECT '═══ انتخاب‌های احمدی ═══' AS section;
SELECT DISTINCT uid FROM walk WHERE kind='chosen';
