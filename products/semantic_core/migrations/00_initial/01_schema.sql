-- =====================================================================
-- PART 1 — SCHEMA
-- =====================================================================
PRAGMA foreign_keys = OFF;

-- ============ LAYER M — META ============

CREATE TABLE e01_506_01_tb(
    need_uid TEXT PRIMARY KEY, need_label TEXT NOT NULL,
    need_kind TEXT NOT NULL CHECK(need_kind IN ('user','system','domain','quality','performance')),
    need_statement TEXT, priority INTEGER NOT NULL DEFAULT 2 CHECK(priority IN (1,2,3)),
    status TEXT NOT NULL DEFAULT 'active' CHECK(status IN ('active','deferred','dropped')),
    created_at TEXT NOT NULL DEFAULT (datetime('now')));

CREATE TABLE e01_506_09_tb(verb_code TEXT PRIMARY KEY CHECK(verb_code GLOB '[0-9]'), label TEXT NOT NULL, description TEXT, sort_order INTEGER NOT NULL DEFAULT 0);
CREATE TABLE e01_506_10_tb(entity_code TEXT PRIMARY KEY, label TEXT NOT NULL, description TEXT, sort_order INTEGER NOT NULL DEFAULT 0);
CREATE TABLE e01_506_11_tb(constraint_code TEXT PRIMARY KEY, label TEXT NOT NULL, description TEXT, sort_order INTEGER NOT NULL DEFAULT 0);

CREATE TABLE e01_506_02_tb(
    atom_uid TEXT PRIMARY KEY, category TEXT NOT NULL CHECK(category IN ('A','B','C','D','E','F','G','H','R')),
    origin TEXT NOT NULL DEFAULT 'design' CHECK(origin IN ('design','inferred','observed','derived')),
    statement TEXT NOT NULL, verb_code TEXT NOT NULL, entity_code TEXT NOT NULL,
    constraint_code TEXT, acceptance TEXT, verification TEXT,
    priority INTEGER NOT NULL DEFAULT 2 CHECK(priority IN (1,2,3)),
    status TEXT NOT NULL DEFAULT 'active' CHECK(status IN ('active','deferred','dropped')),
    created_at TEXT NOT NULL DEFAULT (datetime('now')),
    CONSTRAINT fk_atom_verb FOREIGN KEY (verb_code) REFERENCES e01_506_09_tb(verb_code) ON DELETE RESTRICT,
    CONSTRAINT fk_atom_entity FOREIGN KEY (entity_code) REFERENCES e01_506_10_tb(entity_code) ON DELETE RESTRICT,
    CONSTRAINT fk_atom_constraint FOREIGN KEY (constraint_code) REFERENCES e01_506_11_tb(constraint_code) ON DELETE RESTRICT);
CREATE INDEX e02_506_10_ix ON e01_506_02_tb(category);
CREATE INDEX e02_506_11_ix ON e01_506_02_tb(origin);
CREATE INDEX e02_506_12_ix ON e01_506_02_tb(verb_code);
CREATE INDEX e02_506_13_ix ON e01_506_02_tb(entity_code);
CREATE INDEX e02_506_14_ix ON e01_506_02_tb(constraint_code) WHERE constraint_code IS NOT NULL;

CREATE TABLE e01_516_01_tb(
    need_uid TEXT NOT NULL, atom_uid TEXT NOT NULL,
    kind TEXT NOT NULL DEFAULT 'derived' CHECK(kind IN ('derived','refined','satisfies')),
    origin TEXT NOT NULL DEFAULT 'design' CHECK(origin IN ('design','inferred','observed','derived')),
    PRIMARY KEY (need_uid, atom_uid, kind),
    CONSTRAINT fk_nea_need FOREIGN KEY (need_uid) REFERENCES e01_506_01_tb(need_uid) ON DELETE RESTRICT,
    CONSTRAINT fk_nea_atom FOREIGN KEY (atom_uid) REFERENCES e01_506_02_tb(atom_uid) ON DELETE RESTRICT);
CREATE INDEX e02_516_10_ix ON e01_516_01_tb(atom_uid);
CREATE INDEX e02_516_11_ix ON e01_516_01_tb(origin);

CREATE TABLE e01_506_03_tb(
    element_name TEXT PRIMARY KEY, element_code TEXT UNIQUE,
    element_level INTEGER CHECK(element_level IN (1,2,3,4)),
    element_layer TEXT NOT NULL CHECK(element_layer IN ('M','T','C','X','I','V','A')),
    element_kind TEXT NOT NULL CHECK(element_kind IN ('tb','tr','vw','ix','ft')),
    need_uid TEXT, purpose TEXT, notes TEXT, created_at TEXT NOT NULL DEFAULT (datetime('now')),
    CHECK (element_code IS NULL OR element_code GLOB 'e[0-9][0-9]_[0-9][0-9][0-9]_[0-9][0-9]_[a-z][a-z]'),
    CONSTRAINT fk_ele_need FOREIGN KEY (need_uid) REFERENCES e01_506_01_tb(need_uid) ON DELETE RESTRICT);
CREATE INDEX e02_506_15_ix ON e01_506_03_tb(element_layer);
CREATE INDEX e02_506_16_ix ON e01_506_03_tb(element_kind);
CREATE INDEX e02_506_17_ix ON e01_506_03_tb(need_uid) WHERE need_uid IS NOT NULL;

