#!/bin/bash

set +e

#
# Auto-Promote/Demote/RM new/old Nodes
#

while [ true ]; do
    sleep 30

    if [ `hostname` != `docker node ls | grep "Leader" | awk '{print $3}'` ]; then
        echo "[$(date)] I'm not the swarm master... Skipping."
        sleep 120
        continue
    fi

    HOSTS_TO_REMOVE=`docker node ls | tail -n +2 | grep "Down" | grep "Unreachable"`
    HOSTS_TO_REMOVE_COUNT=`docker node ls | tail -n +2 | grep "Down" | grep "Unreachable" | wc -l`

    if (( $HOSTS_TO_REMOVE_COUNT > 0 )); then
        echo "[$(date)] Removing unavailable host... $HOSTS_TO_REMOVE"
        docker node demote `echo $HOSTS_TO_REMOVE | awk '{print $1} '` && docker node rm `echo $HOSTS_TO_REMOVE | awk '{print $1} '`
    fi

    HOSTS_WITHOUT_MASTER_STATUS=`docker node ls | tail -n +2 | grep "Ready" | grep "Active" | grep -v "Leader" | grep -v "Reachable" | grep -v "Unreachable"`
    HOSTS_WITHOUT_MASTER_STATUS_COUNT=`docker node ls | tail -n +2 | grep "Ready" | grep "Active" | grep -v "Leader" | grep -v "Reachable" | grep -v "Unreachable" | wc -l`

    if (( $HOSTS_WITHOUT_MASTER_STATUS_COUNT > 0 )); then
        echo "[$(date)] Promoting new master... $HOSTS_WITHOUT_MASTER_STATUS"
        docker node promote `echo $HOSTS_WITHOUT_MASTER_STATUS | awk '{print $1} '`
    fi
done