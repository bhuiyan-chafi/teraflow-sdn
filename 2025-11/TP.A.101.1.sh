# run with sudo: sudo ./teraFlowTopo.sh
#!/bin/bash

#Remove previous topology
sudo docker stop TP.A.101.1
sudo docker rm TP.A.101.1

echo "Creating TP on 10.100.101.1"
docker run --net=netbrTFS --ip=10.100.101.1 --name TP.A.101.1 -v "/home/asm/p_andrea/transponders_x4.xml:/confd/examples.confd/OC23/demoECOC21.xml" -dt asgamb1/oc23bgp.img ./startNetconfAgent.sh
sleep 2
