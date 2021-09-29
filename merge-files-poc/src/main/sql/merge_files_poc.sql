CREATE DATABASE IF NOT EXISTS ${DB};

USE ${DB};

CREATE EXTERNAL TABLE merge_files_source
(
    region      STRING,
    country     STRING,
    report_date TIMESTAMP,
    output      STRING,
    amount      DOUBLE,
    longs       BIGINT,
    types       STRING,
    count       STRING,
    now         DATE,
    seq         STRING,
    field1      STRING,
    field2      STRING,
    field3      STRING,
    field4      BIGINT,
    field5      STRING,
    field6      STRING,
    field7      STRING,
    field8      STRING
)
    ROW FORMAT SERDE
        'org.apache.hadoop.hive.serde2.OpenCSVSerde'
    STORED AS TEXTFILE
    LOCATION "/user/dstreev/merge-files";



SELECT *
FROM
    merge_files_source
LIMIT 10;

SELECT
    to_date(report_date)
FROM
    merge_files_source
LIMIT 10;

DROP TABLE IF EXISTS merge_files_part;
CREATE EXTERNAL TABLE merge_files_part
(
    report_timestamp TIMESTAMP,
    output STRING,
    amount DOUBLE,
    longs  BIGINT,
    types  STRING,
    count  STRING,
    now    DATE,
    seq    STRING,
    field1 STRING,
    field2 STRING,
    field3 STRING,
    field4 BIGINT,
    field5 STRING,
    field6 STRING,
    field7 STRING,
    field8 STRING
)
    PARTITIONED BY (
        region STRING, country STRING, report_date STRING
        )
    STORED AS ORC
    TBLPROPERTIES (
        'external.table.purge' = 'true'
        );

-- with index and bloom
DROP TABLE IF EXISTS merge_files_part;
CREATE EXTERNAL TABLE merge_files_part
(
    report_timestamp TIMESTAMP,
    output STRING,
    amount DOUBLE,
    longs  BIGINT,
    types  STRING,
    count  STRING,
    now    DATE,
    seq    STRING,
    field1 STRING,
    field2 STRING,
    field3 STRING,
    field4 BIGINT,
    field5 STRING,
    field6 STRING,
    field7 STRING,
    field8 STRING
)
    PARTITIONED BY (
        region STRING, country STRING, report_date STRING
        )
    STORED AS ORC
    TBLPROPERTIES (
        'external.table.purge' = 'true'
        ,'orc.create.index'='true'
        ,'orc.bloom.filter.columns'='output'
        ,'orc.bloom.filter.fpp'='0.05'
        );


-- skewed bomb....
CREATE EXTERNAL TABLE merge_files_part
(
    report_timestamp TIMESTAMP,
    output STRING,
    amount DOUBLE,
    longs  BIGINT,
    types  STRING,
    count  STRING,
    now    DATE,
    seq    STRING,
    field1 STRING,
    field2 STRING,
    field3 STRING,
    field4 BIGINT,
    field5 STRING,
    field6 STRING,
    field7 STRING,
    field8 STRING
)
    PARTITIONED BY (
        region STRING, country STRING, report_date STRING
        )
    SKEWED BY (region, country) ON ("NA", "US")
    STORED AS ORC
    TBLPROPERTIES (
        'external.table.purge' = 'true'
        );

-- For resetting tests.
DROP TABLE IF EXISTS merge_files_part;

-- Baseline Test
-- Simple copy, no merge.
set hive.merge.tezfiles=false;
set hive.optimize.sort.dynamic.partition.threshold=-1;

EXPLAIN
FROM
    merge_files_source
INSERT
INTO
    merge_files_part PARTITION (region, country, report_date)
SELECT
    report_date,
    output,
    amount,
    longs,
    types,
    count,
    now,
    seq,
    field1,
    field2,
    field3,
    field4,
    field5,
    field6,
    field7,
    field8,
    region,
    country,
    to_date(report_date) as report_date;

