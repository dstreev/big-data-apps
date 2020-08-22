USE ${DATABASE};

LOAD DATA INPATH '${HDFS_BASE_DIR}/landing_zone/${TABLE_SOURCE}.csv' OVERWRITE INTO TABLE ${TABLE_BASE}_SWEEP;

INSERT INTO TABLE ${TABLE_BASE}_ARCHIVE
SELECT
    T.*,
    '${PROCESSING_CYCLE}',
    '${ARCHIVE_PARTITION}'
FROM
${TABLE_BASE}_SWEEP T;

INSERT OVERWRITE TABLE ${TABLE_BASE}
SELECT
    T.*
FROM
    ${TABLE_BASE}_SWEEP T;