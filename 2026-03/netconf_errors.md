# NETCONF "Not Connected" Error — Diagnosis & Fix

**Date:** 2026-03-02  
**Files Modified:** `src/device/service/drivers/oc_driver/OCDriver.py`, `src/device/service/driver_api/DriverInstanceCache.py`

## Problem

After migrating the emulator server from Debian Bullseye to Ubuntu 22.04 and recreating Docker containers, `AddDevice` fails with:

```
ncclient.transport.errors.TransportError: Not connected to NETCONF server
```

**Observed behavior:**
- Adding devices (single or bulk) via JSON descriptor fails
- Devices get stored in DB with names only — no endpoints or config
- Deleting a failed device also errors on first attempt, but succeeds on second
- After successful deletion, re-adding the device works

## Root Cause

The `DriverInstanceCache` holds stale NETCONF connections in memory. Four code points form the failure chain:

1. **`DriverInstanceCache.get()`** returns cached `OCDriver` instances without checking if the underlying NETCONF connection is alive.

2. **`OCDriver.Connect()`** returns `True` immediately when `__started` is already set — it never validates whether the SSH session is still active.

3. **`NetconfSessionHandler.disconnect()`** calls `close_session()` on a dead connection, which throws `TransportError`. This prevents clean device deletion on the first attempt. After `pop()` removes the driver from cache, the second delete succeeds — and re-adding creates a fresh connection.

4. **`get_driver()`** returns cached drivers **without calling `Connect()`**. Even after fixing `Connect()` with reconnection logic, cached drivers bypass it entirely — the health check is never triggered.

**Why delete-then-add fixes it:** `DriverInstanceCache.delete()` calls `pop()` (removes from cache) before `Disconnect()`. Even if `Disconnect()` fails, the stale entry is gone. The next `AddDevice` creates a fresh driver with a new NETCONF session.

## Changes Applied

All changes are marked with `[CHAFI-THESIS-START]` / `[CHAFI-THESIS-END]` blocks.

### 1. `NetconfSessionHandler.is_connected()` — New method (line 121)

Checks if the underlying ncclient session is still alive via `self.__manager.connected`.

```python
# [CHAFI-THESIS-START] - Check if NETCONF session is still alive
def is_connected(self) -> bool:
    with self.__lock:
        if self.__manager is None:
            return False
        return self.__manager.connected
# [CHAFI-THESIS-END]
```

### 2. `NetconfSessionHandler.disconnect()` — Made resilient (line 108)

Wraps `close_session()` in try/except so dead connections don't throw. Always clears the `__connected` flag.

```python
def disconnect(self):
    if not self.__connected.is_set():
        return
    with self.__lock:
        # [CHAFI-THESIS-START] - Gracefully handle already-dead connections
        try:
            self.__manager.close_session()
        except Exception:
            pass
        finally:
            self.__connected.clear()
        # [CHAFI-THESIS-END]
```

### 3. `OCDriver.Connect()` — Stale session detection & reconnect (line 338)

When `__started` is already set, validates the connection via `is_connected()`. If stale, disconnects and reconnects automatically.

```python
def Connect(self) -> bool:
    with self.__lock:
        if self.__started.is_set():
            # [CHAFI-THESIS-START] - Detect stale NETCONF sessions and reconnect
            if self.__netconf_handler.is_connected():
                return True
            self.__logger.warning(
                '[CHAFI-THESIS] NETCONF session is stale, reconnecting...')
            try:
                self.__netconf_handler.disconnect()
            except Exception:
                pass
            self.__netconf_handler.connect()
            self.__logger.info(
                '[CHAFI-THESIS] NETCONF session reconnected successfully')
            # [CHAFI-THESIS-END]
            return True
        self.__netconf_handler.connect()
        self.__scheduler.start()
        self.__started.set()
        return True
```

### 4. `get_driver()` — Validate cached drivers (DriverInstanceCache.py, line 86)

Calls `Connect()` on cached drivers so the stale session detection in `OCDriver.Connect()` is triggered.

```python
    driver : _Driver = driver_instance_cache.get(device_uuid)
    # [CHAFI-THESIS-START] - Validate cached driver connection before returning
    if driver is not None:
        LOGGER.info('[CHAFI-THESIS] Cached driver found for device(%s), validating connection...', device_uuid)
        driver.Connect()
        return driver
    # [CHAFI-THESIS-END]
```

## Verification — Confirmed ✅

After rebuilding and redeploying the device service:
1. Database reset without restarting device service — devices added successfully
2. Bulk device addition works without stale connection errors
3. Device deletion succeeds on first attempt even if the container is down
