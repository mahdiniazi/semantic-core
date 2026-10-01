-- =====================================================================
-- PART 2c — TRIGGERS (Groups 8-15): Text, Value, Node, Question, Delete, Immutability, Meta
-- =====================================================================

-- ============ GROUP 8: TEXT NORMALIZATION ============
DROP TRIGGER IF EXISTS e03_311_01_tr;
CREATE TRIGGER e03_311_01_tr AFTER INSERT ON e01_201_02_tb WHEN NEW.value_kind = 'text' AND NEW.text_val IS NOT NULL AND NEW.text_norm IS NULL
BEGIN UPDATE e01_201_02_tb SET text_norm = lower(trim(NEW.text_val)) WHERE val_id = NEW.val_id; END;

DROP TRIGGER IF EXISTS e03_311_02_tr;
CREATE TRIGGER e03_311_02_tr AFTER UPDATE OF text_val ON e01_201_02_tb WHEN NEW.value_kind = 'text' AND NEW.text_val IS NOT NULL AND (NEW.text_norm IS NULL OR NEW.text_norm <> lower(trim(NEW.text_val)))
BEGIN UPDATE e01_201_02_tb SET text_norm = lower(trim(NEW.text_val)) WHERE val_id = NEW.val_id; END;

-- ============ GROUP 8b: VALUE MEMBER CYCLE ============
DROP TRIGGER IF EXISTS e03_311_03_tr;
CREATE TRIGGER e03_311_03_tr BEFORE INSERT ON e01_201_03_tb WHEN NEW.member_val_id IS NOT NULL
BEGIN SELECT CASE WHEN EXISTS (WITH RECURSIVE desc_of_parent(id, depth) AS (
    SELECT NEW.parent_id, 0
    UNION ALL
    SELECT e.member_val_id, desc_of_parent.depth + 1 FROM e01_201_03_tb e
    JOIN desc_of_parent ON e.parent_id = desc_of_parent.id
    WHERE e.member_val_id IS NOT NULL
      AND desc_of_parent.depth < (SELECT int_value FROM e01_676_03_tb WHERE param_uid='max_member_depth'))
    SELECT 1 FROM desc_of_parent WHERE id = NEW.member_val_id) THEN RAISE(ABORT, 'value member: cycle detected') END; END;

DROP TRIGGER IF EXISTS e03_311_04_tr;
CREATE TRIGGER e03_311_04_tr BEFORE UPDATE OF parent_id, member_val_id ON e01_201_03_tb WHEN NEW.member_val_id IS NOT NULL
BEGIN SELECT CASE WHEN EXISTS (WITH RECURSIVE desc_of_parent(id, depth) AS (
    SELECT NEW.parent_id, 0
    UNION ALL
    SELECT e.member_val_id, desc_of_parent.depth + 1 FROM e01_201_03_tb e
    JOIN desc_of_parent ON e.parent_id = desc_of_parent.id
    WHERE e.member_val_id IS NOT NULL AND e.memb_id <> NEW.memb_id
      AND desc_of_parent.depth < (SELECT int_value FROM e01_676_03_tb WHERE param_uid='max_member_depth'))
    SELECT 1 FROM desc_of_parent WHERE id = NEW.member_val_id) THEN RAISE(ABORT, 'value member: cycle detected (upd)') END; END;

-- ============ GROUP 9: NODE GUARDS ============
DROP TRIGGER IF EXISTS e03_516_01_tr;
CREATE TRIGGER e03_516_01_tr BEFORE INSERT ON e01_506_06_tb WHEN NEW.parent_id IS NOT NULL
BEGIN SELECT CASE WHEN NOT EXISTS (SELECT 1 FROM e01_506_06_tb p WHERE p.node_id = NEW.parent_id AND p.need_uid = NEW.need_uid) THEN RAISE(ABORT, 'node parent belongs to another need') END; END;

DROP TRIGGER IF EXISTS e03_516_02_tr;
CREATE TRIGGER e03_516_02_tr BEFORE UPDATE OF need_uid, parent_id ON e01_506_06_tb WHEN NEW.parent_id IS NOT NULL
BEGIN SELECT CASE WHEN NOT EXISTS (SELECT 1 FROM e01_506_06_tb p WHERE p.node_id = NEW.parent_id AND p.need_uid = NEW.need_uid) THEN RAISE(ABORT, 'node parent belongs to another need') END; END;

DROP TRIGGER IF EXISTS e03_126_01_tr;
CREATE TRIGGER e03_126_01_tr BEFORE UPDATE OF parent_id ON e01_506_06_tb WHEN NEW.parent_id IS NOT NULL AND NEW.parent_id <> NEW.node_id
BEGIN SELECT CASE WHEN EXISTS (WITH RECURSIVE up(id) AS (SELECT NEW.parent_id UNION SELECT parent_id FROM e01_506_06_tb JOIN up ON e01_506_06_tb.node_id = up.id WHERE parent_id IS NOT NULL) SELECT 1 FROM up WHERE id = NEW.node_id) THEN RAISE(ABORT, 'node cycle detected') END; END;

-- ============ GROUP 10: QUESTION GUARDS ============
DROP TRIGGER IF EXISTS e03_126_02_tr;
CREATE TRIGGER e03_126_02_tr BEFORE INSERT ON e01_506_05_tb WHEN NEW.parent_uid = NEW.question_uid
BEGIN SELECT RAISE(ABORT, 'question self-cycle'); END;

DROP TRIGGER IF EXISTS e03_126_03_tr;
CREATE TRIGGER e03_126_03_tr BEFORE UPDATE OF parent_uid ON e01_506_05_tb WHEN NEW.parent_uid IS NOT NULL
BEGIN
  SELECT CASE WHEN NEW.parent_uid = NEW.question_uid THEN RAISE(ABORT, 'question self-cycle (upd)') END;
  SELECT CASE WHEN EXISTS (WITH RECURSIVE up(uid) AS (SELECT NEW.parent_uid UNION SELECT parent_uid FROM e01_506_05_tb JOIN up ON e01_506_05_tb.question_uid = up.uid WHERE parent_uid IS NOT NULL) SELECT 1 FROM up WHERE uid = NEW.question_uid) THEN RAISE(ABORT, 'question cycle detected') END;
END;

-- ============ GROUP 11: DELETE GUARDS ============
DROP TRIGGER IF EXISTS e03_320_01_tr;
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

DROP TRIGGER IF EXISTS e03_320_02_tr;
CREATE TRIGGER e03_320_02_tr BEFORE DELETE ON e01_201_02_tb
BEGIN SELECT CASE WHEN EXISTS (
  SELECT 1 FROM e01_222_01_tb WHERE obj_val_id = OLD.val_id
  UNION ALL SELECT 1 FROM e01_201_03_tb WHERE parent_id = OLD.val_id OR member_val_id = OLD.val_id
  UNION ALL SELECT 1 FROM e01_305_01_tb WHERE ctx_val_id = OLD.val_id
  UNION ALL SELECT 1 FROM e01_305_02_tb WHERE val_id = OLD.val_id OR ctx_val_id = OLD.val_id
  UNION ALL SELECT 1 FROM e01_305_03_tb WHERE ctx_val_id = OLD.val_id)
  THEN RAISE(ABORT, 'value referenced; retract or cascade first') END; END;