CREATE TABLE e01_506_04_tb(
    trace_id INTEGER PRIMARY KEY AUTOINCREMENT, atom_uid TEXT NOT NULL, element_name TEXT NOT NULL,
    trace_type TEXT NOT NULL CHECK(trace_type IN ('implements','verifies','constrains','documents','db_decl','db_guard','db_sync','db_audit','app_layer')),
    UNIQUE(atom_uid, element_name, trace_type),
    CONSTRAINT fk_tra_atom FOREIGN KEY (atom_uid) REFERENCES e01_506_02_tb(atom_uid) ON DELETE RESTRICT,
    CONSTRAINT fk_tra_elem FOREIGN KEY (element_name) REFERENCES e01_506_03_tb(element_name) ON DELETE RESTRICT);
CREATE INDEX e02_506_18_ix ON e01_506_04_tb(atom_uid);
CREATE INDEX e02_506_19_ix ON e01_506_04_tb(element_name);

CREATE TABLE e01_506_05_tb(
    question_uid TEXT PRIMARY KEY, parent_uid TEXT, label TEXT NOT NULL, purpose TEXT NOT NULL,
    answer_kind TEXT NOT NULL CHECK(answer_kind IN ('text','entity_ref','value','boolean','criterion','free')),
    required_rule TEXT NOT NULL CHECK(required_rule IN ('always','by_need_kind','conditional','optional')),
    seq INTEGER NOT NULL CHECK(seq >= 0),
    CONSTRAINT fk_que_parent FOREIGN KEY (parent_uid) REFERENCES e01_506_05_tb(question_uid) ON DELETE RESTRICT);
CREATE INDEX e02_506_20_ix ON e01_506_05_tb(parent_uid);

CREATE TABLE e01_506_06_tb(
    node_id INTEGER PRIMARY KEY AUTOINCREMENT, need_uid TEXT NOT NULL, parent_id INTEGER,
    question_uid TEXT NOT NULL, slot TEXT, answer_text TEXT,
    answer_source TEXT NOT NULL DEFAULT 'not_recorded' CHECK(answer_source IN ('source','derived','not_recorded','not_applicable')),
    status TEXT NOT NULL DEFAULT 'open' CHECK(status IN ('open','answered','not_applicable','blocked')),
    ordinal INTEGER NOT NULL DEFAULT 1 CHECK(ordinal >= 1),
    UNIQUE(need_uid, parent_id, question_uid, ordinal),
    CONSTRAINT fk_nod_need FOREIGN KEY (need_uid) REFERENCES e01_506_01_tb(need_uid) ON DELETE RESTRICT,
    CONSTRAINT fk_nod_parent FOREIGN KEY (parent_id) REFERENCES e01_506_06_tb(node_id) ON DELETE RESTRICT,
    CONSTRAINT fk_nod_que FOREIGN KEY (question_uid) REFERENCES e01_506_05_tb(question_uid) ON DELETE RESTRICT);
CREATE INDEX e02_506_21_ix ON e01_506_06_tb(need_uid);
CREATE INDEX e02_506_22_ix ON e01_506_06_tb(parent_id);
CREATE INDEX e02_506_23_ix ON e01_506_06_tb(question_uid);
CREATE UNIQUE INDEX e02_506_24_ix ON e01_506_06_tb(need_uid, question_uid, ordinal) WHERE parent_id IS NULL;

CREATE TABLE e01_676_01_tb(migration_uid TEXT PRIMARY KEY, applied_at TEXT NOT NULL DEFAULT (datetime('now')), notes TEXT);
CREATE TABLE e01_676_02_tb(id INTEGER PRIMARY KEY CHECK(id = 1), schema_ver INTEGER NOT NULL, last_scan_at TEXT NOT NULL DEFAULT (datetime('now')));
CREATE TABLE e01_676_03_tb(param_uid TEXT PRIMARY KEY, int_value INTEGER, text_value TEXT, description TEXT);

CREATE TABLE e01_378_01_tb(
    ref_id INTEGER PRIMARY KEY AUTOINCREMENT, child_table TEXT NOT NULL, child_col TEXT NOT NULL,
    parent_table TEXT NOT NULL, parent_col TEXT NOT NULL,
    action_on_del TEXT NOT NULL DEFAULT 'restrict' CHECK(action_on_del IN ('restrict','cascade','set_null')),
    layer_from TEXT CHECK(layer_from IN ('M','T','C','X','I','V','A')),
    layer_to TEXT CHECK(layer_to IN ('M','T','C','X','I','V','A')),
    note TEXT, UNIQUE(child_table, child_col));
CREATE INDEX e02_378_10_ix ON e01_378_01_tb(child_table);
CREATE INDEX e02_378_11_ix ON e01_378_01_tb(parent_table);

CREATE TABLE e01_506_07_tb(dim_uid TEXT PRIMARY KEY, label TEXT NOT NULL, description TEXT, seq INTEGER NOT NULL);
CREATE TABLE e01_506_08_tb(value_id INTEGER PRIMARY KEY AUTOINCREMENT, dim_uid TEXT NOT NULL, value_uid TEXT NOT NULL, label TEXT NOT NULL, sort_order INTEGER, UNIQUE(dim_uid, value_uid), CONSTRAINT fk_dim_val_dim FOREIGN KEY (dim_uid) REFERENCES e01_506_07_tb(dim_uid) ON DELETE RESTRICT);
CREATE INDEX e02_506_25_ix ON e01_506_08_tb(dim_uid);

