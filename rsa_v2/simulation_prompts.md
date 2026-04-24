## Let me give you the current context:

- in

api.py
I have a flask application that performs two operation: request and teardown. The operations are lightpath establishment and teradown.

- the application is simulated by the

simulator.py
with the configuration

sim_config.py
.

- the main purpose of this simulation is to test my opticalcontroller path blocking probability. Now the question is, how the whole operation is performed.
- the application has graphical views but for simulation some functions are extracted for API execution through

api.py

- when the simulation is run, it calles the APIs and generates Poisson process to generate traffic.
- when a request is sent it calls

topology.py
: find_path() function and then generates a graph to find a suitable path. In the first simulation I filtered the OCH and OMS and checked if they are full. If they are full those links are removed and then the graph is generated. This ensured that every request will find a fresh graph to search a path.

- also from a source to destination there are so many parallel parts. If the links/edges are of OCH type then they cannot be re-used where OMS can be until 701 slots are full.
- now I am trying to test that if I don't filter the ports it will give me bad results because the paths will be full and the request will be rejected at commit_slot() function in

helpers.py
.

- for this simulation I wanted that, if a dijkstra path is not found then it will go to all available path calculation in

topology.py
find_path() function.

- see what happens in find_path() function. The dijkstra path is calculated first and then "selected_path" is checked and upon True it returns the path_result. But if it is not True then it comes to G_simple = nx.Graph(G) and adds allowed hops and finally simple_node_paths = list(nx.all_simple_paths(
  G_simple, source=src_dev, target=dst_dev, cutoff=dynamic_cutoff)) computed.
- this must add additional hop to the dijkstra path and find other paths. In that case it can find several paths from where it chooses one and then expands to parallel paths and displays the available options.
- but right now I found another issue. all_paths usually generates a collection of path whereas for RSA we need one single path object.
- I don't know what is happening in that case.

Can you check?

## Nice catch. Let me discuss this further:

- for example I have one dijkstra and also one from all_paths.
- is there any code that will use the second path if dijkstra if RSA fails?

YES it does.

## Now that you have made the changes let's discuss the next phase:

- we know that from dijkstra path collection we are performing first-fit. And then from the parallel paths we are also doing first-fit.
- but in all_paths it is already a collection. Which one is selected then which parallel one is selected?

Loops through all paths and then selects the first one that succeeds RSA.

## Got it, why don't we do something like this to ease the execution:

- modify the find_path function so that it first can calculate the dijkstra and then for all the dijkstra path it will calculate the parallel paths, then it will find all_paths and then for each path it will again calculate the parallel paths. Finally it will generate a large big path collection.
- that collection will be sent to the @beautifulMentionas response. Then it will loop through to check each path for RSA.
- But before performing RSA, it will check each link if it's free. Both OCH and OMS should not be FULL
- after finding a path it will perform the RSA and slot commit.
- if not found a path then it should be blocked as "no path found"
- if the path is okay but slots are not available then it is a spectral block

Does it make sense? Ask me questions if you have any.

## Q1 — Parallel link enumeration (critical):

- nice catch about the exponential blow. Yes we will find multiple dijkstra and then each of them expanded to parallel paths. This is a huge number.
- the all_paths are also dijkstra_hop+allowed hop and they will also find a good number of paths later expanded to parallel paths. So, yes the exponential blow is correct.
  Let's do this instead:

- collect all dijkstra and then parallel of each of them
- collect all_paths with their parallel
- run a loop and check each path if any of the endpoint/port has an status FULL. If found remove the whole path
- finally after a long check we will get a refined collection of path.

Q2 — Physical check definition:

- if an endpoint is of type OCH it will always Free or FULL
- if an endpoint is of type OMS it can be FREE, IN_USE or FULL
- we remove a link if any of the endpoint is FULL

Q3 — Collection ordering:

- give dijkstra first priority

Q4: Scope

- i will put it in a new git branch so modify the file at once
- perform all these filteration in @beautifulMention
- after creating the collection make three options: first-fit that will send the first path, last fit that will send the last path, random pick that can send any path. I will choose one and run the simulation.
- finally @beautifulMentionit will receive one path and perform the rsa. If the rsa doesn't find slots then its a spectral block and if the path collection is empty it a no path found block

## Q1 — Strategy passing:

- yes I want to pass it from

sim_config.py

Q2 — Retry on collision:

- if you can keep it, its good

## Tell me what is this deduplication phase in topology.py : 411

expand_path() generates all combinations of parallel links along a node-level route. Consider this example:

Route: A → B → C
A→B has 2 parallel links: link-1, link-2
B→C has 2 parallel links: link-3, link-4
Combinations produced:
Path 1: [link-1, link-3]
Path 2: [link-1, link-4]
Path 3: [link-2, link-3]
Path 4: [link-2, link-4]
Phase 4 (FULL filter) removes paths where any link is FULL. Suppose link-3 is FULL:

