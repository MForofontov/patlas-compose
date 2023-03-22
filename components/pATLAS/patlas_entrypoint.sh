#!/bin/bash

if [ "$1" = "init_all" ]
then
    # Wait for postgres
    sleep 60

    # Add database
    export PGPASSWORD=patlas
    psql -h db_patlas -U patlas patlas < plasmid_db_dev_final.sql

    # Run pATLAS service
    ./run.py patlas &

    # Required to continuously run docker container
    tail -f /dev/null
fi