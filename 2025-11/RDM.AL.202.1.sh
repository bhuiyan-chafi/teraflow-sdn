#!/bin/bash

#Remove previous topology
sudo docker stop RDM.AL.202.1 
sudo docker rm RDM.AL.202.1 

echo "Creating ROADMs..."
echo "--- ROADM-1 screen r1 IP 10.100.202.1"
sudo screen -dmS r1 -T xterm sh -c 'docker run --net=netbrTFS --ip=10.100.202.1 --name RDM.AL.202.1 -it ornotifelement.img:latest bash'
sleep 2

echo "Uploading xml schema ../onos-xml/nodeTIM.xml"
sudo docker cp ./nodeTIM.xml RDM.AL.202.1:/confd/examples.confd/OpenROADMNotifElement/
sleep 2

echo "Uploading Makefile"
sudo docker cp ./Makefile-nodeTIM RDM.AL.202.1:/confd/examples.confd/OpenROADMNotifElement/Makefile
sleep 2

echo "Starting the Netconf agents"
sudo screen -S r1 -X stuff './startNetconfAgent.sh\n'
