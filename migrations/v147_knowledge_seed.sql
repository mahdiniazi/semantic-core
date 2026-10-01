.mode column
.headers on

BEGIN;

-- ═══ گام ۱: ساخت concept:knowledge-base (namespace) ═══
INSERT OR IGNORE INTO e01_200_03_tb (ent_uid, type_id, nature, label, description, prv_id)
SELECT 'concept:knowledge-base', type_id, 'concept', 'پایگاه دانش', 'Namespace for Knowledge Layer entities', 2
FROM e01_200_03_tb WHERE ent_uid = 'concept:vehicle';

-- ═══ گام ۲: قواعد جای‌گذاری برای ۶ type ═══
INSERT OR IGNORE INTO e01_200_04_tb (type_id, target_uid, placement_kind, is_default, note) VALUES
((SELECT type_id FROM e01_200_01_tb WHERE type_uid='Hypothesis'),    'concept:knowledge-base', 'inherent_to', 1, 'auto-place Hypothesis'),
((SELECT type_id FROM e01_200_01_tb WHERE type_uid='Evidence'),      'concept:knowledge-base', 'inherent_to', 1, 'auto-place Evidence'),
((SELECT type_id FROM e01_200_01_tb WHERE type_uid='Observation'),   'concept:knowledge-base', 'inherent_to', 1, 'auto-place Observation'),
((SELECT type_id FROM e01_200_01_tb WHERE type_uid='Measurement'),   'concept:knowledge-base', 'inherent_to', 1, 'auto-place Measurement'),
((SELECT type_id FROM e01_200_01_tb WHERE type_uid='Signal'),        'concept:knowledge-base', 'inherent_to', 1, 'auto-place Signal'),
((SELECT type_id FROM e01_200_01_tb WHERE type_uid='Configuration'), 'concept:knowledge-base', 'inherent_to', 1, 'auto-place Configuration');

-- ═══ گام ۳: ساخت ۶ seed entity ═══
INSERT OR IGNORE INTO e01_200_03_tb (ent_uid, type_id, nature, label, description, prv_id) VALUES
('hypothesis:p0301-coil-open',  (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Hypothesis'),    'concept', 'فرضیه: کوئل قطع', 'Coil open causes P0301', 2),
('evidence:p0301-resistance',   (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Evidence'),      'concept', 'شاهد: اندازه‌گیری مقاومت', 'Resistance measurement evidence', 2),
('observation:p0301-infinite',  (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Observation'),   'concept', 'مشاهده: مقاومت بی‌نهایت', 'Observed infinite resistance', 2),
('measurement:resistance-inf',  (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Measurement'),   'concept', 'اندازه‌گیری: بی‌نهایت', 'Infinite ohm', 2),
('signal:ignition-primary',     (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Signal'),        'concept', 'سیگنال: جرقه اولیه', 'Primary ignition signal', 2),
('config:example-vehicle',      (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Configuration'), 'concept', 'پیکربندی نمونه', 'Example vehicle configuration', 2);

-- ═══ گام ۴: اتصال seed entityها ═══
-- Hypothesis suspects FM
INSERT OR IGNORE INTO e01_222_01_tb (rel_uid, reltype_id, subj_ent_id, obj_ent_id, status, prv_id) VALUES
('r:hypothesis-p0301-suspects-coil-open', (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='suspects'), (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='hypothesis:p0301-coil-open'), (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='fm:coil-open'), 'asserted', 2);

-- Evidence supports Hypothesis
INSERT OR IGNORE INTO e01_222_01_tb (rel_uid, reltype_id, subj_ent_id, obj_ent_id, status, prv_id) VALUES
('r:evidence-p0301-supports-hypothesis', (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='supports'), (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='evidence:p0301-resistance'), (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='hypothesis:p0301-coil-open'), 'asserted', 2);

-- Evidence derived from Observation
INSERT OR IGNORE INTO e01_222_01_tb (rel_uid, reltype_id, subj_ent_id, obj_ent_id, status, prv_id) VALUES
('r:evidence-p0301-derived-from-obs', (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='derived_from'), (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='evidence:p0301-resistance'), (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='observation:p0301-infinite'), 'asserted', 2);

-- Observation measures Measurement
INSERT OR IGNORE INTO e01_222_01_tb (rel_uid, reltype_id, subj_ent_id, obj_ent_id, status, prv_id) VALUES
('r:obs-p0301-measures-resistance', (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='measures'), (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='observation:p0301-infinite'), (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='measurement:resistance-inf'), 'asserted', 2);

-- Signal belongs_to_chain ignition-chain
INSERT OR IGNORE INTO e01_222_01_tb (rel_uid, reltype_id, subj_ent_id, obj_ent_id, status, prv_id) VALUES
('r:signal-ignition-primary-in-chain', (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='belongs_to_chain'), (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='signal:ignition-primary'), (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='fn:ignition-chain'), 'asserted', 2);

-- ═══ گام ۵: log + bump ═══
INSERT OR IGNORE INTO e01_676_01_tb (migration_uid, notes)
VALUES ('v147_knowledge_seed', 'Seeded 6 Knowledge Layer entities + placement rules + relations');

UPDATE e01_676_02_tb SET schema_ver = schema_ver + 1 WHERE id = 1;

COMMIT;

-- ═══ POST-CHECK ═══
SELECT '=== knowledge entities ===' AS section;
SELECT t.type_uid, COUNT(e.ent_id) AS n FROM e01_200_01_tb t LEFT JOIN e01_200_03_tb e ON e.type_id=t.type_id WHERE t.type_uid IN ('Hypothesis','Evidence','Observation','Measurement','Signal','Configuration') GROUP BY t.type_uid ORDER BY t.type_uid;

SELECT '' AS x;
SELECT '=== knowledge relations ===' AS section;
SELECT rt.type_uid, COUNT(r.rel_id) AS n FROM e01_202_01_tb rt LEFT JOIN e01_222_01_tb r ON r.reltype_id=rt.reltype_id WHERE rt.type_uid IN ('supports','contradicts','derived_from','verified_by','ruled_out','measures','suspects') GROUP BY rt.type_uid ORDER BY n DESC;

SELECT '' AS x;
SELECT '=== pending ===' AS section;
SELECT status, COUNT(*) AS n FROM e01_200_05_tb GROUP BY status;

SELECT '' AS x;
SELECT '=== health ===' AS section;
SELECT severity, COUNT(*) AS n FROM e04_900_02_vw GROUP BY severity;
