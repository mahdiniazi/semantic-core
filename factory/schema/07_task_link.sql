CREATE TABLE IF NOT EXISTS proposition_task_link (
    link_id         BIGSERIAL PRIMARY KEY,
    project_id      TEXT NOT NULL REFERENCES projects(project_id) ON DELETE CASCADE,
    prop_id         BIGINT NOT NULL REFERENCES atomic_propositions(prop_id) ON DELETE CASCADE,
    task_id         BIGINT NOT NULL REFERENCES wbs_tasks(task_id) ON DELETE CASCADE,
    link_type       TEXT NOT NULL DEFAULT 'supports',
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE (prop_id, task_id, link_type)
);

CREATE INDEX IF NOT EXISTS idx_link_prop ON proposition_task_link(prop_id);
CREATE INDEX IF NOT EXISTS idx_link_task ON proposition_task_link(task_id);
