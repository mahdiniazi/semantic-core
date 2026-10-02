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
CREATE TABLE e01_506_03_tb(
    element_name TEXT PRIMARY KEY, element_code TEXT UNIQUE,
    element_level INTEGER CHECK(element_level IN (1,2,3,4)),
    element_layer TEXT NOT NULL CHECK(element_layer IN ('M','T','C','X','I','V','A')),
    element_kind TEXT NOT NULL CHECK(element_kind IN ('tb','tr','vw','ix','ft')),
    need_uid TEXT, purpose TEXT, notes TEXT, created_at TEXT NOT NULL DEFAULT (datetime('now')),
    CHECK (element_code IS NULL OR element_code GLOB 'e[0-9][0-9]_[0-9][0-9][0-9]_[0-9][0-9]_[a-z][a-z]'),
    CONSTRAINT fk_ele_need FOREIGN KEY (need_uid) REFERENCES e01_506_01_tb(need_uid) ON DELETE RESTRICT);
CREATE TABLE e01_506_04_tb(
    trace_id INTEGER PRIMARY KEY AUTOINCREMENT, atom_uid TEXT NOT NULL, element_name TEXT NOT NULL,
    trace_type TEXT NOT NULL CHECK(trace_type IN ('implements','verifies','constrains','documents','db_decl','db_guard','db_sync','db_audit','app_layer')),
    UNIQUE(atom_uid, element_name, trace_type),
    CONSTRAINT fk_tra_atom FOREIGN KEY (atom_uid) REFERENCES e01_506_02_tb(atom_uid) ON DELETE RESTRICT,
    CONSTRAINT fk_tra_elem FOREIGN KEY (element_name) REFERENCES e01_506_03_tb(element_name) ON DELETE RESTRICT);
CREATE TABLE sqlite_sequence(name,seq);
CREATE TABLE e01_506_05_tb(
    question_uid TEXT PRIMARY KEY, parent_uid TEXT, label TEXT NOT NULL, purpose TEXT NOT NULL,
    answer_kind TEXT NOT NULL CHECK(answer_kind IN ('text','entity_ref','value','boolean','criterion','free')),
    required_rule TEXT NOT NULL CHECK(required_rule IN ('always','by_need_kind','conditional','optional')),
    seq INTEGER NOT NULL CHECK(seq >= 0),
    CONSTRAINT fk_que_parent FOREIGN KEY (parent_uid) REFERENCES e01_506_05_tb(question_uid) ON DELETE RESTRICT);
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
CREATE TABLE e01_676_01_tb(migration_uid TEXT PRIMARY KEY, applied_at TEXT NOT NULL DEFAULT (datetime('now')), notes TEXT);
CREATE TABLE e01_676_02_tb(id INTEGER PRIMARY KEY CHECK(id = 1), schema_ver INTEGER NOT NULL, last_scan_at TEXT NOT NULL DEFAULT (datetime('now')), checksum TEXT, counted_tables INTEGER, counted_triggers INTEGER, counted_views INTEGER);
CREATE TABLE e01_676_03_tb(param_uid TEXT PRIMARY KEY, int_value INTEGER, text_value TEXT, description TEXT);
CREATE TABLE e01_378_01_tb(
    ref_id INTEGER PRIMARY KEY AUTOINCREMENT, child_table TEXT NOT NULL, child_col TEXT NOT NULL,
    parent_table TEXT NOT NULL, parent_col TEXT NOT NULL,
    action_on_del TEXT NOT NULL DEFAULT 'restrict' CHECK(action_on_del IN ('restrict','cascade','set_null')),
    layer_from TEXT CHECK(layer_from IN ('M','T','C','X','I','V','A')),
    layer_to TEXT CHECK(layer_to IN ('M','T','C','X','I','V','A')),
    note TEXT, UNIQUE(child_table, child_col));
CREATE TABLE e01_506_07_tb(dim_uid TEXT PRIMARY KEY, label TEXT NOT NULL, description TEXT, seq INTEGER NOT NULL);
CREATE TABLE e01_506_08_tb(value_id INTEGER PRIMARY KEY AUTOINCREMENT, dim_uid TEXT NOT NULL, value_uid TEXT NOT NULL, label TEXT NOT NULL, sort_order INTEGER, UNIQUE(dim_uid, value_uid), CONSTRAINT fk_dim_val_dim FOREIGN KEY (dim_uid) REFERENCES e01_506_07_tb(dim_uid) ON DELETE RESTRICT);
CREATE TABLE e01_778_01_tb(
    code_id INTEGER PRIMARY KEY AUTOINCREMENT, need_uid TEXT NOT NULL, code TEXT NOT NULL UNIQUE,
    code_kind TEXT NOT NULL CHECK(code_kind IN ('need','atom','element','chain','invariant')),
    parent_code TEXT, label TEXT NOT NULL, description TEXT, seq INTEGER NOT NULL DEFAULT 0,
    created_at TEXT NOT NULL DEFAULT (datetime('now')),
    CONSTRAINT fk_rc_need FOREIGN KEY (need_uid) REFERENCES e01_506_01_tb(need_uid) ON DELETE RESTRICT,
    CONSTRAINT fk_rc_parent FOREIGN KEY (parent_code) REFERENCES e01_778_01_tb(code) ON DELETE RESTRICT);
CREATE TABLE e01_778_03_tb(
    chain_uid TEXT PRIMARY KEY, code TEXT NOT NULL UNIQUE, root_need_uid TEXT NOT NULL, label TEXT NOT NULL, purpose TEXT,
    chain_kind TEXT NOT NULL CHECK(chain_kind IN ('integrity','workflow','diagnostic','provenance','enforcement','validation')),
    created_at TEXT NOT NULL DEFAULT (datetime('now')),
    CONSTRAINT fk_chain_need FOREIGN KEY (root_need_uid) REFERENCES e01_506_01_tb(need_uid) ON DELETE RESTRICT);
CREATE TABLE e01_778_04_tb(
    chain_uid TEXT NOT NULL, ordinal INTEGER NOT NULL CHECK(ordinal >= 1),
    step_kind TEXT NOT NULL CHECK(step_kind IN ('source','transform','enforce','verify','sink','branch')),
    element_name TEXT, need_uid TEXT, code TEXT, description TEXT NOT NULL,
    PRIMARY KEY (chain_uid, ordinal),
    CONSTRAINT fk_step_chain FOREIGN KEY (chain_uid) REFERENCES e01_778_03_tb(chain_uid) ON DELETE RESTRICT,
    CONSTRAINT fk_step_elem FOREIGN KEY (element_name) REFERENCES e01_506_03_tb(element_name) ON DELETE SET NULL,
    CONSTRAINT fk_step_need FOREIGN KEY (need_uid) REFERENCES e01_506_01_tb(need_uid) ON DELETE SET NULL);
CREATE TABLE e01_200_01_tb(
    type_id INTEGER PRIMARY KEY AUTOINCREMENT, type_uid TEXT NOT NULL UNIQUE, label TEXT NOT NULL, description TEXT,
    parent_id INTEGER, is_abstract INTEGER NOT NULL DEFAULT 0 CHECK(is_abstract IN (0,1)),
    CHECK (parent_id IS NULL OR parent_id <> type_id),
    CONSTRAINT fk_ety_parent FOREIGN KEY (parent_id) REFERENCES e01_200_01_tb(type_id) ON DELETE RESTRICT);
CREATE TABLE e01_120_01_tb(
    desc_id INTEGER NOT NULL, anc_id INTEGER NOT NULL, depth INTEGER NOT NULL CHECK(depth >= 0),
    PRIMARY KEY (desc_id, anc_id),
    CONSTRAINT fk_clos_desc FOREIGN KEY (desc_id) REFERENCES e01_200_01_tb(type_id) ON DELETE RESTRICT,
    CONSTRAINT fk_clos_anc FOREIGN KEY (anc_id) REFERENCES e01_200_01_tb(type_id) ON DELETE RESTRICT) WITHOUT ROWID;
CREATE TABLE e01_202_01_tb(
    reltype_id INTEGER PRIMARY KEY AUTOINCREMENT, type_uid TEXT NOT NULL UNIQUE, label TEXT NOT NULL, description TEXT,
    object_kind TEXT NOT NULL DEFAULT 'entity' CHECK(object_kind IN ('entity','value','entity_or_value')),
    is_symmetric INTEGER NOT NULL DEFAULT 0 CHECK(is_symmetric IN (0,1)),
    is_transitive INTEGER NOT NULL DEFAULT 0 CHECK(is_transitive IN (0,1)),
    is_functional INTEGER NOT NULL DEFAULT 0 CHECK(is_functional IN (0,1)),
    inverse_uid TEXT,
    CONSTRAINT fk_rty_inv FOREIGN KEY (inverse_uid) REFERENCES e01_202_01_tb(type_uid) ON DELETE SET NULL);
CREATE TABLE e01_112_01_tb(
    cons_id INTEGER PRIMARY KEY AUTOINCREMENT, reltype_id INTEGER NOT NULL,
    cons_kind TEXT NOT NULL CHECK(cons_kind IN ('allowed_subject_type','allowed_object_type','allowed_subject_nature','allowed_object_nature')),
    target_type_id INTEGER, target_nature TEXT CHECK(target_nature IS NULL OR target_nature IN ('instance','concept')),
    CHECK ((cons_kind IN ('allowed_subject_type','allowed_object_type') AND target_type_id IS NOT NULL AND target_nature IS NULL) OR (cons_kind IN ('allowed_subject_nature','allowed_object_nature') AND target_type_id IS NULL AND target_nature IS NOT NULL)),
    CONSTRAINT fk_cons_rel FOREIGN KEY (reltype_id) REFERENCES e01_202_01_tb(reltype_id) ON DELETE RESTRICT,
    CONSTRAINT fk_cons_type FOREIGN KEY (target_type_id) REFERENCES e01_200_01_tb(type_id) ON DELETE RESTRICT);
CREATE TABLE e01_200_02_tb(dom_id INTEGER PRIMARY KEY AUTOINCREMENT, dom_uid TEXT NOT NULL UNIQUE, label TEXT NOT NULL, description TEXT);
CREATE TABLE e01_201_01_tb(
    val_id INTEGER PRIMARY KEY AUTOINCREMENT, dom_id INTEGER NOT NULL, value_uid TEXT NOT NULL, label TEXT NOT NULL, sort_order INTEGER,
    UNIQUE(dom_id, value_uid),
    CONSTRAINT fk_enm_val_dom FOREIGN KEY (dom_id) REFERENCES e01_200_02_tb(dom_id) ON DELETE RESTRICT);
CREATE TABLE e01_303_01_tb(
    prv_id INTEGER PRIMARY KEY AUTOINCREMENT,
    source_type TEXT NOT NULL CHECK(source_type IN ('manual','sensor','document','inference','external_system','user','ai','import','unknown')),
    source_ref TEXT, method TEXT, confidence REAL CHECK(confidence IS NULL OR (confidence >= 0 AND confidence <= 1)),
    created_at TEXT NOT NULL DEFAULT (datetime('now')), notes TEXT);
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
CREATE TABLE e01_201_03_tb(
    memb_id INTEGER PRIMARY KEY AUTOINCREMENT, parent_id INTEGER NOT NULL, member_val_id INTEGER, member_ent_id INTEGER, ordinal INTEGER NOT NULL DEFAULT 0 CHECK(ordinal >= 0),
    CHECK ((member_val_id IS NOT NULL AND member_ent_id IS NULL) OR (member_val_id IS NULL AND member_ent_id IS NOT NULL)),
    CHECK (parent_id <> member_val_id),
    CONSTRAINT fk_memb_parent FOREIGN KEY (parent_id) REFERENCES e01_201_02_tb(val_id) ON DELETE CASCADE,
    CONSTRAINT fk_memb_val FOREIGN KEY (member_val_id) REFERENCES e01_201_02_tb(val_id) ON DELETE RESTRICT,
    CONSTRAINT fk_memb_ent FOREIGN KEY (member_ent_id) REFERENCES e01_200_03_tb(ent_id) ON DELETE RESTRICT);
CREATE TABLE e01_302_01_tb(
    lin_id INTEGER PRIMARY KEY AUTOINCREMENT, lin_uid TEXT NOT NULL UNIQUE, subj_ent_id INTEGER NOT NULL, reltype_id INTEGER NOT NULL, description TEXT,
    created_at TEXT NOT NULL DEFAULT (datetime('now')),
    CONSTRAINT fk_lin_subj FOREIGN KEY (subj_ent_id) REFERENCES e01_200_03_tb(ent_id) ON DELETE RESTRICT,
    CONSTRAINT fk_lin_rty FOREIGN KEY (reltype_id) REFERENCES e01_202_01_tb(reltype_id) ON DELETE RESTRICT);
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
CREATE TABLE e01_330_02_tb(
    snap_id INTEGER PRIMARY KEY AUTOINCREMENT, ent_id INTEGER NOT NULL, snap_at TEXT NOT NULL, vers_id INTEGER,
    schema_ver TEXT NOT NULL DEFAULT 'v26.0', snap_data TEXT NOT NULL, reason TEXT, created_at TEXT NOT NULL DEFAULT (datetime('now')),
    CONSTRAINT fk_snap_ent FOREIGN KEY (ent_id) REFERENCES e01_200_03_tb(ent_id) ON DELETE RESTRICT,
    CONSTRAINT fk_snap_ver FOREIGN KEY (vers_id) REFERENCES e01_330_01_tb(vers_id) ON DELETE RESTRICT);
