-- Level 1
INSERT INTO wbs_tasks (project_id, task_code, task_name, parent_task_id, level, is_atomic, status_id)
SELECT 'semantic-core', code, name, NULL, 1, FALSE,
       (SELECT status_id FROM statuses WHERE project_id='semantic-core' AND status_code='active')
FROM (VALUES
  ('1', 'زیرساخت'),
  ('2', 'مدل دامنه'),
  ('3', 'حاکمیت دانش'),
  ('4', 'موتور تشخیص'),
  ('5', 'بنیان کسب‌وکار')
) AS t(code, name)
ON CONFLICT (project_id, task_code) DO NOTHING;

-- Level 2
INSERT INTO wbs_tasks (project_id, task_code, task_name, parent_task_id, level, is_atomic, status_id)
SELECT 'semantic-core', code, name,
       (SELECT task_id FROM wbs_tasks WHERE project_id='semantic-core' AND task_code=parent_code),
       2, FALSE,
       (SELECT status_id FROM statuses WHERE project_id='semantic-core' AND status_code='active')
FROM (VALUES
  ('1.1', 'پایگاه داده و طرحواره', '1'),
  ('1.2', 'اسکریپت‌ها', '1'),
  ('1.3', 'ادغام با AI', '1'),
  ('1.4', 'Git و مستندات', '1'),
  ('2.1', 'سلسله‌مراتب انواع', '2'),
  ('2.2', 'موجودیت‌ها', '2'),
  ('2.3', 'روابط', '2'),
  ('2.4', 'بافت‌ها', '2'),
  ('3.1', 'Claim', '3'),
  ('3.2', 'Evidence', '3'),
  ('3.3', 'نسخه‌بندی', '3'),
  ('3.4', 'حل تعارض', '3'),
  ('4.1', 'Episode', '4'),
  ('4.2', 'Hypothesis', '4'),
  ('4.3', 'Test', '4'),
  ('4.4', 'Decision', '4'),
  ('4.5', 'Verification', '4'),
  ('5.1', 'گزارش‌دهی', '5'),
  ('5.2', 'ادغام تجاری', '5')
) AS t(code, name, parent_code)
ON CONFLICT (project_id, task_code) DO NOTHING;
