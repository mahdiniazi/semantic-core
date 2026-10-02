-- v139 — ساخت ۷ نقش پایه + ۱۳ زیرنقش + بازآرایی ۵ نقش فعلی
.mode column
.headers on

BEGIN;

-- ═══ گام ۱: اطمینان از وجود type «Role» ═══
INSERT OR IGNORE INTO e01_200_01_tb (type_uid, label, is_abstract)
VALUES ('Role', 'نقش', 1);

-- ═══ گام ۲: ساخت ۷ نقش پایه ═══
INSERT OR IGNORE INTO e01_200_03_tb 
  (ent_uid, type_id, nature, label, description, prv_id)
VALUES
  ('role:switch-function',
   (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Role'),
   'concept', 'کارکرد سوئیچینگ', 'نقش پایه: قطع و وصل جریان/سیگنال', 2),
  ('role:sensing-function',
   (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Role'),
   'concept', 'کارکرد حس‌گری', 'نقش پایه: مشاهده و تبدیل کمیت فیزیکی', 2),
  ('role:control-function',
   (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Role'),
   'concept', 'کارکرد کنترل', 'نقش پایه: پردازش منطق و صدور فرمان', 2),
  ('role:actuation-function',
   (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Role'),
   'concept', 'کارکرد عمل‌گری', 'نقش پایه: تبدیل سیگنال به عمل فیزیکی', 2),
  ('role:protection-function',
   (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Role'),
   'concept', 'کارکرد حفاظت', 'نقش پایه: پیشگیری از آسیب', 2),
  ('role:communication-function',
   (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Role'),
   'concept', 'کارکرد ارتباط', 'نقش پایه: تبادل اطلاعات بین گره‌ها', 2),
  ('role:energy-function',
   (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Role'),
   'concept', 'کارکرد انرژی', 'نقش پایه: ذخیره، تبدیل و توزیع انرژی', 2);

-- ═══ گام ۳: ساخت ۱۳ زیرنقش کلیدی ═══
INSERT OR IGNORE INTO e01_200_03_tb 
  (ent_uid, type_id, nature, label, description, prv_id)
VALUES
  ('role:switch-power',
   (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Role'),
   'concept', 'سوئیچ توان', 'سوئیچ مسیر جریان بالا', 2),
  ('role:switch-signal',
   (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Role'),
   'concept', 'سوئیچ سیگنال', 'سوئیچ مسیر سیگنال کم‌جریان', 2),
  ('role:relay',
   (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Role'),
   'concept', 'رله', 'سوئیچ کنترل‌شده با سیگنال', 2),
  ('role:sensor',
   (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Role'),
   'concept', 'سنسور', 'مشاهده‌گر کمیت فیزیکی', 2),
  ('role:detector',
   (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Role'),
   'concept', 'آشکارساز', 'آشکارساز وضعیت', 2),
  ('role:controller',
   (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Role'),
   'concept', 'کنترلر', 'واحد کنترل الکترونیکی', 2),
  ('role:actuator',
   (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Role'),
   'concept', 'عملگر', 'تبدیل سیگنال به عمل فیزیکی', 2),
  ('role:driver',
   (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Role'),
   'concept', 'درایور', 'طبقه‌ی توان برای عملگر', 2),
  ('role:fuse',
   (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Role'),
   'concept', 'فیوز', 'حافظ یک‌بار مصرف', 2),
  ('role:transceiver',
   (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Role'),
   'concept', 'فرستنده-گیرنده', 'ترنسیور شبکه', 2),
  ('role:gateway',
   (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Role'),
   'concept', 'دروازه', 'تبدیل پروتکل شبکه', 2),
  ('role:energy-storage',
   (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Role'),
   'concept', 'ذخیره‌ساز انرژی', 'باتری، خازن', 2),
  ('role:energy-conversion',
   (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Role'),
   'concept', 'مبدل انرژی', 'دینام، DC-DC', 2);

-- ═══ گام ۴: بازآرایی ۵ نقش فعلی زیر نقش پایه ═══
INSERT OR IGNORE INTO e01_222_01_tb 
  (rel_uid, reltype_id, subj_ent_id, obj_ent_id, status, prv_id)
VALUES
  ('r:switch-is-a-switch-function',
   (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='is_a'),
   (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='role:switch'),
   (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='role:switch-function'),
   'asserted', 2),
  ('r:protector-is-a-protection-function',
   (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='is_a'),
   (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='role:protector'),
   (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='role:protection-function'),
   'asserted', 2),
  ('r:isolator-is-a-switch-function',
   (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='is_a'),
   (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='role:isolator'),
   (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='role:switch-function'),
   'asserted', 2),
  ('r:no-switch-is-a-switch-function',
   (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='is_a'),
   (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='role:no-switch'),
   (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='role:switch-function'),
   'asserted', 2),
  ('r:nc-switch-is-a-switch-function',
   (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='is_a'),
   (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='role:nc-switch'),
   (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='role:switch-function'),
   'asserted', 2);

-- ═══ گام ۵: اتصال ۱۳ زیرنقش به نقش پایه ═══
INSERT OR IGNORE INTO e01_222_01_tb 
  (rel_uid, reltype_id, subj_ent_id, obj_ent_id, status, prv_id)
VALUES
  ('r:switch-power-is-a-switch-function',
   (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='is_a'),
   (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='role:switch-power'),
   (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='role:switch-function'),
   'asserted', 2),
  ('r:switch-signal-is-a-switch-function',
   (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='is_a'),
   (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='role:switch-signal'),
   (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='role:switch-function'),
   'asserted', 2),
  ('r:relay-is-a-switch-function',
   (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='is_a'),
   (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='role:relay'),
   (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='role:switch-function'),
   'asserted', 2),
  ('r:sensor-is-a-sensing-function',
   (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='is_a'),
   (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='role:sensor'),
   (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='role:sensing-function'),
   'asserted', 2),
  ('r:detector-is-a-sensing-function',
   (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='is_a'),
   (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='role:detector'),
   (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='role:sensing-function'),
   'asserted', 2),
  ('r:controller-is-a-control-function',
   (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='is_a'),
   (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='role:controller'),
   (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='role:control-function'),
   'asserted', 2),
  ('r:actuator-is-a-actuation-function',
   (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='is_a'),
   (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='role:actuator'),
   (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='role:actuation-function'),
   'asserted', 2),
  ('r:driver-is-a-actuation-function',
   (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='is_a'),
   (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='role:driver'),
   (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='role:actuation-function'),
   'asserted', 2),
  ('r:fuse-is-a-protection-function',
   (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='is_a'),
   (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='role:fuse'),
   (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='role:protection-function'),
   'asserted', 2),
  ('r:transceiver-is-a-communication-function',
   (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='is_a'),
   (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='role:transceiver'),
   (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='role:communication-function'),
   'asserted', 2),
  ('r:gateway-is-a-communication-function',
   (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='is_a'),
   (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='role:gateway'),
   (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='role:communication-function'),
   'asserted', 2),
  ('r:energy-storage-is-a-energy-function',
   (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='is_a'),
   (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='role:energy-storage'),
   (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='role:energy-function'),
   'asserted', 2),
  ('r:energy-conversion-is-a-energy-function',
   (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='is_a'),
   (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='role:energy-conversion'),
   (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='role:energy-function'),
   'asserted', 2);

-- ═══ گام ۶: نمونه‌ی plays_role (کانسپت → نقش) ═══
INSERT OR IGNORE INTO e01_222_01_tb 
  (rel_uid, reltype_id, subj_ent_id, obj_ent_id, status, prv_id)
VALUES
  ('r:relay-plays-switch-power',
   (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='plays_role'),
   (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='concept:relay'),
   (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='role:switch-power'),
   'asserted', 2),
  ('r:fuse-plays-fuse-role',
   (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='plays_role'),
   (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='concept:fuse'),
   (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='role:fuse'),
   'asserted', 2),
  ('r-maf-plays-sensor-role',
   (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='plays_role'),
   (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='concept:maf-sensor'),
   (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='role:sensor'),
   'asserted', 2),
  ('r-engine-ecu-plays-controller-role',
   (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='plays_role'),
   (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='concept:engine-ecu'),
   (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='role:controller'),
   'asserted', 2),
  ('r-battery-plays-energy-storage-role',
   (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='plays_role'),
   (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='concept:battery'),
   (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='role:energy-storage'),
   'asserted', 2);

-- ═══ گام ۷: log + bump ═══
INSERT OR IGNORE INTO e01_676_01_tb (migration_uid, notes)
VALUES ('v139_roles_base',
        'Created 7 base roles + 13 sub-roles + refactored 5 existing');

UPDATE e01_676_02_tb SET schema_ver = schema_ver + 1 WHERE id = 1;

COMMIT;

-- ═══ POST-CHECK ═══
SELECT '═══ ۱. تعداد کل نقش‌ها ═══' AS section;
SELECT COUNT(*) AS n FROM e01_200_03_tb WHERE ent_uid LIKE 'role:%';

SELECT '' AS x;
SELECT '═══ ۲. نقش‌های پایه (باید ۷ باشد) ═══' AS section;
SELECT ent_uid, label FROM e01_200_03_tb 
WHERE ent_uid IN (
  'role:switch-function','role:sensing-function','role:control-function',
  'role:actuation-function','role:protection-function',
  'role:communication-function','role:energy-function'
) ORDER BY ent_uid;

SELECT '' AS x;
SELECT '═══ ۳. سلسله‌مراتب نقش‌ها ═══' AS section;
SELECT sub.ent_uid AS role, obj.ent_uid AS parent_role
FROM e01_222_01_tb r
JOIN e01_202_01_tb rt ON rt.reltype_id = r.reltype_id AND rt.type_uid='is_a'
JOIN e01_200_03_tb sub ON sub.ent_id = r.subj_ent_id
JOIN e01_200_03_tb obj ON obj.ent_id = r.obj_ent_id
WHERE sub.ent_uid LIKE 'role:%' AND obj.ent_uid LIKE 'role:%'
ORDER BY obj.ent_uid, sub.ent_uid;

SELECT '' AS x;
SELECT '═══ ۴. اتصال کانسپت → نقش (plays_role) ═══' AS section;
SELECT sub.ent_uid AS concept, obj.ent_uid AS role
FROM e01_222_01_tb r
JOIN e01_202_01_tb rt ON rt.reltype_id = r.reltype_id AND rt.type_uid='plays_role'
JOIN e01_200_03_tb sub ON sub.ent_id = r.subj_ent_id
JOIN e01_200_03_tb obj ON obj.ent_id = r.obj_ent_id
ORDER BY sub.ent_uid;

SELECT '' AS x;
SELECT '═══ ۵. سلامت ═══' AS section;
SELECT severity, COUNT(*) AS n FROM e04_900_02_vw GROUP BY severity;
