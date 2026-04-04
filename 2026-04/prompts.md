# Introduction

Please read this file @ to know about this project and what we have built so far. After that we will do some more developments.

## Building the topology

Let's build the topologies first. The first topology I want to build is the NSFNET topology.

- First I have to generate the devices by following this script @beautifulMentionand @beautifulMention following the pattern of @beautifulMention sql file. The new file should be saved in @beautifulMention/rsa_project/sql/nsf_topo as devices.sql.
- Then I have to generate device endpoint information following the sql file pattern @ . But it should use the devices as per @ . Remember that the frequency values will be 191556250000000, 195937500000000 instead of 191581250000000, 195912500000000 and number of slots will be 701 instead of 693. And the bitmap value will be 2^701 - 1 instead of the current value.
- Modify the file @ so that each transponders an have 4 ports instead of 2.
- The next option is to generate the links. To see the current topology you can check the links I desire from this json file @ . Note that this topology will have parallel links. So you have to generate this amount of link and follow the sql file pattern from this file @ . Finally a new file should be generated in the nsf folder.
- Now, you have to create another folder as paneu_topo and then generate the devices, endpoints and then links. For devices you can see the script allTPs.sh and allRDMs.sh but create only the europeans. For the links follow this file paneu_parallel.json.
- This implementation intorduces an additional problem which is stated with a fix in this file @ . You task is to read that and get the idea and then implement the solution.
- The next step is to limit the number of hops for the additional path. The additional path computation must respect the rule shortest_path_hop+1 rule. Which means if you find dijkstra path with 8 hops, all available path must be calculated within 9 hops. Create a variable for that because I might tune that for testing. This must eliminate the use of HIGHEST_HOP. Because no hard coded hop should be used.

## Applying no specified port option

If you see the current path finding mechanism in @ . You will see it is bounded by the ports. But it limits the benefits of having parallel links between devices.

- So in the dijkstra part it is okay to bind it with ports, but for additional path finding the ports should not be fixed, instead it must avail all available resources.

- can you also remove the port binding from dijkstra as well? The function can receive the ports but don't use them. This will help ease the coding.

## Building the APIs

I need two APIs, one for submitting the lightpath request and another one for tearing it down. Right now I am sending the lightpath request using the web template here @ . From there it takes me to another web template where I can see the dijkstra path with rsa compuration and below all the available path. Then I have to click on Acquire Slot button from this web template @ and it perform necessary operation and then acquires the slots and update the database. Are you clear on this?

- what I need is that: I don't want to change what I currently have. I want you to create another folder in the root directory as path_blocking. There create another python file and there generate the first API that will perform the following:
- - it will re-use existing resource: functions, enums, files, etc.
- - it will take the src_device, dst_device, bitrate and then perform the path_computation and slot acquisition in one go.
- - you can have some questions!
- - - what happens if there is no dijkstra found?
- - - - Dijkstra will be found always because we are filtering out the used OCH and full OMS ports. The only chance is that when the resource is 100% occupied for the given bitrate, we will find no path available. In that case the API response must return path-blocked.
- - - what happens if number of slots are not available?
- - - - Path blocked.
- - you might need some additional codes to write. But try to avoid current modifying or adding current files. If you need additional support, get results from there and then write necessary codes in the new python file.
- then create another python file as simulator.py where I will define the parameters in a dictionary and perform a API request to test.

- for the teardown option, create another database model it's fine. Then after the successfull allocation of slots store necessary information there. And perform a teardown request for now to test. Leave the holding time for now. One execution must acquire and release at the same time. The models are defined in @ .
- - remember that the timing of the lightpath establish request must not include the database storing time. It should be kept as it is now.

## Building the simulator

Now we have the hardest task, which is designing the test-cases and running the simulator. Let me give you the foundational concept:

- The number of requests, N_REQ = 10,000 which should be defined as a constant
- Mean holding time, HOLDING_TIME = 30 seconds after which an active lightpath must be teared down and resources freed.
- Arrival Rate, is a variable defined as arrival_rate and the equation is erlang/HOLDING_TIME
- Erlang is a tuple ERLANG= (100...1000) in a step of 100
- for each erlang we perform 1 simulation
- transient period is 10 holding time which is 10\*30=300seconds=5minutes. This means that for this period we don't count the requests but we do send them and perform teardown. From 6th minutes we count the number of blocked requests, stored in request_blocked variable.
- after each erlang we compute the following:
- - blocking probability, blocking_probability = request_blocked/N
- - confidence interval, confidence_interval = blocking_probability \pm Z \times \sqroot (blocking_probability(1-blocking_probability))/N
- - value Z is a constant whose value is 1.96 at 95% confidence level
- the final output will be a dictionary showing, load: , blocking_probability, confidence_interval

### Setting up the parameters

- The source and the destination must be picked randomly from the lists available @
- The bit-rate must be chosen the same way
- The erlang must be used in a loop sequentially
- For Statistical Distribution here is my theoretical explanation:
- - as I described before if you are testing with 100 erlangs for example you must generate 100/30=3.333 requests per second. I don't know if this is exponential distribution.
- - the teardown must be scheduled after 30 seconds of path establishment. For that I think you must the record time of establishment and then perform the teardown based on that.
- If you use the virtual time: isn't it gonna create problem? If you are fast-forwarding the arrival, the teardown is scheduled right after 30 seconds-isn't it gonna increase the path blocking because most of the resources are scheduled later to be freed?
- for the number of requests I have one concern. Since we are considering the transient phase, we are missing the number of requests sent by that time. And at the steady state the total number of requests sent is < N. So for the probability we cannot say we tested N paths, isn't it? Don't you think we must reset that count as well? And we must send N requests starting from the steady state too?

