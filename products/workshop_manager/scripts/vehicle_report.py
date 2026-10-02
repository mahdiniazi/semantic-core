#!/usr/bin/env python3
"""vehicle_report.py — گزارش تجمیعی خودرو."""
import sys, os
sys.path.insert(0, os.path.dirname(__file__))
from cross_branch import search
def report(vin):
    entries = search(vin)
    return {"vin": vin, "total_entries": len(entries), "branches": list({e[0] for e in entries}), "history": entries}
if __name__ == "__main__":
    import json
    print(json.dumps(report(sys.argv[1] if len(sys.argv)>1 else "TEST"), ensure_ascii=False, indent=2))
