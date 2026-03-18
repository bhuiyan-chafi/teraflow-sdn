#!/bin/bash

echo "Creating TP1..."
docker run --net=netbrTFS --ip=10.100.102.1 --name TP1 -v "/home/asm/tfs_emus/transponders_x4.xml:/confd/examples.confd/OC23/demoECOC21.xml" -dt asgamb1/oc23bgp.img ./startNetconfAgent.sh
sleep 2

echo "Creating TP2..."
docker run --net=netbrTFS --ip=10.100.102.2 --name TP2 -v "/home/asm/tfs_emus/transponders_x4.xml:/confd/examples.confd/OC23/demoECOC21.xml" -dt asgamb1/oc23bgp.img ./startNetconfAgent.sh
sleep 2

echo "Creating TP3..."
docker run --net=netbrTFS --ip=10.100.102.3 --name TP3 -v "/home/asm/tfs_emus/transponders_x4.xml:/confd/examples.confd/OC23/demoECOC21.xml" -dt asgamb1/oc23bgp.img ./startNetconfAgent.sh
sleep 2

echo "Creating TP4..."
docker run --net=netbrTFS --ip=10.100.102.4 --name TP4 -v "/home/asm/tfs_emus/transponders_x4.xml:/confd/examples.confd/OC23/demoECOC21.xml" -dt asgamb1/oc23bgp.img ./startNetconfAgent.sh
sleep 2

echo "Creating TP5..."
docker run --net=netbrTFS --ip=10.100.102.5 --name TP5 -v "/home/asm/tfs_emus/transponders_x4.xml:/confd/examples.confd/OC23/demoECOC21.xml" -dt asgamb1/oc23bgp.img ./startNetconfAgent.sh
sleep 2

echo "Creating TP6..."
docker run --net=netbrTFS --ip=10.100.102.6 --name TP6 -v "/home/asm/tfs_emus/transponders_x4.xml:/confd/examples.confd/OC23/demoECOC21.xml" -dt asgamb1/oc23bgp.img ./startNetconfAgent.sh
sleep 2

echo ""
echo "Waiting for all TP NETCONF agents to be ready..."
for ip in 10.100.102.{1..6}; do
  while ! nc -z -w 2 "$ip" 2022 2>/dev/null; do
    echo "  Waiting for $ip:2022..."
    sleep 2
  done
  echo "  $ip:2022 is ready"
done
echo ""
echo "All 6 TPs are ready."
