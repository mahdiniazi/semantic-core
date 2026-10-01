-- v49 — زنجیره تشخیصی تهویه: کولر و بخاری
.mode column
.headers on

BEGIN;

-- =====================================================================
-- ۱. حالت‌های خرابی HVAC
-- =====================================================================
INSERT OR IGNORE INTO e01_200_03_tb (ent_uid, type_id, nature, label, description, prv_id) VALUES
('fm:ac-no-cold',        (SELECT type_id FROM e01_200_01_tb WHERE type_uid='FailureMode'),'concept','کولر سرد نمی‌کند','دمای خروجی بالا',2),
('fm:ac-refrigerant-low',(SELECT type_id FROM e01_200_01_tb WHERE type_uid='FailureMode'),'concept','کمبود گاز کولر','نشتی یا کمبود شارژ',2),
('fm:ac-compressor-dead',(SELECT type_id FROM e01_200_01_tb WHERE type_uid='FailureMode'),'concept','خرابی کمپرسور کولر','کمپرسور کار نمی‌کند',2),
('fm:ac-clutch-fail',    (SELECT type_id FROM e01_200_01_tb WHERE type_uid='FailureMode'),'concept','خرابی کلاچ کولر','کلاچ درگیر نمی‌شود',2),
('fm:blower-dead',       (SELECT type_id FROM e01_200_01_tb WHERE type_uid='FailureMode'),'concept','خرابی فن کابین','فن کابین کار نمی‌کند',2),
('fm:heater-no-hot',     (SELECT type_id FROM e01_200_01_tb WHERE type_uid='FailureMode'),'concept','بخاری گرم نمی‌کند','رادیاتور بخاری یا شیر گرم',2),
('fm:cabin-filter-clog', (SELECT type_id FROM e01_200_01_tb WHERE type_uid='FailureMode'),'concept','گرفتگی فیلتر کابین','هوای کم یا بوی بد',2),
('fm:expansion-valve-clog',(SELECT type_id FROM e01_200_01_tb WHERE type_uid='FailureMode'),'concept','گرفتگی شیر انبساط','جریان گاز محدود',2);

-- =====================================================================
-- ۲. DTC های HVAC
-- =====================================================================
INSERT OR IGNORE INTO e01_200_03_tb (ent_uid, type_id, nature, label, description, prv_id) VALUES
('dtc:B1421',(SELECT type_id FROM e01_200_01_tb WHERE type_uid='DTC'),'concept','B1421','خرابی سنسور فشار کولر',2),
('dtc:B1422',(SELECT type_id FROM e01_200_01_tb WHERE type_uid='DTC'),'concept','B1422','خرابی کمپرسور کولر',2),
('dtc:B1423',(SELECT type_id FROM e01_200_01_tb WHERE type_uid='DTC'),'concept','B1423','نشتی گاز کولر',2),
('dtc:B1424',(SELECT type_id FROM e01_200_01_tb WHERE type_uid='DTC'),'concept','B1424','خرابی فن کابین',2),
('dtc:B1425',(SELECT type_id FROM e01_200_01_tb WHERE type_uid='DTC'),'concept','B1425','خرابی رادیاتور بخاری',2);

