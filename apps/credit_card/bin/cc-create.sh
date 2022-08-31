#!/usr/bin/env bash

cd `dirname $0`

DATABASE=$1
echo "using database: ${DATABASE}"

hive --hivevar DATABASE=${DATABASE} -f ../schema/cc-schema.ddl

