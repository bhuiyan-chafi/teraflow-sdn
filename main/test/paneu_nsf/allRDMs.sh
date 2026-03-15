#!/bin/bash

echo "Creating RDMlondon..."
docker run --net=netbrTFS --ip=10.100.201.1 --name RDMlondon -v "/home/asm/tfs_emus/roadm.xml:/confd/examples.confd/OC23/init_openconfig-platform.xml" -dt asgamb1/flexscale-node.img ./startNetconfAgent.sh
sleep 2

echo "Creating RDMparis..."
docker run --net=netbrTFS --ip=10.100.201.2 --name RDMparis -v "/home/asm/tfs_emus/roadm.xml:/confd/examples.confd/OC23/init_openconfig-platform.xml" -dt asgamb1/flexscale-node.img ./startNetconfAgent.sh
sleep 2

echo "Creating RDMfrankfurt..."
docker run --net=netbrTFS --ip=10.100.201.3 --name RDMfrankfurt -v "/home/asm/tfs_emus/roadm.xml:/confd/examples.confd/OC23/init_openconfig-platform.xml" -dt asgamb1/flexscale-node.img ./startNetconfAgent.sh
sleep 2

echo "Creating RDMamsterdam..."
docker run --net=netbrTFS --ip=10.100.201.4 --name RDMamsterdam -v "/home/asm/tfs_emus/roadm.xml:/confd/examples.confd/OC23/init_openconfig-platform.xml" -dt asgamb1/flexscale-node.img ./startNetconfAgent.sh
sleep 2

echo "Creating RDMmadrid..."
docker run --net=netbrTFS --ip=10.100.201.5 --name RDMmadrid -v "/home/asm/tfs_emus/roadm.xml:/confd/examples.confd/OC23/init_openconfig-platform.xml" -dt asgamb1/flexscale-node.img ./startNetconfAgent.sh
sleep 2

echo "Creating RDMrome..."
docker run --net=netbrTFS --ip=10.100.201.6 --name RDMrome -v "/home/asm/tfs_emus/roadm.xml:/confd/examples.confd/OC23/init_openconfig-platform.xml" -dt asgamb1/flexscale-node.img ./startNetconfAgent.sh
sleep 2

echo "Creating RDMberlin..."
docker run --net=netbrTFS --ip=10.100.201.7 --name RDMberlin -v "/home/asm/tfs_emus/roadm.xml:/confd/examples.confd/OC23/init_openconfig-platform.xml" -dt asgamb1/flexscale-node.img ./startNetconfAgent.sh
sleep 2

echo "Creating RDMwarsaw..."
docker run --net=netbrTFS --ip=10.100.201.8 --name RDMwarsaw -v "/home/asm/tfs_emus/roadm.xml:/confd/examples.confd/OC23/init_openconfig-platform.xml" -dt asgamb1/flexscale-node.img ./startNetconfAgent.sh
sleep 2

echo "Creating RDMstockholm..."
docker run --net=netbrTFS --ip=10.100.201.9 --name RDMstockholm -v "/home/asm/tfs_emus/roadm.xml:/confd/examples.confd/OC23/init_openconfig-platform.xml" -dt asgamb1/flexscale-node.img ./startNetconfAgent.sh
sleep 2

echo "Creating RDMathens..."
docker run --net=netbrTFS --ip=10.100.201.10 --name RDMathens -v "/home/asm/tfs_emus/roadm.xml:/confd/examples.confd/OC23/init_openconfig-platform.xml" -dt asgamb1/flexscale-node.img ./startNetconfAgent.sh
sleep 2

echo "Creating RDMvienna..."
docker run --net=netbrTFS --ip=10.100.201.11 --name RDMvienna -v "/home/asm/tfs_emus/roadm.xml:/confd/examples.confd/OC23/init_openconfig-platform.xml" -dt asgamb1/flexscale-node.img ./startNetconfAgent.sh
sleep 2

