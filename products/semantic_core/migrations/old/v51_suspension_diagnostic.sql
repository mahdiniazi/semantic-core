-- v51 — زنجیره تشخیصی تعلیق: کمک‌فنر، فنر، سیبک، بوش
.mode column
.headers on

BEGIN;

-- =====================================================================
-- ۱. حالت‌های خرابی تعلیق
-- =====================================================================
INSERT OR IGNORE INTO e01_200_03_tb (ent_uid, type_id, nature, label, description, prv_id) VALUES
('fm:shock-leaking',      (SELECT type_id FROM e01_200_01_tb WHERE type_uid='FailureMode'),'concept','نشت کمک‌فنر','روغن کمک‌فنر نشت کرده',2),
('fm:shock-worn',         (SELECT type_id FROM e01_200_01_tb WHERE type_uid='FailureMode'),'concept','فرسودگی کمک‌فنر','کمک‌فنر خاصیت خود را از دست داده',2),
('fm:shock-dead',         (SELECT type_id FROM e01_200_01_tb WHERE type_uid='FailureMode'),'concept','خرابی کامل کمک‌فنر','کمک‌فنر کار نمی‌کند',2),
('fm:spring-broken',      (SELECT type_id FROM e01_200_01_tb WHERE type_uid='FailureMode'),'concept','شکستگی فنر','فنر لول شکسته',2),
('fm:spring-sagging',     (SELECT type_id FROM e01_200_01_tb WHERE type_uid='FailureMode'),'concept','افتادگی فنر','فنر شل شده و ارتفاع کم شده',2),
('fm:balljoint-worn',     (SELECT type_id FROM e01_200_01_tb WHERE type_uid='FailureMode'),'concept','فرسودگی سیبک','سیبک چرخ شل شده',2),
('fm:bushing-cracked',    (SELECT type_id FROM e01_200_01_tb WHERE type_uid='FailureMode'),'concept','ترکیدگی بوش','بوش لاستیکی ترک خورده',2),
('fm:control-arm-bent',   (SELECT type_id FROM e01_200_01_tb WHERE type_uid='FailureMode'),'concept','خمیدگی طبق','طبق ضربه خورده و خم شده',2),
('fm:noise-over-bump',    (SELECT type_id FROM e01_200_01_tb WHERE type_uid='FailureMode'),'concept','صدای تق تق روی دست‌انداز','صدا از سیستم تعلیق',2),
('fm:vehicle-pulling',    (SELECT type_id FROM e01_200_01_tb WHERE type_uid='FailureMode'),'concept','کشیدن به یک طرف','خودرو به یک سمت می‌کشد',2),
('fm:tire-uneven-wear',   (SELECT type_id FROM e01_200_01_tb WHERE type_uid='FailureMode'),'concept','سایش نامتقارن لاستیک','لاستیک یک‌طرفه ساییده می‌شود',2);

-- =====================================================================
-- ۲. DTC های تعلیق
-- =====================================================================
INSERT OR IGNORE INTO e01_200_03_tb (ent_uid, type_id, nature, label, description, prv_id) VALUES
('dtc:C0710',(SELECT type_id FROM e01_200_01_tb WHERE type_uid='DTC'),'concept','C0710','خرابی سنسور موقعیت تعلیق',2),
('dtc:C1145',(SELECT type_id FROM e01_200_01_tb WHERE type_uid='DTC'),'concept','C1145','خرابی سنسور سرعت چرخ جلو راست',2),
('dtc:C1234',(SELECT type_id FROM e01_200_01_tb WHERE type_uid='DTC'),'concept','C1234','خرابی سنسور سرعت چرخ عقب چپ',2),
('dtc:C0050',(SELECT type_id FROM e01_200_01_tb WHERE type_uid='DTC'),'concept','C0050','خرابی سیستم ترمز-تعلیق',2);

