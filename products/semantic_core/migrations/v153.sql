.mode column
.headers on

BEGIN;

-- ═══ گام ۱: ساخت ۲ type جدید ═══
INSERT OR IGNORE INTO e01_200_01_tb (type_uid, label, is_abstract)
VALUES 
  ('DiagnosticEpisode', 'اپیزود تشخیصی', 1),
  ('State', 'حالت خودرو', 1);

-- ═══ گام ۲: ساخت ۲ state ═══
INSERT OR IGNORE INTO e01_200_03_tb (ent_uid, type_id, nature, label, description, prv_id) VALUES
('state:cranking-cold', (SELECT type_id FROM e01_200_01_tb WHERE type_uid='State'), 'concept', 'استارت سرد', 'Cranking in cold weather', 2),
('state:idle-warm',     (SELECT type_id FROM e01_200_01_tb WHERE type_uid='State'), 'concept', 'درجا کارکردن گرم', 'Warm idle', 2);

-- ═══ گام ۳: ساخت episode اصلی ═══
INSERT OR IGNORE INTO e01_200_03_tb (ent_uid, type_id, nature, label, description, prv_id) VALUES
('episode:p0301-cold-start-2026', (SELECT type_id FROM e01_200_01_tb WHERE type_uid='DiagnosticEpisode'), 'concept', 'اپیزود P0301 — استارت سرد', 'Cold-start misfire diagnostic episode', 2);

-- ═══ گام ۴: قاعده‌ی جای‌گذاری برای دو type جدید ═══
INSERT OR IGNORE INTO e01_200_04_tb (type_id, target_uid, placement_kind, is_default, note) VALUES
((SELECT type_id FROM e01_200_01_tb WHERE type_uid='DiagnosticEpisode'), 'concept:vehicle', 'inherent_to', 1, 'rule for DiagnosticEpisode'),
((SELECT type_id FROM e01_200_01_tb WHERE type_uid='State'),              'concept:vehicle', 'inherent_to', 1, 'rule for State');

-- ═══ گام ۵: اتصال Episode به خودرو ═══
INSERT OR IGNORE INTO e01_222_01_tb (rel_uid, reltype_id, subj_ent_id, obj_ent_id, status, prv_id) VALUES
('r:episode-p0301-concerns-vehicle', 
 (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='concerns_vehicle'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='episode:p0301-cold-start-2026'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='vehicle:pride-24IR12345'),
 'asserted', 2);

-- ═══ گام ۶: اتصال Episode به State ═══
INSERT OR IGNORE INTO e01_222_01_tb (rel_uid, reltype_id, subj_ent_id, obj_ent_id, status, prv_id) VALUES
('r:episode-p0301-has-state-cranking-cold',
 (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='has_state'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='episode:p0301-cold-start-2026'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='state:cranking-cold'),
 'asserted', 2);

-- ═══ گام ۷: اتصال Episode به ۸ participant ═══
INSERT OR IGNORE INTO e01_222_01_tb (rel_uid, reltype_id, subj_ent_id, obj_ent_id, status, prv_id)
SELECT 
  'r:episode-p0301-participant-' || REPLACE(REPLACE(p.ent_uid, ':', '-'), ' ', '-'),
  (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='has_participant'),
  (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='episode:p0301-cold-start-2026'),
  p.ent_id,
  'asserted', 2
FROM e01_200_03_tb p
WHERE p.ent_uid IN (
  'hypothesis:p0301-coil-open',
  'evidence:p0301-resistance',
  'evidence:p0301-spark-ok',
  'observation:p0301-infinite',
  'measurement:resistance-inf',
  'test:p0301-coil-resistance',
  'diagnosis:p0301-ruled-out-coil',
  'verification:p0301-passed'
);

-- ═══ گام ۸: log + bump ═══
INSERT OR IGNORE INTO e01_676_01_tb (migration_uid, notes)
VALUES ('v153_diagnostic_episode', 'Created DiagnosticEpisode + State + 1 complete episode with 8 participants');

UPDATE e01_676_02_tb SET schema_ver = schema_ver + 1 WHERE id = 1;

COMMIT;

-- ═══ POST-CHECK ═══
SELECT '═══ ۱. Episode + State جدید ═══' AS section;
SELECT t.type_uid, COUNT(e.ent_id) AS n FROM e01_200_01_tb t LEFT JOIN e01_200_03_tb e ON e.type_id=t.type_id WHERE t.type_uid IN ('DiagnosticEpisode','State') GROUP BY t.type_uid;

SELECT '' AS x;
SELECT '═══ ۲. Episode connects ═══' AS section;
SELECT rt.type_uid, COUNT(*) AS n FROM e01_222_01_tb r JOIN e01_202_01_tb rt ON rt.reltype_id=r.reltype_id WHERE r.subj_ent_id = (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='episode:p0301-cold-start-2026') GROUP BY rt.type_uid ORDER BY n DESC;

SELECT '' AS x;
SELECT '═══ ۳. participants اپیزود P0301 ═══' AS section;
SELECT obj.ent_uid AS participant, obj.label
FROM e01_222_01_tb r
JOIN e01_202_01_tb rt ON rt.reltype_id=r.reltype_id AND rt.type_uid='has_participant'
JOIN e01_200_03_tb subj ON subj.ent_id=r.subj_ent_id
JOIN e01_200_03_tb obj ON obj.ent_id=r.obj_ent_id
WHERE subj.ent_uid = 'episode:p0301-cold-start-2026'
ORDER BY obj.ent_uid;

SELECT '' AS x;
SELECT '═══ ۴. وضعیت سلامت ═══' AS section;
SELECT severity, COUNT(*) AS n FROM e04_900_02_vw GROUP BY severity;
