# How ParallelOpticalController Operates

In this part we will discuss, how our parallelopticalcontroller functions inside teraflowSDN. More precisely I am going to discuss about the mathematical operations, algorithmic approach, code reviews, etc. So, let's start with the `graph-building`.

## Building Graph with NetworkX

This is the primary core part of the whole execution. From the teraflow topology, we have generated another local graph using `networkX` for better path computation and expansion. This allows us to compute the shortest path as well as all possible path from a source to destination.

### Initialization

In `[ParallelOpticalController.py:270]` I have computed the required slot by calling a helper function in RSA.py:71. The bitrate for this operation is considered as GHz. The formulas have been used to determine required bandwidth and number of slots.

$B_r=(\frac{R_b}{n})(1+\alpha)$, where $n=log_2(M)$

`M` represents the modulation format that has been used. Even though there are several involving factors to determine required bandwidth, I have used the most common ones to simplify the process. To determine the number of slots, I have used the minimum unit of measurement as per ITU G.694.1 standards which is 6.25GHz spacing of an optical channel. And the slots are determined using this formula: $N=(\frac{B_R}{6.25})$

In `[ParallelOpticalController.py:305]` I have called the core graph building function in topology.py:307. Here are the logical terms:

- only optical devices are considered for the graph building.
- the devices are `networkX` nodes but added with some additional information. [As networkX doesn't have a default device-port-link type formation, I had to make my own.]
- `[topology.py:192]` fetched all the links and created a device-endpoint map based on the `teraflow` db records. This map helps fetching frequency related information from the database. Then in `RSATools.py:342` for each endpoint we have retrieved the channel information. This information gives all details about the supported frequencies.
- `[topology.py:398]`, here we have drawn the graph by defining the nodes and edges.
- `[ParallelOpticalController.py:333]`, the path calculations are performed here.
- `[topology.py:429]`, first graph is build with free links only where `OCH==USED[false]` which is `G_FREE`***[multi-directed, which allows parallel links]***. Second graph `G_simple_free` is defined to remove parallel links, to find unique paths from source to destination.
- `dijkstra` is calculated from `G_free` to ensure we used free links only.
-`G_simple` is the raw graph to determine all possible paths from source to destination. Later they are expanded to find parallel paths. This doesn't filter used links.

***Where all possible paths are discovered?***

In `find_paths()` function I have generated a second graph (`G_simple_free`) with all links (even with used ones) and called `all_simple_paths()` to find all possible paths. `expand_path()` takes a list of nodes(devices) and find all possible combinations between two nodes.

### Performing the RSA

---
`[POC.py:353]`, takes the path and additional information. `[RSAHelper.py:417]]`, `rsa_bitmap_pre_compute()` takes the path and optical-links, calculates min(min(frequencies)), max(max(frequencies)) and then generates a reference bitmap. Later each hop is calculated with the bitmap intersection to produce final result. Finally, result is stored in db-flow and returned in response.

### Acquiring the Slots

---
Takes path object. Traverse each hop, checks current bitmap value from the cache(perform_rsa), removes the alignment, converts back to the integer and updates the database using context-client.
