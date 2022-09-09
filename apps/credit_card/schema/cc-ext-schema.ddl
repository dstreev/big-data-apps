CREATE DATABASE
    IF NOT EXISTS ${DATABASE}_ext;

USE ${DATABASE}_ext;

DROP TABLE
    IF EXISTS CC_ACCT;

-- Managed ACID Table for CURRENT Account Info.
CREATE EXTERNAL TABLE
    IF NOT EXISTS CC_ACCT
(
    CCN            STRING,
    FIRST_NAME     STRING,
    LAST_NAME      STRING,
    STREET_NUM     INT,
    STREET         STRING,
    STATE          STRING,
    LAST_UPDATE_TS BIGINT
)
STORED AS ORC
TBLPROPERTIES(
    'external.table.purge'='true');

DROP TABLE
    IF EXISTS CC_TRANS;

-- The Managed CC Transaction Table
CREATE EXTERNAL TABLE
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
        )
STORED AS ORC
TBLPROPERTIES(
    'external.table.purge'='true');
