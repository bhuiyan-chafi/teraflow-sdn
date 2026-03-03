# Generating Multiple Topologies

TeraflowSDN allows us to generate multiple topologies, but it is not a simple process. To discuss this topic I want to address a couple of things.

## How we deploy tfs?

First we define the environment variables and then execute the [script](../deploy/all.sh) that deploys almost everything [you can choose your specific deployment as well]. Later when we change any code we had to rebuild and redeploy a specific server. For example let's have a look at an example that rebuilds and redeploys the **context service**.

```bash
docker build -t localhost:32000/tfs/context:dev -f src/context/Dockerfile .
sleep 1
docker push localhost:32000/tfs/context:dev
sleep 1
kubectl rollout restart deployment/contextservice -n tfs
```

The new contextservice pod starts with the latest changes we have performed in the codes.

## Can we generate multiple topologies by default?

No, and that is where we have some critical steps to follow. Teraflow by default adds everything under the `admin` context and `admin` topology. If you don't create these two things before performing any operation, you are likely to face errors. So, make sure you create these two things beforehand by uploading a json descriptor that has these contents.

```json
{
  "contexts": [
    {
      "context_id": { "context_uuid": { "uuid": "admin" } }
    }
  ],
  "topologies": [
    {
      "topology_id": {
        "context_id": { "context_uuid": { "uuid": "admin" } },
        "topology_uuid": { "uuid": "admin" }
      }
    }
  ]
}
```

Then we have to check how tfs has structured topologies under contexts and how we can add our topology devices, links to a specific topology. Let's start with the json descriptor: please have a look at this [file](./admin_admin.json).

In each topology section we have an array of items that defines the list of devices and links that must go to a specific topology.

```json
 "device_ids": [{ "device_uuid": { "uuid": "TP1" } }]
```

Even though this block is defined before the **devices** block, the data in this array is processed after the addition of the devices and links. So, all your devices and links must be defined under `device_ids` and `link_ids`. But is this enough to generate multiple topologies?

## Changing some block of codes

The git branch I used for deployment had these feature turned off from the backend. To turn it on I had to make some modifications:

### Modifying Config.py

---

> File: [Config.py](../src/context/Config.py)

Here I had to change:

```python
DEFAULT_VALUE = False #before
DEFAULT_VALUE = True # after
```

But the issue was still not resolved.

### Changing the ENV variables

---

By default the `contextservice` has these setup:

```yaml
 env:
    - name: ALLOW_EXPLICIT_ADD_DEVICE_TO_TOPOLOGY
        value: "FALSE"
    - name: ALLOW_EXPLICIT_ADD_LINK_TO_TOPOLOGY
        value: "FALSE"
```

But if you change vale to `TRUE` and apply the manifest file on the pod, you will accidentally change the container image source to tfs remote server:

```yaml
containers:
    - name: server
        image: labs.etsi.org:5050/tfs/controller/context:latest
        imagePullPolicy: Always
```

This is dangerous because you will keep rebuilding your image with new codes but they will never appear in your container. When we deploy `tfs` using the `all.sh`, it changes the image pulling location to our local server, but applying the manifest changes it to the remote one. So try to avoid it, and follow these manual script.

```bash
#!/bin/bash

docker build -t localhost:32000/tfs/context:dev -f src/context/Dockerfile .
sleep 1
docker push localhost:32000/tfs/context:dev
sleep 1
# Set env vars for explicit device/link-to-topology assignment
kubectl set env deployment/contextservice -n tfs ALLOW_EXPLICIT_ADD_DEVICE_TO_TOPOLOGY=TRUE ALLOW_EXPLICIT_ADD_LINK_TO_TOPOLOGY=TRUE

kubectl rollout restart deployment/contextservice -n tfs

# check the env variables
kubectl exec -n tfs <pod-name> -- env | grep ALLOW_EXPLICIT
```

This will enable the env variables and restart the pod. You can also check the env variables using the script mentioned above.

But, does it ensure the desired functionality?

### Fixing a minor bug

---

> File: [Topology.py](../src/context/service/database/Topology.py)

In line number 114 we had a statement like this:

```python
if device_uuid not in device_uuids: continue
```

which initially ignores all the device ids mentioned in the `device_ids` block. So, I changed it to:

```python
if device_uuid in device_uuids: continue
```

and this fixed the issues.

Now you can test this [json descriptor](./test_test.json), which must create another topology and show only the device specified there [Make sure you have the device running].
