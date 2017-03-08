#!/bin/bash

while 1; do
    sleep 10
    docker node promote `docker node ls | tail -n +2 | awk '{print $1} '`
done