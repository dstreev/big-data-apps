USE ${database};

MERGE
INTO
    CC_ACCT AS ACCT
USING
    (
 SELECT
          sub.CCN       ,
          sub.FIRST_NAME,
          sub.LAST_NAME ,
          sub.STREET_NUM,
          sub.STREET    ,
          sub.STATE     ,
          sub.LAST_UPDATE_TS
     FROM
          (
       SELECT
                CCN       ,
                FIRST_NAME,
                LAST_NAME ,
                STREET_NUM,
                STREET    ,
                S.STATE AS STATE ,
                LAST_UPDATE_TS,
                rank() over(partition BY CCN ORDER BY LAST_UPDATE_TS DESC) rank
           FROM
                CC_ACCT_DELTA D1, STATE S
          WHERE
                D1.ST = S.ST
                PROCESSING_CYCLE = ${last.processing.cycle}
          ) sub
    WHERE
          sub.rank = 1) AS DELTA
 ON
    ACCT.CCN = DELTA.CCN
WHEN MATCHED
    AND(
      DELTA.LAST_UPDATE_TS > ACCT.LAST_UPDATE_TS) THEN
UPDATE
SET
    FIRST_NAME = DELTA.FIRST_NAME,
    LAST_NAME = DELTA.LAST_NAME  ,
    STREET_NUM = DELTA.STREET_NUM,
    STREET = DELTA.STREET        ,
    STATE = DELTA.STATE          ,
    LAST_UPDATE_TS = DELTA.LAST_UPDATE_TS 
WHEN NOT MATCHED THEN
INSERT
    VALUES
    (
      DELTA.CCN       ,
      DELTA.FIRST_NAME,
      DELTA.LAST_NAME ,
      DELTA.STREET_NUM,
      DELTA.STREET    ,
      DELTA.STATE     ,
      DELTA.LAST_UPDATE_TS
    ) ;