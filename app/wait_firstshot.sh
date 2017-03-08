#!/bin/bash


for i in {300..0}; do
 sleep 1
 if [ -e "/tmp/bootstrap_firstshot.lock" ]; then
    echo "[OK] First node feeded successfully - Shutting down bootstrap mode"
    sleep 1;
    exit 0;
 fi



done

echo "[ERROR] No node requested PXE-Boot within 5 minutes. Exiting!"
exit 1
