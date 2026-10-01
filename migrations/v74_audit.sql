.mode column
.headers on

SELECT '=== پوشش زیرسیستم‌ها ===' AS section;

SELECT '۱. برق تأمین' AS subsystem, COUNT(DISTINCT obj.ent_id) AS n
FROM e01_222_01_tb r
JOIN e01_202_01_tb rt ON rt.reltype_id = r.reltype_id AND rt.type_uid='has_part'
JOIN e01_200_03_tb obj ON obj.ent_id = r.obj_ent_id
WHERE obj.ent_uid IN ('concept:battery','concept:alternator','concept:starter','concept:fuse','concept:relay','concept:wiring')
UNION ALL SELECT '۲. جرقه‌زنی', COUNT(DISTINCT obj.ent_id)
FROM e01_222_01_tb r
JOIN e01_202_01_tb rt ON rt.reltype_id = r.reltype_id AND rt.type_uid='has_part'
JOIN e01_200_03_tb obj ON obj.ent_id = r.obj_ent_id
WHERE obj.ent_uid IN ('concept:ignition-coil','concept:spark-plug')
UNION ALL SELECT '۳. سوخت‌رسانی', COUNT(DISTINCT obj.ent_id)
FROM e01_222_01_tb r
JOIN e01_202_01_tb rt ON rt.reltype_id = r.reltype_id AND rt.type_uid='has_part'
JOIN e01_200_03_tb obj ON obj.ent_id = r.obj_ent_id
WHERE obj.ent_uid IN ('concept:fuel-pump','concept:injector')
UNION ALL SELECT '۴. ترمز', COUNT(DISTINCT obj.ent_id)
FROM e01_222_01_tb r
JOIN e01_202_01_tb rt ON rt.reltype_id = r.reltype_id AND rt.type_uid='has_part'
JOIN e01_200_03_tb obj ON obj.ent_id = r.obj_ent_id
WHERE obj.ent_uid LIKE 'concept:brake-%'
UNION ALL SELECT '۵. فرمان', COUNT(DISTINCT obj.ent_id)
FROM e01_222_01_tb r
JOIN e01_202_01_tb rt ON rt.reltype_id = r.reltype_id AND rt.type_uid='has_part'
JOIN e01_200_03_tb obj ON obj.ent_id = r.obj_ent_id
WHERE obj.ent_uid LIKE 'concept:steering-%' OR obj.ent_uid IN ('concept:power-steering','concept:tie-rod')
UNION ALL SELECT '۶. تعلیق', COUNT(DISTINCT obj.ent_id)
FROM e01_222_01_tb r
JOIN e01_202_01_tb rt ON rt.reltype_id = r.reltype_id AND rt.type_uid='has_part'
JOIN e01_200_03_tb obj ON obj.ent_id = r.obj_ent_id
WHERE obj.ent_uid IN ('concept:coil-spring','concept:shock-absorber','concept:control-arm','concept:ball-joint','concept:bushing')
UNION ALL SELECT '۷. تهویه', COUNT(DISTINCT obj.ent_id)
FROM e01_222_01_tb r
JOIN e01_202_01_tb rt ON rt.reltype_id = r.reltype_id AND rt.type_uid='has_part'
JOIN e01_200_03_tb obj ON obj.ent_id = r.obj_ent_id
WHERE obj.ent_uid LIKE 'concept:ac-%' OR obj.ent_uid IN ('concept:blower-motor','concept:cabin-filter','concept:heater-core')
UNION ALL SELECT '۸. روشنایی', COUNT(DISTINCT obj.ent_id)
FROM e01_222_01_tb r
JOIN e01_202_01_tb rt ON rt.reltype_id = r.reltype_id AND rt.type_uid='has_part'
JOIN e01_200_03_tb obj ON obj.ent_id = r.obj_ent_id
WHERE obj.ent_uid LIKE 'concept:%light%' OR obj.ent_uid LIKE 'concept:turn-signal'
UNION ALL SELECT '۹. سنسورها', COUNT(DISTINCT obj.ent_id)
FROM e01_222_01_tb r
JOIN e01_202_01_tb rt ON rt.reltype_id = r.reltype_id AND rt.type_uid='has_part'
JOIN e01_200_03_tb obj ON obj.ent_id = r.obj_ent_id
WHERE obj.ent_uid LIKE 'concept:%-sensor' OR obj.ent_uid IN ('concept:tps','concept:crankshaft-sensor','concept:coolant-sensor')
UNION ALL SELECT '۱۰. کنترل', COUNT(DISTINCT obj.ent_id)
FROM e01_222_01_tb r
JOIN e01_202_01_tb rt ON rt.reltype_id = r.reltype_id AND rt.type_uid='has_part'
JOIN e01_200_03_tb obj ON obj.ent_id = r.obj_ent_id
WHERE obj.ent_uid LIKE 'concept:%ecu' OR obj.ent_uid LIKE 'concept:%-actuator' OR obj.ent_uid IN ('concept:injector','concept:throttle-actuator')
UNION ALL SELECT '۱۱. EV', COUNT(DISTINCT obj.ent_id)
FROM e01_222_01_tb r
JOIN e01_202_01_tb rt ON rt.reltype_id = r.reltype_id AND rt.type_uid='has_part'
JOIN e01_200_03_tb obj ON obj.ent_id = r.obj_ent_id
WHERE obj.ent_uid IN ('concept:traction-motor','concept:inverter','concept:battery-pack','concept:onboard-charger','concept:charging-port','concept:bms','concept:dcdc','concept:regen-brake','concept:thermal-mgmt','concept:hv-cable')

