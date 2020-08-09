#!/usr/bin/env bash

mkdir -p $HOME/datasets/github/covid-19

# Fetch the latest datasets
wget --backups=3 -P $HOME/datasets/github/covid-19/ https://github.com/datasets/covid-19/raw/master/data/countries-aggregated.csv
hdfs dfs -put -f $HOME/datasets/github/covid-19/countries-aggregated.csv /warehouse/tablespace/external/hive/covid_github.db/IN_COUNTRIES_AGGREGATED
wget --backups=3 -P $HOME/datasets/github/covid-19/ https://github.com/datasets/covid-19/raw/master/data/key-countries-pivoted.csv
hdfs dfs -put -f $HOME/datasets/github/covid-19/key-countries-pivoted.csv /warehouse/tablespace/external/hive/covid_github.db/IN_KEY_COUNTRIES_PIVOTED
wget --backups=3 -P $HOME/datasets/github/covid-19/ https://github.com/datasets/covid-19/raw/master/data/reference.csv
hdfs dfs -put -f $HOME/datasets/github/covid-19/reference.csv /warehouse/tablespace/external/hive/covid_github.db/IN_REFERENCE
wget --backups=3 -P $HOME/datasets/github/covid-19/ https://github.com/datasets/covid-19/raw/master/data/time-series-19-covid-combined.csv
hdfs dfs -put -f $HOME/datasets/github/covid-19/time-series-19-covid-combined.csv /warehouse/tablespace/external/hive/covid_github.db/IN_TIME_SERIES_COMBINED
wget --backups=3 -P $HOME/datasets/github/covid-19/ https://github.com/datasets/covid-19/raw/master/data/us_confirmed.csv
hdfs dfs -put -f $HOME/datasets/github/covid-19/us_confirmed.csv /warehouse/tablespace/external/hive/covid_github.db/IN_US_CONFIRMED
wget --backups=3 -P $HOME/datasets/github/covid-19/ https://github.com/datasets/covid-19/raw/master/data/us_deaths.csv
hdfs dfs -put -f $HOME/datasets/github/covid-19/us_deaths.csv /warehouse/tablespace/external/hive/covid_github.db/IN_US_DEATHS
wget --backups=3 -P $HOME/datasets/github/covid-19/ https://github.com/datasets/covid-19/raw/master/data/worldwide-aggregated.csv
hdfs dfs -put -f $HOME/datasets/github/covid-19/worldwide-aggregated.csv /warehouse/tablespace/external/hive/covid_github.db/IN_WORLDWIDE_AGGREGATED