CREATE TABLE e01_778_05_tb(
    policy_id INTEGER PRIMARY KEY AUTOINCREMENT,
    element_name TEXT NOT NULL,
    need_uid TEXT NOT NULL,
    policy_kind TEXT NOT NULL CHECK(policy_kind IN ('fk','guard','sync','audit','immutability','index')),
    fk_ref_id INTEGER,
    exec_name TEXT,
    rationale TEXT NOT NULL CHECK(length(rationale) >= 10),
    is_mandatory INTEGER NOT NULL DEFAULT 1 CHECK(is_mandatory IN (0,1)),
    created_at TEXT NOT NULL DEFAULT (datetime('now')),
    CHECK ((policy_kind = 'fk' AND fk_ref_id IS NOT NULL AND exec_name IS NULL) OR (policy_kind IN ('guard','sync','audit','immutability','index') AND fk_ref_id IS NULL AND exec_name IS NOT NULL)),
    CONSTRAINT fk_pol_elem FOREIGN KEY (element_name) REFERENCES e01_506_03_tb(element_name) ON DELETE RESTRICT,
    CONSTRAINT fk_pol_need FOREIGN KEY (need_uid) REFERENCES e01_506_01_tb(need_uid) ON DELETE RESTRICT,
    CONSTRAINT fk_pol_fk FOREIGN KEY (fk_ref_id) REFERENCES e01_378_01_tb(ref_id) ON DELETE RESTRICT,
    CONSTRAINT fk_pol_exec FOREIGN KEY (exec_name) REFERENCES e01_506_03_tb(element_name) ON DELETE RESTRICT
);
CREATE TABLE _baseline_v26 (kind TEXT NOT NULL, id INTEGER, label TEXT, details TEXT, captured_at TEXT NOT NULL DEFAULT (datetime('now')));
CREATE TABLE IF NOT EXISTS 'e02_404_01_ft_data'(id INTEGER PRIMARY KEY, block BLOB);
CREATE TABLE IF NOT EXISTS 'e02_404_01_ft_idx'(segid, term, pgno, PRIMARY KEY(segid, term)) WITHOUT ROWID;
CREATE TABLE IF NOT EXISTS 'e02_404_01_ft_docsize'(id INTEGER PRIMARY KEY, sz BLOB);
CREATE TABLE IF NOT EXISTS 'e02_404_01_ft_config'(k PRIMARY KEY, v) WITHOUT ROWID;
CREATE TABLE e01_516_01_tb (
    need_uid  TEXT NOT NULL,
    atom_uid  TEXT NOT NULL,
    kind      TEXT NOT NULL DEFAULT 'derived'
              CHECK(kind IN ('derived','refined','satisfies')),
    origin    TEXT NOT NULL DEFAULT 'design'
              CHECK(origin IN ('design','inferred','observed','derived')),
    PRIMARY KEY (need_uid, atom_uid, kind),
    CONSTRAINT fk_nea_need FOREIGN KEY (need_uid)
        REFERENCES e01_506_01_tb(need_uid) ON DELETE RESTRICT,
    CONSTRAINT fk_nea_atom FOREIGN KEY (atom_uid)
        REFERENCES e01_506_02_tb(atom_uid) ON DELETE RESTRICT
) WITHOUT ROWID;
CREATE TABLE e01_778_02_tb (
    element_name    TEXT NOT NULL,
    need_uid        TEXT NOT NULL,
    code            TEXT,
    is_primary      INTEGER NOT NULL DEFAULT 0 CHECK(is_primary IN (0,1)),
    is_driving      INTEGER NOT NULL DEFAULT 0 CHECK(is_driving IN (0,1)),
    role            TEXT NOT NULL DEFAULT 'serves'
                    CHECK(role IN
                       ('defines','serves','verifies','constrains',
                        'observes','maintains')),
    note            TEXT,
    PRIMARY KEY (element_name, need_uid, role),
    CONSTRAINT fk_er_elem FOREIGN KEY (element_name)
        REFERENCES e01_506_03_tb(element_name) ON DELETE RESTRICT,
    CONSTRAINT fk_er_need FOREIGN KEY (need_uid)
        REFERENCES e01_506_01_tb(need_uid) ON DELETE RESTRICT,
    CONSTRAINT fk_er_code FOREIGN KEY (code)
        REFERENCES e01_778_01_tb(code) ON DELETE RESTRICT
) WITHOUT ROWID;
CREATE TABLE sqlite_stat1(tbl,idx,stat);
CREATE TABLE e01_506_12_tb (
    need_uid     TEXT NOT NULL,
    node_id      INTEGER NOT NULL,
    question_uid TEXT NOT NULL,
    slot         TEXT,
    answer_text  TEXT,
    status       TEXT,
    depth        INTEGER NOT NULL DEFAULT 0,
    path         TEXT,
    cached_at    TEXT NOT NULL DEFAULT (datetime('now')),
    PRIMARY KEY (need_uid, node_id)
) WITHOUT ROWID;
CREATE INDEX e02_506_10_ix ON e01_506_02_tb(category);
CREATE INDEX e02_506_11_ix ON e01_506_02_tb(origin);
CREATE INDEX e02_506_12_ix ON e01_506_02_tb(verb_code);
CREATE INDEX e02_506_13_ix ON e01_506_02_tb(entity_code);
CREATE INDEX e02_506_14_ix ON e01_506_02_tb(constraint_code) WHERE constraint_code IS NOT NULL;
CREATE INDEX e02_506_15_ix ON e01_506_03_tb(element_layer);
CREATE INDEX e02_506_16_ix ON e01_506_03_tb(element_kind);
CREATE INDEX e02_506_17_ix ON e01_506_03_tb(need_uid) WHERE need_uid IS NOT NULL;
CREATE INDEX e02_506_18_ix ON e01_506_04_tb(atom_uid);
CREATE INDEX e02_506_19_ix ON e01_506_04_tb(element_name);
CREATE INDEX e02_506_20_ix ON e01_506_05_tb(parent_uid);
CREATE INDEX e02_506_21_ix ON e01_506_06_tb(need_uid);
CREATE INDEX e02_506_22_ix ON e01_506_06_tb(parent_id);
CREATE INDEX e02_506_23_ix ON e01_506_06_tb(question_uid);
CREATE UNIQUE INDEX e02_506_24_ix ON e01_506_06_tb(need_uid, question_uid, ordinal) WHERE parent_id IS NULL;
CREATE INDEX e02_378_10_ix ON e01_378_01_tb(child_table);
CREATE INDEX e02_378_11_ix ON e01_378_01_tb(parent_table);
CREATE INDEX e02_506_25_ix ON e01_506_08_tb(dim_uid);
CREATE INDEX e02_778_10_ix ON e01_778_01_tb(parent_code);
CREATE INDEX e02_778_11_ix ON e01_778_01_tb(need_uid);
CREATE INDEX e02_778_12_ix ON e01_778_01_tb(code_kind);
CREATE INDEX e02_778_30_ix ON e01_778_03_tb(root_need_uid);
CREATE INDEX e02_778_31_ix ON e01_778_03_tb(chain_kind);
CREATE INDEX e02_778_40_ix ON e01_778_04_tb(step_kind);
CREATE INDEX e02_778_41_ix ON e01_778_04_tb(element_name) WHERE element_name IS NOT NULL;
CREATE INDEX e02_778_42_ix ON e01_778_04_tb(need_uid) WHERE need_uid IS NOT NULL;
CREATE INDEX e02_200_10_ix ON e01_200_01_tb(parent_id);
CREATE INDEX e02_120_10_ix ON e01_120_01_tb(anc_id);
CREATE INDEX e02_202_10_ix ON e01_202_01_tb(object_kind);
CREATE INDEX e02_202_11_ix ON e01_202_01_tb(is_functional) WHERE is_functional = 1;
CREATE UNIQUE INDEX e02_112_10_ix ON e01_112_01_tb(reltype_id, cons_kind, target_type_id) WHERE target_type_id IS NOT NULL;
CREATE UNIQUE INDEX e02_112_11_ix ON e01_112_01_tb(reltype_id, cons_kind, target_nature) WHERE target_nature IS NOT NULL;
CREATE INDEX e02_112_12_ix ON e01_112_01_tb(reltype_id);
CREATE INDEX e02_112_13_ix ON e01_112_01_tb(cons_kind);
CREATE INDEX e02_201_10_ix ON e01_201_01_tb(dom_id);
CREATE INDEX e02_303_10_ix ON e01_303_01_tb(source_type);
CREATE INDEX e02_303_11_ix ON e01_303_01_tb(source_type, source_ref);
CREATE UNIQUE INDEX e02_303_12_ix ON e01_303_01_tb(source_type, source_ref) WHERE source_type='unknown' AND source_ref='system:unknown';
CREATE INDEX e02_200_20_ix ON e01_200_03_tb(type_id, nature);
CREATE INDEX e02_200_21_ix ON e01_200_03_tb(nature);
CREATE INDEX e02_200_22_ix ON e01_200_03_tb(status);
CREATE INDEX e02_200_23_ix ON e01_200_03_tb(label);
CREATE INDEX e02_200_24_ix ON e01_200_03_tb(prv_id) WHERE prv_id IS NOT NULL;
CREATE INDEX e02_201_20_ix ON e01_201_02_tb(value_kind);
CREATE INDEX e02_201_21_ix ON e01_201_02_tb(num_val) WHERE num_val IS NOT NULL;
CREATE INDEX e02_201_22_ix ON e01_201_02_tb(text_val) WHERE text_val IS NOT NULL;
CREATE INDEX e02_201_23_ix ON e01_201_02_tb(text_norm) WHERE text_norm IS NOT NULL;
CREATE INDEX e02_201_24_ix ON e01_201_02_tb(enum_id) WHERE enum_id IS NOT NULL;
CREATE INDEX e02_201_25_ix ON e01_201_02_tb(prv_id) WHERE prv_id IS NOT NULL;
CREATE INDEX e02_201_30_ix ON e01_201_03_tb(parent_id);
CREATE INDEX e02_201_31_ix ON e01_201_03_tb(member_val_id);
CREATE INDEX e02_201_32_ix ON e01_201_03_tb(member_ent_id);
CREATE INDEX e02_302_10_ix ON e01_302_01_tb(subj_ent_id);
CREATE INDEX e02_302_11_ix ON e01_302_01_tb(reltype_id);
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
CREATE UNIQUE INDEX e02_305_10_ix ON e01_305_01_tb(ent_id, COALESCE(ctx_ent_id, -1), COALESCE(ctx_val_id, -1), role, COALESCE(valid_from, ''), COALESCE(valid_to, ''));
CREATE INDEX e02_305_11_ix ON e01_305_01_tb(ctx_ent_id) WHERE ctx_ent_id IS NOT NULL;
CREATE INDEX e02_305_12_ix ON e01_305_01_tb(prv_id) WHERE prv_id IS NOT NULL;
CREATE UNIQUE INDEX e02_305_20_ix ON e01_305_02_tb(val_id, COALESCE(ctx_ent_id, -1), COALESCE(ctx_val_id, -1), role, COALESCE(valid_from, ''), COALESCE(valid_to, ''));
CREATE INDEX e02_305_21_ix ON e01_305_02_tb(ctx_ent_id) WHERE ctx_ent_id IS NOT NULL;
CREATE INDEX e02_305_22_ix ON e01_305_02_tb(prv_id) WHERE prv_id IS NOT NULL;
CREATE UNIQUE INDEX e02_305_30_ix ON e01_305_03_tb(rel_id, COALESCE(ctx_ent_id, -1), COALESCE(ctx_val_id, -1), role, COALESCE(valid_from, ''), COALESCE(valid_to, ''));
CREATE INDEX e02_305_31_ix ON e01_305_03_tb(ctx_ent_id) WHERE ctx_ent_id IS NOT NULL;
CREATE INDEX e02_305_32_ix ON e01_305_03_tb(prv_id) WHERE prv_id IS NOT NULL;
CREATE INDEX e02_300_10_ix ON e01_300_01_tb(ent_a_id);
CREATE INDEX e02_300_11_ix ON e01_300_01_tb(ent_b_id);
CREATE INDEX e02_300_12_ix ON e01_300_01_tb(prv_id) WHERE prv_id IS NOT NULL;
CREATE INDEX e02_300_13_ix ON e01_300_01_tb(ent_a_id, ent_b_id, clm_type, status);
CREATE INDEX e02_330_10_ix ON e01_330_01_tb(ent_id);
CREATE INDEX e02_330_20_ix ON e01_330_02_tb(ent_id);
CREATE INDEX e02_330_21_ix ON e01_330_02_tb(vers_id) WHERE vers_id IS NOT NULL;
CREATE INDEX e02_778_50_ix ON e01_778_05_tb(element_name);
CREATE INDEX e02_778_51_ix ON e01_778_05_tb(need_uid);
CREATE INDEX e02_778_52_ix ON e01_778_05_tb(policy_kind);
CREATE INDEX e02_778_53_ix ON e01_778_05_tb(fk_ref_id) WHERE fk_ref_id IS NOT NULL;
CREATE INDEX e02_778_54_ix ON e01_778_05_tb(exec_name) WHERE exec_name IS NOT NULL;
CREATE INDEX e02_516_10_ix ON e01_516_01_tb(atom_uid);
CREATE INDEX e02_516_11_ix ON e01_516_01_tb(origin);
CREATE INDEX e02_778_20_ix ON e01_778_02_tb(need_uid);
CREATE INDEX e02_778_21_ix ON e01_778_02_tb(code) WHERE code IS NOT NULL;
CREATE INDEX e02_778_22_ix ON e01_778_02_tb(is_primary) WHERE is_primary = 1;
CREATE INDEX e02_778_23_ix ON e01_778_02_tb(is_driving) WHERE is_driving = 1;
CREATE INDEX e02_222_21_ix 
    ON e01_222_01_tb(subj_ent_id, reltype_id, obj_ent_id, status)
    WHERE superseded_at IS NULL;
CREATE INDEX e02_222_22_ix 
    ON e01_222_01_tb(obj_ent_id, reltype_id, subj_ent_id, status)
    WHERE superseded_at IS NULL AND obj_ent_id IS NOT NULL;
CREATE INDEX e02_222_23_ix 
    ON e01_222_01_tb(reltype_id, subj_ent_id)
    WHERE superseded_at IS NULL AND status = 'asserted';
CREATE INDEX e02_222_24_ix 
    ON e01_222_01_tb(valid_from, valid_to)
    WHERE valid_to IS NULL OR valid_to > datetime('now');
CREATE INDEX e02_200_25_ix 
    ON e01_200_03_tb(type_id, status)
    WHERE status = 'active';
