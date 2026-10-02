#!/usr/bin/env python3
"""pricing.py — محاسبه قیمت شفاف."""
def total(part, labor, time_minutes, labor_rate=200000):
    labor_cost = (time_minutes / 60) * labor_rate
    return {"part": part, "labor_base": labor, "labor_time": round(labor_cost), "total": part + labor + round(labor_cost)}
if __name__ == "__main__":
    for p,l,t in [(500000, 200000, 30), (2000000, 500000, 60)]:
        print(total(p,l,t))
