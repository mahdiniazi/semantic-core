"""Common utilities for workshop scripts."""
import sqlite3, os, json, datetime

DB_PATH = os.path.join(os.path.dirname(__file__), "..", "db", "workshop.db")
SC_PATH = os.path.expanduser("~/semantic_core/products/semantic_core/db/semantic_core.db")

def wm_conn(): return sqlite3.connect(DB_PATH)
def sc_conn():
    c = sqlite3.connect(f"file:{SC_PATH}?mode=ro", uri=True)
    c.row_factory = sqlite3.Row
    return c

def now(): return datetime.datetime.now().isoformat(timespec="seconds")
