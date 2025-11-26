#!/bin/bash
# RUN: bash RDM.A.201.1.sh
#Remove previous topology
docker stop RDM.A.201.2
docker rm RDM.A.201.2

echo "Creating ROADM RDM.A.201.2 ..."
docker run --net=netbrTFS --ip=10.100.201.2 --name RDM.A.201.2 -v "/home/asm/odtn-dockers/roadm.xml:/confd/examples.confd/OC23/init_openconfig-platform.xml" -dt asgamb1/flexscale-node.img ./startNetconfAgent.sh
