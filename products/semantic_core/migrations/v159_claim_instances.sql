-- v159: ساخت نمونه‌های Claim + زیرشاخه‌های نوعی
-- تسک‌های مرتبط: 3.1.1، 3.1.2

-- ۱. زیرشاخه‌های Claim (3.1.2)
INSERT INTO e01_200_01_tb (type_uid, label, description, parent_id, is_abstract) VALUES
 ('PhysicalClaim','ادعای فیزیکی','ادعا درباره کمیت یا ویژگی فیزیکی قابل اندازه‌گیری', 16, 0),
 ('FunctionalClaim','ادعای کارکردی','ادعا درباره کارکرد یک قطعه یا سیستم', 16, 0),
 ('DiagnosticClaim','ادعای تشخیصی','ادعا درباره علت یک عیب مشخص', 16, 0);

-- ۲. سه نمونه Claim (3.1.1)
INSERT INTO e01_200_03_tb (ent_uid, type_id, nature, label, description) VALUES
 ('claim:p0301-coil-resistance',
  (SELECT type_id FROM e01_200_01_tb WHERE type_uid='PhysicalClaim'),
  'instance',
  'ادعا: مقاومت کوئل سیلندر ۱ بی‌نهایت است',
  'ادعای فیزیکی درباره مقاومت سیم‌پیچ اولیه کوئل'),
 ('claim:p0301-coil-open',
  (SELECT type_id FROM e01_200_01_tb WHERE type_uid='DiagnosticClaim'),
  'instance',
  'ادعا: کوئل سیلندر ۱ قطع است',
  'ادعای تشخیصی درباره علت P0301'),
 ('claim:p0301-spark-ok',
  (SELECT type_id FROM e01_200_01_tb WHERE type_uid='FunctionalClaim'),
  'instance',
  'ادعا: جرقه شمع سیلندر ۱ سالم است',
  'ادعای کارکردی که فرضیه کوئل قطع را تضعیف می‌کند');

INSERT INTO e01_676_01_tb (migration_uid, notes) VALUES ('v159_claim_instances','3 Claim instances + 3 subtypes');
