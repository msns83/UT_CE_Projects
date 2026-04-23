from kafka import KafkaConsumer
import pandas as pd
import json
import matplotlib.pyplot as plt
import seaborn as sns

consumer = KafkaConsumer(
    'darooghe.transactions', 
    bootstrap_servers=['localhost:9092'],
    value_deserializer=lambda m: json.loads(m.decode('utf-8')),
    auto_offset_reset='earliest',
    enable_auto_commit=False,
    consumer_timeout_ms=5000  
)

records = []

for msg in consumer:
    value = msg.value
    if value:
        records.append(value)
    
    if len(records) >= 10000:
        break

if records:
    df = pd.DataFrame(records)

    for n in df.columns:
        print(n)

    print("\nBasic Activity Metrics")
    print("-" * 40)
    print(f"Total Records Received: {len(df)}")
    print(f"Unique Customers: {df['customer_id'].nunique() if 'customer_id' in df.columns else 'N/A'}")
    print("-" * 40)

    if 'customer_id' in df.columns:
        freq_df = df.groupby('customer_id').size().reset_index(name='transaction_count')

        print("\nFrequency of User Activity:")
        print(freq_df.sort_values('transaction_count', ascending=False).head(10).to_string(index=False))

        plt.figure(figsize=(10, 5))
        sns.histplot(freq_df['transaction_count'], bins=20, kde=True)
        plt.title('User Activity Frequency Distribution')
        plt.xlabel('Number of Transactions')
        plt.ylabel('Number of Users')
        plt.grid(True)
        plt.tight_layout()
        plt.show()

        top_user_id = freq_df.sort_values('transaction_count', ascending=False).iloc[0]['customer_id']
        print(f"\nTop active user: {top_user_id}")

        top_user_df = df[df['customer_id'] == top_user_id]

        if 'timestamp' in top_user_df.columns:
            top_user_df['timestamp'] = pd.to_datetime(top_user_df['timestamp'], errors='coerce')
            top_user_df = top_user_df.dropna(subset=['timestamp'])

            time_series_df = top_user_df.set_index('timestamp').resample('1T').size().reset_index(name='transactions_per_minute')

            print("\nGrowth Trend for Top User (Transactions per Minute):")
            print(time_series_df.tail(10).to_string(index=False))

            plt.figure(figsize=(12, 6))
            plt.plot(time_series_df['timestamp'], time_series_df['transactions_per_minute'], marker='o')
            plt.title(f'Growth Trend for Top User ({top_user_id})')
            plt.xlabel('Time')
            plt.ylabel('Transactions per Minute')
            plt.xticks(rotation=45)
            plt.grid(True)
            plt.tight_layout()
            plt.show()

        else:
            print("\n'timestamp' field missing, cannot plot growth trend for top user.")

    else:
        print("\n 'customer_id' field not found in data, skipping user activity plots.")

else:
    print("No activity received from Kafka topic.")
