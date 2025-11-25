# How can we access an application running inside 2 layer deep?

In this tutorial we will learn how we can access `ONOS` controller that is running inside a `VM` inside our linux machine. So the controller is 2 layer deep: `MAC`<->`Linux Machine`<->`VM`(also running another linux: prof. alessio's configured linux for ONOS).

Now! We will run onos isnide the VM's linux that will be accessed by our linux machine and then from our MAC. So, let's start!

## Run the docker with port binding

From your **VM**:

```shell
docker run -d --name onos -p 8181:8181 onosproject/onos
```

The commands can be found in this folder so check them out.[start](./create.sh)
This command should run the **ONOS** controller with this specific port. Now **you have access from your host linux to the VM's linux**(host-only network coinfiguration should already be configured). From your host linux browser try this url:

From your **host linux**:

```shell
http://10.0.4.10:8181/onos/ui/login.html
```

You must be able to login. Sometimes it fails because it takes time to be initailized. If you fail once, try again. If still not accessible, make sure you can ping your VM from your linux host.

## Connect to your host linux from mac with proper port access

From your mac or any other device, mention the proper access while connecting through **SSH**.

```shell
ssh -L 8181:10.0.4.10:8181 user@<host-linux-ip>
```

**Now from the MAC/Other machine's browser:**

```shell
http://localhost:8181/onos/ui/login.html
```

It should work!
