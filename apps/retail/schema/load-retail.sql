USE ${TARGET_DB};

INSERT OVERWRITE TABLE
    CUSTOMER
SELECT
    ID,
    FULL_NAME,
    ADDRESS,
    STATE,
    CONTACT_NUM
FROM
    ${SRC_DB}.CUSTOMER_SRC;

INSERT OVERWRITE TABLE
    VISIT PARTITION (visit_date)
SELECT
    ID,
    CUSTOMER_ID,
    VISIT_TS,
    STAY_TIME,
    CAST(VISIT_TS as DATE) as VISIT_DATE
FROM
    ${SRC_DB}.VISIT_SRC;

/*

 For Spark:
 Produces GOOD FILE DISTRO
  1.1 K        1.1 K           1000.9 M /warehouse/tablespace/external/spark/retail.db/purchase
  MUCH FASTER CREATION!!!!
*/
/*
 Hive Load: Produces GOOD File Distro
2.3 K        2.3 K            623.1 M /warehouse/tablespace/managed/hive/retail.db/purchase
 ----------------------------------------------------------------------------------------------
        VERTICES      MODE        STATUS  TOTAL  COMPLETED  RUNNING  PENDING  FAILED  KILLED
----------------------------------------------------------------------------------------------
Map 2 ..........      llap     SUCCEEDED     30         30        0        0       0       0
Map 1 ..........      llap     SUCCEEDED     30         30        0        0       0       0
Map 5 ..........      llap     SUCCEEDED     30         30        0        0       0       0
Reducer 3 ......      llap     SUCCEEDED     12         12        0        0       0       0
Reducer 4 ......      llap     SUCCEEDED     12         12        0        0       0       0
----------------------------------------------------------------------------------------------
VERTICES: 05/05  [==========================>>] 100%  ELAPSED TIME: 440.97 s
----------------------------------------------------------------------------------------------
INFO  : Starting task [Stage-2:DEPENDENCY_COLLECTION] in serial mode
INFO  : Starting task [Stage-0:MOVE] in serial mode
INFO  : Loading data to table retail.purchase partition (purchase_date=null) from hdfs://HOME90/warehouse/tablespace/managed/hive/retail.db/purchase/.hive-staging_hive_2019-12-16_04-55-46_121_4982933263069354920-5/-ext-10000
INFO  :

INFO  :          Time taken to load dynamic partitions: 144.694 seconds
INFO  :          Time taken for adding to write entity : 0.172 seconds
INFO  : Starting task [Stage-3:STATS] in serial mode
INFO  : Completed executing command(queryId=hive_20191216045546_1c51fddf-951e-4091-b749-e1270b943af0); Time taken: 441.456 seconds
INFO  : OK
No rows affected (442.672 seconds)
 */
INSERT INTO TABLE
    PURCHASE PARTITION (PURCHASE_DATE)
SELECT
    PS.ID,
    PS.CUSTOMER_ID,
    PS.VISIT_ID,
    PS.SALES_REP,
    PS.REGISTER,
    PS.TRANSACTION_ID,
    PS.DISCOUNT,
    PS.DISCOUNT_CODE,
    PS.TOTAL_PURCHASE,
    PS.TENDER_TYPE,
    VS.VISIT_TS AS PURCHASE_TS,
    VS2.G_DATE  AS PURCHASE_DATE
FROM
    ${SRC_DB}.PURCHASE_SRC PS
        JOIN ${SRC_DB}.VISIT_SRC VS ON PS.VISIT_ID = VS.ID
        JOIN (SELECT DISTINCT CAST(VISIT_TS AS DATE) AS G_DATE FROM ${SRC_DB}.VISIT_SRC) VS2
             ON CAST(VS.VISIT_TS AS DATE) = VS2.G_DATE;