#!/usr/bin/env python3
"""refer.py — سیستم ارجاع بین سطوح."""
def should_refer(level, blocked):
    if level == 1 and blocked: return 2
    if level == 2 and blocked: return 3
    return None
def referral_chain(level, blocked): 
    r = should_refer(level, blocked)
    return f"L{level} → L{r}" if r else f"L{level} ادامه"
if __name__ == "__main__":
    for case in [(1,True),(2,True),(2,False)]:
        print(case, "→", referral_chain(*case))