SELECT '=== زیرسیستم‌های گمشده ===' AS section;
SELECT 'ABS' AS missing WHERE NOT EXISTS (SELECT 1 FROM e01_200_03_tb WHERE ent_uid='concept:abs-ecu')
UNION ALL SELECT 'گیربکس' WHERE NOT EXISTS (SELECT 1 FROM e01_200_03_tb WHERE ent_uid='concept:transmission')
UNION ALL SELECT 'کلاچ' WHERE NOT EXISTS (SELECT 1 FROM e01_200_03_tb WHERE ent_uid='concept:clutch')
UNION ALL SELECT 'رادیاتور' WHERE NOT EXISTS (SELECT 1 FROM e01_200_03_tb WHERE ent_uid='concept:radiator')
UNION ALL SELECT 'واتر پمپ' WHERE NOT EXISTS (SELECT 1 FROM e01_200_03_tb WHERE ent_uid='concept:water-pump')
UNION ALL SELECT 'ترموستات' WHERE NOT EXISTS (SELECT 1 FROM e01_200_03_tb WHERE ent_uid='concept:thermostat')
UNION ALL SELECT 'کاتالیست' WHERE NOT EXISTS (SELECT 1 FROM e01_200_03_tb WHERE ent_uid='concept:catalytic-converter')
UNION ALL SELECT 'اگزوز' WHERE NOT EXISTS (SELECT 1 FROM e01_200_03_tb WHERE ent_uid='concept:muffler')
UNION ALL SELECT 'ایربگ' WHERE NOT EXISTS (SELECT 1 FROM e01_200_03_tb WHERE ent_uid='concept:airbag')
UNION ALL SELECT 'سیستم صوتی' WHERE NOT EXISTS (SELECT 1 FROM e01_200_03_tb WHERE ent_uid='concept:infotainment')
UNION ALL SELECT 'کروز کنترل' WHERE NOT EXISTS (SELECT 1 FROM e01_200_03_tb WHERE ent_uid='concept:cruise-control')
UNION ALL SELECT 'سنسور دنده عقب' WHERE NOT EXISTS (SELECT 1 FROM e01_200_03_tb WHERE ent_uid='concept:parking-sensor')
UNION ALL SELECT 'دوربین دنده عقب' WHERE NOT EXISTS (SELECT 1 FROM e01_200_03_tb WHERE ent_uid='concept:reverse-camera')
UNION ALL SELECT 'توربو' WHERE NOT EXISTS (SELECT 1 FROM e01_200_03_tb WHERE ent_uid='concept:turbocharger')
UNION ALL SELECT 'مخزن سوخت' WHERE NOT EXISTS (SELECT 1 FROM e01_200_03_tb WHERE ent_uid='concept:fuel-tank')
UNION ALL SELECT 'لاستیک' WHERE NOT EXISTS (SELECT 1 FROM e01_200_03_tb WHERE ent_uid='concept:tire')
UNION ALL SELECT 'چرخ' WHERE NOT EXISTS (SELECT 1 FROM e01_200_03_tb WHERE ent_uid='concept:wheel')
UNION ALL SELECT 'TPMS' WHERE NOT EXISTS (SELECT 1 FROM e01_200_03_tb WHERE ent_uid='concept:tpms-sensor')
UNION ALL SELECT 'صندلی' WHERE NOT EXISTS (SELECT 1 FROM e01_200_03_tb WHERE ent_uid='concept:seat')
UNION ALL SELECT 'کمربند' WHERE NOT EXISTS (SELECT 1 FROM e01_200_03_tb WHERE ent_uid='concept:seatbelt')
UNION ALL SELECT 'شیشه جلو' WHERE NOT EXISTS (SELECT 1 FROM e01_200_03_tb WHERE ent_uid='concept:windshield')
UNION ALL SELECT 'آینه' WHERE NOT EXISTS (SELECT 1 FROM e01_200_03_tb WHERE ent_uid='concept:mirror')
UNION ALL SELECT 'در' WHERE NOT EXISTS (SELECT 1 FROM e01_200_03_tb WHERE ent_uid='concept:door')
UNION ALL SELECT 'چراغ هشدار موتور' WHERE NOT EXISTS (SELECT 1 FROM e01_200_03_tb WHERE ent_uid='concept:check-engine-light');
