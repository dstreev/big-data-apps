# Stages

- setup
- fetch
- init
- load
- managed
- parts
- compact

# Table Sizes v1.
## External
REMOTE: hdfs://HOME90/warehouse/tablespace/external/hive/airline_perf.db/airline_perf_ext		LOCAL: file:/home/dstreev
hdfs-cli:$ du -h .
293.8 M  881.3 M  /warehouse/tablespace/external/hive/airline_perf.db/airline_perf_ext/year_month=2018-01
268.5 M  805.6 M  /warehouse/tablespace/external/hive/airline_perf.db/airline_perf_ext/year_month=2018-02
314.4 M  943.3 M  /warehouse/tablespace/external/hive/airline_perf.db/airline_perf_ext/year_month=2018-03
307.5 M  922.5 M  /warehouse/tablespace/external/hive/airline_perf.db/airline_perf_ext/year_month=2018-04
318.5 M  955.4 M  /warehouse/tablespace/external/hive/airline_perf.db/airline_perf_ext/year_month=2018-05
323.4 M  970.3 M  /warehouse/tablespace/external/hive/airline_perf.db/airline_perf_ext/year_month=2018-06
332.9 M  998.8 M  /warehouse/tablespace/external/hive/airline_perf.db/airline_perf_ext/year_month=2018-07
332.7 M  998.2 M  /warehouse/tablespace/external/hive/airline_perf.db/airline_perf_ext/year_month=2018-08
301.9 M  905.8 M  /warehouse/tablespace/external/hive/airline_perf.db/airline_perf_ext/year_month=2018-09
318.2 M  954.5 M  /warehouse/tablespace/external/hive/airline_perf.db/airline_perf_ext/year_month=2018-10
303.6 M  910.7 M  /warehouse/tablespace/external/hive/airline_perf.db/airline_perf_ext/year_month=2018-11
308.5 M  925.4 M  /warehouse/tablespace/external/hive/airline_perf.db/airline_perf_ext/year_month=2018-12
302.1 M  906.3 M  /warehouse/tablespace/external/hive/airline_perf.db/airline_perf_ext/year_month=2019-01
276.3 M  828.8 M  /warehouse/tablespace/external/hive/airline_perf.db/airline_perf_ext/year_month=2019-02
326.2 M  978.5 M  /warehouse/tablespace/external/hive/airline_perf.db/airline_perf_ext/year_month=2019-03
316.3 M  948.8 M  /warehouse/tablespace/external/hive/airline_perf.db/airline_perf_ext/year_month=2019-04
329.0 M  987.1 M  /warehouse/tablespace/external/hive/airline_perf.db/airline_perf_ext/year_month=2019-05
329.8 M  989.3 M  /warehouse/tablespace/external/hive/airline_perf.db/airline_perf_ext/year_month=2019-06
REMOTE: hdfs://HOME90/warehouse/tablespace/external/hive/airline_perf.db/airline_perf_ext		LOCAL: file:/home/dstreev
hdfs-cli:$ du -h ..
5.5 G  16.4 G  /warehouse/tablespace/external/hive/airline_perf.db/airline_perf_ext
## Managed
### Initial Size
hdfs-cli:$ du -h .
20.4 M  61.2 M  /warehouse/tablespace/managed/hive/airline_perf.db/airline_perf/delta_0000002_0000002_0000
18.8 M  56.3 M  /warehouse/tablespace/managed/hive/airline_perf.db/airline_perf/delta_0000003_0000003_0000
21.0 M  63.1 M  /warehouse/tablespace/managed/hive/airline_perf.db/airline_perf/delta_0000004_0000004_0000
21.6 M  64.8 M  /warehouse/tablespace/managed/hive/airline_perf.db/airline_perf/delta_0000005_0000005_0000
22.1 M  66.4 M  /warehouse/tablespace/managed/hive/airline_perf.db/airline_perf/delta_0000006_0000006_0000
23.0 M  68.9 M  /warehouse/tablespace/managed/hive/airline_perf.db/airline_perf/delta_0000007_0000007_0000
23.3 M  70.0 M  /warehouse/tablespace/managed/hive/airline_perf.db/airline_perf/delta_0000008_0000008_0000
23.7 M  71.1 M  /warehouse/tablespace/managed/hive/airline_perf.db/airline_perf/delta_0000009_0000009_0000
20.9 M  62.8 M  /warehouse/tablespace/managed/hive/airline_perf.db/airline_perf/delta_0000010_0000010_0000
22.2 M  66.5 M  /warehouse/tablespace/managed/hive/airline_perf.db/airline_perf/delta_0000011_0000011_0000
21.6 M  64.9 M  /warehouse/tablespace/managed/hive/airline_perf.db/airline_perf/delta_0000012_0000012_0000
21.6 M  64.9 M  /warehouse/tablespace/managed/hive/airline_perf.db/airline_perf/delta_0000013_0000013_0000
21.3 M  63.8 M  /warehouse/tablespace/managed/hive/airline_perf.db/airline_perf/delta_0000014_0000014_0000
19.9 M  59.7 M  /warehouse/tablespace/managed/hive/airline_perf.db/airline_perf/delta_0000015_0000015_0000
22.7 M  68.0 M  /warehouse/tablespace/managed/hive/airline_perf.db/airline_perf/delta_0000016_0000016_0000
22.2 M  66.5 M  /warehouse/tablespace/managed/hive/airline_perf.db/airline_perf/delta_0000017_0000017_0000
23.5 M  70.5 M  /warehouse/tablespace/managed/hive/airline_perf.db/airline_perf/delta_0000018_0000018_0000
24.2 M  72.7 M  /warehouse/tablespace/managed/hive/airline_perf.db/airline_perf/delta_0000019_0000019_0000
REMOTE: hdfs://HOME90/warehouse/tablespace/managed/hive/airline_perf.db/airline_perf		LOCAL: file:/home/dstreev
hdfs-cli:$ du -h ..
394.0 M  1.2 G  /warehouse/tablespace/managed/hive/airline_perf.db/airline_perf

### Post Compaction
hdfs-cli:$ du -h .
0        0        /warehouse/tablespace/managed/hive/airline_perf.db/airline_perf/.hive-staging_hive_2019-09-15_07-54-33_714_4310444708381833897-1
290.1 M  870.3 M  /warehouse/tablespace/managed/hive/airline_perf.db/airline_perf/base_0000019
REMOTE: hdfs://HOME90/warehouse/tablespace/managed/hive/airline_perf.db/airline_perf		LOCAL: file:/home/dstreev