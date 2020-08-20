#!/usr/bin/env bash

mkdir -p $HOME/datasets/github/covid-19

PUB_DATE=`date +%Y_%M_%d`

hdfs dfs -mkdir -p /data/covid/archives/github/IN_COUNTRIES_AGGREGATED
hdfs dfs -mkdir -p /data/covid/archives/github/IN_KEY_COUNTRIES_PIVOTED
hdfs dfs -mkdir -p /data/covid/archives/github/IN_REFERENCE
hdfs dfs -mkdir -p /data/covid/archives/github/IN_TIME_SERIES_COMBINED
hdfs dfs -mkdir -p /data/covid/archives/github/IN_US_CONFIRMED
hdfs dfs -mkdir -p /data/covid/archives/github/IN_US_DEATHS
hdfs dfs -mkdir -p /data/covid/archives/github/IN_WORLDWIDE_AGGREGATED

# Fetch the latest datasets
wget --backups=3 -P $HOME/datasets/github/covid-19/ https://github.com/datasets/covid-19/raw/master/data/countries-aggregated.csv
hdfs dfs -put -f $HOME/datasets/github/covid-19/countries-aggregated.csv /warehouse/tablespace/external/hive/covid_github.db/IN_COUNTRIES_AGGREGATED
hdfs dfs -put $HOME/datasets/github/covid-19/countries-aggregated.csv /data/covid/archives/github/IN_COUNTRIES_AGGREGATED/${PUB_DATE}_countries-aggregated.csv

wget --backups=3 -P $HOME/datasets/github/covid-19/ https://github.com/datasets/covid-19/raw/master/data/key-countries-pivoted.csv
hdfs dfs -put -f $HOME/datasets/github/covid-19/key-countries-pivoted.csv /warehouse/tablespace/external/hive/covid_github.db/IN_KEY_COUNTRIES_PIVOTED
hdfs dfs -put $HOME/datasets/github/covid-19/key-countries-pivoted.csv /data/covid/archives/github/IN_KEY_COUNTRIES_PIVOTED/${PUB_DATE}_key-countries-pivoted.csv

wget --backups=3 -P $HOME/datasets/github/covid-19/ https://github.com/datasets/covid-19/raw/master/data/reference.csv
hdfs dfs -put -f $HOME/datasets/github/covid-19/reference.csv /warehouse/tablespace/external/hive/covid_github.db/IN_REFERENCE
hdfs dfs -put $HOME/datasets/github/covid-19/reference.csv /data/covid/archives/github/IN_REFERENCE/${PUB_DATE}_reference.csv

wget --backups=3 -P $HOME/datasets/github/covid-19/ https://github.com/datasets/covid-19/raw/master/data/time-series-19-covid-combined.csv
hdfs dfs -put -f $HOME/datasets/github/covid-19/time-series-19-covid-combined.csv /warehouse/tablespace/external/hive/covid_github.db/IN_TIME_SERIES_COMBINED
hdfs dfs -put $HOME/datasets/github/covid-19/time-series-19-covid-combined.csv /data/covid/archives/github/IN_TIME_SERIES_COMBINED/${PUB_DATE}_time-series-19-covid-combined.csv

wget --backups=3 -P $HOME/datasets/github/covid-19/ https://github.com/datasets/covid-19/raw/master/data/us_confirmed.csv
hdfs dfs -put -f $HOME/datasets/github/covid-19/us_confirmed.csv /warehouse/tablespace/external/hive/covid_github.db/IN_US_CONFIRMED
hdfs dfs -put $HOME/datasets/github/covid-19/us_confirmed.csv /data/covid/archives/github/IN_US_CONFIRMED/${PUB_DATE}_us_confirmed.csv

wget --backups=3 -P $HOME/datasets/github/covid-19/ https://github.com/datasets/covid-19/raw/master/data/us_deaths.csv
hdfs dfs -put -f $HOME/datasets/github/covid-19/us_deaths.csv /warehouse/tablespace/external/hive/covid_github.db/IN_US_DEATHS
hdfs dfs -put $HOME/datasets/github/covid-19/us_deaths.csv /data/covid/archives/github/IN_US_DEATHS/${PUB_DATE}_us_deaths.csv

wget --backups=3 -P $HOME/datasets/github/covid-19/ https://github.com/datasets/covid-19/raw/master/data/worldwide-aggregated.csv
hdfs dfs -put -f $HOME/datasets/github/covid-19/worldwide-aggregated.csv /warehouse/tablespace/external/hive/covid_github.db/IN_WORLDWIDE_AGGREGATED
hdfs dfs -put $HOME/datasets/github/covid-19/worldwide-aggregated.csv /data/covid/archives/github/IN_WORLDWIDE_AGGREGATED/${PUB_DATE}_worldwide-aggregated.csv

