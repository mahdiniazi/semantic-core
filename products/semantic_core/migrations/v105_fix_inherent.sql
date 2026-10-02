-- v105 — تکمیل inherent_to برای E/E و زیرسیستم‌های حیاتی
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
  -- ═══ Vehicle لاجرم EE-architecture دارد ═══
  SELECT 'concept:vehicle' AS sub, 'concept:ee-architecture' AS obj UNION ALL
  
  -- ═══ هر سواری بنزینی لاجرم ECU، سنسور، شبکه دارد ═══
  SELECT 'concept:passenger-car-petrol', 'concept:ecu-subsystem' UNION ALL
  SELECT 'concept:passenger-car-petrol', 'concept:sensor-subsystem' UNION ALL
  SELECT 'concept:passenger-car-petrol', 'concept:bus-subsystem' UNION ALL
  
  -- ═══ EE-architecture لاجرم زیرسیستم‌ها ═══
  SELECT 'concept:ee-architecture', 'concept:power-supply-subsystem' UNION ALL
  SELECT 'concept:ee-architecture', 'concept:starting-subsystem' UNION ALL
  
  -- ═══ ecu-subsystem لاجرم engine-ecu ═══
  SELECT 'concept:ecu-subsystem', 'concept:engine-ecu'
) p
WHERE EXISTS (SELECT 1 FROM e01_200_03_tb WHERE ent_uid=p.sub)
  AND EXISTS (SELECT 1 FROM e01_200_03_tb WHERE ent_uid=p.obj)
  AND NOT EXISTS (
    SELECT 1 FROM e01_222_01_tb r
    WHERE r.rel_uid = 'r:inh-' || REPLACE(p.sub, 'concept:', '') || '-' || REPLACE(p.obj, 'concept:', '')
  );

INSERT OR IGNORE INTO e01_676_01_tb (migration_uid, notes)
VALUES ('v105_fix_inherent','Added missing inherent_to for E/E architecture and subsystems');

UPDATE e01_676_02_tb SET schema_ver = schema_ver + 1 WHERE id = 1;

COMMIT;

-- ═══ گزارش ═══
SELECT '=== inherent_to جدید ===' AS section;
SELECT 
  sub.label AS from_entity,
  obj.label AS has_inherently
FROM e01_222_01_tb r
JOIN e01_202_01_tb rt ON rt.reltype_id = r.reltype_id AND rt.type_uid='inherent_to'
JOIN e01_200_03_tb sub ON sub.ent_id = r.subj_ent_id
JOIN e01_200_03_tb obj ON obj.ent_id = r.obj_ent_id
WHERE sub.ent_uid IN ('concept:vehicle','concept:passenger-car-petrol','concept:ee-architecture','concept:ecu-subsystem')
  AND r.status='asserted' AND r.superseded_at IS NULL
ORDER BY sub.label, obj.label;
