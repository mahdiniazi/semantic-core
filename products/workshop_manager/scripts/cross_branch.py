#!/usr/bin/env python3
"""cross_branch.py — جستجوی سوابق در همه شعبات."""
import sys, os
sys.path.insert(0, os.path.dirname(__file__))
from _common import wm_conn
def search(vin):
    conn = wm_conn()
    try:
        conn.execute("CREATE TABLE IF NOT EXISTS branch_network(id INTEGER PRIMARY KEY, branch TEXT, vin TEXT, entry_at TEXT)")
        rows = conn.execute("SELECT branch, entry_at FROM branch_network WHERE vin=? ORDER BY entry_at DESC", (vin,)).fetchall()
        return rows
    finally: conn.close()
if __name__ == "__main__": print(search(sys.argv[1] if len(sys.argv)>1 else "TEST"))
