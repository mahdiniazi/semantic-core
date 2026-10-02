-- v85 — شکستن passenger-car به چهار گروه سوختی
.mode column
.headers on

BEGIN;

INSERT OR IGNORE INTO e01_200_03_tb (ent_uid, type_id, nature, label, description, prv_id) VALUES
('concept:passenger-car-petrol',(SELECT type_id FROM e01_200_01_tb WHERE type_uid='PassengerCar'),'concept','سواری بنزینی','Petrol passenger car',2),
('concept:passenger-car-diesel',(SELECT type_id FROM e01_200_01_tb WHERE type_uid='PassengerCar'),'concept','سواری دیزلی','Diesel passenger car',2),
('concept:passenger-car-hybrid',(SELECT type_id FROM e01_200_01_tb WHERE type_uid='PassengerCar'),'concept','سواری هیبرید','Hybrid passenger car',2),
('concept:passenger-car-ev',    (SELECT type_id FROM e01_200_01_tb WHERE type_uid='PassengerCar'),'concept','سواری برقی','Electric passenger car',2);

INSERT OR IGNORE INTO e01_222_01_tb (rel_uid, reltype_id, subj_ent_id, obj_ent_id, status, prv_id)
SELECT
  'r:' || REPLACE(p.sub_uid, ':', '-') || '-is-a-parent',
  (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='is_a'),
  (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid=p.sub_uid),
  (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='concept:passenger-car'),
  'asserted', 2
FROM (
  SELECT 'concept:passenger-car-petrol' AS sub_uid UNION ALL
  SELECT 'concept:passenger-car-diesel' UNION ALL
  SELECT 'concept:passenger-car-hybrid' UNION ALL
  SELECT 'concept:passenger-car-ev'
) p
WHERE NOT EXISTS (
  SELECT 1 FROM e01_222_01_tb r 
  WHERE r.rel_uid = 'r:' || REPLACE(p.sub_uid, ':', '-') || '-is-a-parent'
);

UPDATE e01_222_01_tb
SET obj_ent_id = (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='concept:passenger-car-ev')
WHERE reltype_id = (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='is_a')
  AND obj_ent_id = (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='concept:passenger-car')
  AND subj_ent_id IN (
    SELECT ent_id FROM e01_200_03_tb WHERE ent_uid IN (
      'concept:tesla-model-3','concept:tesla-model-s','concept:tesla-model-x','concept:tesla-model-y',
      'concept:nissan-leaf','concept:chevrolet-bolt','concept:hyundai-ioniq-5','concept:kia-ev6',
      'concept:byd-han','concept:byd-song','concept:nio-suv','concept:xpeng-p7',
      'concept:jaguar-ipace','concept:lotus-evija','concept:mg-mg4',
      'concept:skoda-enyaq','concept:cupra-born','concept:dacia-spring','concept:byd-atto3'
    )
  );

UPDATE e01_222_01_tb
SET obj_ent_id = (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='concept:passenger-car-hybrid')
WHERE reltype_id = (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='is_a')
  AND obj_ent_id = (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='concept:passenger-car')
  AND subj_ent_id IN (
    SELECT ent_id FROM e01_200_03_tb WHERE ent_uid IN (
      'concept:toyota-camry','concept:toyota-corolla','concept:honda-accord',
      'concept:toyota-rav4','concept:hyundai-sonata','concept:kia-optima'
    )
  );

UPDATE e01_222_01_tb
SET obj_ent_id = (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='concept:passenger-car-petrol')
WHERE reltype_id = (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='is_a')
  AND obj_ent_id = (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='concept:passenger-car');

UPDATE e01_222_01_tb
SET obj_ent_id = (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='concept:passenger-car-petrol')
WHERE reltype_id = (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='instance_of')
  AND obj_ent_id = (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='concept:passenger-car');

INSERT OR IGNORE INTO e01_676_01_tb (migration_uid, notes)
VALUES ('v85_fuel_split','Split passenger-car into 4 fuel groups');

UPDATE e01_676_02_tb SET schema_ver = schema_ver + 1 WHERE id = 1;

COMMIT;

SELECT '=== توزیع ===' AS section;
SELECT 
  parent.label AS fuel_group,
  COUNT(*) AS n_cars
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

SELECT '=== باقیمانده ===' AS section;
SELECT COUNT(*) AS remaining
FROM e01_222_01_tb r
WHERE r.reltype_id = (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='is_a')
  AND r.obj_ent_id = (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='concept:passenger-car')
  AND r.status='asserted' AND r.superseded_at IS NULL;
