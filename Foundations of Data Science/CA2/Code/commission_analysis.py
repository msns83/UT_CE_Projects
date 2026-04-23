from pyspark.sql import SparkSession
from pyspark.sql.functions import col, sum, avg, round

spark = SparkSession.builder.appName("DetailedCommissionAnalysis").getOrCreate()

df = spark.read.json("transactions.json")
approved_df = df.filter(col("status") == "approved")

commission_by_type = approved_df.groupBy("merchant_category", "commission_type").agg(
    sum("commission_amount").alias("total_commission"),
    avg("commission_amount").alias("avg_commission"),
    round(sum("commission_amount") / sum("amount"), 4).alias("commission_to_amount_ratio")
)

commission_by_type = commission_by_type.orderBy(col("total_commission").desc())
commission_by_type.show(truncate=False)
spark.stop()