DROP TRIGGER IF EXISTS e03_320_03_tr;
CREATE TRIGGER e03_320_03_tr BEFORE DELETE ON e01_200_01_tb
BEGIN SELECT CASE WHEN EXISTS (
  SELECT 1 FROM e01_200_01_tb WHERE parent_id = OLD.type_id
  UNION ALL SELECT 1 FROM e01_200_03_tb WHERE type_id = OLD.type_id
  UNION ALL SELECT 1 FROM e01_112_01_tb WHERE target_type_id = OLD.type_id
  UNION ALL SELECT 1 FROM e01_120_01_tb WHERE desc_id = OLD.type_id OR anc_id = OLD.type_id)
  THEN RAISE(ABORT, 'entity type referenced') END; END;

DROP TRIGGER IF EXISTS e03_320_04_tr;
CREATE TRIGGER e03_320_04_tr BEFORE DELETE ON e01_202_01_tb
BEGIN SELECT CASE WHEN EXISTS (
  SELECT 1 FROM e01_222_01_tb WHERE reltype_id = OLD.reltype_id
  UNION ALL SELECT 1 FROM e01_302_01_tb WHERE reltype_id = OLD.reltype_id
  UNION ALL SELECT 1 FROM e01_112_01_tb WHERE reltype_id = OLD.reltype_id
  UNION ALL SELECT 1 FROM e01_202_01_tb WHERE inverse_uid = OLD.type_uid)
  THEN RAISE(ABORT, 'relation type referenced') END; END;

DROP TRIGGER IF EXISTS e03_320_05_tr;
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

DROP TRIGGER IF EXISTS e03_320_06_tr;
CREATE TRIGGER e03_320_06_tr BEFORE DELETE ON e01_302_01_tb
BEGIN SELECT CASE WHEN EXISTS (SELECT 1 FROM e01_222_01_tb WHERE lin_id = OLD.lin_id) THEN RAISE(ABORT, 'lineage referenced by relations') END; END;

DROP TRIGGER IF EXISTS e03_320_07_tr;
CREATE TRIGGER e03_320_07_tr BEFORE DELETE ON e01_200_02_tb
BEGIN SELECT CASE WHEN EXISTS (SELECT 1 FROM e01_201_01_tb WHERE dom_id = OLD.dom_id) THEN RAISE(ABORT, 'enum domain has values') END; END;

DROP TRIGGER IF EXISTS e03_320_08_tr;
CREATE TRIGGER e03_320_08_tr BEFORE DELETE ON e01_201_01_tb
BEGIN SELECT CASE WHEN EXISTS (SELECT 1 FROM e01_201_02_tb WHERE enum_id = OLD.val_id) THEN RAISE(ABORT, 'enum value referenced by values') END; END;

