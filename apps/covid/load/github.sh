#!/usr/bin/env bash

cd `dirname $0`
CURR_DIR=`pwd`

INPUT=$1
IN_RANGE=$2
IN_DB=$3

PROCESSING_CYCLE=${INPUT:=`date +%Y-%m-%d`}
RANGE=${IN_RANGE:=1}

ARCHIVE_PARTITION=`date +%Y-%m`
HDFS_BASE_DIR=/data/covid/github
DATABASE=${IN_DB:=covid_github}

mkdir -p $HOME/datasets/covid/github
hdfs dfs -mkdir -p ${HDFS_BASE_DIR}/landing_zone

# Fetch the latest datasets
for source in countries-aggregated key-countries-pivoted reference time-series-19-covid-combined us_confirmed us_deaths worldwide-aggregated; do
  wget --backups=3 -P $HOME/datasets/covid/github/ https://github.com/datasets/covid-19/raw/master/data/${source}.csv
done

#wget --backups=3 -P $HOME/datasets/covid/github/ https://github.com/datasets/covid-19/raw/master/data/countries-aggregated.csv
#wget --backups=3 -P $HOME/datasets/covid/github/ https://github.com/datasets/covid-19/raw/master/data/key-countries-pivoted.csv
#wget --backups=3 -P $HOME/datasets/covid/github/ https://github.com/datasets/covid-19/raw/master/data/reference.csv
#wget --backups=3 -P $HOME/datasets/covid/github/ https://github.com/datasets/covid-19/raw/master/data/time-series-19-covid-combined.csv
#wget --backups=3 -P $HOME/datasets/covid/github/ https://github.com/datasets/covid-19/raw/master/data/us_confirmed.csv
#wget --backups=3 -P $HOME/datasets/covid/github/ https://github.com/datasets/covid-19/raw/master/data/us_deaths.csv
#wget --backups=3 -P $HOME/datasets/covid/github/ https://github.com/datasets/covid-19/raw/master/data/worldwide-aggregated.csv
for (( LOAD=1; LOAD<=$RANGE; LOAD++ ))
do
  for GRP in "countries-aggregated,COUNTRIES_AGGREGATED" "key-countries-pivoted,KEY_COUNTRIES_PIVOTED" "reference,REFERENCE" "time-series-19-covid-combined,TIME_SERIES_COMBINED" "us_confirmed,US_CONFIRMED" "us_deaths,US_DEATHS" "worldwide-aggregated,WORLDWIDE_AGGREGATED"
  do
    IFS=','
    read -ra grparr <<< "${GRP}"

    hdfs dfs -mkdir -p ${HDFS_BASE_DIR}/${grparr[1]}
    hdfs dfs -put -f $HOME/datasets/covid/github/${grparr[0]}.csv ${HDFS_BASE_DIR}/landing_zone/
    hdfs dfs -put -f $HOME/datasets/covid/github/${grparr[0]}.csv ${HDFS_BASE_DIR}/${grparr[1]}/${PROCESSING_CYCLE}_${LOAD}_${grparr[0]}.csv

    hive --hivevar DATABASE=${DATABASE} --hivevar PROCESSING_CYCLE=${PROCESSING_CYCLE} \
      --hivevar HDFS_BASE_DIR=${HDFS_BASE_DIR} --hivevar ARCHIVE_PARTITION=${ARCHIVE_PARTITION} \
      --hivevar TABLE_BASE=${grparr[1]} --hivevar TABLE_SOURCE=${grparr[0]} -f ../dml/github_load.sql
  done
done


#  hdfs dfs -put -f $HOME/datasets/covid/github/countries-aggregated.csv ${HDFS_BASE_DIR}/landing_zone
#  hdfs dfs -put $HOME/datasets/covid/github/countries-aggregated.csv ${HDFS_BASE_DIR}/IN_COUNTRIES_AGGREGATED/${PROCESSING_CYCLE}_${LOAD}_countries-aggregated.csv
#  hdfs dfs -put -f $HOME/datasets/covid/github/key-countries-pivoted.csv ${HDFS_BASE_DIR}/landing_zone
#  hdfs dfs -put $HOME/datasets/covid/github/key-countries-pivoted.csv ${HDFS_BASE_DIR}/IN_KEY_COUNTRIES_PIVOTED/${PROCESSING_CYCLE}_${LOAD}_key-countries-pivoted.csv
#  hdfs dfs -put -f $HOME/datasets/covid/github/reference.csv ${HDFS_BASE_DIR}/landing_zone
#  hdfs dfs -put $HOME/datasets/covid/github/reference.csv ${HDFS_BASE_DIR}/IN_REFERENCE/${PROCESSING_CYCLE}_${LOAD}_reference.csv
#  hdfs dfs -put -f $HOME/datasets/covid/github/time-series-19-covid-combined.csv ${HDFS_BASE_DIR}/landing_zone
#  hdfs dfs -put $HOME/datasets/covid/github/time-series-19-covid-combined.csv ${HDFS_BASE_DIR}/IN_TIME_SERIES_COMBINED/${PROCESSING_CYCLE}_${LOAD}_time-series-19-covid-combined.csv
#  hdfs dfs -put -f $HOME/datasets/covid/github/us_confirmed.csv ${HDFS_BASE_DIR}/landing_zone
#  hdfs dfs -put $HOME/datasets/covid/github/us_confirmed.csv ${HDFS_BASE_DIR}/IN_US_CONFIRMED/${PROCESSING_CYCLE}_${LOAD}_us_confirmed.csv
#  hdfs dfs -put -f $HOME/datasets/covid/github/us_deaths.csv ${HDFS_BASE_DIR}/landing_zone
#  hdfs dfs -put $HOME/datasets/covid/github/us_deaths.csv ${HDFS_BASE_DIR}/IN_US_DEATHS/${PROCESSING_CYCLE}_${LOAD}_us_deaths.csv
#  hdfs dfs -put -f $HOME/datasets/covid/github/worldwide-aggregated.csv ${HDFS_BASE_DIR}/landing_zone
#  hdfs dfs -put $HOME/datasets/covid/github/worldwide-aggregated.csv ${HDFS_BASE_DIR}/IN_WORLDWIDE_AGGREGATED/${PROCESSING_CYCLE}_${LOAD}_worldwide-aggregated.csv
