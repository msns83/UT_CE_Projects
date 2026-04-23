import sqlite3
import socket
import json
import time

DB_NAME = "main_system.db"
CORE_HOST = '127.0.0.1'
CORE_PORT = 8080

def start_replay(speed_factor=1.0):
    print(f"Replay System Initializing (Speed: {speed_factor})")
    
    try:
        conn = sqlite3.connect(DB_NAME)
        cursor = conn.cursor()
        cursor.execute("SELECT payload FROM raw_logs ORDER BY id ASC")
        logs = cursor.fetchall()
        conn.close()
    except sqlite3.Error as e:
        print(f"❌ Database error: {e}")
        return

    if not logs:
        print("⚠️ No raw data found in 'raw_logs' table to replay.")
        return

    print(f"Found {len(logs)} messages. Connecting to Core at {CORE_HOST}:{CORE_PORT}...")

    with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
        try:
            s.connect((CORE_HOST, CORE_PORT))
            print("Connected to Socket. Starting re-injection...")

            for row in logs:
                raw_payload = row[0] 
                
                message = raw_payload.strip() + "\n"
                s.sendall(message.encode('utf-8'))
                
                print(f"Resenting: {raw_payload}")
            
                time.sleep(0.5 / speed_factor)

            print("Replay is completed")
            
        except ConnectionRefusedError:
            print("Core connection Failed")

if __name__ == "__main__":
    start_replay(speed_factor=1.0)