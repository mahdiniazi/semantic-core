#!/usr/bin/env python3
"""ranker.py — رتبه‌بندی فرضیه‌ها بر اساس شواهد."""
def rank(hypotheses):
    scored = []
    for h in hypotheses:
        sup = h.get("supports", 0); con = h.get("contradicts", 0)
        scored.append({**h, "score": sup - con})
    return sorted(scored, key=lambda x: -x["score"])
if __name__ == "__main__":
    h = [{"name":"coil-open","supports":1,"contradicts":1},{"name":"injector","supports":2,"contradicts":0}]
    for r in rank(h): print(r)
