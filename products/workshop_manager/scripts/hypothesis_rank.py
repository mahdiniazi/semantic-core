#!/usr/bin/env python3
"""hypothesis_rank.py — امتیازدهی جامع فرضیه."""
def score(h):
    return (h.get("supports",0)*2) - (h.get("contradicts",0)*3) - (h.get("ruled_out",0)*10) + h.get("prior",0)*0.5
def rank_all(hs): return sorted(hs, key=score, reverse=True)
if __name__ == "__main__":
    for h in rank_all([{"name":"coil","supports":1,"contradicts":1,"prior":0.7},{"name":"injector","supports":2,"prior":0.3}]): print(h)
