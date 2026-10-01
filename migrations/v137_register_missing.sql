-- v137 — ثبت سه element گم‌شده
.mode column
.headers on

BEGIN;

-- ═══ ۱. Registry: ۳ عنصر گم‌شده ═══
INSERT OR IGNORE INTO e01_506_03_tb 
  (element_name, element_level, element_layer, element_kind, need_uid, purpose)
VALUES 
  ('e04_900_02_vw', 4, 'M', 'vw', 'N30', 'گزارش سلامت — ۱۷ چک ساختاری در سه سطح'),
  ('_baseline_v26', 2, 'V', 'tb', 'N60', 'بکاپ تاریخی v26 — مقایسه تحول'),
  ('e02_200_40_ix', 2, 'T', 'ix', 'N50', 'ایندکس type_id روی جدول قواعد جای‌گذاری');

-- ═══ ۲. Matrix: پیوند به نیازها ═══
INSERT OR IGNORE INTO e01_778_02_tb 
  (element_name, need_uid, is_primary, is_driving, role, note)
VALUES 
  ('e04_900_02_vw', 'N30', 0, 0, 'observes', 'گزارش یکپارچگی ارجاعی'),
  ('_baseline_v26', 'N60', 0, 0, 'maintains', 'نگه‌داشتن بکاپ تاریخی'),
  ('e02_200_40_ix', 'N50', 0, 0, 'serves', 'تسریع auto_place');

-- ═══ ۳. Policy: سه سیاست ═══
INSERT OR IGNORE INTO e01_778_05_tb
  (element_name, need_uid, policy_kind, exec_name, rationale, is_mandatory)
VALUES 
  ('e04_900_02_vw', 'N30', 'audit', 'e04_900_02_vw',
   'گزارش سلامت باید هر بار به‌عنوان مرجع بررسی شود', 1),
  ('_baseline_v26', 'N60', 'immutability', '_baseline_v26',
   'بکاپ تاریخی نباید هرگز تغییر کند — فقط خواندنی', 1),
  ('e02_200_40_ix', 'N50', 'index', 'e02_200_40_ix',
   'ایندکس اختصاصی برای تسریع auto_place', 1);

-- ═══ ۴. log + bump ═══
INSERT OR IGNORE INTO e01_676_01_tb (migration_uid, notes)
VALUES ('v137_register_missing', 
        'Registered 3 missing elements: e04_900_02_vw, _baseline_v26, e02_200_40_ix');

UPDATE e01_676_02_tb SET schema_ver = schema_ver + 1 WHERE id = 1;

COMMIT;

-- ═══ POST-CHECK ═══
SELECT '═══ registry جدید ═══' AS section;
SELECT element_name, element_layer, element_kind, element_level, need_uid, purpose
FROM e01_506_03_tb
WHERE element_name IN ('e04_900_02_vw', '_baseline_v26', 'e02_200_40_ix');

SELECT '' AS x;
SELECT '═══ schema بدون registry (باید خالی باشد) ═══' AS section;
SELECT sm.type, sm.name
FROM sqlite_master sm
WHERE sm.type IN ('table','view','trigger','index')
  AND sm.name NOT LIKE 'sqlite_%'
  AND sm.name NOT LIKE '%_data'
  AND sm.name NOT LIKE '%_idx'
  AND sm.name NOT LIKE '%_docsize'
  AND sm.name NOT LIKE '%_config'
  AND NOT EXISTS (SELECT 1 FROM e01_506_03_tb r WHERE r.element_name=sm.name);

SELECT '' AS x;
SELECT '═══ health ═══' AS section;
SELECT severity, COUNT(*) AS n FROM e04_900_02_vw GROUP BY severity;
