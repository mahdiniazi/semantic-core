-- v48 — زنجیره تشخیصی ترمز: C0035 (سایش لنت)
.mode column
.headers on

BEGIN;

-- =====================================================================
-- ۱. حالت‌های خرابی سیستم ترمز
-- =====================================================================
INSERT OR IGNORE INTO e01_200_03_tb (ent_uid, type_id, nature, label, description, prv_id) VALUES
('fm:brake-pad-worn',     (SELECT type_id FROM e01_200_01_tb WHERE type_uid='FailureMode'),'concept','سایش لنت ترمز','لنت به حد مجاز رسیده',2),
('fm:brake-fluid-low',    (SELECT type_id FROM e01_200_01_tb WHERE type_uid='FailureMode'),'concept','کمبود روغن ترمز','سطح روغن پایین',2),
('fm:brake-disc-warped',  (SELECT type_id FROM e01_200_01_tb WHERE type_uid='FailureMode'),'concept','تاب برداشتن دیسک','دیسک ترمز خم شده',2),
('fm:brake-caliper-stuck',(SELECT type_id FROM e01_200_01_tb WHERE type_uid='FailureMode'),'concept','گیر کردن کالیپر','کالیپر آزاد نمی‌شود',2),
('fm:brake-line-leak',    (SELECT type_id FROM e01_200_01_tb WHERE type_uid='FailureMode'),'concept','نشت لوله ترمز','نشتی در مدار روغن',2);

-- =====================================================================
-- ۲. DTC های سیستم ترمز
-- =====================================================================
INSERT OR IGNORE INTO e01_200_03_tb (ent_uid, type_id, nature, label, description, prv_id) VALUES
('dtc:C0035',(SELECT type_id FROM e01_200_01_tb WHERE type_uid='DTC'),'concept','C0035','خرابی سنسور چرخ جلو چپ',2),
('dtc:C0040',(SELECT type_id FROM e01_200_01_tb WHERE type_uid='DTC'),'concept','C0040','خرابی سنسور چرخ جلو راست',2),
('dtc:C0110',(SELECT type_id FROM e01_200_01_tb WHERE type_uid='DTC'),'concept','C0110','خرابی پمپ ترمز ABS',2),
('dtc:C0265',(SELECT type_id FROM e01_200_01_tb WHERE type_uid='DTC'),'concept','C0265','خرابی رله پمپ ABS',2);

-- =====================================================================
-- ۳. تشخیص
-- =====================================================================
INSERT OR IGNORE INTO e01_200_03_tb (ent_uid, type_id, nature, label, description, prv_id) VALUES
('diagnosis:c0035-pad',(SELECT type_id FROM e01_200_01_tb WHERE type_uid='Diagnosis'),'instance','تشخیص: لنت فرسوده','سایش بیش از حد لنت ترمز',2),
('diagnosis:c0110-pump',(SELECT type_id FROM e01_200_01_tb WHERE type_uid='Diagnosis'),'instance','تشخیص: پمپ ABS خراب','پمپ کار نمی‌کند',2);

