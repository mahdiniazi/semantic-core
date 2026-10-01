INSERT INTO e01_201_02_tb (value_kind, num_val, unit, prv_id) VALUES
('number', 12.0, 'V', 2),
('number', 12.0, 'V', 2),
('number', 12.0, 'V', 2),
('number', 12.0, 'V', 2),
('number', 14.5, 'V', 2),
('number', 14.5, 'V', 2),
('number', 0.8, 'O', 2),
('number', 0.8, 'O', 2),
('number', 3.5, 'bar', 2),
('number', 3.0, 'bar', 2),
('number', 90.0, 'C', 2),
('number', 105.0, 'C', 2),
('number', 0.5, 'V', 2),
('number', 4.5, 'V', 2),
('number', 0.1, 'V', 2),
('number', 0.9, 'V', 2),
('number', 850.0, 'kg', 2),
('number', 1050.0, 'kg', 2),
('number', 1250.0, 'kg', 2);

INSERT INTO e01_222_01_tb (rel_uid, reltype_id, subj_ent_id, obj_val_id, status, prv_id)
VALUES
('r:battery-pride-voltage',(SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='has_voltage'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='battery:pride-66ah'),
 (SELECT val_id FROM e01_201_02_tb WHERE num_val=12.0 LIMIT 1),'asserted',2),
('r:battery-206-voltage',(SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='has_voltage'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='battery:206-60ah'),
 (SELECT val_id FROM e01_201_02_tb WHERE num_val=12.0 LIMIT 1 OFFSET 1),'asserted',2),
('r:battery-dena-voltage',(SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='has_voltage'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='battery:dena-74ah'),
 (SELECT val_id FROM e01_201_02_tb WHERE num_val=12.0 LIMIT 1 OFFSET 2),'asserted',2),
('r:alternator-pride-voltage',(SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='has_voltage'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='alternator:pride-70a'),
 (SELECT val_id FROM e01_201_02_tb WHERE num_val=14.5 LIMIT 1),'asserted',2),
('r:coil-pride-resistance',(SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='has_resistance'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='coil:pride-double'),
 (SELECT val_id FROM e01_201_02_tb WHERE num_val=0.8 LIMIT 1),'asserted',2),
('r:coil-206-resistance',(SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='has_resistance'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='coil:206-double'),
 (SELECT val_id FROM e01_201_02_tb WHERE num_val=0.8 LIMIT 1 OFFSET 1),'asserted',2),
('r:maf-pride-idle',(SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='has_voltage'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='sensor:pride-maf'),
 (SELECT val_id FROM e01_201_02_tb WHERE num_val=0.5 LIMIT 1),'asserted',2),
('r:o2-pride-voltage',(SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='has_voltage'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='sensor:pride-o2'),
 (SELECT val_id FROM e01_201_02_tb WHERE num_val=0.9 LIMIT 1),'asserted',2),
('r:vehicle-pride-weight',(SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='has_quantity'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='vehicle:pride-1'),
 (SELECT val_id FROM e01_201_02_tb WHERE num_val=850.0 LIMIT 1),'asserted',2),
('r:vehicle-206-weight',(SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='has_quantity'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='vehicle:206-1'),
 (SELECT val_id FROM e01_201_02_tb WHERE num_val=1050.0 LIMIT 1),'asserted',2),
('r:vehicle-dena-weight',(SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='has_quantity'),
 (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='vehicle:dena-1'),
 (SELECT val_id FROM e01_201_02_tb WHERE num_val=1250.0 LIMIT 1),'asserted',2);

UPDATE e01_676_02_tb SET schema_ver = schema_ver + 1 WHERE id = 1;

SELECT 'values' AS k, COUNT(*) AS n FROM e01_201_02_tb
UNION ALL SELECT 'value_relations', COUNT(*) FROM e01_222_01_tb WHERE obj_val_id IS NOT NULL
UNION ALL SELECT 'relations_total', COUNT(*) FROM e01_222_01_tb;
