from kafka import KafkaConsumer
import pandas as pd
import json
import matplotlib.pyplot as plt
import matplotlib.dates as mdates
import seaborn as sns

consumer = KafkaConsumer(
    'transaction_aggregates',  
    bootstrap_servers=['localhost:9092'],
    value_deserializer=lambda m: json.loads(m.decode('utf-8')),
    auto_offset_reset='earliest',
    enable_auto_commit=False
)

records = []
for msg in consumer:
    value = msg.value
    if 'window' in value:
        records.append({
            'timestamp': value['window']['start'],
            'total_transactions': value['total_transactions']
        })
    if len(records) >= 1000:
        break

df = pd.DataFrame(records)
df['timestamp'] = pd.to_datetime(df['timestamp'])
df = df.sort_values('timestamp')

plt.figure(figsize=(12, 6))
sns.lineplot(x='timestamp', y='total_transactions', data=df, marker="o")
plt.title("Transaction Volume Over Time", fontsize=16)
plt.xlabel("Timestamp")
plt.ylabel("Number of Transactions")
plt.xticks(rotation=45)
plt.grid(True)
plt.tight_layout()
plt.show()
