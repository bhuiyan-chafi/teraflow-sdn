# Introduction

Here in this discussion we have discussed the installation process and the problems we faced. We have followed [this tutorial](./files/TFS_DEV.pdf) provided by the official community.

## Upgrading the Ubuntu Distribution

```bash
sudo apt-get update -y
sudo apt-get dist-upgrade -y
```

Install the prerequisites:

```bash
sudo apt-get install -y ca-certificates curl gnupg lsb-release snapd jq
```

Install and configure docker:

```bash
sudo apt-get install -y docker.io docker-buildx

if [ -s /etc/docker/daemon.json ]; then cat /etc/docker/daemon.json; else echo '{}'; fi \
    | jq 'if has("insecure-registries") then . else .+ {"insecure-registries": []} end' -- \
    | jq '."insecure-registries" |= (.+ ["localhost:32000"] | unique)' -- \
    | tee tmp.daemon.json
sudo mv tmp.daemon.json /etc/docker/daemon.json
sudo chown root:root /etc/docker/daemon.json
sudo chmod 600 /etc/docker/daemon.json

sudo systemctl restart docker
```

Install Microk8s

```bash
# Install MicroK8s
sudo snap install microk8s --classic --channel=1.29/stable

# Wait until MicroK8s is ready
sudo microk8s.status --wait-ready

# Create alias for command "microk8s.kubectl" to be usable as "kubectl"
sudo snap alias microk8s.kubectl kubectl

# Create alias for command "microk8s.helm3" to be usable as "helm3"
sudo snap alias microk8s.helm3 helm3
```

**Make sure `ufw` is `inactive`**, we are using for testing purpose so firewall at this moment is not crucial. But if you want to keep it active:

```bash
sudo ufw status
# If ufw is active, install following rules to enable access pod-to-pod and pod-to-internet
sudo ufw allow in on cni0 && sudo ufw allow out on cni0
sudo ufw default allow routed
```

Add user to the docker and microk8s groups:

```bash
sudo usermod -a -G docker $USER
sudo usermod -a -G microk8s $USER
mkdir -p $HOME/.kube
sudo chown -f -R $USER $HOME/.kube
sudo reboot
microk8s config > $HOME/.kube/config

microk8s.status --wait-ready #should be running
```

Enable community addons:

```bash
microk8s.enable community
#you will face error
git config --global --add safe.directory /snap/microk8s/current/addons/community/.git
microk8s.enable community
microk8s.enable dns
microk8s.enable hostpath-storage
microk8s.enable ingress
microk8s.enable registry
```

For scalable production deployments consider enabling addons:

- linkerd: deploys the linkerd service mesh used for load balancing among replicas
- prometheus: set of tools that enable TFS observability through per-component instrumentation
- metrics-server: deploys the Kubernetes metrics server for API access to service metrics

```bash
microk8s.enable prometheus
microk8s.enable metrics-server
microk8s.enable linkerd
```

In another tab periodically check K8 resources and addons:

```bash
watch -n 1 kubectl get all --all-namespaces
watch -n 1 microk8s.status --wait-ready
```

**Important:** Enabling some of the addons might take few minutes. Do not proceed with next steps until the addons are ready. Otherwise, the deployment might fail. To confirm everything is up and running:

- Periodically Check the status of Kubernetes until you see the addons [dns, ha-cluster, helm3, hostpath-storage, ingress, linkerd, metrics-server, prometheus, registry, storage] in the enabled block.
- Periodically Check Kubernetes resources until all pods are Ready and Running.
- If it takes too long for the Pods to be ready, we observed that rebooting the machine may help.
- If linkerd is enabled, run the following commands to add the alias to the command, and validate it is working correctly:

```bash
sudo snap alias microk8s.linkerd linkerd
linkerd check
```

If metrics-server is enabled, run the following command to validate it is working correctly:

```bash
kubectl top pods --all-namespaces
```

## In case just in case

I hope this day never come -_-

Find below some additional commands you might need while you work with MicroK8s:

```bash
microk8s.stop  # stop MicroK8s cluster (for instance, before power off your computer)
microk8s.start # start MicroK8s cluster
microk8s.reset # reset infrastructure to a clean state, will fail for mode than 1 node
```

If you are executing the commands above(you are done bro). I hope this day never come for me, god is merciful.

## But this day came for me :) 25-09-2025 and I am having fun :(

The easiest solution is to remove microK8 completely and re-install.

```bash
sudo snap remove microk8s --purge
sudo apt-get remove --purge docker.io docker-buildx
sudo rm -rf /etc/docker
sudo reboot
```

You can fix one by one but it keeps coming. So at last I stopped and pursued the easiest solution. This saves time.

`It is very normal to change the HOSTNAME of your node(vm, physical-machine)` but remember this! If you were running `pods` before and you have changed the hostname, most likely everything will fail because K8 will consider the hostname with new name as a second node. So, if you are not actually on a second node remove the previous node and reset.

```bash
microk8s kubectl get nodes -o wide
microk8s remove-node node-name
```

### to remove all pods and namspaces

