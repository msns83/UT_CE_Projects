import sys
import subprocess
import time
import sqlite3
import csv

DB_NAME = "main_system.db"
DASHBOARD_URL = "http://localhost:8000"

def export_db_to_csv():
    print("Exporting database to CSV...")
    try:
        conn = sqlite3.connect(DB_NAME)
        cursor = conn.cursor()
        
        csv_file = "system_data_dump.csv"
        
        cursor.execute("SELECT * FROM sensor_data")
        rows = cursor.fetchall()
        
        column_names = [description[0] for description in cursor.description]
        
        with open(csv_file, 'w', newline='') as f:
            writer = csv.writer(f)
            writer.writerow(column_names)
            writer.writerows(rows)
            
        print(f"Database exported successfully to {csv_file}")
        conn.close()
    except Exception as e:
        print(f"Error exporting CSV: {e}")

def run_report():
    print("Generating final report...")
    try:
        subprocess.run([sys.executable, "report.py"], check=True)
        print("Report generated.")
    except subprocess.CalledProcessError as e:
        print(f"Error generating report: {e}")

def cleanup(processes):
    print("\nStopping system...")
    for p in processes:
        if p.poll() is None:  
            p.terminate()
            try:
                p.wait(timeout=2)
            except subprocess.TimeoutExpired:
                p.kill()
    
    run_report()
    export_db_to_csv()
    print("System shutdown complete.")

def run_casual_system():
    processes = []
    print("\nStarting Casual System...")
    
    print("Launching Core System...")
    core = subprocess.Popen([sys.executable, "core.py"])
    processes.append(core)
    time.sleep(2)
    
    print("Launching Dashboard...")
    dash = subprocess.Popen([sys.executable, "dashboard.py"])
    processes.append(dash)
    
    print("Launching Sensor Simulator...")
    sensors = subprocess.Popen([sys.executable, "sensors.py"])
    processes.append(sensors)
    
    
    print(f"System is READY.")
    print(f"Access the Dashboard at: {DASHBOARD_URL}")
    
    return processes

def run_replay_system():
    processes = []
    print("\nStarting Replay Mode...")
    
    print("Launching Core System...")
    core = subprocess.Popen([sys.executable, "core.py"])
    processes.append(core)
    time.sleep(2)
    
    
    print("Launching Dashboard...")
    dash = subprocess.Popen([sys.executable, "dashboard.py"])
    processes.append(dash)
    
    
    print("Launching Replay Script...")
    replay = subprocess.Popen([sys.executable, "replay.py"])
    processes.append(replay)
    
    print(f"Replay System is RUNNING.")
    print(f"Access the Dashboard at: {DASHBOARD_URL}")
    
    return processes

def main():
    while True:
        print("\n=== Smart Environment System Interface ===")
        print("1. Run Casual System")
        print("2. Run Replay Mode")
        
        choice = input("Select an option (1/2): ").strip()
        
        processes = []
        
        if choice == '1':
            processes = run_casual_system()
        elif choice == '2':
            processes = run_replay_system()
        else:
            print("Invalid choice. Please enter 1 or 2.")
            continue
            
        try:
            print("\nPress Controll + C to exit.")
            while True:
                pass
        except KeyboardInterrupt:
            print("\nStop detected.")
        finally:
            cleanup(processes)
            break

if __name__ == "__main__":
    main()
