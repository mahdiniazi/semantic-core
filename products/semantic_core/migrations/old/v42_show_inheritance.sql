-- v42 — نمایش ارث‌بری قطعات
.mode column
.headers on

-- همه قطعاتی که یک پراید باید داشته باشد
-- (از خودش + والدش + جدش)
WITH RECURSIVE
  chain(concept_uid, level) AS (
    SELECT 'concept:pride', 0
    UNION ALL
    SELECT obj.ent_uid, c.level + 1
    FROM chain c
    JOIN e01_200_03_tb sub ON sub.ent_uid = c.concept_uid
    JOIN e01_222_01_tb r ON r.subj_ent_id = sub.ent_id
    JOIN e01_202_01_tb rt ON rt.reltype_id = r.reltype_id AND rt.type_uid = 'is_a'
    JOIN e01_200_03_tb obj ON obj.ent_id = r.obj_ent_id
    WHERE c.level < 5
  ),
  parts AS (
    SELECT 
      c.concept_uid,
      c.level,
      obj.ent_uid AS part_uid,
      obj.label AS part_label
    FROM chain c
    JOIN e01_200_03_tb sub ON sub.ent_uid = c.concept_uid
    JOIN e01_222_01_tb r ON r.subj_ent_id = sub.ent_id
    JOIN e01_202_01_tb rt ON rt.reltype_id = r.reltype_id AND rt.type_uid = 'has_part'
    JOIN e01_200_03_tb obj ON obj.ent_id = r.obj_ent_id
  )
SELECT 
  concept_uid AS from_concept,
  level,
  part_uid,
  part_label
FROM parts
ORDER BY level, part_uid;
