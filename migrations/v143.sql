.mode column
.headers on

BEGIN;

-- ═══ گام ۱: ساخت ۲۰۲ رابطه‌ی belongs_to_chain از plays_role_in ═══
INSERT OR IGNORE INTO e01_222_01_tb 
  (rel_uid, reltype_id, subj_ent_id, obj_ent_id, status, prv_id)
SELECT 
  'r:member-' || REPLACE(REPLACE(subj.ent_uid, ':', '-'), ' ', '-') 
              || '-in-' 
              || REPLACE(REPLACE(obj.ent_uid, ':', '-'), ' ', '-'),
  (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid = 'belongs_to_chain'),
  r.subj_ent_id,
  r.obj_ent_id,
  'asserted',
  COALESCE(r.prv_id, 2)
FROM e01_222_01_tb r
JOIN e01_202_01_tb rt ON rt.reltype_id = r.reltype_id
JOIN e01_200_03_tb subj ON subj.ent_id = r.subj_ent_id
JOIN e01_200_03_tb obj  ON obj.ent_id  = r.obj_ent_id
WHERE rt.type_uid = 'plays_role_in'
  AND r.superseded_at IS NULL;

-- ═══ گام ۲: حذف ۲۰۲ رابطه‌ی plays_role_in قدیمی ═══
DELETE FROM e01_222_01_tb 
WHERE reltype_id = (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid = 'plays_role_in');

-- ═══ گام ۳: علامت‌گذاری plays_role_in به‌عنوان deprecated ═══
UPDATE e01_202_01_tb 
SET label = 'deprecated — از belongs_to_chain استفاده کنید' 
WHERE type_uid = 'plays_role_in';

-- ═══ گام ۴: log + bump ═══
INSERT OR IGNORE INTO e01_676_01_tb (migration_uid, notes)
VALUES ('v143_replace_plays_role_in', 
        'Replaced 202 plays_role_in with belongs_to_chain');

UPDATE e01_676_02_tb SET schema_ver = schema_ver + 1 WHERE id = 1;

COMMIT;

-- ═══ POST-CHECK ═══
SELECT '═══ ۱. شمارش relationها ═══' AS section;
SELECT rt.type_uid, COUNT(r.rel_id) AS n
FROM e01_202_01_tb rt
LEFT JOIN e01_222_01_tb r ON r.reltype_id = rt.reltype_id
WHERE rt.type_uid IN ('plays_role','plays_role_in','belongs_to_chain','is_a','has_failure_mode')
GROUP BY rt.type_uid
ORDER BY n DESC;

SELECT '' AS x;
SELECT '═══ ۲. نمونه belongs_to_chain برای concept ═══' AS section;
SELECT subj.ent_uid AS concept, obj.ent_uid AS chain
FROM e01_222_01_tb r
JOIN e01_202_01_tb rt ON rt.reltype_id=r.reltype_id AND rt.type_uid='belongs_to_chain'
JOIN e01_200_03_tb subj ON subj.ent_id = r.subj_ent_id
JOIN e01_200_03_tb obj  ON obj.ent_id  = r.obj_ent_id
WHERE subj.ent_uid LIKE 'concept:%'
ORDER BY subj.ent_uid
LIMIT 10;

SELECT '' AS x;
SELECT '═══ ۳. نمونه belongs_to_chain برای DTC (قدیمی) ═══' AS section;
SELECT COUNT(*) AS dtc_in_chain
FROM e01_222_01_tb r
JOIN e01_202_01_tb rt ON rt.reltype_id=r.reltype_id AND rt.type_uid='belongs_to_chain'
JOIN e01_200_03_tb subj ON subj.ent_id = r.subj_ent_id
WHERE subj.ent_uid LIKE 'dtc:%';

SELECT '' AS x;
SELECT '═══ ۴. pending ═══' AS section;
SELECT status, COUNT(*) AS n FROM e01_200_05_tb GROUP BY status;

SELECT '' AS x;
SELECT '═══ ۵. سلامت ═══' AS section;
SELECT severity, COUNT(*) AS n FROM e04_900_02_vw GROUP BY severity;
