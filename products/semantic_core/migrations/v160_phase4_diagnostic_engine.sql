-- v160: تکمیل فاز ۴ — انواع گمشده موتور تشخیص
-- 4.1.1، 4.1.2، 4.2.1، 4.2.2، 4.3.2، 4.4.1، 4.4.2، 4.4.3، 4.5.1، 4.5.2

-- ۱. نوع Episode (اگر نیست)
INSERT OR IGNORE INTO e01_200_01_tb (type_uid, label, description, is_abstract)
VALUES ('Episode','اپیزود تشخیصی','یک چرخه کامل تشخیص از نشانه تا راستی‌آزمایی', 0);

-- ۲. state machine Episode — 6 role/state برای فازها
INSERT OR IGNORE INTO e01_200_01_tb (type_uid, label, description, is_abstract)
VALUES ('EpisodeState','وضعیت اپیزود','هر فاز از چرخه تشخیص', 0);

-- ۳. نوع Verification
INSERT OR IGNORE INTO e01_200_01_tb (type_uid, label, description, is_abstract)
VALUES ('Verification','راستی‌آزمایی','تأیید مستقل بازگشت رفتار مورد انتظار', 0);

-- ۴. نوع Decision
INSERT OR IGNORE INTO e01_200_01_tb (type_uid, label, description, is_abstract)
VALUES ('Decision','تصمیم','نتیجه تشخیصی نهایی + سطح اطمینان', 0);

-- ۵. سطوح Decision (زیرشاخه)
INSERT OR IGNORE INTO e01_200_01_tb (type_uid, label, description, parent_id, is_abstract)
VALUES ('DecisionConfirmed','تصمیم تأییدشده','اطمینان کافی برای اقدام', (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Decision'), 0);
INSERT OR IGNORE INTO e01_200_01_tb (type_uid, label, description, parent_id, is_abstract)
VALUES ('DecisionReferral','تصمیم ارجاع','نیاز به متخصص یا آزمون بیشتر', (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Decision'), 0);

-- ۶. reltypes گمشده فاز ۴
INSERT OR IGNORE INTO e01_202_01_tb (type_uid, label, object_kind, is_functional)
VALUES ('predicts','پیش‌بینی می‌کند','entity', 0);
INSERT OR IGNORE INTO e01_202_01_tb (type_uid, label, object_kind, is_functional)
VALUES ('interprets','تفسیر می‌کند','entity', 0);
INSERT OR IGNORE INTO e01_202_01_tb (type_uid, label, object_kind, is_functional)
VALUES ('refer_to','ارجاع به','entity', 0);
INSERT OR IGNORE INTO e01_202_01_tb (type_uid, label, object_kind, is_functional)
VALUES ('counterfactual_of','نقض‌پذیرِ','entity', 0);
INSERT OR IGNORE INTO e01_202_01_tb (type_uid, label, object_kind, is_functional)
VALUES ('episode_has_state','اپیزود در وضعیت','entity', 0);

-- ۷. اصلاح type_id باگ verification (كاندید: type_id=1)
UPDATE e01_200_03_tb
SET type_id = (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Verification')
WHERE ent_uid = 'verification:p0301-passed';

-- ۸. اصلاح نوع episode (اگر 572 اشتباه است — فایل اگر DiagnosticEpisode باشد skip می‌شود)
UPDATE e01_200_03_tb
SET type_id = (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Episode')
WHERE ent_uid = 'episode:p0301-cold-start-2026'
  AND (SELECT type_uid FROM e01_200_01_tb WHERE type_id=e01_200_03_tb.type_id) NOT IN ('Episode','DiagnosticEpisode');

-- ۹. ثبت در migration log
INSERT OR IGNORE INTO e01_676_01_tb (migration_uid, notes)
VALUES ('v160_phase4_diagnostic_engine','Phase 4: Episode state machine + Verification + Decision + 5 reltypes');

COMMIT;
