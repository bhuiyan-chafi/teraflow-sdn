# Development of OPENROADM driver for TeraflowSDN

We are progressing with the following targets:

1. `[2025-10-08]` ~ Started with our existing ROADM containers in docker. The first target is to make some scripts for reading device data and export them in `json` and `xml` which is completed on `[2025-10-13]`.

2. `[2025-10-14]` ~ Adding features(scripts) to add, edit and delete configurations(ports specifically).

3. [*] ~ Study `ONOS` how the configuration is added to the devices.

- Is the discovery automatic?
- How the ports are assigned?
- Difference between the circuit-pack ports and physical links.
- any additional information*

## Creating the virtual environemnt

We are keeping the same `venv` version that teraflow official docs suggested.

```bash
pyenv virtualenv 3.9.16 openroadm
pyenv local 3.9.16/envs/openroadm
pyenv activate 3.9.16/envs/openroadm
pip install -r requirements.txt
```

## Initiating a connection and read the ROADM device

```bash
python InitiateConnectionSSH.py
```

### Getting filtered outputs

[2025-10-13] we added scripts to filter device configuration(info, interfaces, physical-links and ports). The codebase can be found [in this folder](./scripts/)
