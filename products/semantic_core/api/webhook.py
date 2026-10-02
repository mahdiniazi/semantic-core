#!/usr/bin/env python3
"""Webhook receiver for semantic_core events."""
from http.server import HTTPServer, BaseHTTPRequestHandler
LOG = "/tmp/semantic_core_webhooks.log"

class H(BaseHTTPRequestHandler):
    def do_POST(self):
        n = int(self.headers.get("Content-Length", 0))
        body = self.rfile.read(n)
        with open(LOG, "ab") as f:
            f.write(body + b"\n")
        self.send_response(200); self.end_headers(); self.wfile.write(b'{"received":true}')

if __name__ == "__main__":
    HTTPServer(("127.0.0.1", 8889), H).serve_forever()