DROP TRIGGER IF EXISTS e03_320_09_tr;
CREATE TRIGGER e03_320_09_tr BEFORE UPDATE OF type_id ON e01_200_03_tb WHEN OLD.type_id <> NEW.type_id
BEGIN
  SELECT CASE WHEN EXISTS (SELECT 1 FROM e01_222_01_tb r WHERE r.subj_ent_id = OLD.ent_id AND r.status = 'asserted' AND r.superseded_at IS NULL AND EXISTS (SELECT 1 FROM e01_112_01_tb c WHERE c.reltype_id = r.reltype_id AND c.cons_kind = 'allowed_subject_type') AND NOT EXISTS (SELECT 1 FROM e01_112_01_tb c JOIN e01_120_01_tb cl ON cl.anc_id = c.target_type_id WHERE c.reltype_id = r.reltype_id AND c.cons_kind = 'allowed_subject_type' AND cl.desc_id = NEW.type_id)) THEN RAISE(ABORT, 'cannot change type: violates active subject domain') END;
  SELECT CASE WHEN EXISTS (SELECT 1 FROM e01_222_01_tb r WHERE r.obj_ent_id = OLD.ent_id AND r.status = 'asserted' AND r.superseded_at IS NULL AND EXISTS (SELECT 1 FROM e01_112_01_tb c WHERE c.reltype_id = r.reltype_id AND c.cons_kind = 'allowed_object_type') AND NOT EXISTS (SELECT 1 FROM e01_112_01_tb c JOIN e01_120_01_tb cl ON cl.anc_id = c.target_type_id WHERE c.reltype_id = r.reltype_id AND c.cd ~/semantic_core

cat > 02c_triggers_part3.sql << 'SQL_EOF'
-- =====================================================================
-- PART 2c — TRIGGERS (Groups 8-15): Text, Value, Node, Question, Delete, Immutability, Meta
-- =====================================================================

-- ============ GROUP 8: TEXT NORMALIZATION ============
DROP TRIGGER IF EXISTS e03_311_01_tr;
CREATE TRIGGER e03_311_01_tr AFTER INSERT ON e01_201_02_tb WHEN NEW.value_kind = 'text' AND NEW.text_val IS NOT NULL AND NEW.text_norm IS NULL
BEGIN UPDATE e01_201_02_tb SET text_norm = lower(trim(NEW.text_val)) WHERE val_id = NEW.val_id; END;

DROP TRIGGER IF EXISTS e03_311_02_tr;
CREATE TRIGGER e03_311_02_tr AFTER UPDATE OF text_val ON e01_201_02_tb WHEN NEW.value_kind = 'text' AND NEW.text_val IS NOT NULL AND (NEW.text_norm IS NULL OR NEW.text_norm <> lower(trim(NEW.text_val)))
BEGIN UPDATE e01_201_02_tb SET text_norm = lower(trim(NEW.text_val)) WHERE val_id = NEW.val_id; END;

-- ============ GROUP 8b: VALUE MEMBER CYCLE ============
DROP TRIGGER IF EXISTS e03_311_03_tr;
CREATE TRIGGER e03_311_03_tr BEFORE INSERT ON e01_201_03_tb WHEN NEW.member_val_id IS NOT NULL
BEGIN SELECT CASE WHEN EXISTS (WITH RECURSIVE desc_of_parent(id, depth) AS (
    SELECT NEW.parent_id, 0
    UNION ALL
    SELECT e.member_val_id, desc_of_parent.depth + 1 FROM e01_201_03_tb e
    JOIN desc_of_parent ON e.parent_id = desc_of_parent.id
    WHERE e.member_val_id IS NOT NULL
      AND desc_of_parent.depth < (SELECT int_value FROM e01_676_03_tb WHERE param_uid='max_member_depth'))
    SELECT 1 FROM desc_of_parent WHERE id = NEW.member_val_id) THEN RAISE(ABORT, 'value member: cycle detected') END; END;

DROP TRIGGER IF EXISTS e03_311_04_tr;
CREATE TRIGGER e03_311_04_tr BEFORE UPDATE OF parent_id, member_val_id ON e01_201_03_tb WHEN NEW.member_val_id IS NOT NULL
BEGIN SELECT CASE WHEN EXISTS (WITH RECURSIVE desc_of_parent(id, depth) AS (
    SELECT NEW.parent_id, 0
    UNION ALL
    SELECT e.member_val_id, desc_of_parent.depth + 1 FROM e01_201_03_tb e
    JOIN desc_of_parent ON e.parent_id = desc_of_parent.id
    WHERE e.member_val_id IS NOT NULL AND e.memb_id <> NEW.memb_id
      AND desc_of_parent.depth < (SELECT int_value FROM e01_676_03_tb WHERE param_uid='max_member_depth'))
    SELECT 1 FROM desc_of_parent WHERE id = NEW.member_val_id) THEN RAISE(ABORT, 'value member: cycle detected (upd)') END; END;

-- ============ GROUP 9: NODE GUARDS ============
DROP TRIGGER IF EXISTS e03_516_01_tr;
CREATE TRIGGER e03_516_01_tr BEFORE INSERT ON e01_506_06_tb WHEN NEW.parent_id IS NOT NULL
BEGIN SELECT CASE WHEN NOT EXISTS (SELECT 1 FROM e01_506_06_tb p WHERE p.node_id = NEW.parent_id AND p.need_uid = NEW.need_uid) THEN RAISE(ABORT, 'node parent belongs to another need') END; END;

DROP TRIGGER IF EXISTS e03_516_02_tr;
CREATE TRIGGER e03_516_02_tr BEFORE UPDATE OF need_uid, parent_id ON e01_506_06_tb WHEN NEW.parent_id IS NOT NULL
BEGIN SELECT CASE WHEN NOT EXISTS (SELECT 1 FROM e01_506_06_tb p WHERE p.node_id = NEW.parent_id AND p.need_uid = NEW.need_uid) THEN RAISE(ABORT, 'node parent belongs to another need') END; END;

DROP TRIGGER IF EXISTS e03_126_01_tr;
CREATE TRIGGER e03_126_01_tr BEFORE UPDATE OF parent_id ON e01_506_06_tb WHEN NEW.parent_id IS NOT NULL AND NEW.parent_id <> NEW.node_id
BEGIN SELECT CASE WHEN EXISTS (WITH RECURSIVE up(id) AS (SELECT NEW.parent_id UNION SELECT parent_id FROM e01_506_06_tb JOIN up ON e01_506_06_tb.node_id = up.id WHERE parent_id IS NOT NULL) SELECT 1 FROM up WHERE id = NEW.node_id) THEN RAISE(ABORT, 'node cycle detected') END; END;

-- ============ GROUP 10: QUESTION GUARDS ============
DROP TRIGGER IF EXISTS e03_126_02_tr;
CREATE TRIGGER e03_126_02_tr BEFORE INSERT ON e01_506_05_tb WHEN NEW.parent_uid = NEW.question_uid
BEGIN SELECT RAISE(ABORT, 'question self-cycle'); END;

DROP TRIGGER IF EXISTS e03_126_03_tr;
CREATE TRIGGER e03_126_03_tr BEFORE UPDATE OF parent_uid ON e01_506_05_tb WHEN NEW.parent_uid IS NOT NULL
BEGIN
  SELECT CASE WHEN NEW.parent_uid = NEW.question_uid THEN RAISE(ABORT, 'question self-cycle (upd)') END;
  SELECT CASE WHEN EXISTS (WITH RECURSIVE up(uid) AS (SELECT NEW.parent_uid UNION SELECT parent_uid FROM e01_506_05_tb JOIN up ON e01_506_05_tb.question_uid = up.uid WHERE parent_uid IS NOT NULL) SELECT 1 FROM up WHERE uid = NEW.question_uid) THEN RAISE(ABORT, 'question cycle detected') END;
END;

-- ============ GROUP 11: DELETE GUARDS ============
DROP TRIGGER IF EXISTS e03_320_01_tr;
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

DROP TRIGGER IF EXISTS e03_320_02_tr;
CREATE TRIGGER e03_320_02_tr BEFORE DELETE ON e01_201_02_tb
BEGIN SELECT CASE WHEN EXISTS (
  SELECT 1 FROM e01_222_01_tb WHERE obj_val_id = OLD.val_id
  UNION ALL SELECT 1 FROM e01_201_03_tb WHERE parent_id = OLD.val_id OR member_val_id = OLD.val_id
  UNION ALL SELECT 1 FROM e01_305_01_tb WHERE ctx_val_id = OLD.val_id
  UNION ALL SELECT 1 FROM e01_305_02_tb WHERE val_id = OLD.val_id OR ctx_val_id = OLD.val_id
  UNION ALL SELECT 1 FROM e01_305_03_tb WHERE ctx_val_id = OLD.val_id)
  THEN RAISE(ABORT, 'value referenced; retract or cascade first') END; END;

DROP TRIGGER IF EXISTS e03_320_03_tr;
CREATE TRIGGER e03_320_03_tr BEFORE DELETE ON e01_200_01_tb
BEGIN SELECT CASE WHEN EXISTS (
  SELECT 1 FROM e01_200_01_tb WHERE parent_id = OLD.type_id
  UNION ALL SELECT 1 FROM e01_200_03_tb WHERE type_id = OLD.type_id
  UNION ALL SELECT 1 FROM e01_112_01_tb WHERE target_type_id = OLD.type_id
  UNION ALL SELECT 1 FROM e01_120_01_tb WHERE desc_id = OLD.type_id OR anc_id = OLD.type_id)
  THEN RAISE(ABORT, 'entity type referenced') END; END;

DROP TRIGGER IF EXISTS e03_320_04_tr;
CREATE TRIGGER e03_320_04_tr BEFORE DELETE ON e01_202_01_tb
BEGIN SELECT CASE WHEN EXISTS (
  SELECT 1 FROM e01_222_01_tb WHERE reltype_id = OLD.reltype_id
  UNION ALL SELECT 1 FROM e01_302_01_tb WHERE reltype_id = OLD.reltype_id
  UNION ALL SELECT 1 FROM e01_112_01_tb WHERE reltype_id = OLD.reltype_id
  UNION ALL SELECT 1 FROM e01_202_01_tb WHERE inverse_uid = OLD.type_uid)
  THEN RAISE(ABORT, 'relation type referenced') END; END;

DROP TRIGGER IF EXISTS e03_320_05_tr;
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

DROP TRIGGER IF EXISTS e03_320_06_tr;
CREATE TRIGGER e03_320_06_tr BEFORE DELETE ON e01_302_01_tb
BEGIN SELECT CASE WHEN EXISTS (SELECT 1 FROM e01_222_01_tb WHERE lin_id = OLD.lin_id) THEN RAISE(ABORT, 'lineage referenced by relations') END; END;

DROP TRIGGER IF EXISTS e03_320_07_tr;
CREATE TRIGGER e03_320_07_tr BEFORE DELETE ON e01_200_02_tb
BEGIN SELECT CASE WHEN EXISTS (SELECT 1 FROM e01_201_01_tb WHERE dom_id = OLD.dom_id) THEN RAISE(ABORT, 'enum domain has values') END; END;

DROP TRIGGER IF EXISTS e03_320_08_tr;
CREATE TRIGGER e03_320_08_tr BEFORE DELETE ON e01_201_01_tb
BEGIN SELECT CASE WHEN EXISTS (SELECT 1 FROM e01_201_02_tb WHERE enum_id = OLD.val_id) THEN RAISE(ABORT, 'enum value referenced by values') END; END;

DROP TRIGGER IF EXISTS e03_320_09_tr;
CREATE TRIGGER e03_320_09_tr BEFORE UPDATE OF type_id ON e01_200_03_tb WHEN OLD.type_id <> NEW.type_id
BEGIN
  SELECT CASE WHEN EXISTS (SELECT 1 FROM e01_222_01_tb r WHERE r.subj_ent_id = OLD.ent_id AND r.status = 'asserted' AND r.superseded_at IS NULL AND EXISTS (SELECT 1 FROM e01_112_01_tb c WHERE c.reltype_id = r.reltype_id AND c.cons_kind = 'allowed_subject_type') AND NOT EXISTS (SELECT 1 FROM e01_112_01_tb c JOIN e01_120_01_tb cl ON cl.anc_id = c.target_type_id WHERE c.reltype_id = r.reltype_id AND c.cons_kind = 'allowed_subject_type' AND cl.desc_id = NEW.type_id)) THEN RAISE(ABORT, 'cannot change type: violates active subject domain') END;
  SELECT CASE WHEN EXISTS (SELECT 1 FROM e01_222_01_tb r WHERE r.obj_ent_id = OLD.ent_id AND r.status = 'asserted' AND r.superseded_at IS NULL AND EXISTS (SELECT 1 FROM e01_112_01_tb c WHERE c.reltype_id = r.reltype_id AND c.cons_kind = 'allowed_object_type') AND NOT EXISTS (SELECT 1 FROM e01_112_01_tb c JOIN e01_120_01_tb cl ON cl.anc_id = c.target_type_id WHERE c.reltype_id = r.reltype_id AND c.cons_kind = 'allowed_object_type' AND cl.desc_id = NEW.type_id)) THEN RAISE(ABORT, 'cannot change type: violates active object domain') END;
  SELECT CASE WHEN EXISTS (SELECT 1 FROM e01_222_01_tb r WHERE r.reif_ent_id = OLD.ent_id AND r.reif_type <> 'none' AND r.status = 'asserted' AND r.superseded_at IS NULL AND NOT EXISTS (SELECT 1 FROM e01_200_01_tb et WHERE et.type_id = NEW.type_id AND et.type_uid IN ('ReifiedRelation','Evidence','Observation','Measurement','Claim','Hypothesis','Diagnosis'))) THEN RAISE(ABORT, 'cannot change type: invalidates reification') END;
END;

-- ============ GROUP 12: SEMANTIC GRAPH GUARDS ============
DROP TRIGGER IF EXISTS e03_370_30_tr;
CREATE TRIGGER e03_370_30_tr BEFORE DELETE ON e01_778_01_tb
BEGIN SELECT CASE WHEN EXISTS (SELECT 1 FROM e01_778_01_tb WHERE parent_code = OLD.code UNION ALL SELECT 1 FROM e01_778_02_tb WHERE code = OLD.code) THEN RAISE(ABORT, 'req_code referenced') END; END;

DROP TRIGGER IF EXISTS e03_370_32_tr;
CREATE TRIGGER e03_370_32_tr BEFORE UPDATE OF need_uid, code, code_kind ON e01_778_01_tb WHEN OLD.need_uid <> NEW.need_uid OR OLD.code <> NEW.code OR OLD.code_kind <> NEW.code_kind
BEGIN SELECT RAISE(ABORT, 'e01_778_01_tb PK is immutable'); END;

DROP TRIGGER IF EXISTS e03_370_33_tr;
CREATE TRIGGER e03_370_33_tr BEFORE UPDATE OF element_name, need_uid, role ON e01_778_02_tb WHEN OLD.element_name <> NEW.element_name OR OLD.need_uid <> NEW.need_uid OR OLD.role <> NEW.role
BEGIN SELECT RAISE(ABORT, 'e01_778_02_tb PK is immutable'); END;

DROP TRIGGER IF EXISTS e03_370_34_tr;
CREATE TRIGGER e03_370_34_tr BEFORE UPDATE OF chain_uid, ordinal ON e01_778_04_tb WHEN OLD.chain_uid <> NEW.chain_uid OR OLD.ordinal <> NEW.ordinal
BEGIN SELECT RAISE(ABORT, 'e01_778_04_tb PK is immutable'); END;

-- ============ GROUP 13: REIFICATION ARCHIVE ============
DROP TRIGGER IF EXISTS e03_360_01_tr;
CREATE TRIGGER e03_360_01_tr AFTER UPDATE OF status ON e01_222_01_tb WHEN NEW.status = 'retracted' AND OLD.status <> 'retracted' AND NEW.reif_type = 'annotated' AND NEW.reif_ent_id IS NOT NULL
BEGIN UPDATE e01_200_03_tb SET status = 'archived' WHERE ent_id = NEW.reif_ent_id AND status = 'active'; END;

-- ============ GROUP 14: META INSERT GUARDS ============
DROP TRIGGER IF EXISTS e03_370_01_tr;
CREATE TRIGGER e03_370_01_tr BEFORE INSERT ON e01_516_01_tb
BEGIN SELECT CASE WHEN NOT EXISTS (SELECT 1 FROM e01_506_01_tb WHERE need_uid = NEW.need_uid) THEN RAISE(ABORT, 'nee_atom: need does not exist') END; SELECT CASE WHEN NOT EXISTS (SELECT 1 FROM e01_506_02_tb WHERE atom_uid = NEW.atom_uid) THEN RAISE(ABORT, 'nee_atom: atom does not exist') END; END;

DROP TRIGGER IF EXISTS e03_370_02_tr;
CREATE TRIGGER e03_370_02_tr BEFORE INSERT ON e01_506_03_tb
BEGIN SELECT CASE WHEN NEW.need_uid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM e01_506_01_tb WHERE need_uid = NEW.need_uid) THEN RAISE(ABORT, 'ele_stor: need does not exist') END; END;

DROP TRIGGER IF EXISTS e03_370_03_tr;
CREATE TRIGGER e03_370_03_tr BEFORE INSERT ON e01_506_04_tb
BEGIN SELECT CASE WHEN NOT EXISTS (SELECT 1 FROM e01_506_02_tb WHERE atom_uid = NEW.atom_uid) THEN RAISE(ABORT, 'tra_stor: atom does not exist') END; SELECT CASE WHEN NOT EXISTS (SELECT 1 FROM e01_506_03_tb WHERE element_name = NEW.element_name) THEN RAISE(ABORT, 'tra_stor: element does not exist') END; END;

DROP TRIGGER IF EXISTS e03_370_04_tr;
CREATE TRIGGER e03_370_04_tr BEFORE INSERT ON e01_506_08_tb
BEGIN SELECT CASE WHEN NOT EXISTS (SELECT 1 FROM e01_506_07_tb WHERE dim_uid = NEW.dim_uid) THEN RAISE(ABORT, 'dim_val: dim does not exist') END; END;

DROP TRIGGER IF EXISTS e03_370_05_tr;
CREATE TRIGGER e03_370_05_tr BEFORE INSERT ON e01_506_06_tb
BEGIN SELECT CASE WHEN NOT EXISTS (SELECT 1 FROM e01_506_01_tb WHERE need_uid = NEW.need_uid) THEN RAISE(ABORT, 'nod_tree: need does not exist') END; SELECT CASE WHEN NEW.parent_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM e01_506_06_tb WHERE node_id = NEW.parent_id) THEN RAISE(ABORT, 'nod_tree: parent does not exist') END; SELECT CASE WHEN NOT EXISTS (SELECT 1 FROM e01_506_05_tb WHERE question_uid = NEW.question_uid) THEN RAISE(ABORT, 'nod_tree: question does not exist') END; END;

