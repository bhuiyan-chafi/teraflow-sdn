# How this virtual NIC works under the hood?

This is pretty obvious basic, mostly you might know all of these! But just in case if you need a reminder. I certainly do! Lol. 

## From the host machine

When we open the `virtualbox` and then create a VM, we use NAT or NAT NETWORK(looks similar but slightly different) to communicate from the VM to the host. Now the network is one way (VM->Host), any packet leaves from the VM is passed to the host and then to the internet. But? What happens when we need a reverse connection(for example you want to setup an ssh server in your vm and access it from host)?

**If we check the IPs of the Host machine:**

```shell
ip addr show
```

We will **not** see any IP address that is similar to the VM IP(typically it takes 10.0.2.X/24 series). But how from VM to Host it works?

## From the VM

If we check the ip route of the VM:

```shell
route -n
```

We will see default gateway pointed to the host machine(0.0.0.0). So, any packet that doesn't match internal network is forwarded to the default gateway(0.0.0.0) and it flow from there. If the desired destination is connected to your host, it is likely to reach there.

If we check the network IP, we will find an IP 10.0.2.X associated to the NIC enp0s3 typically. Also checking the ARP will show address resoluted for the HOST:

```shell
arp -n
```

you will find the IP of your virtual NICs address. So, you can access the host from the VM. But how from HOST to VM?

## From HOST

Check the ARP resolution after pining of-course:

```shell
arp -n
```

No address resolution for VM(no address found for the VM). But which IP shall we ping to the VM, that is the biggest question. By default VM is given an IP either by DHCP or manual configuration which is connected to the NAT. If we ping to that same IP it is not gonna work because we cannot reconfigure it. Even if we do we will loose the default connectivity to the host.

And in that case we create a virtual NIC for host-only connection that is going to handle the connection between host -> VM.

## From the VM(2)

So, the typical solution is to configure the second NIC that we created via vboxnetX from the host and assigned to our VM to a different subnet. But remember the new NIC must be the same subnet of the vboxnetX. Only then we have a network between the host <-> vm.