echo "Creating RDMprague..."
docker run --net=netbrTFS --ip=10.100.201.12 --name RDMprague -v "/home/asm/tfs_emus/roadm.xml:/confd/examples.confd/OC23/init_openconfig-platform.xml" -dt asgamb1/flexscale-node.img ./startNetconfAgent.sh
sleep 2

echo "Creating RDMbrussels..."
docker run --net=netbrTFS --ip=10.100.201.13 --name RDMbrussels -v "/home/asm/tfs_emus/roadm.xml:/confd/examples.confd/OC23/init_openconfig-platform.xml" -dt asgamb1/flexscale-node.img ./startNetconfAgent.sh
sleep 2

echo "Creating RDMmilan..."
docker run --net=netbrTFS --ip=10.100.201.14 --name RDMmilan -v "/home/asm/tfs_emus/roadm.xml:/confd/examples.confd/OC23/init_openconfig-platform.xml" -dt asgamb1/flexscale-node.img ./startNetconfAgent.sh
sleep 2

echo "Creating RDMzurich..."
docker run --net=netbrTFS --ip=10.100.201.15 --name RDMzurich -v "/home/asm/tfs_emus/roadm.xml:/confd/examples.confd/OC23/init_openconfig-platform.xml" -dt asgamb1/flexscale-node.img ./startNetconfAgent.sh
sleep 2

echo "Creating RDMdublin..."
docker run --net=netbrTFS --ip=10.100.201.16 --name RDMdublin -v "/home/asm/tfs_emus/roadm.xml:/confd/examples.confd/OC23/init_openconfig-platform.xml" -dt asgamb1/flexscale-node.img ./startNetconfAgent.sh
sleep 2

echo "Creating RDMglasgow..."
docker run --net=netbrTFS --ip=10.100.201.17 --name RDMglasgow -v "/home/asm/tfs_emus/roadm.xml:/confd/examples.confd/OC23/init_openconfig-platform.xml" -dt asgamb1/flexscale-node.img ./startNetconfAgent.sh
sleep 2

echo "Creating RDMcopenhagen..."
docker run --net=netbrTFS --ip=10.100.201.18 --name RDMcopenhagen -v "/home/asm/tfs_emus/roadm.xml:/confd/examples.confd/OC23/init_openconfig-platform.xml" -dt asgamb1/flexscale-node.img ./startNetconfAgent.sh
sleep 2

echo "Creating RDMhamburg..."
docker run --net=netbrTFS --ip=10.100.201.19 --name RDMhamburg -v "/home/asm/tfs_emus/roadm.xml:/confd/examples.confd/OC23/init_openconfig-platform.xml" -dt asgamb1/flexscale-node.img ./startNetconfAgent.sh
sleep 2

echo "Creating RDMmunich..."
docker run --net=netbrTFS --ip=10.100.201.20 --name RDMmunich -v "/home/asm/tfs_emus/roadm.xml:/confd/examples.confd/OC23/init_openconfig-platform.xml" -dt asgamb1/flexscale-node.img ./startNetconfAgent.sh
sleep 2

echo "Creating RDMbudapest..."
docker run --net=netbrTFS --ip=10.100.201.21 --name RDMbudapest -v "/home/asm/tfs_emus/roadm.xml:/confd/examples.confd/OC23/init_openconfig-platform.xml" -dt asgamb1/flexscale-node.img ./startNetconfAgent.sh
sleep 2

echo "Creating RDMbelgrade..."
docker run --net=netbrTFS --ip=10.100.201.22 --name RDMbelgrade -v "/home/asm/tfs_emus/roadm.xml:/confd/examples.confd/OC23/init_openconfig-platform.xml" -dt asgamb1/flexscale-node.img ./startNetconfAgent.sh
sleep 2

echo "Creating RDMbarcelona..."
docker run --net=netbrTFS --ip=10.100.201.23 --name RDMbarcelona -v "/home/asm/tfs_emus/roadm.xml:/confd/examples.confd/OC23/init_openconfig-platform.xml" -dt asgamb1/flexscale-node.img ./startNetconfAgent.sh
sleep 2