CREATE TRIGGER e03_312_01_tr BEFORE INSERT ON e01_222_01_tb
BEGIN
  SELECT CASE WHEN (SELECT reltype_id FROM e01_202_01_tb WHERE reltype_id = NEW.reltype_id) IS NULL THEN RAISE(ABORT, 'unknown relation type') END;
  SELECT CASE WHEN (SELECT ent_id FROM e01_200_03_tb WHERE ent_id = NEW.subj_ent_id) IS NULL THEN RAISE(ABORT, 'subject entity does not exist') END;
  SELECT CASE WHEN NEW.obj_ent_id IS NOT NULL AND (SELECT ent_id FROM e01_200_03_tb WHERE ent_id = NEW.obj_ent_id) IS NULL THEN RAISE(ABORT, 'object entity does not exist') END;
  SELECT CASE WHEN NEW.obj_val_id IS NOT NULL AND (SELECT val_id FROM e01_201_02_tb WHERE val_id = NEW.obj_val_id) IS NULL THEN RAISE(ABORT, 'object value does not exist') END;
  SELECT CASE WHEN NEW.lin_id IS NOT NULL AND (SELECT lin_id FROM e01_302_01_tb WHERE lin_id = NEW.lin_id) IS NULL THEN RAISE(ABORT, 'relation lineage does not exist') END;
  SELECT CASE WHEN NEW.prv_id IS NOT NULL AND (SELECT prv_id FROM e01_303_01_tb WHERE prv_id = NEW.prv_id) IS NULL THEN RAISE(ABORT, 'relation provenance does not exist') END;
  SELECT CASE WHEN NEW.reif_type <> 'none' AND NOT EXISTS (SELECT 1 FROM e01_200_03_tb e JOIN e01_200_01_tb et ON et.type_id = e.type_id WHERE e.ent_id = NEW.reif_ent_id AND et.type_uid IN ('ReifiedRelation','Evidence','Observation','Measurement','Claim','Hypothesis','Diagnosis')) THEN RAISE(ABORT, 'reification target invalid') END;
  SELECT CASE WHEN (SELECT object_kind FROM e01_202_01_tb WHERE reltype_id = NEW.reltype_id) = 'entity' AND NEW.obj_val_id IS NOT NULL THEN RAISE(ABORT, 'expects entity; got value') END;
  SELECT CASE WHEN (SELECT object_kind FROM e01_202_01_tb WHERE reltype_id = NEW.reltype_id) = 'value' AND NEW.obj_ent_id IS NOT NULL THEN RAISE(ABORT, 'expects value; got entity') END;
  SELECT CASE WHEN EXISTS (SELECT 1 FROM e01_112_01_tb WHERE reltype_id = NEW.reltype_id AND cons_kind = 'allowed_subject_type')
    AND NOT EXISTS (SELECT 1 FROM e01_112_01_tb tc JOIN e01_120_01_tb cl ON cl.anc_id = tc.target_type_id JOIN e01_200_03_tb e ON e.ent_id = NEW.subj_ent_id AND e.type_id = cl.desc_id WHERE tc.reltype_id = NEW.reltype_id AND tc.cons_kind = 'allowed_subject_type')
    THEN RAISE(ABORT, 'subject violates domain (type)') END;
  SELECT CASE WHEN NEW.obj_ent_id IS NOT NULL AND EXISTS (SELECT 1 FROM e01_112_01_tb WHERE reltype_id = NEW.reltype_id AND cons_kind = 'allowed_object_type')
    AND NOT EXISTS (SELECT 1 FROM e01_112_01_tb tc JOIN e01_120_01_tb cl ON cl.anc_id = tc.target_type_id JOIN e01_200_03_tb e ON e.ent_id = NEW.obj_ent_id AND e.type_id = cl.desc_id WHERE tc.reltype_id = NEW.reltype_id AND tc.cons_kind = 'allowed_object_type')
    THEN RAISE(ABORT, 'object violates domain (type)') END;
  SELECT CASE WHEN EXISTS (SELECT 1 FROM e01_112_01_tb WHERE reltype_id = NEW.reltype_id AND cons_kind = 'allowed_subject_nature')
    AND NOT EXISTS (SELECT 1 FROM e01_112_01_tb tc JOIN e01_200_03_tb e ON e.ent_id = NEW.subj_ent_id WHERE tc.reltype_id = NEW.reltype_id AND tc.cons_kind = 'allowed_subject_nature' AND tc.target_nature = e.nature)
    THEN RAISE(ABORT, 'subject violates domain (nature)') END;
  SELECT CASE WHEN NEW.obj_ent_id IS NOT NULL AND EXISTS (SELECT 1 FROM e01_112_01_tb WHERE reltype_id = NEW.reltype_id AND cons_kind = 'allowed_object_nature')
    AND NOT EXISTS (SELECT 1 FROM e01_112_01_tb tc JOIN e01_200_03_tb e ON e.ent_id = NEW.obj_ent_id WHERE tc.reltype_id = NEW.reltype_id AND tc.cons_kind = 'allowed_object_nature' AND tc.target_nature = e.nature)
    THEN RAISE(ABORT, 'object violates domain (nature)') END;
  SELECT CASE WHEN NEW.superseded_at IS NULL AND NEW.status = 'asserted' AND EXISTS (SELECT 1 FROM e01_222_01_tb r JOIN e01_202_01_tb rt ON rt.reltype_id = r.reltype_id WHERE r.subj_ent_id = NEW.subj_ent_id AND r.reltype_id = NEW.reltype_id AND r.ctx_key = NEW.ctx_key AND r.superseded_at IS NULL AND r.status = 'asserted' AND rt.is_functional = 1)
    THEN RAISE(ABORT, 'functional already asserted in ctx') END;
  SELECT CASE WHEN NEW.reltype_id = (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid = 'instance_of') AND NEW.superseded_at IS NULL AND NEW.status = 'asserted'
    AND EXISTS (SELECT 1 FROM e01_222_01_tb r WHERE r.subj_ent_id = NEW.subj_ent_id AND r.reltype_id = NEW.reltype_id AND r.superseded_at IS NULL AND r.status = 'asserted')
    THEN RAISE(ABORT, 'instance_of: one concept per instance') END;
  SELECT CASE WHEN NEW.reltype_id = (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid = 'instance_of') AND NEW.obj_ent_id IS NOT NULL AND NEW.superseded_at IS NULL AND NEW.status = 'asserted'
    AND (SELECT nature FROM e01_200_03_tb WHERE ent_id = NEW.subj_ent_id) = 'instance'
    AND (SELECT nature FROM e01_200_03_tb WHERE ent_id = NEW.obj_ent_id) = 'concept'
    AND (SELECT type_id FROM e01_200_03_tb WHERE ent_id = NEW.subj_ent_id) <> (SELECT type_id FROM e01_200_03_tb WHERE ent_id = NEW.obj_ent_id)
    THEN RAISE(ABORT, 'instance_of: subject type must match concept type') END;
END;
CREATE TRIGGER e03_312_02_tr BEFORE UPDATE OF subj_ent_id, reltype_id, obj_ent_id, obj_val_id, reif_type, reif_ent_id, lin_id, prv_id ON e01_222_01_tb
BEGIN
  SELECT CASE WHEN (SELECT reltype_id FROM e01_202_01_tb WHERE reltype_id = NEW.reltype_id) IS NULL THEN RAISE(ABORT, 'unknown relation type') END;
  SELECT CASE WHEN (SELECT ent_id FROM e01_200_03_tb WHERE ent_id = NEW.subj_ent_id) IS NULL THEN RAISE(ABORT, 'subject entity does not exist') END;
  SELECT CASE WHEN NEW.obj_ent_id IS NOT NULL AND (SELECT ent_id FROM e01_200_03_tb WHERE ent_id = NEW.obj_ent_id) IS NULL THEN RAISE(ABORT, 'object entity does not exist') END;
  SELECT CASE WHEN NEW.obj_val_id IS NOT NULL AND (SELECT val_id FROM e01_201_02_tb WHERE val_id = NEW.obj_val_id) IS NULL THEN RAISE(ABORT, 'object value does not exist') END;
  SELECT CASE WHEN NEW.lin_id IS NOT NULL AND (SELECT lin_id FROM e01_302_01_tb WHERE lin_id = NEW.lin_id) IS NULL THEN RAISE(ABORT, 'relation lineage does not exist') END;
  SELECT CASE WHEN NEW.prv_id IS NOT NULL AND (SELECT prv_id FROM e01_303_01_tb WHERE prv_id = NEW.prv_id) IS NULL THEN RAISE(ABORT, 'relation provenance does not exist') END;
  SELECT CASE WHEN NEW.reif_type <> 'none' AND NOT EXISTS (SELECT 1 FROM e01_200_03_tb e JOIN e01_200_01_tb et ON et.type_id = e.type_id WHERE e.ent_id = NEW.reif_ent_id AND et.type_uid IN ('ReifiedRelation','Evidence','Observation','Measurement','Claim','Hypothesis','Diagnosis')) THEN RAISE(ABORT, 'reification target invalid') END;
  SELECT CASE WHEN (SELECT object_kind FROM e01_202_01_tb WHERE reltype_id = NEW.reltype_id) = 'entity' AND NEW.obj_val_id IS NOT NULL THEN RAISE(ABORT, 'expects entity; got value') END;
  SELECT CASE WHEN (SELECT object_kind FROM e01_202_01_tb WHERE reltype_id = NEW.reltype_id) = 'value' AND NEW.obj_ent_id IS NOT NULL THEN RAISE(ABORT, 'expects value; got entity') END;
  SELECT CASE WHEN EXISTS (SELECT 1 FROM e01_112_01_tb WHERE reltype_id = NEW.reltype_id AND cons_kind = 'allowed_subject_type')
    AND NOT EXISTS (SELECT 1 FROM e01_112_01_tb tc JOIN e01_120_01_tb cl ON cl.anc_id = tc.target_type_id JOIN e01_200_03_tb e ON e.ent_id = NEW.subj_ent_id AND e.type_id = cl.desc_id WHERE tc.reltype_id = NEW.reltype_id AND tc.cons_kind = 'allowed_subject_type')
    THEN RAISE(ABORT, 'subject violates domain (type)') END;
  SELECT CASE WHEN NEW.obj_ent_id IS NOT NULL AND EXISTS (SELECT 1 FROM e01_112_01_tb WHERE reltype_id = NEW.reltype_id AND cons_kind = 'allowed_object_type')
    AND NOT EXISTS (SELECT 1 FROM e01_112_01_tb tc JOIN e01_120_01_tb cl ON cl.anc_id = tc.target_type_id JOIN e01_200_03_tb e ON e.ent_id = NEW.obj_ent_id AND e.type_id = cl.desc_id WHERE tc.reltype_id = NEW.reltype_id AND tc.cons_kind = 'allowed_object_type')
    THEN RAISE(ABORT, 'object violates domain (type)') END;
  SELECT CASE WHEN EXISTS (SELECT 1 FROM e01_112_01_tb WHERE reltype_id = NEW.reltype_id AND cons_kind = 'allowed_subject_nature')
    AND NOT EXISTS (SELECT 1 FROM e01_112_01_tb tc JOIN e01_200_03_tb e ON e.ent_id = NEW.subj_ent_id WHERE tc.reltype_id = NEW.reltype_id AND tc.cons_kind = 'allowed_subject_nature' AND tc.target_nature = e.nature)
    THEN RAISE(ABORT, 'subject violates domain (nature)') END;
  SELECT CASE WHEN NEW.obj_ent_id IS NOT NULL AND EXISTS (SELECT 1 FROM e01_112_01_tb WHERE reltype_id = NEW.reltype_id AND cons_kind = 'allowed_object_nature')
    AND NOT EXISTS (SELECT 1 FROM e01_112_01_tb tc JOIN e01_200_03_tb e ON e.ent_id = NEW.obj_ent_id WHERE tc.reltype_id = NEW.reltype_id AND tc.cons_kind = 'allowed_object_nature' AND tc.target_nature = e.nature)
    THEN RAISE(ABORT, 'object violates domain (nature)') END;
END;
CREATE TRIGGER e03_112_01_tr BEFORE UPDATE OF ctx_key, status, superseded_at ON e01_222_01_tb
BEGIN
  SELECT CASE WHEN NEW.superseded_at IS NULL AND NEW.status = 'asserted' AND OLD.ctx_key <> NEW.ctx_key
    AND EXISTS (SELECT 1 FROM e01_222_01_tb r JOIN e01_202_01_tb rt ON rt.reltype_id = r.reltype_id
      WHERE r.subj_ent_id = NEW.subj_ent_id AND r.reltype_id = NEW.reltype_id AND r.ctx_key = NEW.ctx_key
        AND r.superseded_at IS NULL AND r.status = 'asserted' AND r.rel_id <> NEW.rel_id AND rt.is_functional = 1)
    THEN RAISE(ABORT, 'functional already asserted (ctx conflict)') END;
  SELECT CASE WHEN NEW.reltype_id = (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid = 'instance_of') AND NEW.superseded_at IS NULL AND NEW.status = 'asserted' AND OLD.status <> 'asserted'
    AND EXISTS (SELECT 1 FROM e01_222_01_tb r WHERE r.subj_ent_id = NEW.subj_ent_id AND r.reltype_id = NEW.reltype_id AND r.superseded_at IS NULL AND r.status = 'asserted' AND r.rel_id <> NEW.rel_id)
    THEN RAISE(ABORT, 'instance_of: one concept (upd)') END;
END;
CREATE TRIGGER e03_135_01_tr AFTER INSERT ON e01_305_03_tb
BEGIN
  UPDATE e01_222_01_tb SET ctx_key = COALESCE(
    (SELECT 's:' || group_concat(x, '|')
     FROM (SELECT COALESCE('e:' || ctx_ent_id, 'v:' || ctx_val_id) || ':' || role AS x
           FROM e01_305_03_tb WHERE rel_id = NEW.rel_id
           ORDER BY role, COALESCE(ctx_ent_id, ctx_val_id))), 'u:')
  WHERE rel_id = NEW.rel_id;
END;
CREATE TRIGGER e03_135_02_tr AFTER UPDATE OF ctx_ent_id, ctx_val_id, role, rel_id ON e01_305_03_tb
BEGIN
  UPDATE e01_222_01_tb SET ctx_key = COALESCE(
    (SELECT 's:' || group_concat(x, '|')
     FROM (SELECT COALESCE('e:' || ctx_ent_id, 'v:' || ctx_val_id) || ':' || role AS x
           FROM e01_305_03_tb WHERE rel_id = OLD.rel_id
           ORDER BY role, COALESCE(ctx_ent_id, ctx_val_id))), 'u:')
  WHERE rel_id = OLD.rel_id;
  UPDATE e01_222_01_tb SET ctx_key = COALESCE(
    (SELECT 's:' || group_concat(x, '|')
     FROM (SELECT COALESCE('e:' || ctx_ent_id, 'v:' || ctx_val_id) || ':' || role AS x
           FROM e01_305_03_tb WHERE rel_id = NEW.rel_id
           ORDER BY role, COALESCE(ctx_ent_id, ctx_val_id))), 'u:')
  WHERE rel_id = NEW.rel_id;
END;
CREATE TRIGGER e03_135_03_tr AFTER DELETE ON e01_305_03_tb
BEGIN
  UPDATE e01_222_01_tb SET ctx_key = COALESCE(
    (SELECT 's:' || group_concat(x, '|')
     FROM (SELECT COALESCE('e:' || ctx_ent_id, 'v:' || ctx_val_id) || ':' || role AS x
           FROM e01_305_03_tb WHERE rel_id = OLD.rel_id
           ORDER BY role, COALESCE(ctx_ent_id, ctx_val_id))), 'u:')
  WHERE rel_id = OLD.rel_id;
