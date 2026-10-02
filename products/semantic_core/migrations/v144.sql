.mode column
.headers on

BEGIN;

INSERT OR IGNORE INTO e01_222_01_tb 
  (rel_uid, reltype_id, subj_ent_id, obj_ent_id, status, prv_id)
SELECT
  'r:fm-bridge-' || REPLACE(REPLACE(specific.ent_uid, ':', '-'), ' ', '-') || '-to-' || REPLACE(REPLACE(generic.ent_uid, ':', '-'), ' ', '-'),
  (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid = 'is_a'),
  specific.ent_id,
  generic.ent_id,
  'asserted',
  2
FROM e01_200_03_tb specific
JOIN e01_200_03_tb generic ON 1=1
WHERE specific.ent_uid LIKE 'fm:%'
  AND specific.ent_uid NOT LIKE 'fm:generic-%'
  AND generic.ent_uid LIKE 'fm:generic-%'
  AND (
    (specific.ent_uid LIKE '%-open%'      AND generic.ent_uid = 'fm:generic-open')
    OR (specific.ent_uid LIKE '%-short%'  AND generic.ent_uid = 'fm:generic-short')
    OR (specific.ent_uid LIKE '%-stuck%'  AND generic.ent_uid = 'fm:generic-stuck-closed')
    OR (specific.ent_uid LIKE '%-dead%'   AND generic.ent_uid = 'fm:generic-dead')
    OR (specific.ent_uid LIKE '%-failed%' AND generic.ent_uid = 'fm:generic-failed')
    OR (specific.ent_uid LIKE '%-worn%'   AND generic.ent_uid = 'fm:generic-worn')
    OR (specific.ent_uid LIKE '%-dirty%'  AND generic.ent_uid = 'fm:generic-dirty')
    OR (specific.ent_uid LIKE '%-clog%'   AND generic.ent_uid = 'fm:generic-clogged')
    OR (specific.ent_uid LIKE '%-leak%'   AND generic.ent_uid = 'fm:generic-leaking')
    OR (specific.ent_uid LIKE '%-broken%' AND generic.ent_uid = 'fm:generic-broken')
    OR (specific.ent_uid LIKE '%-drift%'  AND generic.ent_uid = 'fm:generic-drift')
    OR (specific.ent_uid LIKE '%-noisy%'  AND generic.ent_uid = 'fm:generic-noisy')
    OR (specific.ent_uid LIKE '%-weak%'   AND generic.ent_uid = 'fm:generic-weak')
  );

INSERT OR IGNORE INTO e01_676_01_tb (migration_uid, notes)
VALUES ('v144_fm_bridge', 'Bridged specific FM to generic FM');

UPDATE e01_676_02_tb SET schema_ver = schema_ver + 1 WHERE id = 1;

COMMIT;

SELECT 'total_bridges' AS metric, COUNT(*) AS n FROM e01_222_01_tb r JOIN e01_202_01_tb rt ON rt.reltype_id=r.reltype_id AND rt.type_uid='is_a' JOIN e01_200_03_tb subj ON subj.ent_id=r.subj_ent_id WHERE subj.ent_uid LIKE 'fm:%' AND subj.ent_uid NOT LIKE 'fm:generic-%';

SELECT severity, COUNT(*) AS n FROM e04_900_02_vw GROUP BY severity;
