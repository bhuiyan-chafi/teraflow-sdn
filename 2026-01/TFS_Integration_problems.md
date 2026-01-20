# Problems and Solutions

During the development I faced these issues. Some of them are so dumb that I was laughing, but in development everything is fair!

## No device info received by the controller

File ***"/var/teraflow/device/service/DeviceServiceServicerImpl.py"***, line 148, in ***AddDevice*** raise OperationFailedException('AddDevice', extra_details=errors).

```bash
bash scripts/show_logs_device.sh 
# filter logs
kubectl logs -n tfs deployment/deviceservice -f | grep -i CHAFI
```

***Solution***:

- ***populate_endpoints()*** is where ***driver.GetConfig()*** is called during ***AddDevice*** flow
- so, we passed ***device_info*** related information from there too. File: src/device/service/Tools.py because it works as a helper for ***DeviceServiceServicerImpl.py***.
