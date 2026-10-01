-- ===================================================================
-- Project Monitor — Bootstrap (Schema + View + Seed)
-- Recreates the entire database from scratch
-- Usage: psql -U monitor_ai -d project_monitor -h localhost -f bootstrap.sql
-- ===================================================================

-- ─── TABLES ───
CREATE TABLE projects (
    project_id      TEXT PRIMARY KEY,
    display_name    TEXT NOT NULL,
    description     TEXT,
    repo_root       TEXT,
    repo_url        TEXT,
    config          JSONB NOT NULL DEFAULT '{}',
    enabled         BOOLEAN NOT NULL DEFAULT TRUE,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE statuses (
    status_id       BIGSERIAL PRIMARY KEY,
    project_id      TEXT NOT NULL REFERENCES projects(project_id) ON DELETE CASCADE,
    status_code     TEXT NOT NULL,
    label           TEXT NOT NULL,
    is_terminal     BOOLEAN DEFAULT FALSE,
    sort_order      INTEGER DEFAULT 0,
    UNIQUE (project_id, status_code)
);

CREATE TABLE scopes (
    scope_id        BIGSERIAL PRIMARY KEY,
    project_id      TEXT NOT NULL REFERENCES projects(project_id) ON DELETE CASCADE,
    scope_code      TEXT NOT NULL,
    variant         TEXT,
    config_context  TEXT,
    state           TEXT,
    condition_min   JSONB,
    condition_max   JSONB,
    description     TEXT,
    UNIQUE (project_id, scope_code)
);

CREATE TABLE sources (
    source_id       BIGSERIAL PRIMARY KEY,
    project_id      TEXT NOT NULL REFERENCES projects(project_id) ON DELETE CASCADE,
    source_type     TEXT NOT NULL,
    source_ref      TEXT,
    confidence      NUMERIC(3,2) CHECK (confidence BETWEEN 0 AND 1),
    notes           TEXT,
    UNIQUE (project_id, source_ref)
);

CREATE TABLE wbs_tasks (
    task_id         BIGSERIAL PRIMARY KEY,
    project_id      TEXT NOT NULL REFERENCES projects(project_id) ON DELETE CASCADE,
    task_code       TEXT NOT NULL,
    task_name       TEXT NOT NULL,
    parent_task_id  BIGINT REFERENCES wbs_tasks(task_id) ON DELETE CASCADE,
    level           INTEGER NOT NULL DEFAULT 0,
    is_atomic       BOOLEAN DEFAULT FALSE,
    estimated_min   INTEGER,
    actual_min      INTEGER,
    status_id       BIGINT REFERENCES statuses(status_id),
    verification_cmd TEXT,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE (project_id, task_code)
);

CREATE INDEX idx_wbs_parent ON wbs_tasks(parent_task_id);

CREATE TABLE atomic_propositions (
    prop_id         BIGSERIAL PRIMARY KEY,
    project_id      TEXT NOT NULL REFERENCES projects(project_id) ON DELETE CASCADE,
    prop_code       TEXT NOT NULL,
    proposition     TEXT NOT NULL,
    prop_type       TEXT NOT NULL,
    scope_id        BIGINT REFERENCES scopes(scope_id),
    source_id       BIGINT REFERENCES sources(source_id),
    status_id       BIGINT REFERENCES statuses(status_id),
    task_id         BIGINT REFERENCES wbs_tasks(task_id),
    verification_cmd TEXT,
    tags            JSONB DEFAULT '[]',
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE (project_id, prop_code)
);

CREATE INDEX idx_prop_type ON atomic_propositions(project_id, prop_type);
CREATE INDEX idx_prop_status ON atomic_propositions(project_id, status_id);

CREATE TABLE change_log (
    change_id       BIGSERIAL PRIMARY KEY,
    project_id      TEXT NOT NULL REFERENCES projects(project_id) ON DELETE CASCADE,
    entity_type     TEXT NOT NULL,
    entity_id       BIGINT NOT NULL,
    field_changed   TEXT NOT NULL,
    old_value       TEXT,
    new_value       TEXT,
    changed_by      TEXT DEFAULT 'AI_AGENT',
    changed_at      TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- ─── VIEW ───
CREATE VIEW ai_roadmap AS
SELECT p.project_id, p.display_name, ap.prop_code, ap.proposition, ap.prop_type, s.scope_code, st.status_code, wt.task_code, wt.task_name, wt.verification_cmd, wt.is_atomic
FROM projects p
JOIN atomic_propositions ap ON ap.project_id = p.project_id
LEFT JOIN scopes s ON ap.scope_id = s.scope_id
LEFT JOIN statuses st ON ap.status_id = st.status_id
LEFT JOIN wbs_tasks wt ON ap.task_id = wt.task_id
WHERE p.enabled = TRUE AND st.status_code IN ('active', 'draft');

-- ─── SEED ───
INSERT INTO projects (project_id, display_name, description, repo_url) VALUES ('semantic-core', 'هسته معنایی برق خودرو', 'پایگاه دانش معنایی برای تشخیص برق و الکترونیک خودرو', 'https://github.com/mahdiniazi/semantic-core');

INSERT INTO statuses (project_id, status_code, label, is_terminal) VALUES ('semantic-core', 'draft', 'پیش‌نویس', FALSE), ('semantic-core', 'active', 'فعال', FALSE), ('semantic-core', 'verified', 'تأییدشده', TRUE), ('semantic-core', 'deprecated', 'منسوخ', TRUE);

INSERT INTO scopes (project_id, scope_code, description) VALUES ('semantic-core', 'SCOPE-GENERAL', 'دامنه عمومی همه پروژه'), ('semantic-core', 'SCOPE-DOMAIN', 'لایه مدل دامنه'), ('semantic-core', 'SCOPE-A-CRANKING', 'Variant A در حالت استارت');

INSERT INTO sources (project_id, source_type, source_ref, confidence) VALUES ('semantic-core', 'constitution', 'PRINCIPLE-01', 1.00), ('semantic-core', 'constitution', 'PRINCIPLE-02', 1.00), ('semantic-core', 'constitution', 'PRINCIPLE-03', 1.00), ('semantic-core', 'constitution', 'PRINCIPLE-04', 1.00), ('semantic-core', 'constitution', 'PRINCIPLE-05', 1.00);

INSERT INTO atomic_propositions (project_id, prop_code, proposition, prop_type, scope_id, source_id, status_id) VALUES ('semantic-core', 'P-001', 'هر نوع انتزاعی نباید به‌عنوان نوع نمونه به کار رود.', 'rule', 1, 1, 2);
INSERT INTO atomic_propositions (project_id, prop_code, proposition, prop_type, scope_id, source_id, status_id) VALUES ('semantic-core', 'P-002', 'دامنه اعتبار هر قاعده باید صریح ثبت شود.', 'rule', 1, 1, 2);
INSERT INTO atomic_propositions (project_id, prop_code, proposition, prop_type, scope_id, source_id, status_id) VALUES ('semantic-core', 'P-003', 'واقعیت مشاهده‌شده باید از انتظار جدا بماند.', 'rule', 1, 2, 2);
INSERT INTO atomic_propositions (project_id, prop_code, proposition, prop_type, scope_id, source_id, status_id) VALUES ('semantic-core', 'P-004', 'موجودیت می‌تواند در بافت‌های مختلف نقش‌های متفاوتی داشته باشد.', 'rule', 2, 3, 2);
INSERT INTO atomic_propositions (project_id, prop_code, proposition, prop_type, scope_id, source_id, status_id) VALUES ('semantic-core', 'P-005', 'قابلیت از همکاری چند موجودیت پدید می‌آید.', 'rule', 2, 3, 2);
INSERT INTO atomic_propositions (project_id, prop_code, proposition, prop_type, scope_id, source_id, status_id) VALUES ('semantic-core', 'P-006', 'وضعیت گسسته باید از شرط پیوسته جدا باشد.', 'rule', 2, 4, 2);
INSERT INTO atomic_propositions (project_id, prop_code, proposition, prop_type, scope_id, source_id, status_id) VALUES ('semantic-core', 'P-007', 'هیچ نسخه‌ای از دانش حذف نمی‌شود.', 'rule', 1, 1, 2);
INSERT INTO atomic_propositions (project_id, prop_code, proposition, prop_type, scope_id, source_id, status_id) VALUES ('semantic-core', 'P-008', 'نمی‌دانیم یک حالت معتبر است.', 'rule', 1, 2, 2);
INSERT INTO atomic_propositions (project_id, prop_code, proposition, prop_type, scope_id, source_id, status_id) VALUES ('semantic-core', 'P-009', 'هر تصمیم مهم باید قابل بازسازی باشد.', 'rule', 1, 5, 2);
INSERT INTO atomic_propositions (project_id, prop_code, proposition, prop_type, scope_id, source_id, status_id) VALUES ('semantic-core', 'P-010', 'هوش مصنوعی دستیار است، نه صاحب اختیار حقیقت.', 'rule', 1, 5, 2);
