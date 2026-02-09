#!/bin/bash

#Remove previous topology
sudo docker stop -t 1 TP1
sudo docker rm TP1
sudo docker stop -t 1 TP2
sudo docker rm TP2
sudo docker stop -t 1 RDM1
sudo docker rm RDM1

echo "Creating TP1"
docker run --net=netbrTFS --ip=10.100.101.1 --name TP1 -v "/home/asm/p_andrea/transponders_x4.xml:/confd/examples.confd/OC23/demoECOC21.xml" -dt asgamb1/oc23bgp.img ./startNetconfAgent.sh
sleep 2
echo "Creating RDM1..."
docker run --net=netbrTFS --ip=10.100.201.1 --name RDM1 -v "/home/asm/p_andrea/roadm.xml:/confd/examples.confd/OC23/init_openconfig-platform.xml" -dt asgamb1/flexscale-node.img ./startNetconfAgent.sh
sleep 2
echo "Creating TP2"
docker run --net=netbrTFS --ip=10.100.101.2 --name TP2 -v "/home/asm/p_andrea/transponders_x4.xml:/confd/examples.confd/OC23/demoECOC21.xml" -dt asgamb1/oc23bgp.img ./startNetconfAgent.sh
sleep 2
echo "Topology has been generated"