# Installation

I tried installing VM, UbuntuServer 22.04 in my ubuntu laptop. It worked perfectly, and also created a ssh connection so that it can be accessed from the same LAN. See this directory for details of [how to create a ssh server for the vm](../additional-nic/). But before that you must ensure you have openSSH installed in your VM OS. If not you can follow this [process](../ssh-server/).

## Installation in University Server

- there was no option to create another virtual network interface so I skipped the `enp0s3` configuration part. My plan is to configure it later using `netplan` (if you are using a VM inside).
- after the installation, we installed ubuntu-desktop gui for easier management(our university is using WPA enterprise).

```bash
sudo apt install ubuntu-desktop-minimal -y
```

Install all necessary updates that are requested and restart. Now we have to configure one more thing to be able to manage NICs using our GUI. Typically in server images the networking functions are managed by `netplan and networkd`. Since we have transferred the control to `NetworkManager` we have to change the `renderer` as well. We had to do this because our university maintains WPA enterprise solutions. I tried creating `wpa_supplicant` scripts to push the network credentials but it kept rejecting. So, I didn't want to make it complicated and simply installed web-ui. That let us use `NetworkManager`, and we configured it like following:

```bash
sudo nano /etc/cloud/cloud.cfg.d/99-disable-network-config.cfg

#put the following value
network: {config: disabled}
#save and exit

sudo rm -f /etc/netplan/50-cloud-init.yaml
sudo netplan generate

sudo nano /etc/netplan/01-netcfg.yaml

#put the values
network:
  version: 2
  renderer: NetworkManager
#save and exit
sudo chmod 600 /etc/netplan/01-netcfg.yaml
sudo chown root:root /etc/netplan/01-netcfg.yaml
sudo netplan apply
```

Now the configuration will be persistent and will survive reboots.

### Disabling `swap` for MicroK8

As per official documentation `Microk8` doesn't work very well with `swap`. So, we are going to turn it off permanently. Swap is by default turned off for `server` installation, but we have installed `gui` extension that's why we have to turn in off. 

```bash
sudo swapoff -a #turns it off temporarily
swapon --show    # should show nothing
free -h          # Swap: 0B

#but this change doesn't survive reboots, so if you want you can permanent solutions. We don't often reboot our production servers so I am skipping the permanent solution. Also because our server is used by different users and they might need swap spaces. 

#for permanent solution
sudo swapoff -a
sudo nano /etc/fstab
#comment the swap.* file 
sudo reboot
```

## Server credential

**You have to contact Professor Alessio Giorgetti, DII for that access.**

## Applicable if you are using a VM inside the Server

Next we are going to configure our `Static Network` for `TeraFlowSDN` internal VMs. Please [follow this link](./network-configuration.md).

## Deploying TeraFlowSDN

Please follow this discussion to learn about [the deployment](deployment.md).
 