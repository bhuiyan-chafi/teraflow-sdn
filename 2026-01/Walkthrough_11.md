# Walkthrough: Task 11 - Reference Bitmap RSA Computation

## Overview

Task 11 fundamentally redesigns the RSA (Routing and Spectrum Assignment) computation to use a **reference bitmap** that aligns all endpoints to a unified frequency range. This solves three critical problems:

1. **Misaligned frequency ranges** between endpoints (e.g., C-band vs CL-band)
2. **Missing parallel endpoint constraints** at the device level (ROADM WSS ports)
3. **Incorrect slot granularity** (12.5 GHz instead of ITU standard 6.25 GHz)

---

## Motivation

### Problem 1: Cannot Mix Different Bands

**Scenario**: Path with mixed band capabilities

```
TP1 (C-band: 191.556-195.938 THz, 701 slots)
  ↓
RDM1 (CL-band: 188.450-195.938 THz, 1199 slots)
  ↓
RDM2 (CL-band: 188.450-195.938 THz, 1199 slots)
  ↓
TP2 (C-band: 191.556-195.938 THz, 701 slots)
```

**Current Implementation** (Task 3):

```python
# Hop 1: TP1 → RDM1
src_bitmap = TP1.bitmap_value  # 701 bits, represents 191.556-195.938 THz
dst_bitmap = RDM1.bitmap_value # 1199 bits, represents 188.450-195.938 THz
hop1_bitmap = src_bitmap & dst_bitmap  # ❌ WRONG: Misaligned frequency grids
```

**Issue**: Bit 0 of `src_bitmap` represents 191.556 THz, but bit 0 of `dst_bitmap` represents 188.450 THz. Direct intersection is meaningless.

**New Implementation** (Task 11):

```python
# Reference range: 188.450-195.938 THz (CL-band, 1199 slots)
src_aligned = align_to_reference(TP1, 188.450, 195.938)  # Pad with 498 zeros on left
dst_aligned = align_to_reference(RDM1, 188.450, 195.938) # No padding (already CL)
hop1_bitmap = src_aligned & dst_aligned  # ✅ CORRECT: Same frequency grid
```

### Problem 2: Missing Parallel Endpoint Constraints

**Scenario**: ROADM with multiple WSS ports

```
RDM1 Device (4 endpoints):
- port-10: In path, C-band, all available (11111111)
- port-11: Other path, C-band, slots 2-3 in use (11110011)
- port-12: Other path, C-band, slots 0-1 in use (11111100)
- port-13: Unused, CL-band, L-band portion in use
```

**Optical Constraint**: RDM1's WSS cannot output the same frequency from multiple ports. If port-11 uses slot 2, port-10 CANNOT use slot 2 on the same device.

**Current Implementation** (Task 3):

```python
# Only checks port-10 (path endpoint)
src_bitmap = port-10.bitmap_value  # 11111111 (all available)
# ❌ IGNORES port-11, port-12, port-13 constraints
```

**New Implementation** (Task 11):

```python
# Check ALL endpoints on RDM1
device_bitmap = port-10 & port-11 & port-12 & port-13
              = 11111111 & 11110011 & 11111100 & (CL constraints)
              = 11110000  # ✅ Only slots available on ALL ports
```

### Problem 3: Wrong Slot Granularity

**Current**:

```python
FLEX_GRID = 12.5  # GHz (WRONG - this is channel width, not slot granularity)
num_slots = ceil(50 Gbps / 12.5 GHz) = 4 slots
```

**ITU-T G.694.1 Standard**:

- **Channel Width**: 12.5 GHz (nominal spacing for fixed-grid)
- **Slot Granularity**: 6.25 GHz (flex-grid minimum spacing)

**Correct**:

```python
SLOT_GRANULARITY = 6.25  # GHz (ITU standard)
num_slots = ceil(50 Gbps / 6.25 GHz) = 8 slots
```

---

## Solution Architecture

### Step 1: Calculate Reference Frequency Range

**Collect All Unique Endpoints**:

