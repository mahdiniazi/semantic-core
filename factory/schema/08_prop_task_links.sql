-- اتصال گزاره‌های کلیدی به وظایف WBS
INSERT INTO proposition_task_link (project_id, prop_id, task_id, link_type)
SELECT 'semantic-core',
       (SELECT prop_id FROM atomic_propositions WHERE project_id='semantic-core' AND prop_code=prop_code_ref),
       (SELECT task_id FROM wbs_tasks WHERE project_id='semantic-core' AND task_code=task_code_ref),
       link_type
FROM (VALUES
  -- زیرساخت
  ('C-059', '1.1.1', 'requires'),  -- تصمیم مهم باید قابل بازسازی باشد
  ('C-059', '1.1.2', 'requires'),
  ('C-059', '1.2.1', 'supports'),  -- roadmap.sh
  ('C-059', '1.2.2', 'supports'),  -- task.sh
  ('C-060', '1.3.1', 'requires'),  -- AI نباید بدون قرارداد حقیقت بسازد → AI_HANDOFF
  ('C-060', '1.3.2', 'requires'),
  ('C-060', '1.3.3', 'verifies'),

  -- مدل دامنه
  ('D-011', '2.1.1', 'supports'),  -- Entity + سلسله‌مراتب
  ('D-016', '2.1.2', 'supports'),
  ('D-017', '2.2.1', 'supports'),  -- Pin/Port + entity ویژگی
  ('D-018', '2.2.2', 'supports'),
  ('D-021', '2.3.1', 'supports'),  -- Connection + رابطه
  ('D-022', '2.3.2', 'supports'),
  ('D-023', '2.3.3', 'supports'),
  ('D-063', '2.4.1', 'supports'),  -- Context + بافت
  ('D-063', '2.4.2', 'supports'),
  ('D-063', '2.4.3', 'supports'),

  -- حاکمیت دانش
  ('G-004', '3.1.1', 'supports'),  -- Claim + entity
  ('G-004', '3.1.2', 'supports'),
  ('G-004', '3.1.3', 'supports'),
  ('G-004', '3.1.4', 'supports'),
  ('G-047', '3.2.1', 'supports'),  -- Evidence + ابعاد
  ('G-059', '3.2.2', 'supports'),
  ('G-059', '3.2.3', 'supports'),
  ('G-047', '3.2.4', 'supports'),
  ('G-100', '3.3.1', 'supports'),  -- Versioning
  ('G-103', '3.3.2', 'supports'),
  ('G-104', '3.3.3', 'supports'),
  ('G-091', '3.4.1', 'supports'),  -- Conflict + حل تعارض
  ('G-092', '3.4.2', 'supports'),

  -- موتور تشخیص
  ('E-025', '4.1.1', 'supports'),  -- Episode
  ('E-025', '4.1.2', 'supports'),
  ('E-025', '4.1.3', 'supports'),
  ('E-069', '4.2.1', 'supports'),  -- Hypothesis + ساختار
  ('E-069', '4.2.2', 'supports'),
  ('E-096', '4.2.3', 'supports'),
  ('E-081', '4.2.4', 'supports'),  -- محدودسازی
  ('E-102', '4.3.1', 'supports'),  -- Test + اجزا
  ('E-104', '4.3.2', 'supports'),
  ('E-117', '4.3.3', 'supports'),  -- انتخاب آزمون
  ('E-146', '4.4.1', 'supports'),  -- Decision
  ('E-147', '4.4.2', 'supports'),
  ('E-150', '4.4.3', 'supports'),  -- Referral
  ('E-154', '4.5.1', 'supports'),  -- Verification
  ('E-158', '4.5.2', 'supports')   -- Counterfactual
) AS t(prop_code_ref, task_code_ref, link_type)
ON CONFLICT (prop_id, task_id, link_type) DO NOTHING;
