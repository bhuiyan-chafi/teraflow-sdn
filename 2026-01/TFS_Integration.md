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
    # find the device in Monster
    docker inspect -f '{{.Name}} - {{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $(docker ps -q)
    # ping from Mascara
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

## Enhancement of Device Endpoints aka PORTS

Let's see an example of the current workflow:
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

We want to extract and store additional endpoint information from devices to enable better endpoint identification and filtering. Currently, endpoints lack detailed indexing and transport type classification. We will add `index` and `transport_type` columns to the database table [***EndPointModel.py : endpoint***] and implement model-based filtering for vendor-specific XML parsing.

1. Use the teraflow descriptor to add the device (e.g., transponder) to the controller.

2. **Creating Model-Based Device Filters**

    >Directory: device_filters [teraflow-develop/src/device/service/drivers/oc_driver/device_filters/]

    Created a new package for device-specific filter classes:
    - **DefaultDevice.py**: Fallback filters for unknown devices with generic patterns
    - **MellanoxSwitch.py**: Specific filters for Mellanox transponders (optical channels)
    - ****init**.py**: Package initialization exporting filter classes

3. **Updating filters.py with Model Mapping**

    >Filename: filters.py [teraflow-develop/src/device/service/drivers/oc_driver/filters.py]

    - Added `OC_TRANSPORT_TYPES` namespace for transport type constants
    - Created `MODEL_FILTER_MAP` dictionary mapping model names to filter classes
    - Implemented `get_device_filter(model_name)` function to return appropriate filter instance

4. **Adding New Attributes to EndPointModel.py**

    >Filename: EndPointModel.py [teraflow-develop/src/context/service/database/models/EndPointModel.py]

    We are adding [***index, transport_type***]
    - Both fields are nullable (String type)
    - Updated `dump()` and `dump_name()` methods to include new fields

5. **Modifying transponders.py with Two-Phase Extraction**

    >Filename: transponders.py [teraflow-develop/src/device/service/drivers/oc_driver/transponders.py]

    - Added helper functions: `_find_element()`, `_get_element_text()`, `_build_channel_map()`, `_extract_port_properties()`, `_get_channel_name_from_port()`
    - Rewrote `extract_ports_based_on_type(xml_data, model_name)` to use model-based filters with two-phase processing:
        - Phase 1: Build channel map from optical channels
        - Phase 2: Extract port properties using channel map
    - Updated `transponder_values_extractor(xml_data, model_name)` to accept model_name and return enhanced port data with `index` and `transport_type`

6. **Modifying OCDriver.py to Extract and Pass model_name**

    >Filename: OCDriver.py [teraflow-develop/src/device/service/drivers/oc_driver/OCDriver.py]

    - Modified `GetConfig()` to extract device_info FIRST (before transponder values) to get model_name
    - Passed model_name to `transponder_values_extractor(xml_data, model_name)` for filtered extraction

7. **Updating Tools.py to Populate New Endpoint Fields**

    >Filename: Tools.py [teraflow-develop/src/device/service/drivers/tools/Tools.py]

    - Modified `populate_endpoints()` to extract and populate `device_endpoint.index` and `device_endpoint.transport_type` from resource_value dictionary

8. **Updating Device.py for Database Storage**

    >Filename: Device.py [teraflow-develop/src/context/service/database/Device.py]

    - Added `index` and `transport_type` to `endpoints_data` dictionary
    - Updated upsert statement to include both fields in `on_conflict_do_update`
    - Modified `_Base.py` to update `endpoint_device_uuid_rec_idx` index definition

9. **Generating Proto Buffers from context.proto**

    >Filename: context.proto [teraflow-develop/proto/context.proto]

    - Added `index` (field 7) and `transport_type` (field 8) to `EndPoint` message
    - Added `index` (field 5) and `transport_type` (field 6) to `EndPointName` message
    - Generated Python code using proto compilation script
    - Proto buffers confirmed in **proto/src/python/context_pb2.py** file

10. **Modified detail.html Template**

    >Filename: detail.html [teraflow-develop/src/webui/service/templates/device/detail.html, src/webui/service/device/routes.py]

    - **Added** two new table columns: `Index` and `Transport Type`
    - **Modified** table column order to: `Endpoint UUID`, `Index`, `Transport Type`, `Name`, `Type`
    - **Added** N/A handling for null/empty values: `{{ endpoint.field if endpoint.field else 'N/A' }}`
    - **Removed** `Location` column from the table