CREATE TABLE e01_778_01_tb(
    code_id INTEGER PRIMARY KEY AUTOINCREMENT, need_uid TEXT NOT NULL, code TEXT NOT NULL UNIQUE,
    code_kind TEXT NOT NULL CHECK(code_kind IN ('need','atom','element','chain','invariant')),
    parent_code TEXT, label TEXT NOT NULL, description TEXT, seq INTEGER NOT NULL DEFAULT 0,
    created_at TEXT NOT NULL DEFAULT (datetime('now')),
    CONSTRAINT fk_rc_need FOREIGN KEY (need_uid) REFERENCES e01_506_01_tb(need_uid) ON DELETE RESTRICT,
    CONSTRAINT fk_rc_parent FOREIGN KEY (parent_code) REFERENCES e01_778_01_tb(code) ON DELETE RESTRICT);
CREATE INDEX e02_778_10_ix ON e01_778_01_tb(parent_code);
CREATE INDEX e02_778_11_ix ON e01_778_01_tb(need_uid);
CREATE INDEX e02_778_12_ix ON e01_778_01_tb(code_kind);

CREATE TABLE e01_778_02_tb(
    element_name TEXT NOT NULL, need_uid TEXT NOT NULL, code TEXT,
    is_primary INTEGER NOT NULL DEFAULT 0 CHECK(is_primary IN (0,1)),
    is_driving INTEGER NOT NULL DEFAULT 0 CHECK(is_driving IN (0,1)),
    role TEXT NOT NULL DEFAULT 'serves' CHECK(role IN ('defines','serves','verifies','constrains','observes','maintains')),
    note TEXT, PRIMARY KEY (element_name, need_uid, role),
    CONSTRAINT fk_er_elem FOREIGN KEY (element_name) REFERENCES e01_506_03_tb(element_name) ON DELETE RESTRICT,
    CONSTRAINT fk_er_need FOREIGN KEY (need_uid) REFERENCES e01_506_01_tb(need_uid) ON DELETE RESTRICT,
    CONSTRAINT fk_er_code FOREIGN KEY (code) REFERENCES e01_778_01_tb(code) ON DELETE RESTRICT);
CREATE INDEX e02_778_20_ix ON e01_778_02_tb(need_uid);
CREATE INDEX e02_778_21_ix ON e01_778_02_tb(code) WHERE code IS NOT NULL;
CREATE INDEX e02_778_22_ix ON e01_778_02_tb(is_primary) WHERE is_primary = 1;
CREATE INDEX e02_778_23_ix ON e01_778_02_tb(is_driving) WHERE is_driving = 1;

CREATE TABLE e01_778_03_tb(
    chain_uid TEXT PRIMARY KEY, code TEXT NOT NULL UNIQUE, root_need_uid TEXT NOT NULL, label TEXT NOT NULL, purpose TEXT,
    chain_kind TEXT NOT NULL CHECK(chain_kind IN ('integrity','workflow','diagnostic','provenance','enforcement','validation')),
    created_at TEXT NOT NULL DEFAULT (datetime('now')),
    CONSTRAINT fk_chain_need FOREIGN KEY (root_need_uid) REFERENCES e01_506_01_tb(need_uid) ON DELETE RESTRICT);
CREATE INDEX e02_778_30_ix ON e01_778_03_tb(root_need_uid);
CREATE INDEX e02_778_31_ix ON e01_778_03_tb(chain_kind);

CREATE TABLE e01_778_04_tb(
    chain_uid TEXT NOT NULL, ordinal INTEGER NOT NULL CHECK(ordinal >= 1),
    step_kind TEXT NOT NULL CHECK(step_kind IN ('source','transform','enforce','verify','sink','branch')),
    element_name TEXT, need_uid TEXT, code TEXT, description TEXT NOT NULL,
    PRIMARY KEY (chain_uid, ordinal),
    CONSTRAINT fk_step_chain FOREIGN KEY (chain_uid) REFERENCES e01_778_03_tb(chain_uid) ON DELETE RESTRICT,
    CONSTRAINT fk_step_elem FOREIGN KEY (element_name) REFERENCES e01_506_03_tb(element_name) ON DELETE SET NULL,
    CONSTRAINT fk_step_need FOREIGN KEY (need_uid) REFERENCES e01_506_01_tb(need_uid) ON DELETE SET NULL);
CREATE INDEX e02_778_40_ix ON e01_778_04_tb(step_kind);
CREATE INDEX e02_778_41_ix ON e01_778_04_tb(element_name) WHERE element_name IS NOT NULL;
CREATE INDEX e02_778_42_ix ON e01_778_04_tb(need_uid) WHERE need_uid IS NOT NULL;

-- ============ LAYER T — TYPE ============

CREATE TABLE e01_200_01_tb(
    type_id INTEGER PRIMARY KEY AUTOINCREMENT, type_uid TEXT NOT NULL UNIQUE, label TEXT NOT NULL, description TEXT,
    parent_id INTEGER, is_abstract INTEGER NOT NULL DEFAULT 0 CHECK(is_abstract IN (0,1)),
    CHECK (parent_id IS NULL OR parent_id <> type_id),
    CONSTRAINT fk_ety_parent FOREIGN KEY (parent_id) REFERENCES e01_200_01_tb(type_id) ON DELETE RESTRICT);
CREATE INDEX e02_200_10_ix ON e01_200_01_tb(parent_id);

