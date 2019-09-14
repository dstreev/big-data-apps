USE streaming_cc;

-- Create Tables
--DROP TABLE CC_TRANS_ALT_FROM_STREAMING;

CREATE TABLE
  IF NOT EXISTS CC_TRANS_ALT_FROM_STREAMING
(
  CC_TRANS STRING   ,                     
  CCN STRING        ,
  TRANS_TS BIGINT,
  ST STRING      ,
  AMNT DOUBLE
)
  PARTITIONED BY
(
  PROCESSING_CYCLE STRING
);

DROP TABLE CC_TRANS_ALT_FROM_STREAMING_EXT;

CREATE EXTERNAL TABLE
  IF NOT EXISTS CC_TRANS_ALT_FROM_STREAMING_EXT
(
  CC_TRANS STRING   ,                     
  CCN STRING        ,
  TRANS_TS BIGINT,
  ST STRING      ,
  AMNT DOUBLE
)
  PARTITIONED BY
(
  PROCESSING_CYCLE STRING
)
ROW FORMAT DELIMITED
  FIELDS TERMINATED BY ','
STORED AS TEXTFILE 
LOCATION
  '/user/nifi/datasets/external/cc_trans_alt';
;

-- Compaction Options

ALTER TABLE
    cc_trans_alt_from_streaming PARTITION(processing_cycle='2019-02-14') COMPACT 'major';

ALTER TABLE
    cc_trans_alt_from_streaming PARTITION(processing_cycle='2019-02-14') COMPACT 'minor';

SHOW COMPACTIONS;


-- Select Queries

SELECT
    st,
    sum(amnt)
FROM
    cc_trans_alt_from_streaming
WHERE
    processing_cycle='2019-02-14'
GROUP BY
    st
ORDER BY st;
 
--    
SELECT
    st,
    sum(amnt)
FROM
    cc_trans_alt_from_streaming_ext
WHERE
    processing_cycle='2019-02-14'
GROUP BY
    st
ORDER BY st;
 
 
        
SELECT
    INPUT__FILE__NAME,
    --st,
    COUNT(*)
FROM
    cc_trans_alt_from_streaming
WHERE
    processing_cycle='2019-02-14'
GROUP BY
    INPUT__FILE__NAME;    
    
MSCK REPAIR TABLE cc_trans_alt_from_streaming_ext;