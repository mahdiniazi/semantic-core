-- =====================================================================
-- v29.4 — اصلاح نوع موجودیت‌های قدیمی
-- =====================================================================
.mode column
.headers on

BEGIN;

-- ۱. باتری: از نوع کلی Battery به نوع مشخص LeadAcidBattery
UPDATE e01_200_03_tb 
SET type_id = (SELECT type_id FROM e01_200_01_tb WHERE type_uid='LeadAcidBattery'),
    updated_at = datetime('now')
WHERE ent_uid = 'battery:generic';

-- ۲. محیط‌ها: از Configuration به OperatingState
UPDATE e01_200_03_tb 
SET type_id = (SELECT type_id FROM e01_200_01_tb WHERE type_uid='OperatingState'),
    updated_at = datetime('now')
WHERE ent_uid IN ('env:high-humidity', 'env:hot-weather');

-- ۳. لاگ
INSERT OR IGNORE INTO e01_676_01_tb (migration_uid, notes)
VALUES ('v29.4_retype_old_entities',
        'Retyped 3 entities: battery→LeadAcidBattery, env→OperatingState');

UPDATE e01_676_02_tb SET schema_ver = schema_ver + 1, last_scan_at = datetime('now') WHERE id = 1;

COMMIT;

-- گزارش
SELECT e.ent_uid, t.type_uid AS new_type
FROM e01_200_03_tb e
JOIN e01_200_01_tb t ON t.type_id = e.type_id
WHERE e.ent_uid IN ('battery:generic', 'env:high-humidity', 'env:hot-weather');
