-- v71 — بازبینی کامل قطعات مشترک
.mode column
.headers on

SELECT '═══ ۱. قطعات هر کلاس (has_part) ═══' AS section;

SELECT 
  src.ent_uid AS class,
  obj.ent_uid AS part,
  obj.label AS label
FROM e01_222_01_tb r
JOIN e01_202_01_tb rt ON rt.reltype_id = r.reltype_id AND rt.type_uid='has_part'
JOIN e01_200_03_tb src ON src.ent_id = r.subj_ent_id
JOIN e01_200_03_tb obj ON obj.ent_id = r.obj_ent_id
WHERE src.ent_uid IN (
  'concept:vehicle','concept:passenger-car','concept:motorcycle',
  'concept:truck','concept:bus','concept:ev','concept:pickup',
  'concept:police','concept:ambulance','concept:fire-truck',
  'concept:bus-fire-truck','concept:delivery-van','concept:tanker',
  'concept:tow-truck','concept:garbage-truck','concept:rescue',
  'concept:taxi','concept:passenger-van','concept:minibus','concept:van'
)
ORDER BY src.ent_uid, obj.ent_uid;

SELECT '═══ ۲. شمارش هر کلاس ═══' AS section;

SELECT 
  src.ent_uid AS class,
  COUNT(*) AS n_parts
FROM e01_222_01_tb r
JOIN e01_202_01_tb rt ON rt.reltype_id = r.reltype_id AND rt.type_uid='has_part'
JOIN e01_200_03_tb src ON src.ent_id = r.subj_ent_id
WHERE src.ent_uid LIKE 'concept:%'
GROUP BY src.ent_uid
ORDER BY n_parts DESC;

SELECT '═══ ۳. قطعاتی که هیچ کلاسی به آن‌ها وصل نیست ═══' AS section;

SELECT 
  e.ent_uid AS concept,
  e.label,
  t.type_uid AS type
FROM e01_200_03_tb e
JOIN e01_200_01_tb t ON t.type_id = e.type_id
WHERE e.ent_uid LIKE 'concept:%'
  -- انواعی که فقط قطعه هستند، نه خودرو
  AND t.type_uid IN (
    'Battery','LeadAcidBattery','LithiumIonBattery','Alternator','Fuse','Relay','Wiring',
    'StarterMotor','StarterRelay','IgnitionSwitch','IgnitionCoil','SparkPlug','IgnitionModule',
    'VoltageRegulator','ChargeIndicator','EngineECU','TransmissionECU','BodyECU','ABS_ECU',
    'CrankshaftSensor','CamshaftSensor','MAPSensor','CoolantTempSensor','O2Sensor',
    'KnockSensor','ThrottlePositionSensor','MassAirFlowSensor','IntakeAirTempSensor','BarometricPressureSensor',
    'FuelLevelSensor','FuelPressureSensor','OilPressureSensor','OilTempSensor','VehicleSpeedSensor',
    'WheelSpeedSensor','EGRPositionSensor','TurboBoostSensor','UpstreamO2Sensor','DownstreamO2Sensor',
    'ThrottleActuator','IdleAirControlValve','Injector','FuelPump','EGRValve','VVTSolenoid',
    'TurboWastegate','EVAPPurgeValve','CoolingFanMotor','Horn','WiperMotor','WindowMotor',
    'DoorLockActuator','MirrorMotor','FuelPumpRelay','CoolingFanRelay','ACCompressorClutch',
    'BrakeMasterCylinder','BrakeBooster','BrakeDisc','BrakePad','BrakeCaliper','BrakeFluid','BrakeLine',
    'SteeringWheel','SteeringColumn','SteeringRack','PowerSteeringPump','TieRod',
    'CoilSpring','ShockAbsorber','ControlArm','BallJoint','Bushing',
    'ACCompressor','ACCondenser','ACExpansionValve','ACRefrigerant','BlowerMotor','CabinAirFilter','HeaterCore',
    'HeadlightLow','HeadlightHigh','TailLight','BrakeLight','TurnSignal','ReverseLight','FogLight',
    'LicensePlateLight','InteriorLight','DashLight','HeadlightRelay','HeadlightFuse',
    'CANBus','LINBus','FlexRayBus','AutomotiveEthernet',
    'TractionMotor','Inverter','BatteryPack','BatteryModule','BatteryCell','OnboardCharger',
    'ChargingPort','BMS','DCDCConverter','RegenerativeBrake','ThermalManagement','HighVoltageCable',
    'WarningLight','Siren','HydraulicLift','WheelchairRamp','FirePump','Ladder','Reefer','Tank'
  )
  -- آنهایی که در هیچ has_part نیستند
  AND e.ent_id NOT IN (
    SELECT obj.ent_id 
    FROM e01_222_01_tb r
    JOIN e01_202_01_tb rt ON rt.reltype_id = r.reltype_id AND rt.type_uid='has_part'
    JOIN e01_200_03_tb obj ON obj.ent_id = r.obj_ent_id
  )
ORDER BY t.type_uid, e.ent_uid;
