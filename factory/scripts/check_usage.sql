.mode column
.headers on

SELECT 
  'parent_id in types' AS usage,
  COUNT(*) AS n
FROM e01_200_01_tb
WHERE parent_id IN (
  SELECT type_id FROM e01_200_01_tb
  WHERE type_uid IN (
    'ActuatorSystem','AlternatorSystem','BatterySystem','BrakingSystem',
    'BusSystem','ChargingSystem','ControlCommSystem','ECUSystem','EESystem',
    'FuseBoxSystem','HVACSystem','IgnitionCoilSystem','IgnitionSwitchSystem',
    'IgnitionSystem','LightingSystem','PowerSupplySystem','RelaySystem',
    'SensorSystem','SparkPlugSystem','StarterMotorSystem','StartingSystem',
    'SteeringSystem','SuspensionSystem','VoltageRegulatorSystem','WiringSystem',
    'FiatDucato2','RefrigeratedTruckClass'
  )
)
UNION ALL
SELECT 'reference in 112_tb', COUNT(*)
FROM e01_112_01_tb
WHERE target_type_id IN (
  SELECT type_id FROM e01_200_01_tb
  WHERE type_uid IN ('FiatDucato2','RefrigeratedTruckClass')
)
UNION ALL
SELECT 'total candidates', COUNT(*)
FROM e01_200_01_tb
WHERE type_uid IN (
  'ActuatorSystem','AlternatorSystem','BatterySystem','BrakingSystem',
  'BusSystem','ChargingSystem','ControlCommSystem','ECUSystem','EESystem',
  'FuseBoxSystem','HVACSystem','IgnitionCoilSystem','IgnitionSwitchSystem',
  'IgnitionSystem','LightingSystem','PowerSupplySystem','RelaySystem',
  'SensorSystem','SparkPlugSystem','StarterMotorSystem','StartingSystem',
  'SteeringSystem','SuspensionSystem','VoltageRegulatorSystem','WiringSystem',
  'FiatDucato2','RefrigeratedTruckClass'
);