CREATE TABLE e01_120_01_tb(
    desc_id INTEGER NOT NULL, anc_id INTEGER NOT NULL, depth INTEGER NOT NULL CHECK(depth >= 0),
    PRIMARY KEY (desc_id, anc_id),
    CONSTRAINT fk_clos_desc FOREIGN KEY (desc_id) REFERENCES e01_200_01_tb(type_id) ON DELETE RESTRICT,
    CONSTRAINT fk_clos_anc FOREIGN KEY (anc_id) REFERENCES e01_200_01_tb(type_id) ON DELETE RESTRICT) WITHOUT ROWID;
CREATE INDEX e02_120_10_ix ON e01_120_01_tb(anc_id);

CREATE TABLE e01_202_01_tb(
    reltype_id INTEGER PRIMARY KEY AUTOINCREMENT, type_uid TEXT NOT NULL UNIQUE, label TEXT NOT NULL, description TEXT,
    object_kind TEXT NOT NULL DEFAULT 'entity' CHECK(object_kind IN ('entity','value','entity_or_value')),
    is_symmetric INTEGER NOT NULL DEFAULT 0 CHECK(is_symmetric IN (0,1)),
    is_transitive INTEGER NOT NULL DEFAULT 0 CHECK(is_transitive IN (0,1)),
    is_functional INTEGER NOT NULL DEFAULT 0 CHECK(is_functional IN (0,1)),
    inverse_uid TEXT,
    CONSTRAINT fk_rty_inv FOREIGN KEY (inverse_uid) REFERENCES e01_202_01_tb(type_uid) ON DELETE SET NULL);
CREATE INDEX e02_202_10_ix ON e01_202_01_tb(object_kind);
CREATE INDEX e02_202_11_ix ON e01_202_01_tb(is_functional) WHERE is_functional = 1;

CREATE TABLE e01_112_01_tb(
    cons_id INTEGER PRIMARY KEY AUTOINCREMENT, reltype_id INTEGER NOT NULL,
    cons_kind TEXT NOT NULL CHECK(cons_kind IN ('allowed_subject_type','allowed_object_type','allowed_subject_nature','allowed_object_nature')),
    target_type_id INTEGER, target_nature TEXT CHECK(target_nature IS NULL OR target_nature IN ('instance','concept')),
    CHECK ((cons_kind IN ('allowed_subject_type','allowed_object_type') AND target_type_id IS NOT NULL AND target_nature IS NULL) OR (cons_kind IN ('allowed_subject_nature','allowed_object_nature') AND target_type_id IS NULL AND target_nature IS NOT NULL)),
    CONSTRAINT fk_cons_rel FOREIGN KEY (reltype_id) REFERENCES e01_202_01_tb(reltype_id) ON DELETE RESTRICT,
    CONSTRAINT fk_cons_type FOREIGN KEY (target_type_id) REFERENCES e01_200_01_tb(type_id) ON DELETE RESTRICT);
CREATE UNIQUE INDEX e02_112_10_ix ON e01_112_01_tb(reltype_id, cons_kind, target_type_id) WHERE target_type_id IS NOT NULL;
CREATE UNIQUE INDEX e02_112_11_ix ON e01_112_01_tb(reltype_id, cons_kind, target_nature) WHERE target_nature IS NOT NULL;
CREATE INDEX e02_112_12_ix ON e01_112_01_tb(reltype_id);
CREATE INDEX e02_112_13_ix ON e01_112_01_tb(cons_kind);

CREATE TABLE e01_200_02_tb(dom_id INTEGER PRIMARY KEY AUTOINCREMENT, dom_uid TEXT NOT NULL UNIQUE, label TEXT NOT NULL, description TEXT);
CREATE TABLE e01_201_01_tb(
    val_id INTEGER PRIMARY KEY AUTOINCREMENT, dom_id INTEGER NOT NULL, value_uid TEXT NOT NULL, label TEXT NOT NULL, sort_order INTEGER,
    UNIQUE(dom_id, value_uid),
    CONSTRAINT fk_enm_val_dom FOREIGN KEY (dom_id) REFERENCES e01_200_02_tb(dom_id) ON DELETE RESTRICT);
CREATE INDEX e02_201_10_ix ON e01_201_01_tb(dom_id);

-- ============ LAYER C — CORE ============

CREATE TABLE e01_303_01_tb(
    prv_id INTEGER PRIMARY KEY AUTOINCREMENT,
    source_type TEXT NOT NULL CHECK(source_type IN ('manual','sensor','document','inference','external_system','user','ai','import','unknown')),
    source_ref TEXT, method TEXT, confidence REAL CHECK(confidence IS NULL OR (confidence >= 0 AND confidence <= 1)),
    created_at TEXT NOT NULL DEFAULT (datetime('now')), notes TEXT);
CREATE INDEX e02_303_10_ix ON e01_303_01_tb(source_type);
CREATE INDEX e02_303_11_ix ON e01_303_01_tb(source_type, source_ref);
CREATE UNIQUE INDEX e02_303_12_ix ON e01_303_01_tb(source_type, source_ref) WHERE source_type='unknown' AND source_ref='system:unknown';

CREATE TABLE e01_200_03_tb(
    ent_id INTEGER PRIMARY KEY AUTOINCREMENT, ent_uid TEXT NOT NULL UNIQUE, type_id INTEGER NOT NULL,
    nature TEXT NOT NULL DEFAULT 'instance' CHECK(nature IN ('instance','concept')),
    label TEXT NOT NULL, description TEXT,
    label_norm TEXT CHECK(label_norm IS NULL OR length(label_norm) > 0),
    desc_norm TEXT NOT NULL DEFAULT '',
    status TEXT NOT NULL DEFAULT 'active' CHECK(status IN ('active','archived','deprecated','merged')),
    prv_id INTEGER, created_at TEXT NOT NULL DEFAULT (datetime('now')), updated_at TEXT NOT NULL DEFAULT (datetime('now')),
    CONSTRAINT fk_ent_type FOREIGN KEY (type_id) REFERENCES e01_200_01_tb(type_id) ON DELETE RESTRICT,
    CONSTRAINT fk_ent_prv FOREIGN KEY (prv_id) REFERENCES e01_303_01_tb(prv_id) ON DELETE SET NULL);
