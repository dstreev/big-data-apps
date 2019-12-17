-- Managed Table Query
SELECT
    flightdate
  , Operating_Airline
  , cancelled
  , origin
  , dest
  , Flight_Number_Operating_Airline
  , taxiout
  , taxiin
FROM
    airline_perf
WHERE
      origin = 'ATL'
  AND dest = 'LGA'
  AND operating_airline = 'DL'
  AND year_ = '2018'
  AND month_ = '10'