END;
CREATE TRIGGER e03_343_01_tr AFTER INSERT ON e01_200_03_tb WHEN NEW.prv_id IS NULL
BEGIN UPDATE e01_200_03_tb SET prv_id = (SELECT prv_id FROM e01_303_01_tb WHERE source_type='unknown' AND source_ref='system:unknown' ORDER BY prv_id LIMIT 1), updated_at = datetime('now') WHERE ent_id = NEW.ent_id; END;
CREATE TRIGGER e03_343_02_tr AFTER INSERT ON e01_201_02_tb WHEN NEW.prv_id IS NULL
BEGIN UPDATE e01_201_02_tb SET prv_id = (SELECT prv_id FROM e01_303_01_tb WHERE source_type='unknown' AND source_ref='system:unknown' ORDER BY prv_id LIMIT 1) WHERE val_id = NEW.val_id; END;
CREATE TRIGGER e03_343_03_tr AFTER INSERT ON e01_222_01_tb WHEN NEW.prv_id IS NULL
BEGIN UPDATE e01_222_01_tb SET prv_id = (SELECT prv_id FROM e01_303_01_tb WHERE source_type='unknown' AND source_ref='system:unknown' ORDER BY prv_id LIMIT 1) WHERE rel_id = NEW.rel_id; END;
CREATE TRIGGER e03_343_04_tr AFTER INSERT ON e01_305_01_tb WHEN NEW.prv_id IS NULL
BEGIN UPDATE e01_305_01_tb SET prv_id = (SELECT prv_id FROM e01_303_01_tb WHERE source_type='unknown' AND source_ref='system:unknown' ORDER BY prv_id LIMIT 1) WHERE ctx_id = NEW.ctx_id; END;
CREATE TRIGGER e03_343_05_tr AFTER INSERT ON e01_305_02_tb WHEN NEW.prv_id IS NULL
BEGIN UPDATE e01_305_02_tb SET prv_id = (SELECT prv_id FROM e01_303_01_tb WHERE source_type='unknown' AND source_ref='system:unknown' ORDER BY prv_id LIMIT 1) WHERE ctx_id = NEW.ctx_id; END;
CREATE TRIGGER e03_343_06_tr AFTER INSERT ON e01_305_03_tb WHEN NEW.prv_id IS NULL
BEGIN UPDATE e01_305_03_tb SET prv_id = (SELECT prv_id FROM e01_303_01_tb WHERE source_type='unknown' AND source_ref='system:unknown' ORDER BY prv_id LIMIT 1) WHERE ctx_id = NEW.ctx_id; END;
CREATE TRIGGER e03_343_07_tr AFTER INSERT ON e01_300_01_tb WHEN NEW.prv_id IS NULL
BEGIN UPDATE e01_300_01_tb SET prv_id = (SELECT prv_id FROM e01_303_01_tb WHERE source_type='unknown' AND source_ref='system:unknown' ORDER BY prv_id LIMIT 1) WHERE clm_id = NEW.clm_id; END;
CREATE TRIGGER e03_343_08_tr BEFORE DELETE ON e01_303_01_tb WHEN OLD.source_type = 'unknown' AND OLD.source_ref = 'system:unknown'
BEGIN SELECT RAISE(ABORT, 'cannot delete fallback provenance'); END;
CREATE TRIGGER e03_343_09_tr BEFORE UPDATE OF source_type, source_ref ON e01_303_01_tb
WHEN OLD.source_type = 'unknown' AND OLD.source_ref = 'system:unknown' AND (NEW.source_type <> 'unknown' OR NEW.source_ref <> 'system:unknown')
BEGIN SELECT RAISE(ABORT, 'cannot change fallback provenance identity'); END;
CREATE TRIGGER e03_311_01_tr AFTER INSERT ON e01_201_02_tb WHEN NEW.value_kind = 'text' AND NEW.text_val IS NOT NULL AND NEW.text_norm IS NULL
BEGIN UPDATE e01_201_02_tb SET text_norm = lower(trim(NEW.text_val)) WHERE val_id = NEW.val_id; END;
CREATE TRIGGER e03_311_02_tr AFTER UPDATE OF text_val ON e01_201_02_tb WHEN NEW.value_kind = 'text' AND NEW.text_val IS NOT NULL AND (NEW.text_norm IS NULL OR NEW.text_norm <> lower(trim(NEW.text_val)))
BEGIN UPDATE e01_201_02_tb SET text_norm = lower(trim(NEW.text_val)) WHERE val_id = NEW.val_id; END;
CREATE TRIGGER e03_311_03_tr BEFORE INSERT ON e01_201_03_tb WHEN NEW.member_val_id IS NOT NULL
BEGIN SELECT CASE WHEN EXISTS (WITH RECURSIVE desc_of_parent(id, depth) AS (
    SELECT NEW.parent_id, 0
    UNION ALL
    SELECT e.member_val_id, desc_of_parent.depth + 1 FROM e01_201_03_tb e
    JOIN desc_of_parent ON e.parent_id = desc_of_parent.id
    WHERE e.member_val_id IS NOT NULL
      AND desc_of_parent.depth < (SELECT int_value FROM e01_676_03_tb WHERE param_uid='max_member_depth'))
    SELECT 1 FROM desc_of_parent WHERE id = NEW.member_val_id) THEN RAISE(ABORT, 'value member: cycle detected') END; END;
CREATE TRIGGER e03_311_04_tr BEFORE UPDATE OF parent_id, member_val_id ON e01_201_03_tb WHEN NEW.member_val_id IS NOT NULL
BEGIN SELECT CASE WHEN EXISTS (WITH RECURSIVE desc_of_parent(id, depth) AS (
    SELECT NEW.parent_id, 0
    UNION ALL
    SELECT e.member_val_id, desc_of_parent.depth + 1 FROM e01_201_03_tb e
    JOIN desc_of_parent ON e.parent_id = desc_of_parent.id
    WHERE e.member_val_id IS NOT NULL AND e.memb_id <> NEW.memb_id
      AND desc_of_parent.depth < (SELECT int_value FROM e01_676_03_tb WHERE param_uid='max_member_depth'))
    SELECT 1 FROM desc_of_parent WHERE id = NEW.member_val_id) THEN RAISE(ABORT, 'value member: cycle detected (upd)') END; END;
CREATE TRIGGER e03_516_01_tr BEFORE INSERT ON e01_506_06_tb WHEN NEW.parent_id IS NOT NULL
BEGIN SELECT CASE WHEN NOT EXISTS (SELECT 1 FROM e01_506_06_tb p WHERE p.node_id = NEW.parent_id AND p.need_uid = NEW.need_uid) THEN RAISE(ABORT, 'node parent belongs to another need') END; END;
CREATE TRIGGER e03_516_02_tr BEFORE UPDATE OF need_uid, parent_id ON e01_506_06_tb WHEN NEW.parent_id IS NOT NULL
BEGIN SELECT CASE WHEN NOT EXISTS (SELECT 1 FROM e01_506_06_tb p WHERE p.node_id = NEW.parent_id AND p.need_uid = NEW.need_uid) THEN RAISE(ABORT, 'node parent belongs to another need') END; END;
CREATE TRIGGER e03_126_01_tr BEFORE UPDATE OF parent_id ON e01_506_06_tb WHEN NEW.parent_id IS NOT NULL AND NEW.parent_id <> NEW.node_id
BEGIN SELECT CASE WHEN EXISTS (WITH RECURSIVE up(id) AS (SELECT NEW.parent_id UNION SELECT parent_id FROM e01_506_06_tb JOIN up ON e01_506_06_tb.node_id = up.id WHERE parent_id IS NOT NULL) SELECT 1 FROM up WHERE id = NEW.node_id) THEN RAISE(ABORT, 'node cycle detected') END; END;
CREATE TRIGGER e03_126_02_tr BEFORE INSERT ON e01_506_05_tb WHEN NEW.parent_uid = NEW.question_uid
BEGIN SELECT RAISE(ABORT, 'question self-cycle'); END;
CREATE TRIGGER e03_126_03_tr BEFORE UPDATE OF parent_uid ON e01_506_05_tb WHEN NEW.parent_uid IS NOT NULL
BEGIN
  SELECT CASE WHEN NEW.parent_uid = NEW.question_uid THEN RAISE(ABORT, 'question self-cycle (upd)') END;
  SELECT CASE WHEN EXISTS (WITH RECURSIVE up(uid) AS (SELECT NEW.parent_uid UNION SELECT parent_uid FROM e01_506_05_tb JOIN up ON e01_506_05_tb.question_uid = up.uid WHERE parent_uid IS NOT NULL) SELECT 1 FROM up WHERE uid = NEW.question_uid) THEN RAISE(ABORT, 'question cycle detected') END;
END;
CREATE TRIGGER e03_320_01_tr BEFORE DELETE ON e01_200_03_tb
BEGIN SELECT CASE WHEN EXISTS (
  SELECT 1 FROM e01_201_03_tb WHERE member_ent_id = OLD.ent_id
  UNION ALL SELECT 1 FROM e01_302_01_tb WHERE subj_ent_id = OLD.ent_id
  UNION ALL SELECT 1 FROM e01_222_01_tb WHERE subj_ent_id = OLD.ent_id
  UNION ALL SELECT 1 FROM e01_222_01_tb WHERE obj_ent_id = OLD.ent_id
  UNION ALL SELECT 1 FROM e01_222_01_tb WHERE reif_ent_id = OLD.ent_id
  UNION ALL SELECT 1 FROM e01_305_01_tb WHERE ent_id = OLD.ent_id OR ctx_ent_id = OLD.ent_id
  UNION ALL SELECT 1 FROM e01_305_02_tb WHERE ctx_ent_id = OLD.ent_id
  UNION ALL SELECT 1 FROM e01_305_03_tb WHERE ctx_ent_id = OLD.ent_id
  UNION ALL SELECT 1 FROM e01_300_01_tb WHERE ent_a_id = OLD.ent_id OR ent_b_id = OLD.ent_id
  UNION ALL SELECT 1 FROM e01_330_01_tb WHERE ent_id = OLD.ent_id OR approved_by_id = OLD.ent_id
  UNION ALL SELECT 1 FROM e01_330_02_tb WHERE ent_id = OLD.ent_id)
  THEN RAISE(ABORT, 'entity referenced; retract or archive first') END; END;
CREATE TRIGGER e03_320_02_tr BEFORE DELETE ON e01_201_02_tb
BEGIN SELECT CASE WHEN EXISTS (
  SELECT 1 FROM e01_222_01_tb WHERE obj_val_id = OLD.val_id
  UNION ALL SELECT 1 FROM e01_201_03_tb WHERE parent_id = OLD.val_id OR member_val_id = OLD.val_id
  UNION ALL SELECT 1 FROM e01_305_01_tb WHERE ctx_val_id = OLD.val_id
  UNION ALL SELECT 1 FROM e01_305_02_tb WHERE val_id = OLD.val_id OR ctx_val_id = OLD.val_id
  UNION ALL SELECT 1 FROM e01_305_03_tb WHERE ctx_val_id = OLD.val_id)
  THEN RAISE(ABORT, 'value referenced; retract or cascade first') END; END;
CREATE TRIGGER e03_320_03_tr BEFORE DELETE ON e01_200_01_tb
BEGIN SELECT CASE WHEN EXISTS (
  SELECT 1 FROM e01_200_01_tb WHERE parent_id = OLD.type_id
  UNION ALL SELECT 1 FROM e01_200_03_tb WHERE type_id = OLD.type_id
  UNION ALL SELECT 1 FROM e01_112_01_tb WHERE target_type_id = OLD.type_id
  UNION ALL SELECT 1 FROM e01_120_01_tb WHERE desc_id = OLD.type_id OR anc_id = OLD.type_id)
  THEN RAISE(ABORT, 'entity type referenced') END; END;
CREATE TRIGGER e03_320_04_tr BEFORE DELETE ON e01_202_01_tb
BEGIN SELECT CASE WHEN EXISTS (
  SELECT 1 FROM e01_222_01_tb WHERE reltype_id = OLD.reltype_id
  UNION ALL SELECT 1 FROM e01_302_01_tb WHERE reltype_id = OLD.reltype_id
  UNION ALL SELECT 1 FROM e01_112_01_tb WHERE reltype_id = OLD.reltype_id
  UNION ALL SELECT 1 FROM e01_202_01_tb WHERE inverse_uid = OLD.type_uid)
  THEN RAISE(ABORT, 'relation type referenced') END; END;
CREATE TRIGGER e03_320_05_tr BEFORE DELETE ON e01_303_01_tb WHEN NOT (OLD.source_type = 'unknown' AND OLD.source_ref = 'system:unknown')
BEGIN SELECT CASE WHEN EXISTS (
  SELECT 1 FROM e01_200_03_tb WHERE prv_id = OLD.prv_id
  UNION ALL SELECT 1 FROM e01_201_02_tb WHERE prv_id = OLD.prv_id
  UNION ALL SELECT 1 FROM e01_222_01_tb WHERE prv_id = OLD.prv_id
  UNION ALL SELECT 1 FROM e01_305_01_tb WHERE prv_id = OLD.prv_id
  UNION ALL SELECT 1 FROM e01_305_02_tb WHERE prv_id = OLD.prv_id
  UNION ALL SELECT 1 FROM e01_305_03_tb WHERE prv_id = OLD.prv_id
  UNION ALL SELECT 1 FROM e01_300_01_tb WHERE prv_id = OLD.prv_id)
  THEN RAISE(ABORT, 'provenance referenced') END; END;
CREATE TRIGGER e03_320_06_tr BEFORE DELETE ON e01_302_01_tb
BEGIN SELECT CASE WHEN EXISTS (SELECT 1 FROM e01_222_01_tb WHERE lin_id = OLD.lin_id) THEN RAISE(ABORT, 'lineage referenced by relations') END; END;
CREATE TRIGGER e03_320_07_tr BEFORE DELETE ON e01_200_02_tb
BEGIN SELECT CASE WHEN EXISTS (SELECT 1 FROM e01_201_01_tb WHERE dom_id = OLD.dom_id) THEN RAISE(ABORT, 'enum domain has values') END; END;
CREATE TRIGGER e03_320_08_tr BEFORE DELETE ON e01_201_01_tb
BEGIN SELECT CASE WHEN EXISTS (SELECT 1 FROM e01_201_02_tb WHERE enum_id = OLD.val_id) THEN RAISE(ABORT, 'enum value referenced by values') END; END;
CREATE TRIGGER e03_320_09_tr BEFORE UPDATE OF type_id ON e01_200_03_tb WHEN OLD.type_id <> NEW.type_id
BEGIN
  SELECT CASE WHEN EXISTS (SELECT 1 FROM e01_222_01_tb r WHERE r.subj_ent_id = OLD.ent_id AND r.status = 'asserted' AND r.superseded_at IS NULL AND EXISTS (SELECT 1 FROM e01_112_01_tb c WHERE c.reltype_id = r.reltype_id AND c.cons_kind = 'allowed_subject_type') AND NOT EXISTS (SELECT 1 FROM e01_112_01_tb c JOIN e01_120_01_tb cl ON cl.anc_id = c.target_type_id WHERE c.reltype_id = r.reltype_id AND c.cons_kind = 'allowed_subject_type' AND cl.desc_id = NEW.type_id)) THEN RAISE(ABORT, 'cannot change type: violates active subject domain') END;
  SELECT CASE WHEN EXISTS (SELECT 1 FROM e01_222_01_tb r WHERE r.obj_ent_id = OLD.ent_id AND r.status = 'asserted' AND r.superseded_at IS NULL AND EXISTS (SELECT 1 FROM e01_112_01_tb c WHERE c.reltype_id = r.reltype_id AND c.cons_kind = 'allowed_object_type') AND NOT EXISTS (SELECT 1 FROM e01_112_01_tb c JOIN e01_120_01_tb cl ON cl.anc_id = c.target_type_id WHERE c.reltype_id = r.reltype_id AND c.cons_kind = 'allowed_object_type' AND cl.desc_id = NEW.type_id)) THEN RAISE(ABORT, 'cannot change type: violates active object domain') END;
  SELECT CASE WHEN EXISTS (SELECT 1 FROM e01_222_01_tb r WHERE r.reif_ent_id = OLD.ent_id AND r.reif_type <> 'none' AND r.status = 'asserted' AND r.superseded_at IS NULL AND NOT EXISTS (SELECT 1 FROM e01_200_01_tb et WHERE et.type_id = NEW.type_id AND et.type_uid IN ('ReifiedRelation','Evidence','Observation','Measurement','Claim','Hypothesis','Diagnosis'))) THEN RAISE(ABORT, 'cannot change type: invalidates reification') END;
