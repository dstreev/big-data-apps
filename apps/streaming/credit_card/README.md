## Files

[Hive Schema](./credit-card-schema.sql)
[CC Transactions AVRO Schema](./cc-trans.avsc)
[CC Transactions (min) AVRO Schema](./cc-trans-min.avsc)


## Start the generators

`java -jar $GEN_JAR -cfg cc-trans-gen.yaml -scfg cc-trans-kafka.yaml`
`java -jar $GEN_JAR -cfg cc-acct-gen.yaml -scfg cc-acct-kafka.yaml`

## Kafka

### Create Topic

__CC_Trans__
`/usr/hdp/current/kafka-broker/bin/kafka-topics.sh --if-not-exists --create --topic CC_TRANS_JSON --partitions 20 --replication-factor 2 --zookeeper os04.streever.local:2181`

__CC_ACCT__
`/usr/hdp/current/kafka-broker/bin/kafka-topics.sh --if-not-exists --create --topic CC_ACCT_JSON --partitions 20 --replication-factor 2 --zookeeper os04.streever.local:2181`

### List Topics 3

`/usr/hdp/current/kafka-broker/bin/kafka-topics.sh --list --zookeeper os04.streever.local:2181`


### Delete Topic

`/usr/hdp/current/kafka-broker/bin/kafka-topics.sh --delete --topic CC_ACCT_JSON --zookeeper os04.streever.local:2181`

## Checking Client Topic Lag

`/usr/hdp/current/kafka-broker/bin/kafka-consumer-groups.sh --bootstrap-server os10.streever.local:6667 --group CC_NIFI --describe`

## Start the CC_ACCT generator

`java -jar $GEN_JAR -cfg cc-acct-gen.yaml -scfg cc-acct-kafka.yaml`

