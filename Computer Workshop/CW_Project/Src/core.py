import socket
import json
import sqlite3
import select
from datetime import datetime

DB_NAME = "main_system.db"
INACTIVITY_TIMEOUT = 10 

def init_db():
    conn = sqlite3.connect(DB_NAME)
    cursor = conn.cursor()
    cursor.execute('CREATE TABLE IF NOT EXISTS raw_logs (id INTEGER PRIMARY KEY, ts TEXT, payload TEXT)')
    cursor.execute('CREATE TABLE IF NOT EXISTS sensor_data (id INTEGER PRIMARY KEY, source TEXT, ts TEXT, val REAL)')
    cursor.execute('CREATE TABLE IF NOT EXISTS events (id INTEGER PRIMARY KEY, type TEXT, source TEXT, desc TEXT, ts TEXT)')
    conn.commit()
    conn.close()

def parse_payload(source, payload):
    ts_raw = payload[:12]
    try:
        dt_obj = datetime.strptime(ts_raw, "%y%m%d%H%M%S")
        ts_iso = dt_obj.isoformat()
    except ValueError:
        raise ValueError(f"Invalid timestamp format: {ts_raw}")

    if source == 'light':
        val = float(payload[12:15])
    elif source == 'temp':
        val_str = payload[12:16]
        val = float(f"{val_str[:2]}.{val_str[2:]}")
    elif source == 'moisture':
        val = float(payload[12:14])
    else:
        raise ValueError("Unknown source")
    
    return ts_iso, val, dt_obj

def log_event(etype, source, desc, ts, existing_conn=None):
    query = "INSERT INTO events (type, source, desc, ts) VALUES (?, ?, ?, ?)"
    params = (etype, source, desc, ts)
    
    if existing_conn:
        existing_conn.execute(query, params)
    else:
        try:
            with sqlite3.connect(DB_NAME, timeout=20) as conn:
                conn.execute(query, params)
                conn.commit()
        except sqlite3.OperationalError as e:
            print(f"Database Connecting Error: {e}")

def process_message(line, moisture_window):
    arrival_ts = datetime.now().isoformat()
    
    try:
        with sqlite3.connect(DB_NAME, timeout=20) as conn:
            cursor = conn.cursor()
            cursor.execute("INSERT INTO raw_logs (ts, payload) VALUES (?, ?)", (arrival_ts, line))
            
            try:
                msg = json.loads(line)
                source = msg.get('source')
                payload = msg.get('data')

                expected_len = {'light': 15, 'temp': 16, 'moisture': 14}

                if source in expected_len and len(payload) != expected_len[source]:
                    desc = f"Length Mismatch: got {len(payload)}, expected {expected_len[source]}"
                    print(desc)
                    log_event("FORMAT_ERROR", source, desc, arrival_ts, existing_conn=conn)
                    conn.commit()
                    return

                if not payload.isdigit():
                    print(f"Non-numeric characters detected in {source}")
                    log_event("FORMAT_ERROR", source, "Non-numeric characters detected", arrival_ts, existing_conn=conn)
                    conn.commit()
                    return

                ts_iso, val, msg_dt = parse_payload(source, payload)

                if source == 'light':
                    hour = msg_dt.hour
                    if (hour < 6 or hour >= 20) and val > 50:
                        print(f"NIGHT LIGHT ALERT: {val}")
                        log_event("THRESHOLD_ERROR", source, f"Intensity: {val}", ts_iso, existing_conn=conn)

                if source == 'moisture':
                    moisture_window.append(val)
                    if len(moisture_window) > 3: 
                        moisture_window.pop(0)
                    if len(moisture_window) == 3 and all(v == 99.0 for v in moisture_window):
                        log_event("WINDOW_ERROR", source, "3 times 99% Saturation", ts_iso, existing_conn=conn)

                cursor.execute("INSERT INTO sensor_data (source, ts, val) VALUES (?, ?, ?)", (source, ts_iso, val))
                
                conn.commit() 
                print(f"Validated {source.upper()}: {val}")

            except Exception as e:
                conn.commit() 
                log_event("SYSTEM_ERROR", "core", str(e), arrival_ts, existing_conn=conn)
                conn.commit()
                print(f"Main system Error: {e}")

    except sqlite3.OperationalError as e:
        print(f"Database error in message processing: {e}")
        
def main_core():

    init_db()
    moisture_window = []
    
    with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
        s.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
        s.bind(('127.0.0.1', 8080))
        s.listen()
        print("Core is online on 127.0.0.1:8080")
        
        while True:
            conn, addr = s.accept()
            with conn:
                print(f"Sensor arrays connected for {addr}")
                buffer = ""
                while True:
                    ready = select.select([conn], [], [], INACTIVITY_TIMEOUT)
                    
                    if ready[0]:
                        data = conn.recv(1024).decode('utf-8')
                        if not data: break
                        buffer += data
                        while "\n" in buffer:
                            line, buffer = buffer.split("\n", 1)
                            if line.strip():
                                process_message(line, moisture_window)
                    else:
                        print("Alert: Sensors are offline !")
                        log_event("SYSTEM_OFFLINE", "system", "No data received from sensors", datetime.now().isoformat())

if __name__ == "__main__":
    main_core()