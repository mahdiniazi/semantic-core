DROP TRIGGER IF EXISTS e03_120_01_tr;
CREATE TRIGGER e03_120_01_tr BEFORE UPDATE OF parent_id ON e01_200_01_tb WHEN NEW.parent_id IS NOT NULL AND NEW.parent_id <> NEW.type_id BEGIN SELECT CASE WHEN EXISTS (SELECT 1 FROM e01_120_01_tb WHERE desc_id = NEW.parent_id AND anc_id = NEW.type_id) THEN RAISE(ABORT, 'type hierarchy: cycle') END; END;

DROP TRIGGER IF EXISTS e03_120_02_tr;
CREATE TRIGGER e03_120_02_tr AFTER INSERT ON e01_200_01_tb BEGIN INSERT INTO e01_120_01_tb VALUES (NEW.type_id, NEW.type_id, 0); INSERT INTO e01_120_01_tb SELECT NEW.type_id, anc_id, depth+1 FROM e01_120_01_tb WHERE desc_id = NEW.parent_id AND NEW.parent_id IS NOT NULL AND depth < (SELECT int_value FROM e01_676_03_tb WHERE param_uid='max_depth'); END;

DROP TRIGGER IF EXISTS e03_120_03_tr;
CREATE TRIGGER e03_120_03_tr AFTER UPDATE OF parent_id ON e01_200_01_tb WHEN OLD.parent_id IS NOT NEW.parent_id BEGIN DELETE FROM e01_120_01_tb; INSERT INTO e01_120_01_tb WITH RECURSIVE walk(desc_id,anc_id,depth) AS (SELECT type_id,type_id,0 FROM e01_200_01_tb UNION SELECT w.desc_id,p.parent_id,w.depth+1 FROM walk w JOIN e01_200_01_tb p ON p.type_id=w.anc_id WHERE p.parent_id IS NOT NULL AND w.depth < (SELECT int_value FROM e01_676_03_tb WHERE param_uid='max_depth')) SELECT desc_id,anc_id,depth FROM walk; END;

DROP TRIGGER IF EXISTS e03_120_04_tr;
CREATE TRIGGER e03_120_04_tr BEFORE INSERT ON e01_200_03_tb BEGIN SELECT CASE WHEN (SELECT type_id FROM e01_200_01_tb WHERE type_id=NEW.type_id) IS NULL THEN RAISE(ABORT, 'no type') END; SELECT CASE WHEN NEW.nature='instance' AND (SELECT is_abstract FROM e01_200_01_tb WHERE type_id=NEW.type_id)=1 THEN RAISE(ABORT, 'abstract') END; END;

DROP TRIGGER IF EXISTS e03_120_05_tr;
CREATE TRIGGER e03_120_05_tr BEFORE UPDATE OF type_id, nature ON e01_200_03_tb BEGIN SELECT CASE WHEN (SELECT type_id FROM e01_200_01_tb WHERE type_id=NEW.type_id) IS NULL THEN RAISE(ABORT, 'no type upd') END; SELECT CASE WHEN NEW.nature='instance' AND (SELECT is_abstract FROM e01_200_01_tb WHERE type_id=NEW.type_id)=1 THEN RAISE(ABORT, 'abstract upd') END; END;

DROP TRIGGER IF EXISTS e03_340_01_tr;
CREATE TRIGGER e03_340_01_tr AFTER UPDATE OF label, description, nature, status, type_id, label_norm, desc_norm ON e01_200_03_tb BEGIN UPDATE e01_200_03_tb SET updated_at=datetime('now') WHERE ent_id=NEW.ent_id; END;

DROP TRIGGER IF EXISTS e03_434_01_tr;
CREATE TRIGGER e03_434_01_tr AFTER INSERT ON e01_200_03_tb BEGIN INSERT INTO e02_404_01_ft(rowid,label_norm,desc_norm) VALUES (NEW.ent_id, COALESCE(NEW.label_norm, lower(trim(NEW.label))), NEW.desc_norm); END;

