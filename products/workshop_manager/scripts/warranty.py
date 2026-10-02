#!/usr/bin/env python3
"""warranty.py — منطق گارانتی قطعه و خدمات."""
import datetime as dt
DEFAULT_PART_DAYS = 180; DEFAULT_SERVICE_DAYS = 90
def check(sold_at, kind="part", now=None):
    now = now or dt.datetime.now()
    days = DEFAULT_PART_DAYS if kind=="part" else DEFAULT_SERVICE_DAYS
    exp = sold_at + dt.timedelta(days=days)
    return {"kind": kind, "expires_at": exp.date().isoformat(), "valid": now < exp, "days_left": (exp-now).days if now<exp else 0}
if __name__ == "__main__":
    sold = dt.datetime(2026,8,1)
    print("part:", check(sold, "part"))
    print("service:", check(sold, "service"))