/*
 ----------------------------------------------------------------------------------------------
        VERTICES      MODE        STATUS  TOTAL  COMPLETED  RUNNING  PENDING  FAILED  KILLED
----------------------------------------------------------------------------------------------
Map 1 .......... container     SUCCEEDED     37         37        0        0       0       0
Reducer 2 ...... container     SUCCEEDED     36         36        0        0       0       0
----------------------------------------------------------------------------------------------
VERTICES: 02/02  [==========================>>] 100%  ELAPSED TIME: 256.45 s
----------------------------------------------------------------------------------------------

 1260 Partitions

 /warehouse/tablespace/external/hive/merge_files.db on hdfs://HOME90
➔ count -h
       1.3 K       44.6 K            197.5 M /warehouse/tablespace/external/hive/merge_files.db

 +----------------------------------------------------+
|                      Explain                       |
+----------------------------------------------------+
| Plan optimized by CBO.                             |
|                                                    |
| Vertex dependency in root stage                    |
| Reducer 2 <- Map 1 (SIMPLE_EDGE)                   |
|                                                    |
| Stage-3                                            |
|   Stats Work{}                                     |
|     Stage-0                                        |
|       Move Operator                                |
|         table:{"name:":"merge_files.merge_files_part"} |
|         Stage-2                                    |
|           Dependency Collection{}                  |
|             Stage-1                                |
|               Reducer 2                            |
|               File Output Operator [FS_10]         |
|                 Select Operator [SEL_9] (rows=1510941 width=3129) |
|                   Output:["_col0","_col1","_col2","_col3","_col4","_col5","_col6","_col7","_col8","_col9","_col10","_col11","_col12","_col13","_col14","_col15","_col16","_col17"] |
|                   Group By Operator [GBY_8] (rows=1510941 width=3129) |
|                     Output:["_col0","_col1","_col2","_col3","_col4","_col5","_col6","_col7","_col8","_col9","_col10","_col11","_col12","_col13","_col14","_col15","_col16","_col17"],aggregations:["compute_stats(VALUE._col0)","compute_stats(VALUE._col1)","compute_stats(VALUE._col2)","compute_stats(VALUE._col3)","compute_stats(VALUE._col4)","compute_stats(VALUE._col5)","compute_stats(VALUE._col6)","compute_stats(VALUE._col7)","compute_stats(VALUE._col8)","compute_stats(VALUE._col9)","compute_stats(VALUE._col10)","compute_stats(VALUE._col11)","compute_stats(VALUE._col12)","compute_stats(VALUE._col13)","compute_stats(VALUE._col14)"],keys:KEY._col0, KEY._col1, KEY._col2 |
|                   <-Map 1 [SIMPLE_EDGE]            |
|                     File Output Operator [FS_3]    |
|                       table:{"name:":"merge_files.merge_files_part"} |
|                       Select Operator [SEL_1] (rows=3021883 width=3129) |
|                         Output:["_col0","_col1","_col2","_col3","_col4","_col5","_col6","_col7","_col8","_col9","_col10","_col11","_col12","_col13","_col14","_col15","_col16","_col17"] |
|                         TableScan [TS_0] (rows=3021883 width=3129) |
|                           merge_files@merge_files_source,merge_files_source,Tbl:COMPLETE,Col:NONE,Output:["output","amount","longs","types","count","now","seq","field1","field2","field3","field4","field5","field6","field7","field8","region","country","report_date"] |
|                     SHUFFLE [RS_7]                 |
|                       PartitionCols:_col0, _col1, _col2 |
|                       Group By Operator [GBY_6] (rows=3021883 width=3129) |
|                         Output:["_col0","_col1","_col2","_col3","_col4","_col5","_col6","_col7","_col8","_col9","_col10","_col11","_col12","_col13","_col14","_col15","_col16","_col17"],aggregations:["compute_stats(output, 'hll')","compute_stats(amount, 'hll')","compute_stats(longs, 'hll')","compute_stats(types, 'hll')","compute_stats(count, 'hll')","compute_stats(now, 'hll')","compute_stats(seq, 'hll')","compute_stats(field1, 'hll')","compute_stats(field2, 'hll')","compute_stats(field3, 'hll')","compute_stats(field4, 'hll')","compute_stats(field5, 'hll')","compute_stats(field6, 'hll')","compute_stats(field7, 'hll')","compute_stats(field8, 'hll')"],keys:region, country, report_date |
|                         Select Operator [SEL_5] (rows=3021883 width=3129) |
|                           Output:["output","amount","longs","types","count","now","seq","field1","field2","field3","field4","field5","field6","field7","field8","region","country","report_date"] |
|                            Please refer to the previous Select Operator [SEL_1] |
|                                                    |
+----------------------------------------------------+
 */

-- Merge Tez Files
-- No sorting
set hive.merge.tezfiles=true;
set hive.optimize.sort.dynamic.partition.threshold=-1; -- default
EXPLAIN
FROM
    merge_files_source
INSERT
INTO
    merge_files_part PARTITION (region, country, report_date)