-- =====================================================================
-- ۳. تشخیص
-- =====================================================================
INSERT OR IGNORE INTO e01_200_03_tb (ent_uid, type_id, nature, label, description, prv_id) VALUES
('diagnosis:shock-failed',   (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Diagnosis'),'instance','تشخیص: کمک‌فنر معیوب','کمک‌فنر خراب یا ضعیف',2),
('diagnosis:spring-failed',  (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Diagnosis'),'instance','تشخیص: فنر معیوب','فنر شکسته یا افتاده',2),
('diagnosis:balljoint-failed',(SELECT type_id FROM e01_200_01_tb WHERE type_uid='Diagnosis'),'instance','تشخیص: سیبک فرسوده','سیبک چرخ شل شده',2),
('diagnosis:bushing-failed', (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Diagnosis'),'instance','تشخیص: بوش فرسوده','بوش لاستیکی خراب',2),
('diagnosis:align-failed',   (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Diagnosis'),'instance','تشخیص: تنظیم نبودن فرمان','زاویه چرخ‌ها اشتباه',2);

-- =====================================================================
-- ۴. تست‌ها
-- =====================================================================
INSERT OR IGNORE INTO e01_200_03_tb (ent_uid, type_id, nature, label, description, prv_id) VALUES
('test:shock-bounce',       (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Test'),'instance','تست جهش کمک‌فنر','فشار دادن و رها کردن','2'::INTEGER),
('test:shock-leak-visual',  (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Test'),'instance','بازرسی چشمی نشت','بررسی چشمی کمک‌فنر',2),
('test:spring-height',      (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Test'),'instance','تست ارتفاع فنر','اندازه‌گیری ارتفاع خودرو',2),
('test:balljoint-play',     (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Test'),'instance','تست لقی سیبک','تکان دادن چرخ در هوا',2),
('test:bushing-visual',     (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Test'),'instance','بازرسی چشمی بوش','بررسی ترک و پارگی',2),
('test:wheel-alignment',    (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Test'),'instance','تست تنظیم فرمان','اندازه‌گیری زاویه چرخ',2),
('test:road-test',          (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Test'),'instance','تست جاده','رانندگی و گوش دادن به صدا',2);

-- =====================================================================
-- ۵. رویه‌ها
-- =====================================================================
INSERT OR IGNORE INTO e01_200_03_tb (ent_uid, type_id, nature, label, description, prv_id) VALUES
('procedure:replace-shock',      (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Procedure'),'instance','رویه: تعویض کمک‌فنر','تعویض کمک‌فنر جلو یا عقب',2),
('procedure:replace-spring',     (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Procedure'),'instance','رویه: تعویض فنر','تعویض فنر لول',2),
('procedure:replace-balljoint',  (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Procedure'),'instance','رویه: تعویض سیبک','تعویض سیبک چرخ',2),
('procedure:replace-bushing',    (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Procedure'),'instance','رویه: تعویض بوش','تعویض بوش لاستیکی',2),
('procedure:replace-control-arm',(SELECT type_id FROM e01_200_01_tb WHERE type_uid='Procedure'),'instance','رویه: تعویض طبق','تعویض طبق کامل',2),
('procedure:align-wheels',       (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Procedure'),'instance','رویه: تنظیم فرمان','تنظیم زاویه چرخ‌ها',2);

-- =====================================================================
-- ۶. تعمیرات
-- =====================================================================
INSERT OR IGNORE INTO e01_200_03_tb (ent_uid, type_id, nature, label, description, prv_id) VALUES
('repair:shock-replaced',       (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Repair'),'instance','تعمیر: کمک‌فنر تعویض شد','کمک‌فنر جدید نصب شد',2),
('repair:spring-replaced',      (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Repair'),'instance','تعمیر: فنر تعویض شد','فنر جدید نصب شد',2),
('repair:balljoint-replaced',   (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Repair'),'instance','تعمیر: سیبک تعویض شد','سیبک جدید نصب شد',2),
('repair:bushing-replaced',     (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Repair'),'instance','تعمیر: بوش تعویض شد','بوش جدید نصب شد',2),
('repair:control-arm-replaced', (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Repair'),'instance','تعمیر: طبق تعویض شد','طبق جدید نصب شد',2),
('repair:wheels-aligned',       (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Repair'),'instance','تعمیر: فرمان تنظیم شد','تنظیم زاویه انجام شد',2);

-- =====================================================================
-- ۷. manifests_as
-- =====================================================================
INSERT INTO e01_222_01_tb (rel_uid, reltype_id, subj_ent_id, obj_ent_id, status, prv_id) VALUES
('r:shock-leak-c0710',(SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='manifests_as'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='fm:shock-leaking'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='dtc:C0710'),'asserted',2),
('r:shock-worn-c0710',(SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='manifests_as'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='fm:shock-worn'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='dtc:C0710'),'asserted',2),
('r:shock-dead-c0710',(SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='manifests_as'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='fm:shock-dead'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='dtc:C0710'),'asserted',2),
('r:spring-broken-c0050',(SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='manifests_as'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='fm:spring-broken'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='dtc:C0050'),'asserted',2),
('r:spring-sagging-c0050',(SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='manifests_as'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='fm:spring-sagging'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='dtc:C0050'),'asserted',2),
('r:balljoint-worn-c1145',(SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='manifests_as'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='fm:balljoint-worn'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='dtc:C1145'),'asserted',2),
('r:bushing-cracked-c1234',(SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='manifests_as'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='fm:bushing-cracked'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='dtc:C1234'),'asserted',2),
('r:control-arm-bent-c0050',(SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='manifests_as'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='fm:control-arm-bent'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='dtc:C0050'),'asserted',2),
('r:noise-over-bump-c0710',(SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='manifests_as'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='fm:noise-over-bump'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='dtc:C0710'),'asserted',2),
('r:pulling-c0050',(SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='manifests_as'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='fm:vehicle-pulling'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='dtc:C0050'),'asserted',2),
('r:uneven-wear-c0050',(SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='manifests_as'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='fm:tire-uneven-wear'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='dtc:C0050'),'asserted',2);

-- =====================================================================
-- ۸. diagnosed_as
-- =====================================================================
INSERT INTO e01_222_01_tb (rel_uid, reltype_id, subj_ent_id, obj_ent_id, status, prv_id) VALUES
('r:shock-leak-diag',(SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='diagnosed_as'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='fm:shock-leaking'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='diagnosis:shock-failed'),'asserted',2),
('r:shock-worn-diag',(SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='diagnosed_as'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='fm:shock-worn'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='diagnosis:shock-failed'),'asserted',2),
('r:shock-dead-diag',(SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='diagnosed_as'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='fm:shock-dead'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='diagnosis:shock-failed'),'asserted',2),
('r:spring-broken-diag',(SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='diagnosed_as'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='fm:spring-broken'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='diagnosis:spring-failed'),'asserted',2),
('r:spring-sag-diag',(SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='diagnosed_as'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='fm:spring-sagging'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='diagnosis:spring-failed'),'asserted',2),
('r:balljoint-worn-diag',(SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='diagnosed_as'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='fm:balljoint-worn'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='diagnosis:balljoint-failed'),'asserted',2),
('r:bushing-cracked-diag',(SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='diagnosed_as'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='fm:bushing-cracked'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='diagnosis:bushing-failed'),'asserted',2),
('r:control-arm-diag',(SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='diagnosed_as'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='fm:control-arm-bent'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='diagnosis:align-failed'),'asserted',2),
('r:pulling-diag',(SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='diagnosed_as'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='fm:vehicle-pulling'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='diagnosis:align-failed'),'asserted',2),
('r:uneven-wear-diag',(SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='diagnosed_as'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='fm:tire-uneven-wear'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='diagnosis:align-failed'),'asserted',2);

-- =====================================================================
-- ۹. tested_by
-- =====================================================================
INSERT INTO e01_222_01_tb (rel_uid, reltype_id, subj_ent_id, obj_ent_id, status, prv_id) VALUES
('r:shock-tested-bounce',(SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='tested_by'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='diagnosis:shock-failed'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='test:shock-bounce'),'asserted',2),
('r:shock-tested-leak',(SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='tested_by'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='diagnosis:shock-failed'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='test:shock-leak-visual'),'asserted',2),
('r:shock-tested-road',(SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='tested_by'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='diagnosis:shock-failed'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='test:road-test'),'asserted',2),
('r:spring-tested-height',(SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='tested_by'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='diagnosis:spring-failed'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='test:spring-height'),'asserted',2),
('r:balljoint-tested-play',(SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='tested_by'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='diagnosis:balljoint-failed'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='test:balljoint-play'),'asserted',2),
('r:bushing-tested-visual',(SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='tested_by'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='diagnosis:bushing-failed'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='test:bushing-visual'),'asserted',2),
('r:align-tested-wheel',(SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='tested_by'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='diagnosis:align-failed'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='test:wheel-alignment'),'asserted',2);

-- =====================================================================
-- ۱۰. resolved_by
-- =====================================================================
INSERT INTO e01_222_01_tb (rel_uid, reltype_id, subj_ent_id, obj_ent_id, status, prv_id) VALUES
('r:shock-resolved',(SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='resolved_by'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='diagnosis:shock-failed'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='procedure:replace-shock'),'asserted',2),
('r:spring-resolved',(SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='resolved_by'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='diagnosis:spring-failed'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='procedure:replace-spring'),'asserted',2),
('r:balljoint-resolved',(SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='resolved_by'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='diagnosis:balljoint-failed'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='procedure:replace-balljoint'),'asserted',2),
('r:bushing-resolved',(SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='resolved_by'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='diagnosis:bushing-failed'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='procedure:replace-bushing'),'asserted',2),
('r:align-resolved-arm',(SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='resolved_by'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='diagnosis:align-failed'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='procedure:replace-control-arm'),'asserted',2),
('r:align-resolved-wheels',(SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='resolved_by'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='diagnosis:align-failed'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='procedure:align-wheels'),'asserted',2);

-- =====================================================================
-- ۱۱. procedure به repair
-- =====================================================================
INSERT INTO e01_222_01_tb (rel_uid, reltype_id, subj_ent_id, obj_ent_id, status, prv_id) VALUES
('r:proc-shock-repair',(SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='resolved_by'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='procedure:replace-shock'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='repair:shock-replaced'),'asserted',2),
('r:proc-spring-repair',(SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='resolved_by'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='procedure:replace-spring'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='repair:spring-replaced'),'asserted',2),
('r:proc-balljoint-repair',(SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='resolved_by'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='procedure:replace-balljoint'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='repair:balljoint-replaced'),'asserted',2),
('r:proc-bushing-repair',(SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='resolved_by'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='procedure:replace-bushing'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='repair:bushing-replaced'),'asserted',2),
('r:proc-arm-repair',(SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='resolved_by'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='procedure:replace-control-arm'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='repair:control-arm-replaced'),'asserted',2),
('r:proc-align-repair',(SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='resolved_by'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='procedure:align-wheels'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='repair:wheels-aligned'),'asserted',2);

-- =====================================================================
-- ۱۲. applies_to
-- =====================================================================
INSERT INTO e01_222_01_tb (rel_uid, reltype_id, subj_ent_id, obj_ent_id, status, prv_id) VALUES
('r:susp-shock-veh',(SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='applies_to'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='repair:shock-replaced'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='vehicle:pride-1'),'asserted',2),
('r:susp-spring-veh',(SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='applies_to'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='repair:spring-replaced'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='vehicle:206-1'),'asserted',2),
('r:susp-balljoint-veh',(SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='applies_to'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='repair:balljoint-replaced'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='vehicle:samand-1'),'asserted',2),
('r:susp-align-veh',(SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='applies_to'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='repair:wheels-aligned'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='vehicle:dena-1'),'asserted',2);

-- =====================================================================
-- ۱۳. لاگ
-- =====================================================================
INSERT OR IGNORE INTO e01_676_01_tb (migration_uid, notes)
VALUES ('v51_suspension_diagnostic','Suspension diagnostic chain: shock, spring, balljoint, bushing, alignment');

UPDATE e01_676_02_tb SET schema_ver = schema_ver + 1 WHERE id = 1;

COMMIT;

-- =====================================================================
-- گزارش
-- =====================================================================
SELECT 'entities' AS k, COUNT(*) AS n FROM e01_200_03_tb
UNION ALL SELECT 'relations', COUNT(*) FROM e01_222_01_tb;
