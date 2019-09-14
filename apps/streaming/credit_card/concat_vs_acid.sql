use priv_dstreev;

show tables;

drop table cc_trans_all;
create external table cc_trans_all (
    cc_trans string,
    ccn string,
    trans_ts string,
    mcc string,
    mrch_id string,
    st string,
    amount string)
ROW FORMAT DELIMITED
  FIELDS TERMINATED BY ','
STORED AS TEXTFILE
LOCATION '/user/dstreev/datasets/external/cc_trans_all';

select * from cc_trans_all limit 10;

-- Fails
ALTER TABLE cc_trans_all CONCATENATE;

-- Success.  Creates less files, still not ideal.
INSERT OVERWRITE TABLE cc_trans_all
SELECT * from cc_trans_all;


drop table cc_trans_part;
create external table cc_trans_part (
    cc_trans string,
    ccn string,
    trans_ts string,
    mcc string,
    mrch_id string,
    st string,
    amount string)
PARTITIONED BY (section string)    
ROW FORMAT DELIMITED
  FIELDS TERMINATED BY ','
STORED AS TEXTFILE
LOCATION '/user/dstreev/datasets/external/cc_trans_part';

describe cc_trans_part;

-- Discover partitions
MSCK REPAIR TABLE priv_dstreev.cc_trans_part ADD PARTITIONS;

ALTER TABLE priv_dstreev.cc_trans_part RECOVER PARTITIONS;

select * from cc_trans_part limit 10;
use priv_dstreev;
show tables;
create table cc_trans (
    cc_trans string,
    ccn string,
    trans_ts string,
    mcc string,
    mrch_id string,
    st string,
    amount string)
STORED AS ORC;

show create table cc_trans;

insert into table cc_trans
select cc_trans string,
    ccn,
    trans_ts,
    mcc,
    mrch_id,
    st,
    amount from cc_trans_part where section = 19;
    
SHOW COMPACTIONS;
    
ALTER TABLE cc_trans COMPACT 'major';

