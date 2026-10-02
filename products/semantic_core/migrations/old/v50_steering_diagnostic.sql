-- v50 — زنجیره تشخیصی فرمان: سنگینی، نشتی، لقی
.mode column
.headers on

BEGIN;

-- =====================================================================
-- ۱. حالت‌های خرابی فرمان
-- =====================================================================
INSERT OR IGNORE INTO e01_200_03_tb (ent_uid, type_id, nature, label, description, prv_id) VALUES
('fm:steering-hard',       (SELECT type_id FROM e01_200_01_tb WHERE type_uid='FailureMode'),'concept','سنگینی فرمان','فرمان به سختی می‌چرخد',2),
('fm:steering-fluid-low',  (SELECT type_id FROM e01_200_01_tb WHERE type_uid='FailureMode'),'concept','کمبود روغن هیدرولیک','سطح روغن پایین',2),
('fm:steering-pump-dead',  (SELECT type_id FROM e01_200_01_tb WHERE type_uid='FailureMode'),'concept','خرابی پمپ هیدرولیک','پمپ کار نمی‌کند',2),
('fm:steering-belt-slip',  (SELECT type_id FROM e01_200_01_tb WHERE type_uid='FailureMode'),'concept','لغزش تسمه پمپ','تسمه سست یا فرسوده',2),
('fm:steering-rack-leak',  (SELECT type_id FROM e01_200_01_tb WHERE type_uid='FailureMode'),'concept','نشتی جعبه فرمان','نشت روغن از جعبه',2),
('fm:steering-loose',      (SELECT type_id FROM e01_200_01_tb WHERE type_uid='FailureMode'),'concept','لقی فرمان','بازی زیاد در فرمان',2),
('fm:tie-rod-worn',        (SELECT type_id FROM e01_200_01_tb WHERE type_uid='FailureMode'),'concept','فرسودگی میل موجی','سیبک سر میل شل شده',2),
('fm:steering-noise',      (SELECT type_id FROM e01_200_01_tb WHERE type_uid='FailureMode'),'concept','صدای تق تق فرمان','صدا در دست‌انداز',2);

-- =====================================================================
-- ۲. DTC های فرمان (U و C)
-- =====================================================================
INSERT OR IGNORE INTO e01_200_03_tb (ent_uid, type_id, nature, label, description, prv_id) VALUES
('dtc:U0100',(SELECT type_id FROM e01_200_01_tb WHERE type_uid='DTC'),'concept','U0100','از دست رفتن ارتباط ECU',2),
('dtc:C1200',(SELECT type_id FROM e01_200_01_tb WHERE type_uid='DTC'),'concept','C1200','خرابی سنسور زاویه فرمان',2),
('dtc:C1201',(SELECT type_id FROM e01_200_01_tb WHERE type_uid='DTC'),'concept','C1201','خرابی سنسور گشتاور فرمان',2),
('dtc:C1202',(SELECT type_id FROM e01_200_01_tb WHERE type_uid='DTC'),'concept','C1202','خرابی موتور کمکی فرمان',2);

