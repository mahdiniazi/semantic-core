#!/usr/bin/env python3
"""step_timing.py — ثبت و گزارش زمان هر گام."""
import time, json, sys, os
sys.path.insert(0, os.path.dirname(__file__))
from _common import wm_conn, now
def record(repair_id, step, secs):
    conn = wm_conn()
    try:
        conn.execute("CREATE TABLE IF NOT EXISTS step_times(id INTEGER PRIMARY KEY, repair_id INTEGER, step TEXT, secs REAL, at TEXT)")
        conn.execute("INSERT INTO step_times(repair_id, step, secs, at) VALUES(?,?,?,?)", (repair_id, step, secs, now()))
        conn.commit()
    finally: conn.close()
if __name__ == "__main__":
    record(1, "read_dtc", 4.5); print("recorded")
