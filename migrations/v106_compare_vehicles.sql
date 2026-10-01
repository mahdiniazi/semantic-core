-- v106 — مقایسه ۵ خودروی مختلف
.mode column
.headers on

WITH RECURSIVE walk(root_uid, uid, kind, depth) AS (
  -- Seed: instance → concept
  SELECT v.ent_uid, c.ent_uid, 'ancestor', 0
  FROM e01_200_03_tb v
  JOIN e01_222_01_tb r ON r.subj_ent_id = v.ent_id 
    AND r.status='asserted' AND r.superseded_at IS NULL
  JOIN e01_202_01_tb rt ON rt.reltype_id = r.reltype_id AND rt.type_uid='instance_of'
  JOIN e01_200_03_tb c ON c.ent_id = r.obj_ent_id
  WHERE v.ent_uid IN (
    'vehicle:pride-24IR12345',
    'vehicle:pride-24IR99999',
    'vehicle:tesla-m3-24US44444',
    'vehicle:bmw-x5-23DE66666',
    'vehicle:corolla-23JP33333'
  )
  
  UNION ALL
  
  -- is_a (بالا رفتن)
  SELECT w.root_uid, obj.ent_uid, 'ancestor', w.depth + 1
  FROM walk w
  JOIN e01_200_03_tb sub ON sub.ent_uid = w.uid
  JOIN e01_222_01_tb r ON r.subj_ent_id = sub.ent_id 
    AND r.status='asserted' AND r.superseded_at IS NULL
  JOIN e01_202_01_tb rt ON rt.reltype_id = r.reltype_id AND rt.type_uid='is_a'
  JOIN e01_200_03_tb obj ON obj.ent_id = r.obj_ent_id
  WHERE w.kind='ancestor' AND w.depth < 5
  
  UNION ALL
  
  -- inherent_to (پایین رفتن)
  SELECT w.root_uid, obj.ent_uid, 'inherent', w.depth + 1
  FROM walk w
  JOIN e01_200_03_tb sub ON sub.ent_uid = w.uid
  JOIN e01_222_01_tb r ON r.subj_ent_id = sub.ent_id 
    AND r.status='asserted' AND r.superseded_at IS NULL
  JOIN e01_202_01_tb rt ON rt.reltype_id = r.reltype_id AND rt.type_uid='inherent_to'
  JOIN e01_200_03_tb obj ON obj.ent_id = r.obj_ent_id
  WHERE w.kind IN ('ancestor','inherent') AND w.depth < 8
  
  UNION ALL
  
  -- chosen (فقط یک بار در سطح concept)
  SELECT w.root_uid, obj.ent_uid, 'chosen', 99
  FROM walk w
  JOIN e01_222_01_tb r ON r.subj_ent_id = (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid=w.root_uid)
    AND r.status='asserted' AND r.superseded_at IS NULL
  JOIN e01_202_01_tb rt ON rt.reltype_id = r.reltype_id AND rt.type_uid='has_direct_part'
  JOIN e01_200_03_tb obj ON obj.ent_id = r.obj_ent_id
  WHERE w.kind='ancestor' AND w.depth=0
)
SELECT 
  root_uid AS vehicle,
  kind,
  COUNT(DISTINCT uid) AS n
FROM walk
GROUP BY root_uid, kind
ORDER BY vehicle, kind;
