-- v130 — استخراج قواعد از may_have_direct_part
.mode column
.headers on

BEGIN;

-- ═══ استخراج قواعد may_have ═══
INSERT OR IGNORE INTO e01_200_04_tb (type_id, target_uid, placement_kind, note)
SELECT DISTINCT 
  obj.type_id, 
  subj.ent_uid, 
  'may_have_direct_part',
  'Extracted from may_have_direct_part'
FROM e01_222_01_tb r
JOIN e01_202_01_tb rt ON rt.reltype_id = r.reltype_id 
  AND rt.type_uid='may_have_direct_part'
JOIN e01_200_03_tb subj ON subj.ent_id = r.subj_ent_id
JOIN e01_200_03_tb obj ON obj.ent_id = r.obj_ent_id
WHERE subj.ent_uid LIKE 'concept:%-subsystem'
  AND r.status='asserted' AND r.superseded_at IS NULL;

INSERT OR IGNORE INTO e01_676_01_tb (migration_uid, notes)
VALUES ('v130_may_have_rules','Extracted may_have rules for placement');

UPDATE e01_676_02_tb SET schema_ver = schema_ver + 1 WHERE id = 1;

COMMIT;

-- ═══ گزارش ═══
SELECT placement_kind, COUNT(*) AS n 
FROM e01_200_04_tb 
GROUP BY placement_kind
ORDER BY n DESC;
