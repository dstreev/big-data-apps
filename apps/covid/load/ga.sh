#!/usr/bin/env bash

cd `dirname $0`
CURR_DIR=`pwd`

INPUT=$1

IN_CYCLE=$1
IN_ARCH_PART=$2
IN_RANGE=$3
IN_DB=$4

PROCESSING_CYCLE=${IN_CYCLE:=`date +%Y-%m-%d`}
ARCHIVE_PARTITION=${IN_ARCH_PART:=`date +%Y-%m`}
RANGE=${IN_RANGE:=1}
DATABASE=${IN_DB:=covid_ga}

HDFS_BASE_DIR=/data/covid/ga

mkdir -p $HOME/datasets/covid/ga
hdfs dfs -mkdir -p $HDFS_BASE_DIR/landing_zone

for target_dir in COUNTY_CASES DEATHS DEMOGRAPHICS
do
  hdfs dfs -mkdir -p $HDFS_BASE_DIR/$target_dir
done
#hdfs dfs -mkdir -p $HDFS_BASE_DIR/COUNTY_CASES
#hdfs dfs -mkdir -p $HDFS_BASE_DIR/DEATHS
#hdfs dfs -mkdir -p $HDFS_BASE_DIR/DEMOGRAPHICS

wget --backups=3 -P $HOME/datasets/covid/ga https://ga-covid19.ondemand.sas.com/docs/ga_covid_data.zip

pushd $HOME/datasets/covid/ga
unzip -o ga_covid_data.zip
popd

for (( LOAD=1; LOAD<=$RANGE; LOAD++ ))
do
  for GRP in "countycases,COUNTY_CASES" "deaths,DEATHS" "demographics,DEMOGRAPHICS"
  do
    IFS=','
    read -ra grparr <<< "${GRP}"

    hdfs dfs -put -f $HOME/datasets/covid/ga/${grparr[0]}.csv $HDFS_BASE_DIR/landing_zone
    hdfs dfs -put -f $HOME/datasets/covid/ga/${grparr[0]}.csv $HDFS_BASE_DIR/${grparr[1]}/${PROCESSING_CYCLE}_${LOAD}_${grparr[0]}.csv

    hive --hivevar DATABASE=${DATABASE} --hivevar PROCESSING_CYCLE=${PROCESSING_CYCLE}_${LOAD} \
      --hivevar HDFS_BASE_DIR=${HDFS_BASE_DIR} --hivevar ARCHIVE_PARTITION=${ARCHIVE_PARTITION} \
      --hivevar TABLE_BASE=${grparr[1]} --hivevar TABLE_SOURCE=${grparr[0]} -f ../dml/ga_load.sql

  done
done
