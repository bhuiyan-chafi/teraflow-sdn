# Link Endpoint Mismatch Report

## Summary
The "Foreign Key Violation" error during Optical Link creation occurs when the system calculates a UUID from a provided name that does not match the UUID already stored in the database.

## Workflow Overview

1.  **User Action**: Uploads `1-Link.json` via Web UI (`/webui`).
2.  **Processing**:
    -   `routes.py` receives the file.
    -   `DescriptorLoader` processes the JSON logic.
    -   `ContextClient.SetOpticalLink` sends the data to the backend.
3.  **Database Insertion**:
    -   `ContextServiceServicerImpl.SetOpticalLink` calls `optical_link_set`.
    -   `optical_link_set` attempts to resolve `endpoint_uuid` for the link.

## The Problem: Name-Based UUID Generation

All UUIDs in the system are deterministic hashes based on specific inputs.

-   **Formula**: `UUID = hash(Topology_UUID / Device_UUID / Endpoint_Name)`
-   **The Mismatch**:
    -   **Creation Time**: Drivers often create endpoints using auto-discovered names (e.g., `port-11`) under specific Topologies.
    -   **Link Time**: If you provide `port-11` in `1-Link.json` without specifying a Topology, the system defaults to `admin`.
    -   **Result**: `hash("admin/Dev/port-11")` != `hash("optical/Dev/port-11")` (or whatever the original topology was).

## Successful Operation

The operation succeeds only if:
1.  **Using UUIDs**: You provide the **real UUID** string (e.g., `5bd0de8b...`) in the JSON. This bypasses the hashing logic and directly references the record.
2.  **Exact Match**: You provide the exact Name AND the exact Topology context used during device creation, resulting in an identical hash.

## Relevant Files

-   **Web UI Route**: `src/webui/service/main/routes.py`
-   **Descriptor Loader**: `src/common/tools/descriptor/Loader.py`
-   **Link Logic**: `src/context/service/database/OpticalLink.py`
-   **UUID Builder**: `src/context/service/database/uuids/_Builder.py`
