#!/bin/bash

bash ./removeTopo.sh

echo "Creating TP1"
docker run --net=netbrTFS --ip=10.100.101.1 --name TP1 -v "/home/asm/tfs_emus/transponders_x4.xml:/confd/examples.confd/OC23/demoECOC21.xml" -dt asgamb1/oc23bgp.img ./startNetconfAgent.sh
sleep 2

echo "Creating RDM1..."
docker run --net=netbrTFS --ip=10.100.201.1 --name RDM1 -v "/home/asm/tfs_emus/roadm.xml:/confd/examples.confd/OC23/init_openconfig-platform.xml" -dt asgamb1/flexscale-node.img ./startNetconfAgent.sh
sleep 2

echo "Creating RDM2..."
docker run --net=netbrTFS --ip=10.100.201.2 --name RDM2 -v "/home/asm/tfs_emus/roadm.xml:/confd/examples.confd/OC23/init_openconfig-platform.xml" -dt asgamb1/flexscale-node.img ./startNetconfAgent.sh
sleep 2

echo "Creating RDM3..."
docker run --net=netbrTFS --ip=10.100.201.3 --name RDM3 -v "/home/asm/tfs_emus/roadm.xml:/confd/examples.confd/OC23/init_openconfig-platform.xml" -dt asgamb1/flexscale-node.img ./startNetconfAgent.sh
sleep 2

echo "Creating RDM4..."
docker run --net=netbrTFS --ip=10.100.201.4 --name RDM4 -v "/home/asm/tfs_emus/roadm.xml:/confd/examples.confd/OC23/init_openconfig-platform.xml" -dt asgamb1/flexscale-node.img ./startNetconfAgent.sh
sleep 2

echo "Creating RDM5..."
docker run --net=netbrTFS --ip=10.100.201.5 --name RDM5 -v "/home/asm/tfs_emus/roadm.xml:/confd/examples.confd/OC23/init_openconfig-platform.xml" -dt asgamb1/flexscale-node.img ./startNetconfAgent.sh
sleep 2

echo "Creating RDM6..."
docker run --net=netbrTFS --ip=10.100.201.6 --name RDM6 -v "/home/asm/tfs_emus/roadm.xml:/confd/examples.confd/OC23/init_openconfig-platform.xml" -dt asgamb1/flexscale-node.img ./startNetconfAgent.sh
sleep 2

echo "Creating RDM7..."
docker run --net=netbrTFS --ip=10.100.201.7 --name RDM7 -v "/home/asm/tfs_emus/roadm.xml:/confd/examples.confd/OC23/init_openconfig-platform.xml" -dt asgamb1/flexscale-node.img ./startNetconfAgent.sh
sleep 2

echo "Creating RDM8..."
docker run --net=netbrTFS --ip=10.100.201.8 --name RDM8 -v "/home/asm/tfs_emus/roadm.xml:/confd/examples.confd/OC23/init_openconfig-platform.xml" -dt asgamb1/flexscale-node.img ./startNetconfAgent.sh
sleep 2

echo "Creating RDM9..."
docker run --net=netbrTFS --ip=10.100.201.9 --name RDM9 -v "/home/asm/tfs_emus/roadm.xml:/confd/examples.confd/OC23/init_openconfig-platform.xml" -dt asgamb1/flexscale-node.img ./startNetconfAgent.sh
sleep 2

echo "Creating RDM10..."
docker run --net=netbrTFS --ip=10.100.201.10 --name RDM10 -v "/home/asm/tfs_emus/roadm.xml:/confd/examples.confd/OC23/init_openconfig-platform.xml" -dt asgamb1/flexscale-node.img ./startNetconfAgent.sh
sleep 2

echo "Creating TP2"
docker run --net=netbrTFS --ip=10.100.101.2 --name TP2 -v "/home/asm/tfs_emus/transponders_x4.xml:/confd/examples.confd/OC23/demoECOC21.xml" -dt asgamb1/oc23bgp.img ./startNetconfAgent.sh
sleep 2

echo ""
echo "Waiting for NETCONF agents to be ready..."
for ip in 10.100.101.{1..2} 10.100.201.{1..10}; do
  while ! nc -z -w 2 "$ip" 2022 2>/dev/null; do
    echo "  Waiting for $ip:2022..."
    sleep 2
  done
  echo "  $ip:2022 is ready"
done
echo ""
echo "Topology has been generated. All NETCONF agents are ready."
