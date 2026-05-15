# About

Since SPSCPSC-SAFF turned out to be the best performer, I am trying to reduce the time consumption. To do that I have planned to use the built in ´concurrent´ module in python. 

## Current Implementation

We are going to start from the condition where we selected "highest-slot" scheme in topology.py file. In the function find_paths() #L:396 we sent the node paths and the graph to TopologyHelper.highest_slot_path() which then expands each node path and select the first one. But this is useless for the primary path selection. In our path selection scheme, we have two stages. One is the primary path calculated based on hops and another one is expanding each of these node paths into parallel paths. In the primary path selection stage it is not necessary to expand each node path into parallel ones if we are simply selecting the first one. There is another function which is expand_path_first_valid() in helpers.py which does the same expansion but returns when a valid path is found. 

Can you check both of these functions expand_path() and expand_path_first_valid() and decide if we can use "expand_path_first_valid()" without breaking any logic?

==> Done.

## Parallelizing the primary path computation for SPSC scheme

If see the function @helper.py #highest_slot_path() you can see that we are running a loop and then checking each path in the node_paths for a an average free slot checking. At the end the path with highest average is selected. We can parallelize this part using the concurrent module.But to store the average results, we have to keep a list and write the path_index and average. Now there can be a data-race because multiple workers are writing at the same time. To avoid that you can use mutex. Finally from the list of averages, select the first item as the best path. Now this leads to several constraints:

1. How many workers should we use?

For that we can use a scheme that involves several factors. For example, first check how many available physical cores "P" we have. Let's say "P" is 16. But we cannot use 16. Now we will check how may paths we had in the node_paths. Let's say we had "N" paths, we will do a binary to decimal representation of that value to select the degree. Let's say "N" = 32. So, 32 is 2⁵. Now we select it as a degree D=5. If D < P, we use D else we use P/2 just to make sure we are not freezing the CPU. 

2. How do change the code? 

Since the current solution is in use, we have to take a function bypass approach. We will define a function for parallel processing and worker deciding. First we will send the "node_paths" to the parallel processing function, then count the number of items it has "N". Then call another function to make the decision on number of workers. Then declare the list to store the results. Perform the check using the existing logic in multiple workers, write the value and finally apply the selection. Remember that the final output must match the current flow. 

3. What about other operations?

Take necessary steps. I just discussed the core logic, there are other operations too. For example database calls, link checks, bitmap computation etc. What I am trying to say is that, I should be able to easily migrate back to the current approach if I don't like the parallel one. 

==> Done

## Parallelizing the Parallel Paths

So, we parallelized the primary path selection. Now we have to parallelize the parallel path expansion. In the previous version we parallelized the primary paths that involves several nodes from source to destination. But in the parallel expansion we explore the same nodes and then expand different links. The condition is checked in @topology.py #L: 341. So, we have to parallelize that part too.

1. How parallel paths are sent for highest-slot checking?

After the expansion in @topology.py the paths are sent to @helpers.py #L:527. Then the process is like before. Let's try to parallelize it. Since the logic is same, try to reuse the functions that you already defined. 