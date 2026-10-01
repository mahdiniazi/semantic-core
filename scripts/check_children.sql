.mode column
.headers on

SELECT 
  parent.type_uid AS parent,
  COUNT(*) AS n_children
FROM e01_200_01_tb child
JOIN e01_200_01_tb parent ON parent.type_id = child.parent_id
WHERE parent.type_uid IN (
  'ActuatorSystem','AlternatorSystem','BatterySystem','BrakingSystem',
  'BusSystem','ChargingSystem','ControlCommSystem','ECUSystem','EESystem',
  'FuseBoxSystem','HVACSystem','IgnitionCoilSystem','IgnitionSwitchSystem',
  'IgnitionSystem','LightingSystem','PowerSupplySystem','RelaySystem',
  'SensorSystem','SparkPlugSystem','StarterMotorSystem','StartingSystem',
  'SteeringSystem','SuspensionSystem','VoltageRegulatorSystem','WiringSystem'
)
GROUP BY parent.type_id
ORDER BY parent.type_uid;
