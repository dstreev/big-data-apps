DROP TABLE IF EXISTS ${TEST_TABLE};
CREATE EXTERNAL TABLE IF NOT EXISTS ${TEST_TABLE} (
                                             id String,
                                             value1 String,
                                             dvalue1 Date
)
LOCATION '/warehouse/tablespace/external/hive/priv_${USER}.db/${TEST_TABLE}';

SHOW CREATE DATABASE ${DB};
SHOW CREATE TABLE ${TEST_TABLE};