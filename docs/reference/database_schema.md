# مرجع طرحواره دیتابیس کارخانه

## جدول projects

فهرست همه محصولات.

ستون‌ها:
- project_id (TEXT, PK) — شناسه یکتا مثل semantic-core
- display_name (TEXT) — نام نمایشی
- description (TEXT) — توضیح
- repo_root (TEXT) — مسیر محلی
- repo_url (TEXT) — آدرس Git
- config (JSONB) — تنظیمات اختصاصی
- enabled (BOOLEAN) — فعال
- created_at، updated_at

## جدول atomic_propositions

گزاره‌های اتمی هر محصول.

ستون‌ها:
- prop_id (BIGSERIAL, PK)
- project_id (TEXT, FK)
- prop_code (TEXT) — مثل C-001، D-045
- proposition (TEXT) — متن گزاره
- prop_type (TEXT) — rule/fact/task/requirement/forbidden
- scope_id (FK)
- source_id (FK)
- status_id (FK)
- task_id (FK)
- verification_cmd (TEXT)
- tags (JSONB)
- created_at، updated_at

Unique: (project_id, prop_code)

## جدول wbs_tasks

ساختار شکست کار.

ستون‌ها:
- task_id (BIGSERIAL, PK)
- project_id (TEXT, FK)
- task_code (TEXT) — مثل 1.1.1
- task_name (TEXT)
- parent_task_id (FK self)
- level (INTEGER) — 1، 2، یا 3
- is_atomic (BOOLEAN)
- estimated_min، actual_min
- status_id (FK)
- verification_cmd (TEXT)
- created_at

Unique: (project_id, task_code)

## جدول sources

منابع گزاره‌ها.

- source_id (BIGSERIAL, PK)
- project_id (TEXT, FK)
- source_type (TEXT) — constitution، domain_model، ...
- source_ref (TEXT) — PRINCIPLE-01، SEC-3-ENTITY
- confidence (NUMERIC)
- notes (TEXT)

Unique: (project_id, source_ref)

## جدول scopes

دامنه اعتبار.

- scope_id (BIGSERIAL, PK)
- project_id (TEXT, FK)
- scope_code (TEXT) — SCOPE-GENERAL، SCOPE-DIAGNOSTIC
- variant، config_context، state
- condition_min، condition_max (JSONB)
- description (TEXT)

Unique: (project_id, scope_code)

## جدول statuses

وضعیت‌ها.

- status_id (BIGSERIAL, PK)
- project_id (TEXT, FK)
- status_code (TEXT) — draft، active، verified، deprecated
- label (TEXT)
- is_terminal (BOOLEAN)
- sort_order (INTEGER)

Unique: (project_id, status_code)

## جدول proposition_task_link

اتصال چند-به-چند بین گزاره‌ها و وظایف.

- link_id (BIGSERIAL, PK)
- project_id (TEXT, FK)
- prop_id (FK)
- task_id (FK)
- link_type (TEXT) — supports، requires، verifies

Unique: (prop_id, task_id, link_type)

## جدول change_log

تاریخچه تغییرات.

- change_id (BIGSERIAL, PK)
- project_id (TEXT, FK)
- entity_type (TEXT)
- entity_id (BIGINT)
- field_changed (TEXT)
- old_value، new_value
- changed_by (TEXT)
- changed_at

## Viewها

### ai_roadmap

گزاره‌های فعال و draft با فیلدهای کلیدی.

### v_ai_roadmap_full

گزاره‌ها + وظایف مرتبط + دستور تأیید.

### v_ai_dashboard

شمارش به تفکیک نوع و وضعیت.

## کوئری‌های پرکاربرد

### تعداد گزاره‌های فعال یک پروژه:
SELECT COUNT(*) FROM atomic_propositions ap
JOIN statuses st ON ap.status_id = st.status_id
WHERE ap.project_id='semantic-core' AND st.status_code='active';

### وظایف اتمی آماده:
SELECT task_code, task_name, verification_cmd
FROM wbs_tasks wt
JOIN statuses st ON wt.status_id = st.status_id
WHERE wt.project_id='semantic-core'
  AND wt.is_atomic = TRUE
  AND st.status_code = 'draft';

### یک گزاره با منبع و دامنه:
SELECT ap.prop_code, ap.proposition,
       s.source_ref, sc.scope_code, st.status_code
FROM atomic_propositions ap
LEFT JOIN sources s ON ap.source_id = s.source_id
LEFT JOIN scopes sc ON ap.scope_id = sc.scope_id
LEFT JOIN statuses st ON ap.status_id = st.status_id
WHERE ap.project_id='semantic-core' AND ap.prop_code='C-033';
