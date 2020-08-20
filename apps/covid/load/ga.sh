#!/usr/bin/env bash

PUB_DATE=`date +%Y-%m-%d`

mkdir -p $HOME/datasets/covid/ga

hdfs dfs -mkdir -p /data/covid/archives/ga/COUNTY_CASES
hdfs dfs -mkdir -p /data/covid/archives/ga/DEATHS
hdfs dfs -mkdir -p /data/covid/archives/ga/DEMOGRAPHICS

wget --backups=3 -P $HOME/datasets/covid/ga https://ga-covid19.ondemand.sas.com/docs/ga_covid_data.zip

cd $HOME/datasets/covid/ga
unzip -o ga_covid_data.zip

hdfs dfs -put -f countycases.csv /warehouse/tablespace/external/hive/covid_ga.db/COUNTY_CASES
hdfs dfs -put -f countycases.csv /data/covid/archives/ga/COUNTY_CASES/${PUB_DATE}_countycases.csv

hdfs dfs -put -f deaths.csv /warehouse/tablespace/external/hive/covid_ga.db/DEATHS
hdfs dfs -put -f deaths.csv /data/covid/archives/ga/DEATHS/${PUB_DATE}_deaths.csv

hdfs dfs -put -f demographics.csv /warehouse/tablespace/external/hive/covid_ga.db/DEMOGRAPHICS
hdfs dfs -put -f demographics.csv /data/covid/archives/ga/DEMOGRAPHICS/${PUB_DATE}_demographics.csv

