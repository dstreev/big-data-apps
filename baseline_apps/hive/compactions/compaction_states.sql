USE HIVE_90;

-- CompactionTxnHandler line 78.  Checking for tables/partitions to review for compactions.
SELECT DISTINCT
    TC.CTC_DATABASE,
    TC.CTC_TABLE,
    TC.CTC_PARTITION
FROM
    COMPLETED_TXN_COMPONENTS TC
        LEFT JOIN (
        SELECT
            C1.*
        FROM
            COMPLETED_COMPACTIONS C1
                INNER JOIN (
                SELECT
                    max(CC_ID) CC_ID
                FROM
                    COMPLETED_COMPACTIONS
                GROUP BY CC_DATABASE, CC_TABLE, CC_PARTITION
            ) C2
                           ON C1.CC_ID = C2.CC_ID
        WHERE
            -- attemped or failed
            C1.CC_STATE IN ("a", "f")
    ) C
                  ON TC.CTC_DATABASE = C.CC_DATABASE AND TC.CTC_TABLE = C.CC_TABLE
                      AND (TC.CTC_PARTITION = C.CC_PARTITION OR (TC.CTC_PARTITION IS NULL AND C.CC_PARTITION IS NULL))
WHERE
     C.CC_ID IS NOT NULL
  OR TC.CTC_TIMESTAMP >= current_timestamp - INTERVAL 300 SECOND;

-- Checking for Aborted Txn.
SELECT
    TC_DATABASE
  , TC_TABLE
  , TC_PARTITION
  , count(*)
FROM
    TXNS,
    TXN_COMPONENTS
WHERE
      TXN_ID = TC_TXNID
  AND TXN_STATE = 'TXN_ABORTED'
GROUP BY
    TC_DATABASE, TC_TABLE, TC_PARTITION;


-- HAVING
--    count(*) >  + abortedThreshold;

SELECT
    max(CC_ID) CC_ID
FROM
    COMPLETED_COMPACTIONS
GROUP BY
    CC_DATABASE, CC_TABLE, CC_PARTITION;