echo "Creating RDMlyon..."
docker run --net=netbrTFS --ip=10.100.201.24 --name RDMlyon -v "/home/asm/tfs_emus/roadm.xml:/confd/examples.confd/OC23/init_openconfig-platform.xml" -dt asgamb1/flexscale-node.img ./startNetconfAgent.sh
sleep 2

echo "Creating RDMbordeaux..."
docker run --net=netbrTFS --ip=10.100.201.25 --name RDMbordeaux -v "/home/asm/tfs_emus/roadm.xml:/confd/examples.confd/OC23/init_openconfig-platform.xml" -dt asgamb1/flexscale-node.img ./startNetconfAgent.sh
sleep 2

echo "Creating RDMstrasbourg..."
docker run --net=netbrTFS --ip=10.100.201.26 --name RDMstrasbourg -v "/home/asm/tfs_emus/roadm.xml:/confd/examples.confd/OC23/init_openconfig-platform.xml" -dt asgamb1/flexscale-node.img ./startNetconfAgent.sh
sleep 2

echo "Creating RDMoslo..."
docker run --net=netbrTFS --ip=10.100.201.27 --name RDMoslo -v "/home/asm/tfs_emus/roadm.xml:/confd/examples.confd/OC23/init_openconfig-platform.xml" -dt asgamb1/flexscale-node.img ./startNetconfAgent.sh
sleep 2

echo "Creating RDMcalifornia..."
docker run --net=netbrTFS --ip=10.100.201.28 --name RDMcalifornia -v "/home/asm/tfs_emus/roadm.xml:/confd/examples.confd/OC23/init_openconfig-platform.xml" -dt asgamb1/flexscale-node.img ./startNetconfAgent.sh
sleep 2

echo "Creating RDMtexas..."
docker run --net=netbrTFS --ip=10.100.201.29 --name RDMtexas -v "/home/asm/tfs_emus/roadm.xml:/confd/examples.confd/OC23/init_openconfig-platform.xml" -dt asgamb1/flexscale-node.img ./startNetconfAgent.sh
sleep 2

echo "Creating RDMnewyork..."
docker run --net=netbrTFS --ip=10.100.201.30 --name RDMnewyork -v "/home/asm/tfs_emus/roadm.xml:/confd/examples.confd/OC23/init_openconfig-platform.xml" -dt asgamb1/flexscale-node.img ./startNetconfAgent.sh
sleep 2

echo "Creating RDMflorida..."
docker run --net=netbrTFS --ip=10.100.201.31 --name RDMflorida -v "/home/asm/tfs_emus/roadm.xml:/confd/examples.confd/OC23/init_openconfig-platform.xml" -dt asgamb1/flexscale-node.img ./startNetconfAgent.sh
sleep 2

echo "Creating RDMillinois..."
docker run --net=netbrTFS --ip=10.100.201.32 --name RDMillinois -v "/home/asm/tfs_emus/roadm.xml:/confd/examples.confd/OC23/init_openconfig-platform.xml" -dt asgamb1/flexscale-node.img ./startNetconfAgent.sh
sleep 2

echo "Creating RDMpennsylvania..."
docker run --net=netbrTFS --ip=10.100.201.33 --name RDMpennsylvania -v "/home/asm/tfs_emus/roadm.xml:/confd/examples.confd/OC23/init_openconfig-platform.xml" -dt asgamb1/flexscale-node.img ./startNetconfAgent.sh
sleep 2

echo "Creating RDMohio..."
docker run --net=netbrTFS --ip=10.100.201.34 --name RDMohio -v "/home/asm/tfs_emus/roadm.xml:/confd/examples.confd/OC23/init_openconfig-platform.xml" -dt asgamb1/flexscale-node.img ./startNetconfAgent.sh
sleep 2

