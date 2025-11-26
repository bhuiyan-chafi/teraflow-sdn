# Activities

Activities in November. There was a file before with updates, but I accidentally deleted it. Whatever, this is something I do. Sometimes being structured sucks.

## Helpful commands

- Docker containers with IPs:

```bash
docker inspect -f '{{.Name}} - {{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $(docker ps -q)
```

- Rebuild Web Service:

```bash
docker build -t localhost:32000/tfs/webui:dev -f src/webui/Dockerfile .
docker push localhost:32000/tfs/webui:dev
kubectl rollout restart deployment/webuiservice -n tfs
```

- Rebuild Context Service:

```bash
docker build -t localhost:32000/tfs/context:dev -f src/context/Dockerfile .
docker push localhost:32000/tfs/context:dev
kubectl rollout restart deployment/contextservice -n tfs
```

- Rebuild Device Service:

```bash
docker build -t localhost:32000/tfs/device:dev -f src/device/Dockerfile .
docker push localhost:32000/tfs/device:dev
kubectl rollout restart deployment/deviceservice -n tfs
```
