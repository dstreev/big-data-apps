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
)
TBLPROPERTIES(
                 'transactional'='true',
                 'transactional_properties'='default');

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
    ST             STRING,
    LAST_UPDATE_TS TIMESTAMP
) PARTITIONED BY (
    YEAR_MONTH STRING
    )
TBLPROPERTIES(
                 'transactional'='true',
                 'transactional_properties'='insert_only');

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
        )
TBLPROPERTIES(
    'transactional'='true',
    'transactional_properties'='insert_only');
