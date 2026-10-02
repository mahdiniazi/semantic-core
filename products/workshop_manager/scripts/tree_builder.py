#!/usr/bin/env python3
"""tree_builder.py — ساخت درخت عیب‌یابی از manifests_as."""
import sys, os, json
sys.path.insert(0, os.path.dirname(__file__))
from _common import sc_conn
def build(dtc):
    c = sc_conn()
    try:
        rows = c.execute("""
            SELECT sub.ent_uid AS failure_mode, sub.label
            FROM e01_222_01_tb r
            JOIN e01_202_01_tb rt ON r.reltype_id=rt.reltype_id
            JOIN e01_200_03_tb sub ON r.subj_ent_id=sub.ent_id
            JOIN e01_200_03_tb obj ON r.obj_ent_id=obj.ent_id
            WHERE rt.type_uid='manifests_as' AND obj.ent_uid=?
        """, (f"dtc:{dtc.upper()}",)).fetchall()
        return [{"failure_mode": r[0], "label": r[1]} for r in rows]
    finally: c.close()
if __name__ == "__main__":
    dtc = sys.argv[1] if len(sys.argv)>1 else "P0301"
    print(json.dumps(build(dtc), ensure_ascii=False, indent=2))
