#!/bin/bash

# 1. Flush the 'raw' table which blocks external access to internal container IPs
# This is the "Martian packet" filter that Docker re-inserts.
sudo iptables -t raw -F PREROUTING

# 2. Ensure the DOCKER-USER chain allows Mascara specifically
# DOCKER-USER is the only chain Docker won't overwrite on restart.
sudo iptables -I DOCKER-USER -s 131.114.54.72 -d 10.100.0.0/16 -j ACCEPT

# 3. Force the kernel to allow forwarding to your specific bridge
# Even if the GUI or other services try to disable it.
sudo sysctl -w net.ipv4.ip_forward=1
sudo iptables -I FORWARD -o brTFS -j ACCEPT
sudo iptables -I FORWARD -i brTFS -j ACCEPT

echo "Network fixes applied for Mascara -> Monster (10.100.x.x)"