```bash
microk8s.kubectl delete pods --all --all-namespaces
microk8s.kubectl delete all --all --all-namespaces
```

### microk8s.enable ingress fails

Yes, in second build it fails because there were existing API configurations based on previous node. Since, this is the same machine but with different name we have to reset the API addon.

```bash
#remove
microk8s.kubectl delete validatingwebhookconfiguration nginx-ingress-microk8s-admission --ignore-not-found
microk8s.kubectl delete mutatingwebhookconfiguration  nginx-ingress-microk8s-admission --ignore-not-found
#reset
microk8s.kubectl get ns ingress -o json \
| jq '.spec.finalizers=[]' \
| microk8s.kubectl replace --raw /api/v1/namespaces/ingress/finalize -f -
#verify
microk8s.kubectl get ns ingress # should return NotFound
microk8s.enable ingress
```

Then repeat the steps before.

## microk8s.enable registry fails :(

```text
Error from server (Forbidden): error when creating "STDIN": persistentvolumeclaims "registry-claim" is forbidden: unable to create new content in namespace container-registry because it is being terminated.
```

Well this was a very big mess. But we solved it with our friend chatgpt :). Behold and go through if you are already reading:

```bash
#try to delete namespaces
for r in $(microk8s.kubectl api-resources --namespaced -o name); do
  microk8s.kubectl -n container-registry delete "$r" --all --ignore-not-found >/dev/null 2>&1
done
#check which pv(s) are running
microk8s.kubectl get pv -o wide
#remove them
microk8s.kubectl delete pv NAME
#check for existing volume
sudo ls -1 /var/snap/microk8s/common/default-storage
#if any of them are mounted you have to unmount them
mount | grep /var/snap/microk8s/common/default-storage || true
#remove them
sudo rm -rf /var/snap/microk8s/common/default-storage/NAME
#check for existing registry
microk8s.kubectl get ns container-registry
#in my case it was still stuck at Terminating
for r in $(microk8s.kubectl api-resources --namespaced -o name); do
  microk8s.kubectl -n container-registry delete "$r" --all --ignore-not-found >/dev/null 2>&1
done

for r in $(microk8s.kubectl api-resources --namespaced -o name); do
  microk8s.kubectl -n container-registry get "$r" -o name 2>/dev/null \
  | xargs -r -I{} microk8s.kubectl -n container-registry patch {} \
      --type=merge -p '{"metadata":{"finalizers":[]}}' >/dev/null 2>&1
done

#still it was there so I had to hard reset
microk8s.kubectl get ns container-registry -o json >/tmp/ctrreg-ns.json
python3 - <<'PY'
import json; p="/tmp/ctrreg-ns.json"; d=json.load(open(p))
d.setdefault("spec",{})["finalizers"]=[]
json.dump(d, open(p,"w"))
PY
microk8s.kubectl replace --raw /api/v1/namespaces/container-registry/finalize -f /tmp/ctrreg-ns.json
#finally it was gone
microk8s.kubectl get ns container-registry || echo "container-registry namespace removed"
microk8s.enable registry
```

## microk8s.enable prometheus fails :(

```text
Release "kube-prom-stack" does not exist. Installing it now.
Error: create: failed to create: secrets "sh.helm.release.v1.kube-prom-stack.v1" is forbidden: unable to create new content in namespace observability because it is being terminated.
```

Let's fix this as well,

```bash
# 1) Try to remove any Helm leftovers in the ns (quiet if none)
microk8s.kubectl -n observability delete secret -l owner=helm --ignore-not-found
microk8s.kubectl -n observability delete configmap -l owner=helm --ignore-not-found
microk8s.kubectl -n observability delete secret sh.helm.release.v1.kube-prom-stack.v1 --ignore-not-found

# 2) Delete EVERYTHING in the namespace (even if it looks empty)
for r in $(microk8s.kubectl api-resources --namespaced -o name); do
  microk8s.kubectl -n observability delete "$r" --all --ignore-not-found >/dev/null 2>&1
done

# 3) If anything still exists with finalizers, strip them
for r in $(microk8s.kubectl api-resources --namespaced -o name); do
  microk8s.kubectl -n observability get "$r" -o name 2>/dev/null \
  | xargs -r -I{} microk8s.kubectl -n observability patch {} \
      --type=merge -p '{"metadata":{"finalizers":[]}}' >/dev/null 2>&1
done

# 4) Force-finalize the namespace
microk8s.kubectl get ns observability -o json >/tmp/obs-ns.json
python3 - <<'PY'
import json; p="/tmp/obs-ns.json"; d=json.load(open(p))
d.setdefault("spec",{})["finalizers"]=[]  # remove the 'kubernetes' finalizer
json.dump(d, open(p,"w"))
PY
microk8s.kubectl replace --raw /api/v1/namespaces/observability/finalize -f /tmp/obs-ns.json

# 5) Verify it's gone
microk8s.kubectl get ns observability || echo "observability namespace removed"

#enable now
microk8s.enable prometheus
```

Next is our deployment which you can [find here](./deployment.md).
