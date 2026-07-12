# Test Case

```bash
python3 test.py request --src RDMwa --dst RDMtx --bitrate 400 --path_strategy random --spectrum_strategy first-fit --path_type dijkstra --parallelpath_strategy none
```

## Dijkstra Shortest Paths: 3 Hops

- RDMwa -> RDMca1 -> RDMca2 -> RDMtx
- RDMwa -> RDMut -> RDMco -> RDMtx

And they are disjoint too. 

## Dijkstra Shortest Path+1 paths: 4 Hops

- RDMwa -> RDMca1 -> RDMca2 -> RDMtx
- RDMwa -> RDMut -> RDMco -> RDMtx
- RDMwa -> RDMca1 -> RDMut -> RDMco -> RDMtx
- RDMwa -> RDMut -> RDMca1 -> RDMca2 -> RDMtx
- RDMwa -> RDMut -> RDMmi -> RDMil -> RDMtx
- RDMwa -> RDMny -> RDMmi -> RDMil -> RDMtx
- RDMwa -> RDMny -> RDMpa -> RDMil -> RDMtx

## Requests

1. [Phase 2] chosen single link path: RDMwa -> RDMny -> RDMpa -> RDMil -> RDMtx via links [RDMwa->RDMny_3, RDMpa->RDMny_17, RDMil->RDMpa_15, RDMtx->RDMil_12]
2. [Phase 2] chosen single link path: RDMwa -> RDMut -> RDMmi -> RDMil -> RDMtx via links [RDMwa->RDMut_2, RDMut->RDMmi_8, RDMil->RDMmi_14, RDMtx->RDMil_12]
3. [Phase 2] chosen single link path: RDMwa -> RDMca1 -> RDMca2 -> RDMtx via links [RDMwa->RDMca1_1, RDMca1->RDMca2_4, RDMca2->RDMtx_6]

