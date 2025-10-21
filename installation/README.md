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

Next is our deployment which you can [find here](./deployment.md).
