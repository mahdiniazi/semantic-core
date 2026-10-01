-- v98 — inherent_to در سطح خودرو و دامنه
.mode column
.headers on

BEGIN;

INSERT OR IGNORE INTO e01_222_01_tb (rel_uid, reltype_id, subj_ent_id, obj_ent_id, status, prv_id)
SELECT
  'r:inh-' || REPLACE(p.sub, 'concept:', '') || '-' || REPLACE(p.obj, 'concept:', ''),
  (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='inherent_to'),
  (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid=p.sub),
  (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid=p.obj),
  'asserted', 2
FROM (
  SELECT 'concept:vehicle' AS sub, 'concept:powertrain-domain' AS obj UNION ALL
  SELECT 'concept:vehicle', 'concept:chassis-domain' UNION ALL
  SELECT 'concept:vehicle', 'concept:body-domain' UNION ALL
  SELECT 'concept:powertrain-domain', 'concept:cooling-subsystem' UNION ALL
  SELECT 'concept:powertrain-domain', 'concept:transmission-subsystem' UNION ALL
  SELECT 'concept:chassis-domain', 'concept:braking-subsystem' UNION ALL
  SELECT 'concept:chassis-domain', 'concept:steering-subsystem' UNION ALL
  SELECT 'concept:chassis-domain', 'concept:suspension-subsystem' UNION ALL
  SELECT 'concept:chassis-domain', 'concept:wheel-subsystem' UNION ALL
  SELECT 'concept:body-domain', 'concept:lighting-subsystem' UNION ALL
  SELECT 'concept:body-domain', 'concept:comfort-subsystem' UNION ALL
  SELECT 'concept:body-domain', 'concept:dashboard-subsystem' UNION ALL
  SELECT 'concept:ee-architecture', 'concept:power-supply-subsystem' UNION ALL
  SELECT 'concept:ee-architecture', 'concept:starting-subsystem' UNION ALL
  SELECT 'concept:passenger-car-petrol', 'concept:ignition-subsystem' UNION ALL
  SELECT 'concept:passenger-car-petrol', 'concept:fuel-subsystem' UNION ALL
  SELECT 'concept:passenger-car-petrol', 'concept:exhaust-subsystem' UNION ALL
  SELECT 'concept:passenger-car-ev', 'concept:ev-subsystem'
) p
WHERE EXISTS (SELECT 1 FROM e01_200_03_tb WHERE ent_uid=p.sub)
  AND EXISTS (SELECT 1 FROM e01_200_03_tb WHERE ent_uid=p.obj)
  AND NOT EXISTS (
    SELECT 1 FROM e01_222_01_tb r
    WHERE r.rel_uid = 'r:inh-' || REPLACE(p.sub, 'concept:', '') || '-' || REPLACE(p.obj, 'concept:', '')
  );

INSERT OR IGNORE INTO e01_676_01_tb (migration_uid, notes)
VALUES ('v98_inherent_domains','Declared inherent domains and subsystems');

UPDATE e01_676_02_tb SET schema_ver = schema_ver + 1 WHERE id = 1;

COMMIT;

SELECT 'entities' AS k, COUNT(*) AS n FROM e01_200_03_tb
UNION ALL SELECT 'relations', COUNT(*) FROM e01_222_01_tb;

SELECT '=== inherent_to در سطح خودرو و دامنه ===' AS section;
SELECT 
  sub.label AS from_entity,
  obj.label AS has_inherently
FROM e01_222_01_tb r
JOIN e01_202_01_tb rt ON rt.reltype_id = r.reltype_id AND rt.type_uid='inherent_to'
JOIN e01_200_03_tb sub ON sub.ent_id = r.subj_ent_id
JOIN e01_200_03_tb obj ON obj.ent_id = r.obj_ent_id
WHERE r.status='asserted' AND r.superseded_at IS NULL
  AND sub.ent_uid IN ('concept:vehicle','concept:powertrain-domain','concept:chassis-domain','concept:body-domain','concept:ee-architecture','concept:passenger-car-petrol','concept:passenger-car-ev')
ORDER BY sub.label, obj.label;
