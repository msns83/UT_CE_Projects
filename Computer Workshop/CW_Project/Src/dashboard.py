import socket
import sqlite3
from http.server import HTTPServer, BaseHTTPRequestHandler
from datetime import datetime

DB_NAME = "main_system.db"
CORE_PORT = 8080

class ModernDashboardHandler(BaseHTTPRequestHandler):
    def check_core_status(self):
        with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
            s.settimeout(0.5)
            return s.connect_ex(('127.0.0.1', CORE_PORT)) == 0

    def get_stats(self):
        try:
            with sqlite3.connect(DB_NAME, timeout=10) as conn:
                cursor = conn.cursor()
                cursor.execute("""
                    SELECT source, val, ts FROM sensor_data 
                    WHERE id IN (SELECT MAX(id) FROM sensor_data GROUP BY source)
                """)
                last_vals = cursor.fetchall()
                
                cursor.execute("SELECT COUNT(*) FROM sensor_data")
                total_valid = cursor.fetchone()[0]
                cursor.execute("SELECT COUNT(*) FROM events")
                total_events = cursor.fetchone()[0]
                
                cursor.execute("SELECT type, source, desc, ts FROM events ORDER BY id DESC LIMIT 12")
                events = cursor.fetchall()
                return last_vals, total_valid, total_events, events
        except:
            return [], 0, 0, []

    def do_GET(self):
        self.send_response(200)
        self.send_header('Content-type', 'text/html')
        self.end_headers()
        
        last_vals, total_valid, total_events, events = self.get_stats()
        is_online = self.check_core_status()
        
        status_text = "ONLINE" if is_online else "OFFLINE"
        status_color = "success" if is_online else "danger"

        html = f"""
        <!DOCTYPE html>
        <html lang="en">
        <head>
            <meta charset="UTF-8">
            <meta http-equiv="refresh" content="2">
            <title>BlackBox | Dashboard</title>
            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
            <style>
                body {{ background-color: #f4f7f6; font-family: 'Inter', sans-serif; }}
                .navbar {{ background: #121820; border-bottom: 3px solid #3498db; }}
                .card {{ border: none; border-radius: 10px; box-shadow: 0 4px 12px rgba(0,0,0,0.08); }}
                .stat-card {{ transition: transform 0.2s; }}
                .stat-card:hover {{ transform: scale(1.02); }}
                .badge-custom {{ padding: 0.5em 0.8em; font-size: 0.75rem; font-weight: 600; }}
                .pulse-dot {{
                    height: 12px; width: 12px; border-radius: 50%; display: inline-block;
                    background-color: {'#2ecc71' if is_online else '#e74c3c'};
                    box-shadow: 0 0 8px {'#2ecc71' if is_online else '#e74c3c'};
                }}
            </style>
        </head>
        <body>
            <nav class="navbar navbar-dark py-3 mb-4">
                <div class="container d-flex justify-content-between align-items-center">
                    <span class="navbar-brand mb-0 h1">📦 BLACKBOX MONITOR</span>
                    <div class="text-white small fw-bold">
                        <span class="pulse-dot me-2"></span> SYSTEM {status_text}
                    </div>
                </div>
            </nav>

            <div class="container">
                <div class="row g-3 mb-4">
                    <div class="col-md-4">
                        <div class="card stat-card p-3 text-center">
                            <div class="text-uppercase text-muted small fw-bold">Total Stored Data</div>
                            <div class="h2 mb-0 fw-bold">{total_valid}</div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="card stat-card p-3 text-center">
                            <div class="text-uppercase text-muted small fw-bold">Incident Count</div>
                            <div class="h2 mb-0 text-danger fw-bold">{total_events}</div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="card stat-card p-3 text-center">
                            <div class="text-uppercase text-muted small fw-bold">Last Dashboard Sync</div>
                            <div class="h2 mb-0 text-primary fw-bold">{datetime.now().strftime('%H:%M:%S')}</div>
                        </div>
                    </div>
                </div>

                <div class="row">
                    <div class="col-lg-4 mb-4">
                        <h6 class="fw-bold text-muted mb-3">SENSOR STATUS</h6>
                        {" ".join([f'''
                        <div class="card mb-2 p-3 border-start border-4 border-primary">
                            <div class="d-flex justify-content-between align-items-center">
                                <div>
                                    <div class="small fw-bold text-secondary">{s.upper()}</div>
                                    <div class="h4 mb-0">{v}</div>
                                </div>
                                <div class="text-end small text-muted">
                                    {t[11:19]}
                                </div>
                            </div>
                        </div>
                        ''' for s, v, t in last_vals])}
                    </div>

                    <div class="col-lg-8">
                        <h6 class="fw-bold text-muted mb-3">INCIDENT LOG (Real-time Errors & Alerts)</h6>
                        <div class="card overflow-hidden">
                            <table class="table table-hover align-middle mb-0">
                                <thead class="table-dark">
                                    <tr>
                                        <th>Error Type</th>
                                        <th>Source</th>
                                        <th>Description</th>
                                        <th>Occurred At</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    {" ".join([f'''
                                    <tr>
                                        <td>
                                            <span class="badge badge-custom rounded-pill 
                                            {'bg-warning text-dark' if 'THRESHOLD' in ty or 'QUALITY' in ty else 
                                             'bg-danger' if 'OFFLINE' in ty or 'ERROR' in ty else 'bg-info'}">
                                                {ty}
                                            </span>
                                        </td>
                                        <td class="small fw-bold">{src}</td>
                                        <td class="small text-secondary">{desc}</td>
                                        <td class="text-muted small">{ts[11:19]}</td>
                                    </tr>
                                    ''' for ty, src, desc, ts in events])}
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </body>
        </html>
        """
        self.wfile.write(html.encode('utf-8'))

def main_dashboard():
    print("Dashboard is active on http://localhost:8000")
    httpd = HTTPServer(('localhost', 8000), ModernDashboardHandler)
    httpd.serve_forever()

if __name__ == "__main__":
    main_dashboard()