END;
CREATE TRIGGER e03_370_30_tr BEFORE DELETE ON e01_778_01_tb
BEGIN SELECT CASE WHEN EXISTS (SELECT 1 FROM e01_778_01_tb WHERE parent_code = OLD.code UNION ALL SELECT 1 FROM e01_778_02_tb WHERE code = OLD.code) THEN RAISE(ABORT, 'req_code referenced') END; END;
CREATE TRIGGER e03_370_32_tr BEFORE UPDATE OF need_uid, code, code_kind ON e01_778_01_tb WHEN OLD.need_uid <> NEW.need_uid OR OLD.code <> NEW.code OR OLD.code_kind <> NEW.code_kind
BEGIN SELECT RAISE(ABORT, 'e01_778_01_tb PK is immutable'); END;
CREATE TRIGGER e03_370_34_tr BEFORE UPDATE OF chain_uid, ordinal ON e01_778_04_tb WHEN OLD.chain_uid <> NEW.chain_uid OR OLD.ordinal <> NEW.ordinal
BEGIN SELECT RAISE(ABORT, 'e01_778_04_tb PK is immutable'); END;
CREATE TRIGGER e03_360_01_tr AFTER UPDATE OF status ON e01_222_01_tb WHEN NEW.status = 'retracted' AND OLD.status <> 'retracted' AND NEW.reif_type = 'annotated' AND NEW.reif_ent_id IS NOT NULL
BEGIN UPDATE e01_200_03_tb SET status = 'archived' WHERE ent_id = NEW.reif_ent_id AND status = 'active'; END;
CREATE TRIGGER e03_370_02_tr BEFORE INSERT ON e01_506_03_tb
BEGIN SELECT CASE WHEN NEW.need_uid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM e01_506_01_tb WHERE need_uid = NEW.need_uid) THEN RAISE(ABORT, 'ele_stor: need does not exist') END; END;
CREATE TRIGGER e03_370_03_tr BEFORE INSERT ON e01_506_04_tb
BEGIN SELECT CASE WHEN NOT EXISTS (SELECT 1 FROM e01_506_02_tb WHERE atom_uid = NEW.atom_uid) THEN RAISE(ABORT, 'tra_stor: atom does not exist') END; SELECT CASE WHEN NOT EXISTS (SELECT 1 FROM e01_506_03_tb WHERE element_name = NEW.element_name) THEN RAISE(ABORT, 'tra_stor: element does not exist') END; END;
CREATE TRIGGER e03_370_04_tr BEFORE INSERT ON e01_506_08_tb
BEGIN SELECT CASE WHEN NOT EXISTS (SELECT 1 FROM e01_506_07_tb WHERE dim_uid = NEW.dim_uid) THEN RAISE(ABORT, 'dim_val: dim does not exist') END; END;
CREATE TRIGGER e03_370_05_tr BEFORE INSERT ON e01_506_06_tb
BEGIN SELECT CASE WHEN NOT EXISTS (SELECT 1 FROM e01_506_01_tb WHERE need_uid = NEW.need_uid) THEN RAISE(ABORT, 'nod_tree: need does not exist') END; SELECT CASE WHEN NEW.parent_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM e01_506_06_tb WHERE node_id = NEW.parent_id) THEN RAISE(ABORT, 'nod_tree: parent does not exist') END; SELECT CASE WHEN NOT EXISTS (SELECT 1 FROM e01_506_05_tb WHERE question_uid = NEW.question_uid) THEN RAISE(ABORT, 'nod_tree: question does not exist') END; END;
CREATE TRIGGER e03_370_06_tr BEFORE INSERT ON e01_506_05_tb
BEGIN SELECT CASE WHEN NEW.parent_uid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM e01_506_05_tb WHERE question_uid = NEW.parent_uid) THEN RAISE(ABORT, 'que_gram: parent does not exist') END; END;
CREATE TRIGGER e03_370_07_tr BEFORE INSERT ON e01_330_01_tb
BEGIN SELECT CASE WHEN NOT EXISTS (SELECT 1 FROM e01_200_03_tb WHERE ent_id = NEW.ent_id) THEN RAISE(ABORT, 'ent_vers: entity does not exist') END; SELECT CASE WHEN NEW.supersedes_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM e01_330_01_tb WHERE vers_id = NEW.supersedes_id) THEN RAISE(ABORT, 'ent_vers: supersedes does not exist') END; SELECT CASE WHEN NEW.supersedes_id IS NOT NULL AND NEW.supersedes_id = NEW.vers_id THEN RAISE(ABORT, 'ent_vers: cannot supersede self') END; SELECT CASE WHEN NEW.supersedes_id IS NOT NULL AND (SELECT ent_id FROM e01_330_01_tb WHERE vers_id = NEW.supersedes_id) <> NEW.ent_id THEN RAISE(ABORT, 'ent_vers: supersedes cross-entity') END; SELECT CASE WHEN NEW.approved_by_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM e01_200_03_tb WHERE ent_id = NEW.approved_by_id) THEN RAISE(ABORT, 'ent_vers: approver does not exist') END; END;
CREATE TRIGGER e03_370_08_tr BEFORE INSERT ON e01_330_02_tb
BEGIN SELECT CASE WHEN NOT EXISTS (SELECT 1 FROM e01_200_03_tb WHERE ent_id = NEW.ent_id) THEN RAISE(ABORT, 'ent_snap: entity does not exist') END; SELECT CASE WHEN NEW.vers_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM e01_330_01_tb WHERE vers_id = NEW.vers_id) THEN RAISE(ABORT, 'ent_snap: vers does not exist') END; SELECT CASE WHEN NEW.vers_id IS NOT NULL AND (SELECT ent_id FROM e01_330_01_tb WHERE vers_id = NEW.vers_id) <> NEW.ent_id THEN RAISE(ABORT, 'ent_snap: vers cross-entity') END; END;
CREATE TRIGGER e03_370_12_tr BEFORE UPDATE OF need_uid ON e01_506_03_tb
BEGIN SELECT CASE WHEN NEW.need_uid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM e01_506_01_tb WHERE need_uid = NEW.need_uid) THEN RAISE(ABORT, 'ele_stor.upd: need does not exist') END; END;
CREATE TRIGGER e03_370_13_tr BEFORE UPDATE OF atom_uid, element_name ON e01_506_04_tb
BEGIN SELECT CASE WHEN NOT EXISTS (SELECT 1 FROM e01_506_02_tb WHERE atom_uid = NEW.atom_uid) THEN RAISE(ABORT, 'tra_stor.upd: atom does not exist') END; SELECT CASE WHEN NOT EXISTS (SELECT 1 FROM e01_506_03_tb WHERE element_name = NEW.element_name) THEN RAISE(ABORT, 'tra_stor.upd: element does not exist') END; END;
CREATE TRIGGER e03_370_15_tr BEFORE UPDATE OF need_uid, parent_id, question_uid ON e01_506_06_tb
BEGIN SELECT CASE WHEN NOT EXISTS (SELECT 1 FROM e01_506_01_tb WHERE need_uid = NEW.need_uid) THEN RAISE(ABORT, 'nod_tree.upd: need does not exist') END; SELECT CASE WHEN NEW.parent_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM e01_506_06_tb WHERE node_id = NEW.parent_id) THEN RAISE(ABORT, 'nod_tree.upd: parent does not exist') END; SELECT CASE WHEN NOT EXISTS (SELECT 1 FROM e01_506_05_tb WHERE question_uid = NEW.question_uid) THEN RAISE(ABORT, 'nod_tree.upd: question does not exist') END; END;
CREATE TRIGGER e03_370_16_tr BEFORE UPDATE OF parent_uid ON e01_506_05_tb
BEGIN SELECT CASE WHEN NEW.parent_uid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM e01_506_05_tb WHERE question_uid = NEW.parent_uid) THEN RAISE(ABORT, 'que_gram.upd: parent does not exist') END; END;
CREATE TRIGGER e03_370_17_tr BEFORE UPDATE OF ent_id, supersedes_id, approved_by_id ON e01_330_01_tb
BEGIN
  SELECT CASE WHEN NOT EXISTS (SELECT 1 FROM e01_200_03_tb WHERE ent_id = NEW.ent_id) THEN RAISE(ABORT, 'ent_vers.upd: entity does not exist') END;
  SELECT CASE WHEN NEW.supersedes_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM e01_330_01_tb WHERE vers_id = NEW.supersedes_id) THEN RAISE(ABORT, 'ent_vers.upd: supersedes does not exist') END;
  SELECT CASE WHEN NEW.supersedes_id IS NOT NULL AND NEW.supersedes_id = NEW.vers_id THEN RAISE(ABORT, 'ent_vers.upd: cannot supersede self') END;
  SELECT CASE WHEN NEW.supersedes_id IS NOT NULL AND (SELECT ent_id FROM e01_330_01_tb WHERE vers_id = NEW.supersedes_id) <> NEW.ent_id THEN RAISE(ABORT, 'ent_vers.upd: supersedes cross-entity') END;
  SELECT CASE WHEN NEW.supersedes_id IS NOT NULL AND EXISTS (WITH RECURSIVE chain(vid, depth) AS (SELECT NEW.supersedes_id, 0 UNION ALL SELECT v.supersedes_id, chain.depth + 1 FROM e01_330_01_tb v JOIN chain ON v.vers_id = chain.vid WHERE v.supersedes_id IS NOT NULL AND chain.depth < (SELECT int_value FROM e01_676_03_tb WHERE param_uid='max_version_depth')) SELECT 1 FROM chain WHERE vid = NEW.vers_id) THEN RAISE(ABORT, 'ent_vers.upd: supersedes chain cycle') END;
  SELECT CASE WHEN NEW.approved_by_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM e01_200_03_tb WHERE ent_id = NEW.approved_by_id) THEN RAISE(ABORT, 'ent_vers.upd: approver does not exist') END;
