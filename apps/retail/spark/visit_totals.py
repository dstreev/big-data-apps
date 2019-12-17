from pyspark.sql import SparkSession

spark = SparkSession \
    .builder \
    .appName("Python Spark SQL basic example") \
    .getOrCreate()

db = "spark_retail"

spark.sql("USE " + db)

df_cust = spark.sql("""SELECT 
                         ID, FULL_NAME, STATE 
                       FROM CUSTOMER""")

df_cstate = df_cust.filter("STATE='GA' OR STATE='NY'")

df_visits = spark.sql("""SELECT 
                            CUSTOMER_ID
                        FROM
                            VISIT""")
df_visits_cnt = df_visits.groupBy("CUSTOMER_ID").count()

df_purchases = spark.sql("""SELECT
                              CUSTOMER_ID,
                              ID,
                              TOTAL_PURCHASE
                            FROM
                                PURCHASE""")

df_full = df_cstate.join(df_visits_cnt, df_cstate.ID == df_visits_cnt.CUSTOMER_ID, "left").join(df_purchases, df_cstate.ID == df_purchases.CUSTOMER_ID, "left")

df_full.show()