Path 1: [link-1, link-3] ❌ removed
Path 2: [link-1, link-4] ✅ kept ← both use link-1 at hop A→B
Path 3: [link-2, link-3] ❌ removed
Path 4: [link-2, link-4] ✅ kept ← both use link-2 at hop A→B
Now Path 2 and Path 4 survive. They use different parallel links but travel the same node route. For RSA, as we discussed earlier, the specific parallel link chosen doesn't change the RSA outcome — RSA checks all device endpoints regardless.

Phase 4b catches this: it converts each path's link IDs into a frozenset and skips any path whose exact set of link IDs was already seen:

python
frozenset(['link-1', 'link-4']) # Path 2 → add to seen
frozenset(['link-2', 'link-4']) # Path 4 → different set → kept separately
In this case they are NOT duplicates because they genuinely use different physical links. A true duplicate would be if the same set of links appeared twice — which theoretically shouldn't happen from expand_path, but can happen because:

Phase 1 expands all dijkstra shortest paths (there may be several)
Phase 2 expands all simple paths up to cutoff
Some node-level routes from Phase 2 that were NOT skipped in the dijkstra_node_set dedup might still produce the same actual link combinations as Phase 1
So Phase 4b is a safety net against exact link-combination duplicates entering the RSA loop — no point running RSA twice on the physically identical path.

In short: frozenset(link_ids) uniquely fingerprints a path by its exact set of links. If two path objects carry the same fingerprint, only the first one is kept.

## Let's do another modification:

- right now the efficiency reduced but the probability is similar to my pre-computation step. - -- the blocking probability is less because we are sending filtered path which is highly probable to be free.
- i want to show that if the pre-computation is not performed then the blocking probability will increase.
- but it is also true that if the filtration is not done then each time first-fit will pick the same path.
- let's remove the OMS filter and keep the OCH filter only in @contextScopeItemMentionfind_paths()
- this will result more blocking because while performing the RSA the path will have less spectrum available through the links.

DONE

## Let's try to remove the exponential explode now

First we will discuss the plan, once come to the same page we will implement the solution.

- right now we have a better path selection logic but the efficiency of the controller drastically reduced.
- to establish 1 request the controller takes 3 seconds which is not acceptable
- let's try to remove the exponential path computation
- what happens if we query only those links whose endpoint status is not FULL
- if can perform this filtration at graph building level we can say for sure the current graph is with valid paths.

Is this logic accurate?

- yes but new constraints arised.

## Let me make things clear to you.

This is a refined version of my accepted logic. Since this version is giving less blocking probability I just want to remove the exponential explode from this one.

- let's discuss this further. So the final decision for graph building is that I want to filter out links endpoints where otn type is OCH and status is full. This will remove parallel links of OCH type because we cannot reuse them. But OMS links will not be filtered out. So, this makes G a graph where the only probability will be no spectrum available.

Are we on the same page for this?

- Yes. build_graph() modified in topology.py. OCH removed at query level.

## Parallel paths

- now we have a graph will no FULL OCH endpoints. But still we have parallel links.
- when dijkstra is computed is there any hop limit? Can you find out from the code?
  -- no there is no default cutoff from networkX.

- okay. This leaves us with the dijkstra path. But now we are sure that our dijkstra path is a valid path and it will not block the path unless there is spectral shortage. Is that clear?
  -- Yes.

- Yes, I know we still have the exponential blowup. This is what we are going to fix. Be with me, we will reach there.
- now let's modify the dijkstra so that after calculating the dijkstra we can have several path of the same hop. Based on the strategy choose the first one/last one or random.
  -- Done.

- now we have one dijkstra node path after applying the strategy, is it a single path or a combination of parallel paths?
  -- single

- this means that later this node path is sent to : expanded = TopologyHelper.expand_path_first_valid(chosen_node_path, G) for parallel expansion right?
- in this function it traversing the graph again to find all parallel paths right? It is traversing the graph not the querying the database again, make sure of that.
  -- Graph not query.

- I can see in this expansion it is again checking the OCH and OMS types and status. But this is redundant because the graph is already filtered.
- what we should do here is that, we must calculate all the parallel paths and then select one as per the strategy here again too.
  -- done

- so how many paths we have right now in dijkstra_collection?
  -- one

- now let's come to all_paths_collection. As we already have on dijkstra path object we know the number of hops. then we added the extra allowed hops and calculated path based on those hops. So in simple_node_paths we have paths including the dijkstra and the new paths based on allowed hops right?
  -- yes. and after the skip, dijkstra node paths are removed.

- yes, and after the skip, dijkstra node paths are removed. But now that we have multple node paths again. We can apply the strategy like dijkstra here again, before expanding it to parallel paths.
- after choosing one, send that path object for the parallel expansion.
  -- done

- I can see you already applied strategy after the parallel expansion. So, finally we have two node paths in candidates and the exponential blow is gone.
  -- yes

- now I want to send these two paths: dijkstra as first and additional as second as a response to the api for performing rsa. then the rsa must be applied on dijkstra first and if failed on the second one. If I do so, do I need phase 4 and 5?
  -- no I don't. Applied logic in code.



