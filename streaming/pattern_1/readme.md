# Streaming Pattern #1 (Avoiding Small Files)

## Summary

This is a classic streaming use case that moves data from a streaming source (Kafka) into Hadoop and make the data available for near realtime consumption.

While a simple use case, volume and availability present a challenge for Big Data Platforms.  How do you make this data available as quickly as possible without consuming valuable resource both during ingestion but more importantly during consumption.

We have the following functional requirements of this pattern:

- The data needs to be available within 1 minute.
- Data ingestion needs to be atomic.  Meaning that we need to establish transactional boundaries for data landing into the system and support concurrent read operations during ingestion.

Filesystems like HDFS and S3 deal with files or objects as an immutable construct.  Meaning that the item can't be changed randomly, it must be rewritten.  This restriction is what allows the filesystems to scale at the levels needed for big data.

The dilemma than becomes the number of inefficient files/objects created by the streaming process.  If you've been working with big data platforms for very long, this is known as the 'Small File Problem'.

'Small Files', in any system, present challenges during consumption.  Given our requirements above, lets consider a streaming feed that's reading 100k records a second.  To scale, you would have created multiple channels to read the stream.  Let's assume that's 10 channels.  Each channels would handle an average of 10k records a sec.   
     

## Environment

Technology | Version
----------- | ---------
Hortonworks Data Platform | 3.1.0
Hive | 3.1.0
Kafka | 2.0
[IOT Data Generator](https://github.com/dstreev/iot-data-utility) [(binary)](https://github.com/dstreev/iot-data-utility/releases/download/3.0_beta4/data-utility-generator-3.0-SNAPSHOT-shaded.jar) | 3.0 beta4
HDF | 3.3.1
HDF NiFi | 1.8.0.3.3.1.0-10
Kerberized | Yes  
