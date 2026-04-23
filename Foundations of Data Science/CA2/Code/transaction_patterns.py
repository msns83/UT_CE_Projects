from pyspark.sql import SparkSession
from pyspark.sql.functions import col, hour, to_date, count, sum, avg, when

spark = SparkSession.builder.appName("TransactionPatternAnalysis").getOrCreate()

df = spark.read.json("transactions.json")
approved_df = df.filter(col("status") == "approved")

print("\n===== 1. Peak transaction hours =====")
approved_df.withColumn("hour", hour(col("timestamp"))) \
    .groupBy("hour") \
    .count() \
    .orderBy(col("count").desc()) \
    .show(10)

print("\n===== 2. Top spending customers =====")
approved_df.groupBy("customer_id") \
    .agg(
        count("*").alias("transaction_count"),
        sum("amount").alias("total_spent")
    ) \
    .orderBy(col("total_spent").desc()) \
    .show(10)

print("\n===== 3. Behavior by merchant category =====")
approved_df.groupBy("merchant_category") \
    .agg(
        count("*").alias("transaction_count"),
        avg("amount").alias("avg_amount")
    ) \
    .orderBy(col("transaction_count").desc()) \
    .show()

print("\n===== 4. Time of day classification =====")
time_df = approved_df.withColumn("hour", hour(col("timestamp"))).withColumn(
    "time_of_day",
    when((col("hour") >= 5) & (col("hour") < 12), "morning")
    .when((col("hour") >= 12) & (col("hour") < 17), "afternoon")
    .when((col("hour") >= 17) & (col("hour") < 21), "evening")
    .otherwise("night")
)

time_df.groupBy("time_of_day") \
    .count() \
    .orderBy(col("count").desc()) \
    .show()

print("\n===== 5. Spending trend over time (daily) =====")
approved_df.withColumn("date", to_date(col("timestamp"))) \
    .groupBy("date") \
    .agg(sum("amount").alias("total_daily_spent")) \
    .orderBy("date") \
    .show(15)

spark.stop()