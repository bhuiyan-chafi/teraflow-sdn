# Task 11: Reference Bitmap RSA Computation with Device-Level Parallel Endpoint Intersection

## Objective

Rewrite the RSA (Routing and Spectrum Assignment) computation to use a unified reference bitmap that aligns all endpoints to a common frequency range. This enables proper spectrum intersection across devices with different frequency capabilities and ensures parallel endpoint constraints are correctly enforced at the device level.

## Background

### Problem with Current Implementation (Post-Task 3)

After Task 3, spectrum management moved from link-level (`c_slot`, `l_slot`) to endpoint-level (`bitmap_value`). However, the current RSA implementation has a fundamental flaw:

**Current Logic** (helpers.py:334-396):

```python
for each hop in path:
    link = OpticalLink.query.get(link_id)
    src_bitmap = int(link.src_endpoint.bitmap_value)  # 701 bits (C-band)
    dst_bitmap = int(link.dst_endpoint.bitmap_value)  # 701 bits (C-band)
    hop_bitmap = src_bitmap & dst_bitmap              # Direct intersection
    current_bitmap &= hop_bitmap
```

**Issues**:

1. **Misaligned Frequency Ranges**: Direct bitmap intersection assumes both endpoints have the same frequency range. If `src_endpoint` supports C-band (191.556-195.938 THz) and `dst_endpoint` supports CL-band (188.450-195.938 THz), their bitmaps represent different frequency grids.

2. **Missing Parallel Endpoint Constraints**: A ROADM device with multiple endpoints (WSS ports) cannot reuse the same frequencies across different ports due to optical interference. Current implementation only checks the specific link endpoints, ignoring other in-use endpoints on the same device.

3. **Incorrect Slot Granularity**: Uses hardcoded `FLEX_GRID = 12.5` GHz instead of ITU standard `SLOT_GRANULARITY = 6.25` GHz.

### Solution Architecture

**New Reference Bitmap Approach**:

1. Calculate a unified reference frequency range from ALL endpoints in the path
2. Detect the operational band that contains this range (e.g., CL, SCL, WHOLE_BAND)
3. Expand all endpoint bitmaps to align with the reference range (with zero-padding)
4. For each device, intersect ALL its endpoint bitmaps (parallel constraint)
5. Intersect device bitmaps across the path to find available spectrum

## Key Design Principles

### 1. Reference Range from Path Endpoints

Collect all unique endpoints in the path and find the widest frequency range:

```python
_reference_min_freq = min([ep.min_frequency for all endpoints in path])
_reference_max_freq = max([ep.max_frequency for all endpoints in path])
```

**Rationale**: If any endpoint supports L-band (188.450 THz) and another supports C-band (195.938 THz max), the reference must span both to correctly represent available spectrum.

### 2. Operational Band Detection

Use the existing `OpticalBandHelper.detect_band()` with narrowest-band-first logic:

```python
band_info = OpticalBandHelper.detect_band(_reference_min_freq, _reference_max_freq)
_selected_min_freq, _selected_max_freq = band_info['frequency_range_hz']
reference_slots = int((_selected_max_freq - _selected_min_freq) / SLOT_GRANULARITY_HZ)
```

**Example**:

- Path has endpoints: C-band (191.556-195.938 THz) and L-band (188.450-191.556 THz)
- Reference range: 188.450-195.938 THz
- Detected band: **CL_BAND** (1199 slots at 6.25 GHz granularity)
- Reference bitmap: 1199 bits wide

### 3. Bitmap Alignment with Zero-Padding

Expand each endpoint's bitmap to match the reference range:

```python
def align_endpoint_to_reference(endpoint, _selected_min_freq, _selected_max_freq, SLOT_GRANULARITY_HZ):
    """
    Aligns an endpoint's bitmap to the reference frequency range.
    
    Frequency Alignment:
    Reference:   |=========================================| (CL-band: 188.450-195.938 THz)
    Endpoint:         |========================|             (C-band: 191.556-195.938 THz)
    Aligned:     [0000][111111111111111111111]              (Padded with zeros)
    
    Args:
        endpoint: Endpoint model instance
        _selected_min_freq: Reference range minimum (Hz)
        _selected_max_freq: Reference range maximum (Hz)
        SLOT_GRANULARITY_HZ: 6.25 GHz in Hz
        
    Returns:
        int: Aligned bitmap value (zero-padded)
    """
    if not endpoint.min_frequency or not endpoint.max_frequency or not endpoint.bitmap_value:
        # Endpoint outside reference or no data - return all zeros
        reference_slots = int((_selected_max_freq - _selected_min_freq) / SLOT_GRANULARITY_HZ)
        return 0  # All unavailable
    
    # Calculate offset from reference start
    offset_hz = endpoint.min_frequency - _selected_min_freq
    offset_slots = int(offset_hz / SLOT_GRANULARITY_HZ)
    
    # Get endpoint's bitmap
    endpoint_bitmap = int(endpoint.bitmap_value)
    
    # Shift to align with reference
    aligned_bitmap = endpoint_bitmap << offset_slots
    
    # Zero-padding happens automatically:
    # - Before endpoint range: shift operation leaves zeros
    # - After endpoint range: bitmap width is less than reference, remaining bits are zero
    
    return aligned_bitmap
```

