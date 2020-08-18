USE CUSTOM_SYS;

-- See the last 10 compaction events
SELECT
    `DATABASE`,
    `TABLE`,
    `PARTITION`,
    `STATE`,
    `TYPE`,
    `START`,
    `END`,
    HADOOP_JOB_ID
FROM
    `CUSTOM_SYS`.`COMPACTIONS`
ORDER BY
    `START` DESC
LIMIT 10;

-- Show the last 10 failed compaction event
-- `state` options are 'SUCCEEDED', 'ATTEMPTED', 'FAILED', 'INITIATED', 'WORKING', and 'READY_FOR_CLEANING'
-- `type` options are 'MAJOR' and 'MINOR'
SELECT
    `DATABASE`,
    `TABLE`,
    `PARTITION`,
    `STATE`,
    `TYPE`,
    `START`,
    `END`
FROM
    `CUSTOM_SYS`.`COMPACTIONS`
WHERE
    `STATE` = 'FAILED'
ORDER BY
    `START` DESC
LIMIT 10;