CREATE INDEX e02_200_20_ix ON e01_200_03_tb(type_id, nature);
CREATE INDEX e02_200_21_ix ON e01_200_03_tb(nature);
CREATE INDEX e02_200_22_ix ON e01_200_03_tb(status);
CREATE INDEX e02_200_23_ix ON e01_200_03_tb(label);
CREATE INDEX e02_200_24_ix ON e01_200_03_tb(prv_id) WHERE prv_id IS NOT NULL;

CREATE TABLE e01_201_02_tb(
    val_id INTEGER PRIMARY KEY AUTOINCREMENT,
    value_kind TEXT NOT NULL CHECK(value_kind IN ('number','text','boolean','datetime','date','duration','interval','enum','identifier','json','collection','range','unknown','not_observed','not_recorded','not_applicable')),
    num_val REAL, text_val TEXT, text_norm TEXT, bool_val INTEGER CHECK(bool_val IN (0,1) OR bool_val IS NULL),
    dt_start TEXT, dt_end TEXT, num_min REAL, num_max REAL, enum_id INTEGER, json_val TEXT,
    is_collection INTEGER NOT NULL DEFAULT 0 CHECK(is_collection IN (0,1)),
    unit TEXT, uncertainty REAL, raw_text TEXT, prv_id INTEGER,
    CHECK (is_collection = 0 OR value_kind = 'collection'),
    CHECK (value_kind IN ('unknown','not_observed','not_recorded','not_applicable') OR (value_kind = 'number' AND num_val IS NOT NULL) OR (value_kind = 'text' AND text_val IS NOT NULL) OR (value_kind = 'boolean' AND bool_val IS NOT NULL) OR (value_kind = 'datetime' AND dt_start IS NOT NULL) OR (value_kind = 'enum' AND enum_id IS NOT NULL) OR (value_kind = 'json' AND json_val IS NOT NULL) OR (value_kind = 'date' AND dt_start IS NOT NULL) OR (value_kind = 'duration' AND (num_val IS NOT NULL OR text_val IS NOT NULL)) OR (value_kind = 'interval' AND (dt_start IS NOT NULL OR num_val IS NOT NULL)) OR (value_kind = 'range' AND (num_min IS NOT NULL OR num_max IS NOT NULL)) OR (value_kind = 'identifier' AND (text_val IS NOT NULL OR num_val IS NOT NULL)) OR (value_kind = 'collection' AND is_collection = 1)),
    CHECK (value_kind NOT IN ('unknown','not_observed','not_recorded','not_applicable') OR (num_val IS NULL AND text_val IS NULL AND text_norm IS NULL AND bool_val IS NULL AND dt_start IS NULL AND dt_end IS NULL AND num_min IS NULL AND num_max IS NULL AND enum_id IS NULL AND json_val IS NULL AND is_collection = 0 AND unit IS NULL)),
    CHECK (num_min IS NULL OR num_max IS NULL OR num_min <= num_max),
    CHECK (dt_start IS NULL OR dt_end IS NULL OR dt_start <= dt_end),
    CONSTRAINT fk_val_enum FOREIGN KEY (enum_id) REFERENCES e01_201_01_tb(val_id) ON DELETE RESTRICT,
    CONSTRAINT fk_val_prv FOREIGN KEY (prv_id) REFERENCES e01_303_01_tb(prv_id) ON DELETE SET NULL);
CREATE INDEX e02_201_20_ix ON e01_201_02_tb(value_kind);
CREATE INDEX e02_201_21_ix ON e01_201_02_tb(num_val) WHERE num_val IS NOT NULL;
CREATE INDEX e02_201_22_ix ON e01_201_02_tb(text_val) WHERE text_val IS NOT NULL;
CREATE INDEX e02_201_23_ix ON e01_201_02_tb(text_norm) WHERE text_norm IS NOT NULL;
CREATE INDEX e02_201_24_ix ON e01_201_02_tb(enum_id) WHERE enum_id IS NOT NULL;
CREATE INDEX e02_201_25_ix ON e01_201_02_tb(prv_id) WHERE prv_id IS NOT NULL;

CREATE TABLE e01_201_03_tb(
    memb_id INTEGER PRIMARY KEY AUTOINCREMENT, parent_id INTEGER NOT NULL, member_val_id INTEGER, member_ent_id INTEGER, ordinal INTEGER NOT NULL DEFAULT 0 CHECK(ordinal >= 0),
    CHECK ((member_val_id IS NOT NULL AND member_ent_id IS NULL) OR (member_val_id IS NULL AND member_ent_id IS NOT NULL)),
    CHECK (parent_id <> member_val_id),
    CONSTRAINT fk_memb_parent FOREIGN KEY (parent_id) REFERENCES e01_201_02_tb(val_id) ON DELETE CASCADE,
    CONSTRAINT fk_memb_val FOREIGN KEY (member_val_id) REFERENCES e01_201_02_tb(val_id) ON DELETE RESTRICT,
    CONSTRAINT fk_memb_ent FOREIGN KEY (member_ent_id) REFERENCES e01_200_03_tb(ent_id) ON DELETE RESTRICT);
