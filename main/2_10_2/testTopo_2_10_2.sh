#!/bin/bash

bash ./removeTopo.sh

echo "Creating TP21"
docker run --net=netbrTFS --ip=10.100.102.1 --name TP21 -v "/home/asm/tfs_emus/transponders_x4.xml:/confd/examples.confd/OC23/demoECOC21.xml" -dt asgamb1/oc23bgp.img ./startNetconfAgent.sh
sleep 2
echo "Creating TP22"
docker run --net=netbrTFS --ip=10.100.102.2 --name TP22 -v "/home/asm/tfs_emus/transponders_x4.xml:/confd/examples.confd/OC23/demoECOC21.xml" -dt asgamb1/oc23bgp.img ./startNetconfAgent.sh
sleep 2

echo "Creating RDM21..."
docker run --net=netbrTFS --ip=10.100.202.1 --name RDM21 -v "/home/asm/tfs_emus/roadm.xml:/confd/examples.confd/OC23/init_openconfig-platform.xml" -dt asgamb1/flexscale-node.img ./startNetconfAgent.sh
sleep 2

echo "Creating RDM22..."
docker run --net=netbrTFS --ip=10.100.202.2 --name RDM22 -v "/home/asm/tfs_emus/roadm.xml:/confd/examples.confd/OC23/init_openconfig-platform.xml" -dt asgamb1/flexscale-node.img ./startNetconfAgent.sh
sleep 2

echo "Creating RDM23..."
docker run --net=netbrTFS --ip=10.100.202.3 --name RDM23 -v "/home/asm/tfs_emus/roadm.xml:/confd/examples.confd/OC23/init_openconfig-platform.xml" -dt asgamb1/flexscale-node.img ./startNetconfAgent.sh
sleep 2

echo "Creating RDM24..."
docker run --net=netbrTFS --ip=10.100.202.4 --name RDM24 -v "/home/asm/tfs_emus/roadm.xml:/confd/examples.confd/OC23/init_openconfig-platform.xml" -dt asgamb1/flexscale-node.img ./startNetconfAgent.sh
sleep 2

echo "Creating RDM25..."
docker run --net=netbrTFS --ip=10.100.202.5 --name RDM25 -v "/home/asm/tfs_emus/roadm.xml:/confd/examples.confd/OC23/init_openconfig-platform.xml" -dt asgamb1/flexscale-node.img ./startNetconfAgent.sh
sleep 2

echo "Creating RDM26..."
docker run --net=netbrTFS --ip=10.100.202.6 --name RDM26 -v "/home/asm/tfs_emus/roadm.xml:/confd/examples.confd/OC23/init_openconfig-platform.xml" -dt asgamb1/flexscale-node.img ./startNetconfAgent.sh
sleep 2

echo "Creating RDM27..."
docker run --net=netbrTFS --ip=10.100.202.7 --name RDM27 -v "/home/asm/tfs_emus/roadm.xml:/confd/examples.confd/OC23/init_openconfig-platform.xml" -dt asgamb1/flexscale-node.img ./startNetconfAgent.sh
sleep 2

echo "Creating RDM28..."
docker run --net=netbrTFS --ip=10.100.202.8 --name RDM28 -v "/home/asm/tfs_emus/roadm.xml:/confd/examples.confd/OC23/init_openconfig-platform.xml" -dt asgamb1/flexscale-node.img ./startNetconfAgent.sh
sleep 2

echo "Creating RDM29..."
docker run --net=netbrTFS --ip=10.100.202.9 --name RDM29 -v "/home/asm/tfs_emus/roadm.xml:/confd/examples.confd/OC23/init_openconfig-platform.xml" -dt asgamb1/flexscale-node.img ./startNetconfAgent.sh
sleep 2

echo "Creating RDM210..."
docker run --net=netbrTFS --ip=10.100.202.10 --name RDM210 -v "/home/asm/tfs_emus/roadm.xml:/confd/examples.confd/OC23/init_openconfig-platform.xml" -dt asgamb1/flexscale-node.img ./startNetconfAgent.sh
sleep 2

echo "Creating TP23"
docker run --net=netbrTFS --ip=10.100.102.3 --name TP23 -v "/home/asm/tfs_emus/transponders_x4.xml:/confd/examples.confd/OC23/demoECOC21.xml" -dt asgamb1/oc23bgp.img ./startNetconfAgent.sh
sleep 2
echo "Creating TP24"
docker run --net=netbrTFS --ip=10.100.102.4 --name TP24 -v "/home/asm/tfs_emus/transponders_x4.xml:/confd/examples.confd/OC23/demoECOC21.xml" -dt asgamb1/oc23bgp.img ./startNetconfAgent.sh
sleep 2

echo ""
echo "Waiting for NETCONF agents to be ready..."
for ip in 10.100.102.{1..4} 10.100.202.{1..10}; do
  while ! nc -z -w 2 "$ip" 2022 2>/dev/null; do
    echo "  Waiting for $ip:2022..."
    sleep 2
  done
  echo "  $ip:2022 is ready"
done
echo ""
echo "Topology has been generated. All NETCONF agents are ready."
