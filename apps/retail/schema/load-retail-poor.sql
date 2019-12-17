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


-- BAD LOAD PROCESS for Hive and Spark
-- Produces 387k files in Spark
/*
 Hive Load:
 File Count: 2.3 K       35.1 K            831.8 M /warehouse/tablespace/managed/hive/retail.db/purchase
 ----------------------------------------------------------------------------------------------
        VERTICES      MODE        STATUS  TOTAL  COMPLETED  RUNNING  PENDING  FAILED  KILLED
----------------------------------------------------------------------------------------------
Map 3 ..........      llap     SUCCEEDED     30         30        0        0       0       0
Map 1 ..........      llap     SUCCEEDED     30         30        0        0       0       0
Reducer 2 ......      llap     SUCCEEDED     12         12        0        0       0       0
----------------------------------------------------------------------------------------------
VERTICES: 03/03  [==========================>>] 100%  ELAPSED TIME: 674.52 s
----------------------------------------------------------------------------------------------
INFO  : Starting task [Stage-2:DEPENDENCY_COLLECTION] in serial mode
INFO  : Starting task [Stage-0:MOVE] in serial mode
INFO  : Loading data to table retail.purchase partition (purchase_date=null) from hdfs://HOME90/warehouse/tablespace/managed/hive/retail.db/purchase/.hive-staging_hive_2019-12-16_04-40-56_484_4287135781764705316-2/-ext-10000
INFO  :

INFO  :          Time taken to load dynamic partitions: 138.278 seconds
INFO  :          Time taken for adding to write entity : 0.168 seconds
INFO  : Starting task [Stage-3:STATS] in serial mode
INFO  : Completed executing command(queryId=hive_20191216044056_18c9d985-ec80-40e1-b79b-29248ddf2333); Time taken: 675.389 seconds
INFO  : OK
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
    CAST(VS.VISIT_TS AS DATE) AS PURCHASE_DATE
FROM
    ${SRC_DB}.PURCHASE_SRC PS
        JOIN ${SRC_DB}.VISIT_SRC VS ON PS.VISIT_ID = VS.ID;
