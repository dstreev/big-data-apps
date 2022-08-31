#!/usr/bin/env bash

cd `dirname $0`

hive --hivevar DATABASE=$1 -f ../schema/cc-schema.ddl

