# How can we create and additional NIC

Sometimes it becomes crucial to test some network test cases without touching the default network. If your machine doesn't have more than one physical NIC, this solution is for you.

I suggest you read this [document](./readme.md) first before proceeding with the installation.

## Create a virtual NIC (host-only)

You can create it using the following commands manually, but there is also an [auto-script](./vbox-config-auto.sh) to handle that. Manual commands are the following(execute from the host machine):

```shell
echo "* 0.0.0.0/0 ::/0" | sudo tee /etc/vbox/networks.conf
sudo VBoxManage hostonlyif create
sudo VBoxManage hostonlyif ipconfig vboxnet0 --ip 10.0.2.1 --netmask 255.255.255.0
```

Here the `vboxnent0` should be replaces with the one you created.

If you need to remove any of the `host-only-network`:

```shell
sudo VBoxManage hostonlyif remove 'name'
```

## Configuring the network inside VM

Power up the VM and see the network configuration:

```shell
ipp addr show
```

Must come up with an additional `enpXsX` which is not configured with any IP addresses. After that run the following commands:

```shell
sudo ip addr flush dev enp0s8 #it was in my case
sudo ip addr add 10.0.2.10/24 dev enp0s8
sudo ip link set enp0s8 up
echo "nameserver 8.8.8.8\nnameserver 8.8.4.4" | sudo tee /etc/resolv.conf
ping -c 4 8.8.8.8
```

Verify the network:

```shell
ip addr show enp0s8
route -n
```

Check the routes because the gateway should be same otherwise we can't access the VM from the host. After that just try to connect the VM through SSH as you do for all machines.