```python
def rsa_bitmap_pre_compute(path_obj, graph):
    from models import OpticalLink, Endpoint
    
    # Extract unique endpoint IDs from path
    endpoint_ids = set()
    for link_info in path_obj['links']:
        link = OpticalLink.query.get(link_info['id'])
        if link.src_endpoint_id:
            endpoint_ids.add(link.src_endpoint_id)
        if link.dst_endpoint_id:
            endpoint_ids.add(link.dst_endpoint_id)
    
    # Query all endpoints
    endpoints = [Endpoint.query.get(eid) for eid in endpoint_ids]
    
    # Find widest frequency range
    _reference_min_freq = min([ep.min_frequency for ep in endpoints if ep.min_frequency])
    _reference_max_freq = max([ep.max_frequency for ep in endpoints if ep.max_frequency])
    
    logger.info(f"[RSA] Reference range: {_reference_min_freq / 1e12:.3f} - {_reference_max_freq / 1e12:.3f} THz")
```

**Example**:

```
Path endpoints:
- TP1-port1: C-band (191.556-195.938 THz)
- RDM1-port10: CL-band (188.450-195.938 THz)
- RDM2-port20: CL-band (188.450-195.938 THz)
- TP2-port2: C-band (191.556-195.938 THz)

Reference min = 188.450 THz (from CL-band endpoints)
Reference max = 195.938 THz (common to all)
Reference range = 188.450-195.938 THz
```

### Step 2: Detect Operational Band

**Use existing `OpticalBandHelper.detect_band()`**:

```python
band_info = OpticalBandHelper.detect_band(_reference_min_freq, _reference_max_freq)

_selected_min_freq, _selected_max_freq = band_info['frequency_range_hz']
# band_info['band_name'] = "C, L" (for CL-band)

SLOT_GRANULARITY_HZ = ITUStandards.SLOT_GRANULARITY.value  # 6250000000 Hz
reference_slots = int((_selected_max_freq - _selected_min_freq) / SLOT_GRANULARITY_HZ)

logger.info(f"[RSA] Detected band: {band_info['band_name']}-Band ({reference_slots} slots)")
```

**Example**:

```
Input: 188.450-195.938 THz
Detected band: CL_BAND
Selected range: 188.450-195.938 THz (standard CL range)
Reference slots: (195937500000000 - 188450000000000) / 6250000000 = 1199 slots
```

### Step 3: Bitmap Alignment Algorithm

**Core Function**:

```python
@staticmethod
def align_endpoint_to_reference(endpoint, _selected_min_freq, _selected_max_freq, SLOT_GRANULARITY_HZ):
    """
    Aligns endpoint bitmap to reference frequency range.
    
    Algorithm:
    1. Calculate frequency offset from reference minimum
    2. Convert offset to slot count
    3. Shift endpoint bitmap left by offset slots
    4. Zero-padding happens automatically (bits outside endpoint range remain 0)
    
    Example:
    Reference: CL-band (188.450-195.938 THz, 1199 slots)
    Endpoint: C-band (191.556-195.938 THz, 701 slots)
    
    Offset = 191.556 - 188.450 = 3.106 THz
    Offset slots = 3106000000000 / 6250000000 = 497.6 ≈ 498 slots
    
    Endpoint bitmap (701 bits):   111111111111111111111111...111
    Shift left by 498:            [000...000][111111111111111...111]
                                   ↑         ↑
                                   498 zeros 701 endpoint bits
    
    Result: 1199-bit aligned bitmap with correct frequency alignment
    """
    if not endpoint or not endpoint.min_frequency or not endpoint.max_frequency or not endpoint.bitmap_value:
        # Return all zeros (unavailable)
        reference_slots = int((_selected_max_freq - _selected_min_freq) / SLOT_GRANULARITY_HZ)
        return 0
    
    # Calculate offset
    offset_hz = endpoint.min_frequency - _selected_min_freq
    offset_slots = int(offset_hz / SLOT_GRANULARITY_HZ)
    
    # Handle negative offset (endpoint starts before reference)
    if offset_slots < 0:
        logger.warning(f"[RSA] Endpoint {endpoint.name} starts before reference range")
        # Trim the endpoint bitmap
        trim_slots = abs(offset_slots)
        endpoint_bitmap = int(endpoint.bitmap_value) >> trim_slots
        offset_slots = 0
    else:
        endpoint_bitmap = int(endpoint.bitmap_value)
    
    # Shift to align
    aligned_bitmap = endpoint_bitmap << offset_slots
    
    logger.debug(f"[RSA] Aligned {endpoint.name}: offset={offset_slots} slots, bitmap_len={endpoint.flex_slots}")
    
    return aligned_bitmap
```

**Visual Examples**:

**Example 1: C-band in CL-band Reference**

```
Reference (1199 slots):
Slot:  0        498      1198
Freq:  188.45   191.556  195.938 THz
Bits:  |========|========|

C-band Endpoint (701 slots):
Slot:  0                 700
Freq:  191.556          195.938 THz
Bits:           |========|

Endpoint bitmap (701 bits):
111111111111111111111111111111111111111111111111...111 (all available)

Aligned bitmap (1199 bits):
[00000000...000][111111111111111111111111111111...111]
 ↑              ↑
 498 zeros      701 endpoint bits

Bit 0 = 188.45 THz (unavailable - outside C-band)
Bit 498 = 191.556 THz (available - start of C-band)
Bit 1198 = 195.9375 THz (available - end of C-band)
```

**Example 2: CL-band in CL-band Reference**

```
Reference (1199 slots): |==========================================|
CL-band Endpoint (1199 slots): |=======================================|

Offset = 0 slots (perfect alignment)

Endpoint bitmap: 11111111111111111111111111111111111111111111...111
Aligned bitmap:  11111111111111111111111111111111111111111111...111
(No change needed)
```

**Example 3: Partial C-band in CL-band Reference**

```
Reference (1199 slots):
Slot:  0        504      1188    1198
Freq:  188.45   191.60   195.90  195.938 THz
Bits:  |========|========|=====|

Partial C-band Endpoint (684 slots):
Slot:  0                684
Freq:  191.60          195.90 THz
Bits:           |========|

Endpoint bitmap (684 bits):
111111111111111111111111111111111111111111...111

Offset = (191.60 - 188.45) / 0.00625 = 504 slots

Aligned bitmap (1199 bits):
[000...000][1111111111111111111111...111][000000000000]
 ↑         ↑                             ↑
 504 zeros 684 endpoint bits            11 zeros
 
Total: 504 + 684 + 11 = 1199 ✓
```

### Step 4: Device-Level Parallel Endpoint Intersection

**Critical Function**:

```python
@staticmethod
def get_device_available_bitmap(device_id, reference_endpoint_id, _selected_min_freq, _selected_max_freq, SLOT_GRANULARITY_HZ):
    """
    Computes available spectrum for a device by intersecting ALL its endpoints.
    
    Why: ROADM WSS cannot reuse frequencies across different output ports.
    If port-11 uses slot 5, port-10 CANNOT use slot 5.
    
    Algorithm:
    1. Query all endpoints for the device
    2. Align each endpoint to reference range
    3. Intersect all aligned bitmaps
    4. Return device-wide available spectrum
    
    Args:
        device_id: UUID of the device
        reference_endpoint_id: The endpoint in the path (for trace marking)
        _selected_min_freq: Reference minimum frequency (Hz)
        _selected_max_freq: Reference maximum frequency (Hz)
        SLOT_GRANULARITY_HZ: 6.25 GHz in Hz
    
    Returns:
        tuple: (device_bitmap, endpoint_traces)
            device_bitmap: int (intersection of all device endpoints)
            endpoint_traces: list of dict (for visualization)
    """
    from models import Endpoint
    
    # Get all endpoints for this device
    all_endpoints = Endpoint.query.filter_by(device_id=device_id).all()
    
    logger.info(f"[RSA] Device {device_id}: Found {len(all_endpoints)} endpoints")
    
    # Initialize with all available
    reference_slots = int((_selected_max_freq - _selected_min_freq) / SLOT_GRANULARITY_HZ)
    device_bitmap = (1 << reference_slots) - 1
    
    endpoint_traces = []
    
    for endpoint in all_endpoints:
        # Align to reference
        aligned_bitmap = TopologyHelper.align_endpoint_to_reference(
            endpoint, _selected_min_freq, _selected_max_freq, SLOT_GRANULARITY_HZ
        )
        
        # Intersect
        before_bitmap = device_bitmap
        device_bitmap &= aligned_bitmap
        
        # Track for trace
        is_path_endpoint = (endpoint.id == reference_endpoint_id)
        endpoint_traces.append({
            'endpoint_name': endpoint.name,
            'is_path_endpoint': is_path_endpoint,
            'min_freq_thz': endpoint.min_frequency / 1e12 if endpoint.min_frequency else None,
            'max_freq_thz': endpoint.max_frequency / 1e12 if endpoint.max_frequency else None,
            'flex_slots': endpoint.flex_slots,
            'original_bitmap': TopologyHelper.int_to_bitmap(int(endpoint.bitmap_value) if endpoint.bitmap_value else 0, endpoint.flex_slots),
            'aligned_bitmap': TopologyHelper.int_to_bitmap(aligned_bitmap, reference_slots),
            'device_bitmap_after': TopologyHelper.int_to_bitmap(device_bitmap, reference_slots)
        })
        
        logger.debug(f"[RSA] Endpoint {endpoint.name}: aligned, device_bitmap updated")
    
    logger.info(f"[RSA] Device final bitmap: {bin(device_bitmap)[:50]}...")
    
    return device_bitmap, endpoint_traces
```

