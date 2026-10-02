#!/usr/bin/env python3
"""API endpoint for semantic_core knowledge base."""
import json
import sqlite3
from http.server import HTTPServer, BaseHTTPRequestHandler

DB = "/home/cs/semantic_core/products/semantic_core/db/semantic_core.db"

def q(sql):
    conn = sqlite3.connect(DB)
    try:
        return conn.execute(sql).fetchall()
    finally:
        conn.close()

class H(BaseHTTPRequestHandler):
    def do_GET(self):
        if self.path == "/health":
            r = {"status": "ok"}
        elif self.path == "/stats":
            r = {"types": q("SELECT COUNT(*) FROM e01_200_01_tb")[0][0],
                 "entities": q("SELECT COUNT(*) FROM e01_200_03_tb")[0][0],
                 "relations": q("SELECT COUNT(*) FROM e01_222_01_tb")[0][0]}
        else:
            self.send_response(404); self.end_headers(); return
        self.send_response(200); self.send_header("Content-Type","application/json"); self.end_headers()
        self.wfile.write(json.dumps(r).encode())

if __name__ == "__main__":
    HTTPServer(("127.0.0.1", 8888), H).serve_forever()
