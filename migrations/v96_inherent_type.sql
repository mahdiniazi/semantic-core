-- v96 — inherent_to لایه نوع-به-نوع (universal)
.mode column
.headers on

BEGIN;

-- ═══════════════════════════════════════════════════════
-- ۱. توجه: inherent_to روی type کار می‌کند، نه entity
-- ولی e01_222_01_tb روی ent_id کار می‌کند.
-- پس باید نوع‌ها را هم به عنوان entity نشان دهیم.
-- ═══════════════════════════════════════════════════════

-- ببینیم کدام typeها entity معادل دارند
SELECT 'types_with_entity' AS metric, COUNT(*) AS n
FROM e01_200_01_tb t
WHERE EXISTS (
  SELECT 1 FROM e01_200_03_tb e WHERE e.type_id = t.type_id
);

SELECT 'types_without_entity' AS metric, COUNT(*) AS n
FROM e01_200_01_tb t
WHERE NOT EXISTS (
  SELECT 1 FROM e01_200_03_tb e WHERE e.type_id = t.type_id
);

-- ═══════════════════════════════════════════════════════
-- ۲. ساخت concept برای typeهای مهم (لایه نوع)
-- ═══════════════════════════════════════════════════════
INSERT OR IGNORE INTO e01_200_03_tb (ent_uid, type_id, nature, label, description, prv_id)
SELECT 'type:' || t.type_uid,
       t.type_id,
       'concept',
       t.label,
       'Type-as-concept (for inherent_to)',
       2
FROM e01_200_01_tb t
WHERE t.type_uid IN (
  'Vehicle', 'Unit', 'ECU', 'Sensor', 'Actuator',
  'PassengerCar', 'Motorcycle', 'Truck', 'Bus',
  'EngineECU', 'BodyECU', 'ABS_ECU', 'TransmissionECU'
);

-- ═══════════════════════════════════════════════════════
-- ۳. اعلام روابط inherent_to
-- ═══════════════════════════════════════════════════════
INSERT OR IGNORE INTO e01_222_01_tb (rel_uid, reltype_id, subj_ent_id, obj_ent_id, status, prv_id)
SELECT
  'r:' || REPLACE(p.from_type, ':', '-') || '-inh-' || REPLACE(p.to_type, ':', '-'),
  (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='inherent_to'),
  (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid=p.from_type),
  (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid=p.to_type),
  'asserted', 2
FROM (
  -- هر خودرویی
  SELECT 'type:Vehicle' AS from_type, 'type:Unit' AS to_type UNION ALL
  -- هر سواری‌ای
  SELECT 'type:PassengerCar',          'type:EngineECU' UNION ALL
  -- هر ECU یکی از انواع است
  SELECT 'type:EngineECU',             'type:ECU' UNION ALL
  SELECT 'type:BodyECU',               'type:ECU' UNION ALL
  SELECT 'type:ABS_ECU',               'type:ECU' UNION ALL
  SELECT 'type:TransmissionECU',       'type:ECU' UNION ALL
  -- هر سنسوری
  SELECT 'type:Sensor',                'type:Unit' UNION ALL
  -- هر عملگری
  SELECT 'type:Actuator',              'type:Unit'
) p
WHERE EXISTS (SELECT 1 FROM e01_200_03_tb WHERE ent_uid=p.from_type)
  AND EXISTS (SELECT 1 FROM e01_200_03_tb WHERE ent_uid=p.to_type)
  AND NOT EXISTS (
    SELECT 1 FROM e01_222_01_tb r
    WHERE r.rel_uid = 'r:' || REPLACE(p.from_type, ':', '-') || '-inh-' || REPLACE(p.to_type, ':', '-')
  );

INSERT OR IGNORE INTO e01_676_01_tb (migration_uid, notes)
VALUES ('v96_inherent_type','Type-level inherent_to relations');

UPDATE e01_676_02_tb SET schema_ver = schema_ver + 1 WHERE id = 1;

COMMIT;

-- ═══════════════════════════════════════════════════════
-- گزارش
-- ═══════════════════════════════════════════════════════
SELECT 'entities' AS k, COUNT(*) AS n FROM e01_200_03_tb
UNION ALL SELECT 'relations', COUNT(*) FROM e01_222_01_tb;

SELECT '=== روابط inherent_to ===' AS section;
SELECT 
  sub.label AS from_type,
  obj.label AS to_type
FROM e01_222_01_tb r
JOIN e01_202_01_tb rt ON rt.reltype_id = r.reltype_id AND rt.type_uid='inherent_to'
JOIN e01_200_03_tb sub ON sub.ent_id = r.subj_ent_id
JOIN e01_200_03_tb obj ON obj.ent_id = r.obj_ent_id
WHERE r.status='asserted' AND r.superseded_at IS NULL
ORDER BY sub.label, obj.label;
