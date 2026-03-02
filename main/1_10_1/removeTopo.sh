#!/bin/bash

#Remove previous topology
for container in TP{1..2} RDM{1..10}; do
  sudo docker stop -t 1 "$container"
  sudo docker rm "$container"
done