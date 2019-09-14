USE ${DB};

-- Discover Partitions
MSCK REPAIR TABLE airline_perf_ext;

DROP TABLE IF EXISTS airline_perf;

-- Would be nice to have a CREATE TABLE {the omission of external) .. LIKE .. STORED AS <alt_format>
CREATE TABLE airline_perf AS (
                             SELECT
                                 Year_
                               , Quarter
                               , Month_
                               , DayofMonth
                               , DayOfWeek
                               , FlightDate
                               , Marketing_Airline_Network
                               , Operated_or_Branded_Code_Share_Partners
                               , DOT_ID_Marketing_Airline
                               , IATA_Code_Marketing_Airline
                               , Flight_Number_Marketing_Airline
                               , Originally_Scheduled_Code_Share_Airline
                               , DOT_ID_Originally_Scheduled_Code_Share_Airline
                               , IATA_Code_Originally_Scheduled_Code_Share_Airline
                               , Flight_Num_Originally_Scheduled_Code_Share_Airline
                               , Operating_Airline
                               , DOT_ID_Operating_Airline
                               , IATA_Code_Operating_Airline
                               , Tail_Number
                               , Flight_Number_Operating_Airline
                               , OriginAirportID
                               , OriginAirportSeqID
                               , OriginCityMarketID
                               , Origin
                               , OriginCityName
                               , OriginState
                               , OriginStateFips
                               , OriginStateName
                               , OriginWac
                               , DestAirportID
                               , DestAirportSeqID
                               , DestCityMarketID
                               , Dest
                               , DestCityName
                               , DestState
                               , DestStateFips
                               , DestStateName
                               , DestWac
                               , CRSDepTime
                               , DepTime
                               , DepDelay
                               , DepDelayMinutes
                               , DepDel15
                               , DepartureDelayGroups
                               , DepTimeBlk
                               , TaxiOut
                               , WheelsOff
                               , WheelsOn
                               , TaxiIn
                               , CRSArrTime
                               , ArrTime
                               , ArrDelay
                               , ArrDelayMinutes
                               , ArrDel15
                               , ArrivalDelayGroups
                               , ArrTimeBlk
                               , Cancelled
                               , CancellationCode
                               , Diverted
                               , CRSElapsedTime
                               , ActualElapsedTime
                               , AirTime
                               , Flights
                               , Distance
                               , DistanceGroup
                               , CarrierDelay
                               , WeatherDelay
                               , NASDelay
                               , SecurityDelay
                               , LateAircraftDelay
                               , FirstDepTime
                               , TotalAddGTime
                               , LongestAddGTime
                               , DivAirportLandings
                               , DivReachedDest
                               , DivActualElapsedTime
                               , DivArrDelay
                               , DivDistance
                               , Div1Airport
                               , Div1AirportID
                               , Div1AirportSeqID
                               , Div1WheelsOn
                               , Div1TotalGTime
                               , Div1LongestGTime
                               , Div1WheelsOff
                               , Div1TailNum
                               , Div2Airport
                               , Div2AirportID
                               , Div2AirportSeqID
                               , Div2WheelsOn
                               , Div2TotalGTime
                               , Div2LongestGTime
                               , Div2WheelsOff
                               , Div2TailNum
                               , Div3Airport
                               , Div3AirportID
                               , Div3AirportSeqID
                               , Div3WheelsOn
                               , Div3TotalGTime
                               , Div3LongestGTime
                               , Div3WheelsOff
                               , Div3TailNum
                               , Div4Airport
                               , Div4AirportID
                               , Div4AirportSeqID
                               , Div4WheelsOn
                               , Div4TotalGTime
                               , Div4LongestGTime
                               , Div4WheelsOff
                               , Div4TailNum
                               , Div5Airport
                               , Div5AirportID
                               , Div5AirportSeqID
                               , Div5WheelsOn
                               , Div5TotalGTime
                               , Div5LongestGTime
                               , Div5WheelsOff
                               , Div5TailNum
                               , Duplicate
                             FROM
                                 airline_perf_ext
                             WHERE
                                 year_month = 'NOT_SET'
                             );