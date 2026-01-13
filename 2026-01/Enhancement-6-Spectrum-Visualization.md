# Enhancement 6: Spectrum Allocation Visualization

## Overview

This document provides comprehensive walkthrough of the spectrum allocation visualization implementation based on ITU-T G.694.1 flexible grid standards. The visualization displays all standard band slots regardless of device capability boundaries, clearly distinguishing between unsupported frequencies, available slots, and allocated slots.

---

## 1. Core Design Principle

### Visualization Follows Standards, Not Device Capabilities

**Critical Rule:** Always display ALL ITU standard slots for the detected band, using status codes to show device capabilities and current usage.

**Example:**

- Standard C-Band: 700 slots (191556.25 - 195937.5 GHz)
- Device supports: 684 slots (missing 8 on each end)
- Visualization: Shows all 700 slots
  - Slots 0-7: UNAVAILABLE (hardware limitation)
  - Slots 8-691: AVAILABLE or IN_USE (check bitmap)  
  - Slots 692-699: UNAVAILABLE (hardware limitation)

---

## 2. Implementation Summary

### Files Modified

1. **helpers.py** - Added SpectrumHelper class
2. **app.py** - Enhanced endpoint_details route
3. **device_endpoint_frequency_view.html** - New spectrum table card

### Key Components

**SpectrumHelper.build_spectrum_slot_table()**

- Inputs: endpoint, band_info
- Returns: List of 700 slot dicts with frequency, availability, is_anchor

**Three Availability States (Constants enum):**

- `UNAVAILABLE` - Outside device capability
- `AVAILABLE` - Free slot (bitmap bit = 1)
- `IN_USE` - Allocated slot (bitmap bit = 0)

**Bitmap LSB Ordering:**

- Bit 0 (LSB) = endpoint minimum frequency
- Bit 1 = min_freq + 6.25 GHz
- Bit N = min_freq + (N × 6.25 GHz)

---

## 3. Testing Instructions

### Quick Verification Steps

1. Navigate to <http://localhost:3000/devices>
2. Click "View Details" for any device
3. Click "Frequency View" for any endpoint
4. Scroll to "Spectrum Allocation Table" card

### Expected Results

**For standard C-band endpoint (700 slots):**

- ✅ Total Standard Slots: 700
- ✅ Table shows slot #, frequency (THz), availability
- ✅ Anchor frequency (193.100 THz) highlighted in cyan
- ✅ Color coding: Gray (UNAVAILABLE), Green (AVAILABLE), Yellow (IN_USE)
- ✅ Summary shows slot distribution

**For reduced-range endpoint:**

- ✅ Still shows 700 total slots
- ✅ Edge slots marked UNAVAILABLE (gray)
- ✅ Device-capable slots show AVAILABLE or IN_USE
- ✅ Summary: Unavailable count matches capability gap

---

## 4. Technical Details

### ITU Standards Used

From `enums/ITUStandards.py`:

```python
ANCHOR_FREQUENCY = 193100000000000 Hz  # 193.100 THz
SLOT_GRANULARITY = 6250000000 Hz       # 6.25 GHz
```

### Bitmap Bit Extraction

```python
bit_position = (frequency_hz - endpoint_min_hz) / slot_granularity_hz
bit_value = (bitmap_value >> bit_position) & 1

if bit_value == 1:
    return "AVAILABLE"  # Free
else:
    return "IN_USE"     # Allocated
```

### Frequency Calculation

```python
for slot_index in range(700):  # C-band
    frequency_hz = band_min_hz + (slot_index * slot_granularity_hz)
    # Check availability and build table row
```

---

## 5. User Interface

### Table Structure

| Slot # | Frequency (THz) | Availability |
|--------|-----------------|--------------|
| 0      | 191.556250     | AVAILABLE    |
| ...    | ...            | ...          |
| 247    | 193.100000     | ANCHOR-AVAIL |
| ...    | ...            | ...          |
| 699    | 195.931250     | AVAILABLE    |

### Color Scheme

- **Gray** (table-secondary) - UNAVAILABLE
- **Green** (table-success) - AVAILABLE  
- **Yellow** (table-warning) - IN_USE
- **Cyan** (table-info) - Anchor frequency

### Scrolling

- Container height: 500px (scrollable)
- Sticky header stays visible when scrolling
- Smooth scroll through all 700 rows

---

## 6. Key Achievements

✅ **Standards Compliance** - ITU-T G.694.1 flex-grid  
✅ **Complete Visualization** - All 700 C-band slots  
✅ **Three-State Model** - Capability vs usage distinction  
✅ **LSB Bitmap** - Correct frequency-to-bit mapping  
✅ **Anchor Highlighting** - 193.100 THz reference  
✅ **Enum-Based** - ITUStandards, Constants, FrequencyMeasurementUnit  
✅ **Custom Filters** - hz_to_thz, hz_to_ghz, format_hz  
✅ **Responsive Design** - Bootstrap 5.3.0 table styling  

---

For detailed implementation walkthrough, algorithm explanations, and future enhancement roadmap, see the full documentation in Walkthrough.md Enhancement 6 section.
