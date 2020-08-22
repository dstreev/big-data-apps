CREATE DATABASE IF NOT EXISTS ${DATABASE};

USE ${DATABASE};

DROP TABLE IF EXISTS COUNTRIES_AGGREGATED_SWEEP;

CREATE EXTERNAL TABLE IF NOT EXISTS COUNTRIES_AGGREGATED_SWEEP
(
    RECORD_DATE DATE COMMENT "DATE",
    COUNTRY     STRING COMMENT "Country",
    CONFIRMED   BIGINT COMMENT "Confirmed",
    RECOVERED   BIGINT COMMENT "Recovered",
    DEATHS      BIGINT COMMENT "Deaths"
)
    ROW FORMAT SERDE
        'org.apache.hadoop.hive.serde2.OpenCSVSerde'
    STORED AS TEXTFILE
    TBLPROPERTIES ("skip.header.line.count" = "1");

-- Specifically NOT scripting DROP of Archive table to prevent
-- Accidental delete of data that can NOT be recovered.
DROP TABLE IF EXISTS COUNTRIES_AGGREGATED_ARCHIVE;

CREATE TABLE IF NOT EXISTS COUNTRIES_AGGREGATED_ARCHIVE
(
    RECORD_DATE      DATE COMMENT "DATE",
    COUNTRY          STRING COMMENT "Country",
    CONFIRMED        BIGINT COMMENT "Confirmed",
    RECOVERED        BIGINT COMMENT "Recovered",
    DEATHS           BIGINT COMMENT "Deaths",
    PROCESSING_CYCLE STRING
)
    PARTITIONED BY (
        YEAR_MONTH STRING
        );

DROP TABLE IF EXISTS COUNTRIES_AGGREGATED;

CREATE TABLE IF NOT EXISTS COUNTRIES_AGGREGATED
(
    RECORD_DATE DATE COMMENT "DATE",
    COUNTRY     STRING COMMENT "Country",
    CONFIRMED   BIGINT COMMENT "Confirmed",
    RECOVERED   BIGINT COMMENT "Recovered",
    DEATHS      BIGINT COMMENT "Deaths"
);

DROP TABLE IF EXISTS KEY_COUNTRIES_PIVOTED_SWEEP;

CREATE EXTERNAL TABLE IF NOT EXISTS KEY_COUNTRIES_PIVOTED_SWEEP
(
    RECORD_DATE DATE COMMENT "Date",
    CHINA       BIGINT COMMENT "China",
    US          BIGINT COMMENT "US",
    UK          BIGINT COMMENT "United Kingdom",
    ITALY       BIGINT COMMENT "Italy",
    FRANCE      BIGINT COMMENT "FRANCE",
    GERMANY     BIGINT COMMENT "Germany",
    SPAIN       BIGINT COMMENT "SPAIN",
    IRAN        BIGINT COMMENT "IRAN"
)
    ROW FORMAT SERDE
        'org.apache.hadoop.hive.serde2.OpenCSVSerde'
    STORED AS TEXTFILE
    TBLPROPERTIES ("skip.header.line.count" = "1");

-- Specifically NOT scripting DROP of Archive table to prevent
-- Accidental delete of data that can NOT be recovered.
DROP TABLE IF EXISTS KEY_COUNTRIES_PIVOTED_ARCHIVE;

CREATE TABLE IF NOT EXISTS KEY_COUNTRIES_PIVOTED_ARCHIVE
(
    RECORD_DATE      DATE COMMENT "Date",
    CHINA            BIGINT COMMENT "China",
    US               BIGINT COMMENT "US",
    UK               BIGINT COMMENT "United Kingdom",
    ITALY            BIGINT COMMENT "Italy",
    FRANCE           BIGINT COMMENT "FRANCE",
    GERMANY          BIGINT COMMENT "Germany",
    SPAIN            BIGINT COMMENT "SPAIN",
    IRAN             BIGINT COMMENT "IRAN",
    PROCESSING_CYCLE STRING
)
    PARTITIONED BY (
        YEAR_MONTH STRING
        );

DROP TABLE IF EXISTS KEY_COUNTRIES_PIVOTED;

CREATE TABLE IF NOT EXISTS KEY_COUNTRIES_PIVOTED
(
    RECORD_DATE DATE COMMENT "Date",
    CHINA       BIGINT COMMENT "China",
    US          BIGINT COMMENT "US",
    UK          BIGINT COMMENT "United Kingdom",
    ITALY       BIGINT COMMENT "Italy",
    FRANCE      BIGINT COMMENT "FRANCE",
    GERMANY     BIGINT COMMENT "Germany",
    SPAIN       BIGINT COMMENT "SPAIN",
    IRAN        BIGINT COMMENT "IRAN"
);


