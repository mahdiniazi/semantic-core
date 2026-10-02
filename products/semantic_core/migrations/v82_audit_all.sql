.mode column
.headers on

SELECT '═══ گام ۱: پیشرانه ═══' AS section;
SELECT sub.label AS subsystem, obj.label AS part
FROM e01_222_01_tb r
JOIN e01_202_01_tb rt ON rt.reltype_id = r.reltype_id AND rt.type_uid='has_part'
JOIN e01_200_03_tb sub ON sub.ent_id = r.subj_ent_id
JOIN e01_200_03_tb obj ON obj.ent_id = r.obj_ent_id
WHERE sub.ent_uid IN ('concept:ignition-subsystem','concept:fuel-subsystem',
                      'concept:cooling-subsystem','concept:exhaust-subsystem',
                      'concept:transmission-subsystem')
  AND r.status='asserted' AND r.superseded_at IS NULL
ORDER BY sub.ent_uid, obj.ent_uid;

SELECT '═══ گام ۲: شاسی ═══' AS section;
SELECT sub.label AS subsystem, obj.label AS part
FROM e01_222_01_tb r
JOIN e01_202_01_tb rt ON rt.reltype_id = r.reltype_id AND rt.type_uid='has_part'
JOIN e01_200_03_tb sub ON sub.ent_id = r.subj_ent_id
JOIN e01_200_03_tb obj ON obj.ent_id = r.obj_ent_id
WHERE sub.ent_uid IN ('concept:braking-subsystem','concept:steering-subsystem',
                      'concept:suspension-subsystem','concept:wheel-subsystem',
                      'concept:abs-subsystem')
  AND r.status='asserted' AND r.superseded_at IS NULL
ORDER BY sub.ent_uid, obj.ent_uid;

SELECT '═══ گام ۳: بدنه ═══' AS section;
SELECT sub.label AS subsystem, obj.label AS part
FROM e01_222_01_tb r
JOIN e01_202_01_tb rt ON rt.reltype_id = r.reltype_id AND rt.type_uid='has_part'
JOIN e01_200_03_tb sub ON sub.ent_id = r.subj_ent_id
JOIN e01_200_03_tb obj ON obj.ent_id = r.obj_ent_id
WHERE sub.ent_uid IN ('concept:lighting-subsystem','concept:comfort-subsystem',
                      'concept:hvac-subsystem','concept:airbag-subsystem',
                      'concept:dashboard-subsystem','concept:emergency-subsystem')
  AND r.status='asserted' AND r.superseded_at IS NULL
ORDER BY sub.ent_uid, obj.ent_uid;

SELECT '═══ گام ۴: ADAS + سرگرمی ═══' AS section;
SELECT sub.label AS subsystem, obj.label AS part
FROM e01_222_01_tb r
JOIN e01_202_01_tb rt ON rt.reltype_id = r.reltype_id AND rt.type_uid='has_part'
JOIN e01_200_03_tb sub ON sub.ent_id = r.subj_ent_id
JOIN e01_200_03_tb obj ON obj.ent_id = r.obj_ent_id
WHERE sub.ent_uid IN ('concept:adas-subsystem','concept:audio-subsystem')
  AND r.status='asserted' AND r.superseded_at IS NULL
ORDER BY sub.ent_uid, obj.ent_uid;

SELECT '═══ گام ۵: E/E ═══' AS section;
SELECT sub.label AS subsystem, obj.label AS part
FROM e01_222_01_tb r
JOIN e01_202_01_tb rt ON rt.reltype_id = r.reltype_id AND rt.type_uid='has_part'
JOIN e01_200_03_tb sub ON sub.ent_id = r.subj_ent_id
JOIN e01_200_03_tb obj ON obj.ent_id = r.obj_ent_id
WHERE sub.ent_uid IN ('concept:power-supply-subsystem','concept:starting-subsystem',
                      'concept:bus-subsystem','concept:sensor-subsystem',
                      'concept:ev-subsystem')
  AND r.status='asserted' AND r.superseded_at IS NULL
ORDER BY sub.ent_uid, obj.ent_uid;

SELECT '═══ گام ۶: DCU و ECUها ═══' AS section;
SELECT sub.label AS parent, obj.label AS child
FROM e01_222_01_tb r
JOIN e01_202_01_tb rt ON rt.reltype_id = r.reltype_id AND rt.type_uid='has_part'
JOIN e01_200_03_tb sub ON sub.ent_id = r.subj_ent_id
JOIN e01_200_03_tb obj ON obj.ent_id = r.obj_ent_id
WHERE sub.ent_uid LIKE 'concept:%-dcu'
  AND r.status='asserted' AND r.superseded_at IS NULL
ORDER BY sub.ent_uid, obj.ent_uid;