**Example Execution**:

```
Device: RDM1 (4 endpoints)
Reference: CL-band (188.450-195.938 THz, 1199 slots)

Endpoint 1: port-10 (path endpoint)
- Range: C-band (191.556-195.938 THz, 701 slots)
- Original bitmap: 111111111111...111 (all available)
- Aligned bitmap:  [000...000][111111111111...111] (498 offset)
- Device bitmap:   111111111111...111 (initialized)

Endpoint 2: port-11 (other path)
- Range: C-band (191.556-195.938 THz, 701 slots)
- Original bitmap: 111100111111...111 (slots 2-3 in use: bits 2-3 are 0)
- Aligned bitmap:  [000...000][111100111111...111] (498 offset)
- Device bitmap:   [000...000][111100111111...111] (after & with port-10)

Endpoint 3: port-12 (other path)
- Range: C-band (191.556-195.938 THz, 701 slots)
- Original bitmap: 111111001111...111 (slots 0-1 in use: bits 0-1 are 0)
- Aligned bitmap:  [000...000][111111001111...111] (498 offset)
- Device bitmap:   [000...000][111100001111...111] (after & with port-11)

Endpoint 4: port-13 (unused)
- Range: CL-band (188.450-195.938 THz, 1199 slots)
- Original bitmap: 00111111111111...111 (L-band slots in use: first 498 bits are 0)
- Aligned bitmap:  00111111111111...111 (no offset)
- Device bitmap:   [000...000][111000001111...111] (after & with port-12)

Final device bitmap:
[000...000][111000001111...111]
 ↑         ↑
 L-band:   C-band: Only slots available across ALL 4 endpoints
 unavail   (slots 0-4 blocked by port-12/port-11, rest available)
```

### Step 5: Path-Wide Bitmap Intersection

**Main Loop**:

```python
def rsa_bitmap_pre_compute(path_obj, graph):
    # ... (Steps 1-2: Calculate reference range and detect band) ...
    
    # Initialize path bitmap
    reference_bitmap = (1 << reference_slots) - 1
    
    trace_steps = []
    
    # Iterate through hops
    for i, link_info in enumerate(path_obj['links']):
        link_id = link_info['id']
        hop_label = f"{link_info['src']} -> {link_info['dst']}"
        
        logger.info(f"[RSA] Processing Hop {i+1}: {hop_label}")
        
        # Query link
        link = OpticalLink.query.get(link_id)
        if not link:
            logger.error(f"[RSA] Link {link_id} not found")
            continue
        
        # Get source device bitmap (with parallel constraints)
        src_device_bitmap, src_traces = TopologyHelper.get_device_available_bitmap(
            link.src_endpoint.device_id,
            link.src_endpoint_id,
            _selected_min_freq,
            _selected_max_freq,
            SLOT_GRANULARITY_HZ
        )
        
        # Get destination device bitmap (with parallel constraints)
        dst_device_bitmap, dst_traces = TopologyHelper.get_device_available_bitmap(
            link.dst_endpoint.device_id,
            link.dst_endpoint_id,
            _selected_min_freq,
            _selected_max_freq,
            SLOT_GRANULARITY_HZ
        )
        
        # Hop bitmap = intersection of src and dst device bitmaps
        hop_bitmap = src_device_bitmap & dst_device_bitmap
        
        # Update path bitmap
        before_path_bitmap = reference_bitmap
        reference_bitmap &= hop_bitmap
        
        # Record trace
        trace_steps.append({
            'hop_index': i + 1,
            'hop_label': hop_label,
            'link_name': link_info['name'],
            'src_device': link_info['src'],
            'dst_device': link_info['dst'],
            'src_endpoint_traces': src_traces,
            'dst_endpoint_traces': dst_traces,
            'src_device_bitmap': TopologyHelper.int_to_bitmap(src_device_bitmap, reference_slots),
            'dst_device_bitmap': TopologyHelper.int_to_bitmap(dst_device_bitmap, reference_slots),
            'hop_bitmap': TopologyHelper.int_to_bitmap(hop_bitmap, reference_slots),
            'cumulative_bitmap': TopologyHelper.int_to_bitmap(reference_bitmap, reference_slots)
        })
        
        logger.info(f"[RSA] Hop {i+1} complete: hop_bitmap={bin(hop_bitmap)[:50]}...")
    
    logger.info(f"[RSA] Path bitmap final: {bin(reference_bitmap)[:50]}...")
    
    return reference_bitmap, reference_slots, trace_steps, band_info
```

