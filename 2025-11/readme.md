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

- Watch namespaces:

```bash
watch -n 1 kubectl get all --all-namespaces
```

## Complete fresh Re-Deploy without purging microk8s and docker

```bash
# ... inside my_deploy.sh ...

# ----- CockroachDB ------------------------------------------------------------
# ...
# Enable flag for dropping database, if it exists.
export CRDB_DROP_DATABASE_IF_EXISTS="YES"  # <--- Change to YES

# Enable flag for re-deploying CockroachDB from scratch.
export CRDB_REDEPLOY="YES"                 # <--- Change to YES


# ----- QuestDB ----------------------------------------------------------------
# ...
# Enable flag for dropping tables if they exist.
export QDB_DROP_TABLES_IF_EXIST="YES"      # <--- Change to YES

# Enable flag for re-deploying QuestDB from scratch.
export QDB_REDEPLOY="YES"                  # <--- Change to YES
```

## Updated context.proto

Updated context.proto because `odtn-type` was missing in `EndPointName` message:

```proto
message EndPointName {
  EndPointId endpoint_id = 1;
  string device_name = 2;
  string endpoint_name = 3;
  string endpoint_type = 4;
  string odtn_type = 5;
}
```

Before generating `proto` message you have to activate the `pyenv` otherwise dependencies will be missing, and you won't be able to generate the code:

```bash
pyenv activate 3.9.16/envs/tfs
bash proto/generate_code_python.sh
```

## Testing the RSA computation isolated

The project is in `monster` which I am periodically syncing. Steps:

- installed python 3.9.16 which is available with the command python3.9
- used docker and docker compose for the `flask` app
