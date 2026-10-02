#!/usr/bin/env python3
"""history.py — بازیابی سوابق خودرو از workshop.db."""
import sys, os
sys.path.insert(0, os.path.dirname(__file__))
from _common import wm_conn
def history(vin):
    conn = wm_conn()
    try:
        rows = conn.execute("SELECT * FROM repair_history WHERE vin=?", (vin,)).fetchall()
        return rows
    except Exception as e: return [("error", str(e))]
if __name__ == "__main__":
    vin = sys.argv[1] if len(sys.argv)>1 else "TEST"
    print(f"History for {vin}: {history(vin)}")
