from pyspark.sql import SparkSession
from pyspark.sql.functions import col, window, sum, avg, expr
import pyspark.sql.functions as F
import os

os.environ['PYSPARK_SUBMIT_ARGS'] = '--packages org.apache.spark:spark-sql-kafka-0-10_2.12:3.5.0 pyspark-shell'

spark = SparkSession.builder \
    .appName("RealTimeCommissionAnalytics") \
    .master("local[*]") \
    .config("spark.hadoop.io.native.lib.available", "false") \
    .config("spark.sql.streaming.checkpointLocation", "file:///tmp/spark_checkpoints/transactions") \
    .getOrCreate()

spark.sparkContext.setLogLevel("ERROR")

kafka_bootstrap_servers = "localhost:9092"
input_topic = "darooghe.transactions"
checkpoint_base_dir = "file:///tmp/spark_checkpoints/transactions"

from pyspark.sql.types import StructType, StructField, StringType, FloatType, TimestampType

schema = StructType([
    StructField("transaction_id", StringType(), True),
    StructField("timestamp", TimestampType(), True),
    StructField("customer_id", StringType(), True),
    StructField("merchant_id", StringType(), True),
    StructField("merchant_category", StringType(), True),
    StructField("payment_method", StringType(), True),
    StructField("amount", FloatType(), True),
    StructField("commission_type", StringType(), True),
    StructField("commission_amount", FloatType(), True),
    StructField("total_amount", FloatType(), True),
    StructField("customer_type", StringType(), True),
    StructField("status", StringType(), True),
])

kafka_stream = spark.readStream \
    .format("kafka") \
    .option("kafka.bootstrap.servers", kafka_bootstrap_servers) \
    .option("subscribe", input_topic) \
    .option("startingOffsets", "latest") \
    .load()

transactions_df = kafka_stream.selectExpr("CAST(value AS STRING)") \
    .select(F.from_json("value", schema).alias("transaction")) \
    .select("transaction.*")

commission_by_type = transactions_df \
    .withWatermark("timestamp", "2 minutes") \
    .groupBy(
        window("timestamp", "1 minute"),
        "commission_type"
    ) \
    .agg(
        sum("commission_amount").alias("total_commission")
    )

commission_by_type_kafka = commission_by_type.selectExpr(
    "commission_type as key",
    "to_json(named_struct('commission_type', commission_type, 'window_start', window.start, 'window_end', window.end, 'total_commission', total_commission)) as value"
)

commission_ratio = transactions_df \
    .groupBy("merchant_category") \
    .agg(
        (sum("commission_amount") / sum("amount")).alias("commission_ratio")
    )

commission_ratio_kafka = commission_ratio.selectExpr(
    "merchant_category as key",
    "to_json(named_struct('merchant_category', merchant_category, 'commission_ratio', commission_ratio)) as value"
)

top_merchants = transactions_df \
    .withWatermark("timestamp", "10 minutes") \
    .groupBy(
        window("timestamp", "5 minutes", "1 minute"),
        "merchant_id"
    ) \
    .agg(
        sum("commission_amount").alias("total_commission")
    )

top_merchants_kafka = top_merchants.selectExpr(
    "merchant_id as key",
    "to_json(named_struct('merchant_id', merchant_id, 'window_start', window.start, 'window_end', window.end, 'total_commission', total_commission)) as value"
)

commission_by_type_kafka.writeStream \
    .format("kafka") \
    .option("kafka.bootstrap.servers", kafka_bootstrap_servers) \
    .option("checkpointLocation", f"{checkpoint_base_dir}/commission_by_type") \
    .option("topic", "commission_by_type") \
    .outputMode("update") \
    .start()

commission_by_type.writeStream \
    .format("console") \
    .option("truncate", False) \
    .outputMode("update") \
    .start()

commission_ratio_kafka.writeStream \
    .format("kafka") \
    .option("kafka.bootstrap.servers", kafka_bootstrap_servers) \
    .option("checkpointLocation", f"{checkpoint_base_dir}/commission_ratio_by_category") \
    .option("topic", "commission_ratio_by_category") \
    .outputMode("complete") \
    .start()

commission_ratio.writeStream \
    .format("console") \
    .option("truncate", False) \
    .outputMode("complete") \
    .start()

top_merchants_kafka.writeStream \
    .format("kafka") \
    .option("kafka.bootstrap.servers", kafka_bootstrap_servers) \
    .option("checkpointLocation", f"{checkpoint_base_dir}/top_merchants_commission") \
    .option("topic", "top_merchants_commission") \
    .outputMode("update") \
    .start()

top_merchants.writeStream \
    .format("console") \
    .option("truncate", False) \
    .outputMode("update") \
    .start()

spark.streams.awaitAnyTermination()
