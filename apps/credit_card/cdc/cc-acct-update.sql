set hive.query.name="CC_ACCT ACID Update";
-- set hive.session.id="CC_ACCT ACID Update";

USE ${DATABASE};

-- Account Datasets: 2022-08-01 to 2022-08-10
-- Small Files on 2022-08-05

set tez.grouping.min-size = ${TEZ_GROUP_MIN_SIZE};
set tez.grouping.max-size = ${TEZ_GROUP_MAX_SIZE};

-- EXPLAIN FORMATTED
MERGE
INTO
    CC_ACCT AS ACCT
    USING
    (
        SELECT
            SUB.CCN,
            SUB.FIRST_NAME,
            SUB.LAST_NAME,
            SUB.STREET_NUM,
            SUB.STREET,
            SUB.STATE,
            SUB.LAST_UPDATE_TS
        FROM
            (
                -- Address possible duplicates.  Need to remove before the merge.
                -- Rank function is helpful here.  Similar to older techniques but done at a much
                -- smaller scale then against the entire dataset.
                SELECT
                    CCN,
                    FIRST_NAME,
                    LAST_NAME,
                    STREET_NUM,
                    STREET,
                    S.STATE AS                                                  STATE,
                    from_unixtime(cast(LAST_UPDATE_TS as INT)) as LAST_UPDATE_TS,
                    rank() OVER (PARTITION BY CCN ORDER BY LAST_UPDATE_TS DESC, UUID ASC) RANK
                FROM
                    ${DATABASE}_INGEST.CC_ACCT_DELTA_INGEST D1,
                    ${DATABASE}_INGEST.STATE S
                WHERE
                    D1.ST = S.ABBREVIATION AND D1.PROCESSING_CYCLE = "${PROCESSING_CYCLE}"
            ) SUB
        WHERE
            SUB.RANK = 1) AS DELTA
    ON
    ACCT.CCN = DELTA.CCN
WHEN MATCHED
    AND (
        DELTA.LAST_UPDATE_TS > ACCT.LAST_UPDATE_TS) THEN
    UPDATE
    SET
        FIRST_NAME = DELTA.FIRST_NAME,
        LAST_NAME = DELTA.LAST_NAME ,
        STREET_NUM = DELTA.STREET_NUM,
        STREET = DELTA.STREET ,
        STATE = DELTA.STATE ,
        LAST_UPDATE_TS = DELTA.LAST_UPDATE_TS
WHEN NOT MATCHED THEN
    INSERT
    VALUES
    (DELTA.CCN,
     DELTA.FIRST_NAME,
     DELTA.LAST_NAME,
     DELTA.STREET_NUM,
     DELTA.STREET,
     DELTA.STATE,
     DELTA.LAST_UPDATE_TS);