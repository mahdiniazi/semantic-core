.mode column
.headers on

SELECT 
  parent.type_uid AS parent_type,
  child.type_uid  AS child_type,
  parent.label    AS parent_label,
  child.label     AS child_label
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
ORDER BY parent.type_uid, child.type_uid;
