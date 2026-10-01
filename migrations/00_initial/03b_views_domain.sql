DROP VIEW IF EXISTS e04_267_01_vw;
CREATE VIEW e04_267_01_vw AS SELECT v.ent_id AS vehicle_entity_id, v.ent_uid, v.label AS vehicle_label, (SELECT vs.text_val FROM e01_222_01_tb r JOIN e01_202_01_tb rt ON rt.reltype_id = r.reltype_id JOIN e01_201_02_tb vs ON vs.val_id = r.obj_val_id WHERE r.subj_ent_id = v.ent_id AND rt.type_uid = 'has_vin' AND r.superseded_at IS NULL AND r.status = 'asserted' ORDER BY r.recorded_at DESC, r.rel_id DESC LIMIT 1) AS vin, (SELECT oe.label FROM e01_222_01_tb r JOIN e01_202_01_tb rt ON rt.reltype_id = r.reltype_id JOIN e01_200_03_tb oe ON oe.ent_id = r.obj_ent_id WHERE r.subj_ent_id = v.ent_id AND rt.type_uid = 'instance_of' AND r.superseded_at IS NULL AND r.status = 'asserted' ORDER BY r.recorded_at DESC, r.rel_id DESC LIMIT 1) AS model_label FROM e01_200_03_tb v JOIN e01_200_01_tb et ON et.type_id = v.type_id AND et.type_uid = 'Vehicle' WHERE v.nature = 'instance' AND v.status = 'active';

DROP VIEW IF EXISTS e04_267_02_vw;
CREATE VIEW e04_267_02_vw AS SELECT r.obj_ent_id AS vehicle_entity_id, r.subj_ent_id AS unit_entity_id, et.type_uid AS unit_type_uid, CASE WHEN et.type_uid = 'ECU' THEN 1 ELSE 0 END AS is_ecu FROM e01_222_01_tb r JOIN e01_202_01_tb rt ON rt.reltype_id = r.reltype_id AND rt.type_uid = 'installed_on' JOIN e01_200_03_tb u ON u.ent_id = r.subj_ent_id JOIN e01_200_01_tb et ON et.type_id = u.type_id WHERE r.superseded_at IS NULL AND r.status = 'asserted';

DROP VIEW IF EXISTS e04_260_01_vw;
CREATE VIEW e04_260_01_vw AS SELECT e.ent_id AS ecu_entity_id, e.ent_uid AS ecu_uid, e.label AS ecu_label, e.description AS ecu_description, e.status FROM e01_200_03_tb e JOIN e01_200_01_tb et ON et.type_id = e.type_id AND et.type_uid = 'ECU';

DROP VIEW IF EXISTS e04_260_02_vw;
CREATE VIEW e04_260_02_vw AS SELECT c.ent_id AS case_entity_id FROM e01_200_03_tb c JOIN e01_200_01_tb et ON et.type_id = c.type_id WHERE et.type_uid = 'Case';

DROP VIEW IF EXISTS e04_260_03_vw;
CREATE VIEW e04_260_03_vw AS SELECT t.ent_id AS tech_entity_id, t.label AS tech_label, 0 AS cases_count FROM e01_200_03_tb t JOIN e01_200_01_tb et_t ON et_t.type_id = t.type_id AND et_t.type_uid = 'Technician' WHERE t.status = 'active';

DROP VIEW IF EXISTS e04_110_01_vw;
CREATE VIEW e04_110_01_vw AS WITH RECURSIVE expected(desc_id, anc_id, depth, path, cycle) AS (SELECT t.type_id, t.type_id, 0, ',' || CAST(t.type_id AS TEXT) || ',', 0 FROM e01_200_01_tb t UNION ALL SELECT e.desc_id, p.parent_id, e.depth + 1, e.path || CAST(p.parent_id AS TEXT) || ',', CASE WHEN instr(e.path, ',' || CAST(p.parent_id AS TEXT) || ',') > 0 THEN 1 ELSE 0 END FROM expected e JOIN e01_200_01_tb p ON p.type_id = e.anc_id WHERE e.cycle = 0 AND p.parent_id IS NOT NULL AND e.depth < 100), expected_rows AS (SELECT desc_id, anc_id, depth FROM expected WHERE cycle = 0), actual AS (SELECT desc_id, anc_id, depth, COUNT(*) AS n FROM e01_120_01_tb GROUP BY desc_id, anc_id, depth) SELECT 'missing_expected_row', e.desc_id FROM expected_rows e WHERE NOT EXISTS (SELECT 1 FROM actual a WHERE a.desc_id = e.desc_id AND a.anc_id = e.anc_id AND a.depth = e.depth) UNION ALL SELECT 'orphan_closure_row', cl.desc_id FROM e01_120_01_tb cl WHERE NOT EXISTS (SELECT 1 FROM e01_200_01_tb t WHERE t.type_id = cl.desc_id) OR NOT EXISTS (SELECT 1 FROM e01_200_01_tb t WHERE t.type_id = cl.anc_id) UNION ALL SELECT 'closure_cycle', cl.desc_id FROM e01_120_01_tb cl WHERE cl.desc_id = cl.anc_id AND cl.depth > 0;

DROP VIEW IF EXISTS e04_110_02_vw;
CREATE VIEW e04_110_02_vw AS SELECT 'T' AS layer, 'parent_self' AS violation_kind, t.type_id AS object_id, t.type_uid AS detail FROM e01_200_01_tb t WHERE t.parent_id = t.type_id UNION ALL SELECT 'T', 'parent_orphan', t.type_id, CAST(t.parent_id AS TEXT) FROM e01_200_01_tb t WHERE t.parent_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM e01_200_01_tb p WHERE p.type_id = t.parent_id) UNION ALL SELECT 'T', 'inverse_orphan', r.reltype_id, r.inverse_uid FROM e01_202_01_tb r WHERE r.inverse_uid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM e01_202_01_tb x WHERE x.type_uid = r.inverse_uid);

DROP VIEW IF EXISTS e04_310_02_vw;
CREATE VIEW e04_310_02_vw AS SELECT 'rel_subject' AS violation_kind, r.rel_id AS id, r.rel_uid AS uid FROM e01_222_01_tb r WHERE NOT EXISTS (SELECT 1 FROM e01_200_03_tb e WHERE e.ent_id = r.subj_ent_id) UNION ALL SELECT 'rel_object_ent', r.rel_id, r.rel_uid FROM e01_222_01_tb r WHERE r.obj_ent_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM e01_200_03_tb e WHERE e.ent_id = r.obj_ent_id) UNION ALL SELECT 'ent_type', e.ent_id, e.ent_uid FROM e01_200_03_tb e WHERE NOT EXISTS (SELECT 1 FROM e01_200_01_tb t WHERE t.type_id = e.type_id);

DROP VIEW IF EXISTS e04_978_01_vw;
CREATE VIEW e04_978_01_vw AS SELECT 'M_fk' AS check_name, 0 AS has_violation, 'no rows = healthy' AS expectation UNION ALL SELECT 'T_semantic', CASE WHEN EXISTS(SELECT 1 FROM e04_110_02_vw) THEN 1 ELSE 0 END, 'no rows = healthy' UNION ALL SELECT 'C_orphan', CASE WHEN EXISTS(SELECT 1 FROM e04_310_02_vw) THEN 1 ELSE 0 END, 'no rows = healthy' UNION ALL SELECT 'foreign_keys_off', CASE WHEN (SELECT foreign_keys FROM pragma_foreign_keys) = 0 THEN 0 ELSE 1 END, '0 = healthy';
