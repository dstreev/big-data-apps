CREATE DATABASE IF NOT EXISTS ${DB};

USE ${DB};

DROP TABLE IF EXISTS wide_table;

CREATE EXTERNAL TABLE IF NOT EXISTS wide_table
(
    ACTIVE_start STRING,
    ACTIVE_stop  STRING,
    output       STRING,
    amount       FLOAT,
    report_date  STRING,
    count        STRING,
    now          STRING,
    seq          BIGINT,
    field1_001   STRING,
    field1_002   STRING,
    field1_003   STRING,
    field1_004   STRING,
    field1_005   STRING,
    field1_006   STRING,
    field1_007   STRING,
    field1_008   STRING,
    field1_009   STRING,
    field1_010   STRING,
    field1_011   STRING,
    field1_012   STRING,
    field1_013   STRING,
    field1_014   STRING,
    field1_015   STRING,
    field1_016   STRING,
    field1_017   STRING,
    field1_018   STRING,
    field1_019   STRING,
    field1_020   STRING,
    field1_021   STRING,
    field1_022   STRING,
    field1_023   STRING,
    field1_024   STRING,
    field1_025   STRING,
    field1_026   STRING,
    field1_027   STRING,
    field1_028   STRING,
    field1_029   STRING,
    field1_030   STRING,
    field1_031   STRING,
    field1_032   STRING,
    field1_033   STRING,
    field1_034   STRING,
    field1_035   STRING,
    field1_036   STRING,
    field1_037   STRING,
    field1_038   STRING,
    field1_039   STRING,
    field1_040   STRING,
    field1_041   STRING,
    field1_042   STRING,
    field1_043   STRING,
    field1_044   STRING,
    field1_045   STRING,
    field1_046   STRING,
    field1_047   STRING,
    field1_048   STRING,
    field1_049   STRING,
    field1_050   STRING,
    field1_051   STRING,
    field1_052   STRING,
    field1_053   STRING,
    field1_054   STRING,
    field1_055   STRING,
    field1_056   STRING,
    field1_057   STRING,
    field1_058   STRING,
    field1_059   STRING,
    field1_060   STRING,
    field1_061   STRING,
    field1_062   STRING,
    field1_063   STRING,
    field1_064   STRING,
    field1_065   STRING,
    field1_066   STRING,
    field1_067   STRING,
    field1_068   STRING,
    field1_069   STRING,
    field1_070   STRING,
    field1_071   STRING,
    field1_072   STRING,
    field1_073   STRING,
    field1_074   STRING,
    field1_075   STRING,
    field1_076   STRING,
    field1_077   STRING,
    field1_078   STRING,
    field1_079   STRING,
    field1_080   STRING,
    field1_081   STRING,
    field1_082   STRING,
    field1_083   STRING,
    field1_084   STRING,
    field1_085   STRING,
    field1_086   STRING,
    field1_087   STRING,
    field1_088   STRING,
    field1_089   STRING,
    field1_090   STRING,
    field1_091   STRING,
    field1_092   STRING,
    field1_093   STRING,
    field1_094   STRING,
    field1_095   STRING,
    field1_096   STRING,
    field1_097   STRING,
    field1_098   STRING,
    field1_099   STRING,
    field2       STRING,
    field3_001   STRING,
    field3_002   STRING,
    field3_003   STRING,
    field3_004   STRING,
    field3_005   STRING,
    field3_006   STRING,
    field3_007   STRING,
    field3_008   STRING,
    field3_009   STRING,
    field3_010   STRING,
    field3_011   STRING,
    field3_012   STRING,
    field3_013   STRING,
    field3_014   STRING,
    field3_015   STRING,
    field3_016   STRING,
    field3_017   STRING,
    field3_018   STRING,
    field3_019   STRING,
    field3_020   STRING,
    field3_021   STRING,
    field3_022   STRING,
    field3_023   STRING,
    field3_024   STRING,
    field3_025   STRING,
    field3_026   STRING,
    field3_027   STRING,
    field3_028   STRING,
    field3_029   STRING,
    field3_030   STRING,
    field3_031   STRING,
    field3_032   STRING,
    field3_033   STRING,
    field3_034   STRING,
    field3_035   STRING,
    field3_036   STRING,
    field3_037   STRING,
    field3_038   STRING,
    field3_039   STRING,
    field3_040   STRING,
    field3_041   STRING,
    field3_042   STRING,
    field3_043   STRING,
    field3_044   STRING,
    field3_045   STRING,
    field3_046   STRING,
    field3_047   STRING,
    field3_048   STRING,
    field3_049   STRING,
    field3_050   STRING,
    field3_051   STRING,
    field3_052   STRING,
    field3_053   STRING,
    field3_054   STRING,
    field3_055   STRING,
    field3_056   STRING,
    field3_057   STRING,
    field3_058   STRING,
    field3_059   STRING,
    field3_060   STRING,
    field3_061   STRING,
    field3_062   STRING,
    field3_063   STRING,
    field3_064   STRING,
    field3_065   STRING,
    field3_066   STRING,
    field3_067   STRING,
    field3_068   STRING,
    field3_069   STRING,
    field3_070   STRING,
    field3_071   STRING,
    field3_072   STRING,
    field3_073   STRING,
    field3_074   STRING,
    field3_075   STRING,
    field3_076   STRING,
    field3_077   STRING,
    field3_078   STRING,
    field3_079   STRING,
    field3_080   STRING,
    field3_081   STRING,
    field3_082   STRING,
    field3_083   STRING,
    field3_084   STRING,
    field3_085   STRING,
    field3_086   STRING,
    field3_087   STRING,
    field3_088   STRING,
    field3_089   STRING,
    field3_090   STRING,
    field3_091   STRING,
    field3_092   STRING,
    field3_093   STRING,
    field3_094   STRING,
    field3_095   STRING,
    field3_096   STRING,
    field3_097   STRING,
    field3_098   STRING,
    field3_099   STRING,
    field4       INT,
    field5       STRING,
    field6       STRING,
    field7       STRING,
    field8       STRING
)
    ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde'
        WITH
        SERDEPROPERTIES (
            "separatorChar" = ",",
            "quoteChar" = "\"", "escapeChar" = "\\"
            )
    STORED AS TEXTFILE
    LOCATION '${HDFS_DIR}';

SELECT *
FROM
    wide_table
LIMIT 10;