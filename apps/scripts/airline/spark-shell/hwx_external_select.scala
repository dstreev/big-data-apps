import com.hortonworks.hwc.HiveWarehouseSession
import com.hortonworks.hwc.HiveWarehouseSession._

val hive = HiveWarehouseSession.session(spark).build()

hive.setDatabase("airline_perf")

hive.execute("show tables").show(100, false)

val df = hive.executeQuery("select flightdate, Operating_Airline,cancelled,origin, dest, Flight_Number_Operating_Airline, taxiout, taxiin from airline_perf_ext where origin = 'ATL' and dest = 'LGA' and operating_airline = 'DL' and year_ = '2018' and month_ = '10'")

df.show(1000, false)
