#!/usr/bin/env python3
"""skill_levels.py — سه سطح مهارتی تعمیرگاه."""
LEVELS = {
    1: {"name": "ساده", "examples": ["تعویض شمع","باز کردن پیچ","تمیز کردن"]},
    2: {"name": "فنی", "examples": ["اندازه‌گیری ولتاژ","خواندن DTC","دیاگ"]},
    3: {"name": "تشخیص نهایی", "examples": ["تصمیم علت اصلی","انتخاب مسیر تعمیر"]}
}
def classify(task_type):
    return 1 if task_type in ("mechanical","visual") else (2 if task_type in ("measure","read") else 3)
if __name__ == "__main__":
    for lvl, info in LEVELS.items(): print(f"L{lvl}: {info['name']} — {info['examples']}")