SELECT
    report_date,
    output,
    amount,
    longs,
    types,
    count,
    now,
    seq,
    field1,
    field2,
    field3,
    field4,
    field5,
    field6,
    field7,
    field8,
    region,
    country,
    to_date(report_date) as report_date;

/*
----------------------------------------------------------------------------------------------
        VERTICES      MODE        STATUS  TOTAL  COMPLETED  RUNNING  PENDING  FAILED  KILLED
----------------------------------------------------------------------------------------------
Map 1 .........  container       RUNNING     37         34        3        0       0       0
Reducer 2        container       RUNNING     36          0       36        0       0       0
----------------------------------------------------------------------------------------------
VERTICES: 00/02  [============>>--------------] 46%   ELAPSED TIME: 120.51 s
----------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------
        VERTICES      MODE        STATUS  TOTAL  COMPLETED  RUNNING  PENDING  FAILED  KILLED
----------------------------------------------------------------------------------------------
File Merge ..... container     SUCCEEDED   1260       1260        0        0       0       0
----------------------------------------------------------------------------------------------
VERTICES: 01/01  [==========================>>] 100%  ELAPSED TIME: 219.13 s
----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------
-- Question: Is there a setting to control the number of threads for file merge or is that related to the tasks you see?

/warehouse/tablespace/external/hive/merge_files.db on hdfs://HOME90
➔ count -h merge_files_part/*
         225          210             19.2 M /warehouse/tablespace/external/hive/merge_files.db/merge_files_part/region=APAC
         225          210             12.4 M /warehouse/tablespace/external/hive/merge_files.db/merge_files_part/region=EU
         225          210             12.4 M /warehouse/tablespace/external/hive/merge_files.db/merge_files_part/region=MIDEAST
         225          210             99.6 M /warehouse/tablespace/external/hive/merge_files.db/merge_files_part/region=NA
         225          210             12.4 M /warehouse/tablespace/external/hive/merge_files.db/merge_files_part/region=RUSSIA
         225          210             12.4 M /warehouse/tablespace/external/hive/merge_files.db/merge_files_part/region=SA

 */
 +----------------------------------------------------+
|                      Explain                       |
+----------------------------------------------------+
| Plan optimized by CBO.                             |
|                                                    |
| Vertex dependency in root stage                    |
| Reducer 2 <- Map 1 (SIMPLE_EDGE)                   |
|                                                    |
| Stage-3                                            |
|   Stats Work{}                                     |
|     Stage-0                                        |
|       Move Operator                                |
|         table:{"name:":"merge_files.merge_files_part"} |
|         Stage-2                                    |
|           Dependency Collection{}                  |
|             Stage-5(CONDITIONAL)                   |
|               Move Operator                        |
|                 Stage-8(CONDITIONAL CHILD TASKS: Stage-5, Stage-4, Stage-6) |
|                   Conditional Operator             |
|                     Stage-1                        |
|                       Reducer 2                    |
|                       File Output Operator [FS_10] |
|                         Select Operator [SEL_9] (rows=1510941 width=3129) |
|                           Output:["_col0","_col1","_col2","_col3","_col4","_col5","_col6","_col7","_col8","_col9","_col10","_col11","_col12","_col13","_col14","_col15","_col16","_col17"] |
|                           Group By Operator [GBY_8] (rows=1510941 width=3129) |
|                             Output:["_col0","_col1","_col2","_col3","_col4","_col5","_col6","_col7","_col8","_col9","_col10","_col11","_col12","_col13","_col14","_col15","_col16","_col17"],aggregations:["compute_stats(VALUE._col0)","compute_stats(VALUE._col1)","compute_stats(VALUE._col2)","compute_stats(VALUE._col3)","compute_stats(VALUE._col4)","compute_stats(VALUE._col5)","compute_stats(VALUE._col6)","compute_stats(VALUE._col7)","compute_stats(VALUE._col8)","compute_stats(VALUE._col9)","compute_stats(VALUE._col10)","compute_stats(VALUE._col11)","compute_stats(VALUE._col12)","compute_stats(VALUE._col13)","compute_stats(VALUE._col14)"],keys:KEY._col0, KEY._col1, KEY._col2 |
|                           <-Map 1 [SIMPLE_EDGE]    |
|                             File Output Operator [FS_3] |
|                               table:{"name:":"merge_files.merge_files_part"} |
|                               Select Operator [SEL_1] (rows=3021883 width=3129) |
|                                 Output:["_col0","_col1","_col2","_col3","_col4","_col5","_col6","_col7","_col8","_col9","_col10","_col11","_col12","_col13","_col14","_col15","_col16","_col17"] |
|                                 TableScan [TS_0] (rows=3021883 width=3129) |
|                                   merge_files@merge_files_source,merge_files_source,Tbl:COMPLETE,Col:NONE,Output:["output","amount","longs","types","count","now","seq","field1","field2","field3","field4","field5","field6","field7","field8","region","country","report_date"] |
|                             SHUFFLE [RS_7]         |
|                               PartitionCols:_col0, _col1, _col2 |
|                               Group By Operator [GBY_6] (rows=3021883 width=3129) |
|                                 Output:["_col0","_col1","_col2","_col3","_col4","_col5","_col6","_col7","_col8","_col9","_col10","_col11","_col12","_col13","_col14","_col15","_col16","_col17"],aggregations:["compute_stats(output, 'hll')","compute_stats(amount, 'hll')","compute_stats(longs, 'hll')","compute_stats(types, 'hll')","compute_stats(count, 'hll')","compute_stats(now, 'hll')","compute_stats(seq, 'hll')","compute_stats(field1, 'hll')","compute_stats(field2, 'hll')","compute_stats(field3, 'hll')","compute_stats(field4, 'hll')","compute_stats(field5, 'hll')","compute_stats(field6, 'hll')","compute_stats(field7, 'hll')","compute_stats(field8, 'hll')"],keys:region, country, report_date |
|                                 Select Operator [SEL_5] (rows=3021883 width=3129) |
|                                   Output:["output","amount","longs","types","count","now","seq","field1","field2","field3","field4","field5","field6","field7","field8","region","country","report_date"] |
|                                    Please refer to the previous Select Operator [SEL_1] |
|             Stage-4(CONDITIONAL)                   |
|               File Merge                           |
|                  Please refer to the previous Stage-8(CONDITIONAL CHILD TASKS: Stage-5, Stage-4, Stage-6) |
|             Stage-7                                |
|               Move Operator                        |
|                 Stage-6(CONDITIONAL)               |
|                   File Merge                       |
|                      Please refer to the previous Stage-8(CONDITIONAL CHILD TASKS: Stage-5, Stage-4, Stage-6) |
|                                                    |
+----------------------------------------------------+
 */
