-- v104 — نمای درختی کامل برای یک خودروی خاص
.mode column
.headers on

-- ═══════════════════════════════════════════════════════
-- view: درخت ارث‌بری از خودرو تا قطعه
-- ═══════════════════════════════════════════════════════
DROP VIEW IF EXISTS v_vehicle_tree;
CREATE VIEW v_vehicle_tree AS
WITH RECURSIVE
  -- گام ۱: concept خودرو + اجدادش
  ancestors(uid, level) AS (
    SELECT 'concept:pride', 0
    UNION
    SELECT obj.ent_uid, a.level + 1
    FROM ancestors a
    JOIN e01_200_03_tb sub ON sub.ent_uid = a.uid
    JOIN e01_222_01_tb r ON r.subj_ent_id = sub.ent_id
      AND r.status='asserted' AND r.superseded_at IS NULL
    JOIN e01_202_01_tb rt ON rt.reltype_id = r.reltype_id AND rt.type_uid='is_a'
    JOIN e01_200_03_tb obj ON obj.ent_id = r.obj_ent_id
    WHERE a.level < 10
  ),
  -- گام ۲: درخت ارث‌بری (recursive از ancestors)
  tree(parent_uid, child_uid, obligation, depth, path) AS (
    -- شروع: خود مفهوم پراید
    SELECT 
      NULL,
      'concept:pride',
      'root',
      0,
      'concept:pride'
    
    UNION
    
    -- لاجرم‌ها از ancestors
    SELECT
      a.uid,
      obj.ent_uid,
      'inherent',
      1,
      a.uid || ' → ' || obj.ent_uid
    FROM ancestors a
    JOIN e01_200_03_tb sub ON sub.ent_uid = a.uid
    JOIN e01_222_01_tb r ON r.subj_ent_id = sub.ent_id
      AND r.status='asserted' AND r.superseded_at IS NULL
    JOIN e01_202_01_tb rt ON rt.reltype_id = r.reltype_id AND rt.type_uid='inherent_to'
    JOIN e01_200_03_tb obj ON obj.ent_id = r.obj_ent_id
    
    UNION
    
    -- زنجیره‌ی inherent به inherent
    SELECT
      t.child_uid,
      obj.ent_uid,
      'inherent',
      t.depth + 1,
      t.path || ' → ' || obj.ent_uid
    FROM tree t
    JOIN e01_200_03_tb sub ON sub.ent_uid = t.child_uid
    JOIN e01_222_01_tb r ON r.subj_ent_id = sub.ent_id
      AND r.status='asserted' AND r.superseded_at IS NULL
    JOIN e01_202_01_tb rt ON rt.reltype_id = r.reltype_id AND rt.type_uid='inherent_to'
    JOIN e01_200_03_tb obj ON obj.ent_id = r.obj_ent_id
    WHERE t.depth < 6
    
    UNION
    
    -- انتخاب‌های instance
    SELECT
      'vehicle:pride-24IR12345',
      obj.ent_uid,
      'chosen',
      1,
      'vehicle:pride-24IR12345 → ' || obj.ent_uid
    FROM e01_222_01_tb r
    JOIN e01_202_01_tb rt ON rt.reltype_id = r.reltype_id AND rt.type_uid='has_direct_part'
    JOIN e01_200_03_tb obj ON obj.ent_id = r.obj_ent_id
    WHERE r.subj_ent_id = (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='vehicle:pride-24IR12345')
      AND r.status='asserted' AND r.superseded_at IS NULL
  )
SELECT 
  depth,
  parent_uid,
  child_uid,
  obligation,
  path,
  (SELECT label FROM e01_200_03_tb WHERE ent_uid = child_uid) AS child_label
FROM tree;

-- ═══════════════════════════════════════════════════════
-- گزارش
-- ═══════════════════════════════════════════════════════

SELECT '═══ ۱. آمار کلی ═══' AS section;
SELECT obligation, COUNT(*) AS n
FROM v_vehicle_tree
GROUP BY obligation;

SELECT '' AS x;
SELECT '═══ ۲. سطح ۱: دامنه‌ها ═══' AS section;
SELECT child_label AS domain, obligation
FROM v_vehicle_tree
WHERE depth = 1 AND obligation='inherent'
ORDER BY child_label;

SELECT '' AS x;
SELECT '═══ ۳. سطح ۲: زیرسیستم‌ها ═══' AS section;
SELECT child_label AS subsystem, obligation
FROM v_vehicle_tree
WHERE depth = 2 AND obligation='inherent'
ORDER BY child_label;

SELECT '' AS x;
SELECT '═══ ۴. سطح ۳: قطعات (نمونه) ═══' AS section;
SELECT child_label AS part
FROM v_vehicle_tree
WHERE depth = 3 AND obligation='inherent'
ORDER BY child_label
LIMIT 20;

SELECT '' AS x;
SELECT '═══ ۵. انتخاب‌های احمدی ═══' AS section;
SELECT child_label AS chosen_item
FROM v_vehicle_tree
WHERE obligation='chosen';
