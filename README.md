# Thesis overview

The repo contains various aspects of my thesis. Specially the demo project that I did before the main integration in TeraflowSDN can be tested by the following commands:

```bash
git clone https://github.com/bhuiyan-chafi/teraflow-sdn.git
cd teraflow-sdn/2025-11/rsa_project/
# if you are in mac with latest version of docker and docker compose
docker compose up --build
# if you are using older versions in linux
docker-compose up --build
```

The web application is a flask app which can be accessed through: [localhost:3000/](localhost:3000/)

## Main Integration

Please read the [document here](./main/TFS_Integration.md).

## Test the system with descriptors

Please find the [descriptors here](./2026-02/topo_2_5_2/).
