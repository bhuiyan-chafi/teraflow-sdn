# RSA V2

Finally I got some serious modification from modification from my professor. The current logics that I have in my RSA project has serious misleading and wrong information. But, over the last discussion these misconceptions are over. So, we have to modify the logic and prepare new simulation scenarios. Let's do that. 

## Optimising queries

1. Graph has been cached 
2. 

## Modifying the Device Database

See the sql file @ . From there remove all the values starting with "TP". These values corresponds Transponders which are not necessary for the current scenario. 

## Modifying the Endpoints

- Each of these TPxxx devices has endpoints specified in @ . We have to remove them as well. 
- If you notice carefully you will see each devices denoted as "RDMxxxx" which are the ROADM devices has 20 endpoints. We have to reduce them into 8. 
- One misconception is that, you have created 12 OCH and 12 OMS. Since we don't have connections to transponders, we don't need OCH type endpoints anymore. So, we will have 12 OMS ports only. 

## Modifying the Optical Links

- as we have already removed the Transponders, there will be no links from those devices. 
- as for the ROADM, we have to reduce the it into single links. Which means use one endpoint of a ROADM to another ROADM for one connection.
- remember that this is a NSFNET standard topology with 14 devices and 21 links mesh-network. If you need to re-arrange some of the links, please do. But I want a standard topology created.

### Create Parallel Links

- now create another file as optical_links_parallel.sql
- use the same source and destination but use different endpoints to expand one link into total 3 links
- as each RDMxxxx device has 8 ports, you can use 3 as input and 3 as output. That will still leave you with 2 more. 

## Fix sim_config

- change the names as per the devices in @

## Fixing the core logic

Now we have to perform some serious modification. From now on, prefer discussion over development. Do not jump into coding unless you are clear about my instructions. 

### Randomising the bit-rates

If you see in @ right now the bit-rates are listed in a python list. Later in @ , these bitrates are run by a python loop. So, we have different simulations for each of these bit-rates. But this makes the dynamic flex-grid more like a fixed-grid scenario. In flex-grid scenario we have multiple bit-rate channels co-exist in the same fiber. Different requests generated from a poisson process can have different bit-rates. So,

- we have remove the BIT_RATE list from @ and then remove the loop in @ . 
- the possible bit-rates are 100,200 and 400 Gbps. The probability distribution is 50%, 25%, 25%. 

### Behaviour of the Randomness

There is a peculiar behaviour which is common but problematic for simulation scenarios. While Poisson Process is uniformly random, different simulation will have different type of dynamic traffic. What I meant is that, let's say simulation A has a result P=0.008 for a metric. If I run the same simulation with the same configuration again I get a new value P=0.006. This is not acceptable. 

==> This is why we are using CI and relative CI. So, the problem is already fixed there. The deviation I saw earlier could be because of running it in different machine. 

### Generating the graph

Now that we don't have the transponders, it is not necessary to filter any ports for the optical transport type. 

- If you see in @topology.py function build_graph() line number 46, 47, here we are filtering otn_type for the graph generation. Right now in our topology all the endpoints are of OMS type and that is why we don't need to filter them using the query. 
- also we don't have to filter the status in query: line number 57, 61
- we need the rest of the information
- we don't have to query the src_otn_type, dst_otn_type, src_status, dst_status
- also in the for loop we don't have to determine the OTN type
So, remove these filters. This confirms that from the graph generation phase now we are returning a graph which has multiple edges (including parallels if available) between two nodes.  

- if that is correct and we are not filtering any updated information, for each request building this graph is a heavy task. Why don't we put it in a cache, for example in a simulation run we are using the same graph over and over again. If we build the graph for the first request and then use it for the consecutive requests we can avoid the heavy traffic to the database. As I know python has a db_flow in memory operation to store information in a running execution. Let me know if we can use that or you have other caching options, but remember one thing that things should be simple and without requiring additional packages. 
- the graph will not change even for different erlang loads in @sim_config.py. It will only change if stop the running project and then run again with new values in the database. So, keeping it alive for until the python app is running is the best choice I guess. 

### Path selection strategy

In @sim_config.py there is a variable PATH_TYPE which determines which and how many path should be returned as a response. For example if the value is dijkstra it should return the disjkstra path only, for additional it must return the additional path calculated based on dijkstra in @topology.py. If selected both then it must return two paths, which is the current situation. The path calculation must be performed based on these conditions to avoid unnecessary path computation. Because unnecessary path computations arise latency. Right now in @api.py the simulator already performs rsa in a loop. I think we can keep this setup, because if the response returns one path the loop runs once and for two it will run it twice. If needed we will modify it later based on the upcoming situations. 

