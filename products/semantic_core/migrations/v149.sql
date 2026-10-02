.mode column
.headers on

BEGIN;

-- ═══ گام ۱: ساخت ۴ entity جدید ═══
INSERT OR IGNORE INTO e01_200_03_tb (ent_uid, type_id, nature, label, description, prv_id) VALUES
('evidence:p0301-spark-ok',          (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Evidence'),  'concept', 'شاهد مخالف: جرقه سالم', 'Spark visible — contradicts coil open', 2),
('diagnosis:p0301-ruled-out-coil',   (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Diagnosis'), 'concept', 'تشخیص: فرضیه کوئل رد شد', 'Coil hypothesis ruled out', 2),
('test:p0301-coil-resistance',       (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Test'),      'concept', 'تست: مقاومت کوئل', 'Coil resistance test', 2),
('verification:p0301-passed',        (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Vehicle'),   'concept', 'راستی‌آزمایی: موفق', 'Verification passed', 2);

-- ═══ گام ۲: رابطه‌ی contradicts (شاهد مخالف) ═══
INSERT OR IGNORE INTO e01_222_01_tb (rel_uid, reltype_id, subj_ent_id, obj_ent_id, status, prv_id) VALUES
('r:evidence-p0301-spark-contradicts-coil-open',
 (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='contradicts'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='evidence:p0301-spark-ok'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='hypothesis:p0301-coil-open'),
 'asserted', 2);

-- ═══ گام ۳: رابطه‌ی ruled_out (فرضیه رد شد) ═══
INSERT OR IGNORE INTO e01_222_01_tb (rel_uid, reltype_id, subj_ent_id, obj_ent_id, status, prv_id) VALUES
('r:diagnosis-p0301-ruled-out-coil-open',
 (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='ruled_out'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='diagnosis:p0301-ruled-out-coil'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='hypothesis:p0301-coil-open'),
 'asserted', 2);

-- ═══ گام ۴: رابطه‌ی verified_by (راستی‌آزمایی) ═══
INSERT OR IGNORE INTO e01_222_01_tb (rel_uid, reltype_id, subj_ent_id, obj_ent_id, status, prv_id) VALUES
('r:verification-p0301-passed-verified-by-coil-resistance',
 (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='verified_by'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='verification:p0301-passed'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='test:p0301-coil-resistance'),
 'asserted', 2);

-- ═══ گام ۵: log + bump ═══
INSERT OR IGNORE INTO e01_676_01_tb (migration_uid, notes)
VALUES ('v149_contradicts_ruled_out_verified',
        'Activated contradicts, ruled_out, verified_by with P0301 examples');

UPDATE e01_676_02_tb SET schema_ver = schema_ver + 1 WHERE id = 1;

COMMIT;

-- ═══ POST-CHECK ═══
SELECT '═══ ۱. سه رابطه‌ی فعال‌شده ═══' AS section;
SELECT rt.type_uid, COUNT(r.rel_id) AS n
FROM e01_202_01_tb rt
LEFT JOIN e01_222_01_tb r ON r.reltype_id = rt.reltype_id
WHERE rt.type_uid IN ('contradicts','ruled_out','verified_by')
GROUP BY rt.type_uid
ORDER BY rt.type_uid;

SELECT '' AS x;
SELECT '═══ ۲. نمونه contradicts ═══' AS section;
SELECT subj.ent_uid AS evidence, obj.ent_uid AS hypothesis
FROM e01_222_01_tb r
JOIN e01_202_01_tb rt ON rt.reltype_id=r.reltype_id AND rt.type_uid='contradicts'
JOIN e01_200_03_tb subj ON subj.ent_id=r.subj_ent_id
JOIN e01_200_03_tb obj ON obj.ent_id=r.obj_ent_id;

SELECT '' AS x;
SELECT '═══ ۳. نمونه ruled_out ═══' AS section;
SELECT subj.ent_uid AS diagnosis, obj.ent_uid AS hypothesis
FROM e01_222_01_tb r
JOIN e01_202_01_tb rt ON rt.reltype_id=r.reltype_id AND rt.type_uid='ruled_out'
JOIN e01_200_03_tb subj ON subj.ent_id=r.subj_ent_id
JOIN e01_200_03_tb obj ON obj.ent_id=r.obj_ent_id;

SELECT '' AS x;
SELECT '═══ ۴. نمونه verified_by ═══' AS section;
SELECT subj.ent_uid AS verification, obj.ent_uid AS test
FROM e01_222_01_tb r
JOIN e01_202_01_tb rt ON rt.reltype_id=r.reltype_id AND rt.type_uid='verified_by'
JOIN e01_200_03_tb subj ON subj.ent_id=r.subj_ent_id
JOIN e01_200_03_tb obj ON obj.ent_id=r.obj_ent_id;

SELECT '' AS x;
SELECT '═══ ۵. pending و health ═══' AS section;
SELECT 'pending' AS metric, COUNT(*) AS n FROM e01_200_05_tb WHERE status='pending'
UNION ALL SELECT 'watch', COUNT(*) FROM e04_900_02_vw WHERE severity='watch'
UNION ALL SELECT 'critical', COUNT(*) FROM e04_900_02_vw WHERE severity='critical';

SELECT '' AS x;
SELECT severity, COUNT(*) AS n FROM e04_900_02_vw GROUP BY severity;
