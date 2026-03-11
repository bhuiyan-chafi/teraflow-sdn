#!/bin/bash

# ============================================================
# allTPs.sh — Start all 20 Transponder containers
# Naming: TP1–TP20
# IPs:    10.100.101.1–10.100.101.20
# ============================================================
echo "Creating TP1"
docker run --net=netbrTFS --ip=10.100.101.1 --name TP1 -v "/home/asm/tfs_emus/transponders_x4.xml:/confd/examples.confd/OC23/demoECOC21.xml" -dt asgamb1/oc23bgp.img ./startNetconfAgent.sh
sleep 2

echo "Creating TP2"
docker run --net=netbrTFS --ip=10.100.101.2 --name TP2 -v "/home/asm/tfs_emus/transponders_x4.xml:/confd/examples.confd/OC23/demoECOC21.xml" -dt asgamb1/oc23bgp.img ./startNetconfAgent.sh
sleep 2

echo "Creating TP3"
docker run --net=netbrTFS --ip=10.100.101.3 --name TP3 -v "/home/asm/tfs_emus/transponders_x4.xml:/confd/examples.confd/OC23/demoECOC21.xml" -dt asgamb1/oc23bgp.img ./startNetconfAgent.sh
sleep 2

echo "Creating TP4"
docker run --net=netbrTFS --ip=10.100.101.4 --name TP4 -v "/home/asm/tfs_emus/transponders_x4.xml:/confd/examples.confd/OC23/demoECOC21.xml" -dt asgamb1/oc23bgp.img ./startNetconfAgent.sh
sleep 2

echo "Creating TP5"
docker run --net=netbrTFS --ip=10.100.101.5 --name TP5 -v "/home/asm/tfs_emus/transponders_x4.xml:/confd/examples.confd/OC23/demoECOC21.xml" -dt asgamb1/oc23bgp.img ./startNetconfAgent.sh
sleep 2

echo "Creating TP6"
docker run --net=netbrTFS --ip=10.100.101.6 --name TP6 -v "/home/asm/tfs_emus/transponders_x4.xml:/confd/examples.confd/OC23/demoECOC21.xml" -dt asgamb1/oc23bgp.img ./startNetconfAgent.sh
sleep 2

echo "Creating TP7"
docker run --net=netbrTFS --ip=10.100.101.7 --name TP7 -v "/home/asm/tfs_emus/transponders_x4.xml:/confd/examples.confd/OC23/demoECOC21.xml" -dt asgamb1/oc23bgp.img ./startNetconfAgent.sh
sleep 2

echo "Creating TP8"
docker run --net=netbrTFS --ip=10.100.101.8 --name TP8 -v "/home/asm/tfs_emus/transponders_x4.xml:/confd/examples.confd/OC23/demoECOC21.xml" -dt asgamb1/oc23bgp.img ./startNetconfAgent.sh
sleep 2

echo "Creating TP9"
docker run --net=netbrTFS --ip=10.100.101.9 --name TP9 -v "/home/asm/tfs_emus/transponders_x4.xml:/confd/examples.confd/OC23/demoECOC21.xml" -dt asgamb1/oc23bgp.img ./startNetconfAgent.sh
sleep 2

echo "Creating TP10"
docker run --net=netbrTFS --ip=10.100.101.10 --name TP10 -v "/home/asm/tfs_emus/transponders_x4.xml:/confd/examples.confd/OC23/demoECOC21.xml" -dt asgamb1/oc23bgp.img ./startNetconfAgent.sh
sleep 2

echo "Creating TP11"
docker run --net=netbrTFS --ip=10.100.101.11 --name TP11 -v "/home/asm/tfs_emus/transponders_x4.xml:/confd/examples.confd/OC23/demoECOC21.xml" -dt asgamb1/oc23bgp.img ./startNetconfAgent.sh
sleep 2

echo "Creating TP12"
docker run --net=netbrTFS --ip=10.100.101.12 --name TP12 -v "/home/asm/tfs_emus/transponders_x4.xml:/confd/examples.confd/OC23/demoECOC21.xml" -dt asgamb1/oc23bgp.img ./startNetconfAgent.sh
sleep 2

echo "Creating TP13"
docker run --net=netbrTFS --ip=10.100.101.13 --name TP13 -v "/home/asm/tfs_emus/transponders_x4.xml:/confd/examples.confd/OC23/demoECOC21.xml" -dt asgamb1/oc23bgp.img ./startNetconfAgent.sh
sleep 2

echo "Creating TP14"
docker run --net=netbrTFS --ip=10.100.101.14 --name TP14 -v "/home/asm/tfs_emus/transponders_x4.xml:/confd/examples.confd/OC23/demoECOC21.xml" -dt asgamb1/oc23bgp.img ./startNetconfAgent.sh
sleep 2

echo "Creating TP15"
docker run --net=netbrTFS --ip=10.100.101.15 --name TP15 -v "/home/asm/tfs_emus/transponders_x4.xml:/confd/examples.confd/OC23/demoECOC21.xml" -dt asgamb1/oc23bgp.img ./startNetconfAgent.sh
sleep 2

echo "Creating TP16"
docker run --net=netbrTFS --ip=10.100.101.16 --name TP16 -v "/home/asm/tfs_emus/transponders_x4.xml:/confd/examples.confd/OC23/demoECOC21.xml" -dt asgamb1/oc23bgp.img ./startNetconfAgent.sh
sleep 2

echo "Creating TP17"
docker run --net=netbrTFS --ip=10.100.101.17 --name TP17 -v "/home/asm/tfs_emus/transponders_x4.xml:/confd/examples.confd/OC23/demoECOC21.xml" -dt asgamb1/oc23bgp.img ./startNetconfAgent.sh
sleep 2

echo "Creating TP18"
docker run --net=netbrTFS --ip=10.100.101.18 --name TP18 -v "/home/asm/tfs_emus/transponders_x4.xml:/confd/examples.confd/OC23/demoECOC21.xml" -dt asgamb1/oc23bgp.img ./startNetconfAgent.sh
sleep 2

echo "Creating TP19"
docker run --net=netbrTFS --ip=10.100.101.19 --name TP19 -v "/home/asm/tfs_emus/transponders_x4.xml:/confd/examples.confd/OC23/demoECOC21.xml" -dt asgamb1/oc23bgp.img ./startNetconfAgent.sh
sleep 2

echo "Creating TP20"
docker run --net=netbrTFS --ip=10.100.101.20 --name TP20 -v "/home/asm/tfs_emus/transponders_x4.xml:/confd/examples.confd/OC23/demoECOC21.xml" -dt asgamb1/oc23bgp.img ./startNetconfAgent.sh
sleep 2

echo ""
echo "Waiting for all TP NETCONF agents to be ready..."
for ip in 10.100.101.{1..20}; do
  while ! nc -z -w 2 "$ip" 2022 2>/dev/null; do
    echo "  Waiting for $ip:2022..."
    sleep 2
  done
  echo "  $ip:2022 is ready"
done
echo ""
echo "All 20 TPs are ready."
