import java.util.Date

import com.hortonworks.hwc.HiveWarehouseSession
import com.hortonworks.hwc.HiveWarehouseSession._
import org.apache.spark.sql.SparkSession


object VisitTotalsHWCv1 {
  def main(args: Array[String]) {

    val start_time = new Date()
    val spark = SparkSession.builder.appName("Visit Totals HWCv1").getOrCreate()

    val hive = HiveWarehouseSession.session(spark).build()

    val db = args(0)

    hive.setDatabase(db)

    val df = hive.executeQuery(
      """
        |SELECT
        |    C.ID AS CUSTOMER_ID,
        |    FULL_NAME,
        |    NUM_OF_VISITS,
        |    PURCHASE_COUNT,
        |    TOTAL_PURCHASES
        |FROM
        |    CUSTOMER C
        |        LEFT OUTER JOIN
        |        (SELECT
        |             CUSTOMER_ID,
        |             count(*) AS NUM_OF_VISITS
        |         FROM
        |             VISIT
        |         GROUP BY CUSTOMER_ID) V ON C.ID = V.CUSTOMER_ID
        |        LEFT OUTER JOIN
        |        (SELECT
        |             CUSTOMER_ID,
        |             count(ID)           AS PURCHASE_COUNT,
        |             sum(TOTAL_PURCHASE) AS TOTAL_PURCHASES
        |         FROM
        |             PURCHASE
        |         GROUP BY CUSTOMER_ID) P ON C.ID = P.CUSTOMER_ID
        |WHERE
        |    C.STATE = "GA" or C.STATE = "NY"
        |""".stripMargin)

    df.show(100, false)

    val total_time = new Date().getTime - start_time.getTime

    println("Total Time: " + total_time)

  }
}