DROP TABLE IF EXISTS REFERENCE_SWEEP;
CREATE EXTERNAL TABLE REFERENCE_SWEEP
(
    UID            STRING,
    ISO2           STRING,
    ISO3           STRING,
    CODE           STRING,
    FIPS           STRING,
    ADMIN2         STRING,
    PROVINCE_STATE STRING,
    COUNTRY_REGION STRING,
    LATITUDE       DOUBLE,
    LONGITUDE      DOUBLE,
    COMBINED_KEY   STRING,
    POPULATION     BIGINT
)
    ROW FORMAT SERDE
        'org.apache.hadoop.hive.serde2.OpenCSVSerde'
    STORED AS TEXTFILE
    TBLPROPERTIES ("skip.header.line.count" = "1");

DROP TABLE IF EXISTS REFERENCE_ARCHIVE;
CREATE TABLE REFERENCE_ARCHIVE
(
    UID              STRING,
    ISO2             STRING,
    ISO3             STRING,
    CODE             STRING,
    FIPS             STRING,
    ADMIN2           STRING,
    PROVINCE_STATE   STRING,
    COUNTRY_REGION   STRING,
    LATITUDE         DOUBLE,
    LONGITUDE        DOUBLE,
    COMBINED_KEY     STRING,
    POPULATION       BIGINT,
    PROCESSING_CYCLE STRING
)
    PARTITIONED BY (
        YEAR_MONTH STRING
        );

DROP TABLE IF EXISTS REFERENCE;
CREATE TABLE REFERENCE
(
    UID            STRING,
    ISO2           STRING,
    ISO3           STRING,
    CODE           STRING,
    FIPS           STRING,
    ADMIN2         STRING,
    PROVINCE_STATE STRING,
    COUNTRY_REGION STRING,
    LATITUDE       DOUBLE,
    LONGITUDE      DOUBLE,
    COMBINED_KEY   STRING,
    POPULATION     BIGINT
);

DROP TABLE IF EXISTS TIME_SERIES_COMBINED_SWEEP;

CREATE EXTERNAL TABLE IF NOT EXISTS TIME_SERIES_COMBINED_SWEEP
(
    RECORD_DATE DATE,
    COUNTRY_REGION STRING,
    STATE STRING,
    LATITUDE DOUBLE,
    LONGITUDE DOUBLE,
    CONFIRMED BIGINT,
    RECOVERED BIGINT,
    DEATHS BIGINT
)
ROW FORMAT SERDE
    'org.apache.hadoop.hive.serde2.OpenCSVSerde'
    STORED AS TEXTFILE
    TBLPROPERTIES ("skip.header.line.count" = "1");

DROP TABLE IF EXISTS TIME_SERIES_COMBINED_ARCHIVE;

CREATE TABLE IF NOT EXISTS TIME_SERIES_COMBINED_ARCHIVE
(
    RECORD_DATE      DATE,
    COUNTRY_REGION   STRING,
    STATE            STRING,
    LATITUDE         DOUBLE,
    LONGITUDE        DOUBLE,
    CONFIRMED        BIGINT,
    RECOVERED        BIGINT,
    DEATHS           BIGINT,
    PROCESSING_CYCLE STRING
)
    PARTITIONED BY (
        YEAR_MONTH STRING
        );;


DROP TABLE IF EXISTS TIME_SERIES_COMBINED;

CREATE TABLE IF NOT EXISTS TIME_SERIES_COMBINED
(
    RECORD_DATE    DATE,
    COUNTRY_REGION STRING,
    STATE          STRING,
    LATITUDE       DOUBLE,
    LONGITUDE      DOUBLE,
    CONFIRMED      BIGINT,
    RECOVERED      BIGINT,
    DEATHS         BIGINT
);



DROP TABLE IF EXISTS US_CONFIRMED_SWEEP;

CREATE EXTERNAL TABLE IF NOT EXISTS US_CONFIRMED_SWEEP
(
    UID          STRING,
    ISO2         STRING,
    ISO3         STRING,
    CODE3        STRING,
    FIPS         STRING,
    ADMIN2       STRING,
    LATITUDE     DOUBLE,
    COMBINED_KEY STRING,
    RECORD_DATE  DATE,
    CASES        BIGINT,
    LONGITUDE    BIGINT,
    COUNTRY      STRING,
    STATE        STRING
)
    ROW FORMAT SERDE
        'org.apache.hadoop.hive.serde2.OpenCSVSerde'
    STORED AS TEXTFILE
    TBLPROPERTIES ("skip.header.line.count" = "1");

DROP TABLE IF EXISTS US_CONFIRMED_ARCHIVE;

