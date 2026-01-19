# The final part of the Thesis

We are going to integrate our ***RSA*** project in TeraFlowSDN. For that I have removed the repository from github and moved it to [***GitLAB***](https://gitlab.com/thesis-group1/teraflow.git). I am a free user, so the repository is private. If you need access please send me an [email](mailto:a.bhuiyan@studenti.unipi.it).

## Enhancement of Device Configuration

We want to store some additional information from the device to perform device based filtration. Currently we don't have any information related to manufacturer. So, we will add these columns [***vendor, model***] in the database table [***device***]. Device [***name, type, and driver***] is already present in the database.

### Steps

1. Creating the Docker Network  ***UniPi Server: Monster***

    ```bash
    sudo docker network create --driver=bridge --ip-range=10.100.0.0/16 --subnet=10.100.0.0/16 -o "com.docker.network.bridge.name=brTFS" netbrTFS
    ```

2. Add route in ***UniPi Server: Mascara***

    ```bash
    sudo ip route add 10.100.0.0/16 via 131.114.54.73
    route -n
    ```

3. Add route in ***UniPi Server: Monster***

    ```bash
    sudo iptables -I DOCKER-USER -s 131.114.54.72 -d 10.100.0.0/16 -j ACCEPT
    sudo iptables --list
    ```

4. Try to ping the *Emulated Device* from ***UniPi Server: Mascara***

    ```bash
    ping 10.100.101.1
    ```

5. Use Professor Andrea's OpenConfig example XML [configuration-file](./transponders_x4.xml).

6. Creating our emulated device *Optical Transponder* in [***UniPi Server: monster***] using this [script](../2025-11/TP.A.101.1.sh).

7. Use the teraflow [descriptor](../2025-11/1_TP.json) to add the device to the controller.

8. The discovery of ***Device Name***

    >Filename: OCDriver.py [teraflow-develop/src/device/service/drivers/oc_driver/OCDriver.py]

    Right now the ***Device Name*** is selected from the ***JSON*** descriptor. It doesn't read from the ***xml*** configuration file.
