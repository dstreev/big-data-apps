#!/usr/bin/env bash

cd `dirname $0`
CURR_DIR=`pwd`

INPUT=$1
PROCESSING_CYCLE=${INPUT:=`date +%Y-%m-%d`}
ARCHIVE_PARTITION=`date +%Y-%m`
HDFS_BASE_DIR=/data/covid/ga
DATABASE=covid_ga

mkdir -p $HOME/datasets/covid/ga

hdfs dfs -mkdir -p $HDFS_BASE_DIR/COUNTY_CASES
hdfs dfs -mkdir -p $HDFS_BASE_DIR/DEATHS
hdfs dfs -mkdir -p $HDFS_BASE_DIR/DEMOGRAPHICS
hdfs dfs -mkdir -p $HDFS_BASE_DIR/landing_zone

wget --backups=3 -P $HOME/datasets/covid/ga https://ga-covid19.ondemand.sas.com/docs/ga_covid_data.zip

pushd $HOME/datasets/covid/ga
unzip -o ga_covid_data.zip

#hdfs dfs -put -f countycases.csv /warehouse/tablespace/external/hive/covid_ga.db/COUNTY_CASES
hdfs dfs -put -f countycases.csv $HDFS_BASE_DIR/COUNTY_CASES/${PROCESSING_CYCLE}_countycases.csv
hdfs dfs -put -f countycases.csv $HDFS_BASE_DIR/landing_zone

#hdfs dfs -put -f deaths.csv /warehouse/tablespace/external/hive/covid_ga.db/DEATHS
hdfs dfs -put -f deaths.csv $HDFS_BASE_DIR/DEATHS/${PROCESSING_CYCLE}_deaths.csv
hdfs dfs -put -f deaths.csv $HDFS_BASE_DIR/landing_zone

#hdfs dfs -put -f demographics.csv /warehouse/tablespace/external/hive/covid_ga.db/DEMOGRAPHICS
hdfs dfs -put -f demographics.csv $HDFS_BASE_DIR/DEMOGRAPHICS/${PROCESSING_CYCLE}_demographics.csv
hdfs dfs -put -f demographics.csv $HDFS_BASE_DIR/landing_zone

popd

hive --hivevar DATABASE=${DATABASE} --hivevar PROCESSING_CYCLE=${PROCESSING_CYCLE} --hivevar HDFS_BASE_DIR=${HDFS_BASE_DIR} --hivevar ARCHIVE_PARTITION=${ARCHIVE_PARTITION} -f ../dml/ga_load.sql
