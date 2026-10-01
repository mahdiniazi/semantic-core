-- v56 — خودروهای چینی
.mode column
.headers on

BEGIN;

INSERT OR IGNORE INTO e01_200_01_tb (type_uid, label, is_abstract) VALUES
-- چری
('CheryTiggo',    'چری تیگو',        0),
('CheryArrizo',   'چری آریزو',       0),
-- جک
('JACS3',         'جک S3',           0),
('JACS5',         'جک S5',           0),
('JACJ4',         'جک J4',           0),
-- برلیانس
('BrillianceH230',  'برلیانس H230',  0),
('BrillianceH320',  'برلیانس H320',  0),
('BrillianceH530',  'برلیانس H530',  0),
-- لیفان
('LifanX60',      'لیفان X60',       0),
('Lifan820',      'لیفان ۸۲۰',       0),
-- هاوال
('HavalH6',       'هاوال H6',        0),
('HavalH2',       'هاوال H2',        0),
-- جیلی
('GeelyEmgrand',  'جیلی امگرند',     0),
('GeelyCoolray',  'جیلی کولری',      0),
-- BYD
('BYDSong',       'BYD سانگ',        0),
('BYDAtto3',      'BYD Atto 3',      0);

UPDATE e01_200_01_tb 
SET parent_id = (SELECT type_id FROM e01_200_01_tb WHERE type_uid='PassengerCar')
WHERE type_uid IN (
  'CheryTiggo','CheryArrizo',
  'JACS3','JACS5','JACJ4',
  'BrillianceH230','BrillianceH320','BrillianceH530',
  'LifanX60','Lifan820',
  'HavalH6','HavalH2',
  'GeelyEmgrand','GeelyCoolray',
  'BYDSong','BYDAtto3'
);

