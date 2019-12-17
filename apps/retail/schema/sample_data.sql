USE ${DB};

INSERT INTO TABLE CUSTOMER VALUES ("1","DAVID","GA"),
                               ("2","BETH","GA"),
                               ("3","DANI","NY"),
                               ("4","BURT","MD"),
                               ("5","LORI","MD"),
                               ("6","MARY","MA");

INSERT INTO TABLE VISIT VALUES ("A", "1", CAST("2019-12-12 09:09:00" as TIMESTAMP), 600),
                               ("B", "1", CAST("2019-12-13 10:00:00" as TIMESTAMP), 300),
                               ("C", "2", CAST("2019-12-10 10:00:00" as TIMESTAMP), 1200);


INSERT INTO TABLE PURCHASE VALUES ("A1", "1", "A", "Sara", "W3", "T1", 0.0, null, 40.32, "CASH"),
                                  ("A1.1", "1", "A", "Chuck", "W3", "T1", 0.0, null, 32.55, "CASH"),
                                 ("A2", "2", "A", "Chuck", "W3", "T1", 0.0, null, 25.40, "CASH");

