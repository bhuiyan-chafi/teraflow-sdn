#!/bin/sh

echo "Stop ONOS docker container"
sudo docker stop onos
sleep 2

echo "Start ONOS docker container"

sudo docker start onos
sleep 60

echo "Configure ONOS docker container"
./configure.sh

