-- =====================================================================
-- PART 2b — TRIGGERS (Groups 5-7): Relation Validation, Context, Provenance
-- =====================================================================

-- ============ GROUP 5: RELATION VALIDATION (INSERT) ============
DROP TRIGGER IF EXISTS e03_312_01_tr;
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

-- ============ GROUP 5b: RELATION VALIDATION (UPDATE) ============
DROP TRIGGER IF EXISTS e03_312_02_tr;
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

-- ============ GROUP 5c: RELATION CONTEXT CONFLICT ============
DROP TRIGGER IF EXISTS e03_112_01_tr;
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

-- ============ GROUP 6: CONTEXT KEY SYNC ============
DROP TRIGGER IF EXISTS e03_135_01_tr;
CREATE TRIGGER e03_135_01_tr AFTER INSERT ON e01_305_03_tb
BEGIN
  UPDATE e01_222_01_tb SET ctx_key = COALESCE(
    (SELECT 's:' || group_concat(x, '|')
     FROM (SELECT COALESCE('e:' || ctx_ent_id, 'v:' || ctx_val_id) || ':' || role AS x
           FROM e01_305_03_tb WHERE rel_id = NEW.rel_id
           ORDER BY role, COALESCE(ctx_ent_id, ctx_val_id))), 'u:')
  WHERE rel_id = NEW.rel_id;
END;

DROP TRIGGER IF EXISTS e03_135_02_tr;
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

DROP TRIGGER IF EXISTS e03_135_03_tr;
CREATE TRIGGER e03_135_03_tr AFTER DELETE ON e01_305_03_tb
BEGIN
  UPDATE e01_222_01_tb SET ctx_key = COALESCE(
    (SELECT 's:' || group_concat(x, '|')
     FROM (SELECT COALESCE('e:' || ctx_ent_id, 'v:' || ctx_val_id) || ':' || role AS x
           FROM e01_305_03_tb WHERE rel_id = OLD.rel_id
           ORDER BY role, COALESCE(ctx_ent_id, ctx_val_id))), 'u:')
  WHERE rel_id = OLD.rel_id;
END;

-- ============ GROUP 7: PROVENANCE FALLBACK ============
DROP TRIGGER IF EXISTS e03_343_01_tr;
CREATE TRIGGER e03_343_01_tr AFTER INSERT ON e01_200_03_tb WHEN NEW.prv_id IS NULL
BEGIN UPDATE e01_200_03_tb SET prv_id = (SELECT prv_id FROM e01_303_01_tb WHERE source_type='unknown' AND source_ref='system:unknown' ORDER BY prv_id LIMIT 1), updated_at = datetime('now') WHERE ent_id = NEW.ent_id; END;

DROP TRIGGER IF EXISTS e03_343_02_tr;
CREATE TRIGGER e03_343_02_tr AFTER INSERT ON e01_201_02_tb WHEN NEW.prv_id IS NULL
BEGIN UPDATE e01_201_02_tb SET prv_id = (SELECT prv_id FROM e01_303_01_tb WHERE source_type='unknown' AND source_ref='system:unknown' ORDER BY prv_id LIMIT 1) WHERE val_id = NEW.val_id; END;

DROP TRIGGER IF EXISTS e03_343_03_tr;
CREATE TRIGGER e03_343_03_tr AFTER INSERT ON e01_222_01_tb WHEN NEW.prv_id IS NULL
BEGIN UPDATE e01_222_01_tb SET prv_id = (SELECT prv_id FROM e01_303_01_tb WHERE source_type='unknown' AND source_ref='system:unknown' ORDER BY prv_id LIMIT 1) WHERE rel_id = NEW.rel_id; END;

DROP TRIGGER IF EXISTS e03_343_04_tr;
CREATE TRIGGER e03_343_04_tr AFTER INSERT ON e01_305_01_tb WHEN NEW.prv_id IS NULL
BEGIN UPDATE e01_305_01_tb SET prv_id = (SELECT prv_id FROM e01_303_01_tb WHERE source_type='unknown' AND source_ref='system:unknown' ORDER BY prv_id LIMIT 1) WHERE ctx_id = NEW.ctx_id; END;

DROP TRIGGER IF EXISTS e03_343_05_tr;
CREATE TRIGGER e03_343_05_tr AFTER INSERT ON e01_305_02_tb WHEN NEW.prv_id IS NULL
BEGIN UPDATE e01_305_02_tb SET prv_id = (SELECT prv_id FROM e01_303_01_tb WHERE source_type='unknown' AND source_ref='system:unknown' ORDER BY prv_id LIMIT 1) WHERE ctx_id = NEW.ctx_id; END;

DROP TRIGGER IF EXISTS e03_343_06_tr;
CREATE TRIGGER e03_343_06_tr AFTER INSERT ON e01_305_03_tb WHEN NEW.prv_id IS NULL
BEGIN UPDATE e01_305_03_tb SET prv_id = (SELECT prv_id FROM e01_303_01_tb WHERE source_type='unknown' AND source_ref='system:unknown' ORDER BY prv_id LIMIT 1) WHERE ctx_id = NEW.ctx_id; END;

DROP TRIGGER IF EXISTS e03_343_07_tr;
CREATE TRIGGER e03_343_07_tr AFTER INSERT ON e01_300_01_tb WHEN NEW.prv_id IS NULL
BEGIN UPDATE e01_300_01_tb SET prv_id = (SELECT prv_id FROM e01_303_01_tb WHERE source_type='unknown' AND source_ref='system:unknown' ORDER BY prv_id LIMIT 1) WHERE clm_id = NEW.clm_id; END;

DROP TRIGGER IF EXISTS e03_343_08_tr;
CREATE TRIGGER e03_343_08_tr BEFORE DELETE ON e01_303_01_tb WHEN OLD.source_type = 'unknown' AND OLD.source_ref = 'system:unknown'
BEGIN SELECT RAISE(ABORT, 'cannot delete fallback provenance'); END;

DROP TRIGGER IF EXISTS e03_343_09_tr;
CREATE TRIGGER e03_343_09_tr BEFORE UPDATE OF source_type, source_ref ON e01_303_01_tb
WHEN OLD.source_type = 'unknown' AND OLD.source_ref = 'system:unknown' AND (NEW.source_type <> 'unknown' OR NEW.source_ref <> 'system:unknown')
BEGIN SELECT RAISE(ABORT, 'cannot change fallback provenance identity'); END;
