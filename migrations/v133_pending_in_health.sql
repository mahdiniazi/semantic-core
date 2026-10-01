-- v133 — افزودن pending به view سلامت (همان view، بدون view جدید)
.mode column
.headers on

BEGIN;

DROP VIEW IF EXISTS e04_900_02_vw;

CREATE VIEW e04_900_02_vw AS
-- ═══ ۱. نیاز بدون سیاست ═══
SELECT 'need' AS kind, n.need_uid AS item, 'بدون سیاست' AS issue, 'critical' AS severity
FROM e01_506_01_tb n
WHERE NOT EXISTS (SELECT 1 FROM e01_778_05_tb p WHERE p.need_uid = n.need_uid)

-- ═══ ۲. عنصر در schema نیست ═══
UNION ALL SELECT 'element', e.element_name, 'در schema نیست', 'critical'
FROM e01_506_03_tb e
WHERE e.element_kind IN ('tb','tr','vw','ft') AND e.element_name NOT LIKE 'POLICY:%'
  AND NOT EXISTS (SELECT 1 FROM sqlite_master sm WHERE sm.name = e.element_name)

-- ═══ ۳. عنصر در matrix نیست ═══
UNION ALL SELECT 'element', e.element_name, 'در matrix نیست', 'critical'
FROM e01_506_03_tb e
WHERE e.element_kind IN ('tb','tr','vw','ft') AND e.element_name NOT LIKE 'POLICY:%'
  AND NOT EXISTS (SELECT 1 FROM e01_778_02_tb m WHERE m.element_name = e.element_name)

-- ═══ ۴. entity بدون prv ═══
UNION ALL SELECT 'entity', e.ent_uid, 'prv خالی', 'critical'
FROM e01_200_03_tb e WHERE e.prv_id IS NULL

-- ═══ ۵. relation subject نامعتبر ═══
UNION ALL SELECT 'relation', r.rel_uid, 'subject نامعتبر', 'critical'
FROM e01_222_01_tb r
WHERE r.status='asserted' AND r.superseded_at IS NULL
  AND NOT EXISTS (SELECT 1 FROM e01_200_03_tb e WHERE e.ent_id = r.subj_ent_id)

-- ═══ ۶. relation object نامعتبر ═══
UNION ALL SELECT 'relation', r.rel_uid, 'object نامعتبر', 'critical'
FROM e01_222_01_tb r
WHERE r.status='asserted' AND r.superseded_at IS NULL AND r.obj_ent_id IS NOT NULL
  AND NOT EXISTS (SELECT 1 FROM e01_200_03_tb e WHERE e.ent_id = r.obj_ent_id)

-- ═══ ۷. policy بدون element ═══
UNION ALL SELECT 'policy', p.element_name, 'element نامعتبر', 'critical'
FROM e01_778_05_tb p
WHERE NOT EXISTS (SELECT 1 FROM e01_506_03_tb e WHERE e.element_name = p.element_name)

-- ═══ ۸. trigger بدون registry ═══
UNION ALL SELECT 'trigger', sm.name, 'در registry نیست', 'critical'
FROM sqlite_master sm
WHERE sm.type='trigger' AND sm.name LIKE 'e03%'
  AND NOT EXISTS (SELECT 1 FROM e01_506_03_tb e WHERE e.element_name = sm.name)

-- ═══ ۹. trigger بدون anchor ═══
UNION ALL SELECT 'trigger', sm.name, 'anchor ندارد', 'critical'
FROM sqlite_master sm
WHERE sm.type='trigger' AND sm.name LIKE 'e03%'
  AND NOT EXISTS (SELECT 1 FROM e01_778_05_tb p WHERE p.exec_name = sm.name)

-- ═══ ۱۰. FK بدون anchor ═══
UNION ALL SELECT 'fk', f.child_table || '.' || f.child_col, 'anchor ندارد', 'critical'
FROM e01_378_01_tb f
WHERE NOT EXISTS (SELECT 1 FROM e01_778_05_tb p WHERE p.fk_ref_id = f.ref_id AND p.policy_kind='fk')

-- ═══ ۱۱. closure یتیم ═══
UNION ALL SELECT 'closure', CAST(c.desc_id AS TEXT)||'→'||CAST(c.anc_id AS TEXT), 'type یتیم', 'critical'
FROM e01_120_01_tb c
WHERE NOT EXISTS (SELECT 1 FROM e01_200_01_tb t WHERE t.type_id = c.desc_id)
   OR NOT EXISTS (SELECT 1 FROM e01_200_01_tb t WHERE t.type_id = c.anc_id)

-- ═══ ۱۲. context نامعتبر ═══
UNION ALL SELECT 'context', CAST(c.ctx_id AS TEXT), 'relation نامعتبر', 'critical'
FROM e01_305_03_tb c
WHERE NOT EXISTS (SELECT 1 FROM e01_222_01_tb r WHERE r.rel_id = c.rel_id)

-- ═══ ۱۳. version نامعتبر ═══
UNION ALL SELECT 'version', CAST(v.vers_id AS TEXT), 'entity نامعتبر', 'critical'
FROM e01_330_01_tb v
WHERE NOT EXISTS (SELECT 1 FROM e01_200_03_tb e WHERE e.ent_id = v.ent_id)

-- ═══ ۱۴. identity نامعتبر ═══
UNION ALL SELECT 'identity', CAST(c.clm_id AS TEXT), 'entity نامعتبر', 'critical'
FROM e01_300_01_tb c
WHERE NOT EXISTS (SELECT 1 FROM e01_200_03_tb e WHERE e.ent_id = c.ent_a_id)
   OR NOT EXISTS (SELECT 1 FROM e01_200_03_tb e WHERE e.ent_id = c.ent_b_id)

-- ═══ ۱۵. PENDING — منتظر قاعده جای‌گذاری ═══
UNION ALL SELECT 'pending', p.ent_uid,
  'منتظر قاعده برای نوع ' || t.type_uid,
  'watch'
FROM e01_200_05_tb p
JOIN e01_200_01_tb t ON t.type_id = p.type_id
WHERE p.status = 'pending'

-- ═══ ۱۶. type بدون نمونه ═══
UNION ALL SELECT 'type', t.type_uid, 'بدون نمونه', 'info'
FROM e01_200_01_tb t
WHERE NOT EXISTS (SELECT 1 FROM e01_200_03_tb e WHERE e.type_id = t.type_id)

-- ═══ ۱۷. reltype بدون رابطه ═══
UNION ALL SELECT 'reltype', t.type_uid, 'بدون رابطه', 'info'
FROM e01_202_01_tb t
WHERE NOT EXISTS (SELECT 1 FROM e01_222_01_tb r WHERE r.reltype_id = t.reltype_id);

INSERT OR IGNORE INTO e01_676_01_tb (migration_uid, notes)
VALUES ('v133_pending_in_health','Added pending items to health view');

UPDATE e01_676_02_tb SET schema_ver = schema_ver + 1 WHERE id = 1;

COMMIT;

-- ═══ گزارش ═══
SELECT '═══ وضعیت سلامت ═══' AS section;
SELECT severity, COUNT(*) AS n FROM e04_900_02_vw GROUP BY severity;

SELECT '' AS x;
SELECT '═══ critical ═══' AS section;
SELECT kind, item, issue FROM e04_900_02_vw WHERE severity='critical';

SELECT '' AS x;
SELECT '═══ watch ═══' AS section;
SELECT kind, item, issue FROM e04_900_02_vw WHERE severity='watch';
