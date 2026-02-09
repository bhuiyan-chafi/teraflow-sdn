# Parallel Optical Controller Development Guide

This document details the `parallelopticalcontroller` service in TeraFlowSDN.

## Overview

The Parallel Optical Controller is a custom service for implementing your own RSA (Routing and Spectrum Assignment) algorithm in TeraFlowSDN.

**Status**: ✅ Successfully deployed and running on **port 10075**

---

## Quick Deploy

```bash
cd /home/tfs/teraflow/teraflow-develop
./build_parallel_optical.sh
```

---

## Files Created/Modified

### New Files

| File | Purpose |
| ---- | ------- |
| `src/parallelopticalcontroller/__init__.py` | Module init with logging config |
| `src/parallelopticalcontroller/ParallelOpticalController.py` | Main Flask application (port 10075) |
| `src/parallelopticalcontroller/requirements.in` | Python dependencies |
| `src/parallelopticalcontroller/Dockerfile` | Docker build instructions |
| `manifests/parallelopticalcontrollerservice.yaml` | Kubernetes deployment & service |
| `build_parallel_optical.sh` | Build & deploy script |

### Modified Files

| File | Change |
| --- | --- |
| `proto/context.proto` | Added `SERVICETYPE_PARALLEL_OPTICAL = 14` |
| `src/common/Constants.py` | Added `PARALLELOPTICALCONTROLLER` enum + port 10075 |
| `src/common/Settings.py` | Added `is_deployed_paralleloptical()` function |
| `src/context/service/database/models/enums/ServiceType.py` | Added `PARALLEL_OPTICAL` ORM enum |
| `src/service/service/tools/ParallelOpticalTools.py` | HTTP client for parallelopticalcontroller |
| `src/service/service/ServiceServiceServicerImpl.py` | Handler for service_type=14 |
| `src/webui/service/__init__.py` | Exposed `is_deployed_paralleloptical()` to templates |
| `src/webui/service/templates/base.html` | Updated Optical View condition |

---

## Key Configuration

| Property | Value |
| --- | --- |
| **Port** | 10075 |
| **Service Type** | `SERVICETYPE_PARALLEL_OPTICAL = 14` |
| **Route Prefix** | `/ParallelOpticalTFS/` |
| **Entry Point** | `parallelopticalcontroller.ParallelOpticalController` |
| **imagePullPolicy** | `Always` |

---

## API Endpoints

| Method | Endpoint | Description |
| --- | --- | --- |
| GET | `/health` | Health check |
| GET | `/ParallelOpticalTFS/GetStatus` | Get controller status |
| GET | `/ParallelOpticalTFS/GetTopology/{ctx}/{topo}` | Sync topology from TFS |
| PUT | `/ParallelOpticalTFS/AddLightpath/{src}/{dst}/{bitrate}/{bidir}` | Create lightpath |

---

## Verify Deployment

```bash
# Check pod status
kubectl get pods -n tfs | grep parallel

# Check logs
kubectl logs deployment/parallelopticalcontrollerservice -n tfs --tail=20

# Internal connectivity test
kubectl exec deployment/parallelopticalcontrollerservice -n tfs -- wget -qO- http://localhost:10075/ParallelOpticalTFS/GetStatus
```

**Expected log output**:

```bash
INFO - Hello! Welcome to Parallel Optical Controller!
INFO - Starting Flask server on port 10075...
 * Serving Flask app "ParallelOpticalController" (lazy loading)
 * Running on http://0.0.0.0:10075/
```

---

## External Access (Ingress)

```bash
kubectl patch ingress tfs-ingress -n tfs --type=json \
  -p='[{"op": "add", "path": "/spec/rules/0/http/paths/-", 
        "value": {"backend": {"service": {"name": "parallelopticalcontrollerservice", "port": {"number": 10075}}}, 
                  "path": "/()(ParallelOpticalTFS/.*)", "pathType": "Prefix"}}]'
```

**Accessible at**: `http://<server-ip>/ParallelOpticalTFS/GetStatus`

---

## Database Migration

> [!CAUTION]
> After adding `SERVICETYPE_PARALLEL_OPTICAL`, the database needs the new enum value!

### Option 1: SQL Migration (Preserves Data)

```bash
./scripts/cockroachdb_client.sh
# Then run:
ALTER TYPE orm_servicetypeenum ADD VALUE 'PARALLEL_OPTICAL';
```

### Option 2: Database Reset (Loses Data)**

```bash
./redeploy-db.sh
```

---

## WebUI Integration

The "Optical View" navigation link appears when either `opticalcontrollerservice` OR `parallelopticalcontrollerservice` is deployed:

```html
{% if is_deployed_optical() or is_deployed_paralleloptical() %}
```

---

## Troubleshooting

### Rebuild after code changes

```bash
./build_parallel_optical.sh
```

### Pod not starting

```bash
kubectl describe pod -n tfs -l app=parallelopticalcontrollerservice
kubectl logs deployment/parallelopticalcontrollerservice -n tfs --previous
```