DROP TRIGGER IF EXISTS e03_370_06_tr;
CREATE TRIGGER e03_370_06_tr BEFORE INSERT ON e01_506_05_tb
BEGIN SELECT CASE WHEN NEW.parent_uid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM e01_506_05_tb WHERE question_uid = NEW.parent_uid) THEN RAISE(ABORT, 'que_gram: parent does not exist') END; END;

DROP TRIGGER IF EXISTS e03_370_07_tr;
CREATE TRIGGER e03_370_07_tr BEFORE INSERT ON e01_330_01_tb
BEGIN SELECT CASE WHEN NOT EXISTS (SELECT 1 FROM e01_200_03_tb WHERE ent_id = NEW.ent_id) THEN RAISE(ABORT, 'ent_vers: entity does not exist') END; SELECT CASE WHEN NEW.supersedes_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM e01_330_01_tb WHERE vers_id = NEW.supersedes_id) THEN RAISE(ABORT, 'ent_vers: supersedes does not exist') END; SELECT CASE WHEN NEW.supersedes_id IS NOT NULL AND NEW.supersedes_id = NEW.vers_id THEN RAISE(ABORT, 'ent_vers: cannot supersede self') END; SELECT CASE WHEN NEW.supersedes_id IS NOT NULL AND (SELECT ent_id FROM e01_330_01_tb WHERE vers_id = NEW.supersedes_id) <> NEW.ent_id THEN RAISE(ABORT, 'ent_vers: supersedes cross-entity') END; SELECT CASE WHEN NEW.approved_by_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM e01_200_03_tb WHERE ent_id = NEW.approved_by_id) THEN RAISE(ABORT, 'ent_vers: approver does not exist') END; END;

