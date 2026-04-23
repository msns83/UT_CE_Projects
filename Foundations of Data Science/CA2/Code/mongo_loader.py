import json
import pandas as pd
from pymongo import MongoClient
from datetime import datetime, timedelta

client = MongoClient('mongodb://localhost:27017/')
db = client['transactions_db']
collection = db['transactions']

with open('transactions.json', 'r') as f:
    transactions = [json.loads(line.strip()) for line in f.readlines()]

for transaction in transactions:
    transaction['timestamp'] = datetime.strptime(transaction['timestamp'], "%Y-%m-%dT%H:%M:%S.%fZ")
    transaction['date_partition'] = datetime(transaction['timestamp'].year, transaction['timestamp'].month, transaction['timestamp'].day, 0, 0, 0)

collection.insert_many(transactions)

def apply_data_retention():
    retention_date = datetime.utcnow() - timedelta(days=1)
    retention_date_partition = retention_date.replace(hour=0, minute=0, second=0, microsecond=0)
    result = collection.delete_many({"date_partition": {"$lt": retention_date_partition}})
    print(f"Deleted {result.deleted_count} old documents based on retention policy.")

def generate_aggregated_data():
    pipeline = [
        {
            "$group": {
                "_id": {
                    "date": "$date_partition",
                    "merchant_id": "$merchant_id",
                    "customer_type": "$customer_type"
                },
                "total_transactions": {"$sum": 1},
                "total_amount": {"$sum": "$amount"},
                "total_commission": {"$sum": "$commission_amount"}
            }
        },
        {
            "$sort": {"_id.date": 1}
        }
    ]
    daily_summary = list(collection.aggregate(pipeline))
    df_daily = pd.DataFrame(daily_summary)
    print("Daily Summary:")
    print(df_daily.head())

    pipeline_commission = [
        {
            "$group": {
                "_id": {
                    "month": {"$month": "$timestamp"},
                    "year": {"$year": "$timestamp"},
                    "merchant_category": "$merchant_category"
                },
                "total_commission": {"$sum": "$commission_amount"}
            }
        },
        {
            "$sort": {"_id.year": 1, "_id.month": 1}
        }
    ]
    commission_summary = list(collection.aggregate(pipeline_commission))
    df_commission = pd.DataFrame(commission_summary)
    print("\nMonthly Commission Summary:")
    print(df_commission.head())

apply_data_retention()
generate_aggregated_data()

client.close()