-- Sorted Distribution
-- no merge
set hive.merge.tezfiles=false;
set hive.optimize.sort.dynamic.partition.threshold=0;
EXPLAIN
FROM
    merge_files_source
INSERT
INTO
    merge_files_part PARTITION (region, country, report_date)
SELECT
    report_date,
    output,
    amount,
    longs,
    types,
    count,
    now,
    seq,
    field1,
    field2,
    field3,
    field4,
    field5,
    field6,
    field7,
    field8,
    region,
    country,
    to_date(report_date) as report_date
SORT BY region,
    country,
    report_date;

/*
----------------------------------------------------------------------------------------------
        VERTICES      MODE        STATUS  TOTAL  COMPLETED  RUNNING  PENDING  FAILED  KILLED
----------------------------------------------------------------------------------------------
Map 1 .......... container     SUCCEEDED     37         37        0        0       0       0
Reducer 2 ...... container     SUCCEEDED      2          2        0        0       0       0
----------------------------------------------------------------------------------------------
VERTICES: 02/02  [==========================>>] 100%  ELAPSED TIME: 138.07 s
----------------------------------------------------------------------------------------------

1260 partitions

/warehouse/tablespace/external/hive/merge_files.db on hdfs://HOME90
➔ count -h merge_files_part/*
         225          210              9.0 M /warehouse/tablespace/external/hive/merge_files.db/merge_files_part/region=APAC
         225          210              3.5 M /warehouse/tablespace/external/hive/merge_files.db/merge_files_part/region=EU
         225          210              3.5 M /warehouse/tablespace/external/hive/merge_files.db/merge_files_part/region=MIDEAST
         225          210             87.2 M /warehouse/tablespace/external/hive/merge_files.db/merge_files_part/region=NA
         225          210              3.5 M /warehouse/tablespace/external/hive/merge_files.db/merge_files_part/region=RUSSIA
         225          210              3.5 M /warehouse/tablespace/external/hive/merge_files.db/merge_files_part/region=SA

-- NOTICE that the file sizes are smaller.  I checked and the count matches the original source.  So the sorting is allowing
    the files to be encoded better, not a simple concat.  Which I suspect is what's happening in the merge.


 +----------------------------------------------------+
|                      Explain                       |
+----------------------------------------------------+
| Plan not optimized by CBO.                         |
|                                                    |
| Vertex dependency in root stage                    |
| Reducer 2 <- Map 1 (SIMPLE_EDGE)                   |
|                                                    |
| Stage-3                                            |
|   Stats Work{}                                     |
|     Stage-0                                        |
|       Move Operator                                |
|         table:{"name:":"merge_files.merge_files_part"} |
|         Stage-2                                    |
|           Dependency Collection{}                  |
|             Stage-1                                |
|               Reducer 2 vectorized                 |
|               File Output Operator [FS_18]         |
|                 table:{"name:":"merge_files.merge_files_part"} |
|                 Select Operator [SEL_17]           |
|                   Output:["_col0","_col1","_col2","_col3","_col4","_col5","_col6","_col7","_col8","_col9","_col10","_col11","_col12","_col13","_col14","_col15","_col16","_col17"] |
|                 <-Map 1 [SIMPLE_EDGE] vectorized   |
|                   SHUFFLE [RS_16]                  |
|                     PartitionCols:_col15, _col16, _col17 |
|                     Select Operator [SEL_15] (rows=3021883 width=3146) |
|                       Output:["_col0","_col1","_col2","_col3","_col4","_col5","_col6","_col7","_col8","_col9","_col10","_col11","_col12","_col13","_col14","_col15","_col16","_col17"] |
|                       TableScan [TS_0] (rows=3021883 width=3146) |
|                         merge_files@merge_files_source,merge_files_source,Tbl:COMPLETE,Col:NONE,Output:["output","amount","longs","types","count","now","seq","field1","field2","field3","field4","field5","field6","field7","field8","region","country","report_date"] |
|                                                    |
+----------------------------------------------------+
 */

