CREATE EXTERNAL TABLE raw (
    vin STRING,
    field1 STRING,
    field2 STRING,
    field3 STRING,
    year_ STRING,
    month_ STRING
)
    ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde'
        WITH
        SERDEPROPERTIES (
            "separatorChar" = ",",
            "quoteChar" = "\"", "escapeChar" = "\\"
            )
    STORED AS TEXTFILE
    LOCATION '/user/dstreev/datasets/vin';

CREATE TABLE vin (
    vin STRING,
    field1 STRING,
    field2 STRING,
    field3 STRING
)
PARTITIONED BY (year_ STRING, month_ STRING)
CLUSTERED BY (vin) INTO 10 BUCKETS
    STORED AS ORC
TBLPROPERTIES ('transactional'='true');

CREATE TABLE vin2 (
                     vin STRING,
                     field1 STRING,
                     field2 STRING,
                     field3 STRING
)
PARTITIONED BY (year_ STRING, month_ STRING);

INSERT INTO vin PARTITION (year_, month_)
SELECT
    vin, field1, field2, field3, year_, month_
FROM raw;

INSERT INTO vin2 PARTITION (year_, month_)
SELECT
    vin, field1, field2, field3, year_, month_
FROM raw
DISTRIBUTE BY vin SORT BY year_, month_;

FROM raw
INSERT INTO vin PARTITION (year_, month_)
SELECT
    vin, field1, field2, field3, year_, month_
WHERE
    year_ = "2020"
    and month_ = "10"
INSERT INTO vin PARTITION (year_, month_)
SELECT
    vin, field1, field2, field3, year_, month_
WHERE
      year_ != "2020"
  and month_ != "10";

set hive.optimize.sort.dynamic.partition.threshold=-1;
set hive.optimize.sort.dynamic.partition.threshold=0;
set hive.optimize.sort.dynamic.partition.threshold=1;