**Example Trace Output**:

```
[RSA Pre-Compute] Reference range: 188.450 - 195.938 THz
[RSA Pre-Compute] Detected band: C, L-Band (1199 slots)

Hop 1: TP1 -> RDM1
  Source Device: TP1
    Endpoint: port-1 (path) C-band
      Original: 1111111111...111 (701 bits)
      Aligned:  [000...000][1111111111...111] (1199 bits, 498 offset)
    Device bitmap: [000...000][1111111111...111]
  
  Destination Device: RDM1
    Endpoint: port-10 (path) CL-band
      Original: 1111111111...111 (1199 bits)
      Aligned:  1111111111...111 (no offset)
    Endpoint: port-11 (other) C-band
      Original: 1111001111...111 (slots 2-3 used)
      Aligned:  [000...000][1111001111...111]
    Endpoint: port-12 (other) C-band
      Original: 1111110011...111 (slots 0-1 used)
      Aligned:  [000...000][1111110011...111]
    Device bitmap: [000...000][1111000011...111]
  
  Hop bitmap: [000...000][1111000011...111]
  Cumulative: [000...000][1111000011...111]

Hop 2: RDM1 -> RDM2
  ... (similar structure)

Final available: [000...000][1111000011...111]
Required slots: 8 (50 Gbps / 6.25 GHz)
First-fit result: Slots 5-12 available ✓
```

### Step 6: First-Fit Allocation (Unchanged Logic)

```python
def perform_rsa(path_obj, bandwidth, graph):
    # Calculate required slots with CORRECT granularity
    SLOT_GRANULARITY_HZ = ITUStandards.SLOT_GRANULARITY.value
    SLOT_GRANULARITY_GHZ = SLOT_GRANULARITY_HZ / FrequencyMeasurementUnit.GHz.value
    num_slots = math.ceil(float(bandwidth) / SLOT_GRANULARITY_GHZ)
    
    logger.info(f"[RSA] Bandwidth: {bandwidth} Gbps, Required slots: {num_slots} (@ {SLOT_GRANULARITY_GHZ} GHz)")
    
    # Pre-compute with reference bitmap
    reference_bitmap, reference_slots, trace_steps, band_info = TopologyHelper.rsa_bitmap_pre_compute(path_obj, graph)
    
    # First-fit search (same logic as before, but on reference_bitmap)
    start_bit = -1
    current_run = 0
    
    for i in range(reference_slots):
        is_free = (reference_bitmap >> i) & 1
        if is_free:
            current_run += 1
            if current_run == num_slots:
                start_bit = i - num_slots + 1
                break
        else:
            current_run = 0
    
    if start_bit != -1:
        # Success - create mask
        mask = ((1 << num_slots) - 1) << start_bit
        final_bitmap_val = reference_bitmap & ~mask
        
        return {
            'success': True,
            'num_slots': num_slots,
            'start_slot': start_bit,
            'common_bitmap': f"{reference_bitmap:0{reference_slots}b}",
            'required_slots': f"{mask:0{reference_slots}b}",
            'final_bitmap': f"{final_bitmap_val:0{reference_slots}b}",
            'trace_steps': trace_steps,
            'band_info': band_info,
            'mask': mask
        }
    else:
        # Failure
        return {
            'success': False,
            'num_slots': num_slots,
            'common_bitmap': f"{reference_bitmap:0{reference_slots}b}",
            'error': "No contiguous slots found",
            'trace_steps': trace_steps,
            'band_info': band_info,
            'mask': 0
        }
```

### Step 7: Commit Slots with Reference Alignment

