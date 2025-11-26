#!/bin/bash

#Remove previous topology
sudo docker stop TP.AL.102.1 
sudo docker rm TP.AL.102.1 

echo "Creating transponders..."
echo "--- TP.AL.102.1 screen t1 IP 10.100.200.21"
screen -dmS t1 -T xterm sh -c 'docker run --net=netbrOnos --ip=10.100.200.21 --name TP.AL.102.1 -it octmm.img:latest bash'
sleep 2

echo "Uploading xml schema ../onos-xml/configTerminalDeviceCNIT40.xml"
sudo docker cp ./configTerminalDeviceCNIT40.xml TP.AL.102.1:/confd/examples.confd/OpenConfigTelemetry2.0/
sleep 2

echo "Uploading Makefile"
sudo docker cp ./Makefile-TerminalDeviceCNIT40 TP.AL.102.1:/confd/examples.confd/OpenConfigTelemetry2.0/Makefile
sleep 2

echo "Starting the Netconf agents"
sudo screen -S t1 -X stuff './startNetconfAgent.sh\n'

