# Deploying OpticalController Service in TeraFlowSDN

## Quick Start

```bash
cd /home/tfs/teraflow/teraflow-develop

# Build the image
docker build -t localhost:32000/tfs/opticalcontroller:dev -f src/opticalcontroller/Dockerfile .

# Push to local registry
docker push localhost:32000/tfs/opticalcontroller:dev

# Deploy to Kubernetes
kubectl apply -f manifests/opticalcontrollerservice.yaml -n tfs

# CRITICAL: Restart ServiceService to pick up new environment variables!
kubectl rollout restart deployment/serviceservice -n tfs
```

> [!CAUTION]
> **You MUST restart ServiceService after deploying OpticalController!**  
> Kubernetes injects service discovery env vars only at pod startup. Without restart, ServiceService won't detect OpticalController.

## Verify Integration

### 1. Check OpticalController pod is running

```bash
kubectl get pods -n tfs | grep optical
# Expected: opticalcontrollerservice-xxx   1/1     Running
```

### 2. Check ServiceService has optical environment variables

```bash
kubectl exec -n tfs deployment/serviceservice -- env | grep OPTICAL
# Expected: OPTICALCONTROLLERSERVICE_SERVICE_HOST=10.x.x.x
#           OPTICALCONTROLLERSERVICE_SERVICE_PORT_GRPC=10060
```

If the above returns empty, restart serviceservice:

```bash
kubectl rollout restart deployment/serviceservice -n tfs
```

### 3. View OpticalController logs

```bash
kubectl logs deployment/opticalcontrollerservice -n tfs --tail=50
```

## Access the API

### External/Remote Access (via Ingress)

By default, OpticalController is only accessible within the cluster. To access it externally (e.g., from `131.114.54.72/OpticalTFS/`), add an ingress rule:

```bash
kubectl patch ingress tfs-ingress -n tfs --type=json \
  -p='[{"op": "add", "path": "/spec/rules/0/http/paths/-", 
        "value": {"backend": {"service": {"name": "opticalcontrollerservice", "port": {"number": 10060}}}, 
                  "path": "/()(OpticalTFS/.*)", "pathType": "Prefix"}}]'
```

**Now accessible at**:

- `http://<your-server-ip>/OpticalTFS/GetLightpaths`
- `http://<your-server-ip>/OpticalTFS/GetOpticalBands`
- `http://<your-server-ip>/OpticalTFS/GetLinks`

### Local Access (Port Forward)

For local development/testing:

```bash
kubectl port-forward -n tfs deployment/opticalcontrollerservice 10060:10060
# Then open: http://localhost:10060/
```

### Direct API Access (from within cluster)

```bash
# From any pod in the tfs namespace:
curl http://opticalcontrollerservice:10060/OpticalTFS/GetLightpaths
curl http://opticalcontrollerservice:10060/OpticalTFS/GetOpticalBands
curl http://opticalcontrollerservice:10060/OpticalTFS/GetLinks
```

### REST API Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/OpticalTFS/GetTopology/{ctx}/{topo}` | Sync topology from TFS |
| PUT | `/OpticalTFS/AddFlexLightpath/{src}/{dst}/{bitrate}/{bidir}` | Create flex lightpath |
| PUT | `/OpticalTFS/AddLightpath/{src}/{dst}/{bitrate}/{bidir}` | Create fixed lightpath |
| GET | `/OpticalTFS/GetLightpaths` | List all lightpaths |
| GET | `/OpticalTFS/GetOpticalBands` | List all optical bands |
| GET | `/OpticalTFS/GetOpticalBand/{id}` | Get specific optical band |
| GET | `/OpticalTFS/GetLinks` | Get link slot status |
| DELETE | `/OpticalTFS/DelFlexLightpath/...` | Delete flex lightpath |
| DELETE | `/OpticalTFS/DelLightpath/...` | Delete fixed lightpath |

## View logs

```bash
kubectl logs deployment/opticalcontrollerservice -n tfs --tail=50
```

## Test if running

```bash
kubectl exec -n tfs deployment/serviceservice -- env | grep OPTICAL
```

## Expected Log Output

When running correctly, you'll see:

- Serving Flask app "OpticalController" (lazy loading)
- Environment: production
- Debug mode: on
- Running on <http://0.0.0.0:10060/> (Press CTRL+C to quit)

## Troubleshooting

### ErrImageNeverPull

If you see `ErrImageNeverPull`, the manifest has `imagePullPolicy: Never`.

**Solution**: Change to `IfNotPresent` in `manifests/opticalcontrollerservice.yaml` line 33:

```yaml
imagePullPolicy: IfNotPresent
```

Then reapply:

```bash
kubectl apply -f manifests/opticalcontrollerservice.yaml -n tfs
kubectl rollout restart deployment/opticalcontrollerservice -n tfs
```

### Pod CrashLoopBackOff

Check logs for Python errors:

```bash
kubectl logs deployment/opticalcontrollerservice -n tfs --previous
```

### Rebuild After Code Changes

```bash
docker build -t localhost:32000/tfs/opticalcontroller:dev -f src/opticalcontroller/Dockerfile .
docker push localhost:32000/tfs/opticalcontroller:dev
kubectl rollout restart deployment/opticalcontrollerservice -n tfs
```

## Architecture Notes

| Property | Value |
|----------|-------|
| Port | 10060 (REST API) |
| Protocol | HTTP (not gRPC) |
| Image | `localhost:32000/tfs/opticalcontroller:dev` |
| Service Name | `opticalcontrollerservice` |
| Entry Point | `python -m opticalcontroller.OpticalController` |

## Related Files

- Manifest: `manifests/opticalcontrollerservice.yaml`
- Dockerfile: `src/opticalcontroller/Dockerfile`
- Main Code: `src/opticalcontroller/OpticalController.py`
- RSA Algorithm: `src/opticalcontroller/RSA.py`

---

## Data Storage (Important!)

> [!WARNING]
> **OpticalController uses IN-MEMORY storage, NOT a database!**

The RSA class stores all lightpaths and optical bands in Python dictionaries:

- `RSA.db_flows` - All lightpaths
- `RSA.optical_bands` - All optical bands
- `RSA.links_dict` - Link slot availability

**Implications:**

1. **Data persists until pod restart** - Even if you delete a service in TFS, OpticalController still shows it
2. **Pod restart clears ALL data** - Topology must be re-synced via `GetTopology`
3. **NOT synced with TFS database** - These are two separate data stores

### Clear Stale Data

To reset OpticalController state:

```bash
kubectl rollout restart deployment/opticalcontrollerservice -n tfs
```

After restart, the topology will be re-synced on the next service request.

### HTML Template (`/index`)

The `index.html` template route exists in code but **no templates folder exists** in the repository. This route will fail with a template not found error.
