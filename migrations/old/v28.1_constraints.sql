-- =====================================================================
-- v28.1 — Seed Relation Constraints (e01_112_01_tb)
-- هدف: بیدار کردن نگهبان‌های روابط
-- =====================================================================
.mode column
.headers on

BEGIN;

-- =====================================================================
-- ۱. instance_of — هر instance به یک concept
-- =====================================================================
INSERT INTO e01_112_01_tb (reltype_id, cons_kind, target_type_id, target_nature)
SELECT (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='instance_of'),
       'allowed_subject_nature', NULL, 'instance'
UNION ALL
SELECT (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='instance_of'),
       'allowed_object_nature', NULL, 'concept';

-- =====================================================================
-- ۲. is_a — concept به concept (زیرگروه)
-- =====================================================================
INSERT INTO e01_112_01_tb (reltype_id, cons_kind, target_type_id, target_nature)
SELECT (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='is_a'),
       'allowed_subject_nature', NULL, 'concept'
UNION ALL
SELECT (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='is_a'),
       'allowed_object_nature', NULL, 'concept';

-- =====================================================================
-- ۳. has_failure_mode — Unit → FailureMode
-- =====================================================================
INSERT INTO e01_112_01_tb (reltype_id, cons_kind, target_type_id, target_nature)
SELECT (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='has_failure_mode'),
       'allowed_subject_type',
       (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Unit'),
       NULL
UNION ALL
SELECT (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='has_failure_mode'),
       'allowed_object_type',
       (SELECT type_id FROM e01_200_01_tb WHERE type_uid='FailureMode'),
       NULL;

-- =====================================================================
-- ۴. manifests_as — FailureMode → DTC
-- =====================================================================
INSERT INTO e01_112_01_tb (reltype_id, cons_kind, target_type_id, target_nature)
SELECT (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='manifests_as'),
       'allowed_subject_type',
       (SELECT type_id FROM e01_200_01_tb WHERE type_uid='FailureMode'),
       NULL
UNION ALL
SELECT (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='manifests_as'),
       'allowed_object_type',
       (SELECT type_id FROM e01_200_01_tb WHERE type_uid='DTC'),
       NULL;

-- =====================================================================
-- ۵. has_vin — فقط Vehicle → Value
-- =====================================================================
INSERT INTO e01_112_01_tb (reltype_id, cons_kind, target_type_id, target_nature)
SELECT (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='has_vin'),
       'allowed_subject_type',
       (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Vehicle'),
       NULL
UNION ALL
SELECT (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='has_vin'),
       'allowed_object_nature', NULL, 'concept';  -- value entity
-- توجه: object_kind این رابطه value است، پس تریگر جداگانه چک می‌کند

-- =====================================================================
-- ۶. installed_on — Unit → Vehicle
-- =====================================================================
INSERT INTO e01_112_01_tb (reltype_id, cons_kind, target_type_id, target_nature)
SELECT (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='installed_on'),
       'allowed_subject_type',
       (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Unit'),
       NULL
UNION ALL
SELECT (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='installed_on'),
       'allowed_object_type',
       (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Vehicle'),
       NULL;

-- =====================================================================
-- ۷. controls — ECU → Actuator
-- =====================================================================
INSERT INTO e01_112_01_tb (reltype_id, cons_kind, target_type_id, target_nature)
SELECT (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='controls'),
       'allowed_subject_type',
       (SELECT type_id FROM e01_200_01_tb WHERE type_uid='ECU'),
       NULL
UNION ALL
SELECT (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='controls'),
       'allowed_object_type',
       (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Actuator'),
       NULL;

-- =====================================================================
-- ۸. measures — Sensor → Unit
-- =====================================================================
INSERT INTO e01_112_01_tb (reltype_id, cons_kind, target_type_id, target_nature)
SELECT (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='measures'),
       'allowed_subject_type',
       (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Sensor'),
       NULL
UNION ALL
SELECT (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='measures'),
       'allowed_object_type',
       (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Unit'),
       NULL;

-- =====================================================================
-- ۹. reports_dtc — ECU → DTC
-- =====================================================================
INSERT INTO e01_112_01_tb (reltype_id, cons_kind, target_type_id, target_nature)
SELECT (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='reports_dtc'),
       'allowed_subject_type',
       (SELECT type_id FROM e01_200_01_tb WHERE type_uid='ECU'),
       NULL
UNION ALL
SELECT (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='reports_dtc'),
       'allowed_object_type',
       (SELECT type_id FROM e01_200_01_tb WHERE type_uid='DTC'),
       NULL;

-- =====================================================================
-- ۱۰. communicates_over — ECU → Bus
-- =====================================================================
INSERT INTO e01_112_01_tb (reltype_id, cons_kind, target_type_id, target_nature)
SELECT (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='communicates_over'),
       'allowed_subject_type',
       (SELECT type_id FROM e01_200_01_tb WHERE type_uid='ECU'),
       NULL
UNION ALL
SELECT (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='communicates_over'),
       'allowed_object_type',
       (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Bus'),
       NULL;

-- =====================================================================
-- ۱۱. carries_signal — Pin → Signal
-- =====================================================================
INSERT INTO e01_112_01_tb (reltype_id, cons_kind, target_type_id, target_nature)
SELECT (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='carries_signal'),
       'allowed_subject_type',
       (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Pin'),
       NULL
UNION ALL
SELECT (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='carries_signal'),
       'allowed_object_type',
       (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Signal'),
       NULL;

-- =====================================================================
-- ۱۲. powered_by — Unit → Unit (ولتاژ)
-- =====================================================================
INSERT INTO e01_112_01_tb (reltype_id, cons_kind, target_type_id, target_nature)
SELECT (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='powered_by'),
       'allowed_subject_type',
       (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Unit'),
       NULL
UNION ALL
SELECT (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='powered_by'),
       'allowed_object_type',
       (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Unit'),
       NULL;

-- =====================================================================
-- ثبت در رجیستری + لاگ
-- =====================================================================
INSERT OR IGNORE INTO e01_676_01_tb (migration_uid, notes)
VALUES ('v28.1_constraints',
        'Seeded ' || (SELECT COUNT(*) FROM e01_112_01_tb) || ' relation constraints');

UPDATE e01_676_02_tb SET schema_ver = schema_ver + 1 WHERE id = 1;

COMMIT;

-- =====================================================================
-- گزارش
-- =====================================================================
SELECT '=== قیدها بر اساس نوع ===' AS section;
SELECT cons_kind, COUNT(*) AS n
FROM e01_112_01_tb
GROUP BY cons_kind ORDER BY n DESC;

SELECT '=== نوع رابطه‌هایی که قید دارند ===' AS section;
SELECT rt.type_uid, COUNT(c.cons_id) AS n_constraints
FROM e01_202_01_tb rt
LEFT JOIN e01_112_01_tb c ON c.reltype_id = rt.reltype_id
GROUP BY rt.reltype_id
HAVING n_constraints > 0
ORDER BY n_constraints DESC;