echo "Creating RDMgeorgia..."
docker run --net=netbrTFS --ip=10.100.201.35 --name RDMgeorgia -v "/home/asm/tfs_emus/roadm.xml:/confd/examples.confd/OC23/init_openconfig-platform.xml" -dt asgamb1/flexscale-node.img ./startNetconfAgent.sh
sleep 2

echo "Creating RDMmichigan..."
docker run --net=netbrTFS --ip=10.100.201.36 --name RDMmichigan -v "/home/asm/tfs_emus/roadm.xml:/confd/examples.confd/OC23/init_openconfig-platform.xml" -dt asgamb1/flexscale-node.img ./startNetconfAgent.sh
sleep 2

echo "Creating RDMwashington..."
docker run --net=netbrTFS --ip=10.100.201.37 --name RDMwashington -v "/home/asm/tfs_emus/roadm.xml:/confd/examples.confd/OC23/init_openconfig-platform.xml" -dt asgamb1/flexscale-node.img ./startNetconfAgent.sh
sleep 2

echo "Creating RDMvirginia..."
docker run --net=netbrTFS --ip=10.100.201.38 --name RDMvirginia -v "/home/asm/tfs_emus/roadm.xml:/confd/examples.confd/OC23/init_openconfig-platform.xml" -dt asgamb1/flexscale-node.img ./startNetconfAgent.sh
sleep 2

echo "Creating RDMarizona..."
docker run --net=netbrTFS --ip=10.100.201.39 --name RDMarizona -v "/home/asm/tfs_emus/roadm.xml:/confd/examples.confd/OC23/init_openconfig-platform.xml" -dt asgamb1/flexscale-node.img ./startNetconfAgent.sh
sleep 2

echo "Creating RDMmassachusetts..."
docker run --net=netbrTFS --ip=10.100.201.40 --name RDMmassachusetts -v "/home/asm/tfs_emus/roadm.xml:/confd/examples.confd/OC23/init_openconfig-platform.xml" -dt asgamb1/flexscale-node.img ./startNetconfAgent.sh
sleep 2

echo "Creating RDMtennessee..."
docker run --net=netbrTFS --ip=10.100.201.41 --name RDMtennessee -v "/home/asm/tfs_emus/roadm.xml:/confd/examples.confd/OC23/init_openconfig-platform.xml" -dt asgamb1/flexscale-node.img ./startNetconfAgent.sh
sleep 2

echo "Creating RDMindiana..."
docker run --net=netbrTFS --ip=10.100.201.42 --name RDMindiana -v "/home/asm/tfs_emus/roadm.xml:/confd/examples.confd/OC23/init_openconfig-platform.xml" -dt asgamb1/flexscale-node.img ./startNetconfAgent.sh
sleep 2

echo "Creating RDMmissouri..."
docker run --net=netbrTFS --ip=10.100.201.43 --name RDMmissouri -v "/home/asm/tfs_emus/roadm.xml:/confd/examples.confd/OC23/init_openconfig-platform.xml" -dt asgamb1/flexscale-node.img ./startNetconfAgent.sh
sleep 2

echo "Creating RDMmaryland..."
docker run --net=netbrTFS --ip=10.100.201.44 --name RDMmaryland -v "/home/asm/tfs_emus/roadm.xml:/confd/examples.confd/OC23/init_openconfig-platform.xml" -dt asgamb1/flexscale-node.img ./startNetconfAgent.sh
sleep 2

echo "Creating RDMcolorado..."
docker run --net=netbrTFS --ip=10.100.201.45 --name RDMcolorado -v "/home/asm/tfs_emus/roadm.xml:/confd/examples.confd/OC23/init_openconfig-platform.xml" -dt asgamb1/flexscale-node.img ./startNetconfAgent.sh
sleep 2

echo ""
echo "Waiting for all RDM NETCONF agents to be ready..."
for ip in 10.100.201.{1..45}; do
  while ! nc -z -w 2 "$ip" 2022 2>/dev/null; do
    echo "  Waiting for $ip:2022..."
    sleep 2
  done
  echo "  $ip:2022 is ready"
done
echo ""
echo "All 45 RDMs are ready."
