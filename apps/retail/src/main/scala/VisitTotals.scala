import org.apache.spark.SparkContext
import org.apache.spark.SparkConf
import org.apache.spark.sql.SparkSession
import com.hortonworks.hwc.HiveWarehouseSession
import com.hortonworks.hwc.HiveWarehouseSession._
import java.util.Date
import org.apache.spark.sql.functions._
//import org.apache.hadoop.hive.ql.exec.spark.session.SparkSession
import org.apache.spark.sql.functions.col


object VisitTotals {
  def main(args: Array[String]) {
    val start_time = new Date()

    val spark = SparkSession
      .builder()
      .appName("Visit Totals")
      .enableHiveSupport() // Key to Integrating with Hive Metastore
      .getOrCreate()

    spark.sql("USE " + args(0))

    val dfc = spark.sql("SELECT * FROM CUSTOMER")

    val dfc_state = dfc.filter("STATE = 'GA' OR STATE = 'NY'")

    val df_visit = spark.sql("SELECT * FROM VISIT")

    val df_visit_count = df_visit.groupBy("visit.customer_id").agg(count("id").alias("visit_count"))

    val df_purchase = spark.sql("SELECT * FROM PURCHASE").groupBy("customer_id").agg(sum("total_purchase"), count("id").alias("purchase_count"))

    //val dfj = dfc.join(df_visit_count, col("customer.id") === col("visit.customer_id"), "outer").join(df_purchase, col("id") === col("purchase.customer_id"), "outer")
    val dfj = dfc_state.join(df_visit_count, col("customer.id") === col("visit.customer_id"), "left").join(df_purchase, col("id") === col("purchase.customer_id"), "left")

    println( "Record Count: " + dfj.count())

//    dfj.show(100, false)

    val total_time = new Date().getTime - start_time.getTime

    println("Total Time: " + total_time)

  }
}
