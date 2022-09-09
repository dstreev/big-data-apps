set hive.query.name="CC_ACCT External Update";
-- set hive.session.id="CC_ACCT External Update";

USE ${DATABASE}_ext;

-- Account Datasets: 2022-08-01 to 2022-08-10
-- Small Files on 2022-08-05

-- set tez.grouping.min-size = ${TEZ_GROUP_MIN_SIZE};
-- set tez.grouping.max-size = ${TEZ_GROUP_MAX_SIZE};

-- EXPLAIN FORMATTED
WITH
    CC_MERGED AS (SELECT
                      CCN,
                      FIRST_NAME,
                      LAST_NAME,
                      STREET_NUM,
                      STREET,
                      STATE,
                      LAST_UPDATE_TS,
                      '1' as UUID
                  FROM
                      CC_ACCT
                  UNION ALL
                  SELECT
                      CCN,
                      FIRST_NAME,
                      LAST_NAME,
                      CAST(STREET_NUM AS INT),
                      STREET,
                      S.STATE AS STATE,
                      CAST(LAST_UPDATE_TS AS BIGINT),
                      UUID
                  FROM
                      ${DATABASE}_INGEST.CC_ACCT_DELTA_INGEST D1, ${DATABASE}_INGEST.STATE S
                  WHERE
                      D1.ST = S.ABBREVIATION
                    AND D1.PROCESSING_CYCLE = "${PROCESSING_CYCLE}"),
    RANKED AS (SELECT
                   CCN,
                   FIRST_NAME,
                   LAST_NAME,
                   STREET_NUM,
                   STREET,
                   STATE,
                   LAST_UPDATE_TS,
                   rank() OVER (PARTITION BY CCN ORDER BY LAST_UPDATE_TS DESC, UUID DESC) AS RANK
               FROM CC_MERGED
               )
FROM
    RANKED
INSERT
OVERWRITE
TABLE
CC_ACCT
SELECT CCN,
       FIRST_NAME,
       LAST_NAME,
       STREET_NUM,
       STREET,
       STATE,
       LAST_UPDATE_TS
WHERE RANK = 1;

