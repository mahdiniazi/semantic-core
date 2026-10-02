#!/usr/bin/env python3
"""assign.py — تخصیص تسک به سطح مناسب."""
from skill_levels import classify
def assign(task):
    lvl = classify(task.get("type","mechanical"))
    return {"task": task.get("name"), "assigned_to": f"L{lvl}"}
if __name__ == "__main__":
    for t in [{"name":"تعویض شمع","type":"mechanical"},{"name":"خواندن DTC","type":"read"},{"name":"تصمیم نهایی","type":"decision"}]:
        print(assign(t))