DROP TRIGGER IF EXISTS e03_370_08_tr;
CREATE TRIGGER e03_370_08_tr BEFORE INSERT ON e01_330_02_tb
BEGIN SELECT CASE WHEN NOT EXISTS (SELECT 1 FROM e01_200_03_tb WHERE ent_id = NEW.ent_id) THEN RAISE(ABORT, 'ent_snap: entity does not exist') END; SELECT CASE WHEN NEW.vers_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM e01_330_01_tb WHERE vers_id = NEW.vers_id) THEN RAISE(ABORT, 'ent_snap: vers does not exist') END; SELECT CASE WHEN NEW.vers_id IS NOT NULL AND (SELECT ent_id FROM e01_330_01_tb WHERE vers_id = NEW.vers_id) <> NEW.ent_id THEN RAISE(ABORT, 'ent_snap: vers cross-entity') END; END;

DROP TRIGGER IF EXISTS e03_370_11_tr;
CREATE TRIGGER e03_370_11_tr BEFORE UPDATE OF need_uid, atom_uid ON e01_516_01_tb
BEGIN SELECT CASE WHEN NOT EXISTS (SELECT 1 FROM e01_506_01_tb WHERE need_uid = NEW.need_uid) THEN RAISE(ABORT, 'nee_atom.upd: need does not exist') END; SELECT CASE WHEN NOT EXISTS (SELECT 1 FROM e01_506_02_tb WHERE atom_uid = NEW.atom_uid) THEN RAISE(ABORT, 'nee_atom.upd: atom does not exist') END; END;

DROP TRIGGER IF EXISTS e03_370_12_tr;
CREATE TRIGGER e03_370_12_tr BEFORE UPDATE OF need_uid ON e01_506_03_tb
BEGIN SELECT CASE WHEN NEW.need_uid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM e01_506_01_tb WHERE need_uid = NEW.need_uid) THEN RAISE(ABORT, 'ele_stor.upd: need does not exist') END; END;

DROP TRIGGER IF EXISTS e03_370_13_tr;
CREATE TRIGGER e03_370_13_tr BEFORE UPDATE OF atom_uid, element_name ON e01_506_04_tb
BEGIN SELECT CASE WHEN NOT EXISTS (SELECT 1 FROM e01_506_02_tb WHERE atom_uid = NEW.atom_uid) THEN RAISE(ABORT, 'tra_stor.upd: atom does not exist') END; SELECT CASE WHEN NOT EXISTS (SELECT 1 FROM e01_506_03_tb WHERE element_name = NEW.element_name) THEN RAISE(ABORT, 'tra_stor.upd: element does not exist') END; END;

DROP TRIGGER IF EXISTS e03_370_14_tr;
CREATE TRIGGER e03_370_14_tr BEFORE UPDATE OF dim_uid ON e01_506_08_tb
BEGIN SELECT CASE WHEN NOT EXISTS (SELECT 1 FROM e01_506_07_tb WHERE dim_uid = NEW.dim_uid) THEN RAISE(ABORT, 'dim_val.upd: dim does not exist') END; END;

DROP TRIGGER IF EXISTS e03_370_15_tr;
CREATE TRIGGER e03_370_15_tr BEFORE UPDATE OF need_uid, parent_id, question_uid ON e01_506_06_tb
BEGIN SELECT CASE WHEN NOT EXISTS (SELECT 1 FROM e01_506_01_tb WHERE need_uid = NEW.need_uid) THEN RAISE(ABORT, 'nod_tree.upd: need does not exist') END; SELECT CASE WHEN NEW.parent_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM e01_506_06_tb WHERE node_id = NEW.parent_id) THEN RAISE(ABORT, 'nod_tree.upd: parent does not exist') END; SELECT CASE WHEN NOT EXISTS (SELECT 1 FROM e01_506_05_tb WHERE question_uid = NEW.question_uid) THEN RAISE(ABORT, 'nod_tree.upd: question does not exist') END; END;

DROP TRIGGER IF EXISTS e03_370_16_tr;
CREATE TRIGGER e03_370_16_tr BEFORE UPDATE OF parent_uid ON e01_506_05_tb
BEGIN SELECT CASE WHEN NEW.parent_uid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM e01_506_05_tb WHERE question_uid = NEW.parent_uid) THEN RAISE(ABORT, 'que_gram.upd: parent does not exist') END; END;