DROP TRIGGER IF EXISTS e03_434_02_tr;
CREATE TRIGGER e03_434_02_tr AFTER DELETE ON e01_200_03_tb BEGIN INSERT INTO e02_404_01_ft(e02_404_01_ft,rowid,label_norm,desc_norm) VALUES ('delete', OLD.ent_id, COALESCE(OLD.label_norm, lower(trim(OLD.label))), OLD.desc_norm); END;

DROP TRIGGER IF EXISTS e03_434_03_tr;
CREATE TRIGGER e03_434_03_tr AFTER UPDATE OF label_norm, desc_norm, label ON e01_200_03_tb BEGIN INSERT INTO e02_404_01_ft(e02_404_01_ft,rowid,label_norm,desc_norm) VALUES ('delete', OLD.ent_id, COALESCE(OLD.label_norm, lower(trim(OLD.label))), OLD.desc_norm); INSERT INTO e02_404_01_ft(rowid,label_norm,desc_norm) VALUES (NEW.ent_id, COALESCE(NEW.label_norm, lower(trim(NEW.label))), NEW.desc_norm); END;

DROP TRIGGER IF EXISTS e03_434_04_tr;
CREATE TRIGGER e03_434_04_tr AFTER INSERT ON e01_200_03_tb WHEN NEW.label_norm IS NULL BEGIN UPDATE e01_200_03_tb SET label_norm=lower(trim(NEW.label)) WHERE ent_id=NEW.ent_id; END;

DROP TRIGGER IF EXISTS e03_434_05_tr;
CREATE TRIGGER e03_434_05_tr AFTER UPDATE OF label ON e01_200_03_tb WHEN NEW.label IS NOT OLD.label AND NEW.label_norm IS NULL BEGIN UPDATE e01_200_03_tb SET label_norm=lower(trim(NEW.label)) WHERE ent_id=NEW.ent_id; END;

DROP TRIGGER IF EXISTS e03_122_01_tr;
CREATE TRIGGER e03_122_01_tr BEFORE INSERT ON e01_222_01_tb WHEN NEW.reltype_id=(SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='is_a') AND NEW.superseded_at IS NULL AND NEW.status='asserted' BEGIN SELECT CASE WHEN NEW.subj_ent_id=NEW.obj_ent_id THEN RAISE(ABORT, 'isa self') END; SELECT CASE WHEN EXISTS (WITH RECURSIVE anc(id,depth) AS (SELECT NEW.obj_ent_id,0 UNION ALL SELECT r.obj_ent_id,anc.depth+1 FROM e01_222_01_tb r JOIN e01_202_01_tb rt ON rt.reltype_id=r.reltype_id JOIN anc ON r.subj_ent_id=anc.id WHERE rt.type_uid='is_a' AND r.superseded_at IS NULL AND r.status='asserted' AND anc.depth < (SELECT int_value FROM e01_676_03_tb WHERE param_uid='max_isa_depth')) SELECT 1 FROM anc WHERE id=NEW.subj_ent_id) THEN RAISE(ABORT, 'isa cycle') END; END;

DROP TRIGGER IF EXISTS e03_122_02_tr;
CREATE TRIGGER e03_122_02_tr BEFORE UPDATE OF subj_ent_id, obj_ent_id, reltype_id, status, superseded_at ON e01_222_01_tb WHEN NEW.reltype_id=(SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='is_a') AND NEW.superseded_at IS NULL AND NEW.status='asserted' BEGIN SELECT CASE WHEN NEW.subj_ent_id=NEW.obj_ent_id THEN RAISE(ABORT, 'isa self upd') END; SELECT CASE WHEN EXISTS (WITH RECURSIVE anc(id,depth) AS (SELECT NEW.obj_ent_id,0 UNION ALL SELECT r.obj_ent_id,anc.depth+1 FROM e01_222_01_tb r JOIN e01_202_01_tb rt ON rt.reltype_id=r.reltype_id JOIN anc ON r.subj_ent_id=anc.id WHERE rt.type_uid='is_a' AND r.superseded_at IS NULL AND r.status='asserted' AND r.rel_id<>NEW.rel_id AND anc.depth < (SELECT int_value FROM e01_676_03_tb WHERE param_uid='max_isa_depth')) SELECT 1 FROM anc WHERE id=NEW.subj_ent_id) THEN RAISE(ABORT, 'isa cycle upd') END; END;
