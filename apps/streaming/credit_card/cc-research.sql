use ${database};

MSCK REPAIR TABLE CC_TRANS_BRIDGE;

SHOW PARTITIONS CC_TRANS_BRIDGE;
DESCRIBE CC_TRANS_BRIDGE;
DESCRIBE CC_TRANS_BRIDGE PARTITION (processing_cycle='11-23');

SHOW TABLES;
SHOW COMPACTIONS;

alter table CC_TRANS DROP PARTITION (processing_cycle='2018-11-21');

show create table cc_trans_bridge;

select processing_cycle, count(cc_trans) from CC_TRANS group by processing_cycle;

select * from cc_trans_from_incremental_append limit 100;

show partitions cc_trans_bridge;
ALTER TABLE CC_TRANS_BRIDGE ADD IF NOT EXISTS PARTITION (processing_cycle="12-35");
select amnt, cast(trans_ts as Timestamp) from cc_trans_bridge limit 10;