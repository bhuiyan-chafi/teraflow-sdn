#!/bin/sh

echo "Stop ONOS docker container"
sudo docker stop onos
sleep 2

echo "Remove ONOS docker container"
sudo docker rm onos
sleep 20

echo "Start ONOS docker container"
docker run -d --name onos -p 8181:8181 onosproject/onos
sleep 60

echo "Configure ONOS docker container"
./configure.sh

