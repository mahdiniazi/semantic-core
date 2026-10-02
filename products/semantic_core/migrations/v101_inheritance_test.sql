-- v101 — تست ارث‌بری: این خودروی خاص چه چیزهایی دارد؟
.mode column
.headers on

-- ═══════════════════════════════════════════════════════
-- تست ۱: پراید احمدی — لاجرم‌ها + design انتخاب‌شده
-- ═══════════════════════════════════════════════════════
SELECT '═══ ۱. پراید احمدی (IR12345) ═══' AS section;

WITH RECURSIVE 
  -- همه conceptهای اجداد
  concepts(uid, level) AS (
    SELECT 'concept:pride', 0
    UNION
    SELECT obj.ent_uid, c.level + 1
    FROM concepts c
    JOIN e01_200_03_tb sub ON sub.ent_uid = c.uid
    JOIN e01_222_01_tb r ON r.subj_ent_id = sub.ent_id
      AND r.status='asserted' AND r.superseded_at IS NULL
    JOIN e01_202_01_tb rt ON rt.reltype_id = r.reltype_id AND rt.type_uid='is_a'
    JOIN e01_200_03_tb obj ON obj.ent_id = r.obj_ent_id
    WHERE c.level < 5
  ),
  -- همه قطعات از این conceptها با has_direct_part و inherent_to
  parts_from_concepts(part_uid, obligation, depth, via) AS (
    SELECT obj.ent_uid, rt.type_uid, 1, sub.ent_uid
    FROM concepts c
    JOIN e01_200_03_tb sub ON sub.ent_uid = c.uid
    JOIN e01_222_01_tb r ON r.subj_ent_id = sub.ent_id
      AND r.status='asserted' AND r.superseded_at IS NULL
    JOIN e01_202_01_tb rt ON rt.reltype_id = r.reltype_id
      AND rt.type_uid IN ('has_direct_part','inherent_to')
    JOIN e01_200_03_tb obj ON obj.ent_id = r.obj_ent_id
  ),
  -- لاجرم‌ها (inherent + has_direct)
  all_parts(part_uid, source) AS (
    SELECT part_uid, 'inherited-mandatory'
    FROM parts_from_concepts 
    WHERE obligation = 'inherent_to'
    
    UNION
    
    SELECT part_uid, 'inherited-design'
    FROM parts_from_concepts
    WHERE obligation = 'has_direct_part'
    
    UNION
    
    -- انتخاب‌های instance
    SELECT obj.ent_uid, 'selected-option'
    FROM e01_222_01_tb r
    JOIN e01_202_01_tb rt ON rt.reltype_id = r.reltype_id AND rt.type_uid='has_direct_part'
    JOIN e01_200_03_tb obj ON obj.ent_id = r.obj_ent_id
    WHERE r.subj_ent_id = (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='vehicle:pride-24IR12345')
      AND r.status='asserted' AND r.superseded_at IS NULL
  )
SELECT source, COUNT(DISTINCT part_uid) AS n
FROM all_parts
GROUP BY source
ORDER BY source;

-- ═══════════════════════════════════════════════════════
-- تست ۲: پراید ساده (IR99999) — بدون انتخاب اضافی
-- ═══════════════════════════════════════════════════════
SELECT '' AS x, '' AS y;
SELECT '═══ ۲. پراید ساده (IR99999) ═══' AS section;

WITH RECURSIVE 
  concepts(uid, level) AS (
    SELECT 'concept:pride', 0
    UNION
    SELECT obj.ent_uid, c.level + 1
    FROM concepts c
    JOIN e01_200_03_tb sub ON sub.ent_uid = c.uid
    JOIN e01_222_01_tb r ON r.subj_ent_id = sub.ent_id
      AND r.status='asserted' AND r.superseded_at IS NULL
    JOIN e01_202_01_tb rt ON rt.reltype_id = r.reltype_id AND rt.type_uid='is_a'
    JOIN e01_200_03_tb obj ON obj.ent_id = r.obj_ent_id
    WHERE c.level < 5
  ),
  all_parts(part_uid, source) AS (
    SELECT obj.ent_uid, 'inherited-' || rt.type_uid
    FROM concepts c
    JOIN e01_200_03_tb sub ON sub.ent_uid = c.uid
    JOIN e01_222_01_tb r ON r.subj_ent_id = sub.ent_id
      AND r.status='asserted' AND r.superseded_at IS NULL
    JOIN e01_202_01_tb rt ON rt.reltype_id = r.reltype_id
      AND rt.type_uid IN ('has_direct_part','inherent_to')
    JOIN e01_200_03_tb obj ON obj.ent_id = r.obj_ent_id
    
    UNION
    
    SELECT obj.ent_uid, 'selected-option'
    FROM e01_222_01_tb r
    JOIN e01_202_01_tb rt ON rt.reltype_id = r.reltype_id AND rt.type_uid='has_direct_part'
    JOIN e01_200_03_tb obj ON obj.ent_id = r.obj_ent_id
    WHERE r.subj_ent_id = (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='vehicle:pride-24IR99999')
      AND r.status='asserted' AND r.superseded_at IS NULL
  )
SELECT source, COUNT(DISTINCT part_uid) AS n
FROM all_parts
GROUP BY source
ORDER BY source;