-- Sorted Distribution
-- no merge
-- data skew
 */
set hive.merge.tezfiles=false;
set hive.optimize.sort.dynamic.partition.threshold=0;
EXPLAIN
FROM
    merge_files_source
INSERT
INTO
    merge_files_part PARTITION (region, country, report_date)
SELECT
    report_date,
    output,
    amount,
    longs,
    types,
    count,
    now,
    seq,
    field1,
    field2,
    field3,
    field4,
    field5,
    field6,
    field7,
    field8,
    region,
    country,
    to_date(report_date) as report_date
WHERE
            region != "NA"
    SORT BY region
  ,         country
  ,         report_date
INSERT
INTO
    merge_files_part PARTITION (region, country, report_date)
SELECT
    report_date,
    output,
    amount,
    longs,
    types,
    count,
    now,
    seq,
    field1,
    field2,
    field3,
    field4,
    field5,
    field6,
    field7,
    field8,
    region,
    country,
    to_date(report_date) as report_date
WHERE
            region = "NA"
    SORT BY region
  ,         country
  ,         report_date;

/*
----------------------------------------------------------------------------------------------
        VERTICES      MODE        STATUS  TOTAL  COMPLETED  RUNNING  PENDING  FAILED  KILLED
----------------------------------------------------------------------------------------------
Map 1 .......... container     SUCCEEDED     37         37        0        0       0       0
Reducer 2 ...... container     SUCCEEDED      2          2        0        0       0       0
Reducer 3 ...... container     SUCCEEDED      2          2        0        0       0       0
----------------------------------------------------------------------------------------------
VERTICES: 03/03  [==========================>>] 100%  ELAPSED TIME: 122.72 s
----------------------------------------------------------------------------------------------

1260 partitions (note that it took hms 60+ secs just to organize and write the data to partitions after all tasks complete.

/warehouse/tablespace/external/hive/merge_files.db on hdfs://HOME90
➔ count -h merge_files_part/*
         225          210              9.0 M /warehouse/tablespace/external/hive/merge_files.db/merge_files_part/region=APAC
         225          210              3.5 M /warehouse/tablespace/external/hive/merge_files.db/merge_files_part/region=EU
         225          210              3.5 M /warehouse/tablespace/external/hive/merge_files.db/merge_files_part/region=MIDEAST
         225          210             87.2 M /warehouse/tablespace/external/hive/merge_files.db/merge_files_part/region=NA
         225          210              3.5 M /warehouse/tablespace/external/hive/merge_files.db/merge_files_part/region=RUSSIA
         225          210              3.5 M /warehouse/tablespace/external/hive/merge_files.db/merge_files_part/region=SA

 +----------------------------------------------------+
|                      Explain                       |
+----------------------------------------------------+
| Plan not optimized by CBO.                         |
|                                                    |
| Vertex dependency in root stage                    |
| Reducer 2 <- Map 1 (SIMPLE_EDGE)                   |
| Reducer 3 <- Map 1 (SIMPLE_EDGE)                   |
|                                                    |
| Stage-4                                            |
|   Stats Work{}                                     |
|     Stage-0                                        |
|       Move Operator                                |
|         table:{"name:":"merge_files.merge_files_part"} |
|         Stage-3                                    |
|           Dependency Collection{}                  |
|             Stage-2                                |
|               Reducer 2 vectorized                 |
|               File Output Operator [FS_40]         |
|                 table:{"name:":"merge_files.merge_files_part"} |
|                 Select Operator [SEL_39]           |
|                   Output:["_col0","_col1","_col2","_col3","_col4","_col5","_col6","_col7","_col8","_col9","_col10","_col11","_col12","_col13","_col14","_col15","_col16","_col17"] |
|                 <-Map 1 [SIMPLE_EDGE] vectorized   |
|                   SHUFFLE [RS_37]                  |
|                     PartitionCols:_col15, _col16, _col17 |
|                     Select Operator [SEL_35] (rows=3178905 width=3053) |
|                       Output:["_col0","_col1","_col2","_col3","_col4","_col5","_col6","_col7","_col8","_col9","_col10","_col11","_col12","_col13","_col14","_col15","_col16","_col17"] |
|                       Filter Operator [FIL_33] (rows=3178905 width=3053) |
|                         predicate:(region <> 'NA') |
|                         TableScan [TS_0] (rows=3178905 width=3053) |
|                           merge_files@merge_files_source,merge_files_source,Tbl:COMPLETE,Col:NONE,Output:["region","country","report_date","output","amount","longs","types","count","now","seq","field1","field2","field3","field4","field5","field6","field7","field8"] |
|               Reducer 3 vectorized                 |
|               File Output Operator [FS_42]         |
|                 table:{"name:":"merge_files.merge_files_part"} |
|                 Select Operator [SEL_41]           |
|                   Output:["_col0","_col1","_col2","_col3","_col4","_col5","_col6","_col7","_col8","_col9","_col10","_col11","_col12","_col13","_col14","_col15","_col16","_col17"] |
|                 <-Map 1 [SIMPLE_EDGE] vectorized   |
|                   SHUFFLE [RS_38]                  |
|                     PartitionCols:'NA', _col16, _col17 |
|                     Select Operator [SEL_36] (rows=5 width=3053) |
|                       Output:["_col0","_col1","_col2","_col3","_col4","_col5","_col6","_col7","_col8","_col9","_col10","_col11","_col12","_col13","_col14","_col16","_col17"] |
|                       Filter Operator [FIL_34] (rows=5 width=3053) |
|                         predicate:(region = 'NA')  |
|                          Please refer to the previous TableScan [TS_0] |
| Stage-5                                            |
|   Stats Work{}                                     |
|     Stage-1                                        |
|       Move Operator                                |
|         table:{"name:":"merge_files.merge_files_part"} |
|          Please refer to the previous Stage-3      |
|                                                    |
+----------------------------------------------------+

*/
 */

