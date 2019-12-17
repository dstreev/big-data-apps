USE ${TARGET_DB};

SELECT
    C.ID AS CUSTOMER_ID,
    FULL_NAME,
    NUM_OF_VISITS,
    PURCHASE_COUNT,
    TOTAL_PURCHASES
FROM
    CUSTOMER C
        LEFT OUTER JOIN
        (SELECT
             CUSTOMER_ID,
             count(*) AS NUM_OF_VISITS
         FROM
             VISIT
         GROUP BY CUSTOMER_ID) V ON C.ID = V.CUSTOMER_ID
        LEFT OUTER JOIN
        (SELECT
             CUSTOMER_ID,
             count(ID)           AS PURCHASE_COUNT,
             sum(TOTAL_PURCHASE) AS TOTAL_PURCHASES
         FROM
             PURCHASE
         GROUP BY CUSTOMER_ID) P ON C.ID = P.CUSTOMER_ID
WHERE
    C.STATE = "GA" or C.STATE = "NY"
LIMIT 100;