END;
CREATE TRIGGER e03_370_18_tr BEFORE UPDATE OF ent_id, vers_id ON e01_330_02_tb
BEGIN SELECT CASE WHEN NOT EXISTS (SELECT 1 FROM e01_200_03_tb WHERE ent_id = NEW.ent_id) THEN RAISE(ABORT, 'ent_snap.upd: entity does not exist') END; SELECT CASE WHEN NEW.vers_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM e01_330_01_tb WHERE vers_id = NEW.vers_id) THEN RAISE(ABORT, 'ent_snap.upd: vers does not exist') END; SELECT CASE WHEN NEW.vers_id IS NOT NULL AND (SELECT ent_id FROM e01_330_01_tb WHERE vers_id = NEW.vers_id) <> NEW.ent_id THEN RAISE(ABORT, 'ent_snap.upd: vers cross-entity') END; END;
CREATE TRIGGER e03_370_21_tr BEFORE DELETE ON e01_506_01_tb
BEGIN SELECT CASE WHEN EXISTS (SELECT 1 FROM e01_516_01_tb WHERE need_uid = OLD.need_uid UNION ALL SELECT 1 FROM e01_506_06_tb WHERE need_uid = OLD.need_uid UNION ALL SELECT 1 FROM e01_506_03_tb WHERE need_uid = OLD.need_uid UNION ALL SELECT 1 FROM e01_778_01_tb WHERE need_uid = OLD.need_uid UNION ALL SELECT 1 FROM e01_778_02_tb WHERE need_uid = OLD.need_uid UNION ALL SELECT 1 FROM e01_778_03_tb WHERE root_need_uid = OLD.need_uid UNION ALL SELECT 1 FROM e01_778_04_tb WHERE need_uid = OLD.need_uid) THEN RAISE(ABORT, 'nee_stor referenced; use status=deferred/dropped') END; END;
CREATE TRIGGER e03_370_22_tr BEFORE DELETE ON e01_506_02_tb
BEGIN SELECT CASE WHEN EXISTS (SELECT 1 FROM e01_516_01_tb WHERE atom_uid = OLD.atom_uid UNION ALL SELECT 1 FROM e01_506_04_tb WHERE atom_uid = OLD.atom_uid) THEN RAISE(ABORT, 'req_stor referenced; use status=deferred/dropped') END; END;
CREATE TRIGGER e03_370_23_tr BEFORE DELETE ON e01_506_03_tb
BEGIN SELECT CASE WHEN EXISTS (SELECT 1 FROM e01_506_04_tb WHERE element_name = OLD.element_name UNION ALL SELECT 1 FROM e01_778_02_tb WHERE element_name = OLD.element_name UNION ALL SELECT 1 FROM e01_778_04_tb WHERE element_name = OLD.element_name) THEN RAISE(ABORT, 'ele_stor referenced') END; END;
CREATE TRIGGER e03_370_24_tr BEFORE DELETE ON e01_506_07_tb
BEGIN SELECT CASE WHEN EXISTS (SELECT 1 FROM e01_506_08_tb WHERE dim_uid = OLD.dim_uid) THEN RAISE(ABORT, 'dim_stor referenced') END; END;
CREATE TRIGGER e03_370_25_tr BEFORE DELETE ON e01_506_05_tb
BEGIN SELECT CASE WHEN EXISTS (SELECT 1 FROM e01_506_05_tb WHERE parent_uid = OLD.question_uid UNION ALL SELECT 1 FROM e01_506_06_tb WHERE question_uid = OLD.question_uid) THEN RAISE(ABORT, 'que_gram referenced') END; END;
CREATE TRIGGER e03_370_26_tr BEFORE DELETE ON e01_330_01_tb
BEGIN SELECT CASE WHEN EXISTS (SELECT 1 FROM e01_330_01_tb WHERE supersedes_id = OLD.vers_id UNION ALL SELECT 1 FROM e01_330_02_tb WHERE vers_id = OLD.vers_id) THEN RAISE(ABORT, 'ent_vers referenced; use status=deprecated') END; END;
CREATE TRIGGER e03_310_03_tr BEFORE INSERT ON e01_201_02_tb
BEGIN SELECT CASE WHEN NEW.enum_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM e01_201_01_tb WHERE val_id = NEW.enum_id) THEN RAISE(ABORT, 'enum value does not exist') END; END;
CREATE TRIGGER e03_310_04_tr BEFORE UPDATE OF enum_id ON e01_201_02_tb
BEGIN SELECT CASE WHEN NEW.enum_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM e01_201_01_tb WHERE val_id = NEW.enum_id) THEN RAISE(ABORT, 'enum value does not exist (upd)') END; END;
CREATE TRIGGER e03_310_05_tr BEFORE INSERT ON e01_201_03_tb
BEGIN SELECT CASE WHEN NOT EXISTS (SELECT 1 FROM e01_201_02_tb WHERE val_id = NEW.parent_id) THEN RAISE(ABORT, 'val_memb: parent does not exist') END; SELECT CASE WHEN NEW.member_val_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM e01_201_02_tb WHERE val_id = NEW.member_val_id) THEN RAISE(ABORT, 'val_memb: member_val does not exist') END; SELECT CASE WHEN NEW.member_ent_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM e01_200_03_tb WHERE ent_id = NEW.member_ent_id) THEN RAISE(ABORT, 'val_memb: member_ent does not exist') END; END;
CREATE TRIGGER e03_310_06_tr BEFORE UPDATE OF parent_id, member_val_id, member_ent_id ON e01_201_03_tb
BEGIN SELECT CASE WHEN NOT EXISTS (SELECT 1 FROM e01_201_02_tb WHERE val_id = NEW.parent_id) THEN RAISE(ABORT, 'val_memb.upd: parent does not exist') END; SELECT CASE WHEN NEW.member_val_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM e01_201_02_tb WHERE val_id = NEW.member_val_id) THEN RAISE(ABORT, 'val_memb.upd: member_val does not exist') END; SELECT CASE WHEN NEW.member_ent_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM e01_200_03_tb WHERE ent_id = NEW.member_ent_id) THEN RAISE(ABORT, 'val_memb.upd: member_ent does not exist') END; END;
CREATE TRIGGER e03_328_01_tr BEFORE UPDATE OF need_uid ON e01_506_01_tb WHEN OLD.need_uid <> NEW.need_uid BEGIN SELECT RAISE(ABORT, 'e01_506_01_tb.need_uid is immutable'); END;
CREATE TRIGGER e03_328_02_tr BEFORE UPDATE OF atom_uid ON e01_506_02_tb WHEN OLD.atom_uid <> NEW.atom_uid BEGIN SELECT RAISE(ABORT, 'e01_506_02_tb.atom_uid is immutable'); END;
CREATE TRIGGER e03_328_04_tr BEFORE UPDATE OF element_name ON e01_506_03_tb WHEN OLD.element_name <> NEW.element_name BEGIN SELECT RAISE(ABORT, 'e01_506_03_tb.element_name is immutable'); END;
CREATE TRIGGER e03_328_05_tr BEFORE UPDATE OF trace_id ON e01_506_04_tb WHEN OLD.trace_id <> NEW.trace_id BEGIN SELECT RAISE(ABORT, 'e01_506_04_tb.trace_id is immutable'); END;
CREATE TRIGGER e03_328_06_tr BEFORE UPDATE OF question_uid ON e01_506_05_tb WHEN OLD.question_uid <> NEW.question_uid BEGIN SELECT RAISE(ABORT, 'e01_506_05_tb.question_uid is immutable'); END;
CREATE TRIGGER e03_328_07_tr BEFORE UPDATE OF node_id ON e01_506_06_tb WHEN OLD.node_id <> NEW.node_id BEGIN SELECT RAISE(ABORT, 'e01_506_06_tb.node_id is immutable'); END;
CREATE TRIGGER e03_328_08_tr BEFORE UPDATE OF migration_uid ON e01_676_01_tb WHEN OLD.migration_uid <> NEW.migration_uid BEGIN SELECT RAISE(ABORT, 'e01_676_01_tb.migration_uid is immutable'); END;
CREATE TRIGGER e03_328_09_tr BEFORE UPDATE OF id ON e01_676_02_tb WHEN OLD.id <> NEW.id BEGIN SELECT RAISE(ABORT, 'e01_676_02_tb.id is immutable'); END;
CREATE TRIGGER e03_328_10_tr BEFORE UPDATE OF ref_id ON e01_378_01_tb WHEN OLD.ref_id <> NEW.ref_id BEGIN SELECT RAISE(ABORT, 'e01_378_01_tb.ref_id is immutable'); END;
CREATE TRIGGER e03_328_11_tr BEFORE UPDATE OF dim_uid ON e01_506_07_tb WHEN OLD.dim_uid <> NEW.dim_uid BEGIN SELECT RAISE(ABORT, 'e01_506_07_tb.dim_uid is immutable'); END;
CREATE TRIGGER e03_328_12_tr BEFORE UPDATE OF value_id ON e01_506_08_tb WHEN OLD.value_id <> NEW.value_id BEGIN SELECT RAISE(ABORT, 'e01_506_08_tb.value_id is immutable'); END;
CREATE TRIGGER e03_328_13_tr BEFORE UPDATE OF type_id ON e01_200_01_tb WHEN OLD.type_id <> NEW.type_id BEGIN SELECT RAISE(ABORT, 'e01_200_01_tb.type_id is immutable'); END;
CREATE TRIGGER e03_328_14_tr BEFORE UPDATE OF desc_id, anc_id ON e01_120_01_tb WHEN OLD.desc_id <> NEW.desc_id OR OLD.anc_id <> NEW.anc_id BEGIN SELECT RAISE(ABORT, 'e01_120_01_tb PK is immutable'); END;
CREATE TRIGGER e03_328_15_tr BEFORE UPDATE OF reltype_id ON e01_202_01_tb WHEN OLD.reltype_id <> NEW.reltype_id BEGIN SELECT RAISE(ABORT, 'e01_202_01_tb.reltype_id is immutable'); END;
CREATE TRIGGER e03_328_16_tr BEFORE UPDATE OF cons_id ON e01_112_01_tb WHEN OLD.cons_id <> NEW.cons_id BEGIN SELECT RAISE(ABORT, 'e01_112_01_tb.cons_id is immutable'); END;
CREATE TRIGGER e03_328_17_tr BEFORE UPDATE OF dom_id ON e01_200_02_tb WHEN OLD.dom_id <> NEW.dom_id BEGIN SELECT RAISE(ABORT, 'e01_200_02_tb.dom_id is immutable'); END;
CREATE TRIGGER e03_328_18_tr BEFORE UPDATE OF val_id ON e01_201_01_tb WHEN OLD.val_id <> NEW.val_id BEGIN SELECT RAISE(ABORT, 'e01_201_01_tb.val_id is immutable'); END;
CREATE TRIGGER e03_328_19_tr BEFORE UPDATE OF prv_id ON e01_303_01_tb WHEN OLD.prv_id <> NEW.prv_id BEGIN SELECT RAISE(ABORT, 'e01_303_01_tb.prv_id is immutable'); END;
CREATE TRIGGER e03_328_20_tr BEFORE UPDATE OF ent_id ON e01_200_03_tb WHEN OLD.ent_id <> NEW.ent_id BEGIN SELECT RAISE(ABORT, 'e01_200_03_tb.ent_id is immutable'); END;
CREATE TRIGGER e03_328_21_tr BEFORE UPDATE OF val_id ON e01_201_02_tb WHEN OLD.val_id <> NEW.val_id BEGIN SELECT RAISE(ABORT, 'e01_201_02_tb.val_id is immutable'); END;
CREATE TRIGGER e03_328_22_tr BEFORE UPDATE OF memb_id ON e01_201_03_tb WHEN OLD.memb_id <> NEW.memb_id BEGIN SELECT RAISE(ABORT, 'e01_201_03_tb.memb_id is immutable'); END;
CREATE TRIGGER e03_328_23_tr BEFORE UPDATE OF lin_id ON e01_302_01_tb WHEN OLD.lin_id <> NEW.lin_id BEGIN SELECT RAISE(ABORT, 'e01_302_01_tb.lin_id is immutable'); END;
CREATE TRIGGER e03_328_24_tr BEFORE UPDATE OF rel_id ON e01_222_01_tb WHEN OLD.rel_id <> NEW.rel_id BEGIN SELECT RAISE(ABORT, 'e01_222_01_tb.rel_id is immutable'); END;
CREATE TRIGGER e03_328_25_tr BEFORE UPDATE OF ctx_id ON e01_305_01_tb WHEN OLD.ctx_id <> NEW.ctx_id BEGIN SELECT RAISE(ABORT, 'e01_305_01_tb.ctx_id is immutable'); END;
CREATE TRIGGER e03_328_26_tr BEFORE UPDATE OF ctx_id ON e01_305_02_tb WHEN OLD.ctx_id <> NEW.ctx_id BEGIN SELECT RAISE(ABORT, 'e01_305_02_tb.ctx_id is immutable'); END;
CREATE TRIGGER e03_328_27_tr BEFORE UPDATE OF ctx_id ON e01_305_03_tb WHEN OLD.ctx_id <> NEW.ctx_id BEGIN SELECT RAISE(ABORT, 'e01_305_03_tb.ctx_id is immutable'); END;
CREATE TRIGGER e03_328_28_tr BEFORE UPDATE OF clm_id ON e01_300_01_tb WHEN OLD.clm_id <> NEW.clm_id BEGIN SELECT RAISE(ABORT, 'e01_300_01_tb.clm_id is immutable'); END;
CREATE TRIGGER e03_328_29_tr BEFORE UPDATE OF vers_id ON e01_330_01_tb WHEN OLD.vers_id <> NEW.vers_id BEGIN SELECT RAISE(ABORT, 'e01_330_01_tb.vers_id is immutable'); END;
CREATE TRIGGER e03_328_30_tr BEFORE UPDATE OF snap_id ON e01_330_02_tb WHEN OLD.snap_id <> NEW.snap_id BEGIN SELECT RAISE(ABORT, 'e01_330_02_tb.snap_id is immutable'); END;
CREATE TRIGGER e03_328_31_tr BEFORE UPDATE OF source_type, source_ref ON e01_303_01_tb WHEN OLD.source_type = 'unknown' AND OLD.source_ref = 'system:unknown' AND (NEW.source_type <> 'unknown' OR NEW.source_ref <> 'system:unknown') BEGIN SELECT RAISE(ABORT, 'fallback provenance identity is immutable'); END;
CREATE TRIGGER e03_328_32_tr BEFORE DELETE ON e01_676_02_tb BEGIN SELECT RAISE(ABORT, 'schema state row cannot be deleted'); END;
CREATE TRIGGER e03_328_33_tr BEFORE UPDATE OF verb_code ON e01_506_09_tb WHEN OLD.verb_code <> NEW.verb_code BEGIN SELECT RAISE(ABORT, 'e01_506_09_tb.verb_code is immutable'); END;
CREATE TRIGGER e03_328_34_tr BEFORE UPDATE OF entity_code ON e01_506_10_tb WHEN OLD.entity_code <> NEW.entity_code BEGIN SELECT RAISE(ABORT, 'e01_506_10_tb.entity_code is immutable'); END;
CREATE TRIGGER e03_328_35_tr BEFORE UPDATE OF constraint_code ON e01_506_11_tb WHEN OLD.constraint_code <> NEW.constraint_code BEGIN SELECT RAISE(ABORT, 'e01_506_11_tb.constraint_code is immutable'); END;
CREATE TRIGGER e03_328_36_tr BEFORE UPDATE OF schema_ver ON e01_676_02_tb WHEN NEW.schema_ver < OLD.schema_ver BEGIN SELECT RAISE(ABORT, 'schema_ver cannot decrease'); END;
CREATE TRIGGER e03_328_37_tr BEFORE UPDATE OF param_uid ON e01_676_03_tb WHEN OLD.param_uid <> NEW.param_uid BEGIN SELECT RAISE(ABORT, 'e01_676_03_tb.param_uid is immutable'); END;
CREATE VIEW e04_200_01_vw AS SELECT 'entity_type' AS node_kind, type_id AS node_id, type_uid, label, description FROM e01_200_01_tb UNION ALL SELECT 'relation_type', reltype_id, type_uid, label, description FROM e01_202_01_tb UNION ALL SELECT 'enum_domain', dom_id, dom_uid, label, description FROM e01_200_02_tb
/* e04_200_01_vw(node_kind,node_id,type_uid,label,description) */;
CREATE VIEW e04_230_01_vw AS SELECT ent_id, ent_uid, type_id, label, description, status FROM e01_200_03_tb WHERE nature = 'concept'
/* e04_230_01_vw(ent_id,ent_uid,type_id,label,description,status) */;
CREATE VIEW e04_230_02_vw AS SELECT ent_id, ent_uid, type_id, label, description, status FROM e01_200_03_tb WHERE nature = 'instance'
/* e04_230_02_vw(ent_id,ent_uid,type_id,label,description,status) */;
CREATE VIEW e04_340_01_vw AS SELECT * FROM e01_222_01_tb WHERE superseded_at IS NULL
/* e04_340_01_vw(rel_id,rel_uid,lin_id,ctx_key,reif_type,reltype_id,subj_ent_id,obj_ent_id,obj_val_id,reif_ent_id,status,prv_id,valid_from,valid_to,recorded_at,superseded_at,ordinal) */;
CREATE VIEW e04_340_02_vw AS SELECT * FROM e01_222_01_tb WHERE superseded_at IS NULL AND status = 'asserted'
/* e04_340_02_vw(rel_id,rel_uid,lin_id,ctx_key,reif_type,reltype_id,subj_ent_id,obj_ent_id,obj_val_id,reif_ent_id,status,prv_id,valid_from,valid_to,recorded_at,superseded_at,ordinal) */;
CREATE VIEW e04_340_04_vw AS SELECT r.lin_id, r.rel_uid, r.subj_ent_id, r.reltype_id, r.valid_from, r.valid_to, r.recorded_at, r.superseded_at, r.status, CASE WHEN r.superseded_at IS NULL THEN 1 ELSE 0 END AS is_current FROM e01_222_01_tb r
/* e04_340_04_vw(lin_id,rel_uid,subj_ent_id,reltype_id,valid_from,valid_to,recorded_at,superseded_at,status,is_current) */;
CREATE VIEW e04_325_01_vw AS SELECT 'entity' AS tgt_kind, ctx_id AS qual_id, ent_id AS tgt_id, ctx_ent_id, ctx_val_id, role, valid_from, valid_to, prv_id FROM e01_305_01_tb UNION ALL SELECT 'value', ctx_id, val_id, ctx_ent_id, ctx_val_id, role, valid_from, valid_to, prv_id FROM e01_305_02_tb UNION ALL SELECT 'relation', ctx_id, rel_id, ctx_ent_id, ctx_val_id, role, valid_from, valid_to, prv_id FROM e01_305_03_tb
/* e04_325_01_vw(tgt_kind,qual_id,tgt_id,ctx_ent_id,ctx_val_id,role,valid_from,valid_to,prv_id) */;
CREATE VIEW e04_310_01_vw AS SELECT DISTINCT a.ent_a_id, a.ent_b_id FROM e01_300_01_tb a JOIN e01_300_01_tb b ON a.ent_a_id = b.ent_a_id AND a.ent_b_id = b.ent_b_id AND a.clm_type = 'same_as' AND b.clm_type = 'distinct_from' WHERE a.status = 'asserted' AND b.status = 'asserted'
/* e04_310_01_vw(ent_a_id,ent_b_id) */;
CREATE VIEW e04_311_01_vw AS SELECT v.val_id, v.value_kind, 'absence_kind_with_payload' AS violation_kind FROM e01_201_02_tb v WHERE v.value_kind IN ('unknown','not_observed','not_recorded','not_applicable') AND (v.num_val IS NOT NULL OR v.text_val IS NOT NULL OR v.text_norm IS NOT NULL OR v.bool_val IS NOT NULL OR v.dt_start IS NOT NULL OR v.dt_end IS NOT NULL OR v.num_min IS NOT NULL OR v.num_max IS NOT NULL OR v.enum_id IS NOT NULL OR v.json_val IS NOT NULL)
/* e04_311_01_vw(val_id,value_kind,violation_kind) */;
CREATE VIEW e04_122_01_vw AS WITH RECURSIVE cl(sub_id, anc_id) AS (SELECT r.subj_ent_id, r.obj_ent_id FROM e01_222_01_tb r JOIN e01_202_01_tb rt ON rt.reltype_id = r.reltype_id WHERE rt.type_uid = 'is_a' AND r.superseded_at IS NULL AND r.status = 'asserted' UNION SELECT c.sub_id, r.obj_ent_id FROM cl c JOIN e01_222_01_tb r ON r.subj_ent_id = c.anc_id JOIN e01_202_01_tb rt ON rt.reltype_id = r.reltype_id WHERE rt.type_uid = 'is_a' AND r.superseded_at IS NULL AND r.status = 'asserted') SELECT * FROM cl
/* e04_122_01_vw(sub_id,anc_id) */;
CREATE VIEW e04_267_01_vw AS SELECT v.ent_id AS vehicle_entity_id, v.ent_uid, v.label AS vehicle_label, (SELECT vs.text_val FROM e01_222_01_tb r JOIN e01_202_01_tb rt ON rt.reltype_id = r.reltype_id JOIN e01_201_02_tb vs ON vs.val_id = r.obj_val_id WHERE r.subj_ent_id = v.ent_id AND rt.type_uid = 'has_vin' AND r.superseded_at IS NULL AND r.status = 'asserted' ORDER BY r.recorded_at DESC, r.rel_id DESC LIMIT 1) AS vin, (SELECT oe.label FROM e01_222_01_tb r JOIN e01_202_01_tb rt ON rt.reltype_id = r.reltype_id JOIN e01_200_03_tb oe ON oe.ent_id = r.obj_ent_id WHERE r.subj_ent_id = v.ent_id AND rt.type_uid = 'instance_of' AND r.superseded_at IS NULL AND r.status = 'asserted' ORDER BY r.recorded_at DESC, r.rel_id DESC LIMIT 1) AS model_label FROM e01_200_03_tb v JOIN e01_200_01_tb et ON et.type_id = v.type_id AND et.type_uid = 'Vehicle' WHERE v.nature = 'instance' AND v.status = 'active'
/* e04_267_01_vw(vehicle_entity_id,ent_uid,vehicle_label,vin,model_label) */;
CREATE VIEW e04_267_02_vw AS SELECT r.obj_ent_id AS vehicle_entity_id, r.subj_ent_id AS unit_entity_id, et.type_uid AS unit_type_uid, CASE WHEN et.type_uid = 'ECU' THEN 1 ELSE 0 END AS is_ecu FROM e01_222_01_tb r JOIN e01_202_01_tb rt ON rt.reltype_id = r.reltype_id AND rt.type_uid = 'installed_on' JOIN e01_200_03_tb u ON u.ent_id = r.subj_ent_id JOIN e01_200_01_tb et ON et.type_id = u.type_id WHERE r.superseded_at IS NULL AND r.status = 'asserted'
/* e04_267_02_vw(vehicle_entity_id,unit_entity_id,unit_type_uid,is_ecu) */;
CREATE VIEW e04_260_01_vw AS SELECT e.ent_id AS ecu_entity_id, e.ent_uid AS ecu_uid, e.label AS ecu_label, e.description AS ecu_description, e.status FROM e01_200_03_tb e JOIN e01_200_01_tb et ON et.type_id = e.type_id AND et.type_uid = 'ECU'
/* e04_260_01_vw(ecu_entity_id,ecu_uid,ecu_label,ecu_description,status) */;
CREATE VIEW e04_260_02_vw AS SELECT c.ent_id AS case_entity_id FROM e01_200_03_tb c JOIN e01_200_01_tb et ON et.type_id = c.type_id WHERE et.type_uid = 'Case'
/* e04_260_02_vw(case_entity_id) */;
CREATE VIEW e04_260_03_vw AS SELECT t.ent_id AS tech_entity_id, t.label AS tech_label, 0 AS cases_count FROM e01_200_03_tb t JOIN e01_200_01_tb et_t ON et_t.type_id = t.type_id AND et_t.type_uid = 'Technician' WHERE t.status = 'active'
/* e04_260_03_vw(tech_entity_id,tech_label,cases_count) */;
CREATE VIEW e04_110_01_vw AS WITH RECURSIVE expected(desc_id, anc_id, depth, path, cycle) AS (SELECT t.type_id, t.type_id, 0, ',' || CAST(t.type_id AS TEXT) || ',', 0 FROM e01_200_01_tb t UNION ALL SELECT e.desc_id, p.parent_id, e.depth + 1, e.path || CAST(p.parent_id AS TEXT) || ',', CASE WHEN instr(e.path, ',' || CAST(p.parent_id AS TEXT) || ',') > 0 THEN 1 ELSE 0 END FROM expected e JOIN e01_200_01_tb p ON p.type_id = e.anc_id WHERE e.cycle = 0 AND p.parent_id IS NOT NULL AND e.depth < 100), expected_rows AS (SELECT desc_id, anc_id, depth FROM expected WHERE cycle = 0), actual AS (SELECT desc_id, anc_id, depth, COUNT(*) AS n FROM e01_120_01_tb GROUP BY desc_id, anc_id, depth) SELECT 'missing_expected_row', e.desc_id FROM expected_rows e WHERE NOT EXISTS (SELECT 1 FROM actual a WHERE a.desc_id = e.desc_id AND a.anc_id = e.anc_id AND a.depth = e.depth) UNION ALL SELECT 'orphan_closure_row', cl.desc_id FROM e01_120_01_tb cl WHERE NOT EXISTS (SELECT 1 FROM e01_200_01_tb t WHERE t.type_id = cl.desc_id) OR NOT EXISTS (SELECT 1 FROM e01_200_01_tb t WHERE t.type_id = cl.anc_id) UNION ALL SELECT 'closure_cycle', cl.desc_id FROM e01_120_01_tb cl WHERE cl.desc_id = cl.anc_id AND cl.depth > 0
/* e04_110_01_vw("'missing_expected_row'",desc_id) */;
CREATE VIEW e04_110_02_vw AS SELECT 'T' AS layer, 'parent_self' AS violation_kind, t.type_id AS object_id, t.type_uid AS detail FROM e01_200_01_tb t WHERE t.parent_id = t.type_id UNION ALL SELECT 'T', 'parent_orphan', t.type_id, CAST(t.parent_id AS TEXT) FROM e01_200_01_tb t WHERE t.parent_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM e01_200_01_tb p WHERE p.type_id = t.parent_id) UNION ALL SELECT 'T', 'inverse_orphan', r.reltype_id, r.inverse_uid FROM e01_202_01_tb r WHERE r.inverse_uid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM e01_202_01_tb x WHERE x.type_uid = r.inverse_uid)
/* e04_110_02_vw(layer,violation_kind,object_id,detail) */;
CREATE VIEW e04_310_02_vw AS SELECT 'rel_subject' AS violation_kind, r.rel_id AS id, r.rel_uid AS uid FROM e01_222_01_tb r WHERE NOT EXISTS (SELECT 1 FROM e01_200_03_tb e WHERE e.ent_id = r.subj_ent_id) UNION ALL SELECT 'rel_object_ent', r.rel_id, r.rel_uid FROM e01_222_01_tb r WHERE r.obj_ent_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM e01_200_03_tb e WHERE e.ent_id = r.obj_ent_id) UNION ALL SELECT 'ent_type', e.ent_id, e.ent_uid FROM e01_200_03_tb e WHERE NOT EXISTS (SELECT 1 FROM e01_200_01_tb t WHERE t.type_id = e.type_id)
/* e04_310_02_vw(violation_kind,id,uid) */;
CREATE TRIGGER e03_778_13_tr BEFORE DELETE ON e01_778_05_tb
WHEN OLD.is_mandatory = 1
BEGIN
    SELECT CASE WHEN EXISTS (SELECT 1 FROM e01_778_02_tb m WHERE m.element_name = OLD.element_name AND m.need_uid = OLD.need_uid AND m.is_primary = 1 AND m.is_driving = 1)
        THEN RAISE(ABORT, 'policy: cannot delete mandatory policy of driving element') END;
