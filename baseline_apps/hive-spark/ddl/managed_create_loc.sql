DROP TABLE IF EXISTS ${TEST_TABLE};
CREATE TABLE IF NOT EXISTS ${TEST_TABLE} (
                                             id String,
                                             value1 String,
                                             dvalue1 Date
)
LOCATION '/warehouse/tablespace/managed/hive/bad_location';

SHOW CREATE DATABASE ${DB};
SHOW CREATE TABLE ${TEST_TABLE};