-- =====================================================================
-- ۳. تشخیص
-- =====================================================================
INSERT OR IGNORE INTO e01_200_03_tb (ent_uid, type_id, nature, label, description, prv_id) VALUES
('diagnosis:b1421-pressure',(SELECT type_id FROM e01_200_01_tb WHERE type_uid='Diagnosis'),'instance','تشخیص: فشار گاز پایین','فشار گاز کولر پایین است',2),
('diagnosis:b1422-comp',   (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Diagnosis'),'instance','تشخیص: کمپرسور معیوب','کمپرسور کار نمی‌کند',2),
('diagnosis:b1424-blower', (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Diagnosis'),'instance','تشخیص: فن کابین معیوب','فن نمی‌چرخد',2),
('diagnosis:b1425-heater', (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Diagnosis'),'instance','تشخیص: بخاری معیوب','رادیاتور بخاری گرفتگی دارد',2);

-- =====================================================================
-- ۴. تست‌ها
-- =====================================================================
INSERT OR IGNORE INTO e01_200_03_tb (ent_uid, type_id, nature, label, description, prv_id) VALUES
('test:ac-pressure-low',   (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Test'),'instance','تست فشار پایین','فشار سمت کم‌فشار',2),
('test:ac-pressure-high',  (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Test'),'instance','تست فشار بالا','فشار سمت پرفشار',2),
('test:ac-clutch-power',   (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Test'),'instance','تست برق کلاچ','ولتاژ روی کلاچ کمپرسور',2),
('test:ac-temp-output',    (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Test'),'instance','تست دمای خروجی','اندازه‌گیری دمای دریچه کولر',2),
('test:blower-motor',      (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Test'),'instance','تست موتور فن','چرخش فن در سرعت‌های مختلف',2),
('test:cabin-filter',      (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Test'),'instance','تست فیلتر کابین','بررسی گرفتگی فیلتر',2),
('test:heater-core',       (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Test'),'instance','تست رادیاتور بخاری','دمای ورودی و خروجی',2),
('test:expansion-valve',   (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Test'),'instance','تست شیر انبساط','جریان گاز در شیر',2);

-- =====================================================================
-- ۵. رویه‌ها
-- =====================================================================
INSERT OR IGNORE INTO e01_200_03_tb (ent_uid, type_id, nature, label, description, prv_id) VALUES
('procedure:recharge-ac',    (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Procedure'),'instance','رویه: شارژ گاز کولر','شارژ مجدد گاز کولر',2),
('procedure:leak-test',      (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Procedure'),'instance','رویه: تست نشتی گاز','پیدا کردن محل نشتی',2),
('procedure:replace-comp',   (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Procedure'),'instance','رویه: تعویض کمپرسور','تعویض کامل کمپرسور',2),
('procedure:replace-clutch', (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Procedure'),'instance','رویه: تعویض کلاچ','تعویض کلاچ کمپرسور',2),
('procedure:replace-blower', (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Procedure'),'instance','رویه: تعویض فن کابین','تعویض موتور فن',2),
('procedure:replace-filter', (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Procedure'),'instance','رویه: تعویض فیلتر کابین','تعویض فیلتر',2),
('procedure:replace-heater', (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Procedure'),'instance','رویه: تعویض رادیاتور بخاری','تعویض رادیاتور بخاری',2),
('procedure:clean-expansion',(SELECT type_id FROM e01_200_01_tb WHERE type_uid='Procedure'),'instance','رویه: تمیزکاری شیر انبساط','تمیز کردن شیر',2);

-- =====================================================================
-- ۶. تعمیرات
-- =====================================================================
INSERT OR IGNORE INTO e01_200_03_tb (ent_uid, type_id, nature, label, description, prv_id) VALUES
('repair:ac-recharged',    (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Repair'),'instance','تعمیر: گاز شارژ شد','شارژ گاز انجام شد',2),
('repair:comp-replaced',   (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Repair'),'instance','تعمیر: کمپرسور تعویض شد','کمپرسور جدید نصب شد',2),
('repair:clutch-replaced', (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Repair'),'instance','تعمیر: کلاچ تعویض شد','کلاچ کمپرسور تعویض شد',2),
('repair:blower-replaced', (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Repair'),'instance','تعمیر: فن تعویض شد','موتور فن تعویض شد',2),
('repair:filter-replaced', (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Repair'),'instance','تعمیر: فیلتر تعویض شد','فیلتر کابین تعویض شد',2),
('repair:heater-replaced', (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Repair'),'instance','تعمیر: رادیاتور بخاری تعویض شد','رادیاتور بخاری تعویض شد',2),
('repair:expansion-cleaned',(SELECT type_id FROM e01_200_01_tb WHERE type_uid='Repair'),'instance','تعمیر: شیر انبساط تمیز شد','شیر تمیز و آزاد شد',2);

-- =====================================================================
-- ۷. روابط — manifests_as
-- =====================================================================
INSERT INTO e01_222_01_tb (rel_uid, reltype_id, subj_ent_id, obj_ent_id, status, prv_id)
VALUES
('r:ac-no-cold-b1423',(SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='manifests_as'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='fm:ac-no-cold'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='dtc:B1423'),'asserted',2),
('r:ac-refrig-low-b1423',(SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='manifests_as'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='fm:ac-refrigerant-low'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='dtc:B1423'),'asserted',2),
('r:ac-refrig-low-b1421',(SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='manifests_as'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='fm:ac-refrigerant-low'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='dtc:B1421'),'asserted',2),
('r:comp-dead-b1422',(SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='manifests_as'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='fm:ac-compressor-dead'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='dtc:B1422'),'asserted',2),
('r:clutch-fail-b1422',(SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='manifests_as'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='fm:ac-clutch-fail'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='dtc:B1422'),'asserted',2),
('r:blower-dead-b1424',(SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='manifests_as'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='fm:blower-dead'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='dtc:B1424'),'asserted',2),
('r:heater-no-hot-b1425',(SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='manifests_as'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='fm:heater-no-hot'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='dtc:B1425'),'asserted',2);

-- =====================================================================
-- ۸. روابط — diagnosed_as
-- =====================================================================
INSERT INTO e01_222_01_tb (rel_uid, reltype_id, subj_ent_id, obj_ent_id, status, prv_id)
VALUES
('r:refrig-low-diag',(SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='diagnosed_as'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='fm:ac-refrigerant-low'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='diagnosis:b1421-pressure'),'asserted',2),
('r:ac-no-cold-diag',(SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='diagnosed_as'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='fm:ac-no-cold'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='diagnosis:b1421-pressure'),'asserted',2),
('r:comp-dead-diag',(SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='diagnosed_as'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='fm:ac-compressor-dead'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='diagnosis:b1422-comp'),'asserted',2),
('r:clutch-fail-diag',(SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='diagnosed_as'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='fm:ac-clutch-fail'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='diagnosis:b1422-comp'),'asserted',2),
('r:blower-dead-diag',(SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='diagnosed_as'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='fm:blower-dead'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='diagnosis:b1424-blower'),'asserted',2),
('r:filter-clog-diag',(SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='diagnosed_as'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='fm:cabin-filter-clog'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='diagnosis:b1424-blower'),'asserted',2),
('r:heater-no-hot-diag',(SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='diagnosed_as'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='fm:heater-no-hot'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='diagnosis:b1425-heater'),'asserted',2),
('r:expansion-clog-diag',(SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='diagnosed_as'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='fm:expansion-valve-clog'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='diagnosis:b1421-pressure'),'asserted',2);

-- =====================================================================
-- ۹. روابط — tested_by
-- =====================================================================
INSERT INTO e01_222_01_tb (rel_uid, reltype_id, subj_ent_id, obj_ent_id, status, prv_id)
VALUES
('r:b1421-test-low',(SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='tested_by'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='diagnosis:b1421-pressure'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='test:ac-pressure-low'),'asserted',2),
('r:b1421-test-high',(SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='tested_by'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='diagnosis:b1421-pressure'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='test:ac-pressure-high'),'asserted',2),
('r:b1421-test-exp',(SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='tested_by'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='diagnosis:b1421-pressure'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='test:expansion-valve'),'asserted',2),
('r:b1422-test-clutch',(SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='tested_by'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='diagnosis:b1422-comp'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='test:ac-clutch-power'),'asserted',2),
('r:b1422-test-temp',(SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='tested_by'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='diagnosis:b1422-comp'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='test:ac-temp-output'),'asserted',2),
('r:b1424-test-motor',(SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='tested_by'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='diagnosis:b1424-blower'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='test:blower-motor'),'asserted',2),
('r:b1424-test-filter',(SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='tested_by'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='diagnosis:b1424-blower'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='test:cabin-filter'),'asserted',2),
('r:b1425-test-core',(SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='tested_by'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='diagnosis:b1425-heater'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='test:heater-core'),'asserted',2);

-- =====================================================================
-- ۱۰. روابط — resolved_by
-- =====================================================================
INSERT INTO e01_222_01_tb (rel_uid, reltype_id, subj_ent_id, obj_ent_id, status, prv_id)
VALUES
('r:b1421-resolved-recharge',(SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='resolved_by'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='diagnosis:b1421-pressure'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='procedure:recharge-ac'),'asserted',2),
('r:b1421-resolved-leak',(SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='resolved_by'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='diagnosis:b1421-pressure'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='procedure:leak-test'),'asserted',2),
('r:b1421-resolved-clean',(SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='resolved_by'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='diagnosis:b1421-pressure'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='procedure:clean-expansion'),'asserted',2),
('r:b1422-resolved-comp',(SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='resolved_by'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='diagnosis:b1422-comp'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='procedure:replace-comp'),'asserted',2),
('r:b1422-resolved-clutch',(SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='resolved_by'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='diagnosis:b1422-comp'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='procedure:replace-clutch'),'asserted',2),
('r:b1424-resolved-blower',(SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='resolved_by'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='diagnosis:b1424-blower'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='procedure:replace-blower'),'asserted',2),
('r:b1424-resolved-filter',(SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='resolved_by'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='diagnosis:b1424-blower'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='procedure:replace-filter'),'asserted',2),
('r:b1425-resolved-heater',(SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='resolved_by'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='diagnosis:b1425-heater'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='procedure:replace-heater'),'asserted',2);

-- =====================================================================
-- ۱۱. روابط — procedure به repair
-- =====================================================================
INSERT INTO e01_222_01_tb (rel_uid, reltype_id, subj_ent_id, obj_ent_id, status, prv_id)
VALUES
('r:proc-recharge-repair',(SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='resolved_by'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='procedure:recharge-ac'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='repair:ac-recharged'),'asserted',2),
('r:proc-comp-repair',(SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='resolved_by'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='procedure:replace-comp'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='repair:comp-replaced'),'asserted',2),
('r:proc-clutch-repair',(SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='resolved_by'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='procedure:replace-clutch'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='repair:clutch-replaced'),'asserted',2),
('r:proc-blower-repair',(SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='resolved_by'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='procedure:replace-blower'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='repair:blower-replaced'),'asserted',2),
('r:proc-filter-repair',(SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='resolved_by'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='procedure:replace-filter'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='repair:filter-replaced'),'asserted',2),
('r:proc-heater-repair',(SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='resolved_by'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='procedure:replace-heater'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='repair:heater-replaced'),'asserted',2),
('r:proc-exp-repair',(SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='resolved_by'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='procedure:clean-expansion'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='repair:expansion-cleaned'),'asserted',2);

-- =====================================================================
-- ۱۲. applies_to
-- =====================================================================
INSERT INTO e01_222_01_tb (rel_uid, reltype_id, subj_ent_id, obj_ent_id, status, prv_id)
VALUES
('r:recharge-veh',(SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='applies_to'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='repair:ac-recharged'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='vehicle:pride-1'),'asserted',2),
('r:comp-repl-veh',(SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='applies_to'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='repair:comp-replaced'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='vehicle:206-1'),'asserted',2),
('r:blower-repl-veh',(SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='applies_to'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='repair:blower-replaced'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='vehicle:samand-1'),'asserted',2),
('r:filter-repl-veh',(SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='applies_to'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='repair:filter-replaced'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='vehicle:dena-1'),'asserted',2);

-- =====================================================================
-- ۱۳. لاگ
-- =====================================================================
INSERT OR IGNORE INTO e01_676_01_tb (migration_uid, notes)
VALUES ('v49_hvac_diagnostic','HVAC diagnostic chain: compressor, blower, filter, heater, expansion');

UPDATE e01_676_02_tb SET schema_ver = schema_ver + 1 WHERE id = 1;

COMMIT;

-- =====================================================================
-- گزارش
-- =====================================================================
SELECT 'entities' AS k, COUNT(*) AS n FROM e01_200_03_tb
UNION ALL SELECT 'relations', COUNT(*) FROM e01_222_01_tb;
