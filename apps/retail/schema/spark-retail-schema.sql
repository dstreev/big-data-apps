CREATE DATABASE IF NOT EXISTS ${TARGET_DB};

USE ${TARGET_DB};

DROP TABLE IF EXISTS CUSTOMER;
CREATE TABLE IF NOT EXISTS CUSTOMER
(
    ID          STRING,
    FULL_NAME   STRING,
    ADDRESS     STRING,
    STATE       STRING,
    CONTACT_NUM STRING
) USING ORC;

DROP TABLE IF EXISTS VISIT;
CREATE TABLE IF NOT EXISTS VISIT
(
    ID          STRING,
    CUSTOMER_ID STRING,
    VISIT_TS    TIMESTAMP,
    STAY_TIME   BIGINT,
    VISIT_DATE  DATE
) USING ORC PARTITIONED BY (VISIT_DATE);

DROP TABLE IF EXISTS PURCHASE;
CREATE TABLE IF NOT EXISTS PURCHASE
(
    ID             STRING,
    CUSTOMER_ID    STRING,
    VISIT_ID       STRING,
    SALES_REP      STRING,
    REGISTER       STRING,
    TRANSACTION_ID STRING,
    DISCOUNT       DOUBLE,
    DISCOUNT_CODE  STRING,
    TOTAL_PURCHASE DOUBLE,
    TENDER_TYPE    STRING,
    PURCHASE_TS    TIMESTAMP,
    PURCHASE_DATE  DATE
) USING ORC PARTITIONED BY (PURCHASE_DATE);

/*
CREATE TABLE IF NOT EXISTS LINE_ITEM
(
    ID            STRING,
    PURCHASE_ID   STRING,
    ITEM_ID       STRING,
    ORIG_PRICE    DOUBLE,
    SALE_PRICE    DOUBLE,
    DISCOUNT_CODE STRING
) PARTITIONED BY (PURCHASE_DATE DATE);

CREATE TABLE IF NOT EXISTS TRANSACTION
(
    ID                 STRING,
    CUSTOMER_ID        STRING,
    PURCHASE_ID        STRING,
    CREDIT_CARD_NUM    STRING,
    CHARGE_AMOUNT      DOUBLE,
    MERCH_CODE         STRING,
    AUTH_CODE          STRING,
    REJECT             BOOLEAN,
    REJECT_REASON_CODE STRING,
    TRANSACTION_TS     TIMESTAMP
) PARTITIONED BY (TRANSACTION_DATE DATE);
*/