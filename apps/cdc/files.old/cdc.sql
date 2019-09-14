
CREATE database IF NOT EXISTS cdc;

use cdc;
show tables;

-- Cleanup
drop table cdc;
drop table cdc_raw;

CREATE external TABLE
IF NOT EXISTS cdc_raw(id String, update_date TIMESTAMP, source_code INT, source_ip String,
  direction String, target_ip String, offset INT, contrast BIGINT, amount_due DOUBLE, pass_due
  BOOLEAN, interest DOUBLE) PARTITIONED BY(proc_date String) 
  ROW FORMAT DELIMITED FIELDS TERMINATED
  BY '\t'STORED AS TEXTFILE LOCATION '/user/dstreev/datasets/cdc_v1_raw';

msck repair table cdc_raw;

select * from cdc_raw limit 100;
select proc_date, count(*) from cdc_raw group by proc_date;

select count(distinct id) from cdc_raw where proc_date<='2017-11-01';

select count(*) from cdc_raw where proc_date<='2017-11-01';

select proc_date, count(*) from cdc_raw group by proc_date;

select proc_date, count(distinct id) from cdc_raw group by proc_date;

DROP TABLE CDC;
CREATE TABLE
    IF NOT EXISTS cdc STORED AS ORC AS
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
          cdc_raw
    WHERE
          proc_date='2017-11-01') sub
WHERE
    sub.rank=1;
  
ANALYZE TABLE CDC COMPUTE STATISTICS FOR COLUMNS;

SELECT * FROM CDC limit 100;

select count(*) from CDC;

INSERT
    OVERWRITE TABLE CDC
SELECT
    subb.id          ,
    subb.update_date ,
    subb.source_code ,
    subb.source_ip   ,
    subb.direction   ,
    subb.target_ip   ,
    subb.offset      ,
    subb.contrast    ,
    subb.amount_due  ,
    subb.pass_due    ,
    subb.interest
FROM
    (
 SELECT
          *,
          rank() over(partition BY suba.id ORDER BY suba.update_date DESC) rank
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
                interest
           FROM
                cdc
    UNION ALL
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
                interest
           FROM
                CDC_RAW
          WHERE
                proc_date='2017-11-03') suba) subb
WHERE
    subb.rank=1;