## Testing

- Now put simple logs in the simulator to see the following:
- - which erlang is in execution
- - which path has been established, at what time and when is to be teared down
- - after teardown log which one teared down, at which time

## Question and Answer

1. About the virtual timing, what is fast forwarded actually? The transient phase 300 seconds or the time of the whole simulation?

In real-world time (or if we used Python's time.sleep()), a single Erlang load simulation with 10,000 requests averaging 3.33 requests per second would take roughly 55 minutes to finish just one loop. To process all 10 Erlang loads (100 to 1,000), you would have to leave your computer running for nearly 10 hours. Because we are using an Event Priority Queue, the virtual clock jumps instantaneously to the exact millisecond of the next event (whether it's an Arrival or a Teardown), entirely skipping the "dead air" between them. So, the simulator fast-forwards through the 300-second transient phase AND fast-forwards through the ~50-minute steady-state phase. The only factor limiting the speed of the script now is purely how fast your computer's CPU and Docker Database can mathematically calculate the optical routes and commit the SQL slot blocks!

## Problems and solution

1. **_Lightpaths were established even though there were no OCH ports available in the source, destination device:_** I found a path computation error by executing the single api call. TPmissouri has 3 connections to RDMissouri. According to the logic in @beautifulMention: find_paths(), we cannot re-use any OCH port if the status is not "FREE". Checking the database I saw that the lightpath establishment operation is not updating the link status. The logic is handled by the @beautifulMentionin process_optical_links() but it is creating a huge problem. Let me describe you the scenario.

- one optical links is consisted of two endpoints of a device. If the endpoint otn_type is OCH in both ends, those endpoints can only be used once. But if the otn_type is OMS they can be used untill all of the spectrum is used.
- now the decision for the OCH is straight forward, isn't it? Because if the lightpath succeeds you can put in_use=TRUE for the endpoints and make the status=FULL in optical_links.
- but for the OMS you simply cannot do that without computing the current bitmap and checking the slots. This is significant issue because the path computation relies on that. I am thinking to move the status column from optical_links to endpoints table. In that case I don't have to query two tables to update a single logic.
- as this is done, now we can discuss on the next step 2. Let's focus on the web template of the optical links. One optical links is consisted of two endpoints of a device. If the endpoint otn_type is OCH in both ends, those endpoints can only be used once. But if the otn_type is OMS they can be used untill all of the spectrum is used. Before fixing the database the optical links backend logic used an intermediate computation to determine the link status. Since link status has been removed from the optical_links table, the logic is obsolute now. What we have to do is that, we have check both of the endpoint status and simply display that value. If you think logically, in a link two endpoint is either OCH or OMS. So there is no change that for one link we will have two different value in the status. So, you can debug the function "process_optical_links()" in @ and remove if it's no longer used. Because in the path compuation we are going to change the logic in the next step once we are done with this.
- to ease the process we are removing the ports from the path computation completely to utilize the benefits of having parallel links. Now that we don't have the ports any more, we have to modify the function find_paths() in app.py and topology.py by receivng 3 parameters only: src_device, dst_device and bitrate. We must remove additionals except the dijkstra only part. Then in the topology.py we are calling the function build_graph() where are querying the links and building the graph. Since we have modified the models, can you confirm this part is updated with the latest changes?
- till now the changes seems to be fine. I have also checked by making a request from the web interface. Let's discuss on perform_rsa_for_path() in @ . As we can see the graph is built again using the link ids. Do you think this is a redundant task? For the rsa computation we are passing the path_obj and graph and then querying the endpoints, etc. But this process can be simplified isnt it? If we have the link IDs, can we get the source devices and destination devices from all of them and then perform a endpoint search and then perofrm the parallel rsa computation-it is going to result the same. Is it or you see any flaw?
- now the next part is to committing the slots. If I am acquiring the path with the required slots, how am I going to update the database. Remember that for links endpoints which are both OCH, we will update them as FULL. But for link endpoints of OMS type should check the updated bitmap, if it's all 0s or 0 it is FULL otherwise USED.

2. **_Race condition and db transaction issue checking:_** If we see from the simulation point of view, we are generating N requests at a time and all of them are accessing the same resources. Imagine a scenario where two lightpath request involves common links. Both of them will query the same information and compute the rsa. In another scenario one lightpath is acquiring the slots of a link which is being computed by another lightpath but before the second one acquires, the first one acquires that in that case the bitmap values will be tamperred. Isn't it?

- the situation is found to be true and solved by introducing a change signature to accept allocated_mask(The value "allocated_mask": N is the integer representation of the specific spectrum slots (bits) that have been reserved for that lightpath.) instead of (or in addition to) final_bitmap. Update the endpoint query using .with_for_update(). This causes a concurrent request to Halt (wait) if it targets the same links, ensuring it sees the most recent bitmap after the first request finishes. If, after waiting and acquiring the lock, the requested slots are no longer FREE, return a specific blocking status.

## Simulation 1

Now we are ready to perform the simulation again. Lets create some more transponders so that we can have more nodes to generate routes instead of congesting a few. This problem previously led us to a higher path blocking probability. If we check the @ , right now we have only 5 TPs. So, we are going to create more TPs and connect them to the RDMs. The following TPs should be created with the suggested name and configuration like other existing TPs. The TPs are: TPindiana, TPohio, TPmassachusetts, TParizona, TPwashington, TPgeorgia, TPtennese, TPpennsylvania, TPmichigan. If you notice the state names, I have RDMs with exactly these names. What I am trying to say is that, if there is any mismatch follow the sate name from the matching RDMs. Now generate the new TPs in @ .