-- no merge, sort with true not threshold.
set hive.merge.tezfiles=false;
set hive.optimize.sort.dynamic.partition.threshold=-1;
set hive.optimize.sort.dynamic.partition=true;

EXPLAIN
FROM
    merge_files_source
INSERT
INTO
    merge_files_part PARTITION (region, country, report_date)
SELECT
    report_date,
    output,
    amount,
    longs,
    types,
    count,
    now,
    seq,
    field1,
    field2,
    field3,
    field4,
    field5,
    field6,
    field7,
    field8,
    region,
    country,
    to_date(report_date) as report_date
SORT BY region,
    country,
    report_date;

/*
 not great.  small files, not sorting.
 */


-- differ threshold "1" and using INSERT not FROM method.
set hive.merge.tezfiles=false;
set hive.optimize.sort.dynamic.partition.threshold=1;
set hive.optimize.sort.dynamic.partition=false;

INSERT INTO TABLE
    merge_files_part PARTITION (region, country, report_date)
SELECT
    report_date,
    output,
    amount,
    longs,
    types,
    count,
    now,
    seq,
    field1,
    field2,
    field3,
    field4,
    field5,
    field6,
    field7,
    field8,
    region,
    country,
    to_date(report_date) as report_date
FROM
    merge_files_source
SORT BY region,
    country,
    report_date;


