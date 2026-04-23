import socket
import json
import time
import random
from datetime import datetime, timedelta

HOST = '127.0.0.1'
PORT = 8080

STUDENT_ID = 810101459  
random.seed(STUDENT_ID)

def get_base_ts():
    dt = datetime.now()
    if random.random() < 0.1:
        dt = dt + timedelta(days=random.choice([-730, 730]))
    return dt.strftime("%y%m%d%H%M%S")

def generate_message(moisture_state):
    sensor_type = random.choice(['light', 'temp', 'moisture'])
    ts_str = get_base_ts()
    hour = int(ts_str[6:8])
    is_night = hour < 6 or hour > 20
    
    payload = ""

    if sensor_type == 'light':
        if is_night and random.random() < 0.3:
            val = random.randint(51, 99)
        else:
            val = random.randint(0, 40) if is_night else random.randint(60, 100)
        payload = ts_str + f"{val:03d}"

    elif sensor_type == 'temp':
        val = f"{random.randint(20, 30):02d}{random.randint(0, 99):02d}"
        payload = ts_str + val

    elif sensor_type == 'moisture':
        if moisture_state['counter'] >= 3:
            val = 99
            moisture_state['counter'] += 1
            if moisture_state['counter'] > 5: moisture_state['counter'] = 0
        elif random.random() < 0.15:
            val = 99
            moisture_state['counter'] += 1
        else:
            val = random.randint(10, 80)
            moisture_state['counter'] = 0
        payload = ts_str + f"{val:02d}"

    if random.random() < 0.05:
        payload += str(random.randint(0, 9)) 
    elif random.random() < 0.03:
        payload = payload[:-1] + "X" 

    return {
        "source": sensor_type,
        "data": payload,
        "sid": STUDENT_ID
    }

def main_sensors():
    moisture_state = {'counter': 0}

    print(f"Sensors are active on {HOST}:{PORT}")
    
    with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
        try:
            s.connect((HOST, PORT))
            while True:
                if random.random() < 0.02:
                    downtime = random.randint(5, 10)
                    print(f"Simulated sensors disconnection for {downtime}s")
                    time.sleep(downtime)
                    continue

                msg_obj = generate_message(moisture_state)
                
                json_output = json.dumps(msg_obj) + "\n"
                s.sendall(json_output.encode('utf-8'))
                
                print(f"Sent: {json_output.strip()}")
                time.sleep(random.uniform(0.5, 1.5))
                
        except ConnectionRefusedError:
            print("Socket Error")

if __name__ == "__main__":
    main_sensors()