-- =====================================================================
-- ۴. تست‌ها
-- =====================================================================
INSERT OR IGNORE INTO e01_200_03_tb (ent_uid, type_id, nature, label, description, prv_id) VALUES
('test:pad-thickness',  (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Test'),'instance','تست ضخامت لنت','اندازه‌گیری ضخامت لنت',2),
('test:brake-fluid',    (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Test'),'instance','تست روغن ترمز','بررسی سطح و کیفیت روغن',2),
('test:brake-pressure', (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Test'),'instance','تست فشار ترمز','اندازه‌گیری فشار مدار',2),
('test:abs-light',      (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Test'),'instance','تست چراغ ABS','بررسی روشن شدن چراغ',2);

-- =====================================================================
-- ۵. رویه‌ها
-- =====================================================================
INSERT OR IGNORE INTO e01_200_03_tb (ent_uid, type_id, nature, label, description, prv_id) VALUES
('procedure:replace-pad',    (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Procedure'),'instance','رویه: تعویض لنت','تعویض لنت‌های جلو',2),
('procedure:replace-fluid',  (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Procedure'),'instance','رویه: تعویض روغن ترمز','تعویض و هواگیری روغن ترمز',2),
('procedure:replace-disc',   (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Procedure'),'instance','رویه: تعویض دیسک','تعویض دیسک ترمز',2),
('procedure:repair-caliper', (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Procedure'),'instance','رویه: تعمیر کالیپر','تمیز و روغن‌کاری کالیپر',2),
('procedure:replace-pump',   (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Procedure'),'instance','رویه: تعویض پمپ ABS','تعویض پمپ ترمز ABS',2);

-- =====================================================================
-- ۶. تعمیرات
-- =====================================================================
INSERT OR IGNORE INTO e01_200_03_tb (ent_uid, type_id, nature, label, description, prv_id) VALUES
('repair:pad-replaced',   (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Repair'),'instance','تعمیر: لنت تعویض شد','لنت ترمز جلو تعویض شد',2),
('repair:fluid-replaced', (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Repair'),'instance','تعمیر: روغن ترمز تعویض شد','روغن و هواگیری انجام شد',2),
('repair:disc-replaced',  (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Repair'),'instance','تعمیر: دیسک تعویض شد','دیسک ترمز تعویض شد',2),
('repair:caliper-fixed',  (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Repair'),'instance','تعمیر: کالیپر تعمیر شد','کالیپر تمیز و آزاد شد',2),
('repair:pump-replaced',  (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Repair'),'instance','تعمیر: پمپ ABS تعویض شد','پمپ ABS تعویض شد',2);

-- =====================================================================
-- ۷. روابط — manifests_as
-- =====================================================================
INSERT INTO e01_222_01_tb (rel_uid, reltype_id, subj_ent_id, obj_ent_id, status, prv_id)
VALUES
('r:pad-worn-c0035',(SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='manifests_as'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='fm:brake-pad-worn'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='dtc:C0035'),'asserted',2),
('r:brake-fluid-c0035',(SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='manifests_as'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='fm:brake-fluid-low'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='dtc:C0035'),'asserted',2),
('r:pump-bad-c0110',(SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='manifests_as'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='fm:brake-caliper-stuck'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='dtc:C0110'),'asserted',2);

-- =====================================================================
-- ۸. روابط — diagnosed_as
-- =====================================================================
INSERT INTO e01_222_01_tb (rel_uid, reltype_id, subj_ent_id, obj_ent_id, status, prv_id)
VALUES
('r:pad-worn-diag-c0035',(SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='diagnosed_as'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='fm:brake-pad-worn'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='diagnosis:c0035-pad'),'asserted',2),
('r:caliper-diag-c0110',(SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='diagnosed_as'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='fm:brake-caliper-stuck'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='diagnosis:c0110-pump'),'asserted',2);

-- =====================================================================
-- ۹. روابط — tested_by
-- =====================================================================
INSERT INTO e01_222_01_tb (rel_uid, reltype_id, subj_ent_id, obj_ent_id, status, prv_id)
VALUES
('r:c0035-tested-pad',(SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='tested_by'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='diagnosis:c0035-pad'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='test:pad-thickness'),'asserted',2),
('r:c0035-tested-fluid',(SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='tested_by'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='diagnosis:c0035-pad'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='test:brake-fluid'),'asserted',2),
('r:c0035-tested-pressure',(SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='tested_by'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='diagnosis:c0035-pad'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='test:brake-pressure'),'asserted',2),
('r:c0110-tested-abs',(SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='tested_by'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='diagnosis:c0110-pump'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='test:abs-light'),'asserted',2);

-- =====================================================================
-- ۱۰. روابط — resolved_by
-- =====================================================================
INSERT INTO e01_222_01_tb (rel_uid, reltype_id, subj_ent_id, obj_ent_id, status, prv_id)
VALUES
('r:c0035-resolved-pad',(SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='resolved_by'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='diagnosis:c0035-pad'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='procedure:replace-pad'),'asserted',2),
('r:c0035-resolved-fluid',(SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='resolved_by'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='diagnosis:c0035-pad'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='procedure:replace-fluid'),'asserted',2),
('r:c0035-resolved-disc',(SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='resolved_by'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='diagnosis:c0035-pad'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='procedure:replace-disc'),'asserted',2),
('r:c0110-resolved-caliper',(SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='resolved_by'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='diagnosis:c0110-pump'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='procedure:repair-caliper'),'asserted',2),
('r:c0110-resolved-pump',(SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='resolved_by'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='diagnosis:c0110-pump'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='procedure:replace-pump'),'asserted',2);

-- =====================================================================
-- ۱۱. روابط — procedure به repair
-- =====================================================================
INSERT INTO e01_222_01_tb (rel_uid, reltype_id, subj_ent_id, obj_ent_id, status, prv_id)
VALUES
('r:proc-pad-repair',(SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='resolved_by'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='procedure:replace-pad'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='repair:pad-replaced'),'asserted',2),
('r:proc-fluid-repair',(SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='resolved_by'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='procedure:replace-fluid'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='repair:fluid-replaced'),'asserted',2),
('r:proc-disc-repair',(SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='resolved_by'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='procedure:replace-disc'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='repair:disc-replaced'),'asserted',2),
('r:proc-caliper-repair',(SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='resolved_by'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='procedure:repair-caliper'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='repair:caliper-fixed'),'asserted',2),
('r:proc-pump-repair',(SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='resolved_by'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='procedure:replace-pump'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='repair:pump-replaced'),'asserted',2);

-- =====================================================================
-- ۱۲. applies_to خودرو
-- =====================================================================
INSERT INTO e01_222_01_tb (rel_uid, reltype_id, subj_ent_id, obj_ent_id, status, prv_id)
VALUES
('r:repair-pad-veh',(SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='applies_to'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='repair:pad-replaced'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='vehicle:pride-1'),'asserted',2),
('r:repair-fluid-veh',(SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='applies_to'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='repair:fluid-replaced'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='vehicle:pride-1'),'asserted',2),
('r:repair-disc-veh',(SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='applies_to'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='repair:disc-replaced'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='vehicle:206-1'),'asserted',2),
('r:repair-caliper-veh',(SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='applies_to'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='repair:caliper-fixed'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='vehicle:206-1'),'asserted',2);

-- =====================================================================
-- ۱۳. لاگ
-- =====================================================================
INSERT OR IGNORE INTO e01_676_01_tb (migration_uid, notes)
VALUES ('v48_brake_diagnostic','Brake diagnostic chain: pad, fluid, disc, caliper, pump');

UPDATE e01_676_02_tb SET schema_ver = schema_ver + 1 WHERE id = 1;

COMMIT;

-- =====================================================================
-- گزارش
-- =====================================================================
SELECT 'entities' AS k, COUNT(*) AS n FROM e01_200_03_tb
UNION ALL SELECT 'relations', COUNT(*) FROM e01_222_01_tb;

SELECT '=== زنجیره تشخیصی ترمز ===' AS section;
SELECT 
  se.ent_uid AS from_entity,
  rt.type_uid AS relation,
  oe.ent_uid AS to_entity
FROM e01_222_01_tb r
JOIN e01_202_01_tb rt ON rt.reltype_id = r.reltype_id
JOIN e01_200_03_tb se ON se.ent_id = r.subj_ent_id
JOIN e01_200_03_tb oe ON oe.ent_id = r.obj_ent_id
WHERE (se.ent_uid LIKE 'diagnosis:c00%' OR se.ent_uid LIKE 'procedure:%pad%' 
    OR se.ent_uid LIKE 'procedure:%disc%' OR se.ent_uid LIKE 'procedure:%caliper%'
    OR se.ent_uid LIKE 'procedure:%pump%' OR se.ent_uid LIKE 'procedure:%fluid%'
    OR se.ent_uid LIKE 'fm:brake%' OR se.ent_uid LIKE 'repair:pad%' OR se.ent_uid LIKE 'repair:fluid%'
    OR se.ent_uid LIKE 'repair:disc%' OR se.ent_uid LIKE 'repair:caliper%' OR se.ent_uid LIKE 'repair:pump%')
   OR (oe.ent_uid LIKE 'diagnosis:c00%' OR oe.ent_uid LIKE 'procedure:%pad%'
    OR oe.ent_uid LIKE 'procedure:%disc%' OR oe.ent_uid LIKE 'procedure:%caliper%'
    OR oe.ent_uid LIKE 'procedure:%pump%' OR oe.ent_uid LIKE 'procedure:%fluid%'
    OR oe.ent_uid LIKE 'test:%pad%' OR oe.ent_uid LIKE 'test:brake%' OR oe.ent_uid LIKE 'test:abs%'
    OR oe.ent_uid LIKE 'repair:pad%' OR oe.ent_uid LIKE 'repair:fluid%'
    OR oe.ent_uid LIKE 'repair:disc%' OR oe.ent_uid LIKE 'repair:caliper%' OR oe.ent_uid LIKE 'repair:pump%')
ORDER BY se.ent_uid, rt.type_uid;