-- =====================================================================
-- ۳. تشخیص
-- =====================================================================
INSERT OR IGNORE INTO e01_200_03_tb (ent_uid, type_id, nature, label, description, prv_id) VALUES
('diagnosis:c1200-angle',   (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Diagnosis'),'instance','تشخیص: سنسور زاویه معیوب','سنسور زاویه فرمان خراب',2),
('diagnosis:c1201-torque',  (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Diagnosis'),'instance','تشخیص: سنسور گشتاور معیوب','سنسور گشتاور کار نمی‌کند',2),
('diagnosis:hard-pump',     (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Diagnosis'),'instance','تشخیص: پمپ هیدرولیک ضعیف','پمپ فشار کافی تولید نمی‌کند',2),
('diagnosis:loose-rack',    (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Diagnosis'),'instance','تشخیص: لقی جعبه فرمان','بازی در جعبه فرمان',2);

-- =====================================================================
-- ۴. تست‌ها
-- =====================================================================
INSERT OR IGNORE INTO e01_200_03_tb (ent_uid, type_id, nature, label, description, prv_id) VALUES
('test:steering-fluid-level',(SELECT type_id FROM e01_200_01_tb WHERE type_uid='Test'),'instance','تست سطح روغن هیدرولیک','بررسی سطح روغن',2),
('test:steering-pump-pressure',(SELECT type_id FROM e01_200_01_tb WHERE type_uid='Test'),'instance','تست فشار پمپ','اندازه‌گیری فشار پمپ',2),
('test:steering-belt',       (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Test'),'instance','تست تسمه پمپ','بررسی کشش و سلامت تسمه',2),
('test:steering-leak',       (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Test'),'instance','تست نشتی','پیدا کردن محل نشتی',2),
('test:steering-play',       (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Test'),'instance','تست لقی فرمان','اندازه‌گیری بازی فرمان',2),
('test:angle-sensor',        (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Test'),'instance','تست سنسور زاویه','خوانش زاویه فرمان',2),
('test:torque-sensor',       (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Test'),'instance','تست سنسور گشتاور','خوانش گشتاور',2);

-- =====================================================================
-- ۵. رویه‌ها
-- =====================================================================
INSERT OR IGNORE INTO e01_200_03_tb (ent_uid, type_id, nature, label, description, prv_id) VALUES
('procedure:add-fluid',      (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Procedure'),'instance','رویه: افزودن روغن هیدرولیک','شارژ روغن',2),
('procedure:replace-pump',   (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Procedure'),'instance','رویه: تعویض پمپ هیدرولیک','تعویض کامل پمپ',2),
('procedure:replace-belt',   (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Procedure'),'instance','رویه: تعویض تسمه پمپ','تعویض تسمه',2),
('procedure:replace-rack',   (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Procedure'),'instance','رویه: تعویض جعبه فرمان','تعویض کامل جعبه',2),
('procedure:replace-tierod', (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Procedure'),'instance','رویه: تعویض میل موجی','تعویض سر میل موجی',2),
('procedure:replace-angle',  (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Procedure'),'instance','رویه: تعویض سنسور زاویه','تعویض سنسور',2),
('procedure:replace-torque', (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Procedure'),'instance','رویه: تعویض سنسور گشتاور','تعویض سنسور گشتاور',2);

-- =====================================================================
-- ۶. تعمیرات
-- =====================================================================
INSERT OR IGNORE INTO e01_200_03_tb (ent_uid, type_id, nature, label, description, prv_id) VALUES
('repair:fluid-added',      (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Repair'),'instance','تعمیر: روغن اضافه شد','شارژ انجام شد',2),
('repair:pump-replaced',    (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Repair'),'instance','تعمیر: پمپ تعویض شد','پمپ جدید نصب شد',2),
('repair:belt-replaced',    (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Repair'),'instance','تعمیر: تسمه تعویض شد','تسمه جدید نصب شد',2),
('repair:rack-replaced',    (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Repair'),'instance','تعمیر: جعبه فرمان تعویض شد','جعبه جدید نصب شد',2),
('repair:tierod-replaced',  (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Repair'),'instance','تعمیر: میل موجی تعویض شد','میل جدید نصب شد',2),
('repair:angle-sensor-repl',(SELECT type_id FROM e01_200_01_tb WHERE type_uid='Repair'),'instance','تعمیر: سنسور زاویه تعویض شد','سنسور جدید نصب شد',2),
('repair:torque-sensor-repl',(SELECT type_id FROM e01_200_01_tb WHERE type_uid='Repair'),'instance','تعمیر: سنسور گشتاور تعویض شد','سنسور جدید نصب شد',2);

-- =====================================================================
-- ۷. manifests_as
-- =====================================================================
INSERT INTO e01_222_01_tb (rel_uid, reltype_id, subj_ent_id, obj_ent_id, status, prv_id) VALUES
('r:steering-hard-c1200',(SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='manifests_as'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='fm:steering-hard'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='dtc:C1200'),'asserted',2),
('r:steering-hard-c1202',(SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='manifests_as'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='fm:steering-hard'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='dtc:C1202'),'asserted',2),
('r:fluid-low-c1202',(SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='manifests_as'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='fm:steering-fluid-low'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='dtc:C1202'),'asserted',2),
('r:pump-dead-c1202',(SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='manifests_as'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='fm:steering-pump-dead'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='dtc:C1202'),'asserted',2),
('r:rack-leak-c1200',(SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='manifests_as'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='fm:steering-rack-leak'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='dtc:C1200'),'asserted',2),
('r:loose-c1201',(SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='manifests_as'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='fm:steering-loose'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='dtc:C1201'),'asserted',2),
('r:tierod-worn-c1201',(SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='manifests_as'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='fm:tie-rod-worn'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='dtc:C1201'),'asserted',2);

-- =====================================================================
-- ۸. diagnosed_as
-- =====================================================================
INSERT INTO e01_222_01_tb (rel_uid, reltype_id, subj_ent_id, obj_ent_id, status, prv_id) VALUES
('r:hard-diag-pump',(SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='diagnosed_as'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='fm:steering-hard'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='diagnosis:hard-pump'),'asserted',2),
('r:fluid-low-diag-pump',(SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='diagnosed_as'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='fm:steering-fluid-low'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='diagnosis:hard-pump'),'asserted',2),
('r:pump-dead-diag-pump',(SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='diagnosed_as'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='fm:steering-pump-dead'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='diagnosis:hard-pump'),'asserted',2),
('r:belt-slip-diag-pump',(SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='diagnosed_as'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='fm:steering-belt-slip'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='diagnosis:hard-pump'),'asserted',2),
('r:loose-diag-rack',(SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='diagnosed_as'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='fm:steering-loose'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='diagnosis:loose-rack'),'asserted',2),
('r:tierod-worn-diag-rack',(SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='diagnosed_as'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='fm:tie-rod-worn'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='diagnosis:loose-rack'),'asserted',2),
('r:noise-diag-rack',(SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='diagnosed_as'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='fm:steering-noise'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='diagnosis:loose-rack'),'asserted',2),
('r:rack-leak-diag-rack',(SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='diagnosed_as'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='fm:steering-rack-leak'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='diagnosis:loose-rack'),'asserted',2);

-- =====================================================================
-- ۹. tested_by
-- =====================================================================
INSERT INTO e01_222_01_tb (rel_uid, reltype_id, subj_ent_id, obj_ent_id, status, prv_id) VALUES
('r:hard-tested-level',(SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='tested_by'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='diagnosis:hard-pump'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='test:steering-fluid-level'),'asserted',2),
('r:hard-tested-pressure',(SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='tested_by'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='diagnosis:hard-pump'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='test:steering-pump-pressure'),'asserted',2),
('r:hard-tested-belt',(SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='tested_by'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='diagnosis:hard-pump'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='test:steering-belt'),'asserted',2),
('r:loose-tested-play',(SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='tested_by'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='diagnosis:loose-rack'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='test:steering-play'),'asserted',2),
('r:loose-tested-leak',(SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='tested_by'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='diagnosis:loose-rack'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='test:steering-leak'),'asserted',2),
('r:angle-tested',(SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='tested_by'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='diagnosis:c1200-angle'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='test:angle-sensor'),'asserted',2),
('r:torque-tested',(SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='tested_by'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='diagnosis:c1201-torque'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='test:torque-sensor'),'asserted',2);

-- =====================================================================
-- ۱۰. resolved_by
-- =====================================================================
INSERT INTO e01_222_01_tb (rel_uid, reltype_id, subj_ent_id, obj_ent_id, status, prv_id) VALUES
('r:hard-resolved-fluid',(SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='resolved_by'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='diagnosis:hard-pump'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='procedure:add-fluid'),'asserted',2),
('r:hard-resolved-pump',(SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='resolved_by'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='diagnosis:hard-pump'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='procedure:replace-pump'),'asserted',2),
('r:hard-resolved-belt',(SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='resolved_by'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='diagnosis:hard-pump'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='procedure:replace-belt'),'asserted',2),
('r:loose-resolved-rack',(SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='resolved_by'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='diagnosis:loose-rack'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='procedure:replace-rack'),'asserted',2),
('r:loose-resolved-tierod',(SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='resolved_by'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='diagnosis:loose-rack'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='procedure:replace-tierod'),'asserted',2),
('r:angle-resolved',(SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='resolved_by'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='diagnosis:c1200-angle'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='procedure:replace-angle'),'asserted',2),
('r:torque-resolved',(SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='resolved_by'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='diagnosis:c1201-torque'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='procedure:replace-torque'),'asserted',2);

-- =====================================================================
-- ۱۱. procedure به repair
-- =====================================================================
INSERT INTO e01_222_01_tb (rel_uid, reltype_id, subj_ent_id, obj_ent_id, status, prv_id) VALUES
('r:proc-addfluid-repair',(SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='resolved_by'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='procedure:add-fluid'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='repair:fluid-added'),'asserted',2),
('r:proc-pump-repair',(SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='resolved_by'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='procedure:replace-pump'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='repair:pump-replaced'),'asserted',2),
('r:proc-belt-repair',(SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='resolved_by'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='procedure:replace-belt'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='repair:belt-replaced'),'asserted',2),
('r:proc-rack-repair',(SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='resolved_by'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='procedure:replace-rack'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='repair:rack-replaced'),'asserted',2),
('r:proc-tierod-repair',(SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='resolved_by'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='procedure:replace-tierod'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='repair:tierod-replaced'),'asserted',2),
('r:proc-angle-repair',(SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='resolved_by'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='procedure:replace-angle'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='repair:angle-sensor-repl'),'asserted',2),
('r:proc-torque-repair',(SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='resolved_by'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='procedure:replace-torque'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='repair:torque-sensor-repl'),'asserted',2);

-- =====================================================================
-- ۱۲. applies_to
-- =====================================================================
INSERT INTO e01_222_01_tb (rel_uid, reltype_id, subj_ent_id, obj_ent_id, status, prv_id) VALUES
('r:steer-fluid-added-veh',(SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='applies_to'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='repair:fluid-added'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='vehicle:pride-1'),'asserted',2),
('r:steer-pump-repl-veh',(SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='applies_to'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='repair:pump-replaced'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='vehicle:405-1'),'asserted',2),
('r:steer-rack-repl-veh',(SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='applies_to'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='repair:rack-replaced'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='vehicle:samand-1'),'asserted',2),
('r:steer-tierod-repl-veh',(SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='applies_to'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='repair:tierod-replaced'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='vehicle:quick-1'),'asserted',2);

-- =====================================================================
-- ۱۳. لاگ
-- =====================================================================
INSERT OR IGNORE INTO e01_676_01_tb (migration_uid, notes)
VALUES ('v50_steering_diagnostic','Steering diagnostic chain: hard, leak, loose, sensors');

UPDATE e01_676_02_tb SET schema_ver = schema_ver + 1 WHERE id = 1;

COMMIT;

-- =====================================================================
-- گزارش
-- =====================================================================
SELECT 'entities' AS k, COUNT(*) AS n FROM e01_200_03_tb
UNION ALL SELECT 'relations', COUNT(*) FROM e01_222_01_tb;
