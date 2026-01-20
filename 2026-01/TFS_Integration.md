# The final part of the Thesis

We are going to integrate our ***RSA*** project in TeraFlowSDN. For that I have removed the repository from github and moved it to [***GitLAB***](https://gitlab.com/thesis-group1/teraflow.git). I am a free user, so the repository is private. If you need access please send me an [email](mailto:a.bhuiyan@studenti.unipi.it).

## Testbed setup

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

## Enhancement of Device Configuration

We want to store some additional information from the device to perform device based filtration. Currently we don't have any information related to manufacturer. So, we will add some columns  in the database table [***DeviceModel.py : device***]. Device [***name, type, and driver***] is already present in the database.

1. Use the teraflow [descriptor](../2025-11/1_TP.json) to add the device to the controller.

2. The discovery of ***Device Name***

    >Filename: OCDriver.py [teraflow-develop/src/device/service/drivers/oc_driver/OCDriver.py]

    Right now the ***Device Name*** is selected from the ***JSON*** descriptor. It doesn't read from the ***xml*** configuration file.

3. Adding new attributes to ***DeviceModel.py***

    We are adding [ ***mfg_name, model, serial_no, hardware_version, software_version*** ]

    - mfg_name, model, serial_no is mandatory to have a value
    - hardware_version, software_version is nullable

4. Modifying ***OCDriver.py*** to accept new values

    - added new file filters.py along with transponders.py to shift all the filters there
    - the helper function resides in transponders.py and OCDriver as the parent
    - check [Problem-1](./TFS_Integration_problems.md#no-device-info-received-by-the-controller)
5. Generating proto buffers ***context.proto*** and Context Service

    - added protos in context.proto and generated python codes for them using the script given in the directory
    - proto buffers are confirmed in **proto/src/python/context_pb2.py** file
    - added new fields in src/context/service/database/Device.py:device_data, callback
    - src/device/service/OpenConfigServicer.py contains the data we added. Before this, the device details were added from the JSON descriptor. Since we are adding from the device itself we must put this information in the servicer for passing through services.

6. Visualizing the ***changes*** in ***WebUI***

    - /src/webui/service/templates/device/detail.html contains new data fields
    - src/webui/service/device/routes.py, contains the controller

7. Rebuilding the ***Services***

    - rebuild ***CockRoachDB***

        ```bash
        export CRDB_DROP_DATABASE_IF_EXISTS="YES"
        export CRDB_REDEPLOY="YES"
        bash deploy/crdb.sh 
        ```

    - rebuild ***ContextService***

        ```bash
        docker build -t localhost:32000/tfs/context:dev -f src/context/Dockerfile .
        docker push localhost:32000/tfs/context:dev
        kubectl rollout restart deployment/contextservice -n tfs
        ```

    - rebuild ***DeviceService***

        ```bash
        docker build -t localhost:32000/tfs/device:dev -f src/device/Dockerfile .
        docker push localhost:32000/tfs/device:dev
        kubectl rollout restart deployment/deviceservice -n tfs
        ```

    - rebuild ***WebUI***

        ```bash
        docker build -t localhost:32000/tfs/webui:dev -f src/webui/Dockerfile .
        docker push localhost:32000/tfs/webui:dev
        kubectl rollout restart deployment/webuiservice -n tfs
        ```

## Enhancement of Device Endpoints[ports]

Right now TFS ***OCDriver*** is reading ***port-11*** from the ***xml*** components and splitting the integer as name. So finally the output becomes: name: 11, endpoint_type: port-11. Which is a bit confusing, so we will try put it according to the standard.

```xml
<component>
    <name>port-1</name>  ← Component name
    <state>
        <name>port-1</name>  ← State name (endpoint_type)
        <type>typex:PORT</type>  ← Type filter
    </state>
    <subcomponents>...</subcomponents>
    <properties>
        <property>
            <name>onos-index</name>
            <value>1</value>  ← Port index (endpoint name in DB)
        </property>
    </properties>
</component>
```

```python
# Location: line 333-365
# Searches for: components with "port" in name
for component in components:
    name = component.find('.//oc:name').text  # Gets "port-1"
    if "port" in name:
        port_index = name.split("-")[1]  # Extracts "1"
        port = (name, port_index)        # Creates ("port-1", "1")
        ports.append(port)
```

Since we are going to add quite a few attributes, let's go one by one. First we are going to start with the index, name, endpoint_type. Name and endpoint_type is already there so, we will start with index.

1. Adding ***index*** in the  
