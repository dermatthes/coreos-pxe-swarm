#!/bin/bash
set +e
while 1; do
    sleep 30
    docker node promote `docker node ls | tail -n +2 | awk '{print $1} '`
done