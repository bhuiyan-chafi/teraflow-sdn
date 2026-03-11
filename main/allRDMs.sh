#!/bin/bash

# ============================================================
# allRDMs.sh — Start all 40 ROADM containers
# Naming: RDM1–RDM40
# IPs:    10.100.201.1–10.100.201.40
# ============================================================

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

echo "Creating RDM11..."
docker run --net=netbrTFS --ip=10.100.201.11 --name RDM11 -v "/home/asm/tfs_emus/roadm.xml:/confd/examples.confd/OC23/init_openconfig-platform.xml" -dt asgamb1/flexscale-node.img ./startNetconfAgent.sh
sleep 2

echo "Creating RDM12..."
docker run --net=netbrTFS --ip=10.100.201.12 --name RDM12 -v "/home/asm/tfs_emus/roadm.xml:/confd/examples.confd/OC23/init_openconfig-platform.xml" -dt asgamb1/flexscale-node.img ./startNetconfAgent.sh
sleep 2

echo "Creating RDM13..."
docker run --net=netbrTFS --ip=10.100.201.13 --name RDM13 -v "/home/asm/tfs_emus/roadm.xml:/confd/examples.confd/OC23/init_openconfig-platform.xml" -dt asgamb1/flexscale-node.img ./startNetconfAgent.sh
sleep 2

echo "Creating RDM14..."
docker run --net=netbrTFS --ip=10.100.201.14 --name RDM14 -v "/home/asm/tfs_emus/roadm.xml:/confd/examples.confd/OC23/init_openconfig-platform.xml" -dt asgamb1/flexscale-node.img ./startNetconfAgent.sh
sleep 2

echo "Creating RDM15..."
docker run --net=netbrTFS --ip=10.100.201.15 --name RDM15 -v "/home/asm/tfs_emus/roadm.xml:/confd/examples.confd/OC23/init_openconfig-platform.xml" -dt asgamb1/flexscale-node.img ./startNetconfAgent.sh
sleep 2

echo "Creating RDM16..."
docker run --net=netbrTFS --ip=10.100.201.16 --name RDM16 -v "/home/asm/tfs_emus/roadm.xml:/confd/examples.confd/OC23/init_openconfig-platform.xml" -dt asgamb1/flexscale-node.img ./startNetconfAgent.sh
sleep 2

echo "Creating RDM17..."
docker run --net=netbrTFS --ip=10.100.201.17 --name RDM17 -v "/home/asm/tfs_emus/roadm.xml:/confd/examples.confd/OC23/init_openconfig-platform.xml" -dt asgamb1/flexscale-node.img ./startNetconfAgent.sh
sleep 2

echo "Creating RDM18..."
docker run --net=netbrTFS --ip=10.100.201.18 --name RDM18 -v "/home/asm/tfs_emus/roadm.xml:/confd/examples.confd/OC23/init_openconfig-platform.xml" -dt asgamb1/flexscale-node.img ./startNetconfAgent.sh
sleep 2

echo "Creating RDM19..."
docker run --net=netbrTFS --ip=10.100.201.19 --name RDM19 -v "/home/asm/tfs_emus/roadm.xml:/confd/examples.confd/OC23/init_openconfig-platform.xml" -dt asgamb1/flexscale-node.img ./startNetconfAgent.sh
sleep 2

echo "Creating RDM20..."
docker run --net=netbrTFS --ip=10.100.201.20 --name RDM20 -v "/home/asm/tfs_emus/roadm.xml:/confd/examples.confd/OC23/init_openconfig-platform.xml" -dt asgamb1/flexscale-node.img ./startNetconfAgent.sh
sleep 2

echo "Creating RDM21..."
docker run --net=netbrTFS --ip=10.100.201.21 --name RDM21 -v "/home/asm/tfs_emus/roadm.xml:/confd/examples.confd/OC23/init_openconfig-platform.xml" -dt asgamb1/flexscale-node.img ./startNetconfAgent.sh
sleep 2

echo "Creating RDM22..."
docker run --net=netbrTFS --ip=10.100.201.22 --name RDM22 -v "/home/asm/tfs_emus/roadm.xml:/confd/examples.confd/OC23/init_openconfig-platform.xml" -dt asgamb1/flexscale-node.img ./startNetconfAgent.sh
sleep 2

echo "Creating RDM23..."
docker run --net=netbrTFS --ip=10.100.201.23 --name RDM23 -v "/home/asm/tfs_emus/roadm.xml:/confd/examples.confd/OC23/init_openconfig-platform.xml" -dt asgamb1/flexscale-node.img ./startNetconfAgent.sh
sleep 2

echo "Creating RDM24..."
docker run --net=netbrTFS --ip=10.100.201.24 --name RDM24 -v "/home/asm/tfs_emus/roadm.xml:/confd/examples.confd/OC23/init_openconfig-platform.xml" -dt asgamb1/flexscale-node.img ./startNetconfAgent.sh
sleep 2

echo "Creating RDM25..."
docker run --net=netbrTFS --ip=10.100.201.25 --name RDM25 -v "/home/asm/tfs_emus/roadm.xml:/confd/examples.confd/OC23/init_openconfig-platform.xml" -dt asgamb1/flexscale-node.img ./startNetconfAgent.sh
sleep 2

