#!/bin/sh
curl --user karaf:karaf -X POST 'http://172.17.0.2:8181/onos/v1/applications/org.onosproject.openflow/active'
sleep 5
echo

curl --user karaf:karaf -X POST 'http://172.17.0.2:8181/onos/v1/applications/org.onosproject.proxyarp/active'
sleep 5
echo

curl --user karaf:karaf -X POST 'http://172.17.0.2:8181/onos/v1/applications/org.onosproject.fwd/active'
echo
