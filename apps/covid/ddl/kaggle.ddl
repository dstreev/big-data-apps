CREATE DATABASE IF NOT EXISTS COVID_KAGGLE;

USE COVID_KAGGLE;

DROP TABLE IF EXISTS COUNTRY_WISE_LATEST;

CREATE EXTERNAL TABLE IF NOT EXISTS COUNTRY_WISE_LATEST
(
    COUNTRY                  STRING,
    CONFIRMED                BIGINT,
    DEATHS                   BIGINT,
    RECOVERED                BIGINT,
    ACTIVE                   BIGINT,
    NEW_CASES                BIGINT,
    NEW_DEATHS               BIGINT,
    NEW_RECOVERED            BIGINT,
    DEATHS_PER_100_CASE      DOUBLE,
    RECOVERED_PER_100_CASE   DOUBLE,
    DEATHS_PER_100_RECOVERED DOUBLE,
    CONFIRMED_LAST_WEEK      BIGINT,
    ONE_WEEK_CHANGE          BIGINT,
    ONE_WEEK_INCREASE        DOUBLE,
    WHO_REGION               STRING
)
    ROW FORMAT SERDE
        'org.apache.hadoop.hive.serde2.OpenCSVSerde'
    STORED AS TEXTFILE
    TBLPROPERTIES ("skip.header.line.count" = "1");

DROP TABLE IF EXISTS CLEAN_COMPLETE;
CREATE EXTERNAL TABLE IF NOT EXISTS CLEAN_COMPLETE
(
    STATE      STRING,
    COUNTRY    STRING,
    LATITUDE   DOUBLE,
    LONGTITUDE DOUBLE,
    DATE_      DATE,
    CONFIRMED  BIGINT,
    DEATHS     BIGINT,
    RECOVERED  BIGINT,
    ACTIVE     BIGINT,
    WHO_REGION STRING
) ROW FORMAT SERDE
    'org.apache.hadoop.hive.serde2.OpenCSVSerde'
    STORED AS TEXTFILE
    TBLPROPERTIES ("skip.header.line.count" = "1");

DROP TABLE IF EXISTS DAY_WISE;

CREATE EXTERNAL TABLE IF NOT EXISTS DAY_WISE
(
    DATE_                    DATE COMMENT "Date",
    CONFIRMED                BIGINT COMMENT "Confirmed",
    DEATHS                   BIGINT COMMENT "Deaths",
    RECOVERED                BIGINT COMMENT "Recovered",
    ACTIVE                   BIGINT COMMENT "Active",
    NEW_CASES                BIGINT COMMENT "New cases",
    NEW_DEATHS               BIGINT COMMENT "New deaths",
    NEW_RECOVERED            BIGINT COMMENT "New recovered",
    DEATHS_PER_100_CASES     DOUBLE COMMENT "Deaths / 100 Cases",
    RECOVERED_PER_100_CASES  DOUBLE COMMENT "Recovered / 100 Cases",
    DEATHS_PER_100_RECOVERED DOUBLE COMMENT "Deaths / 100 Recovered",
    NUM_OF_COUNTRIES         INT COMMENT "No. of countries"
) ROW FORMAT SERDE
    'org.apache.hadoop.hive.serde2.OpenCSVSerde'
    STORED AS TEXTFILE
    TBLPROPERTIES ("skip.header.line.count" = "1");

DROP TABLE IF EXISTS FULL_GROUPED;

CREATE EXTERNAL TABLE IF NOT EXISTS FULL_GROUPED
(
    DATE_         DATE COMMENT "Date",
    COUNTRY       STRING COMMENT "Country/Region",
    CONFIRMED     BIGINT COMMENT "Confirmed",
    DEATHS        BIGINT COMMENT "Deaths",
    RECOVERED     BIGINT COMMENT "Recovered",
    ACTIVE        BIGINT COMMENT "Active",
    NEW_CASES     BIGINT COMMENT "New cases",
    NEW_DEATHS    BIGINT COMMENT "New deaths",
    NEW_RECOVERED BIGINT COMMENT "New recovered",
    WHO_REGION    STRING COMMENT "WHO Region"
) ROW FORMAT SERDE
    'org.apache.hadoop.hive.serde2.OpenCSVSerde'
    STORED AS TEXTFILE
    TBLPROPERTIES ("skip.header.line.count" = "1");

DROP TABLE IF EXISTS USA_COUNTY_WISE;

CREATE EXTERNAL TABLE IF NOT EXISTS USA_COUNTY_WISE
(
    UID            STRING COMMENT "UID",
    ISO2           STRING COMMENT "iso2",
    ISO3           STRING COMMENT "iso3",
    CODE3          STRING COMMENT "code3",
    FIPS           STRING COMMENT "FIPS",
    ADMIN2         STRING COMMENT "Admin2",
    PROVINCE_STATE STRING COMMENT "Province_State",
    COUNTRY_REGION STRING COMMENT "Country_Region",
    LATITUDE       DOUBLE COMMENT "Lat",
    LONGITUDE      DOUBLE COMMENT "Long_",
    COMBINED_KEY   STRING COMMENT "Combined_Key",
    DATE_          DATE COMMENT "Date",
    CONFIRMED      BIGINT COMMENT "Confirmed",
    DEATHS         BIGINT COMMENT "Deaths"
) ROW FORMAT SERDE
    'org.apache.hadoop.hive.serde2.OpenCSVSerde'
    STORED AS TEXTFILE
    TBLPROPERTIES ("skip.header.line.count" = "1");

DROP TABLE IF EXISTS WORLDOMETER_DATA;

CREATE EXTERNAL TABLE WORLDOMETER_DATA
(
    COUNTRY                STRING COMMENT "Country/Region",
    CONTINENT              STRING COMMENT "Continent",
    POPULATION             BIGINT COMMENT "Population",
    TOTAL_CASES            BIGINT COMMENT "TotalCases",
    NEW_CASES              BIGINT COMMENT "NewCases",
    TOTAL_DEATHS           BIGINT COMMENT "TotalDeaths",
    NEW_DEATHS             BIGINT COMMENT "NewDeaths",
    TOTAL_RECOVERED        BIGINT COMMENT "TotalRecovered",
    NEW_RECOVERED          BIGINT COMMENT "NewRecovered",
    ACTIVE_CASES           BIGINT COMMENT "ActiveCases",
    SERIOUS_CRITICAL       BIGINT COMMENT "Serious,Critical",
    TOTAL_CASES_PER_1M_POP BIGINT COMMENT "Tot Cases/1M pop",
    DEATHS_PER_1M_POP      BIGINT COMMENT "Deaths/1M pop",
    TOTAL_TESTS            BIGINT COMMENT "TotalTests",
    TESTS_PER_1M_POP       BIGINT COMMENT "Tests/1M pop",
    WHO_REGION             STRING COMMENT "WHO Region"
)
PARTITIONED BY (record_date DATE)
ROW FORMAT SERDE
    'org.apache.hadoop.hive.serde2.OpenCSVSerde'
    STORED AS TEXTFILE
    TBLPROPERTIES ("skip.header.line.count" = "1");

MSCK REPAIR TABLE WORLDOMETER_DATA;

DESCRIBE FORMATTED WORLDOMETER_DATA;

