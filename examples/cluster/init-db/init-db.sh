#!/bin/bash

sleep 3
for sql in `ls ${INIT_DB_DIR:-/sql}/*.sql`; do
    sleep 3
    for host in ${INIT_DB_HOSTS:-localhost}; do
        echo -n "Run ${sql} on ${host} ... "
        cat ${sql} | curl -s "http://${host}:8123/?query=" --data-binary @-
        echo
    done
done
