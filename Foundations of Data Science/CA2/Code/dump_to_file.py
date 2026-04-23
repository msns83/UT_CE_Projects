import json
from confluent_kafka import Consumer
import logging

logging.basicConfig(level=logging.INFO)

MAX_MESSAGES = 5000
OUTPUT_FILE = "transactions.json"

consumer_conf = {
    'bootstrap.servers': 'localhost:9092',
    'group.id': 'dump-group',
    'auto.offset.reset': 'earliest'
}

consumer = Consumer(consumer_conf)
consumer.subscribe(['darooghe.transactions'])

messages = []

try:
    logging.info("Reading messages from Kafka...")
    while len(messages) < MAX_MESSAGES:
        msg = consumer.poll(1.0)
        if msg is None:
            continue
        if msg.error():
            logging.warning(f"Kafka error: {msg.error()}")
            continue
        try:
            data = json.loads(msg.value().decode('utf-8'))
            messages.append(data)
        except Exception as e:
            logging.error(f"Error decoding message: {e}")

finally:
    consumer.close()
    logging.info(f"Writing {len(messages)} messages to {OUTPUT_FILE}")
    with open(OUTPUT_FILE, "w") as f:
        for item in messages:
            json.dump(item, f)
            f.write("\n")

    logging.info("Done!")