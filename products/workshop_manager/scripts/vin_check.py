#!/usr/bin/env python3
"""vin_check.py — اعتبارسنجی 17-char VIN (ISO 3779)."""
import sys
VALID = set("ABCDEFGHJKLMNPRSTUVWXYZ0123456789")
def validate(v):
    if not v or len(v) != 17: return False, "length"
    if any(c not in VALID for c in v.upper()): return False, "charset"
    return True, "ok"
if __name__ == "__main__":
    v = sys.argv[1] if len(sys.argv)>1 else "1HGBH41JXMN109186"
    ok, reason = validate(v)
    print(f"VIN {v}: {reason} ({'valid' if ok else 'invalid'})")
