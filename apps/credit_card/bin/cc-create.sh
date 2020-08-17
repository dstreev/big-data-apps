#!/usr/bin/env bash

cd `dirname $0`

hive --hivevar database=$1 -f ../schema/cc-schema.ddl

