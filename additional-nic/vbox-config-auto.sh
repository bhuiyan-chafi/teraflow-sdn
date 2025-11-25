sudo ip addr flush dev enp0s8 #it was in my case
sudo ip addr add 10.0.2.10/24 dev enp0s8
sudo ip link set enp0s8 up
echo "nameserver 8.8.8.8\nnameserver 8.8.4.4" | sudo tee /etc/resolv.conf
ping -c 4 8.8.8.8