-- workshop schema
CREATE TABLE IF NOT EXISTS vehicle(id INTEGER PRIMARY KEY, vin TEXT UNIQUE, model TEXT, year INT, created_at TEXT DEFAULT CURRENT_TIMESTAMP);
CREATE TABLE IF NOT EXISTS customer(id INTEGER PRIMARY KEY, name TEXT, phone TEXT, created_at TEXT DEFAULT CURRENT_TIMESTAMP);
CREATE TABLE IF NOT EXISTS reception(id INTEGER PRIMARY KEY, vehicle_id INT, customer_id INT, symptom TEXT, accepted_at TEXT DEFAULT CURRENT_TIMESTAMP, FOREIGN KEY(vehicle_id) REFERENCES vehicle(id), FOREIGN KEY(customer_id) REFERENCES customer(id));
CREATE TABLE IF NOT EXISTS repair_history(id INTEGER PRIMARY KEY, vin TEXT, branch TEXT, entry_at TEXT, exit_at TEXT, description TEXT);
CREATE TABLE IF NOT EXISTS branch_network(id INTEGER PRIMARY KEY, branch TEXT, vin TEXT, entry_at TEXT);
CREATE TABLE IF NOT EXISTS step_times(id INTEGER PRIMARY KEY, repair_id INTEGER, step TEXT, secs REAL, at TEXT);
CREATE TABLE IF NOT EXISTS warranty(id INTEGER PRIMARY KEY, vin TEXT, kind TEXT, sold_at TEXT, expires_at TEXT);
CREATE TABLE IF NOT EXISTS pricing(id INTEGER PRIMARY KEY, repair_id INTEGER, part_cost REAL, labor_cost REAL, time_minutes INT);
CREATE INDEX IF NOT EXISTS ix_vehicle_vin ON vehicle(vin);
CREATE INDEX IF NOT EXISTS ix_history_vin ON repair_history(vin);
CREATE INDEX IF NOT EXISTS ix_branch_vin ON branch_network(vin);
CREATE INDEX IF NOT EXISTS ix_reception_vehicle ON reception(vehicle_id);
