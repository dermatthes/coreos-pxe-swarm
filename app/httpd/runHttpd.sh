#!/bin/bash


php -d variables_order=EGPCS -S $PXE_SERVER_IP:888 ./httpd.php