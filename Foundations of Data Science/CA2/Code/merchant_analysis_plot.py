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

merchant_counts = {}

for msg in consumer:
    value = msg.value
    merchant_id = value.get('merchant_id')
    count = value.get('total_transactions', 0)
    
    if merchant_id:
        merchant_counts[merchant_id] = merchant_counts.get(merchant_id, 0) + count
    
    if len(merchant_counts) >= 50:
        break

top_merchants = pd.DataFrame.from_dict(merchant_counts, orient='index', columns=['transactions'])
top_merchants = top_merchants.sort_values('transactions', ascending=False).head(5)

plt.figure(figsize=(10, 6))
sns.barplot(x=top_merchants.index, y=top_merchants['transactions'], palette='Blues_d')
plt.title("Top 5 Merchants by Number of Transactions", fontsize=16)
plt.xlabel("Merchant ID")
plt.ylabel("Number of Transactions")
plt.xticks(rotation=30)
plt.tight_layout()
plt.show()