/*
 Same results of threshold 1 (or 0) and with FROM method.  Good...
 */


-- attempt to increase reducers
set hive.merge.tezfiles=false;
set hive.optimize.sort.dynamic.partition.threshold=1260;
set hive.exec.reducers.bytes.per.reducer=20000000;
set mapreduce.job.reduce=6;
EXPLAIN
FROM
    merge_files_source
INSERT
INTO
    merge_files_part PARTITION (region, country, report_date)
SELECT
    report_date,
    output,
    amount,
    longs,
    types,
    count,
    now,
    seq,
    field1,
    field2,
    field3,
    field4,
    field5,
    field6,
    field7,
    field8,
    region,
    country,
    to_date(report_date) as report_date
WHERE
            region != "NA"
    SORT BY region
  ,         country
  ,         report_date
INSERT
INTO
    merge_files_part PARTITION (region, country, report_date)
SELECT
    report_date,
    output,
    amount,
    longs,
    types,
    count,
    now,
    seq,
    field1,
    field2,
    field3,
    field4,
    field5,
    field6,
    field7,
    field8,
    region,
    country,
    to_date(report_date) as report_date
WHERE
            region = "NA"
    SORT BY region
  ,         country
  ,         report_date
  ,         output;



set hive.merge.tezfiles=false;
set hive.optimize.sort.dynamic.partition.threshold=10;
-- Optimize Writes
set hive.exec.orc.delta.streaming.optimizations.enabled=true;
set hive.stats.autogather=false;
set tez.runtime.pipelined.sorter.lazy-allocate.memory=true;
-- these settings set reducer to 1
--set hive.vectorized.execution.enabled=false;
--set hive.tez.auto.reducer.parallelism=true;
-- This setting help increase reducer counts to speed writes up.
set mapred.reduce.tasks=200;
--set hive.tez.max.partition.factor=5.0;
set hive.exec.orc.split.strategy=HYBRID;
EXPLAIN
FROM
    merge_files_source
INSERT
INTO
    merge_files_part PARTITION (region, country, report_date)
SELECT
    report_date,
    output,
    amount,
    longs,
    types,
    count,
    now,
    seq,
    field1,
    field2,
    field3,
    field4,
    field5,
    field6,
    field7,
    field8,
    region,
    country,
    to_date(report_date) as report_date
WHERE
            region != "NA"
    SORT BY region
  ,         country
  ,         report_date
INSERT
INTO
    merge_files_part PARTITION (region, country, report_date)
SELECT
    report_date,
    output,
    amount,
    longs,
    types,
    count,
    now,
    seq,
    field1,
    field2,
    field3,
    field4,
    field5,
    field6,
    field7,
    field8,
    region,
    country,
    to_date(report_date) as report_date
WHERE
            region = "NA"
    SORT BY region
  ,         country
  ,         report_date;

set hive.tez.exec.print.summary=true;

set hive.merge.tezfiles=true;
set hive.optimize.sort.dynamic.partition.threshold=-1;
set hive.stats.autogather=false;
set hive.stats.autogather=true;
-- these settings set reducer to 1
--set hive.vectorized.execution.enabled=false;
--set hive.tez.auto.reducer.parallelism=true;
-- This setting help increase reducer counts to speed writes up.
set mapred.reduce.tasks=100;
set hive.merge.size.per.task=16777216;
set hive.merge.smallfiles.avgsize=8388608;

set hive.exec.orc.memory.pool=0.8;
set hive.exec.orc.dictionary.key.size.threshold=0.00;
set hive.orc.row.index.stride.dictionary.check=true;

--set hive.tez.max.partition.factor=5.0;
EXPLAIN
INSERT INTO TABLE
    merge_files_part PARTITION (region, country, report_date)
SELECT
    report_date,
    output,
    amount,
    longs,
    types,
    count,
    now,
    seq,
    field1,
    field2,
    field3,
    field4,
    field5,
    field6,
    field7,
    field8,
    region,
    country,
    to_date(report_date) as report_date
FROM
    merge_files_source;

--set hive.optimize.sort.dynamic.partition=true;

set hive.optimize.sort.dynamic.partition.threshold=0;
set hive.stats.autogather=false;
set mapred.reduce.tasks=1500;
EXPLAIN
INSERT INTO TABLE
    merge_files_part PARTITION (region, country, report_date)
SELECT
    report_date,
    output,
    amount,
    longs,
    types,
    count,
    now,
    seq,
    field1,
    field2,
    field3,
    field4,
    field5,
    field6,
    field7,
    field8,
    region,
    country,
    to_date(report_date) as report_date
