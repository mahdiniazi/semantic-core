#!/usr/bin/env python3
"""barcode.py — پردازش بارکد خودرو."""
import sys, re
def parse(code):
    if not code or len(code) < 4: return None
    return {"raw": code, "type": "vin" if len(code)==17 else "barcode"}
if __name__ == "__main__":
    print(parse(sys.argv[1] if len(sys.argv)>1 else "1HGBH41JXMN109186"))
