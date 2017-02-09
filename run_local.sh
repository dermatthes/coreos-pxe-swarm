#!/bin/bash


docker rm -t coreos-pxe-swarm
docker build -t coreos-pxe-swarm .
echo "Starting image in interactive mode...";
docker run --net=host -e INTERFACE_BOOTSTRAP=br0 -it coreos-pxe-swarm

echo "Image closed...";