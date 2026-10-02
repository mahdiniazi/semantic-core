DROP VIEW IF EXISTS e04_200_01_vw;
CREATE VIEW e04_200_01_vw AS SELECT 'entity_type' AS node_kind, type_id AS node_id, type_uid, label, description FROM e01_200_01_tb UNION ALL SELECT 'relation_type', reltype_id, type_uid, label, description FROM e01_202_01_tb UNION ALL SELECT 'enum_domain', dom_id, dom_uid, label, description FROM e01_200_02_tb;

DROP VIEW IF EXISTS e04_230_01_vw;
CREATE VIEW e04_230_01_vw AS SELECT ent_id, ent_uid, type_id, label, description, status FROM e01_200_03_tb WHERE nature = 'concept';

DROP VIEW IF EXISTS e04_230_02_vw;
CREATE VIEW e04_230_02_vw AS SELECT ent_id, ent_uid, type_id, label, description, status FROM e01_200_03_tb WHERE nature = 'instance';

DROP VIEW IF EXISTS e04_340_01_vw;
CREATE VIEW e04_340_01_vw AS SELECT * FROM e01_222_01_tb WHERE superseded_at IS NULL;

DROP VIEW IF EXISTS e04_340_02_vw;
CREATE VIEW e04_340_02_vw AS SELECT * FROM e01_222_01_tb WHERE superseded_at IS NULL AND status = 'asserted';

DROP VIEW IF EXISTS e04_340_04_vw;
CREATE VIEW e04_340_04_vw AS SELECT r.lin_id, r.rel_uid, r.subj_ent_id, r.reltype_id, r.valid_from, r.valid_to, r.recorded_at, r.superseded_at, r.status, CASE WHEN r.superseded_at IS NULL THEN 1 ELSE 0 END AS is_current FROM e01_222_01_tb r;

DROP VIEW IF EXISTS e04_325_01_vw;
CREATE VIEW e04_325_01_vw AS SELECT 'entity' AS tgt_kind, ctx_id AS qual_id, ent_id AS tgt_id, ctx_ent_id, ctx_val_id, role, valid_from, valid_to, prv_id FROM e01_305_01_tb UNION ALL SELECT 'value', ctx_id, val_id, ctx_ent_id, ctx_val_id, role, valid_from, valid_to, prv_id FROM e01_305_02_tb UNION ALL SELECT 'relation', ctx_id, rel_id, ctx_ent_id, ctx_val_id, role, valid_from, valid_to, prv_id FROM e01_305_03_tb;

DROP VIEW IF EXISTS e04_310_01_vw;
CREATE VIEW e04_310_01_vw AS SELECT DISTINCT a.ent_a_id, a.ent_b_id FROM e01_300_01_tb a JOIN e01_300_01_tb b ON a.ent_a_id = b.ent_a_id AND a.ent_b_id = b.ent_b_id AND a.clm_type = 'same_as' AND b.clm_type = 'distinct_from' WHERE a.status = 'asserted' AND b.status = 'asserted';

DROP VIEW IF EXISTS e04_311_01_vw;
CREATE VIEW e04_311_01_vw AS SELECT v.val_id, v.value_kind, 'absence_kind_with_payload' AS violation_kind FROM e01_201_02_tb v WHERE v.value_kind IN ('unknown','not_observed','not_recorded','not_applicable') AND (v.num_val IS NOT NULL OR v.text_val IS NOT NULL OR v.text_norm IS NOT NULL OR v.bool_val IS NOT NULL OR v.dt_start IS NOT NULL OR v.dt_end IS NOT NULL OR v.num_min IS NOT NULL OR v.num_max IS NOT NULL OR v.enum_id IS NOT NULL OR v.json_val IS NOT NULL);

DROP VIEW IF EXISTS e04_122_01_vw;
CREATE VIEW e04_122_01_vw AS WITH RECURSIVE cl(sub_id, anc_id) AS (SELECT r.subj_ent_id, r.obj_ent_id FROM e01_222_01_tb r JOIN e01_202_01_tb rt ON rt.reltype_id = r.reltype_id WHERE rt.type_uid = 'is_a' AND r.superseded_at IS NULL AND r.status = 'asserted' UNION SELECT c.sub_id, r.obj_ent_id FROM cl c JOIN e01_222_01_tb r ON r.subj_ent_id = c.anc_id JOIN e01_202_01_tb rt ON rt.reltype_id = r.reltype_id WHERE rt.type_uid = 'is_a' AND r.superseded_at IS NULL AND r.status = 'asserted') SELECT * FROM cl;
