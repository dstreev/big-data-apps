import java.util.Date

import com.hortonworks.hwc.HiveWarehouseSession
import com.hortonworks.hwc.HiveWarehouseSession._
import org.apache.spark.sql.SparkSession

import org.apache.spark.sql.functions._

object VisitTotalsHWCv2 {
  def main(args: Array[String]) {

    val start_time = new Date()

    val spark = SparkSession.builder.appName("Visit Totals HWCv2").getOrCreate()

    val hive = HiveWarehouseSession.session(spark).build()

    val db = args(0)
    hive.setDatabase(db)

    val dfc = hive.executeQuery("SELECT * FROM CUSTOMER")

    val dfc_state = dfc.filter("STATE = 'GA' OR STATE = 'NY'")

    val df_visit = hive.executeQuery("SELECT * FROM VISIT")

    val df_visit_count = df_visit.groupBy("customer_id").agg(count("id").alias("visit_count"))

    val df_purchase = hive.executeQuery("SELECT * FROM PURCHASE").groupBy("customer_id").agg(sum("total_purchase"), count("id").alias("purchase_count"))

    //val dfj = dfc.join(df_visit_count, col("customer.id") === col("visit.customer_id"), "outer").join(df_purchase, col("id") === col("purchase.customer_id"), "outer")
    //val dfj = dfc_state.join(df_visit_count, col("id") === col("customer_id"), "outer").join(df_purchase, col("id") === col("customer_id"), "outer")

    val df_asCustomer = dfc_state.as("customer")
    val df_asVisit = df_visit_count.as("visit")
    val df_asPurchase = df_purchase.as("purchase")

    val dfj = df_asCustomer.join(df_asVisit, col("customer.id") === col("visit.customer_id"), "outer").join(df_asPurchase, col("customer.id") === col("purchase.customer_id"), "outer")

    dfj.show(100, false)

    val total_time = new Date().getTime - start_time.getTime

    println("Total Time: " + total_time)

  }
}