CREATE INDEX e02_201_30_ix ON e01_201_03_tb(parent_id);
CREATE INDEX e02_201_31_ix ON e01_201_03_tb(member_val_id);
CREATE INDEX e02_201_32_ix ON e01_201_03_tb(member_ent_id);

CREATE TABLE e01_302_01_tb(
    lin_id INTEGER PRIMARY KEY AUTOINCREMENT, lin_uid TEXT NOT NULL UNIQUE, subj_ent_id INTEGER NOT NULL, reltype_id INTEGER NOT NULL, description TEXT,
    created_at TEXT NOT NULL DEFAULT (datetime('now')),
    CONSTRAINT fk_lin_subj FOREIGN KEY (subj_ent_id) REFERENCES e01_200_03_tb(ent_id) ON DELETE RESTRICT,
    CONSTRAINT fk_lin_rty FOREIGN KEY (reltype_id) REFERENCES e01_202_01_tb(reltype_id) ON DELETE RESTRICT);
CREATE INDEX e02_302_10_ix ON e01_302_01_tb(subj_ent_id);
CREATE INDEX e02_302_11_ix ON e01_302_01_tb(reltype_id);

CREATE TABLE e01_222_01_tb(
    rel_id INTEGER PRIMARY KEY AUTOINCREMENT, rel_uid TEXT NOT NULL UNIQUE, lin_id INTEGER,
    ctx_key TEXT NOT NULL DEFAULT 'u:',
    reif_type TEXT NOT NULL DEFAULT 'none' CHECK(reif_type IN ('none','annotated')),
    reltype_id INTEGER NOT NULL, subj_ent_id INTEGER NOT NULL, obj_ent_id INTEGER, obj_val_id INTEGER, reif_ent_id INTEGER,
    status TEXT NOT NULL DEFAULT 'asserted' CHECK(status IN ('asserted','negated','hypothetical','retracted','unknown')),
    prv_id INTEGER, valid_from TEXT, valid_to TEXT, recorded_at TEXT NOT NULL DEFAULT (datetime('now')), superseded_at TEXT,
    ordinal INTEGER CHECK(ordinal IS NULL OR ordinal >= 0),
    CHECK (valid_from IS NULL OR valid_to IS NULL OR valid_from <= valid_to),
    CHECK (superseded_at IS NULL OR superseded_at >= recorded_at),
    CHECK ((obj_ent_id IS NOT NULL AND obj_val_id IS NULL) OR (obj_ent_id IS NULL AND obj_val_id IS NOT NULL)),
    CHECK (ctx_key = 'u:' OR ctx_key = '?:' OR ctx_key = 'n:' OR ctx_key LIKE 's:%'),
    CHECK ((reif_type = 'none' AND reif_ent_id IS NULL) OR (reif_type = 'annotated' AND reif_ent_id IS NOT NULL)),
    CONSTRAINT fk_rel_lin FOREIGN KEY (lin_id) REFERENCES e01_302_01_tb(lin_id) ON DELETE SET NULL,
    CONSTRAINT fk_rel_rty FOREIGN KEY (reltype_id) REFERENCES e01_202_01_tb(reltype_id) ON DELETE RESTRICT,
    CONSTRAINT fk_rel_subj FOREIGN KEY (subj_ent_id) REFERENCES e01_200_03_tb(ent_id) ON DELETE RESTRICT,
    CONSTRAINT fk_rel_obj_ent FOREIGN KEY (obj_ent_id) REFERENCES e01_200_03_tb(ent_id) ON DELETE RESTRICT,
    CONSTRAINT fk_rel_obj_val FOREIGN KEY (obj_val_id) REFERENCES e01_201_02_tb(val_id) ON DELETE RESTRICT,
    CONSTRAINT fk_rel_reif FOREIGN KEY (reif_ent_id) REFERENCES e01_200_03_tb(ent_id) ON DELETE RESTRICT,
    CONSTRAINT fk_rel_prv FOREIGN KEY (prv_id) REFERENCES e01_303_01_tb(prv_id) ON DELETE SET NULL);
CREATE INDEX e02_222_10_ix ON e01_222_01_tb(subj_ent_id);
CREATE INDEX e02_222_11_ix ON e01_222_01_tb(obj_ent_id) WHERE obj_ent_id IS NOT NULL;
CREATE INDEX e02_222_12_ix ON e01_222_01_tb(obj_val_id) WHERE obj_val_id IS NOT NULL;
CREATE INDEX e02_222_13_ix ON e01_222_01_tb(subj_ent_id, reltype_id, obj_ent_id) WHERE superseded_at IS NULL;
CREATE INDEX e02_222_14_ix ON e01_222_01_tb(reif_ent_id) WHERE reif_ent_id IS NOT NULL;
CREATE INDEX e02_222_15_ix ON e01_222_01_tb(subj_ent_id, reltype_id, ctx_key) WHERE superseded_at IS NULL AND status = 'asserted';
CREATE INDEX e02_222_16_ix ON e01_222_01_tb(status);
CREATE INDEX e02_222_17_ix ON e01_222_01_tb(lin_id) WHERE lin_id IS NOT NULL;
CREATE INDEX e02_222_18_ix ON e01_222_01_tb(prv_id) WHERE prv_id IS NOT NULL;
CREATE INDEX e02_222_19_ix ON e01_222_01_tb(subj_ent_id, reltype_id, ordinal) WHERE ordinal IS NOT NULL;
CREATE INDEX e02_222_20_ix ON e01_222_01_tb(subj_ent_id, reltype_id, obj_ent_id) WHERE status = 'asserted' AND superseded_at IS NULL;

