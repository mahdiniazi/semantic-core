-- v139.1 — افزودن قاعده‌ی جای‌گذاری برای نوع Role + resolve خودکار pending
.mode column
.headers on

BEGIN;

-- ═══ گام ۱: ساخت concept:role-catalog (namespace برای نقش‌ها) ═══
INSERT OR IGNORE INTO e01_200_03_tb (ent_uid, type_id, nature, label, description, prv_id)
SELECT 
  'concept:role-catalog',
  type_id,
  'concept',
  'کاتالوگ نقش‌ها',
  'Namespace for all role definitions — همه‌ی نقش‌ها زیر این مفهوم قرار می‌گیرند',
  2
FROM e01_200_03_tb WHERE ent_uid = 'concept:vehicle';

-- ═══ گام ۲: ثبت concept:role-catalog در registry + matrix + policy ═══
INSERT OR IGNORE INTO e01_506_03_tb 
  (element_name, element_code, element_layer, element_kind, element_level, need_uid, purpose)
VALUES 
  ('concept:role-catalog', NULL, 'M', 'tb', 2, 'N50', 'Namespace برای نقش‌های پایه و زیرنقش‌ها');

-- ═══ گام ۳: افزودن قاعده‌ی جای‌گذاری برای type «Role» ═══
INSERT OR IGNORE INTO e01_200_04_tb 
  (type_id, target_uid, placement_kind, is_default, note)
VALUES (
  (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Role'),
  'concept:role-catalog',
  'inherent_to',
  1,
  'همه‌ی نقش‌ها به کاتالوگ نقش‌ها تعلق دارند'
);

-- ═══ گام ۴: log + bump ═══
INSERT OR IGNORE INTO e01_676_01_tb (migration_uid, notes)
VALUES ('v139.1_role_placement',
        'Added placement rule for Role type + role-catalog concept');

UPDATE e01_676_02_tb SET schema_ver = schema_ver + 1 WHERE id = 1;

COMMIT;

-- ═══ POST-CHECK ═══
SELECT '═══ ۱. قاعده‌ی جدید ═══' AS section;
SELECT r.type_id, t.type_uid, r.target_uid, r.placement_kind, r.is_default
FROM e01_200_04_tb r
JOIN e01_200_01_tb t ON t.type_id = r.type_id
WHERE t.type_uid = 'Role';

SELECT '' AS x;
SELECT '═══ ۲. صف انتظار pending (باید ۰ باشد) ═══' AS section;
SELECT COUNT(*) AS pending_count FROM e01_200_05_tb WHERE status = 'pending';

SELECT '' AS x;
SELECT '═══ ۳. وضعیت pendingها ═══' AS section;
SELECT status, COUNT(*) AS n FROM e01_200_05_tb GROUP BY status;

SELECT '' AS x;
SELECT '═══ ۴. روابط جدید auto-place ═══' AS section;
SELECT COUNT(*) AS auto_relations 
FROM e01_222_01_tb 
WHERE rel_uid LIKE 'r:auto-%' AND superseded_at IS NULL;

SELECT '' AS x;
SELECT '═══ ۵. نمونه روابط auto-place برای نقش‌ها ═══' AS section;
SELECT subj.ent_uid AS source, obj.ent_uid AS target, rt.type_uid AS kind
FROM e01_222_01_tb r
JOIN e01_202_01_tb rt ON rt.reltype_id = r.reltype_id
JOIN e01_200_03_tb subj ON subj.ent_id = r.subj_ent_id
JOIN e01_200_03_tb obj ON obj.ent_id = r.obj_ent_id
WHERE r.rel_uid LIKE 'r:auto-%' 
  AND obj.ent_uid LIKE 'role:%'
ORDER BY obj.ent_uid
LIMIT 10;

SELECT '' AS x;
SELECT '═══ ۶. سلامت ═══' AS section;
SELECT severity, COUNT(*) AS n FROM e04_900_02_vw GROUP BY severity;

SELECT '' AS x;
SELECT '═══ ۷. اگر watch باقی ماند، چه هستند؟ ═══' AS section;
SELECT kind, item, issue FROM e04_900_02_vw WHERE severity='watch';
