# Plan A: One Valid Path Per Node Sequence

## Problem

With parallel optical links, `expand_path(node_path, G, None, None)` generates **all combinatorial
combinations** of parallel links across every hop using backtracking.

**Example:** a 5-hop node path with 3 parallel links per hop:
```
3 x 3 x 3 x 3 x 3 = 3^5 = 243 expanded paths
```
All 243 paths follow the **same route** through the same nodes — they only differ in which
parallel link is picked at each hop. Multiply by dozens of node sequences and we get thousands
of paths, causing the controller pod to crash (OOM) and wiping in-memory `db_flows`.

With single links this was never a problem (1^N = 1 expansion per node sequence).

## Why Plan A Works

The RSA computation (`TopologyHelper.perform_rsa`) already handles parallel links internally:
- It checks **all endpoints/ports** on each device along the route
- It performs **inter-node frequency intersection** to ensure no spectrum is reused
- The specific parallel link chosen at each intermediate hop does NOT affect RSA results

What matters for alternative path suggestions is **route diversity** (different node sequences),
not parallel link permutations within the same route.

## Solution

For each unique node sequence, keep only **ONE valid expanded path** (the first valid one
found by backtracking) instead of all permutations.

**Result:**
- If there are 20 distinct node sequences → 20 alternative paths (instead of 13,000+)
- `HIGHEST_HOP` stays at 15 → long paths are preserved
- No combinatorial explosion → no crash
- RSA works exactly the same

## Implementation

### File: `src/parallelopticalcontroller/topology.py`

### Step 1: Create `expand_path_first_valid` function

Add a new function after the existing `expand_path` (~line 697). This is a variant that uses
the same backtracking logic but **stops as soon as one valid path is found**.

```python
def expand_path_first_valid(node_path, graph_to_use, src_index, dst_index):
    """
    Same as expand_path but returns only the FIRST valid path found.
    Used for alternative paths where we need one representative per node sequence.
    """
    result = [None]  # mutable container for closure

    def backtrack(index, current_edge_path):
        if result[0] is not None:
            return  # already found a valid path, stop

        if index == len(node_path) - 1:
            # same validity check as expand_path (OCH must be FREE, OMS can be shared)
            is_valid = True
            for link in current_edge_path:
                transport = link.get('transport_type', '')
                used = link.get('used', False)
                standardized = get_standardized_transport_type(transport)
                if (standardized == TransportTypeEnum.OCH or standardized == TransportTypeEnum.NA) and used:
                    is_valid = False
                    break

            if is_valid:
                result[0] = {
                    'links': list(current_edge_path),
                    'is_valid': True,
                    'node_path': node_path,
                    'hops': len(current_edge_path)
                }
            return

        u = node_path[index]
        v = node_path[index + 1]

        if not graph_to_use.has_edge(u, v):
            return

        edges = graph_to_use[u][v]
        for key, attr in edges.items():
            if result[0] is not None:
                return  # early exit from loop too

            # same port/direction logic as expand_path
            # same src_index/dst_index constraint logic
            # ... (mirrors expand_path lines 648-678)

            current_edge_path.append({...})  # same link dict as expand_path
            backtrack(index + 1, current_edge_path)
            current_edge_path.pop()

    backtrack(0, [])
    return result[0]
```

Key difference from `expand_path`:
- Uses `result[0]` as early-stop flag
- Only appends paths where `is_valid=True` (skips invalid ones entirely)
- Returns `None` or a single path dict

### Step 2: Update the all_paths loop in `find_paths`

Replace the current loop (~line 554):
```python
# BEFORE:
for i, node_path in enumerate(simple_node_paths):
    edge_paths = expand_path(node_path, G, None, None)
    valid_edge_paths = [p for p in edge_paths if p.get('is_valid', False)]
    paths_result['all_paths'].extend(valid_edge_paths)
    total_edge_paths += len(valid_edge_paths)
```

With:
```python
# AFTER:
for i, node_path in enumerate(simple_node_paths):
    first_valid = expand_path_first_valid(node_path, G, None, None)
    if first_valid:
        paths_result['all_paths'].append(first_valid)
        total_edge_paths += 1
```

### What stays unchanged

- `expand_path` — original function untouched, dijkstra section still uses it
- `ParallelOpticalController.py` — no changes needed
- `RSAHelper.py` / `RSA.py` — RSA computation unaffected
- `HIGHEST_HOP` — stays at 15
- `routes.py` — already fixed `acquired_path_type = None` default
- All `[CHAFI-CRASH-DEBUG]` logs — stay for verification

## Verification

1. Rebuild: `bash build-parallel-optical.sh`
2. Test **single-link topology**: perform RSA → dijkstra + alternative paths work as before
3. Test **parallel-link topology**: perform RSA → no crash, one path per node sequence
4. Check logs: `bash scripts/show_logs_parallelopticalcontroller.sh`
   - All `[CHAFI-CRASH-DEBUG]` steps should complete
   - `[CHAFI-TIMING]` log should show reasonable times