### The Spectrum Assignment

Once we return the path/s the RSA is performed in a loop on the path/s. In @topology.py we are sending path object (single path) and the selected bitrate. It takes us to the perform_rsa() function in @helpers.py. Here we are computing the bandwidth and number of slots required. These two logic is fine, and needs no change. In line 743 we are pre-computing the RSA bitmap. This takes us to the function rsa_bitmap_pre_compute() in the same file where we receive the path object. In this function line number 601 is querying the links from the path object. It is also querying the endpoints of each link. Can you verify the following?
- it is only querying the links within the path object
- it is only querying the endpoints related to the links
- no other endpoints of the same device is queried 

==> Confirmed

- in the next steps till Step 4 we have everything in order. Confirm this, that you understand the process until step 4. 
- now in step 5 we are going to do a major change. In this step we are performing bit-wise intersection for each hop. In a hop we have one source and one destination endpoint. But right now we are querying the device of this endpoint and then querying all the endpoints of this device as parallel endpoints. This is wrong. Because in DWDM network we use parallel links to aggregate the bandwidth. If we consider parallel links as unified, we actually prohibiting the use of parallel links. So,

- first of all we have to remove the parallel endpoint fetching
- second, we have to ensure that the bitwise intersection is performed in each hop for the source and destination endpoints only.
- for example: reference_bitmap = 11111, we have 5 source and 5 destination endpoints in this path object. In each hop we will use the reference_bitmap and then perform intersection, update the reference and then to the next hop. 
- the hop-wise tracing should be preserved but we are not considering the parallels any more since this logic is wrong
- the last value of the reference_bitmap will have the used slots marked as 0.
- the result is then sent back to the perform_rsa() function in @topology.py
- there in step 2 we will start finding the continuous and contiguous slots. 

Before starting that, let's finish everything we discussed here. 

#### Slot checking

Right now in step-2 the slots are checked based on the constraint First-Fit starting from the least significant bits (most right bit). Then it checks "num_slots" which is the total number of slots we require. Now we have to change this based on strategy. the strategies are defined in @sim_config.py under SPECTRUM_STRATEGY. The logic is the following:

- if first-fit we keep the current logic
- for last-fit we start from MSB (most left bit)
- for random we take "num_slots" from any position that satisfies the requirement. But I think we need to discuss the positions. Even though it is random the slot count should start from some position. And if we keep checking until we find the block of slots then it is not randomness I suppose. So, what should be the random-fit case?

THE RANDOM SELECTION STRATEGY:

To maintain a mathematically consistent flow, the spectrum assignment logic is decoupled into a Discovery Phase and a Selection Phase. During the Discovery Phase, the system performs a single scan of the bitmask from 0 to reference_slots to identify every contiguous block that meets the num_slots requirement, saving their starting indices into an available_blocks list (e.g., [0, 15, 40]). In the Selection Phase, the algorithm evaluates this list based on the requested strategy: First-Fit selects the lowest index (available_blocks[0]), Last-Fit selects the highest (available_blocks[-1]), and Random-Fit performs a uniform selection via random.choice(available_blocks). To implement this unified logic, api.py must be updated to pass the strategy argument into TopologyHelper.perform_rsa(path_obj, bitrate, strategy), ensuring the chosen policy is explicitly handled from the initial API request through the final RSA execution.

#### Acquiring the slots

Now in the API we are going to perform slot acquisition as step 3. In line number 98 we have the function commit_slots() that takes us to the @helpers.py again. We are taking the link_ids, mask for this operation. 

- in step 1 the links are queried and then endpoints are extracted. 
- step 2 valid_endpoints are check. The reason is that if two requests are checking the same links in the database, one might get wrong information if another changes it. But in our scenario this is unnecessary, because python is by default sequential. We are not doing any parallel execution here, the events are queued in a priority heap from where one at a time is popped. [removed step 2]

***Side task:***

- if you look at the queries we perform for a "request" from the API. First we are querying the links in @topology.py #L35-45. Then again in @helpers.py #L534-537. Then again in commit_slots() in @helpers.py #L755-758. The same information is retrieved isn't it? Can you confirm? 
- if that is the case then why don't we cache the links at the build_graph() phase. This query has the largest quantity of the information. When a request is placed, we can do this once and then use it in every function when we need to query the database. If the request is successful we can clear that cache before leaving. The next request will perform the query again and then use it till it is finished. It doesn't matter if the request is a success or a block. It must clear the link cache before it leaves the execution. 

