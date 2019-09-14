## Demo Project for Credit Card Transactions.

### Goals

- Stream CC Transactions into Kafka in formats:
    - JSON
    - CSV
- Read JSON
    - Drive into Druid Cubes (with no touch)
    - Read through NiFi, parse and send to CSV
        - Show capabilities of NiFi registry
        - Show performance implications at scale.
- Read CSV
    - From NiFi and drive into a Hive Streaming table to show ACID capabilities.


### Dependency

This project depends on a generator to produce the datasets.