END;
CREATE TRIGGER e03_778_10_tr BEFORE UPDATE OF policy_id ON e01_778_05_tb WHEN OLD.policy_id <> NEW.policy_id BEGIN SELECT RAISE(ABORT, 'policy_id immutable'); END;
CREATE TRIGGER e03_120_01_tr
BEFORE UPDATE OF parent_id ON e01_200_01_tb
WHEN NEW.parent_id IS NOT NULL AND NEW.parent_id <> NEW.type_id
BEGIN
    SELECT CASE WHEN EXISTS (
        SELECT 1 FROM e01_120_01_tb
        WHERE desc_id = NEW.parent_id AND anc_id = NEW.type_id
    ) THEN RAISE(ABORT, 'type hierarchy: cycle detected') END;
END;
CREATE TRIGGER e03_120_04_tr
BEFORE INSERT ON e01_200_03_tb
BEGIN
    SELECT CASE WHEN (SELECT type_id FROM e01_200_01_tb WHERE type_id=NEW.type_id) IS NULL
        THEN RAISE(ABORT, 'entity type does not exist') END;
    SELECT CASE WHEN NEW.nature = 'instance'
             AND (SELECT is_abstract FROM e01_200_01_tb WHERE type_id = NEW.type_id) = 1
        THEN RAISE(ABORT, 'cannot instantiate abstract type') END;
END;
CREATE TRIGGER e03_120_05_tr
BEFORE UPDATE OF type_id, nature ON e01_200_03_tb
BEGIN
    SELECT CASE WHEN (SELECT type_id FROM e01_200_01_tb WHERE type_id=NEW.type_id) IS NULL
        THEN RAISE(ABORT, 'entity type does not exist (upd)') END;
    SELECT CASE WHEN NEW.nature = 'instance'
             AND (SELECT is_abstract FROM e01_200_01_tb WHERE type_id = NEW.type_id) = 1
        THEN RAISE(ABORT, 'cannot reassign to abstract type') END;
END;
CREATE TRIGGER e03_122_01_tr
BEFORE INSERT ON e01_222_01_tb
WHEN NEW.reltype_id = (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='is_a')
 AND NEW.superseded_at IS NULL AND NEW.status = 'asserted'
BEGIN
    SELECT CASE WHEN NEW.subj_ent_id = NEW.obj_ent_id
        THEN RAISE(ABORT, 'is_a: self-reference not allowed') END;
    SELECT CASE WHEN EXISTS (
        WITH RECURSIVE anc(id, depth) AS (
            SELECT NEW.obj_ent_id, 0
            UNION ALL
            SELECT r.obj_ent_id, anc.depth + 1
            FROM e01_222_01_tb r
            JOIN e01_202_01_tb rt ON rt.reltype_id = r.reltype_id
            JOIN anc ON r.subj_ent_id = anc.id
            WHERE rt.type_uid = 'is_a'
              AND r.superseded_at IS NULL AND r.status = 'asserted'
              AND anc.depth < 50
        )
        SELECT 1 FROM anc WHERE id = NEW.subj_ent_id
    ) THEN RAISE(ABORT, 'is_a: cycle detected') END;
END;
CREATE TRIGGER e03_122_02_tr
BEFORE UPDATE OF subj_ent_id, obj_ent_id, reltype_id, status, superseded_at
ON e01_222_01_tb
WHEN NEW.reltype_id = (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='is_a')
 AND NEW.superseded_at IS NULL AND NEW.status = 'asserted'
BEGIN
    SELECT CASE WHEN NEW.subj_ent_id = NEW.obj_ent_id
        THEN RAISE(ABORT, 'is_a: self-reference (upd)') END;
    SELECT CASE WHEN EXISTS (
        WITH RECURSIVE anc(id, depth) AS (
            SELECT NEW.obj_ent_id, 0
            UNION ALL
            SELECT r.obj_ent_id, anc.depth + 1
            FROM e01_222_01_tb r
            JOIN e01_202_01_tb rt ON rt.reltype_id = r.reltype_id
            JOIN anc ON r.subj_ent_id = anc.id
            WHERE rt.type_uid = 'is_a'
              AND r.superseded_at IS NULL AND r.status = 'asserted'
              AND r.rel_id <> NEW.rel_id
              AND anc.depth < 50
        )
        SELECT 1 FROM anc WHERE id = NEW.subj_ent_id
    ) THEN RAISE(ABORT, 'is_a: cycle detected (upd)') END;
END;
CREATE VIEW e04_978_01_vw AS
SELECT 'M_fk' AS check_name, 0 AS has_violation, 'healthy' AS expectation
UNION ALL SELECT 'T_semantic', CASE WHEN EXISTS(SELECT 1 FROM e04_110_02_vw) THEN 1 ELSE 0 END, 'healthy'
UNION ALL SELECT 'C_orphan', CASE WHEN EXISTS(SELECT 1 FROM e04_310_02_vw) THEN 1 ELSE 0 END, 'healthy'
UNION ALL SELECT 'M_primary_unguarded',
  CASE WHEN EXISTS(
    SELECT 1 FROM e01_778_02_tb m
    WHERE m.is_primary = 1
      AND NOT EXISTS (SELECT 1 FROM e01_778_05_tb p
                      WHERE p.element_name = m.element_name
                        AND p.need_uid = m.need_uid
                        AND p.is_mandatory = 1)
  ) THEN 1 ELSE 0 END,
  'healthy'
UNION ALL SELECT 'M_fk_unanchored',
  CASE WHEN EXISTS(
    SELECT 1 FROM e01_378_01_tb f
    WHERE NOT EXISTS (SELECT 1 FROM e01_778_05_tb p
                      WHERE p.fk_ref_id = f.ref_id AND p.policy_kind = 'fk')
  ) THEN 1 ELSE 0 END,
  'healthy'
UNION ALL SELECT 'M_trigger_unanchored',
  CASE WHEN EXISTS(
    SELECT 1 FROM sqlite_master sm
    WHERE sm.type = 'trigger' AND sm.name LIKE 'e03\_%' ESCAPE '\'
      AND sm.name NOT LIKE 'e03\_778\_%' ESCAPE '\'
      AND NOT EXISTS (SELECT 1 FROM e01_778_05_tb p WHERE p.exec_name = sm.name)
  ) THEN 1 ELSE 0 END,
  'healthy'
UNION ALL SELECT 'M_policy_orphan',
  CASE WHEN EXISTS(
    SELECT 1 FROM e01_778_05_tb p
    WHERE NOT EXISTS (SELECT 1 FROM e01_778_02_tb m
                      WHERE m.element_name = p.element_name AND m.need_uid = p.need_uid)
  ) THEN 1 ELSE 0 END,
  'healthy'
UNION ALL SELECT 'M_ver',
  CASE WHEN (SELECT schema_ver FROM e01_676_02_tb WHERE id=1) >= 32 THEN 0 ELSE 1 END,
  'ver>=32'
UNION ALL SELECT 'M_policy_count',
  CASE WHEN (SELECT COUNT(*) FROM e01_778_05_tb) >= 170 THEN 0 ELSE 1 END,
  'count>=170'
/* e04_978_01_vw(check_name,has_violation,expectation) */;
CREATE TRIGGER e03_120_02_tr AFTER INSERT ON e01_200_01_tb
BEGIN
    INSERT INTO e01_120_01_tb (desc_id, anc_id, depth)
    VALUES (NEW.type_id, NEW.type_id, 0);
    INSERT INTO e01_120_01_tb (desc_id, anc_id, depth)
    SELECT NEW.type_id, anc_id, depth + 1
    FROM e01_120_01_tb
    WHERE desc_id = NEW.parent_id
      AND NEW.parent_id IS NOT NULL
      AND depth < (SELECT int_value FROM e01_676_03_tb WHERE param_uid='max_depth');
END;
CREATE TRIGGER e03_120_03_tr AFTER UPDATE OF parent_id ON e01_200_01_tb
WHEN OLD.parent_id IS NOT NEW.parent_id
BEGIN
    DELETE FROM e01_120_01_tb;
    INSERT INTO e01_120_01_tb (desc_id, anc_id, depth)
    WITH RECURSIVE walk(desc_id, anc_id, depth) AS (
        SELECT t.type_id, t.type_id, 0 FROM e01_200_01_tb t
        UNION
        SELECT w.desc_id, p.parent_id, w.depth + 1
        FROM walk w
        JOIN e01_200_01_tb p ON p.type_id = w.anc_id
        WHERE p.parent_id IS NOT NULL
          AND w.depth < (SELECT int_value FROM e01_676_03_tb WHERE param_uid='max_depth')
    )
    SELECT desc_id, anc_id, depth FROM walk;
