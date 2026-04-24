# About this versiom

V.2 is the modified version for the simulation. After receiving the comments from my professor I made several changes that affects the core logic. In this version we are not considering Transponders and parallel links of the ROADM device for bitmap intersection. The main misconception was this, that I was thinking from a ROADM to another ROADM if I have multiple fibers, they cannot re-use frequencies. But this is completely opposite. Multiple fibers are set, so that they aggregate bandwidth.

## Run a Simulation

To run a simulation you can check the configuration [here](./path_blocking/run_simulation.sh). One simple command is:

```bash
# Usage: ./run_simulation.sh [PATH_STRATEGY] [SPECTRUM_STRATEGY] [PATH_TYPE] [PP_STRAT] [LINK_STUDY] [LOG_NAME]
bash run_simulation.sh first-fit first-fit both none True NSF_TEST
```

To test using python please run the following command from the desired directory:

```bash
python3 test.py request --src RDMca1 --dst RDMny --bitrate 100 --path_strategy first-fit --spectrum_strategy random --path_type dijkstra --parallelpath_strategy none
```
