from pyspark.sql import SparkSession
from pyspark.sql.functions import col, window, lit
from pyspark.sql.types import StructType, StructField, StringType, FloatType, TimestampType
import pyspark.sql.functions as F
import os

os.environ['PYSPARK_SUBMIT_ARGS'] = '--packages org.apache.spark:spark-sql-kafka-0-10_2.12:3.5.0 pyspark-shell'

spark = SparkSession.builder \
    .appName("FraudDetectionSystem") \
    .master("local[*]") \
    .config("spark.hadoop.io.native.lib.available", "false") \
    .getOrCreate()

spark.sparkContext.setLogLevel("ERROR")

kafka_bootstrap_servers = "localhost:9092"
kafka_topic = "darooghe.transactions"
output_topic = "darooghe.fraud_alerts"
checkpoint_dir = "file:///tmp/spark_checkpoints/fraud_detection"

schema = StructType([
    StructField("transaction_id", StringType(), True),
    StructField("timestamp", TimestampType(), True),
    StructField("customer_id", StringType(), True),
    StructField("merchant_id", StringType(), True),
    StructField("merchant_category", StringType(), True),
    StructField("payment_method", StringType(), True),
    StructField("amount", FloatType(), True),
    StructField("commission_amount", FloatType(), True),
    StructField("total_amount", FloatType(), True),
    StructField("customer_type", StringType(), True),
    StructField("status", StringType(), True),
    StructField("location", StructType([
        StructField("lat", FloatType(), True),
        StructField("lng", FloatType(), True)
    ]))
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
    .select(F.from_json("value", schema).alias("transactions")) \
    .select("transactions.*") \
    .withColumn("timestamp", F.to_timestamp("timestamp"))

velocity_alerts = transactions_df \
    .withWatermark("timestamp", "3 minutes") \
    .groupBy(
        window("timestamp", "2 minutes"),
        "customer_id"
    ) \
    .count() \
    .filter("count > 5") \
    .select(
        col("customer_id"),
        lit("velocity_check").alias("fraud_type"),
        col("window.start").alias("event_time")
    )

def haversine(lat1, lon1, lat2, lon2):
    return 6371 * 2 * F.asin(
        F.sqrt(
            F.pow(F.sin((F.radians(lat2) - F.radians(lat1)) / 2), 2) +
            F.cos(F.radians(lat1)) * F.cos(F.radians(lat2)) *
            F.pow(F.sin((F.radians(lon2) - F.radians(lon1)) / 2), 2)
        )
    )

transactions_with_watermark = transactions_df.withWatermark("timestamp", "6 minutes")

geo_alerts = transactions_with_watermark.alias("t1") \
    .join(
        transactions_with_watermark.alias("t2"),
        (col("t1.customer_id") == col("t2.customer_id")) &
        (col("t1.timestamp") < col("t2.timestamp")) &
        (F.unix_timestamp("t2.timestamp") - F.unix_timestamp("t1.timestamp") <= 300),
        "inner"
    ) \
    .withColumn("distance", haversine(
        col("t1.location.lat"), col("t1.location.lng"),
        col("t2.location.lat"), col("t2.location.lng")
    )) \
    .filter("distance > 50") \
    .select(
        col("t1.customer_id").alias("customer_id"),
        lit("geo_impossibility").alias("fraud_type"),
        col("t2.timestamp").alias("event_time")
    )

FAKE_AVG_AMOUNT = 100.0

amount_alerts = transactions_df \
    .filter(col("amount") > (lit(FAKE_AVG_AMOUNT) * 10)) \
    .select(
        col("customer_id"),
        lit("amount_anomaly").alias("fraud_type"),
        col("timestamp").alias("event_time")
    )

fraud_alerts = velocity_alerts.union(geo_alerts).union(amount_alerts)

fraud_alerts_for_kafka = fraud_alerts.selectExpr(
    "CAST(customer_id AS STRING) AS key",
    "to_json(struct(*)) AS value"
)

fraud_alerts_for_kafka.writeStream \
    .format("kafka") \
    .option("kafka.bootstrap.servers", kafka_bootstrap_servers) \
    .option("topic", output_topic) \
    .option("checkpointLocation", checkpoint_dir) \
    .outputMode("append") \
    .start()

fraud_alerts.writeStream \
    .format("console") \
    .option("truncate", False) \
    .outputMode("append") \
    .start()

spark.streams.awaitAnyTermination()