FROM
    merge_files_source
DISTRIBUTE BY
    region,
    country,
    report_date;
    

-- multi insert with different clustering on skewed data
-- this does allow better distro in skewed area.    
EXPLAIN
FROM 
    merge_files_source
INSERT INTO 
    merge_files_part PARTITION (region, country, report_date)
SELECT
    report_date,
    output,
    amount,
    longs,
    types,
    count,
    now,
    seq,
    field1,
    field2,
    field3,
    field4,
    field5,
    field6,
    field7,
    field8,
    region,
    country,
    to_date(report_date) as report_date
    WHERE region='NA'
DISTRIBUTE BY
    region,
    country,
    report_date,
    hash(seq)
INSERT INTO 
    merge_files_part PARTITION (region, country, report_date)
SELECT
    report_date,
    output,
    amount,
    longs,
    types,
    count,
    now,
    seq,
    field1,
    field2,
    field3,
    field4,
    field5,
    field6,
    field7,
    field8,
    region,
    country,
    to_date(report_date) as report_date
    WHERE region!='NA'
DISTRIBUTE BY
    region,
    country,
    report_date;
    


FROM 
    merge_files_source
INSERT INTO 
    merge_files_part PARTITION (region, country, report_date)
SELECT
    report_date,
    output,
    amount,
    longs,
    types,
    count,
    now,
    seq,
    field1,
    field2,
    field3,
    field4,
    field5,
    field6,
    field7,
    field8,
    region,
    country,
    to_date(report_date) as report_date
    WHERE region='NA'
CLUSTER BY
    country,
    report_date,
    hash(seq)
INSERT INTO 
    merge_files_part PARTITION (region, country, report_date)
SELECT
    report_date,
    output,
    amount,
    longs,
    types,
    count,
    now,
    seq,
    field1,
    field2,
    field3,
    field4,
    field5,
    field6,
    field7,
    field8,
    region,
    country,
    to_date(report_date) as report_date
    WHERE region!='NA'
CLUSTER BY
    country,
    report_date;

-------------------------------------
-- Solution/Method Implemented.
-------------------------------------
-- Distribute beyond partition...
-- merge files to address small files
set hive.merge.tezfiles=true;
set hive.optimize.sort.dynamic.partition.threshold=-1;

-- Set this to an estimated number of partitions you'll write to
set mapred.reduce.tasks=1500;

-- For the merge, but lets keep the size to something that can
--  be written to quickly
set hive.merge.size.per.task=67108864;
set hive.merge.smallfiles.avgsize=33554432;

-- Use more memory for ORC writes
set hive.exec.orc.memory.pool=0.8;
-- Disable dictionary lookups.  Theory is that on WIDE tables, this can be pretty resource intensive
--   this will affect compression (large files)
set hive.exec.orc.dictionary.key.size.threshold=0.00;

set hive.orc.row.index.stride.dictionary.check=false;
-- ENGESC suggestion to reduce ORC GC's
set orc.rows.between.memory.checks=10;

INSERT INTO TABLE
    merge_files_part PARTITION (region, country, report_date)
SELECT
    report_date,
    output,
    amount,
    longs,
    types,
    count,
    now,
    seq,
    field1,
    field2,
    field3,
    field4,
    field5,
    field6,
    field7,
    field8,
    region,
    country,
    to_date(report_date) as reporting_date
FROM
    merge_files_source
DISTRIBUTE BY
    region
    , country
    , reporting_date
    , hour(report_date)
    ;

select explode(histogram_numeric(hash(region,country,report_date)%1009,1009)) as h from merge_files_source;

-- Legacy Testing
-- Cluster beyond partition...
-- merge files to address small files
set hive.merge.tezfiles=true;
set hive.optimize.sort.dynamic.partition=false;
set hive.stats.autogather=false;
-- Set this to an estimated number of partitions you'll write to
-- set mapred.reduce.tasks=1500;

-- For the merge, but lets keep the size to something that can
--  be written to quickly
set hive.merge.size.per.task=67108864;
set hive.merge.smallfiles.avgsize=33554432;
EXPLAIN
INSERT INTO TABLE
    merge_files_part PARTITION (region, country, report_date)
SELECT
    report_date,
    output,
    amount,
    longs,
    types,
    count,
    now,
    seq,
    field1,
    field2,
    field3,
    field4,
    field5,
    field6,
    field7,
    field8,
    region,
    country,
    to_date(report_date) as reporting_date
FROM
    merge_files_source;