DROP TRIGGER IF EXISTS e03_370_17_tr;
CREATE TRIGGER e03_370_17_tr BEFORE UPDATE OF ent_id, supersedes_id, approved_by_id ON e01_330_01_tb
BEGIN
  SELECT CASE WHEN NOT EXISTS (SELECT 1 FROM e01_200_03_tb WHERE ent_id = NEW.ent_id) THEN RAISE(ABORT, 'ent_vers.upd: entity does not exist') END;
  SELECT CASE WHEN NEW.supersedes_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM e01_330_01_tb WHERE vers_id = NEW.supersedes_id) THEN RAISE(ABORT, 'ent_vers.upd: supersedes does not exist') END;
  SELECT CASE WHEN NEW.supersedes_id IS NOT NULL AND NEW.supersedes_id = NEW.vers_id THEN RAISE(ABORT, 'ent_vers.upd: cannot supersede self') END;
  SELECT CASE WHEN NEW.supersedes_id IS NOT NULL AND (SELECT ent_id FROM e01_330_01_tb WHERE vers_id = NEW.supersedes_id) <> NEW.ent_id THEN RAISE(ABORT, 'ent_vers.upd: supersedes cross-entity') END;
  SELECT CASE WHEN NEW.supersedes_id IS NOT NULL AND EXISTS (WITH RECURSIVE chain(vid, depth) AS (SELECT NEW.supersedes_id, 0 UNION ALL SELECT v.supersedes_id, chain.depth + 1 FROM e01_330_01_tb v JOIN chain ON v.vers_id = chain.vid WHERE v.supersedes_id IS NOT NULL AND chain.depth < (SELECT int_value FROM e01_676_03_tb WHERE param_uid='max_version_depth')) SELECT 1 FROM chain WHERE vid = NEW.vers_id) THEN RAISE(ABORT, 'ent_vers.upd: supersedes chain cycle') END;
  SELECT CASE WHEN NEW.approved_by_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM e01_200_03_tb WHERE ent_id = NEW.approved_by_id) THEN RAISE(ABORT, 'ent_vers.upd: approver does not exist') END;
END;

DROP TRIGGER IF EXISTS e03_370_18_tr;
CREATE TRIGGER e03_370_18_tr BEFORE UPDATE OF ent_id, vers_id ON e01_330_02_tb
BEGIN SELECT CASE WHEN NOT EXISTS (SELECT 1 FROM e01_200_03_tb WHERE ent_id = NEW.ent_id) THEN RAISE(ABORT, 'ent_snap.upd: entity does not exist') END; SELECT CASE WHEN NEW.vers_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM e01_330_01_tb WHERE vers_id = NEW.vers_id) THEN RAISE(ABORT, 'ent_snap.upd: vers does not exist') END; SELECT CASE WHEN NEW.vers_id IS NOT NULL AND (SELECT ent_id FROM e01_330_01_tb WHERE vers_id = NEW.vers_id) <> NEW.ent_id THEN RAISE(ABORT, 'ent_snap.upd: vers cross-entity') END; END;

-- ============ GROUP 15: META DELETE GUARDS ============
DROP TRIGGER IF EXISTS e03_370_21_tr;
CREATE TRIGGER e03_370_21_tr BEFORE DELETE ON e01_506_01_tb
BEGIN SELECT CASE WHEN EXISTS (SELECT 1 FROM e01_516_01_tb WHERE need_uid = OLD.need_uid UNION ALL SELECT 1 FROM e01_506_06_tb WHERE need_uid = OLD.need_uid UNION ALL SELECT 1 FROM e01_506_03_tb WHERE need_uid = OLD.need_uid UNION ALL SELECT 1 FROM e01_778_01_tb WHERE need_uid = OLD.need_uid UNION ALL SELECT 1 FROM e01_778_02_tb WHERE need_uid = OLD.need_uid UNION ALL SELECT 1 FROM e01_778_03_tb WHERE root_need_uid = OLD.need_uid UNION ALL SELECT 1 FROM e01_778_04_tb WHERE need_uid = OLD.need_uid) THEN RAISE(ABORT, 'nee_stor referenced; use status=deferred/dropped') END; END;

DROP TRIGGER IF EXISTS e03_370_22_tr;
CREATE TRIGGER e03_370_22_tr BEFORE DELETE ON e01_506_02_tb
BEGIN SELECT CASE WHEN EXISTS (SELECT 1 FROM e01_516_01_tb WHERE atom_uid = OLD.atom_uid UNION ALL SELECT 1 FROM e01_506_04_tb WHERE atom_uid = OLD.atom_uid) THEN RAISE(ABORT, 'req_stor referenced; use status=deferred/dropped') END; END;

DROP TRIGGER IF EXISTS e03_370_23_tr;
CREATE TRIGGER e03_370_23_tr BEFORE DELETE ON e01_506_03_tb
BEGIN SELECT CASE WHEN EXISTS (SELECT 1 FROM e01_506_04_tb WHERE element_name = OLD.element_name UNION ALL SELECT 1 FROM e01_778_02_tb WHERE element_name = OLD.element_name UNION ALL SELECT 1 FROM e01_778_04_tb WHERE element_name = OLD.element_name) THEN RAISE(ABORT, 'ele_stor referenced') END; END;

DROP TRIGGER IF EXISTS e03_370_24_tr;
CREATE TRIGGER e03_370_24_tr BEFORE DELETE ON e01_506_07_tb
BEGIN SELECT CASE WHEN EXISTS (SELECT 1 FROM e01_506_08_tb WHERE dim_uid = OLD.dim_uid) THEN RAISE(ABORT, 'dim_stor referenced') END; END;

DROP TRIGGER IF EXISTS e03_370_25_tr;
CREATE TRIGGER e03_370_25_tr BEFORE DELETE ON e01_506_05_tb
BEGIN SELECT CASE WHEN EXISTS (SELECT 1 FROM e01_506_05_tb WHERE parent_uid = OLD.question_uid UNION ALL SELECT 1 FROM e01_506_06_tb WHERE question_uid = OLD.question_uid) THEN RAISE(ABORT, 'que_gram referenced') END; END;

DROP TRIGGER IF EXISTS e03_370_26_tr;
CREATE TRIGGER e03_370_26_tr BEFORE DELETE ON e01_330_01_tb
BEGIN SELECT CASE WHEN EXISTS (SELECT 1 FROM e01_330_01_tb WHERE supersedes_id = OLD.vers_id UNION ALL SELECT 1 FROM e01_330_02_tb WHERE vers_id = OLD.vers_id) THEN RAISE(ABORT, 'ent_vers referenced; use status=deprecated') END; END;

-- ============ GROUP 16: VALUE GUARDS ============
DROP TRIGGER IF EXISTS e03_310_03_tr;
CREATE TRIGGER e03_310_03_tr BEFORE INSERT ON e01_201_02_tb
BEGIN SELECT CASE WHEN NEW.enum_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM e01_201_01_tb WHERE val_id = NEW.enum_id) THEN RAISE(ABORT, 'enum value does not exist') END; END;

DROP TRIGGER IF EXISTS e03_310_04_tr;
CREATE TRIGGER e03_310_04_tr BEFORE UPDATE OF enum_id ON e01_201_02_tb
BEGIN SELECT CASE WHEN NEW.enum_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM e01_201_01_tb WHERE val_id = NEW.enum_id) THEN RAISE(ABORT, 'enum value does not exist (upd)') END; END;