**Example Scenarios**:

**Scenario A: C-band endpoint in CL-band reference**

```
Reference CL (1199 slots):  |==========================================|
                            188.450 THz              191.556 THz      195.938 THz
C-band endpoint (701 slots):                        |=================|
Endpoint bitmap (701 bits):                         111111111111111111
Offset = (191.556 - 188.450) / 0.00625 = 498 slots

Aligned bitmap (1199 bits):
[00000000...000][11111111...111]
 ↑              ↑
 498 zero bits  701 endpoint bits (shifted left by 498)
```

**Scenario B: CL-band endpoint in CL-band reference**

```
Reference CL (1199 slots):  |==========================================|
CL-band endpoint (1199 slots): |=======================================|
Offset = 0 slots

Aligned bitmap: [11111111111111111111111111111111111111111111111111111]
(No padding needed)
```

**Scenario C: Partial C-band endpoint in CL-band reference**

```
Reference CL (1199 slots):  |==========================================|
                            188.450 THz    191.600 THz      195.900 THz
Partial C endpoint (684 slots):           |==================|

Offset = (191.600 - 188.450) / 0.00625 = 504 slots
Aligned bitmap (1199 bits):
[000...000][1111111111111111][000000000000]
 ↑         ↑                  ↑
 504 zeros 684 endpoint bits 11 zeros (1199-504-684)
```

### 4. Device-Level Parallel Endpoint Intersection

**Critical Optical Constraint**: A ROADM device with multiple WSS ports cannot reuse the same frequencies across different ports because outputs from the same WSS cannot carry overlapping wavelengths (optical interference).

**Implementation**:

```python
def get_device_available_bitmap(device_id, reference_endpoint_id, _selected_min_freq, _selected_max_freq, SLOT_GRANULARITY_HZ):
    """
    Computes available spectrum for a device by intersecting ALL its endpoint bitmaps.
    This enforces the parallel endpoint constraint at the device level.
    
    Args:
        device_id: Device UUID
        reference_endpoint_id: The specific endpoint in the path (to include)
        _selected_min_freq: Reference range minimum
        _selected_max_freq: Reference range maximum
        SLOT_GRANULARITY_HZ: 6.25 GHz in Hz
        
    Returns:
        tuple: (device_bitmap, list of trace info dicts)
    """
    from models import Endpoint
    
    # Get ALL endpoints for this device
    all_endpoints = Endpoint.query.filter_by(device_id=device_id).all()
    
    # Initialize with all available
    reference_slots = int((_selected_max_freq - _selected_min_freq) / SLOT_GRANULARITY_HZ)
    device_bitmap = (1 << reference_slots) - 1
    
    trace_info = []
    
    for endpoint in all_endpoints:
        # Align endpoint to reference
        aligned_bitmap = align_endpoint_to_reference(endpoint, _selected_min_freq, _selected_max_freq, SLOT_GRANULARITY_HZ)
        
        # Intersect
        device_bitmap &= aligned_bitmap
        
        # Track for trace
        trace_info.append({
            'endpoint_name': endpoint.name,
            'is_path_endpoint': endpoint.id == reference_endpoint_id,
            'original_bitmap': TopologyHelper.int_to_bitmap(int(endpoint.bitmap_value), endpoint.flex_slots),
            'aligned_bitmap': TopologyHelper.int_to_bitmap(aligned_bitmap, reference_slots)
        })
    
    return device_bitmap, trace_info
```

**Example**:

```
Device: RDM1 (ROADM with 4 endpoints)
- port-10 (path endpoint): C-band, bitmap = 11111111 (all available)
- port-11 (other): C-band, bitmap = 11110011 (slots 2-3 in use)
- port-12 (other): C-band, bitmap = 11111100 (slots 0-1 in use)
- port-13 (other): CL-band, bitmap = 0011111111...11 (L-band in use)

Reference: CL-band (1199 slots)

Aligned bitmaps:
- port-10: [000...000][11111111][000...000]  (498 offset)
- port-11: [000...000][11110011][000...000]
- port-12: [000...000][11111100][000...000]
- port-13: [00111111111111111111111111111111]  (0 offset, full CL)

Device bitmap = port-10 & port-11 & port-12 & port-13
             = [000...000][11110000][000...000]
                           ↑
                           Only slots where ALL endpoints are available
```

### 5. Path-Wide Bitmap Intersection

```python
for each hop in path:
    # Get device bitmaps with parallel constraints
    src_device_bitmap, src_trace = get_device_available_bitmap(src_device_id, src_endpoint_id, ...)
    dst_device_bitmap, dst_trace = get_device_available_bitmap(dst_device_id, dst_endpoint_id, ...)
    
    # Hop bitmap = intersection of src and dst device bitmaps
    hop_bitmap = src_device_bitmap & dst_device_bitmap
    
    # Path bitmap = intersection across all hops
    path_bitmap &= hop_bitmap
```

### 6. Correct Slot Granularity

**Current (WRONG)**:

```python
FLEX_GRID = 12.5  # GHz (hardcoded)
num_slots = math.ceil(bandwidth / FLEX_GRID)
```

**New (CORRECT)**:

```python
SLOT_GRANULARITY_HZ = ITUStandards.SLOT_GRANULARITY.value  # 6250000000 Hz
SLOT_GRANULARITY_GHZ = SLOT_GRANULARITY_HZ / FrequencyMeasurementUnit.GHz.value  # 6.25 GHz
num_slots = math.ceil(bandwidth_gbps / SLOT_GRANULARITY_GHZ)
```

**Example**:

- Bandwidth: 50 Gbps
- Old calculation: 50 / 12.5 = 4 slots (WRONG - uses 12.5 GHz channels)
- New calculation: 50 / 6.25 = 8 slots (CORRECT - uses 6.25 GHz flex-grid)

## Subtasks

### 11.1 Update Slot Calculation to Use ITU Standard

**File**: `helpers.py` - `TopologyHelper.perform_rsa()`

- [ ] Remove hardcoded `FLEX_GRID = 12.5` at line 405
- [ ] Import `FrequencyMeasurementUnit` from `enums.OpticalBands`
- [ ] Calculate `SLOT_GRANULARITY_GHZ = ITUStandards.SLOT_GRANULARITY.value / FrequencyMeasurementUnit.GHz.value`
- [ ] Update `num_slots = math.ceil(float(bandwidth) / SLOT_GRANULARITY_GHZ)`
- [ ] Update log messages to reference 6.25 GHz granularity

### 11.2 Implement Bitmap Alignment Helper

**File**: `helpers.py` - New method in `TopologyHelper` class

- [ ] Create `align_endpoint_to_reference()` static method
- [ ] Calculate offset slots from reference minimum
- [ ] Shift endpoint bitmap by offset
- [ ] Handle edge cases (None values, out of range)
- [ ] Add comprehensive docstring with examples

### 11.3 Implement Device-Level Parallel Endpoint Intersection

**File**: `helpers.py` - New method in `TopologyHelper` class

- [ ] Create `get_device_available_bitmap()` static method
- [ ] Query all endpoints for the device
- [ ] Align each endpoint bitmap to reference
- [ ] Intersect all aligned bitmaps
- [ ] Return device bitmap and trace information
- [ ] Add logging for parallel endpoint detection

### 11.4 Rewrite RSA Pre-Compute with Reference Bitmap

**File**: `helpers.py` - `TopologyHelper.rsa_bitmap_pre_compute()`

**Step 1: Collect all unique endpoints**

- [ ] Extract unique endpoint IDs from path_obj['links']
- [ ] Query Endpoint model for each unique ID
- [ ] Build list of all path endpoints

**Step 2: Calculate reference frequency range**

- [ ] Find min frequency: `min([ep.min_frequency for ep in endpoints])`
- [ ] Find max frequency: `max([ep.max_frequency for ep in endpoints])`
- [ ] Handle None/invalid frequencies

**Step 3: Detect operational band**

- [ ] Call `OpticalBandHelper.detect_band(_reference_min_freq, _reference_max_freq)`
- [ ] Extract `_selected_min_freq`, `_selected_max_freq` from band_info
- [ ] Calculate `reference_slots`
- [ ] Log detected band and reference range

**Step 4: Initialize reference bitmap**

