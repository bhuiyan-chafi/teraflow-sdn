#!/bin/bash

#Remove previous topology
for container in TP2{1..4} RDM2{1..10}; do
  sudo docker stop -t 1 "$container"
  sudo docker rm "$container"
done