UPDATE e01_200_03_tb 
SET type_id = (SELECT type_id FROM e01_200_01_tb WHERE type_uid='PassengerCar'),
    updated_at = datetime('now')
WHERE ent_uid = 'vehicle:sample-1';

INSERT INTO e01_222_01_tb (rel_uid, reltype_id, subj_ent_id, obj_ent_id, status, prv_id)
SELECT
  'r:' || REPLACE(v.ent_uid, ':', '-') || '-instance-of',
  (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='instance_of'),
  v.ent_id,
  (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid =
    CASE 
      WHEN v.ent_uid='vehicle:pride-1' THEN 'concept:pride'
      WHEN v.ent_uid='vehicle:206-1' THEN 'concept:206'
      WHEN v.ent_uid='vehicle:dena-1' THEN 'concept:dena'
      WHEN v.ent_uid='vehicle:sample-1' THEN 'concept:passenger-car'
    END),
  'asserted', 2
FROM e01_200_03_tb v
WHERE v.ent_uid IN ('vehicle:pride-1','vehicle:206-1','vehicle:dena-1','vehicle:sample-1')
AND NOT EXISTS (
  SELECT 1 FROM e01_222_01_tb r 
  WHERE r.rel_uid = 'r:' || REPLACE(v.ent_uid, ':', '-') || '-instance-of'
);

UPDATE e01_676_02_tb SET schema_ver = schema_ver + 1 WHERE id = 1;

SELECT 'relations' AS k, COUNT(*) AS n FROM e01_222_01_tb;

SELECT '=== خودرو به مفهوم ===' AS section;
SELECT 
  sub.ent_uid AS vehicle_instance,
  obj.ent_uid AS concept
FROM e01_222_01_tb r
JOIN e01_202_01_tb rt ON rt.reltype_id = r.reltype_id AND rt.type_uid = 'instance_of'
JOIN e01_200_03_tb sub ON sub.ent_id = r.subj_ent_id
JOIN e01_200_03_tb obj ON obj.ent_id = r.obj_ent_id
WHERE sub.ent_uid LIKE 'vehicle:%'
ORDER BY sub.ent_uid;
