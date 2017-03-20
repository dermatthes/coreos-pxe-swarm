#!/bin/bash


# Minimum Uptime
CONF_MIN_UPTIME=86400

# Require at least n active Docker master nodes
CONF_MIN_DOCKER_MASTERS=3

# Require at least n active Docker nodes
CONF_MIN_DOCKER_NODES=4




set +e

##
# Check if System should be restarted
#

while [ true ]
do
    uptime=`awk '{print int($1)}' /proc/uptime`

    last_digit_of_ip=`echo $COREOS_PRIVATE_IPV4 | cut -d . -f 4`

    dayofweek=`date +%u`

    last_digit_mod_dayofweek=($last_digit_of_ip % 7)

    active_docker_nodes=`docker node ls | grep Ready | grep Active | wc -l`
    active_docker_master_nodes=`docker node ls | grep Ready | grep Active | grep -e "Reachable\|Leader" | wc -l`

    echo "Checking reboot policy:"
    sleep 3600
    echo "Uptime: $uptime LastDigitOfIp: $last_digit_of_ip Dayofweek: $dayofweek Active Nodes: $active_docker_nodes Active Masters: $active_docker_master_nodes"

    if [ $uptime -lt $CONF_MIN_UPTIME ]
    then
        echo "[SKIP] Uptime $uptime < $CONF_MIN_UPTIME"
        continue
    fi

    if [ $last_digit_of_ip -lt 2 ]
    then
        echo "[SKIP] Last digit of my ip: $last_digit_of_ip looks suspicious"
        continue
    fi

    if [ `expr $last_digit_of_ip % 7` -ne $dayofweek ]
    then
        echo "[SKIP] My last digit of ip MOD 7 is not dayofweek - today is not the right day to reboot"
        continue
    fi

    if [ $active_docker_master_nodes -lt $CONF_MIN_DOCKER_MASTERS ]
    then
        echo "[SKIP] Not enough active master nodes"
        continue
    fi

    if [ $active_docker_nodes -lt $CONF_MIN_DOCKER_NODES ]
    then
        echo "[SKIP] Not enough docker nodes"
        continue
    fi

    if [ `date +%l` -gt 5 ]
    then
        echo "[SKIP] Only rebooting between 0-3 o'clock"
        continue
    fi

    echo "[REBOOT NEEDED] Today is a good day to reboot..."

    while [ 1 ]
    do
        echo "Rolling the dices..."
        sleep `shuf -i320-600 -n1`
        if [ `shuf -i0-15 -n1` -eq 1 ]
        then
            echo "Rebooting now..."
            echo "Rebooting canceled!"
            #docker kill cloud-node-vip
            sleep 1
            #reboot
        fi
    done
done