DROP TRIGGER IF EXISTS e03_310_05_tr;
CREATE TRIGGER e03_310_05_tr BEFORE INSERT ON e01_201_03_tb
BEGIN SELECT CASE WHEN NOT EXISTS (SELECT 1 FROM e01_201_02_tb WHERE val_id = NEW.parent_id) THEN RAISE(ABORT, 'val_memb: parent does not exist') END; SELECT CASE WHEN NEW.member_val_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM e01_201_02_tb WHERE val_id = NEW.member_val_id) THEN RAISE(ABORT, 'val_memb: member_val does not exist') END; SELECT CASE WHEN NEW.member_ent_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM e01_200_03_tb WHERE ent_id = NEW.member_ent_id) THEN RAISE(ABORT, 'val_memb: member_ent does not exist') END; END;

DROP TRIGGER IF EXISTS e03_310_06_tr;
CREATE TRIGGER e03_310_06_tr BEFORE UPDATE OF parent_id, member_val_id, member_ent_id ON e01_201_03_tb
BEGIN SELECT CASE WHEN NOT EXISTS (SELECT 1 FROM e01_201_02_tb WHERE val_id = NEW.parent_id) THEN RAISE(ABORT, 'val_memb.upd: parent does not exist') END; SELECT CASE WHEN NEW.member_val_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM e01_201_02_tb WHERE val_id = NEW.member_val_id) THEN RAISE(ABORT, 'val_memb.upd: member_val does not exist') END; SELECT CASE WHEN NEW.member_ent_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM e01_200_03_tb WHERE ent_id = NEW.member_ent_id) THEN RAISE(ABORT, 'val_memb.upd: member_ent does not exist') END; END;

