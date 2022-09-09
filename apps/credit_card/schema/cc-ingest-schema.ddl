CREATE DATABASE
    IF NOT EXISTS ${DATABASE}_ingest;

USE ${DATABASE}_ingest;

DROP TABLE
    IF EXISTS CC_ACCT_DELTA_INGEST;

-- The Ingest table with the CDC Account Records.
CREATE EXTERNAL TABLE
    IF NOT EXISTS CC_ACCT_DELTA_INGEST
(
    CCN            STRING,
    FIRST_NAME     STRING,
    LAST_NAME      STRING,
    STREET_NUM     INT,
    STREET         STRING,
    ST             STRING,
    LAST_UPDATE_TS BIGINT,
    UUID           STRING COMMENT "Used for addition sort and build unique record"
)
    PARTITIONED BY
        (
        PROCESSING_CYCLE STRING
        )
    ROW FORMAT SERDE
        'org.apache.hadoop.hive.serde2.OpenCSVSerde'
    STORED AS TEXTFILE
    TBLPROPERTIES ("discover.partitions" = "true");

DROP TABLE
    IF EXISTS CC_TRANS_INGEST;

-- The Load table for CC Transactions.
CREATE EXTERNAL TABLE
    IF NOT EXISTS CC_TRANS_INGEST
(
    CC_TRANS STRING,
    CCN      STRING,
    TRANS_TS TIMESTAMP,
    MCC      INT,
    MRCH_ID  STRING,
    STATE    STRING,
    AMNT     DOUBLE
)
    PARTITIONED BY
        (
        PROCESSING_CYCLE STRING
        )
    ROW FORMAT SERDE
        'org.apache.hadoop.hive.serde2.OpenCSVSerde'
    STORED AS TEXTFILE
    TBLPROPERTIES ("discover.partitions" = "true");

DROP TABLE IF EXISTS STATE;

CREATE EXTERNAL TABLE IF NOT EXISTS STATE
(
    ABBREVIATION STRING,
    STATE        STRING
) ROW FORMAT DELIMITED
    FIELDS TERMINATED BY ','
    STORED AS TEXTFILE;