CREATE TABLE IF NOT EXISTS US_CONFIRMED_ARCHIVE
(
    UID              STRING,
    ISO2             STRING,
    ISO3             STRING,
    CODE3            STRING,
    FIPS             STRING,
    ADMIN2           STRING,
    LATITUDE         DOUBLE,
    COMBINED_KEY     STRING,
    RECORD_DATE      DATE,
    CASES            BIGINT,
    LONGITUDE        BIGINT,
    COUNTRY          STRING,
    STATE            STRING,
    PROCESSING_CYCLE STRING
)
    PARTITIONED BY (
        YEAR_MONTH STRING
        );

DROP TABLE IF EXISTS US_CONFIRMED;

CREATE TABLE IF NOT EXISTS US_CONFIRMED
(
    UID              STRING,
    ISO2             STRING,
    ISO3             STRING,
    CODE3            STRING,
    FIPS             STRING,
    ADMIN2           STRING,
    LATITUDE         DOUBLE,
    COMBINED_KEY     STRING,
    RECORD_DATE      DATE,
    CASES            BIGINT,
    LONGITUDE        BIGINT,
    COUNTRY          STRING,
    STATE            STRING
);


DROP TABLE IF EXISTS US_DEATHS_SWEEP;

CREATE EXTERNAL TABLE IF NOT EXISTS US_DEATHS_SWEEP
(
    UID          STRING,
    ISO2         STRING,
    ISO3         STRING,
    CODE3        STRING,
    FIPS         STRING,
    ADMIN2       STRING,
    LATITUDE     DOUBLE,
    COMBINED_KEY STRING,
    POPULATION   BIGINT,
    RECORD_DATE  DATE,
    CASES        BIGINT,
    LONGITUDE    DOUBLE,
    COUNTRY      STRING,
    STATE        STRING
)
    ROW FORMAT SERDE
        'org.apache.hadoop.hive.serde2.OpenCSVSerde'
    STORED AS TEXTFILE
    TBLPROPERTIES ("skip.header.line.count" = "1");

DROP TABLE IF EXISTS US_DEATHS_ARCHIVE;

CREATE TABLE IF NOT EXISTS US_DEATHS_ARCHIVE
(
    UID              STRING,
    ISO2             STRING,
    ISO3             STRING,
    CODE3            STRING,
    FIPS             STRING,
    ADMIN2           STRING,
    LATITUDE         DOUBLE,
    COMBINED_KEY     STRING,
    POPULATION       BIGINT,
    RECORD_DATE      DATE,
    CASES            BIGINT,
    LONGITUDE        DOUBLE,
    COUNTRY          STRING,
    STATE            STRING,
    PROCESSING_CYCLE STRING
)
    PARTITIONED BY (
        YEAR_MONTH STRING
        );

DROP TABLE IF EXISTS US_DEATHS;

CREATE TABLE IF NOT EXISTS US_DEATHS
(
    UID          STRING,
    ISO2         STRING,
    ISO3         STRING,
    CODE3        STRING,
    FIPS         STRING,
    ADMIN2       STRING,
    LATITUDE     DOUBLE,
    COMBINED_KEY STRING,
    POPULATION   BIGINT,
    RECORD_DATE  DATE,
    CASES        BIGINT,
    LONGITUDE    DOUBLE,
    COUNTRY      STRING,
    STATE        STRING
);

DROP TABLE IF EXISTS WORLDWIDE_AGGREGATED_SWEEP;

CREATE EXTERNAL TABLE WORLDWIDE_AGGREGATED_SWEEP
(
    RECORD_DATE   DATE,
    CONFIRMED     BIGINT,
    RECOVERED     BIGINT,
    DEATHS        BIGINT,
    INCREASE_RATE DOUBLE
)
    ROW FORMAT SERDE
        'org.apache.hadoop.hive.serde2.OpenCSVSerde'
    STORED AS TEXTFILE
    TBLPROPERTIES ("skip.header.line.count" = "1");

DROP TABLE IF EXISTS WORLDWIDE_AGGREGATED_ARCHIVE;

CREATE TABLE WORLDWIDE_AGGREGATED_ARCHIVE
(
    RECORD_DATE      DATE,
    CONFIRMED        BIGINT,
    RECOVERED        BIGINT,
    DEATHS           BIGINT,
    INCREASE_RATE    DOUBLE,
    PROCESSING_CYCLE STRING
)
    PARTITIONED BY (
        YEAR_MONTH STRING
        );

DROP TABLE IF EXISTS WORLDWIDE_AGGREGATED;

CREATE TABLE WORLDWIDE_AGGREGATED
(
    RECORD_DATE      DATE,
    CONFIRMED        BIGINT,
    RECOVERED        BIGINT,
    DEATHS           BIGINT,
    INCREASE_RATE    DOUBLE
);
