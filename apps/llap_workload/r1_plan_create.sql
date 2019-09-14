
CREATE RESOURCE PLAN finance;
CREATE RESOURCE PLAN logistics;

-- Purposefully created with wrong ALLOC_FRACTION ratio.
CREATE POOL finance.etl_pool WITH ALLOC_FRACTION = 25, QUERY_PARALLELISM = 2;
CREATE POOL finance.bi_pool WITH ALLOC_FRACTION = 75, QUERY_PARALLELISM = 5;

CREATE APPLICATION MAPPING 'beeline_etl' IN finance TO etl_pool WITH ORDER 0;
DROP APPLICATION MAPPING 'beeline_etl' IN finance;
CREATE APPLICATION MAPPING 'beeline_etl' IN finance TO etl_pool WITH ORDER 0;

CREATE APPLICATION MAPPING 'beeline_bi' IN finance TO bi_pool WITH ORDER 1;
CREATE USER MAPPING 'dstreev' IN finance TO bi_pool WITH ORDER 2;
DROP USER MAPPING 'dstreev' IN finance;
CREATE USER MAPPING 'dstreev' IN finance TO bi_pool WITH ORDER 2;

CREATE TRIGGER finance.excessive_time
    WHEN EXECUTOR_CPU_NS > 3000000000
    DO MOVE TO etl_pool;

DROP TRIGGER finance.excessive_time;

CREATE TRIGGER finance.excessive_time
    WHEN EXECUTOR_CPU_NS > 3000000000
    DO MOVE TO etl_pool;

ALTER TRIGGER finance.excessive_time ADD TO POOL bi_pool;
ALTER TRIGGER finance.excessive_time ADD TO POOL default;

ALTER RESOURCE PLAN finance VALIDATE;

ALTER POOL finance.etl_pool SET ALLOC_FRACTION = 0.25;
ALTER POOL finance.bi_pool SET ALLOC_FRACTION = 0.65;
ALTER POOL finance.default SET ALLOC_FRACTION = 0.10, QUERY_PARALLELISM = 2;

ALTER RESOURCE PLAN finance VALIDATE;


ALTER RESOURCE PLAN finance ENABLE;
ALTER RESOURCE PLAN finance ACTIVATE;

