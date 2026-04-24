# About this versiom

V.2 is the modified version for the simulation. After receiving the comments from my professor I made several changes that affects the core logic. In this version we are not considering Transponders and parallel links of the ROADM device for bitmap intersection. The main misconception was this, that I was thinking from a ROADM to another ROADM if I have multiple fibers, they cannot re-use frequencies. But this is completely opposite. Multiple fibers are set, so that they aggregate bandwidth.

## Run a Simulation

To run a simulation you can check the configuration [here](./path_blocking/run_simulation.sh). One simple command is:

```bash
bash run_simulation.sh first-fit first-fit dijkstra True NSF_SPFF-SAFF
```
