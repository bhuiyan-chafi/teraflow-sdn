#!/bin/bash
# ==============================================================================
# Cross-Server Docker Network Setup — Fresh Ubuntu 22.04
# ==============================================================================
# Monster (131.114.54.73) hosts Docker containers on bridge network 10.100.0.0/16
# Mascara (131.114.54.72) needs to reach those containers
# ==============================================================================

# ==============================================================================
# PART 1: RUN ON MONSTER (131.114.54.73)
# ==============================================================================

# --- 1. Switch iptables to legacy mode (Ubuntu 22.04 defaults to nftables) ---
sudo update-alternatives --set iptables /usr/sbin/iptables-legacy
sudo update-alternatives --set ip6tables /usr/sbin/ip6tables-legacy

# --- 2. Enable IP forwarding (persistent across reboots) ---
sudo sysctl -w net.ipv4.ip_forward=1
echo "net.ipv4.ip_forward=1" | sudo tee -a /etc/sysctl.conf
sudo sysctl -p

# --- 3. Create Docker bridge network ---
sudo docker network create \
  --driver=bridge \
  --ip-range=10.100.0.0/16 \
  --subnet=10.100.0.0/16 \
  -o "com.docker.network.bridge.name=brTFS" \
  netbrTFS

# --- 4. Restart Docker (picks up the iptables-legacy switch) ---
sudo systemctl restart docker

# --- 5. Start your topology containers ---
# (run your testTopo script here, e.g. ./topo_3_10_3/testTopo_3_10_3.sh)

# --- 6. Flush Docker's raw PREROUTING DROP rules ---
#    Docker adds per-container DROP rules in the "raw" table that block
#    ALL external access to container IPs. This is the critical fix.
sudo nft flush chain ip raw PREROUTING
sudo iptables -t raw -F PREROUTING

# --- 7. Allow Mascara through DOCKER-USER chain ---
sudo iptables -I DOCKER-USER -s 131.114.54.72 -d 10.100.0.0/16 -j ACCEPT

# --- 8. Allow forwarding between physical NIC and Docker bridge ---
sudo iptables -I FORWARD -i enp1s0f0 -o brTFS -d 10.100.0.0/16 -j ACCEPT
sudo iptables -I FORWARD -i brTFS -o enp1s0f0 -s 10.100.0.0/16 -j ACCEPT

# --- 9. Allow in nftables DOCKER chain (Docker may still use nftables internally) ---
sudo nft insert rule ip filter DOCKER ip saddr 131.114.54.72 oifname "brTFS" accept 2>/dev/null

# --- 10. Allow Mascara through host firewall (iptables) ---
sudo iptables -I DOCKER-USER -s 131.114.54.72 -d 10.100.0.0/16 -j ACCEPT

echo "=== Monster network setup complete ==="

# ==============================================================================
# PART 2: RUN ON MASCARA (131.114.54.72)
# ==============================================================================

# --- 1. Add route to reach Docker containers via Monster ---
# sudo ip route add 10.100.0.0/16 via 131.114.54.73

# --- 2. Verify route ---
# route -n

# --- 3. Test connectivity ---
# ping 10.100.101.1

# ==============================================================================
# QUICK REFERENCE — AFTER DOCKER/CONTAINER RESTART (run on Monster)
# ==============================================================================
# Docker re-adds raw DROP rules every time containers restart.
# Run these 3 commands after every container restart:
#
#   sudo nft flush chain ip raw PREROUTING
#   sudo iptables -t raw -F PREROUTING
#   sudo iptables -I DOCKER-USER -s 131.114.54.72 -d 10.100.0.0/16 -j ACCEPT
#
# ==============================================================================
# TROUBLESHOOTING
# ==============================================================================
# If ping stops working, check for raw DROP rules:
#   sudo nft list table ip raw
#   sudo iptables -t raw -L PREROUTING -n -v
#
# If you see DROP rules for container IPs, flush them:
#   sudo nft flush chain ip raw PREROUTING
#   sudo iptables -t raw -F PREROUTING
# ==============================================================================
