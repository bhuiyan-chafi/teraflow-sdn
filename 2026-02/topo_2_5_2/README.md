# Usage of TFS descriptors

The descriptors are initiators of a service in Teraflow eco-system. Whether you want to add a device or ask for a service! You have to make that request through a descriptor. As I have made some modifications in certain sectors, we have to follow some criteria to use the descriptors properly.

## The context

Defined by the descriptor [context-descriptor](./1.context.json). There is no modification in this descriptor. Usage:

- from the main webui, click on upload json descriptor and select the file
- select the context from the context dropdown menu

***Remember that the context is stored in browsers cache***

## The topology

If you have docker installed in your machine then make sure you have this [testbed](../../main/TFS_Integration.md/#testbed-setup) ready. Then run this following [script](./testTopo2_5_2.sh) to build and run your optical-device emulators.

## Device descriptors

These two descriptors: [Muxponders](./TPs.json) and [ROADMS](./RDMs.json) will add the devices into the controller. ***If you have a different setup, make sure the address and credentials are correct.***

## Links

The official descriptor is slightly different than [this one](./Links.json). As I have added the device endpoint index as another primary key, you can use either `uuid` or `index` under the `endpoint_uuid` section to define src and destination ports of a link. ***Remember that the `uuid` is first priority, if any endpoint is found with that `uuid` then index won't be used. So, don't mixup `uuid`s.***

For parallel links, delete the current optical-links and upload this [one](./ParallelLinks.json).

## Optical Intents/Light-paths

This requires the `ParallelOpticalController` to be running. Make sure you have read [this](../parallel_optical_controller.md) and know how to initiate the controller. Then upload the [first](./PO_Intent.json) and [second](./PO_Intent_2.json) intent to test the topology with no parallel links. For the second intent, avoid the dijkstra path and choose a path with a common OMS transport type (a ROADM endpoint that has an active connection).

With the parallel links, try either of them.
