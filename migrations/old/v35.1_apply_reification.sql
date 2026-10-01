UPDATE e01_222_01_tb SET reif_type = 'none', reif_ent_id = NULL;

INSERT OR IGNORE INTO e01_200_03_tb (ent_uid, type_id, nature, label, description, prv_id)
SELECT 
  'reif:' || r.rel_uid,
  (SELECT type_id FROM e01_200_01_tb WHERE type_uid='ReifiedRelation'),
  'instance',
  'Reified: ' || r.rel_uid,
  'Reified relation',
  2
FROM e01_222_01_tb r
JOIN e01_202_02_tb c ON c.reltype_id = r.reltype_id
WHERE c.reify_rule = 'always'
  AND NOT EXISTS (SELECT 1 FROM e01_200_03_tb e WHERE e.ent_uid = 'reif:' || r.rel_uid);

UPDATE e01_222_01_tb
SET reif_type = 'annotated',
    reif_ent_id = (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid = 'reif:' || e01_222_01_tb.rel_uid)
WHERE reltype_id IN (SELECT reltype_id FROM e01_202_02_tb WHERE reify_rule = 'always')
  AND EXISTS (SELECT 1 FROM e01_200_03_tb WHERE ent_uid = 'reif:' || e01_222_01_tb.rel_uid);

UPDATE e01_676_02_tb SET schema_ver = schema_ver + 1 WHERE id = 1;

SELECT 'entities' AS k, COUNT(*) AS n FROM e01_200_03_tb
UNION ALL SELECT 'reified_entities', COUNT(*) FROM e01_200_03_tb WHERE ent_uid LIKE 'reif:%'
UNION ALL SELECT 'relations_annotated', COUNT(*) FROM e01_222_01_tb WHERE reif_type = 'annotated'
UNION ALL SELECT 'relations_none', COUNT(*) FROM e01_222_01_tb WHERE reif_type = 'none';
