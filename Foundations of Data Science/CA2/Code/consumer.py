import json
from confluent_kafka import Consumer, Producer
from datetime import datetime, timedelta
import logging

logging.basicConfig(level=logging.INFO)

consumer_conf = {
    'bootstrap.servers': 'localhost:9092',
    'group.id': 'validation-final-group',
    'auto.offset.reset': 'earliest'
}
consumer = Consumer(consumer_conf)
consumer.subscribe(['darooghe.transactions'])

producer = Producer({'bootstrap.servers': 'localhost:9092'})

def validate_event(event):
    try:
        expected_total = event['amount'] + event['vat_amount'] 
        if expected_total != event['total_amount']:
            return False, "ERR_AMOUNT"

        tx_time = datetime.fromisoformat(event['timestamp'].replace('Z', ''))
        now = datetime.utcnow()
        if tx_time > now or tx_time < now - timedelta(days=1):
            return False, "ERR_TIME"

        if event['payment_method'] in ['mobile', 'online']:
            device = event.get('device_info', {})
            if not device or device.get("os") not in ["Android", "iOS"]:
                return False, "ERR_DEVICE"

        return True, None
    except Exception as e:
        logging.error(f"Validation crash: {e}")
        return False, "ERR_UNKNOWN"

def send_to_error_logs(event, error_code):
    error_message = {
        "transaction_id": event.get("transaction_id"),
        "error_code": error_code,
        "original_data": event
    }
    producer.produce(
        'darooghe.error_logs',
        key=event.get("customer_id"),
        value=json.dumps(error_message)
    )
    producer.flush()

try:
    while True:
        print("Wating...")
        msg = consumer.poll(1.0)
        if msg is None:
            continue
        if msg.error():
            logging.error(f"Kafka error: {msg.error()}")
            continue

        try:
            event = json.loads(msg.value().decode('utf-8'))
            valid, error_code = validate_event(event)
            if not valid:
                logging.info(f"Invalid transaction: {event['transaction_id']} | Error: {error_code}")
                send_to_error_logs(event, error_code)
        except Exception as e:
            logging.error(f"Error processing message: {e}")
finally:
    consumer.close()