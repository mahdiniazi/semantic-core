.mode column
.headers on

BEGIN;

INSERT OR IGNORE INTO e01_200_01_tb (type_uid, label, is_abstract, parent_id)
VALUES 
  ('PhysicalQuantity',    'کمیت فیزیکی',  1, (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Attribute')),
  ('QualitativeProperty', 'ویژگی کیفی',   1, (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Attribute')),
  ('Identifier',          'شناسه',        1, (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Attribute'));

INSERT OR IGNORE INTO e01_200_01_tb (type_uid, label, is_abstract, parent_id)
VALUES 
  ('BaseQuantity',    'کمیت پایه',  1, (SELECT type_id FROM e01_200_01_tb WHERE type_uid='PhysicalQuantity')),
  ('DerivedQuantity', 'کمیت مشتق',  1, (SELECT type_id FROM e01_200_01_tb WHERE type_uid='PhysicalQuantity'));

UPDATE e01_200_01_tb SET is_abstract = 1 WHERE type_uid = 'Attribute';

INSERT OR IGNORE INTO e01_200_03_tb (ent_uid, type_id, nature, label, description, prv_id)
VALUES 
  ('physical-quantity',    (SELECT type_id FROM e01_200_01_tb WHERE type_uid='PhysicalQuantity'),    'concept', 'کمیت فیزیکی',  'Root of physical quantities', 2),
  ('qualitative-property', (SELECT type_id FROM e01_200_01_tb WHERE type_uid='QualitativeProperty'), 'concept', 'ویژگی کیفی',   'Root of qualitative properties', 2),
  ('identifier',           (SELECT type_id FROM e01_200_01_tb WHERE type_uid='Identifier'),          'concept', 'شناسه',        'Root of identifiers', 2),
  ('base-quantity',        (SELECT type_id FROM e01_200_01_tb WHERE type_uid='BaseQuantity'),        'concept', 'کمیت پایه',    'Root of base quantities', 2),
  ('derived-quantity',     (SELECT type_id FROM e01_200_01_tb WHERE type_uid='DerivedQuantity'),     'concept', 'کمیت مشتق',    'Root of derived quantities', 2);

UPDATE e01_200_03_tb SET type_id = (SELECT type_id FROM e01_200_01_tb WHERE type_uid='BaseQuantity')    WHERE ent_uid='attribute:temperature';
UPDATE e01_200_03_tb SET type_id = (SELECT type_id FROM e01_200_01_tb WHERE type_uid='DerivedQuantity') WHERE ent_uid='attribute:voltage';
UPDATE e01_200_03_tb SET type_id = (SELECT type_id FROM e01_200_01_tb WHERE type_uid='DerivedQuantity') WHERE ent_uid='attribute:pressure';
UPDATE e01_200_03_tb SET type_id = (SELECT type_id FROM e01_200_01_tb WHERE type_uid='DerivedQuantity') WHERE ent_uid='attribute:rpm';
UPDATE e01_200_03_tb SET type_id = (SELECT type_id FROM e01_200_01_tb WHERE type_uid='DerivedQuantity') WHERE ent_uid='attribute:humidity';

UPDATE e01_200_03_tb SET label = 'اختلاف پتانسیل الکتریکی', description = 'Electric potential difference' WHERE ent_uid='attribute:voltage';

DELETE FROM e01_222_01_tb 
WHERE reltype_id = (SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='instance_of')
  AND subj_ent_id IN (SELECT ent_id FROM e01_200_03_tb WHERE ent_uid IN ('attribute:temperature','attribute:voltage','attribute:pressure','attribute:rpm','attribute:humidity'));

INSERT OR IGNORE INTO e01_222_01_tb (rel_uid, reltype_id, subj_ent_id, obj_ent_id, status, prv_id) VALUES
('r:temperature-instance-of-base-quantity',(SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='instance_of'),(SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='attribute:temperature'),(SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='base-quantity'),'asserted', 2),
('r:voltage-instance-of-derived-quantity',(SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='instance_of'),(SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='attribute:voltage'),(SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='derived-quantity'),'asserted', 2),
('r:pressure-instance-of-derived-quantity',(SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='instance_of'),(SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='attribute:pressure'),(SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='derived-quantity'),'asserted', 2),
('r:rpm-instance-of-derived-quantity',(SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='instance_of'),(SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='attribute:rpm'),(SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='derived-quantity'),'asserted', 2),
('r:humidity-instance-of-derived-quantity',(SELECT reltype_id FROM e01_202_01_tb WHERE type_uid='instance_of'),(SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='attribute:humidity'),(SELECT ent_id FROM e01_200_03_tb WHERE ent_uid='derived-quantity'),'asserted', 2);

INSERT OR IGNORE INTO e01_200_04_tb (type_id, target_uid, placement_kind, is_default, note) VALUES
((SELECT type_id FROM e01_200_01_tb WHERE type_uid='PhysicalQuantity'),'concept:vehicle','inherent_to',1,'rule'),
((SELECT type_id FROM e01_200_01_tb WHERE type_uid='QualitativeProperty'),'concept:vehicle','inherent_to',1,'rule'),
((SELECT type_id FROM e01_200_01_tb WHERE type_uid='Identifier'),'concept:vehicle','inherent_to',1,'rule'),
((SELECT type_id FROM e01_200_01_tb WHERE type_uid='BaseQuantity'),'concept:vehicle','inherent_to',1,'rule'),
((SELECT type_id FROM e01_200_01_tb WHERE type_uid='DerivedQuantity'),'concept:vehicle','inherent_to',1,'rule');

INSERT OR IGNORE INTO e01_676_01_tb (migration_uid, notes) VALUES ('v157_attribute_hierarchy','Created Attribute sub-hierarchy');

UPDATE e01_676_02_tb SET schema_ver = schema_ver + 1 WHERE id = 1;

COMMIT;