**Challenge**: Mask is in reference range, but endpoints need updates in their own ranges.

```python
@staticmethod
def commit_slots(link_ids, mask):
    """
    Applies mask to endpoint bitmaps, converting from reference range to endpoint range.
    
    Algorithm:
    1. Calculate reference range from path endpoints
    2. For each link:
       a. Query all endpoints on src device
       b. Convert mask from reference to endpoint range
       c. Apply mask to endpoint.bitmap_value
       d. Repeat for dst device
    3. Commit to database
    """
    from models import db, OpticalLink, Endpoint
    
    if not link_ids or mask is None:
        return False
    
    try:
        # Step 1: Calculate reference range
        links = OpticalLink.query.filter(OpticalLink.id.in_(link_ids)).all()
        endpoint_ids = set()
        for link in links:
            endpoint_ids.add(link.src_endpoint_id)
            endpoint_ids.add(link.dst_endpoint_id)
        
        endpoints = [Endpoint.query.get(eid) for eid in endpoint_ids]
        _reference_min_freq = min([ep.min_frequency for ep in endpoints if ep.min_frequency])
        _reference_max_freq = max([ep.max_frequency for ep in endpoints if ep.max_frequency])
        
        band_info = OpticalBandHelper.detect_band(_reference_min_freq, _reference_max_freq)
        _selected_min_freq, _selected_max_freq = band_info['frequency_range_hz']
        
        SLOT_GRANULARITY_HZ = ITUStandards.SLOT_GRANULARITY.value
        reference_slots = int((_selected_max_freq - _selected_min_freq) / SLOT_GRANULARITY_HZ)
        
        logger.info(f"[RSA Commit] Reference: {band_info['band_name']}-Band, mask={mask:b}")
        
        # Step 2: Process each device
        updated_devices = set()
        
        for link in links:
            for device_id in [link.src_endpoint.device_id, link.dst_endpoint.device_id]:
                if device_id in updated_devices:
                    continue  # Already processed
                
                # Get all endpoints for this device
                device_endpoints = Endpoint.query.filter_by(device_id=device_id).all()
                
                for endpoint in device_endpoints:
                    # Convert mask from reference range to endpoint range
                    endpoint_mask = TopologyHelper.convert_mask_to_endpoint(
                        mask, _selected_min_freq, endpoint, SLOT_GRANULARITY_HZ
                    )
                    
                    # Apply mask
                    current_bitmap = int(endpoint.bitmap_value) if endpoint.bitmap_value else 0
                    new_bitmap = current_bitmap & ~endpoint_mask
                    endpoint.bitmap_value = str(new_bitmap)
                    
                    logger.debug(f"[RSA Commit] {endpoint.name}: mask={endpoint_mask:b}, new_bitmap={new_bitmap:b}")
                
                updated_devices.add(device_id)
        
        db.session.commit()
        logger.info(f"[RSA Commit] Success: Updated {len(updated_devices)} devices")
        return True
        
    except Exception as e:
        db.session.rollback()
        logger.error(f"[RSA Commit] Error: {e}")
        return False

@staticmethod
def convert_mask_to_endpoint(reference_mask, _selected_min_freq, endpoint, SLOT_GRANULARITY_HZ):
    """
    Converts a mask from reference range to endpoint range.
    
    Example:
    Reference: CL-band (1199 slots), mask at slots 500-507 (8 slots)
    Reference mask: [000...][11111111][000...] (bits 500-507 set)
                           ↑        ↑
                           500      507
    
    Endpoint: C-band (701 slots), offset 498 from reference
    Endpoint range: slots 498-1198 in reference = slots 0-700 in endpoint
    
    Mask slots 500-507 in reference = slots 2-9 in endpoint (500-498=2, 507-498=9)
    Endpoint mask: [00][11111111][000...] (bits 2-9 set)
    
    Args:
        reference_mask: int (mask in reference range)
        _selected_min_freq: Reference minimum frequency (Hz)
        endpoint: Endpoint instance
        SLOT_GRANULARITY_HZ: 6.25 GHz in Hz
    
    Returns:
        int: Mask in endpoint range
    """
    if not endpoint.min_frequency or not endpoint.max_frequency:
        return 0  # Endpoint outside reference
    
    # Calculate offset
    offset_hz = endpoint.min_frequency - _selected_min_freq
    offset_slots = int(offset_hz / SLOT_GRANULARITY_HZ)
    
    if offset_slots < 0:
        # Endpoint starts before reference (shouldn't happen in practice)
        return reference_mask << abs(offset_slots)
    else:
        # Shift mask right to align with endpoint range
        endpoint_mask = reference_mask >> offset_slots
        
        # Trim to endpoint width
        endpoint_slots = endpoint.flex_slots
        max_mask = (1 << endpoint_slots) - 1
        endpoint_mask &= max_mask
        
        return endpoint_mask
```