-- ============ LAYER X — CONTEXT ============

CREATE TABLE e01_305_01_tb(
    ctx_id INTEGER PRIMARY KEY AUTOINCREMENT, ent_id INTEGER NOT NULL, ctx_ent_id INTEGER, ctx_val_id INTEGER,
    role TEXT NOT NULL DEFAULT 'condition' CHECK(role IN ('condition','scope','applicability','variant','environment','mode')),
    valid_from TEXT, valid_to TEXT, prv_id INTEGER,
    CHECK ((ctx_ent_id IS NOT NULL AND ctx_val_id IS NULL) OR (ctx_ent_id IS NULL AND ctx_val_id IS NOT NULL)),
    CHECK (ctx_ent_id IS NULL OR ent_id <> ctx_ent_id),
    CHECK (valid_from IS NULL OR valid_to IS NULL OR valid_from <= valid_to),
    CONSTRAINT fk_ectx_ent FOREIGN KEY (ent_id) REFERENCES e01_200_03_tb(ent_id) ON DELETE RESTRICT,
    CONSTRAINT fk_ectx_cen FOREIGN KEY (ctx_ent_id) REFERENCES e01_200_03_tb(ent_id) ON DELETE RESTRICT,
    CONSTRAINT fk_ectx_cvl FOREIGN KEY (ctx_val_id) REFERENCES e01_201_02_tb(val_id) ON DELETE RESTRICT,
    CONSTRAINT fk_ectx_prv FOREIGN KEY (prv_id) REFERENCES e01_303_01_tb(prv_id) ON DELETE SET NULL);
CREATE UNIQUE INDEX e02_305_10_ix ON e01_305_01_tb(ent_id, COALESCE(ctx_ent_id, -1), COALESCE(ctx_val_id, -1), role, COALESCE(valid_from, ''), COALESCE(valid_to, ''));
CREATE INDEX e02_305_11_ix ON e01_305_01_tb(ctx_ent_id) WHERE ctx_ent_id IS NOT NULL;
CREATE INDEX e02_305_12_ix ON e01_305_01_tb(prv_id) WHERE prv_id IS NOT NULL;

CREATE TABLE e01_305_02_tb(
    ctx_id INTEGER PRIMARY KEY AUTOINCREMENT, val_id INTEGER NOT NULL, ctx_ent_id INTEGER, ctx_val_id INTEGER,
    role TEXT NOT NULL DEFAULT 'condition' CHECK(role IN ('condition','scope','applicability','variant','environment','mode')),
    valid_from TEXT, valid_to TEXT, prv_id INTEGER,
    CHECK ((ctx_ent_id IS NOT NULL AND ctx_val_id IS NULL) OR (ctx_ent_id IS NULL AND ctx_val_id IS NOT NULL)),
    CHECK (valid_from IS NULL OR valid_to IS NULL OR valid_from <= valid_to),
    CHECK (ctx_val_id IS NULL OR val_id <> ctx_val_id),
    CONSTRAINT fk_vctx_val FOREIGN KEY (val_id) REFERENCES e01_201_02_tb(val_id) ON DELETE CASCADE,
    CONSTRAINT fk_vctx_cen FOREIGN KEY (ctx_ent_id) REFERENCES e01_200_03_tb(ent_id) ON DELETE RESTRICT,
    CONSTRAINT fk_vctx_cvl FOREIGN KEY (ctx_val_id) REFERENCES e01_201_02_tb(val_id) ON DELETE RESTRICT,
    CONSTRAINT fk_vctx_prv FOREIGN KEY (prv_id) REFERENCES e01_303_01_tb(prv_id) ON DELETE SET NULL);
CREATE UNIQUE INDEX e02_305_20_ix ON e01_305_02_tb(val_id, COALESCE(ctx_ent_id, -1), COALESCE(ctx_val_id, -1), role, COALESCE(valid_from, ''), COALESCE(valid_to, ''));
CREATE INDEX e02_305_21_ix ON e01_305_02_tb(ctx_ent_id) WHERE ctx_ent_id IS NOT NULL;
CREATE INDEX e02_305_22_ix ON e01_305_02_tb(prv_id) WHERE prv_id IS NOT NULL;

CREATE TABLE e01_305_03_tb(
    ctx_id INTEGER PRIMARY KEY AUTOINCREMENT, rel_id INTEGER NOT NULL, ctx_ent_id INTEGER, ctx_val_id INTEGER,
    role TEXT NOT NULL DEFAULT 'condition' CHECK(role IN ('condition','scope','applicability','variant','environment','mode')),
    valid_from TEXT, valid_to TEXT, prv_id INTEGER,
    CHECK ((ctx_ent_id IS NOT NULL AND ctx_val_id IS NULL) OR (ctx_ent_id IS NULL AND ctx_val_id IS NOT NULL)),
    CHECK (valid_from IS NULL OR valid_to IS NULL OR valid_from <= valid_to),
    CONSTRAINT fk_rctx_rel FOREIGN KEY (rel_id) REFERENCES e01_222_01_tb(rel_id) ON DELETE RESTRICT,
    CONSTRAINT fk_rctx_cen FOREIGN KEY (ctx_ent_id) REFERENCES e01_200_03_tb(ent_id) ON DELETE RESTRICT,
    CONSTRAINT fk_rctx_cvl FOREIGN KEY (ctx_val_id) REFERENCES e01_201_02_tb(val_id) ON DELETE RESTRICT,
    CONSTRAINT fk_rctx_prv FOREIGN KEY (prv_id) REFERENCES e01_303_01_tb(prv_id) ON DELETE SET NULL);