-- =====================================================================
-- مفهوم‌ها
-- =====================================================================
INSERT OR IGNORE INTO e01_200_03_tb (ent_uid, type_id, nature, label, description, prv_id) VALUES
('concept:chery-tiggo',      (SELECT type_id FROM e01_200_01_tb WHERE type_uid='CheryTiggo'),'concept','چری تیگو','Chery Tiggo SUV',2),
('concept:chery-arrizo',     (SELECT type_id FROM e01_200_01_tb WHERE type_uid='CheryArrizo'),'concept','چری آریزو','Chery Arrizo',2),
('concept:jac-s3',           (SELECT type_id FROM e01_200_01_tb WHERE type_uid='JACS3'),'concept','جک S3','JAC S3 SUV',2),
('concept:jac-s5',           (SELECT type_id FROM e01_200_01_tb WHERE type_uid='JACS5'),'concept','جک S5','JAC S5 SUV',2),
('concept:jac-j4',           (SELECT type_id FROM e01_200_01_tb WHERE type_uid='JACJ4'),'concept','جک J4','JAC J4 Sedan',2),
('concept:brilliance-h230',  (SELECT type_id FROM e01_200_01_tb WHERE type_uid='BrillianceH230'),'concept','برلیانس H230','Brilliance H230',2),
('concept:brilliance-h320',  (SELECT type_id FROM e01_200_01_tb WHERE type_uid='BrillianceH320'),'concept','برلیانس H320','Brilliance H320',2),
('concept:brilliance-h530',  (SELECT type_id FROM e01_200_01_tb WHERE type_uid='BrillianceH530'),'concept','برلیانس H530','Brilliance H530',2),
('concept:lifan-x60',        (SELECT type_id FROM e01_200_01_tb WHERE type_uid='LifanX60'),'concept','لیفان X60','Lifan X60 SUV',2),
('concept:lifan-820',        (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Lifan820'),'concept','لیفان ۸۲۰','Lifan 820',2),
('concept:haval-h6',         (SELECT type_id FROM e01_200_01_tb WHERE type_uid='HavalH6'),'concept','هاوال H6','Haval H6 SUV',2),
('concept:haval-h2',         (SELECT type_id FROM e01_200_01_tb WHERE type_uid='HavalH2'),'concept','هاوال H2','Haval H2 SUV',2),
('concept:geely-emgrand',    (SELECT type_id FROM e01_200_01_tb WHERE type_uid='GeelyEmgrand'),'concept','جیلی امگرند','Geely Emgrand',2),
('concept:geely-coolray',    (SELECT type_id FROM e01_200_01_tb WHERE type_uid='GeelyCoolray'),'concept','جیلی کولری','Geely Coolray',2),
('concept:byd-song',         (SELECT type_id FROM e01_200_01_tb WHERE type_uid='BYDSong'),'concept','BYD سانگ','BYD Song SUV',2),
('concept:byd-atto3',        (SELECT type_id FROM e01_200_01_tb WHERE type_uid='BYDAtto3'),'concept','BYD Atto 3','BYD Atto 3 EV',2);

-- =====================================================================
-- is_a
-- =====================================================================
INSERT INTO e01_222_01_tb (rel_uid, reltype_id, subj_ent_id, obj_ent_id, status, prv_id)
SELECT
  'r:' || REPLACE(p.sub_uid, ':', '-') || '-is-a',
  (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='is_a'),
  (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid=p.sub_uid),
  (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='concept:passenger-car'),
  'asserted', 2
FROM (
  SELECT 'concept:chery-tiggo' AS sub_uid UNION ALL SELECT 'concept:chery-arrizo' UNION ALL
  SELECT 'concept:jac-s3' UNION ALL SELECT 'concept:jac-s5' UNION ALL SELECT 'concept:jac-j4' UNION ALL
  SELECT 'concept:brilliance-h230' UNION ALL SELECT 'concept:brilliance-h320' UNION ALL SELECT 'concept:brilliance-h530' UNION ALL
  SELECT 'concept:lifan-x60' UNION ALL SELECT 'concept:lifan-820' UNION ALL
  SELECT 'concept:haval-h6' UNION ALL SELECT 'concept:haval-h2' UNION ALL
  SELECT 'concept:geely-emgrand' UNION ALL SELECT 'concept:geely-coolray' UNION ALL
  SELECT 'concept:byd-song' UNION ALL SELECT 'concept:byd-atto3'
) p
WHERE NOT EXISTS (SELECT 1 FROM e01_222_01_tb r WHERE r.rel_uid = 'r:' || REPLACE(p.sub_uid, ':', '-') || '-is-a');

-- =====================================================================
-- manufactured_by
-- =====================================================================
INSERT INTO e01_222_01_tb (rel_uid, reltype_id, subj_ent_id, obj_ent_id, status, prv_id)
SELECT
  'r:' || REPLACE(p.product, ':', '-') || '-by-' || REPLACE(p.maker, ':', '-'),
  (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='manufactured_by'),
  (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid=p.product),
  (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid=p.maker),
  'asserted', 2
FROM (
  SELECT 'concept:chery-tiggo' AS product, 'concept:chery' AS maker UNION ALL
  SELECT 'concept:chery-arrizo',              'concept:chery' UNION ALL
  SELECT 'concept:jac-s3',                    'concept:jac' UNION ALL
  SELECT 'concept:jac-s5',                    'concept:jac' UNION ALL
  SELECT 'concept:jac-j4',                    'concept:jac' UNION ALL
  SELECT 'concept:brilliance-h230',           'concept:brilliance' UNION ALL
  SELECT 'concept:brilliance-h320',           'concept:brilliance' UNION ALL
  SELECT 'concept:brilliance-h530',           'concept:brilliance' UNION ALL
  SELECT 'concept:lifan-x60',                 'concept:lifan' UNION ALL
  SELECT 'concept:lifan-820',                 'concept:lifan' UNION ALL
  SELECT 'concept:haval-h6',                  'concept:haval' UNION ALL
  SELECT 'concept:haval-h2',                  'concept:haval' UNION ALL
  SELECT 'concept:geely-emgrand',             'concept:geely' UNION ALL
  SELECT 'concept:geely-coolray',             'concept:geely' UNION ALL
  SELECT 'concept:byd-song',                  'concept:byd' UNION ALL
  SELECT 'concept:byd-atto3',                 'concept:byd'
) p
WHERE EXISTS (SELECT 1 FROM e01_200_03_tb WHERE ent_uid=p.product)
  AND EXISTS (SELECT 1 FROM e01_200_03_tb WHERE ent_uid=p.maker)
  AND NOT EXISTS (SELECT 1 FROM e01_222_01_tb r WHERE r.rel_uid = 'r:' || REPLACE(p.product, ':', '-') || '-by-' || REPLACE(p.maker, ':', '-'));

INSERT OR IGNORE INTO e01_676_01_tb (migration_uid, notes)
VALUES ('v56_chinese_cars','Chinese cars: Chery (2), JAC (3), Brilliance (3), Lifan (2), Haval (2), Geely (2), BYD (2)');

UPDATE e01_676_02_tb SET schema_ver = schema_ver + 1 WHERE id = 1;

COMMIT;

SELECT 'entities' AS k, COUNT(*) AS n FROM e01_200_03_tb
UNION ALL SELECT 'relations', COUNT(*) FROM e01_222_01_tb;

SELECT '=== خودروهای چینی ===' AS section;
SELECT 
  p.label AS model,
  m.label AS maker
FROM e01_222_01_tb r
JOIN e01_202_01_tb rt ON rt.reltype_id = r.reltype_id AND rt.type_uid='manufactured_by'
JOIN e01_200_03_tb p ON p.ent_id = r.subj_ent_id
JOIN e01_200_03_tb m ON m.ent_id = r.obj_ent_id
WHERE m.ent_uid IN ('concept:chery','concept:jac','concept:brilliance','concept:lifan','concept:haval','concept:geely','concept:byd')
ORDER BY m.ent_uid, p.ent_uid;
