import sqlite3
from datetime import datetime

DB_NAME = "main_system.db"
REPORT_FILE = "final_report.md"

def main_report():
    conn = sqlite3.connect(DB_NAME)
    cursor = conn.cursor()

    cursor.execute("SELECT COUNT(*) FROM sensor_data")
    total_valid = cursor.fetchone()[0]
    
    cursor.execute("SELECT COUNT(*) FROM events")
    total_alerts = cursor.fetchone()[0]

    cursor.execute("SELECT type, COUNT(*) FROM events GROUP BY type")
    error_summary = cursor.fetchall()

    cursor.execute("SELECT source, COUNT(*), AVG(val) FROM sensor_data GROUP BY source")
    sensor_summary = cursor.fetchall()

    cursor.execute("SELECT type, source, desc, ts FROM events ORDER BY id DESC LIMIT 5")
    recent_incidents = cursor.fetchall()

    conn.close()

    report_md = f"""# Final Report
**Generated on:** {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}

## 1. Executive Summary 
- **Scenario:** Smart Environment Monitoring [cite: 24]
- **Student ID (Seed):** 810103482 [cite: 28]
- **Total Valid Records:** {total_valid} [cite: 40]
- **Total Anomalies Detected:** {total_alerts} [cite: 40]

## 2. Data Quality & Reliability 
| Error Type | Occurrences |
|------------|-------------|
"""
    for etype, count in error_summary:
        report_md += f"| {etype} | {count} |\n"

    report_md += """
## 3. Sensor Performance Overview [cite: 40]
| Sensor | Total Readings | Average Value |
|--------|----------------|---------------|
"""
    for src, count, avg in sensor_summary:
        report_md += f"| {src} | {count} | {avg:.2f} |\n"

    report_md += """
## 4. Most Recent Critical Incidents 
| Type | Source | Description | Timestamp |
|------|--------|-------------|-----------|
"""
    for etype, src, desc, ts in recent_incidents:
        report_md += f"| {etype} | {src} | {desc} | {ts} |\n"

    report_md += "\n--- \n*End of Automated Report*"

    with open(REPORT_FILE, "w", encoding="utf-8") as f:
        f.write(report_md)
    
    print(f"Automated report successfully generated: {REPORT_FILE}")

if __name__ == "__main__":
    main_report()