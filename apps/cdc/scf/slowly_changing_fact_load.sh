#!/usr/bin/env bash

CURR_DIR=`pwd`

cd `dirname $0`

if [ ! -f ../../bin/gen-env.sh ]; then
    echo "Missing gen-env.sh"
    exit -1
fi

. ../../bin/gen-env.sh
java -jar $GEN_JAR -cfg slowly_changing_fact.yaml -scfg slowly_changing_fact_kafka.yaml

