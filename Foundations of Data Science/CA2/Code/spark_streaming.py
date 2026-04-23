from pyspark.sql import SparkSession
from pyspark.sql.functions import col, window
from pyspark.sql.types import StructType, StructField, StringType, FloatType
from pyspark.sql import functions as F
import os

os.environ['PYSPARK_SUBMIT_ARGS'] = '--packages org.apache.spark:spark-sql-kafka-0-10_2.12:3.5.0 pyspark-shell'

spark = SparkSession.builder \
    .appName("KafkaTransactionStream") \
    .master("local[*]") \
    .config("spark.sql.streaming.checkpointLocation", "file:///tmp/spark_checkpoints/transactions") \
    .config("spark.hadoop.io.native.lib.available", "false") \
    .getOrCreate()

checkpoint_dir = "file:///tmp/spark_checkpoints/transactions"  

kafka_topic = "darooghe.transactions"
kafka_bootstrap_servers = "localhost:9092"

schema = StructType([
    StructField("transaction_id", StringType(), True),
    StructField("timestamp", StringType(), True),
    StructField("customer_id", StringType(), True),
    StructField("merchant_id", StringType(), True),
    StructField("merchant_category", StringType(), True),
    StructField("payment_method", StringType(), True),
    StructField("amount", FloatType(), True),
    StructField("commission_amount", FloatType(), True),
    StructField("total_amount", FloatType(), True),
    StructField("customer_type", StringType(), True),
    StructField("status", StringType(), True)
])

kafka_stream = spark \
    .readStream \
    .format("kafka") \
    .option("kafka.bootstrap.servers", kafka_bootstrap_servers) \
    .option("subscribe", kafka_topic) \
    .option("startingOffsets", "earliest") \
    .option("failOnDataLoss", "false") \
    .load()

transactions_df = kafka_stream.selectExpr("CAST(value AS STRING)") \
    .select(F.from_json("value", schema).alias("transaction")) \
    .select("transaction.*")

transactions_df = transactions_df.withColumn("timestamp", F.to_timestamp("timestamp"))

windowed_df = transactions_df \
    .groupBy(window("timestamp", "1 minute", "20 seconds"), "merchant_id", "customer_type") \
    .agg(
        F.count("transaction_id").alias("total_transactions"),
        F.sum("amount").alias("total_amount"),
        F.sum("commission_amount").alias("total_commission"),
        F.sum("total_amount").alias("total_revenue")
    )

output_topic = "transaction_aggregates"

query_kafka = windowed_df \
    .selectExpr("CAST(merchant_id AS STRING) AS key", "to_json(struct(*)) AS value") \
    .writeStream \
    .outputMode("complete") \
    .format("kafka") \
    .option("kafka.bootstrap.servers", kafka_bootstrap_servers) \
    .option("topic", output_topic) \
    .option("checkpointLocation", checkpoint_dir + "/out") \
    .start()

query_console = windowed_df \
    .writeStream \
    .outputMode("complete") \
    .format("console") \
    .option("truncate", "false") \
    .start()

query_kafka.awaitTermination()
query_console.awaitTermination()