- [ ] Create `reference_bitmap = (1 << reference_slots) - 1` (all available)
- [ ] This will be intersected with device bitmaps

**Step 5: Iterate through hops**

- [ ] For each link in path:
  - Query OpticalLink to get src_endpoint and dst_endpoint
  - Get src_device_id and dst_device_id
  - Call `get_device_available_bitmap()` for src device
  - Call `get_device_available_bitmap()` for dst device
  - Intersect src_device_bitmap & dst_device_bitmap = hop_bitmap
  - Update reference_bitmap &= hop_bitmap
  - Append to trace_steps with full device-level details

**Step 6: Return results**

- [ ] Return tuple: (reference_bitmap, reference_slots, trace_steps)
- [ ] Update trace_steps structure to include device-level information

### 11.5 Update Trace Visualization

**Files**: `templates/paths.html`, `templates/rsa_path.html`

- [ ] Update trace display to show device-level endpoint intersections
- [ ] Add collapsible sections for parallel endpoints per hop
- [ ] Show original and aligned bitmaps for debugging
- [ ] Display reference range and detected band
- [ ] Update labels to reflect new computation logic

### 11.6 Update perform_rsa() Function

**File**: `helpers.py` - `TopologyHelper.perform_rsa()`

- [ ] Update to use new reference_slots from rsa_bitmap_pre_compute()
- [ ] Use reference_bitmap for first-fit slot allocation
- [ ] Update bitmap length in result dictionaries
- [ ] Ensure mask calculation uses reference range
- [ ] Update logging to show reference range

### 11.7 Update commit_slots() for Reference Alignment

**File**: `helpers.py` - `TopologyHelper.commit_slots()`

- [ ] Calculate reference range from path link endpoints
- [ ] For each link's endpoints:
  - Query device's all endpoints
  - For each endpoint, convert mask from reference range to endpoint range
  - Apply mask to endpoint.bitmap_value
  - Update database
- [ ] Handle offset correctly when applying mask
- [ ] Add logging for mask application per endpoint

### 11.8 Testing

**Test Case 1: Same Band Endpoints (C-band only)**

- [ ] Path: TP1 (C-band) → RDM1 (C-band) → RDM2 (C-band) → TP2 (C-band)
- [ ] Reference range: C-band (191.556-195.938 THz)
- [ ] Reference slots: 701
- [ ] All bitmaps aligned with zero offset
- [ ] Verify result matches old implementation

**Test Case 2: Mixed Bands (C-band and CL-band)**

- [ ] Path: TP1 (C-band) → RDM1 (CL-band) → RDM2 (CL-band) → TP2 (C-band)
- [ ] Reference range: CL-band (188.450-195.938 THz)
- [ ] Reference slots: 1199
- [ ] C-band endpoints padded with 498 zeros on left
- [ ] Verify CL-band devices constrain C-band devices

**Test Case 3: Parallel Endpoint Constraints**

- [ ] Device RDM1 has 4 endpoints
- [ ] One endpoint (port-10) in path, others in use
- [ ] Verify device bitmap excludes slots used by parallel endpoints
- [ ] Check trace shows all device endpoints

**Test Case 4: Bandwidth Calculation**

- [ ] Request 50 Gbps
- [ ] Old: 4 slots (12.5 GHz) - WRONG
- [ ] New: 8 slots (6.25 GHz) - CORRECT
- [ ] Verify slot count in RSA result

**Test Case 5: Slot Acquisition**

- [ ] Perform RSA with reference bitmap
- [ ] Click "Acquire Slots"
- [ ] Verify mask applied to all device endpoints correctly
- [ ] Check database bitmap_value updated
- [ ] Re-run RSA to verify slots marked as IN_USE

## Expected Outcome

After Task 11:

1. **Correct Slot Granularity**: RSA uses 6.25 GHz ITU standard, not 12.5 GHz
2. **Reference Bitmap Alignment**: All endpoints aligned to common frequency range
3. **Multi-Band Support**: Paths can mix C-band, L-band, CL-band, SCL-band devices
4. **Parallel Endpoint Constraints**: Device-level spectrum intersection prevents frequency reuse
5. **Accurate Spectrum Allocation**: Available slots correctly represent physical constraints
6. **Enhanced Trace Visualization**: Shows device-level bitmap intersections for debugging

This completes the RSA computation architecture, making it production-ready for real-world optical networks with heterogeneous device capabilities.

---

## Documentation Files

- [ ] Create `Tasks_11.md` (this file)
- [ ] Create `Walkthrough_11.md` with implementation details and examples
