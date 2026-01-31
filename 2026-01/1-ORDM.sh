#!/bin/bash

#Remove previous topology
echo "Removing running agents"
docker stop ORDM1
docker rm ORDM1

echo "Creating ROADM"
screen -dmS r21 -T xterm sh -c 'docker run --net=netbrTFS --ip=10.100.201.1 --name ORDM1 -it ornotifelement.img:latest bash'
sleep 2
echo "Uploading xml schema ./nodeTIM.xml"
docker cp ./nodeTIM.xml ORDM1:/confd/examples.confd/OpenROADMNotifElement/
sleep 1
echo "Uploading Makefile"
docker cp ./Makefile-nodeTIM ORDM1:/confd/examples.confd/OpenROADMNotifElement/Makefile
sleep 1
echo "Starting the Netconf agents"
screen -S r21 -X stuff './startNetconfAgent.sh\n'
sleep 1

echo "Done!"