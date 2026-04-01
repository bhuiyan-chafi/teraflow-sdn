# Execution and Processing of Optical Services in OpenDaylight (TransportPCE)

This report provides a comprehensive summary of how optical service requests (analogous to intents in ONOS) are processed within the OpenDaylight (ODL) SDN controller's architecture, specifically utilizing the **TransportPCE** project. It details the journey from the initial RESTCONF request to path computation, topology handling, Routing and Spectrum Assignment (RSA), and hardware provisioning.

## 1. The HTTP REST Request and Service Creation

The process begins when a Northbound application or script executes a RESTCONF request to request a new optical service.

* **REST Resource Handler**: TransportPCE exposes RPCs for service provisioning, typically via the `service-create` endpoint modeled by OpenROADM or TAPI (Transport API) YANG models. The entry point in the architecture is the **`ServiceHandler`** (`transportpce-servicehandler`).
* **Decoding**: The controller parses the incoming JSON/XML payload. This includes extracting service parameters: the `a-end` and `z-end` points (source and destination), required capacity, modulation format, and operational constraints like diverse routing or specific spectrum attributes.
* **Validation**: The `ServiceHandler` assesses the request for semantic correctness and registers the service lifecycle state before handing it off to the Path Computation Element (PCE).

## 2. Topology Generation and Context

TransportPCE heavily relies on OpenROADM standards and distinct topological layers represented in the MD-SAL (Model-Driven Service Abstraction Layer) datastore.

* **Topology Model**: The **`NetworkModel`** (`transportpce-networkmodel`) constructs a multi-layer view of the optical network. It builds OpenROADM device topologies based on NETCONF discovery of ROADMs and Xponders.
* **Optical Mapping**: TransportPCE maps underlying physical ports and internal ROADM degrees to a consolidated network graph.
* **Parallel Links Handling**: Parallel fiber pairs or logical links between identical nodes are instantiated as entirely distinct directional link objects in the topology datastore, marked by their specific source/destination port and wavelength capabilities.

## 3. Path Computation (PCE)

Upon a `service-create` request, the `ServiceHandler` triggers an RPC call directly to the **`PCE`** module (`transportpce-pce`).

* **Algorithm Evaluation**: The PCE utilizes a graph algorithm (typically Dijkstra's or a Yen's K-Shortest Path variant) against the fetched MD-SAL optical topology graph.
* **Constraints and Weights**: Edges (links) are assigned weights based on administrative cost, latency, or span loss. The path computation avoids links explicitly blacklisted in the service request or those that do not meet optical reachability (OSNR) requirements.
* **Parallel Links in Pathing**: Similar to ONOS, parallel links are explored as distinct topological edges. Because they have unique link IDs and resource constraints, the graph traversal inherently considers paths routing over different parallel links as unique potential routes.

## 4. Routing and Spectrum Assignment (RSA)

In TransportPCE, RSA is deeply integrated into the `PCE` capability evaluations. Once candidate physical routes are identified, the spectrum assignment step validates wavelength continuity.

* **Spectrum Availability Check**: For each topological candidate path, the PCE checks the `available-frequencies` or bandwidth allocations in the MD-SAL topology.
* **Continuity Constraint**: The RSA algorithm enforces wavelength continuity (unless wavelength converters/regenerators are modeled and allowed). It iterates through the nodes on the path to find a common, contiguous spectrum slot (or continuous DWDM grid channel) matching the requested capacity and signal type.
* **Parallel Check Behavior**: The spectrum evaluation is evaluated strictly per `Path`. If an attempt on a preferred path utilizing one of the parallel links fails due to spectrum fragmentation or lack of an available lambda, the system assesses the alternate topological path over the other parallel link(s).
* **Outcome**: A successful, spectrum-continuous sequence is secured and returned as a `PathDescription` object to the Service Handler.

## 5. Execution and Driver Push (Renderer & OLM)

Once the RSA phase successfully yields a valid path and assigned wavelength:

* **Renderer**: The `ServiceHandler` passes the `PathDescription` to the **`Renderer`** (`transportpce-renderer`). The Renderer breaks down the path into device-specific cross-connects (for ROADMs) and interface setups (for Transponders/Muxponders).
* **Optical Link Management (OLM)**: The **`OLM`** (`transportpce-olm`) manages optical power settings and link turn-up procedures.
* **Provisioning**: Finally, the controller translates these objects into standardized OpenROADM NETCONF `edit-config` payloads. These are transmitted directly via the southbound interfaces to configure the optical switch devices in the network, establishing the lightpath end-to-end.
