#!/usr/bin/env python3
"""sc_bridge.py — پل به semantic_core.db (read-only)."""
import sys, os
sys.path.insert(0, os.path.dirname(__file__))
from _common import sc_conn
def get_stats():
    c = sc_conn()
    try:
        return {
            "types": c.execute("SELECT COUNT(*) FROM e01_200_01_tb").fetchone()[0],
            "entities": c.execute("SELECT COUNT(*) FROM e01_200_03_tb").fetchone()[0],
            "relations": c.execute("SELECT COUNT(*) FROM e01_222_01_tb").fetchone()[0]
        }
    finally: c.close()
if __name__ == "__main__": print(get_stats())
