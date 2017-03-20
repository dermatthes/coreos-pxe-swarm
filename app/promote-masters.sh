#!/bin/bash

set +e

#
# Auto-Promote new Nodes
#

while [ true ]; do
    sleep 30
    HOSTS_WITHOUT_MASTER_STATUS=`docker node ls | tail -n +2 | grep "Ready" | grep "Active" | grep -v "Leader" | grep -v "Reachable"`

    if [ $($HOSTS_WITHOUT_MASTER_STATUS | wc -l) > 0 ]; then
        docker node promote `$HOSTS_WITHOUT_MASTER_STATUS | awk '{print $1} '`
    fi
done