**Example Commit**:

```
Reference: CL-band (1199 slots)
Mask: Slots 500-507 (8 slots)
Binary: [000...][11111111][000...]
         498    500      507

Device: RDM1 (CL-band endpoints)
- port-10: offset=0, mask=slots 500-507 (direct)
- port-11: offset=0, mask=slots 500-507 (direct)
- port-12: offset=0, mask=slots 500-507 (direct)

Device: TP1 (C-band endpoints)
- port-1: offset=498, mask=slots 2-9 (500-498=2, 507-498=9)

All endpoints updated with correct masks in their own ranges.
```

---

## Benefits Achieved

### 1. Multi-Band Path Support

Can now mix devices with different band capabilities:

- TP (C-band) → ROADM (CL-band) → ROADM (SCL-band) → TP (C-band)
- Reference expands to widest band (SCL)
- All bitmaps aligned to common frequency grid
- Correct intersection produces accurate available spectrum

### 2. Parallel Endpoint Constraints

Device-level bitmap intersection ensures:

- ROADM WSS cannot reuse frequencies across ports
- Transponder group constraints enforced
- All device endpoints checked, not just path endpoints
- Accurate representation of physical limitations

### 3. Correct ITU Standard Compliance

- Slot granularity: 6.25 GHz (not 12.5 GHz)
- Bandwidth calculations accurate
- Flex-grid spacing matches ITU-T G.694.1
- Professional-grade implementation

### 4. Enhanced Debugging

Trace visualization shows:

- Reference range and detected band
- All device endpoints (not just path endpoints)
- Original and aligned bitmaps
- Device-level and hop-level intersections
- Clear understanding of where constraints come from

---

## Testing Scenarios

### Test 1: Same Band (Backward Compatibility)

**Setup**:

- Path: TP1 (C) → RDM1 (C) → RDM2 (C) → TP2 (C)
- All endpoints: 191.556-195.938 THz

**Expected**:

- Reference: C-band (701 slots)
- All offsets: 0 (no padding)
- Result matches old implementation
- Bandwidth: 50 Gbps = 8 slots (not 4)

### Test 2: Mixed Bands

**Setup**:

- Path: TP1 (C) → RDM1 (CL) → RDM2 (CL) → TP2 (C)
- TP endpoints: 191.556-195.938 THz (C-band)
- RDM endpoints: 188.450-195.938 THz (CL-band)

**Expected**:

- Reference: CL-band (1199 slots)
- TP endpoints: offset=498, padded left with 498 zeros
- RDM endpoints: offset=0, no padding
- Available spectrum: Only C-band portion (RDM constrains to C)

### Test 3: Parallel Endpoints

**Setup**:

- RDM1 has 4 endpoints
- port-10 (path): all available
- port-11: slots 5-10 in use
- port-12: slots 15-20 in use
- port-13: slots 25-30 in use

**Expected**:

- Device bitmap excludes slots 5-10, 15-20, 25-30
- Trace shows all 4 endpoints
- RSA cannot allocate in blocked slots

### Test 4: Acquisition with Mixed Bands

**Setup**:

- Path with C-band and CL-band devices
- RSA allocates slots 500-507 in CL reference

**Expected**:

- CL devices: mask at slots 500-507
- C devices: mask at slots 2-9 (converted from 500-507)
- Database updated correctly
- Re-run RSA shows slots as IN_USE

---

## Conclusion

Task 11 completes the RSA architecture redesign, enabling production-ready optical spectrum allocation for heterogeneous networks. The reference bitmap approach correctly handles:

- Multi-band devices (C, L, CL, SCL, WHOLE_BAND)
- Parallel endpoint constraints (device-level)
- ITU standards compliance (6.25 GHz granularity)
- Complex path topologies with mixed capabilities

This implementation is robust, standards-compliant, and ready for integration with TeraFlowSDN OpticalController.