CREATE UNIQUE INDEX e02_305_30_ix ON e01_305_03_tb(rel_id, COALESCE(ctx_ent_id, -1), COALESCE(ctx_val_id, -1), role, COALESCE(valid_from, ''), COALESCE(valid_to, ''));
CREATE INDEX e02_305_31_ix ON e01_305_03_tb(ctx_ent_id) WHERE ctx_ent_id IS NOT NULL;
CREATE INDEX e02_305_32_ix ON e01_305_03_tb(prv_id) WHERE prv_id IS NOT NULL;

-- ============ LAYER I — IDENTITY ============

CREATE TABLE e01_300_01_tb(
    clm_id INTEGER PRIMARY KEY AUTOINCREMENT, ent_a_id INTEGER NOT NULL, ent_b_id INTEGER NOT NULL,
    clm_type TEXT NOT NULL CHECK(clm_type IN ('same_as','distinct_from','merged_into','split_from')),
    purpose TEXT, valid_from TEXT, valid_to TEXT, prv_id INTEGER,
    status TEXT NOT NULL DEFAULT 'asserted' CHECK(status IN ('asserted','disputed','retracted')),
    recorded_at TEXT NOT NULL DEFAULT (datetime('now')),
    CHECK (valid_from IS NULL OR valid_to IS NULL OR valid_from <= valid_to),
    CHECK (ent_a_id <> ent_b_id),
    CHECK ((clm_type IN ('same_as','distinct_from') AND ent_a_id < ent_b_id) OR (clm_type IN ('merged_into','split_from'))),
    CONSTRAINT fk_idn_a FOREIGN KEY (ent_a_id) REFERENCES e01_200_03_tb(ent_id) ON DELETE RESTRICT,
    CONSTRAINT fk_idn_b FOREIGN KEY (ent_b_id) REFERENCES e01_200_03_tb(ent_id) ON DELETE RESTRICT,
    CONSTRAINT fk_idn_prv FOREIGN KEY (prv_id) REFERENCES e01_303_01_tb(prv_id) ON DELETE SET NULL);
CREATE INDEX e02_300_10_ix ON e01_300_01_tb(ent_a_id);
CREATE INDEX e02_300_11_ix ON e01_300_01_tb(ent_b_id);
CREATE INDEX e02_300_12_ix ON e01_300_01_tb(prv_id) WHERE prv_id IS NOT NULL;
CREATE INDEX e02_300_13_ix ON e01_300_01_tb(ent_a_id, ent_b_id, clm_type, status);

-- ============ LAYER V — VERSIONING ============

CREATE TABLE e01_330_01_tb(
    vers_id INTEGER PRIMARY KEY AUTOINCREMENT, ent_id INTEGER NOT NULL, vers_label TEXT NOT NULL,
    valid_from TEXT, valid_to TEXT,
    status TEXT NOT NULL DEFAULT 'draft' CHECK(status IN ('draft','under_review','approved','deprecated','retracted')),
    supersedes_id INTEGER, approved_by_id INTEGER, approved_at TEXT, created_at TEXT NOT NULL DEFAULT (datetime('now')),
    CHECK (valid_from IS NULL OR valid_to IS NULL OR valid_from <= valid_to),
    UNIQUE(ent_id, vers_label),
    CONSTRAINT fk_vers_ent FOREIGN KEY (ent_id) REFERENCES e01_200_03_tb(ent_id) ON DELETE RESTRICT,
    CONSTRAINT fk_vers_sup FOREIGN KEY (supersedes_id) REFERENCES e01_330_01_tb(vers_id) ON DELETE RESTRICT,
    CONSTRAINT fk_vers_app FOREIGN KEY (approved_by_id) REFERENCES e01_200_03_tb(ent_id) ON DELETE RESTRICT);
CREATE INDEX e02_330_10_ix ON e01_330_01_tb(ent_id);

CREATE TABLE e01_330_02_tb(
    snap_id INTEGER PRIMARY KEY AUTOINCREMENT, ent_id INTEGER NOT NULL, snap_at TEXT NOT NULL, vers_id INTEGER,
    schema_ver TEXT NOT NULL DEFAULT 'v26.0', snap_data TEXT NOT NULL, reason TEXT, created_at TEXT NOT NULL DEFAULT (datetime('now')),
    CONSTRAINT fk_snap_ent FOREIGN KEY (ent_id) REFERENCES e01_200_03_tb(ent_id) ON DELETE RESTRICT,
    CONSTRAINT fk_snap_ver FOREIGN KEY (vers_id) REFERENCES e01_330_01_tb(vers_id) ON DELETE RESTRICT);
CREATE INDEX e02_330_20_ix ON e01_330_02_tb(ent_id);
CREATE INDEX e02_330_21_ix ON e01_330_02_tb(vers_id) WHERE vers_id IS NOT NULL;

-- ============ LAYER A — AUXILIARY (FTS) ============

CREATE VIRTUAL TABLE e02_404_01_ft USING fts5(
    label_norm, desc_norm, content='e01_200_03_tb', content_rowid='ent_id', tokenize='unicode61 remove_diacritics 1'
);
