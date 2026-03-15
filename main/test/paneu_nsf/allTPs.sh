#!/bin/bash

echo "Creating TPlondon..."
docker run --net=netbrTFS --ip=10.100.101.1 --name TPlondon -v "/home/asm/tfs_emus/transponders_x4.xml:/confd/examples.confd/OC23/demoECOC21.xml" -dt asgamb1/oc23bgp.img ./startNetconfAgent.sh
sleep 2

echo "Creating TPparis..."
docker run --net=netbrTFS --ip=10.100.101.2 --name TPparis -v "/home/asm/tfs_emus/transponders_x4.xml:/confd/examples.confd/OC23/demoECOC21.xml" -dt asgamb1/oc23bgp.img ./startNetconfAgent.sh
sleep 2

echo "Creating TPfrankfurt..."
docker run --net=netbrTFS --ip=10.100.101.3 --name TPfrankfurt -v "/home/asm/tfs_emus/transponders_x4.xml:/confd/examples.confd/OC23/demoECOC21.xml" -dt asgamb1/oc23bgp.img ./startNetconfAgent.sh
sleep 2

echo "Creating TPamsterdam..."
docker run --net=netbrTFS --ip=10.100.101.4 --name TPamsterdam -v "/home/asm/tfs_emus/transponders_x4.xml:/confd/examples.confd/OC23/demoECOC21.xml" -dt asgamb1/oc23bgp.img ./startNetconfAgent.sh
sleep 2

echo "Creating TPmadrid..."
docker run --net=netbrTFS --ip=10.100.101.5 --name TPmadrid -v "/home/asm/tfs_emus/transponders_x4.xml:/confd/examples.confd/OC23/demoECOC21.xml" -dt asgamb1/oc23bgp.img ./startNetconfAgent.sh
sleep 2

echo "Creating TProme..."
docker run --net=netbrTFS --ip=10.100.101.6 --name TProme -v "/home/asm/tfs_emus/transponders_x4.xml:/confd/examples.confd/OC23/demoECOC21.xml" -dt asgamb1/oc23bgp.img ./startNetconfAgent.sh
sleep 2

echo "Creating TPberlin..."
docker run --net=netbrTFS --ip=10.100.101.7 --name TPberlin -v "/home/asm/tfs_emus/transponders_x4.xml:/confd/examples.confd/OC23/demoECOC21.xml" -dt asgamb1/oc23bgp.img ./startNetconfAgent.sh
sleep 2

echo "Creating TPwarsaw..."
docker run --net=netbrTFS --ip=10.100.101.8 --name TPwarsaw -v "/home/asm/tfs_emus/transponders_x4.xml:/confd/examples.confd/OC23/demoECOC21.xml" -dt asgamb1/oc23bgp.img ./startNetconfAgent.sh
sleep 2

echo "Creating TPstockholm..."
docker run --net=netbrTFS --ip=10.100.101.9 --name TPstockholm -v "/home/asm/tfs_emus/transponders_x4.xml:/confd/examples.confd/OC23/demoECOC21.xml" -dt asgamb1/oc23bgp.img ./startNetconfAgent.sh
sleep 2

echo "Creating TPathens..."
docker run --net=netbrTFS --ip=10.100.101.10 --name TPathens -v "/home/asm/tfs_emus/transponders_x4.xml:/confd/examples.confd/OC23/demoECOC21.xml" -dt asgamb1/oc23bgp.img ./startNetconfAgent.sh
sleep 2

echo "Creating TPcalifornia..."
docker run --net=netbrTFS --ip=10.100.101.11 --name TPcalifornia -v "/home/asm/tfs_emus/transponders_x4.xml:/confd/examples.confd/OC23/demoECOC21.xml" -dt asgamb1/oc23bgp.img ./startNetconfAgent.sh
sleep 2

echo "Creating TPtexas..."
docker run --net=netbrTFS --ip=10.100.101.12 --name TPtexas -v "/home/asm/tfs_emus/transponders_x4.xml:/confd/examples.confd/OC23/demoECOC21.xml" -dt asgamb1/oc23bgp.img ./startNetconfAgent.sh
sleep 2

echo "Creating TPnewyork..."
docker run --net=netbrTFS --ip=10.100.101.13 --name TPnewyork -v "/home/asm/tfs_emus/transponders_x4.xml:/confd/examples.confd/OC23/demoECOC21.xml" -dt asgamb1/oc23bgp.img ./startNetconfAgent.sh
sleep 2

echo "Creating TPflorida..."
docker run --net=netbrTFS --ip=10.100.101.14 --name TPflorida -v "/home/asm/tfs_emus/transponders_x4.xml:/confd/examples.confd/OC23/demoECOC21.xml" -dt asgamb1/oc23bgp.img ./startNetconfAgent.sh
sleep 2

echo "Creating TPillinois..."
docker run --net=netbrTFS --ip=10.100.101.15 --name TPillinois -v "/home/asm/tfs_emus/transponders_x4.xml:/confd/examples.confd/OC23/demoECOC21.xml" -dt asgamb1/oc23bgp.img ./startNetconfAgent.sh
sleep 2

echo ""
echo "Waiting for all TP NETCONF agents to be ready..."
for ip in 10.100.101.{1..15}; do
  while ! nc -z -w 2 "$ip" 2022 2>/dev/null; do
    echo "  Waiting for $ip:2022..."
    sleep 2
  done
  echo "  $ip:2022 is ready"
done
echo ""
echo "All 15 TPs are ready."
