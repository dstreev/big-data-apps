CREATE DATABASE
    IF NOT EXISTS ${DATABASE};

USE ${DATABASE};

DROP TABLE
    IF EXISTS CC_ACCT;

-- Managed ACID Table for CURRENT Account Info.
CREATE TABLE
    IF NOT EXISTS CC_ACCT
(
    CCN            STRING,
    FIRST_NAME     STRING,
    LAST_NAME      STRING,
    STREET_NUM     INT,
    STREET         STRING,
    STATE          STRING,
    LAST_UPDATE_TS TIMESTAMP
);

DROP TABLE
    IF EXISTS CC_ACCT_DELTA;

-- Managed ACID Table for Delta Account Info.
CREATE TABLE
    IF NOT EXISTS CC_ACCT_DELTA
(
    CCN            STRING,
    FIRST_NAME     STRING,
    LAST_NAME      STRING,
    STREET_NUM     INT,
    STREET         STRING,
    STATE          STRING,
    LAST_UPDATE_TS TIMESTAMP
) PARTITIONED BY (
    YEAR_MONTH STRING
    );

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
    LAST_UPDATE_TS INT,
    UUID           STRING COMMENT "Used for addition sort and build unique record"
)
    PARTITIONED BY
        (
        PROCESSING_CYCLE STRING
        )
    ROW FORMAT SERDE
        'org.apache.hadoop.hive.serde2.OpenCSVSerde'
    STORED AS TEXTFILE
    TBLPROPERTIES ("external.table.purge" = "true", "discover.partitions" = "true","partition.retention.period" = "true","partition.retention.period" = "7d");


DROP TABLE
    IF EXISTS CC_TRANS;

-- The Managed CC Transaction Table
CREATE TABLE
    IF NOT EXISTS CC_TRANS
(
    CC_TRANS STRING,
    CCN      STRING,
    TRANS_TS BIGINT,
    MCC      INT,
    MRCH_ID  STRING,
    ST       STRING,
    AMNT     DOUBLE
)
    PARTITIONED BY
        (
        YEAR_MONTH STRING
        );

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
    STORED AS TEXTFILE;

CREATE EXTERNAL TABLE IF NOT EXISTS STATE
(
    ABBREVIATION STRING,
    STATE        STRING
) ROW FORMAT DELIMITED
    FIELDS TERMINATED BY ','
    STORED AS TEXTFILE;