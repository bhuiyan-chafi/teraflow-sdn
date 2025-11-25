# How to turn my currenct machine into a SSH server?

 Well, it's pretty obvious for linux machine. Most of the times the setup is already done except few specific things. But let's say we didn't get the default installation! So, we are going to set it up on our own.

## Installing openSSH

Use this file [install_openSSH.sh](./install_openSSH.sh) to install and verify the extension you need to setup the openSSH server. Run the following command from the selected directory where your file is:

```shell
chodmod +x install_openSSH.sh
./install_openSSH.sh
```

## Creating the key from `client` machine

Before executing the following command please find out your username and machine's IP from the server.

```shell
ssh-keygen -t ed25519 -C "mac->ubuntu"
# press Enter to accept defaults (add a passphrase if you want)

# auto copying the key only works if you are in the same network.
ssh-copy-id -i ~/.ssh/id_ed25519.pub youruser@UBUNTU_IP
```

If you want to verify that the key has been successfully imported:

```shell
cat ~/.ssh/authorized_keys #on your server
```

Must show your key.

## Enabling ssh login

Execute the following commands in order:

```shell
sudo gedit /etc/ssh/sshd_config
````

Copy the following parameters:

```text
Port 22
PubkeyAuthentication yes
PasswordAuthentication no
PermitRootLogin no
```

Restart the service:

```shell
sudo systemctl restart ssh
```

## White-listing the openSSH connection on firewall

```shell
sudo ufw allow OpenSSH
sudo ufw enable           # if not already enabled
sudo ufw status verbose
```

## Connecting to the Server

First we need to enable the ssh agent and add our key there:

```shell
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/the_key #but the private one
ssh-add -l
```

Now you are set to login:

```shell
ssh youruser@UBUNTU_IP
```

Provide necessary credentials and login.
