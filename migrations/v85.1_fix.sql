-- v85.1 — تکمیل مهاجرت با استثنای ۴ گروه
.mode column
.headers on

BEGIN;

-- بقیه → بنزینی (به‌جز خود ۴ گروه)
UPDATE e01_222_01_tb
SET obj_ent_id = (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='concept:passenger-car-petrol')
WHERE reltype_id = (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='is_a')
  AND obj_ent_id = (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='concept:passenger-car')
  AND subj_ent_id NOT IN (
    SELECT ent_id FROM e01_200_03_tb WHERE ent_uid IN (
      'concept:passenger-car-petrol','concept:passenger-car-diesel',
      'concept:passenger-car-hybrid','concept:passenger-car-ev'
    )
  )
  AND status='asserted' AND superseded_at IS NULL;

-- sample-1
UPDATE e01_222_01_tb
SET obj_ent_id = (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='concept:passenger-car-petrol')
WHERE reltype_id = (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='instance_of')
  AND obj_ent_id = (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='concept:passenger-car');

UPDATE e01_676_02_tb SET schema_ver = schema_ver + 1 WHERE id = 1;

COMMIT;

-- ═══════ گزارش ═══════
SELECT '=== توزیع نهایی ===' AS section;
SELECT parent.label AS fuel_group, COUNT(*) AS n_cars
FROM e01_222_01_tb r
JOIN e01_202_01_tb rt ON rt.reltype_id = r.reltype_id AND rt.type_uid='is_a'
JOIN e01_200_03_tb parent ON parent.ent_id = r.obj_ent_id
WHERE parent.ent_uid IN (
  'concept:passenger-car-petrol','concept:passenger-car-diesel',
  'concept:passenger-car-hybrid','concept:passenger-car-ev'
)
  AND r.status='asserted' AND r.superseded_at IS NULL
GROUP BY parent.ent_uid
ORDER BY n_cars DESC;

SELECT '=== باقیمانده در passenger-car (باید ۴ باشد = ۴ گروه) ===' AS section;
SELECT sub.label AS remaining, obj.label AS target
FROM e01_222_01_tb r
JOIN e01_202_01_tb rt ON rt.reltype_id = r.reltype_id AND rt.type_uid='is_a'
JOIN e01_200_03_tb sub ON sub.ent_id = r.subj_ent_id
JOIN e01_200_03_tb obj ON obj.ent_id = r.obj_ent_id
WHERE r.obj_ent_id = (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='concept:passenger-car')
  AND r.status='asserted' AND r.superseded_at IS NULL
ORDER BY sub.ent_uid;
