#!/usr/bin/env python3
"""dtc_api.py — جستجوی DTC در semantic_core.db."""
import sys, os
sys.path.insert(0, os.path.dirname(__file__))
from _common import sc_conn
def find_dtc(code):
    c = sc_conn()
    try:
        rows = c.execute("""
            SELECT r.rel_uid, rt.type_uid AS reltype, sub.ent_uid AS subj, obj.ent_uid AS obj
            FROM e01_222_01_tb r
            JOIN e01_202_01_tb rt ON r.reltype_id=rt.reltype_id
            JOIN e01_200_03_tb sub ON r.subj_ent_id=sub.ent_id
            LEFT JOIN e01_200_03_tb obj ON r.obj_ent_id=obj.ent_id
            WHERE r.rel_uid LIKE ?
        """, (f"%{code.lower()}%",)).fetchall()
        return rows
    finally: c.close()
if __name__ == "__main__":
    code = sys.argv[1] if len(sys.argv)>1 else "p0301"
    for r in find_dtc(code): print(dict(r))
