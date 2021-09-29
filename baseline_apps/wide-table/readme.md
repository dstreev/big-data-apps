# Wide Table Testing

- Generate data for a wide-table
- Apply Schema for Hive
- Test Throughput with `hive-sre perf`

## Data Generation

We'll use [io-data-generator]() to build the data for this effort.

### Run

```
datagen -s gen-wide-table.yaml 
```