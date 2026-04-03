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
