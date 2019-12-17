#!/usr/bin/env sh

echo "--- Customer ---"
java -jar $GEN_JAR -cfg customer.yaml -c 100000 -o customer.csv
echo "--- Visit ---"
java -jar $GEN_JAR -cfg visit.yaml -c 20000000 -o visit.csv
echo "--- Purchase ---"
java -jar $GEN_JAR -cfg purchase.yaml -c 10000000 -o purchase.csv