-- ============ GROUP 17: IMMUTABILITY GUARDS ============
DROP TRIGGER IF EXISTS e03_328_01_tr; CREATE TRIGGER e03_328_01_tr BEFORE UPDATE OF need_uid ON e01_506_01_tb WHEN OLD.need_uid <> NEW.need_uid BEGIN SELECT RAISE(ABORT, 'e01_506_01_tb.need_uid is immutable'); END;
DROP TRIGGER IF EXISTS e03_328_02_tr; CREATE TRIGGER e03_328_02_tr BEFORE UPDATE OF atom_uid ON e01_506_02_tb WHEN OLD.atom_uid <> NEW.atom_uid BEGIN SELECT RAISE(ABORT, 'e01_506_02_tb.atom_uid is immutable'); END;
DROP TRIGGER IF EXISTS e03_328_03_tr; CREATE TRIGGER e03_328_03_tr BEFORE UPDATE OF need_uid, atom_uid, kind ON e01_516_01_tb WHEN OLD.need_uid <> NEW.need_uid OR OLD.atom_uid <> NEW.atom_uid OR OLD.kind <> NEW.kind BEGIN SELECT RAISE(ABORT, 'e01_516_01_tb PK is immutable'); END;
DROP TRIGGER IF EXISTS e03_328_04_tr; CREATE TRIGGER e03_328_04_tr BEFORE UPDATE OF element_name ON e01_506_03_tb WHEN OLD.element_name <> NEW.element_name BEGIN SELECT RAISE(ABORT, 'e01_506_03_tb.element_name is immutable'); END;
DROP TRIGGER IF EXISTS e03_328_05_tr; CREATE TRIGGER e03_328_05_tr BEFORE UPDATE OF trace_id ON e01_506_04_tb WHEN OLD.trace_id <> NEW.trace_id BEGIN SELECT RAISE(ABORT, 'e01_506_04_tb.trace_id is immutable'); END;
DROP TRIGGER IF EXISTS e03_328_06_tr; CREATE TRIGGER e03_328_06_tr BEFORE UPDATE OF question_uid ON e01_506_05_tb WHEN OLD.question_uid <> NEW.question_uid BEGIN SELECT RAISE(ABORT, 'e01_506_05_tb.question_uid is immutable'); END;
DROP TRIGGER IF EXISTS e03_328_07_tr; CREATE TRIGGER e03_328_07_tr BEFORE UPDATE OF node_id ON e01_506_06_tb WHEN OLD.node_id <> NEW.node_id BEGIN SELECT RAISE(ABORT, 'e01_506_06_tb.node_id is immutable'); END;
DROP TRIGGER IF EXISTS e03_328_08_tr; CREATE TRIGGER e03_328_08_tr BEFORE UPDATE OF migration_uid ON e01_676_01_tb WHEN OLD.migration_uid <> NEW.migration_uid BEGIN SELECT RAISE(ABORT, 'e01_676_01_tb.migration_uid is immutable'); END;
DROP TRIGGER IF EXISTS e03_328_09_tr; CREATE TRIGGER e03_328_09_tr BEFORE UPDATE OF id ON e01_676_02_tb WHEN OLD.id <> NEW.id BEGIN SELECT RAISE(ABORT, 'e01_676_02_tb.id is immutable'); END;
DROP TRIGGER IF EXISTS e03_328_10_tr; CREATE TRIGGER e03_328_10_tr BEFORE UPDATE OF ref_id ON e01_378_01_tb WHEN OLD.ref_id <> NEW.ref_id BEGIN SELECT RAISE(ABORT, 'e01_378_01_tb.ref_id is immutable'); END;
DROP TRIGGER IF EXISTS e03_328_11_tr; CREATE TRIGGER e03_328_11_tr BEFORE UPDATE OF dim_uid ON e01_506_07_tb WHEN OLD.dim_uid <> NEW.dim_uid BEGIN SELECT RAISE(ABORT, 'e01_506_07_tb.dim_uid is immutable'); END;
DROP TRIGGER IF EXISTS e03_328_12_tr; CREATE TRIGGER e03_328_12_tr BEFORE UPDATE OF value_id ON e01_506_08_tb WHEN OLD.value_id <> NEW.value_id BEGIN SELECT RAISE(ABORT, 'e01_506_08_tb.value_id is immutable'); END;
DROP TRIGGER IF EXISTS e03_328_13_tr; CREATE TRIGGER e03_328_13_tr BEFORE UPDATE OF type_id ON e01_200_01_tb WHEN OLD.type_id <> NEW.type_id BEGIN SELECT RAISE(ABORT, 'e01_200_01_tb.type_id is immutable'); END;
DROP TRIGGER IF EXISTS e03_328_14_tr; CREATE TRIGGER e03_328_14_tr BEFORE UPDATE OF desc_id, anc_id ON e01_120_01_tb WHEN OLD.desc_id <> NEW.desc_id OR OLD.anc_id <> NEW.anc_id BEGIN SELECT RAISE(ABORT, 'e01_120_01_tb PK is immutable'); END;
DROP TRIGGER IF EXISTS e03_328_15_tr; CREATE TRIGGER e03_328_15_tr BEFORE UPDATE OF reltype_id ON e01_202_01_tb WHEN OLD.reltype_id <> NEW.reltype_id BEGIN SELECT RAISE(ABORT, 'e01_202_01_tb.reltype_id is immutable'); END;
DROP TRIGGER IF EXISTS e03_328_16_tr; CREATE TRIGGER e03_328_16_tr BEFORE UPDATE OF cons_id ON e01_112_01_tb WHEN OLD.cons_id <> NEW.cons_id BEGIN SELECT RAISE(ABORT, 'e01_112_01_tb.cons_id is immutable'); END;
DROP TRIGGER IF EXISTS e03_328_17_tr; CREATE TRIGGER e03_328_17_tr BEFORE UPDATE OF dom_id ON e01_200_02_tb WHEN OLD.dom_id <> NEW.dom_id BEGIN SELECT RAISE(ABORT, 'e01_200_02_tb.dom_id is immutable'); END;
DROP TRIGGER IF EXISTS e03_328_18_tr; CREATE TRIGGER e03_328_18_tr BEFORE UPDATE OF val_id ON e01_201_01_tb WHEN OLD.val_id <> NEW.val_id BEGIN SELECT RAISE(ABORT, 'e01_201_01_tb.val_id is immutable'); END;
DROP TRIGGER IF EXISTS e03_328_19_tr; CREATE TRIGGER e03_328_19_tr BEFORE UPDATE OF prv_id ON e01_303_01_tb WHEN OLD.prv_id <> NEW.prv_id BEGIN SELECT RAISE(ABORT, 'e01_303_01_tb.prv_id is immutable'); END;
DROP TRIGGER IF EXISTS e03_328_20_tr; CREATE TRIGGER e03_328_20_tr BEFORE UPDATE OF ent_id ON e01_200_03_tb WHEN OLD.ent_id <> NEW.ent_id BEGIN SELECT RAISE(ABORT, 'e01_200_03_tb.ent_id is immutable'); END;
DROP TRIGGER IF EXISTS e03_328_21_tr; CREATE TRIGGER e03_328_21_tr BEFORE UPDATE OF val_id ON e01_201_02_tb WHEN OLD.val_id <> NEW.val_id BEGIN SELECT RAISE(ABORT, 'e01_201_02_tb.val_id is immutable'); END;
DROP TRIGGER IF EXISTS e03_328_22_tr; CREATE TRIGGER e03_328_22_tr BEFORE UPDATE OF memb_id ON e01_201_03_tb WHEN OLD.memb_id <> NEW.memb_id BEGIN SELECT RAISE(ABORT, 'e01_201_03_tb.memb_id is immutable'); END;
DROP TRIGGER IF EXISTS e03_328_23_tr; CREATE TRIGGER e03_328_23_tr BEFORE UPDATE OF lin_id ON e01_302_01_tb WHEN OLD.lin_id <> NEW.lin_id BEGIN SELECT RAISE(ABORT, 'e01_302_01_tb.lin_id is immutable'); END;
DROP TRIGGER IF EXISTS e03_328_24_tr; CREATE TRIGGER e03_328_24_tr BEFORE UPDATE OF rel_id ON e01_222_01_tb WHEN OLD.rel_id <> NEW.rel_id BEGIN SELECT RAISE(ABORT, 'e01_222_01_tb.rel_id is immutable'); END;
DROP TRIGGER IF EXISTS e03_328_25_tr; CREATE TRIGGER e03_328_25_tr BEFORE UPDATE OF ctx_id ON e01_305_01_tb WHEN OLD.ctx_id <> NEW.ctx_id BEGIN SELECT RAISE(ABORT, 'e01_305_01_tb.ctx_id is immutable'); END;
DROP TRIGGER IF EXISTS e03_328_26_tr; CREATE TRIGGER e03_328_26_tr BEFORE UPDATE OF ctx_id ON e01_305_02_tb WHEN OLD.ctx_id <> NEW.ctx_id BEGIN SELECT RAISE(ABORT, 'e01_305_02_tb.ctx_id is immutable'); END;
DROP TRIGGER IF EXISTS e03_328_27_tr; CREATE TRIGGER e03_328_27_tr BEFORE UPDATE OF ctx_id ON e01_305_03_tb WHEN OLD.ctx_id <> NEW.ctx_id BEGIN SELECT RAISE(ABORT, 'e01_305_03_tb.ctx_id is immutable'); END;
DROP TRIGGER IF EXISTS e03_328_28_tr; CREATE TRIGGER e03_328_28_tr BEFORE UPDATE OF clm_id ON e01_300_01_tb WHEN OLD.clm_id <> NEW.clm_id BEGIN SELECT RAISE(ABORT, 'e01_300_01_tb.clm_id is immutable'); END;
DROP TRIGGER IF EXISTS e03_328_29_tr; CREATE TRIGGER e03_328_29_tr BEFORE UPDATE OF vers_id ON e01_330_01_tb WHEN OLD.vers_id <> NEW.vers_id BEGIN SELECT RAISE(ABORT, 'e01_330_01_tb.vers_id is immutable'); END;
DROP TRIGGER IF EXISTS e03_328_30_tr; CREATE TRIGGER e03_328_30_tr BEFORE UPDATE OF snap_id ON e01_330_02_tb WHEN OLD.snap_id <> NEW.snap_id BEGIN SELECT RAISE(ABORT, 'e01_330_02_tb.snap_id is immutable'); END;
DROP TRIGGER IF EXISTS e03_328_31_tr; CREATE TRIGGER e03_328_31_tr BEFORE UPDATE OF source_type, source_ref ON e01_303_01_tb WHEN OLD.source_type = 'unknown' AND OLD.source_ref = 'system:unknown' AND (NEW.source_type <> 'unknown' OR NEW.source_ref <> 'system:unknown') BEGIN SELECT RAISE(ABORT, 'fallback provenance identity is immutable'); END;
DROP TRIGGER IF EXISTS e03_328_32_tr; CREATE TRIGGER e03_328_32_tr BEFORE DELETE ON e01_676_02_tb BEGIN SELECT RAISE(ABORT, 'schema state row cannot be deleted'); END;
DROP TRIGGER IF EXISTS e03_328_33_tr; CREATE TRIGGER e03_328_33_tr BEFORE UPDATE OF verb_code ON e01_506_09_tb WHEN OLD.verb_code <> NEW.verb_code BEGIN SELECT RAISE(ABORT, 'e01_506_09_tb.verb_code is immutable'); END;
DROP TRIGGER IF EXISTS e03_328_34_tr; CREATE TRIGGER e03_328_34_tr BEFORE UPDATE OF entity_code ON e01_506_10_tb WHEN OLD.entity_code <> NEW.entity_code BEGIN SELECT RAISE(ABORT, 'e01_506_10_tb.entity_code is immutable'); END;
DROP TRIGGER IF EXISTS e03_328_35_tr; CREATE TRIGGER e03_328_35_tr BEFORE UPDATE OF constraint_code ON e01_506_11_tb WHEN OLD.constraint_code <> NEW.constraint_code BEGIN SELECT RAISE(ABORT, 'e01_506_11_tb.constraint_code is immutable'); END;
DROP TRIGGER IF EXISTS e03_328_36_tr; CREATE TRIGGER e03_328_36_tr BEFORE UPDATE OF schema_ver ON e01_676_02_tb WHEN NEW.schema_ver < OLD.schema_ver BEGIN SELECT RAISE(ABORT, 'schema_ver cannot decrease'); END;
DROP TRIGGER IF EXISTS e03_328_37_tr; CREATE TRIGGER e03_328_37_tr BEFORE UPDATE OF param_uid ON e01_676_03_tb WHEN OLD.param_uid <> NEW.param_uid BEGIN SELECT RAISE(ABORT, 'e01_676_03_tb.param_uid is immutable'); END;
