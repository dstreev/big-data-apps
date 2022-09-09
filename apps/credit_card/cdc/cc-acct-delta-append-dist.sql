set hive.query.name="CC_ACCT_DELTA Append (ACID) with Distribute";
-- set hive.session.id="CC_ACCT_DELTA Append (ACID) with Distribute";

USE ${DATABASE};

-- Account Datasets: 2022-08-01 to 2022-08-10
-- Small Files on 2022-08-05

set tez.grouping.min-size = ${TEZ_GROUP_MIN_SIZE};
set tez.grouping.max-size = ${TEZ_GROUP_MAX_SIZE};

-- EXPLAIN FORMATTED
INSERT INTO TABLE CC_ACCT_DELTA
SELECT
    CCN,
    FIRST_NAME,
    LAST_NAME,
    STREET_NUM,
    STREET,
    ST,
    from_unixtime(cast(LAST_UPDATE_TS AS INT))            AS LAST_UPDATE_TS,
    from_unixtime(cast(LAST_UPDATE_TS AS INT), "yyyy_MM") AS YEAR_MONTH
FROM
    ${DATABASE}_INGEST.CC_ACCT_DELTA_INGEST D1
WHERE
      D1.PROCESSING_CYCLE = "${PROCESSING_CYCLE}"
DISTRIBUTE BY
--     from_unixtime(cast(LAST_UPDATE_TS AS INT), "yyyy_MM");
    YEAR_MONTH;