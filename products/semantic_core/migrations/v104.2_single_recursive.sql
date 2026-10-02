-- v104.2 — درخت کامل پراید احمدی با یک CTE واحد
.mode column
.headers on

WITH RECURSIVE walk(uid, kind, depth, path) AS (
  -- ═══ Seed 1: خود پراید (مفهوم) ═══
  SELECT 'concept:pride', 'root', 0, 'concept:pride'
  
  UNION ALL
  
  -- ═══ Seed 2: خودروی احمدی (نمونه) ═══
  SELECT 'vehicle:pride-24IR12345', 'instance', 0, 'vehicle:pride-24IR12345'
  
  UNION ALL
  
  -- ═══ قاعده A: از مفهوم به اجدادش (بالا، از طریق is_a) ═══
  SELECT obj.ent_uid, 'ancestor', w.depth + 1,
         w.path || ' ↑ ' || obj.ent_uid
  FROM walk w
  JOIN e01_200_03_tb sub ON sub.ent_uid = w.uid
  JOIN e01_222_01_tb r ON r.subj_ent_id = sub.ent_id 
    AND r.status='asserted' AND r.superseded_at IS NULL
  JOIN e01_202_01_tb rt ON rt.reltype_id = r.reltype_id AND rt.type_uid='is_a'
  JOIN e01_200_03_tb obj ON obj.ent_id = r.obj_ent_id
  WHERE w.kind IN ('root','instance')
    AND w.depth < 5
  
  UNION ALL
  
  -- ═══ قاعده B: از اجداد به لاجرم‌ها (پایین، از طریق inherent_to) ═══
  SELECT obj.ent_uid, 'inherent', w.depth + 1,
         w.path || ' ↓ ' || obj.ent_uid
  FROM walk w
  JOIN e01_200_03_tb sub ON sub.ent_uid = w.uid
  JOIN e01_222_01_tb r ON r.subj_ent_id = sub.ent_id 
    AND r.status='asserted' AND r.superseded_at IS NULL
  JOIN e01_202_01_tb rt ON rt.reltype_id = r.reltype_id AND rt.type_uid='inherent_to'
  JOIN e01_200_03_tb obj ON obj.ent_id = r.obj_ent_id
  WHERE w.kind IN ('root','ancestor','inherent')
    AND w.depth < 6
  
  UNION ALL
  
  -- ═══ قاعده C: از نمونه به انتخاب‌های خاص ═══
  SELECT obj.ent_uid, 'chosen', 99,
         w.path || ' ★ ' || obj.ent_uid
  FROM walk w
  JOIN e01_222_01_tb r ON r.subj_ent_id = (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid=w.uid)
    AND r.status='asserted' AND r.superseded_at IS NULL
  JOIN e01_202_01_tb rt ON rt.reltype_id = r.reltype_id AND rt.type_uid='has_direct_part'
  JOIN e01_200_03_tb obj ON obj.ent_id = r.obj_ent_id
  WHERE w.kind = 'instance'
)
SELECT 
  kind,
  COUNT(DISTINCT uid) AS n
FROM walk
GROUP BY kind;

SELECT '' AS x;
SELECT '═══ نمونه از هر دسته ═══' AS section;
SELECT kind, uid
FROM walk
WHERE uid IN (
  'concept:vehicle',
  'concept:chassis-domain',
  'concept:braking-subsystem',
  'concept:brake-pad',
  'concept:ac-compressor'
)
ORDER BY kind, uid;
