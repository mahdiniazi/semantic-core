#!/usr/bin/env python3
"""quote_pdf.py — تولید پیش‌فاکتور HTML (ساده)."""
import sys, datetime
def render(vin, items):
    rows = "".join(f"<tr><td>{n}</td><td>{p:,}</td></tr>" for n,p in items)
    s = sum(p for _,p in items)
    return f"""<html dir="rtl"><body><h1>پیش‌فاکتور</h1>
<p>VIN: {vin} | تاریخ: {datetime.datetime.now().date()}</p>
<table border="1"><tr><th>شرح</th><th>مبلغ</th></tr>{rows}
<tr><td><b>جمع</b></td><td><b>{s:,}</b></td></tr></table></body></html>"""
if __name__ == "__main__":
    html = render("TEST123", [("تعویض کوئل", 500000),("دستمزد", 300000)])
    print(html[:200])
