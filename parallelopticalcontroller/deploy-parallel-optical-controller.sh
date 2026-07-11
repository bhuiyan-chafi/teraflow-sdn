#!/bin/bash
# Deploy parallelopticalcontroller service to a fresh TeraFlow ecosystem
# Use this script when the deployment does NOT yet exist in the cluster
# For code changes on an existing deployment, use build-parallel-optical.sh instead

echo "=== Deploying ParallelOpticalController to TeraFlow ==="

# Step 1: Build
echo "[1/5] Building Docker image..."
docker build -t localhost:32000/tfs/parallelopticalcontroller:dev -f src/parallelopticalcontroller/Dockerfile .
sleep 1

# Step 2: Push
echo "[2/5] Pushing image to local registry..."
docker push localhost:32000/tfs/parallelopticalcontroller:dev
sleep 1

# Step 3: Apply manifest (creates Deployment + Service in k8s)
echo "[3/5] Applying Kubernetes manifest..."
kubectl apply -f manifests/parallelopticalcontrollerservice.yaml -n tfs

# Step 4: Restart serviceservice so it picks up new env vars
echo "[4/5] Restarting serviceservice (env var discovery)..."
kubectl rollout restart deployment/serviceservice -n tfs

# Step 5: Restart webuiservice so "Optical View" nav link appears
echo "[5/5] Restarting webuiservice (nav link discovery)..."
kubectl rollout restart deployment/webuiservice -n tfs

echo "=== Done! Verify with: kubectl get pods -n tfs | grep parallel ==="
