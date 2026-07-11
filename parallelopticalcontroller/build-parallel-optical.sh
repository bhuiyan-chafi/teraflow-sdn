#!/bin/bash
# if you face caching issue, please add --no-cache to the build command
docker build -t localhost:32000/tfs/parallelopticalcontroller:dev -f src/parallelopticalcontroller/Dockerfile .
sleep 1
docker push localhost:32000/tfs/parallelopticalcontroller:dev
sleep 1
# if you have change in the files names, or ports, or any other thing, please update the yaml file and push it again
# kubectl apply -f manifests/parallelopticalcontrollerservice.yaml -n tfs
# otherwise just restart the pod
kubectl rollout restart deployment/parallelopticalcontrollerservice -n tfs