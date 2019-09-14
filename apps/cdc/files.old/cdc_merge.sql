CREATE database
IF NOT EXISTS cdc_merge;

use cdc_merge;

drop table cdc;
drop table cdc_source;
  
DROP TABLE cdc;
CREATE TABLE IF NOT EXISTS cdc(
    id String, 
    update_date TIMESTAMP, 
    source_code INT, 
    source_ip String,
    direction String, 
    target_ip String, 
    offset INT, 
    contrast BIGINT, 
    amount_due DOUBLE, 
    pass_due BOOLEAN, 
    interest DOUBLE) 
CLUSTERED BY (ID) into 2 buckets 
STORED AS ORC 
TBLPROPERTIES ('transactional'='true');

DROP TABLE cdc_source;
-- Populate the Merge Table from RAW.
-- It's important that there aren't any duplicates on the source table.
CREATE TABLE
    cdc_source STORED AS ORC AS
SELECT
    sub.id          ,
    sub.update_date ,
    sub.source_code ,
    sub.source_ip   ,
    sub.direction   ,
    sub.target_ip   ,
    sub.offset      ,
    sub.contrast    ,
    sub.amount_due  ,
    sub.pass_due    ,
    sub.interest
FROM
    (
 SELECT
          
          id          ,
          update_date ,
          source_code ,
          source_ip   ,
          direction   ,
          target_ip   ,
          offset      ,
          contrast    ,
          amount_due  ,
          pass_due    ,
          interest    ,
          rank() over(partition BY id ORDER BY update_date DESC) rank
     FROM
          cdc.cdc_raw
    WHERE
          proc_date='2017-11-02') sub
WHERE
    sub.rank=1;

--   
MERGE INTO cdc AS T 
USING cdc_source AS S
ON T.ID = S.ID
WHEN MATCHED AND (S.update_date > T.update_date) 
    THEN UPDATE SET update_date = S.update_date, source_code = S.source_code, source_ip = S.source_ip, direction = S.direction,
        target_ip = S.target_ip, offset = S.offset, contrast = S.contrast, amount_due = S.amount_due, pass_due = S.pass_due,
        interest = S.interest
WHEN NOT MATCHED 
    THEN INSERT VALUES (S.ID, S.update_date, S.source_code, S.source_ip, S.direction, S.target_ip, S.offset, 
        S.contrast, S.amount_due, S.pass_due, S.interest);


SELECT COUNT(*) FROM CDC;

