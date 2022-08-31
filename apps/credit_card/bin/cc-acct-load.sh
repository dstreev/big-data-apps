#!/usr/bin/env bash

## Expects datagen in the path.

COUNT=$1
DATABASE=$2

CURR_DIR=`pwd`

cd `dirname $0`
PROC_CYCLE=`date +%y%m%d_%I%M`
ACCT_FILE=acct-${PROC_CYCLE}

echo "Generating Account Data ($1 records)"
datagencli -cfg ../generator/cc-acct.yaml -o $HOME/datasets/credit_card/acct/${ACCT_FILE} --count $COUNT

echo "Posting Account Data to HDFS in ${PROC_CYCLE} directory"
hdfs dfs -mkdir -p /warehouse/tablespace/external/hive/${DATABASE}.db/cc_acct_delta/YEAR_MONTH=${PROC_CYCLE}

# Discover the new partition.
## Be aware of the limits/performance characteristics of A LOT of partitions here.
## When a LARGE number of partitions will exists, it will be better to ADD the partition manually with SQL.
## See the 'hive.msck.repair.batch.size' property for additional control.
## https://cwiki.apache.org/confluence/display/Hive/LanguageManual+DDL#LanguageManualDDL-PartitionRetention

## Partition Discovery is also an option, but will not show up immediately.  Will only show up in next discovery cycle.
## https://cwiki.apache.org/confluence/display/Hive/LanguageManual+DDL#LanguageManualDDL-DiscoverPartitions

hive -e "MSCK REPAIR TABLE ${DATABASE}.cc_acct_delta SYNC PARTITIONS"

hive --hivevar LAST_PROCESSING_CYCLE=${PROC_CYCLE} -f ../cdc/cc-acct-merge.sql
