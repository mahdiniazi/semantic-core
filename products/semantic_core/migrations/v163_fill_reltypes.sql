-- v163: پر کردن reltype صفر — فقط اگر پیش‌نیاز موجود باشد
BEGIN;

INSERT OR IGNORE INTO e01_222_01_tb (rel_uid, reltype_id, subj_ent_id, obj_ent_id, status)
SELECT 'r:fm-' || SUBSTR(e.ent_uid, 4) || '-severity-high',
       (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='has_severity'),
       e.ent_id,
       (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='state:cold' LIMIT 1),
       'asserted'
FROM e01_200_03_tb e
WHERE e.ent_uid LIKE 'fm:%'
LIMIT 3;

INSERT OR IGNORE INTO e01_676_01_tb (migration_uid, notes)
VALUES ('v163_fill_reltypes','Fill zero reltypes');

COMMIT;