END;
CREATE TRIGGER e03_434_01_tr AFTER INSERT ON e01_200_03_tb
BEGIN
    INSERT INTO e02_404_01_ft(rowid, label_norm, desc_norm)
    VALUES (NEW.ent_id, COALESCE(NEW.label_norm, lower(trim(NEW.label))), COALESCE(NEW.desc_norm, ''));
END;
CREATE TRIGGER e03_434_02_tr AFTER DELETE ON e01_200_03_tb
BEGIN
    INSERT INTO e02_404_01_ft(e02_404_01_ft, rowid, label_norm, desc_norm)
    VALUES ('delete', OLD.ent_id, COALESCE(OLD.label_norm, lower(trim(OLD.label))), COALESCE(OLD.desc_norm, ''));
END;
CREATE TRIGGER e03_434_03_tr AFTER UPDATE OF label_norm, desc_norm, label ON e01_200_03_tb
WHEN NEW.label_norm IS NOT OLD.label_norm
  OR NEW.desc_norm IS NOT OLD.desc_norm
  OR NEW.label IS NOT OLD.label
BEGIN
    INSERT INTO e02_404_01_ft(e02_404_01_ft, rowid, label_norm, desc_norm)
    VALUES ('delete', OLD.ent_id, COALESCE(OLD.label_norm, lower(trim(OLD.label))), COALESCE(OLD.desc_norm, ''));
    INSERT INTO e02_404_01_ft(rowid, label_norm, desc_norm)
    VALUES (NEW.ent_id, COALESCE(NEW.label_norm, lower(trim(NEW.label))), COALESCE(NEW.desc_norm, ''));
END;
CREATE TRIGGER e03_434_04_tr AFTER INSERT ON e01_200_03_tb
WHEN NEW.label_norm IS NULL
BEGIN
    UPDATE e01_200_03_tb SET label_norm = lower(trim(NEW.label))
    WHERE ent_id = NEW.ent_id;
END;
CREATE TRIGGER e03_434_05_tr AFTER UPDATE OF label ON e01_200_03_tb
WHEN NEW.label IS NOT OLD.label AND NEW.label_norm IS NULL
BEGIN
    UPDATE e01_200_03_tb SET label_norm = lower(trim(NEW.label))
    WHERE ent_id = NEW.ent_id;
END;
CREATE VIRTUAL TABLE e02_404_01_ft USING fts5(
    label_norm, desc_norm,
    content='e01_200_03_tb',
    content_rowid='ent_id',
    tokenize='trigram'
)
/* e02_404_01_ft(label_norm,desc_norm) */;
CREATE TRIGGER e03_778_10b_tr
BEFORE UPDATE OF element_name, policy_kind ON e01_778_05_tb
WHEN OLD.element_name <> NEW.element_name
  OR OLD.policy_kind <> NEW.policy_kind
BEGIN SELECT RAISE(ABORT, 'policy identity immutable'); END;
CREATE TRIGGER e03_778_11_tr BEFORE INSERT ON e01_778_05_tb
BEGIN
    SELECT CASE WHEN NOT EXISTS (
        SELECT 1 FROM e01_506_03_tb WHERE element_name = NEW.element_name)
    THEN RAISE(ABORT, 'policy: element not registered') END;
    SELECT CASE WHEN NOT EXISTS (
        SELECT 1 FROM e01_506_01_tb
        WHERE need_uid = NEW.need_uid AND status IN ('active','deferred'))
    THEN RAISE(ABORT, 'policy: need not active or deferred') END;
END;
CREATE VIEW e04_900_01_vw AS
SELECT domain, declared, realized,
  CASE WHEN declared > 0 THEN ROUND(100.0 * realized / declared, 1) ELSE 100.0 END AS coverage_pct,
  missing, orphan, severity_class,
  CASE
    WHEN declared = 0 THEN 'na'
    WHEN realized >= declared AND missing = 0 AND orphan = 0 THEN 'healthy'
    WHEN severity_class = 'expected' THEN 'info'
    WHEN 100.0 * realized / declared >= 80 THEN 'watch'
    ELSE 'critical'
  END AS status
FROM (
  SELECT 'needs_to_policy' AS domain,
    (SELECT COUNT(*) FROM e01_506_01_tb) AS declared,
    (SELECT COUNT(DISTINCT need_uid) FROM e01_778_05_tb) AS realized,
    (SELECT COUNT(*) FROM e01_506_01_tb n WHERE NOT EXISTS (SELECT 1 FROM e01_778_05_tb p WHERE p.need_uid = n.need_uid)) AS missing,
    0 AS orphan, 'real_issue' AS severity_class
  UNION ALL SELECT 'atoms_to_link',
    (SELECT COUNT(*) FROM e01_506_02_tb),
    (SELECT COUNT(DISTINCT atom_uid) FROM e01_516_01_tb),
    (SELECT COUNT(*) FROM e01_506_02_tb a WHERE NOT EXISTS (SELECT 1 FROM e01_516_01_tb l WHERE l.atom_uid = a.atom_uid)),
    0, 'real_issue'
  UNION ALL SELECT 'atoms_to_trace',
    (SELECT COUNT(*) FROM e01_506_02_tb),
    (SELECT COUNT(DISTINCT atom_uid) FROM e01_506_04_tb),
    (SELECT COUNT(*) FROM e01_506_02_tb a WHERE NOT EXISTS (SELECT 1 FROM e01_506_04_tb t WHERE t.atom_uid = a.atom_uid)),
    0, 'real_issue'
  UNION ALL SELECT 'elements_to_schema',
    (SELECT COUNT(*) FROM e01_506_03_tb WHERE element_kind IN ('tb','tr','vw','ft') AND element_name NOT LIKE 'POLICY:%'),
    (SELECT COUNT(*) FROM e01_506_03_tb e WHERE e.element_kind IN ('tb','tr','vw','ft') AND e.element_name NOT LIKE 'POLICY:%' AND EXISTS (SELECT 1 FROM sqlite_master sm WHERE sm.name = e.element_name)),
    (SELECT COUNT(*) FROM e01_506_03_tb e WHERE e.element_kind IN ('tb','tr','vw','ft') AND e.element_name NOT LIKE 'POLICY:%' AND NOT EXISTS (SELECT 1 FROM sqlite_master sm WHERE sm.name = e.element_name)),
    (SELECT COUNT(*) FROM sqlite_master sm WHERE sm.type IN ('table','trigger','view') AND sm.name LIKE 'e0%' AND sm.name NOT LIKE 'e02\_404\_01\_ft%' ESCAPE '\' AND NOT EXISTS (SELECT 1 FROM e01_506_03_tb e WHERE e.element_name = sm.name)),
    'real_issue'
  UNION ALL SELECT 'elements_to_matrix',
    (SELECT COUNT(*) FROM e01_506_03_tb WHERE element_kind IN ('tb','tr','vw','ft') AND element_name NOT LIKE 'POLICY:%'),
    (SELECT COUNT(*) FROM e01_506_03_tb e WHERE e.element_kind IN ('tb','tr','vw','ft') AND e.element_name NOT LIKE 'POLICY:%' AND EXISTS (SELECT 1 FROM e01_778_02_tb m WHERE m.element_name = e.element_name)),
    (SELECT COUNT(*) FROM e01_506_03_tb e WHERE e.element_kind IN ('tb','tr','vw','ft') AND e.element_name NOT LIKE 'POLICY:%' AND NOT EXISTS (SELECT 1 FROM e01_778_02_tb m WHERE m.element_name = e.element_name)),
    0, 'real_issue'
  UNION ALL SELECT 'entity_types_to_instances',
    (SELECT COUNT(*) FROM e01_200_01_tb),
    (SELECT COUNT(DISTINCT type_id) FROM e01_200_03_tb),
    (SELECT COUNT(*) FROM e01_200_01_tb t WHERE NOT EXISTS (SELECT 1 FROM e01_200_03_tb e WHERE e.type_id = t.type_id)),
    0, 'expected'
  UNION ALL SELECT 'relation_types_to_relations',
    (SELECT COUNT(*) FROM e01_202_01_tb),
    (SELECT COUNT(DISTINCT reltype_id) FROM e01_222_01_tb),
    (SELECT COUNT(*) FROM e01_202_01_tb t WHERE NOT EXISTS (SELECT 1 FROM e01_222_01_tb r WHERE r.reltype_id = t.reltype_id)),
    0, 'expected'
  UNION ALL SELECT 'policies_to_elements',
    (SELECT COUNT(*) FROM e01_778_05_tb),
    (SELECT COUNT(*) FROM e01_778_05_tb p WHERE EXISTS (SELECT 1 FROM e01_506_03_tb e WHERE e.element_name = p.element_name)),
    (SELECT COUNT(*) FROM e01_778_05_tb p WHERE NOT EXISTS (SELECT 1 FROM e01_506_03_tb e WHERE e.element_name = p.element_name)),
    0, 'real_issue'
  UNION ALL SELECT 'triggers_to_registry',
    (SELECT COUNT(*) FROM sqlite_master WHERE type='trigger' AND name LIKE 'e03%'),
    (SELECT COUNT(*) FROM sqlite_master sm WHERE sm.type='trigger' AND sm.name LIKE 'e03%' AND EXISTS (SELECT 1 FROM e01_506_03_tb e WHERE e.element_name = sm.name)),
    (SELECT COUNT(*) FROM sqlite_master sm WHERE sm.type='trigger' AND sm.name LIKE 'e03%' AND NOT EXISTS (SELECT 1 FROM e01_506_03_tb e WHERE e.element_name = sm.name)),
    0, 'real_issue'
  UNION ALL SELECT 'triggers_to_anchor',
    (SELECT COUNT(*) FROM sqlite_master WHERE type='trigger' AND name LIKE 'e03%'),
    (SELECT COUNT(*) FROM sqlite_master sm WHERE sm.type='trigger' AND sm.name LIKE 'e03%' AND EXISTS (SELECT 1 FROM e01_778_05_tb p WHERE p.exec_name = sm.name)),
    (SELECT COUNT(*) FROM sqlite_master sm WHERE sm.type='trigger' AND sm.name LIKE 'e03%' AND NOT EXISTS (SELECT 1 FROM e01_778_05_tb p WHERE p.exec_name = sm.name)),
    0, 'real_issue'
  UNION ALL SELECT 'fk_to_anchor',
    (SELECT COUNT(*) FROM e01_378_01_tb),
    (SELECT COUNT(*) FROM e01_378_01_tb f WHERE EXISTS (SELECT 1 FROM e01_778_05_tb p WHERE p.fk_ref_id = f.ref_id AND p.policy_kind='fk')),
    (SELECT COUNT(*) FROM e01_378_01_tb f WHERE NOT EXISTS (SELECT 1 FROM e01_778_05_tb p WHERE p.fk_ref_id = f.ref_id AND p.policy_kind='fk')),
    0, 'real_issue'
  UNION ALL SELECT 'matrix_to_needs',
    (SELECT COUNT(*) FROM e01_778_02_tb),
    (SELECT COUNT(*) FROM e01_778_02_tb m WHERE EXISTS (SELECT 1 FROM e01_506_01_tb n WHERE n.need_uid = m.need_uid)),
    (SELECT COUNT(*) FROM e01_778_02_tb m WHERE NOT EXISTS (SELECT 1 FROM e01_506_01_tb n WHERE n.need_uid = m.need_uid)),
    0, 'real_issue'
) t
/* e04_900_01_vw(domain,declared,realized,coverage_pct,missing,orphan,severity_class,status) */;
CREATE TRIGGER e03_370_01_tr BEFORE INSERT ON e01_516_01_tb
BEGIN
    SELECT CASE WHEN NOT EXISTS (
        SELECT 1 FROM e01_506_01_tb WHERE need_uid = NEW.need_uid)
    THEN RAISE(ABORT, 'nee_atom: need does not exist') END;
    SELECT CASE WHEN NOT EXISTS (
        SELECT 1 FROM e01_506_02_tb WHERE atom_uid = NEW.atom_uid)
    THEN RAISE(ABORT, 'nee_atom: atom does not exist') END;
END;
CREATE TRIGGER e03_370_11_tr BEFORE UPDATE OF need_uid, atom_uid ON e01_516_01_tb
BEGIN
    SELECT CASE WHEN NOT EXISTS (
        SELECT 1 FROM e01_506_01_tb WHERE need_uid = NEW.need_uid)
    THEN RAISE(ABORT, 'nee_atom.upd: need does not exist') END;
    SELECT CASE WHEN NOT EXISTS (
        SELECT 1 FROM e01_506_02_tb WHERE atom_uid = NEW.atom_uid)
    THEN RAISE(ABORT, 'nee_atom.upd: atom does not exist') END;
END;
CREATE TRIGGER e03_370_33_tr 
BEFORE UPDATE OF element_name, need_uid, role ON e01_778_02_tb
WHEN OLD.element_name <> NEW.element_name 
  OR OLD.need_uid <> NEW.need_uid
  OR OLD.role <> NEW.role
BEGIN SELECT RAISE(ABORT, 'e01_778_02_tb PK is immutable'); END;
CREATE TRIGGER e03_370_14_tr
BEFORE UPDATE OF dim_uid ON e01_506_08_tb
BEGIN
    SELECT CASE WHEN NOT EXISTS (
        SELECT 1 FROM e01_506_07_tb WHERE dim_uid = NEW.dim_uid)
    THEN RAISE(ABORT, 'dim_val.upd: dim does not exist') END;
END;
CREATE TRIGGER e03_328_03_tr
BEFORE UPDATE OF need_uid, atom_uid, kind ON e01_516_01_tb
WHEN OLD.need_uid <> NEW.need_uid 
  OR OLD.atom_uid <> NEW.atom_uid
  OR OLD.kind <> NEW.kind
BEGIN SELECT RAISE(ABORT, 'e01_516_01_tb PK is immutable'); END;
CREATE TRIGGER e03_778_14_tr
BEFORE DELETE ON e01_778_02_tb
BEGIN
    SELECT CASE WHEN EXISTS (
        SELECT 1 FROM e01_778_05_tb p
        WHERE p.element_name = OLD.element_name
          AND p.need_uid = OLD.need_uid
          AND p.is_mandatory = 1)
    THEN RAISE(ABORT, 'matrix: cannot delete row with mandatory policies') END;
END;
CREATE TRIGGER e03_778_02_ins_tr
BEFORE INSERT ON e01_778_02_tb
BEGIN
    SELECT CASE WHEN NOT EXISTS (
        SELECT 1 FROM e01_506_03_tb WHERE element_name = NEW.element_name)
    THEN RAISE(ABORT, 'matrix: element not registered') END;
    SELECT CASE WHEN NOT EXISTS (
        SELECT 1 FROM e01_506_01_tb WHERE need_uid = NEW.need_uid)
    THEN RAISE(ABORT, 'matrix: need does not exist') END;
END;
