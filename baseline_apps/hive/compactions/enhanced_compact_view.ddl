CREATE DATABASE IF NOT EXISTS CUSTOM_SYS;

DROP TABLE IF EXISTS `CUSTOM_SYS`.`COMPLETED_COMPACTIONS`;
DROP TABLE IF EXISTS `CUSTOM_SYS`.`COMPACTION_QUEUE`;

CREATE EXTERNAL TABLE `CUSTOM_SYS`.`COMPLETED_COMPACTIONS`
(
    CC_ID               BIGINT COMMENT 'from deserializer',
    CC_DATABASE         STRING COMMENT 'from deserializer',
    CC_TABLE            STRING COMMENT 'from deserializer',
    CC_PARTITION        STRING COMMENT 'from deserializer',
    CC_STATE            STRING COMMENT 'from deserializer',
    CC_TYPE             STRING COMMENT 'from deserializer',
    CC_TBLPROPERTIES    STRING COMMENT 'from deserializer',
    CC_WORKER_ID        STRING COMMENT 'from deserializer',
    CC_START            BIGINT COMMENT 'from deserializer',
    CC_END              BIGINT COMMENT 'from deserializer',
    CC_RUN_AS           STRING COMMENT 'from deserializer',
    CC_HIGHEST_WRITE_ID BIGINT COMMENT 'from deserializer',
    CC_META_INFO        STRING COMMENT 'from deserializer',
    CC_HADOOP_JOB_ID    STRING COMMENT 'from deserializer'
)
    ROW FORMAT SERDE
        'org.apache.hive.storage.jdbc.JdbcSerDe'
    STORED BY
        'org.apache.hive.storage.jdbc.JdbcStorageHandler'
        WITH SERDEPROPERTIES (
        'serialization.format' = '1')
    TBLPROPERTIES (
        'bucketing_version' = '2',
        'hive.sql.database.type' = 'METASTORE',
        'hive.sql.query' =
                'SELECT CC_ID, CC_DATABASE, CC_TABLE, CC_PARTITION, CC_STATE, CC_TYPE, CC_TBLPROPERTIES, CC_WORKER_ID, CC_START, CC_END, CC_RUN_AS, CC_HIGHEST_WRITE_ID, CC_META_INFO, CC_HADOOP_JOB_ID FROM COMPLETED_COMPACTIONS');

CREATE EXTERNAL TABLE `CUSTOM_SYS`.`COMPACTION_QUEUE`
(
    CQ_ID               BIGINT COMMENT 'from deserializer',
    CQ_DATABASE         STRING COMMENT 'from deserializer',
    CQ_TABLE            STRING COMMENT 'from deserializer',
    CQ_PARTITION        STRING COMMENT 'from deserializer',
    CQ_STATE            STRING COMMENT 'from deserializer',
    CQ_TYPE             STRING COMMENT 'from deserializer',
    CQ_TBLPROPERTIES    STRING COMMENT 'from deserializer',
    CQ_WORKER_ID        STRING COMMENT 'from deserializer',
    CQ_START            BIGINT COMMENT 'from deserializer',
    CQ_RUN_AS           STRING COMMENT 'from deserializer',
    CQ_HIGHEST_WRITE_ID BIGINT COMMENT 'from deserializer',
    CQ_META_INFO        STRING COMMENT 'from deserializer',
    CQ_HADOOP_JOB_ID    STRING COMMENT 'from deserializer'
)
    ROW FORMAT SERDE
        'org.apache.hive.storage.jdbc.JdbcSerDe'
    STORED BY
        'org.apache.hive.storage.jdbc.JdbcStorageHandler'
        WITH SERDEPROPERTIES (
        'serialization.format' = '1')
    TBLPROPERTIES (
        'bucketing_version' = '2',
        'hive.sql.database.type' = 'METASTORE',
        'hive.sql.query' =
                'SELECT CQ_ID, CQ_DATABASE, CQ_TABLE, CQ_PARTITION, CQ_STATE, CQ_TYPE, CQ_TBLPROPERTIES, CQ_WORKER_ID, CQ_START, CQ_RUN_AS, CQ_HIGHEST_WRITE_ID, CQ_META_INFO, CQ_HADOOP_JOB_ID FROM COMPACTION_QUEUE');

DROP VIEW IF EXISTS `CUSTOM_SYS`.`COMPACTIONS`;

-- TODO: Handle / Show Aborted Transactions (maybe) I think txn data may be transient...
CREATE VIEW IF NOT EXISTS `CUSTOM_SYS`.`COMPACTIONS` AS
SELECT
    CC_ID                             AS ID,
    CC_DATABASE                       AS `DATABASE`,
    CC_TABLE                          AS `TABLE`,
    CC_PARTITION                      AS `PARTITION`,
    CASE CC_STATE
        WHEN 's' THEN 'SUCCEEDED'
        WHEN 'a' THEN 'ATTEMPTED'
        WHEN 'f' THEN 'FAILED'
        END                           AS STATE,
    CASE CC_TYPE
        WHEN 'a' THEN 'MAJOR'
        WHEN 'i' THEN 'MINOR'
        END                           AS TYPE,
    CC_TBLPROPERTIES                  AS TBLPROPERTIES,
    CC_WORKER_ID                      AS WORKER_ID,
    to_utc_timestamp(CC_START, 'UTC') AS `START`,
    to_utc_timestamp(CC_END, 'UTC')   AS `END`,
    CC_RUN_AS                         AS RUN_AS,
    CC_HIGHEST_WRITE_ID               AS HIGHEST_WRITE_ID,
    CC_META_INFO                      AS META_INFO,
    CC_HADOOP_JOB_ID                  AS HADOOP_JOB_ID
FROM
    `CUSTOM_SYS`.`COMPLETED_COMPACTIONS`
UNION ALL
SELECT
    CQ_ID                             AS ID,
    CQ_DATABASE                       AS `DATABASE`,
    CQ_TABLE                          AS `TABLE`,
    CQ_PARTITION                      AS `PARTITION`,
    CASE CQ_STATE
        WHEN 'i' THEN 'INITIATED'
        WHEN 'w' THEN 'WORKING'
        WHEN 'r' THEN 'READY_FOR_CLEANING'
        END                           AS `STATE`,
    CASE CQ_TYPE
        WHEN 'a' THEN 'MAJOR'
        WHEN 'i' THEN 'MINOR'
        END                           AS `TYPE`,
    CQ_TBLPROPERTIES                  AS TBLPROPERTIES,
    CQ_WORKER_ID                      AS WORKER_ID,
    to_utc_timestamp(CQ_START, 'UTC') AS `START`,
    NULL                              AS `END`,
    CQ_RUN_AS                         AS RUN_AS,
    CQ_HIGHEST_WRITE_ID               AS HIGHEST_WRITE_ID,
    CQ_META_INFO                      AS META_INFO,
    CQ_HADOOP_JOB_ID                  AS HADOOP_JOB_ID
FROM
    `CUSTOM_SYS`.`COMPACTION_QUEUE`;