echo "Creating RDM26..."
docker run --net=netbrTFS --ip=10.100.201.26 --name RDM26 -v "/home/asm/tfs_emus/roadm.xml:/confd/examples.confd/OC23/init_openconfig-platform.xml" -dt asgamb1/flexscale-node.img ./startNetconfAgent.sh
sleep 2

echo "Creating RDM27..."
docker run --net=netbrTFS --ip=10.100.201.27 --name RDM27 -v "/home/asm/tfs_emus/roadm.xml:/confd/examples.confd/OC23/init_openconfig-platform.xml" -dt asgamb1/flexscale-node.img ./startNetconfAgent.sh
sleep 2

echo "Creating RDM28..."
docker run --net=netbrTFS --ip=10.100.201.28 --name RDM28 -v "/home/asm/tfs_emus/roadm.xml:/confd/examples.confd/OC23/init_openconfig-platform.xml" -dt asgamb1/flexscale-node.img ./startNetconfAgent.sh
sleep 2

echo "Creating RDM29..."
docker run --net=netbrTFS --ip=10.100.201.29 --name RDM29 -v "/home/asm/tfs_emus/roadm.xml:/confd/examples.confd/OC23/init_openconfig-platform.xml" -dt asgamb1/flexscale-node.img ./startNetconfAgent.sh
sleep 2

echo "Creating RDM30..."
docker run --net=netbrTFS --ip=10.100.201.30 --name RDM30 -v "/home/asm/tfs_emus/roadm.xml:/confd/examples.confd/OC23/init_openconfig-platform.xml" -dt asgamb1/flexscale-node.img ./startNetconfAgent.sh
sleep 2

echo "Creating RDM31..."
docker run --net=netbrTFS --ip=10.100.201.31 --name RDM31 -v "/home/asm/tfs_emus/roadm.xml:/confd/examples.confd/OC23/init_openconfig-platform.xml" -dt asgamb1/flexscale-node.img ./startNetconfAgent.sh
sleep 2

echo "Creating RDM32..."
docker run --net=netbrTFS --ip=10.100.201.32 --name RDM32 -v "/home/asm/tfs_emus/roadm.xml:/confd/examples.confd/OC23/init_openconfig-platform.xml" -dt asgamb1/flexscale-node.img ./startNetconfAgent.sh
sleep 2

echo "Creating RDM33..."
docker run --net=netbrTFS --ip=10.100.201.33 --name RDM33 -v "/home/asm/tfs_emus/roadm.xml:/confd/examples.confd/OC23/init_openconfig-platform.xml" -dt asgamb1/flexscale-node.img ./startNetconfAgent.sh
sleep 2

echo "Creating RDM34..."
docker run --net=netbrTFS --ip=10.100.201.34 --name RDM34 -v "/home/asm/tfs_emus/roadm.xml:/confd/examples.confd/OC23/init_openconfig-platform.xml" -dt asgamb1/flexscale-node.img ./startNetconfAgent.sh
sleep 2

echo "Creating RDM35..."
docker run --net=netbrTFS --ip=10.100.201.35 --name RDM35 -v "/home/asm/tfs_emus/roadm.xml:/confd/examples.confd/OC23/init_openconfig-platform.xml" -dt asgamb1/flexscale-node.img ./startNetconfAgent.sh
sleep 2

echo "Creating RDM36..."
docker run --net=netbrTFS --ip=10.100.201.36 --name RDM36 -v "/home/asm/tfs_emus/roadm.xml:/confd/examples.confd/OC23/init_openconfig-platform.xml" -dt asgamb1/flexscale-node.img ./startNetconfAgent.sh
sleep 2

echo "Creating RDM37..."
docker run --net=netbrTFS --ip=10.100.201.37 --name RDM37 -v "/home/asm/tfs_emus/roadm.xml:/confd/examples.confd/OC23/init_openconfig-platform.xml" -dt asgamb1/flexscale-node.img ./startNetconfAgent.sh
sleep 2

echo "Creating RDM38..."
docker run --net=netbrTFS --ip=10.100.201.38 --name RDM38 -v "/home/asm/tfs_emus/roadm.xml:/confd/examples.confd/OC23/init_openconfig-platform.xml" -dt asgamb1/flexscale-node.img ./startNetconfAgent.sh
sleep 2

echo "Creating RDM39..."
docker run --net=netbrTFS --ip=10.100.201.39 --name RDM39 -v "/home/asm/tfs_emus/roadm.xml:/confd/examples.confd/OC23/init_openconfig-platform.xml" -dt asgamb1/flexscale-node.img ./startNetconfAgent.sh
sleep 2

echo "Creating RDM40..."
docker run --net=netbrTFS --ip=10.100.201.40 --name RDM40 -v "/home/asm/tfs_emus/roadm.xml:/confd/examples.confd/OC23/init_openconfig-platform.xml" -dt asgamb1/flexscale-node.img ./startNetconfAgent.sh
sleep 2

echo ""
echo "Waiting for all RDM NETCONF agents to be ready..."
for ip in 10.100.201.{1..40}; do
  while ! nc -z -w 2 "$ip" 2022 2>/dev/null; do
    echo "  Waiting for $ip:2022..."
    sleep 2
  done
  echo "  $ip:2022 is ready"
done
echo ""
echo "All 40 RDMs are ready."