- a side task. If you look at a sample at linen #378, you will find how we are printing the paths with link details for logging. But putting these lines in codes creates congestion. Instead I want to define a function in @helpers.py as log_path_links(path_collection[]) where I will send a path collection (can contain single or multiple) computed from NetworkX. From there it must print the paths with links (names to distinguish them properly) and log them properly. You can see the current procedure already available in the mentioned lines. Then from the @topology.py I will call the function and pass the parameter. 

- there is a flaw in the highest_slot finding. Have a look at these logs:

rsa_api      | INFO:helpers:[Path Discovery] Valid path found: RDMma -> RDMpa -> RDMil -> RDMtx via links [RDMpa->RDMma_19, RDMil->RDMpa_15, RDMtx->RDMil_12]
rsa_api      | INFO:helpers:[Path Discovery] Valid path found: RDMma -> RDMga -> RDMtx via links [RDMga->RDMma_22, RDMtx->RDMga_13]
rsa_api      | INFO:helpers:[Highest Slot] Selected Path: RDMma -> RDMga -> RDMtx with Max Avg Slots: 19628.00
rsa_api      | INFO:helpers:[Phase 2] chosen additional path: RDMma -> RDMga -> RDMtx
rsa_api      | INFO:helpers:[Phase 2] chosen single link path: RDMma -> RDMga -> RDMtx via links [RDMga->RDMma_22, RDMtx->RDMga_13]

We have two paths and for the first request it selects the shortest path. And assigns the spectrum. But for the second request, since in the first path we have some spectrum booked; for sure the alternative path has more slots available and thus it must be selected. Why the used path is selected again?

rsa_api      | INFO:helpers:[Path Discovery] Valid path found: RDMma -> RDMpa -> RDMil -> RDMtx via links [RDMpa->RDMma_19, RDMil->RDMpa_15, RDMtx->RDMil_12]
rsa_api      | INFO:helpers:[Path Discovery] Valid path found: RDMma -> RDMga -> RDMtx via links [RDMga->RDMma_22, RDMtx->RDMga_13]
rsa_api      | INFO:helpers:[Highest Slot] Selected Path: RDMma -> RDMga -> RDMtx with Max Avg Slots: 19618.00
rsa_api      | INFO:helpers:[Phase 2] chosen additional path: RDMma -> RDMga -> RDMtx
rsa_api      | INFO:helpers:[Phase 2] chosen single link path: RDMma -> RDMga -> RDMtx via links [RDMga->RDMma_22, RDMtx->RDMga_13]

What is the flaw?

#### Checking the progress

If you look at @test.py, I have a command to test one request. Since we added new strategies, can you reform the command to test one request?


## Counting the used Links:

If you look at @simulator.py, we are posting the results after each load simulation. For a one load we run an amount of requests, in each request we select a path and establish the lightpath request. A path is basically a combination of links. Since we are querying the links at several steps, I want to study which links are mostly picked for a path in a specific network load. For example Erlang 80 I sent 10000 requests and observed a blocking probability. I want to observe which links are mostly picked within 10000 requests. To do that, I propose:

- put a variable in @sim_config.py as LINK_STUDY = True / False
- if True then perform the following:
- since link database IDs are not changing unless I change the data manually
- create a in memory table with link_id, link_name, count
- in each successful request increment the count of a link_id (link_ids are used in every step for path computation and rsa. But verify this before implementing).
- when a network load is done and dumping the results, print first 10 links with the results as: "most_used: RDca, RDny,...."
- give me the plan first then we will discuss how to implement. 

## Running the simulation

Before I used this command to run the simulation: nohup python3 -u -W ignore simulator.py > results/PAN_LF_400.txt 2>&1 &

Now, that we have several constraints to fix, how can I set them and run a simulation for different scenarios. I think if you design a run_simulation.py where I can set the parameters and run the simulation, will help. 


## Fixing the SP+1 logic

So, we had a confusion about the shortest path + 1 path selection. What my professor meant by this is to select all the shortest paths + the paths discovered by increasing one hop. But in the code I implemented only the path selection of shortest paths+1. This gives us less paths, thus increases the path blocking probability. If you go to @topology.py, we can see that we are calculating "simple_node_paths" and then removing the dijkstra paths. For any cases additional paths (shortest path+1) must include the dijkstra shortest paths as well. So, we have to remove the dijkstra deduplication completely. 

### Querying the links in Perform RSA phase