11. Rebuilding the ***Services***

    - rebuild the context, device and webui like before.

## Enhancement of the channels

Right now when the configuration is extracted from the `xml` file, the channels and endpoints are separated and stored in different tables. The flow is the following:

- ***optical_channel***: contains the channels associated to each physical endpoints. The channels are typically the transceivers. All the details like frequency, operational mode and input/output powers are defined there. But there is another table for storing the transceivers but currently the official code is commented to store them.
- the database storage follows the current flow in the backend: ***optical_config*** -> ***transponder_type*** -> ***optical_channel***.
- the ***channel_uuid*** is manually generated using a hash function(channel-name+device_uuid).
- but I didn't find any direct connection to map the channels to the endpoints in the database. The reason is that, channels and endpoints can be same for different devices. The device ID is the distinguisher, for these names. Another issue was that the channels were stored in the database before the endpoints, in different functions. ***So, even if we wanted to use the `endpoint_id` in optical_channels we couldn't do it, unless performing hash-reverse using channel-name and device_id.***
- the easiest solution for that was to use our ***index*** column from ***endpoint*** table in ***optical_config***. The index works like a unique identifier and we populated them before calling the database-manager. Later, we just passed them to each functions for database storing.
- ***src/device/service/Tools.py*** has been modified with these changes. And a sample output is such:

```json
{"endpoint_uuid": {"index": "TPA2_11", "channel": "channel-1"}}
{"endpoint_uuid": {"index": "TPA2_22", "channel": "channel-2"}}
```

- the ***index*** is also beneficial for the user to identify the device+port from the webUI. The function that sanitizes this name is located here: ***src/device/service/Tools.py:44***

### Phase 1: ITU Standards and RSA Tools

1. Creating ITU Standards Module

    > Filename: ITUStandards.py [teraflow-develop/src/common/ITUStandards.py]

    Created a new module with ITU-T G.694.1 optical networking standards:

    - **FrequencyMeasurementUnit**: Enum for frequency unit conversions (GHz, THz)
    - **ITUStandards**: Core constants (ANCHOR_FREQUENCY=193.1 THz, SLOT_GRANULARITY=6.25 GHz)
    - **FreqeuncyRanges**: Enum with min/max frequencies for each optical band (O, E, S, C, L, CL, SCL, WHOLE_BAND)
    - **Bands**: Human-readable band names ("O", "E", "S", "C", "L", "C, L", etc.)
    - **Lambdas**: Wavelength ranges in nm for each band
    - **Slots**: Number of 6.25 GHz slots per band (C_BAND=701, L_BAND=498, etc.)
    - **SlotStatus**: Availability flags (AVAILABLE, UNAVAILABLE, IN_USE)

2. Creating RSA Helper Functions

    > Filename: RSATools.py [teraflow-develop/src/common/RSATools.py]

    Created helper functions for RSA operations:

    - **detect_band(frequency_hz, min_frequency_hz, max_frequency_hz)**: Detects the smallest optical band containing the given frequency
    - **compute_rsa_params(frequency_hz, min_frequency_hz, max_frequency_hz)**: Computes RSA parameters (min/max frequency, flex_slots, bitmap_value) for a channel
    - **detect_band_for_display(min_frequency_hz, max_frequency_hz)**: Returns band info with wavelength range for WebUI display
    - **build_spectrum_slot_table(channel_data, band_info)**: Generates slot table with availability status for WebUI
    - **_determine_slot_availability(...)**: Determines slot status (AVAILABLE/UNAVAILABLE/IN_USE) based on bitmap

---

### Phase 2: Database Schema Updates

1. Adding RSA Fields to OpticalChannelModel

    > Filename: TransponderModel.py [teraflow-develop/src/context/service/database/models/OpticalConfig/TransponderModel.py]

    Added new columns to `OpticalChannelModel` (table: `optical_channel`):

    ```python
    # [CHAFI-THESIS-START] - RSA spectrum allocation fields
    min_frequency = Column(Integer, nullable=True)  # Band minimum frequency in Hz
    max_frequency = Column(Integer, nullable=True)  # Band maximum frequency in Hz
    flex_slots = Column(Integer, nullable=True)     # Number of 6.25 GHz slots in the band
    bitmap_value = Column(String, nullable=True)    # Slot availability bitmap (large int as string)
    # [CHAFI-THESIS-END]
    ```

    Updated `dump()` method to include new fields in JSON output.

2. Updating OpticalConfig.py for Database Storage

    > Filename: OpticalConfig.py [teraflow-develop/src/context/service/database/OpticalConfig.py]

    Modified `set_optical_transponder()` function:

    - Updated channel_tuple to include: `min_frequency`, `max_frequency`, `flex_slots`, `bitmap_value`
    - Updated `OpticalChannelModel` upsert statement with new fields
    - Updated `on_conflict_do_update` to persist RSA fields on updates

---

### Phase 3: Device Service - Channel Extraction

1. Modifying transponders.py for RSA Computation

    > Filename: transponders.py [teraflow-develop/src/device/service/drivers/oc_driver/templates/discovery_tool/transponders.py]

    Modified channel extraction to compute RSA parameters:

    - Added import: `from common.RSATools import compute_rsa_params`
    - In channel dictionary creation, added RSA field computation:
    - Extract `frequency` from XML
    - Call `compute_rsa_params(frequency_hz)` to get band parameters
    - Populate `min_frequency`, `max_frequency`, `flex_slots`, `bitmap_value`
    - Added logging for RSA computation results

2. Updating filters.py with RSA Imports

    > Filename: filters.py [teraflow-develop/src/device/service/drivers/oc_driver/templates/discovery_tool/filters.py]

    - Added import for RSATools module
    - Updated Namespaces and Filters for channel property extraction

---

### Phase 4: WebUI Implementation

1. Adding Jinja Filters for Frequency Conversion

    > Filename: **init**.py [teraflow-develop/src/webui/service/**init**.py]

    Added Jinja template filters in `create_app()`:

    ```python
    # [CHAFI-THESIS-START] - Jinja filters for frequency conversion
    @app.template_filter('hz_to_thz')
    def hz_to_thz_filter(value_hz):
        """Convert Hz to THz for display"""
        return value_hz / FrequencyMeasurementUnit.THz.value

    @app.template_filter('hz_to_ghz')
    def hz_to_ghz_filter(value_hz):
        """Convert Hz to GHz for display"""
        return value_hz / FrequencyMeasurementUnit.GHz.value
    # [CHAFI-THESIS-END]
    ```

2. Updating Endpoint Details Route

    > Filename: routes.py [teraflow-develop/src/webui/service/device/routes.py]

    Modified `endpoint_detail()` function with channel data fetching logic:

    **Data Flow:**

    1. Get `endpoint_index` from `target_endpoint.index` (e.g., "TPA2_11")
    2. Use `opticalconfig_uuid_get_duuid(device_uuid)` to compute `opticalconfig_uuid`
    3. Call `context_client.SelectOpticalConfig(opticalconfig_id)` to get optical config
    4. Match `endpoint_index` with `config['endpoints'][].endpoint_uuid.index` to find channel name
    5. Search `config['channels']` for matching channel and extract RSA data
    6. Call `detect_band_for_display()` to get band info with wavelength range
    7. Call `build_spectrum_slot_table()` to generate slot availability table
    8. Pass `channel_data`, `band_info`, `slot_table`, `slot_granularity` to template

    **Key Functions Used:**

    - `opticalconfig_uuid_get_duuid()` from `common.tools.context_queries.OpticalConfig`
    - `detect_band_for_display()` from `common.RSATools`
    - `build_spectrum_slot_table()` from `common.RSATools`

3. Creating Endpoint Frequency View Template

    > Filename: details.html [teraflow-develop/src/webui/service/templates/device/endpoints/details.html]

    Created comprehensive endpoint details template with:

    **Frequency Capabilities Card:**

    - Minimum/Maximum Frequency (THz)
    - Bandwidth (GHz)
    - Optical Band name (C, L, etc.)
    - Wavelength Range (nm)
    - Flexible Grid Slots count
    - Slot Granularity (6.25 GHz per ITU-T G.694.1)

    **Spectrum Allocation Table:**

    - Scrollable table with all band slots
    - Columns: Slot #, Frequency (THz), Availability
    - Color-coded status badges:
    - UNAVAILABLE (gray) - Outside device capability
    - AVAILABLE (green) - Free slot
    - IN_USE (yellow) - Allocated slot
    - ANCHOR (blue) - ITU anchor frequency (193.1 THz)
    - Summary statistics (total, available, unavailable, in-use counts)
