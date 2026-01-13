# Tasks - Device Model Enhancement

## Important Note: Database Unit Convention

**All frequencies in the database are stored in Hz (Hertz), not GHz.** This provides maximum precision and avoids floating-point rounding errors. Conversions to display units (GHz, THz) are performed using custom Jinja2 filters that reference the `FrequencyMeasurementUnit` enum from OpticalBands.py.

---

## Task 1: Add Vendor and Model Fields to Devices Model

### Objective

Enhance the `Devices` model to include additional metadata fields: `vendor` and `model`, to better align with OpenConfig and OpenROADM standards.

### Subtasks

#### 1.1 Update Database Model

- [ ] Add `vendor` field (String, nullable=True) to `Devices` model in `models.py`
- [ ] Add `model` field (String, nullable=True) to `Devices` model in `models.py`
- [ ] Update the `__repr__` method to reflect new fields (optional)

#### 1.2 Update SQL Seed Data

- [ ] Modify `devices.sql` to include `vendor` and `model` columns in INSERT statements
- [ ] Populate realistic vendor names (e.g., Cisco, Ciena, ADVA, etc.)
- [ ] Populate realistic model names for transponders and ROADMs

#### 1.3 Testing

- [ ] Rebuild Docker containers to apply schema changes
- [ ] Verify data is inserted correctly
- [ ] Check device listings display new fields

### Expected Outcome

The `Devices` table will have two additional fields, making device inventory more comprehensive and ready for future integration with TFS OpticalController.

---

## Task 2: Add Frequency Capability Fields to Endpoints Model

### Objective

Enhance the `Endpoint` model to include frequency-based capability fields that define the operational range and slot availability for each port. This aligns with OpenConfig and OpenROADM standards for optical transceivers and ROADM ports (SRG/WSS).

### Background

- **Transponder ports** (transceivers) support a specific frequency range
- **ROADM ports** (SRG/WSS) also support frequency ranges
- Manufacturers specify these ranges in XML configurations, or we assume based on ITU-T standards
- Bitmap representation is needed for slot management (can be very large, requiring text storage)

### Subtasks

#### 2.1 Update Database Model

- [ ] Add `min_frequency` field (Float/Double) to `Endpoint` model in `models.py`
- [ ] Add `max_frequency` field (Float/Double) to `Endpoint` model in `models.py`
- [ ] Add `flex_slots` field (Integer) to `Endpoint` model in `models.py`
- [ ] Add `bitmap_value` field (Text) to `Endpoint` model in `models.py`
  - Note: Using Text type because integer values can exceed PostgreSQL's bigint range
  - Must be stored without spaces

#### 2.2 Update SQL Seed Data

- [ ] Modify `device_endpoints.sql` to include new columns in INSERT statements
- [ ] Use the following values for all endpoints:
  - `min_frequency`: 191556.25 GHz (ITU-T C-band lower bound)
  - `max_frequency`: 195937.5 GHz (ITU-T C-band upper bound)
  - `flex_slots`: 700 (total flexible grid slots)
  - `bitmap_value`: 2^700 as text (all slots available initially)
    - Value: `5260135901548373507240989882880128665550339802823173859498280903068732154297080822113666536277588451226982968856178217713019432250183803863127814770651880849955223671128444598191663757884322717271293251735781376`

#### 2.3 Testing

- [ ] Rebuild Docker containers to apply schema changes
- [ ] Verify data is inserted correctly with all frequency fields
- [ ] Test bitmap operations in Python scripts
- [ ] Validate that bitmap_value is stored without spaces

### Expected Outcome

The `Endpoint` table will have frequency capability fields enabling:

- Accurate slot availability tracking
- C-band frequency range validation
- WDM channel allocation within ITU-T grid
- Integration with RSA computation logic

---

## Task 3: Remove Legacy c_slot and l_slot Fields from OpticalLink Model

### Objective

Remove the deprecated `c_slot` and `l_slot` fields from the `OpticalLink` model. These fields were used for link-level slot management but are now superseded by endpoint-level `bitmap_value` fields, which provide more accurate and granular frequency slot tracking.

### Rationale

- **Architectural Shift**: Slot management should be at the endpoint/port level, not link level
- **Endpoint-Based Tracking**: The new `bitmap_value` field in `Endpoint` model provides complete slot visibility
- **Standards Compliance**: OpenROADM and OpenConfig define frequency capabilities at the port/interface level
- **Redundancy Elimination**: Maintaining both link-level and endpoint-level slot data is redundant and error-prone

### Subtasks

#### 3.1 Update Database Model

- [ ] Remove `c_slot` field from `OpticalLink` model in `models.py`
- [ ] Remove `l_slot` field from `OpticalLink` model in `models.py`
- [ ] Keep `status` field (still needed for link operational state)

#### 3.2 Update SQL Seed Data

- [ ] Remove `c_slot` column from all INSERT statements in `optical_links.sql`
- [ ] Remove `l_slot` column from all INSERT statements in `optical_links.sql`
- [ ] Update all link INSERT statements across topology sections:
  - TP1-RDM1 (2 links)
  - RDM1-RDM2 (4 links)
  - RDM2-RDM3 (4 links)
  - RDM2-RDM5 (1 link)
  - RDM3-RDM4 (4 links)
  - RDM3-RDM6 (1 link)
  - RDM4-TP3 (2 links)
  - TP2-RDM5 (1 link)
  - RDM5-RDM6 (3 links)
  - RDM6-TP4 (1 link)

#### 3.3 Testing

- [ ] Rebuild Docker containers to apply schema changes
- [ ] Verify optical_links table no longer has c_slot/l_slot columns
- [ ] Ensure existing RSA logic references endpoint bitmap_value instead
- [ ] Confirm link status field still functions correctly

### Expected Outcome

The `OpticalLink` model will be cleaner and aligned with endpoint-based frequency management. All slot availability tracking will be handled through endpoint `bitmap_value` fields, eliminating data duplication and potential inconsistencies.

---

## Task 4: Update Devices Web Interface to Display Vendor and Model

### Objective

Enhance the devices listing web interface to display the newly added `vendor` and `model` fields, providing users with complete device information at a glance.

### Current State

- URL: `http://localhost:3000/devices`
- Route: `@app.route('/devices')` in `app.py`
- Template: `templates/devices.html`
- Current columns: UUID, Name, Type, Action

### Rationale

- Users need to see vendor and model information for device identification
- Facilitates quick device inventory review
- Aligns UI with enhanced data model
- No business logic changes needed (data already queried)

### Subtasks

#### 4.1 Update HTML Template

- [ ] Add `Vendor` column header to the table in `devices.html`
- [ ] Add `Model` column header to the table in `devices.html`
- [ ] Display `device.vendor` value in table row
- [ ] Display `device.model` value in table row
- [ ] Maintain Bootstrap styling consistency
- [ ] Handle null/empty values gracefully (display "-" or "N/A")

#### 4.2 Verify Business Logic

- [ ] Confirm `@app.route('/devices')` already fetches all device fields
- [ ] No changes needed to `app.py` (ORM automatically includes new fields)
- [ ] Test that vendor/model data flows to template correctly

#### 4.3 Testing

- [ ] Access `http://localhost:3000/devices`
- [ ] Verify Vendor and Model columns appear in table
- [ ] Confirm all device rows show correct vendor/model data
- [ ] Check responsive layout on different screen sizes
- [ ] Verify styling matches existing table design

### Expected Outcome

The devices listing page will display a comprehensive table with UUID, Name, Type, Vendor, Model, and Action columns, providing complete device information for network inventory management.

---

## Task 5: Enhance Device Details Page with Endpoint Frequency Information

### Objective

Update the device details page to display endpoint frequency capabilities and provide navigation to individual endpoint frequency views. This completes the endpoint enhancement by exposing frequency data to end users.

### Current State

- URL: `http://localhost:3000/device-details/<device_id>`
- Route: `@app.route('/device-details/<uuid:device_id>')` in `app.py`
- Template: `templates/device_details.html`
- Current endpoint columns: UUID, Name, Type, OTN Type, In Use

### Rationale

- Users need to see endpoint frequency capabilities for spectrum planning
- Frequency values must be displayed in Hz (industry standard) not GHz (database storage)
- Navigation to detailed endpoint view enables deeper analysis
- Supports frequency range validation and slot allocation decisions

### Subtasks

#### 5.1 Update Device Details Template

- [ ] Add `Min Frequency (Hz)` column to endpoints table in `device_details.html`
- [ ] Add `Max Frequency (Hz)` column to endpoints table
- [ ] Add `Action` column with "Frequency View" button
- [ ] Implement GHz to Hz conversion (multiply by 10^9)
  - Database: 191556.25 GHz → Display: 191,556,250,000,000 Hz (191.556 THz)
  - Database: 195937.5 GHz → Display: 195,937,500,000,000 Hz (195.938 THz)
- [ ] Format frequency values with thousand separators for readability
- [ ] Handle null frequency values gracefully (display "N/A")
- [ ] Style "Frequency View" button consistently with other action buttons

#### 5.2 Create Endpoint Details Route

- [ ] Add new route `/endpoint-details/<uuid:endpoint_id>` in `app.py`
- [ ] Query endpoint data using `Endpoint.query.get_or_404(endpoint_id)`
- [ ] Pass endpoint object to new template
- [ ] Include device information via foreign key relationship
- [ ] Handle non-existent endpoint IDs with 404 error

#### 5.3 Create Endpoint Frequency View Template

- [ ] Create `templates/device_endpoint_frequency_view.html`
- [ ] Display endpoint basic information (name, type, OTN type)
- [ ] Show device information (name, vendor, model)
- [ ] Display frequency capabilities:
  - Min Frequency (Hz and THz)
  - Max Frequency (Hz and THz)
  - Flexible Slots count
  - Frequency range bandwidth
- [ ] Add placeholder for bitmap visualization (next task)
- [ ] Include navigation: Back to Device Details, Back to Devices
- [ ] Apply consistent Bootstrap styling

#### 5.4 Testing

- [ ] Access device details page for any device
- [ ] Verify new frequency columns display correct Hz values
- [ ] Check thousand separator formatting
- [ ] Click "Frequency View" button for each endpoint
- [ ] Verify endpoint details page loads correctly
- [ ] Confirm all endpoint data displays accurately
- [ ] Test back navigation buttons
- [ ] Verify 404 handling for invalid endpoint IDs

### Expected Outcome

The device details page will show a comprehensive endpoints table including frequency range information in Hz. Each endpoint will have a "Frequency View" button linking to a dedicated endpoint details page showing complete frequency capability information. This provides users with full visibility into optical port specifications for spectrum management.

---

## Task 6: Dynamic Optical Band Detection Using Enums

### Objective

Enhance the endpoint frequency view to dynamically detect optical bands (O, E, S, C, L) based on actual frequency ranges instead of hardcoded values. Implement modular design using OpticalBands.py enum classes to ensure standards compliance and maintainability.

### Context

Currently, the endpoint frequency view hardcodes "C-band" and wavelength ranges. However, endpoints may support different optical bands, and proper band detection requires comparing actual frequencies against ITU-T standards. The OpticalBands.py enum file provides standardized frequency ranges, wavelength ranges, and band names that should be used throughout the application.

### Subtasks

#### 6.1 Create Optical Band Detection Helper

**Files to Modify:**

- `helpers.py`

**Changes Required:**

- Import enum classes from `enums.OpticalBands`: `FreqeuncyRanges`, `Bands`, `Lambdas`, `FrequencyMeasurementUnit`
- Create new `OpticalBandHelper` class with static method `detect_band(min_frequency_ghz, max_frequency_ghz)`
- Convert input frequencies from GHz to Hz using `FrequencyMeasurementUnit.GHz.value`
- Iterate through `FreqeuncyRanges` enum to find matching band
- Note: FrequencyRanges stores tuples as (max_hz, min_hz) - reversed order
- Return dictionary containing:
  - `band_name`: Band letter (e.g., "C") from `Bands` enum
  - `band_enum_name`: Full enum name (e.g., "C_BAND")
  - `wavelength_range`: Tuple from `Lambdas` enum (e.g., (1530, 1565))
  - `frequency_range_hz`: Tuple from `FreqeuncyRanges` enum
- Handle edge cases with 1% tolerance for quantization effects
- Return `None` if no band matches

#### 6.2 Update Endpoint Details Route

**Files to Modify:**

- `app.py`

**Changes Required:**

- Import `OpticalBandHelper` from `helpers`
- In `endpoint_details()` route, call `OpticalBandHelper.detect_band()` with endpoint's min/max frequencies
- Pass `band_info` dictionary to template alongside `endpoint` and `device`
- Ensure null handling for endpoints without frequency data

#### 6.3 Update Endpoint Frequency View Template

**Files to Modify:**

- `templates/device_endpoint_frequency_view.html`

**Changes Required:**

- Replace hardcoded wavelength range `~1530-1565 nm (C-band)` with dynamic values
- Add "Optical Band" field showing `{{ band_info.band_name }}-band`
- Display wavelength range as `{{ band_info.wavelength_range[0] }}-{{ band_info.wavelength_range[1] }} nm`
- Change "Slot Width" label to "Slot Granularity" (more accurate terminology)
- Add conditional rendering: show "Not detected" if `band_info` is None
- Maintain existing frequency display in Hz and THz

### Technical Notes

**Enum Structure:**

- All enum classes use matching variable names (O_BAND, E_BAND, S_BAND, C_BAND, L_BAND)
- Once band is detected from `FreqeuncyRanges`, same enum name can fetch:
  - Band letter from `Bands[name].value`
  - Wavelength range from `Lambdas[name].value`

**FrequencyMeasurementUnit Usage:**

- Use `.value` to get conversion factor (e.g., `GHz.value = 1000000000`)
- Multiply by this factor to convert GHz → Hz
- Example: `191556.25 GHz × 1e9 = 191556250000000 Hz`

**Terminology:**

- "Slot Width" refers to fixed 12.5 GHz channels (not used in flex-grid)
- "Slot Granularity" refers to 6.25 GHz flex-grid spacing (correct for this project)

### Testing Procedure

- [ ] Start Flask application with `docker-compose up`
- [ ] Navigate to any device details page
- [ ] Click "Frequency View" for an endpoint
- [ ] Verify "Optical Band" shows "C-band" (for C-band test data)
- [ ] Verify wavelength range shows "1530-1565 nm" (from Lambdas enum)
- [ ] Confirm "Slot Granularity" label (not "Slot Width")
- [ ] Test with different band data if available (O, E, S, L bands)
- [ ] Verify "Not detected" shows for endpoints without frequency data
- [ ] Check browser console for any JavaScript errors
- [ ] Validate band detection logic with different frequency ranges

### Expected Outcome

The endpoint frequency view will dynamically detect and display the correct optical band based on actual frequency ranges. Band names, wavelength ranges, and terminology will be derived from standardized enum classes, ensuring consistency with ITU-T standards and eliminating hardcoded values. The modular design will allow easy extension to support all optical bands (O, E, S, C, L) and facilitate future enhancements.

---

## Task 7: Spectrum Allocation Visualization

### Objective

Implement comprehensive spectrum visualization that displays all standard band slots according to ITU-T G.694.1, showing device capability boundaries, allocated slots, and available slots. This visualization must align with ITU standards even when endpoint capabilities differ from the full band range.

### Context

**Critical Design Principle:**  
Visualization follows ITU standards, not device capabilities. If an endpoint supports fewer slots than the standard band, the visualization shows ALL standard slots but marks unsupported frequencies as UNAVAILABLE.

**Three Availability States:**

1. **UNAVAILABLE** - Outside device's frequency capability range
2. **AVAILABLE** - Within device range, free for allocation
3. **IN_USE** - Within device range, currently allocated

**Example Scenario:**

- Standard C-band: 191556.25-195937.5 GHz (700 slots)
- Device endpoint: 191506.25-195887.5 GHz (684 slots, missing 8 on each end)
- Visualization: Shows all 700 standard slots
  - Slots 0-7: UNAVAILABLE (below device min)
  - Slots 8-691: AVAILABLE or IN_USE (based on bitmap)
  - Slots 692-699: UNAVAILABLE (above device max)

### Subtasks

#### 7.1 Create SpectrumHelper Class

**Files to Modify:**

- `helpers.py`

**Import Statements:**

```python
from enums.ITUStandards import ITUStandards
from enums.Device import Constants
```

**New Class Structure:**

```python
class SpectrumHelper:
    @staticmethod
    def build_spectrum_slot_table(endpoint, band_info):
        """Build spectrum slot table with availability status"""
        
    @staticmethod
    def _determine_slot_availability(frequency_hz, endpoint_min_hz, 
                                     endpoint_max_hz, slot_granularity_hz, 
                                     bitmap_value):
        """Determine availability status for a specific slot"""
```

**Algorithm Steps:**

1. **Get ITU Standards:**
   - `slot_granularity_hz = ITUStandards.SLOT_GRANULARITY.value` (6.25 GHz in Hz)
   - `anchor_frequency_hz = ITUStandards.ANCHOR_FREQUENCY.value` (193.1 THz in Hz)

2. **Calculate Standard Slots:**
   - `operational_bandwidth_hz = band_max_hz - band_min_hz`
   - `standard_slots = operational_bandwidth_hz / slot_granularity_hz`
   - For C-band: (195937500000000 - 191556250000000) / 6250000000 = 700 slots

3. **Build Slot Table:**
   - Loop from 0 to standard_slots-1
   - For each slot:
     - `frequency_hz = band_min_hz + (slot_index × slot_granularity_hz)`
     - `is_anchor = (frequency_hz ≈ anchor_frequency_hz)` within tolerance
     - `availability = _determine_slot_availability(...)`

4. **Determine Availability Logic:**

   ```python
   if frequency_hz < endpoint_min_hz or frequency_hz > endpoint_max_hz:
       return Constants.UNAVAILABLE.value
   
   # Within endpoint range - check bitmap
   bit_position = (frequency_hz - endpoint_min_hz) / slot_granularity_hz
   bit_value = (bitmap_value >> bit_position) & 1
   
   if bit_value == 1:
       return Constants.AVAILABLE.value  # Free
   else:
       return Constants.IN_USE.value     # Allocated
   ```

**Bitmap Interpretation:**

- **LSB Ordering:** Bit 0 (LSB) = endpoint_min_frequency
- **Bit Value = 1:** Slot is AVAILABLE (free)
- **Bit Value = 0:** Slot is IN_USE (allocated)
- **Reference Bitmap:** 2^endpoint_slots (all slots available)
- **Current Bitmap:** From database (shows actual allocation)

**Return Value:**

```python
[
    {
        'frequency': 191556250000000,  # Hz
        'availability': 'AVAILABLE',
        'is_anchor': False
    },
    {
        'frequency': 193100000000000,  # Anchor
        'availability': 'IN_USE',
        'is_anchor': True
    },
    ...
]
```

#### 7.2 Update endpoint_details Route

**Files to Modify:**

- `app.py`

**Import Additions:**

```python
from helpers import OpticalBandHelper, SpectrumHelper
from enums.ITUStandards import ITUStandards
```

**Route Logic:**

```python
@app.route('/endpoint-details/<uuid:endpoint_id>')
def endpoint_details(endpoint_id):
    # ... existing code ...
    
    # Get slot granularity
    slot_granularity = ITUStandards.SLOT_GRANULARITY.value
    
    # Build spectrum slot table
    slot_table = []
    if band_info:
        slot_table = SpectrumHelper.build_spectrum_slot_table(endpoint, band_info)
    
    return render_template('device_endpoint_frequency_view.html',
                         endpoint=endpoint,
                         device=device,
                         band_info=band_info,
                         slot_table=slot_table,
                         slot_granularity=slot_granularity)
```

**Data Passed to Template:**

- `endpoint` - Endpoint model instance
- `device` - Device model instance
- `band_info` - Band detection results
- `slot_table` - List of all slots with availability
- `slot_granularity` - ITU slot granularity in Hz

#### 7.3 Update Template with Spectrum Table

**Files to Modify:**

- `templates/device_endpoint_frequency_view.html`

**Replace "Spectrum Availability" Card:**

**New Structure:**

```html
<div class="card mb-4">
  <div class="card-header bg-warning text-dark">
    Spectrum Allocation Table
  </div>
  <div class="card-body">
    <!-- Slot Granularity Display -->
    <p><strong>Slot Granularity:</strong> 
      {{ "{:.2f}".format(slot_granularity | hz_to_ghz) }} GHz
    </p>
    
    <!-- Legend -->
    <p class="text-muted">
      <span class="badge bg-secondary">UNAVAILABLE</span> Outside device |
      <span class="badge bg-success">AVAILABLE</span> Free |
      <span class="badge bg-warning">IN_USE</span> Allocated |
      <span class="badge bg-info">ANCHOR</span> ITU anchor
    </p>
    
    <!-- Scrollable Table -->
    <div class="table-responsive" style="max-height: 500px;">
      <table class="table table-sm table-bordered">
        <thead class="sticky-top">
          <tr>
            <th>Slot #</th>
            <th>Frequency (THz)</th>
            <th>Availability</th>
          </tr>
        </thead>
        <tbody>
          {% for slot in slot_table %}
          <tr class="{% if slot.is_anchor %}table-info
                     {% elif slot.availability == 'UNAVAILABLE' %}table-secondary
                     {% elif slot.availability == 'AVAILABLE' %}table-success
                     {% elif slot.availability == 'IN_USE' %}table-warning
                     {% endif %}">
            <td>{{ loop.index0 }}</td>
            <td>{{ "{:.6f}".format(slot.frequency | hz_to_thz) }}</td>
            <td>
              {% if slot.is_anchor %}
              <span class="badge bg-info">ANCHOR - {{ slot.availability }}</span>
              {% else %}
              <span class="badge">{{ slot.availability }}</span>
              {% endif %}
            </td>
          </tr>
          {% endfor %}
        </tbody>
      </table>
    </div>
    
    <!-- Summary Statistics -->
    <div class="mt-3">
      <p><strong>Summary:</strong></p>
      <ul>
        <li>Total Standard Slots: {{ slot_table | length }}</li>
        <li>Device Slots: {{ endpoint.flex_slots }}</li>
        <li>Unavailable: {{ slot_table | selectattr('availability', 'equalto', 'UNAVAILABLE') | list | length }}</li>
        <li>Available: {{ slot_table | selectattr('availability', 'equalto', 'AVAILABLE') | list | length }}</li>
        <li>In Use: {{ slot_table | selectattr('availability', 'equalto', 'IN_USE') | list | length }}</li>
      </ul>
    </div>
  </div>
</div>
```

**Color Scheme:**

- `table-secondary` (gray) - UNAVAILABLE
- `table-success` (green) - AVAILABLE
- `table-warning` (yellow) - IN_USE
- `table-info` (cyan) - Anchor frequency

**Features:**

- Fixed header with `sticky-top`
- Scrollable body (500px max height)
- Row coloring by availability
- Special highlighting for anchor frequency
- Summary statistics with Jinja2 filters

### Technical Details

#### ITU Standards Reference

**Anchor Frequency:**

- **Value:** 193.100 THz (193100000000000 Hz)
- **Purpose:** ITU-T G.694.1 reference point for flex-grid
- **Visual:** Special cyan highlighting in table

**Slot Granularity:**

- **Value:** 6.25 GHz (6250000000 Hz)
- **Purpose:** Minimum frequency spacing in flex-grid
- **Usage:** Calculate slot boundaries

**Slot Width:**

- **Value:** 12.5 GHz (not used in this implementation)
- **Note:** Fixed-grid parameter, not applicable to flex-grid

#### Bitmap Operations

**LSB (Least Significant Bit) Ordering:**

```
Bitmap: ...0101101
         │││││││
         │││││││
Bit 0 (LSB) ───┘│││││└── Bit 6 (MSB for 7-bit example)
Bit 1 ──────────┘││││
Bit 2 ───────────┘│││
...
```

**Frequency to Bit Mapping:**

```python
# Endpoint range: 191556.25 - 195937.5 GHz (700 slots)
# Bitmap: 2^700 (all 1s = all available)

frequency = 191562.5 GHz  # First slot after min
bit_position = (191562.5 - 191556.25) / 6.25 = 1

# Extract bit 1
bit_value = (bitmap_value >> 1) & 1
# If bit_value == 1: AVAILABLE
# If bit_value == 0: IN_USE
```

**Example:**

```python
endpoint_min = 191556250000000 Hz
slot_frequency = 191562500000000 Hz
granularity = 6250000000 Hz

bit_pos = (191562500000000 - 191556250000000) / 6250000000
        = 6250000000 / 6250000000
        = 1

bit_value = (bitmap >> 1) & 1
```

#### Capability vs Usage Distinction

**Three Scenarios:**

1. **Below Device Minimum:**

   ```
   Standard slot: 191550.0 GHz
   Device min: 191556.25 GHz
   Status: UNAVAILABLE (device can't use this frequency)
   ```

2. **Within Device Range - Free:**

   ```
   Standard slot: 191600.0 GHz
   Device range: 191556.25 - 195937.5 GHz
   Bitmap bit: 1
   Status: AVAILABLE (device can use, currently free)
   ```

3. **Within Device Range - Allocated:**

   ```
   Standard slot: 193100.0 GHz (anchor)
   Device range: 191556.25 - 195937.5 GHz
   Bitmap bit: 0
   Status: IN_USE (device can use, currently allocated)
   ```

4. **Above Device Maximum:**

   ```
   Standard slot: 195943.75 GHz
   Device max: 195937.5 GHz
   Status: UNAVAILABLE (device can't use this frequency)
   ```

### Testing Procedure

#### Step 1: Verify Spectrum Table Display

- [ ] Navigate to endpoint details page
- [ ] Verify "Spectrum Allocation Table" card appears
- [ ] Check table shows slot #, frequency (THz), availability columns
- [ ] Confirm table is scrollable (500px height)
- [ ] Verify header stays fixed when scrolling

#### Step 2: Test Slot Calculations

**For Full-Range Endpoint (700 slots):**

- [ ] Total slots = 700
- [ ] First slot frequency = 191.556250 THz
- [ ] Last slot frequency = 195.931250 THz (195937.5 - 6.25 GHz)
- [ ] Unavailable count = 0 (device supports full band)

**For Reduced-Range Endpoint (684 slots):**

- [ ] Total slots = 700 (still shows full standard)
- [ ] Unavailable slots = 16 (8 on each end)
- [ ] Available + In Use = 684 (device capability)

#### Step 3: Verify Anchor Frequency

- [ ] Find row with frequency 193.100000 THz
- [ ] Verify row has cyan background (table-info)
- [ ] Verify badge shows "ANCHOR - [status]"
- [ ] Status can be AVAILABLE, IN_USE, or UNAVAILABLE

#### Step 4: Test Bitmap Interpretation

**Create Test Endpoint:**

```sql
-- Endpoint with specific bitmap pattern
UPDATE endpoints 
SET bitmap_value = '15'  -- Binary: 1111 (4 slots, all available)
WHERE name = 'test-port';
```

Expected:

- [ ] All 4 device-capable slots show AVAILABLE
- [ ] Slots outside range show UNAVAILABLE

**Test Allocated Slots:**

```sql
-- Allocate slot 2 (set bit 2 to 0)
-- Original: 1111 (15), After: 1011 (11)
UPDATE endpoints 
SET bitmap_value = '11'
WHERE name = 'test-port';
```

Expected:

- [ ] Slot 0: AVAILABLE (bit 0 = 1)
- [ ] Slot 1: AVAILABLE (bit 1 = 1)
- [ ] Slot 2: IN_USE (bit 2 = 0)
- [ ] Slot 3: AVAILABLE (bit 3 = 1)

#### Step 5: Validate Color Coding

- [ ] UNAVAILABLE slots: Gray background (table-secondary)
- [ ] AVAILABLE slots: Green background (table-success)
- [ ] IN_USE slots: Yellow background (table-warning)
- [ ] ANCHOR row: Cyan background (table-info)

#### Step 6: Check Summary Statistics

- [ ] Total Standard Slots matches band (700 for C-band)
- [ ] Device Slots matches endpoint.flex_slots
- [ ] Unavailable + Available + In Use = Total Standard Slots
- [ ] Available + In Use ≤ Device Slots

#### Step 7: Test Edge Cases

**No Frequency Data:**

- [ ] Endpoint with NULL min/max frequencies
- [ ] Should show "not available" message

**Band Detection Failure:**

- [ ] Endpoint with frequencies outside all bands
- [ ] Should handle gracefully with empty slot_table

**Full Allocation:**

- [ ] Bitmap = 0 (all bits 0)
- [ ] All device-capable slots show IN_USE
- [ ] No AVAILABLE slots

**No Allocation:**

- [ ] Bitmap = 2^endpoint_slots (all bits 1)
- [ ] All device-capable slots show AVAILABLE
- [ ] No IN_USE slots

### Expected Outcome

The endpoint frequency view will display a comprehensive spectrum allocation table showing all standard ITU-T G.694.1 slots for the detected optical band. The visualization clearly distinguishes between:

- Device capability boundaries (UNAVAILABLE outside range)
- Free spectrum (AVAILABLE within range, bitmap bit = 1)
- Allocated spectrum (IN_USE within range, bitmap bit = 0)
- ITU anchor frequency (special highlighting)

Users can scroll through all slots, identify allocation patterns, and understand both hardware limitations and current spectrum usage. The implementation uses enum-based constants for maintainability and follows ITU standards precisely, even when device capabilities differ from the full band range.

- [ ] Validate band detection logic with different frequency ranges

### Expected Outcome

The endpoint frequency view will dynamically detect and display the correct optical band based on actual frequency ranges. Band names, wavelength ranges, and terminology will be derived from standardized enum classes, ensuring consistency with ITU-T standards and eliminating hardcoded values. The modular design will allow easy extension to support all optical bands (O, E, S, C, L) and facilitate future enhancements.

---

## Task 8: Multi-Band Support for Endpoints

### Objective

Extend the optical band detection and spectrum visualization system to support endpoints that span multiple optical bands simultaneously (e.g., CL, SCL, WHOLE_BAND). This is common in ROADM devices where WSS ports are band-agnostic and can support wide frequency ranges.

### Background

Real-world optical network equipment, especially ROADM WSS ports, often supports multiple bands:

- **Single-band devices**: O, E, S, C, or L band only
- **Dual-band devices**: CL (C+L combined)
- **Triple-band devices**: SCL (S+C+L combined)
- **Full-spectrum devices**: WHOLE_BAND (O+E+S+C+L)

The existing implementation (Task 6-7) was designed for single-band endpoints. Task 8 enhances the system to automatically detect and visualize multi-band scenarios.

### Key Design Principles

1. **Standard-Based Visualization**: Spectrum table always follows ITU standard range for the detected operational band, not device limits
2. **Wide Bandwidth Support**: Reference bitmap expands across entire standard range of multi-band
3. **Dynamic Band Detection**: System automatically identifies whether endpoint is single-band or multi-band
4. **Clean Presentation**: Remove Hz representation, use THz-only for cleaner UI

### Subtasks

#### 8.1 Update OpticalBandHelper for Multi-Band Detection

**File**: `helpers.py`

- [x] Modify `detect_band()` method to support multi-band matching
- [x] Check endpoint frequency range against all bands in `FreqeuncyRanges` enum
- [x] Prioritize multi-band matches (CL, SCL, WHOLE_BAND) over single-band matches
- [x] Return band info with correct `band_name` from `Bands` enum (e.g., "C, L" for CL_BAND)
- [x] Ensure `wavelength_range` and `frequency_range_hz` reflect full multi-band range

**Implementation Notes**:

- Use 1% tolerance for frequency range matching
- Multi-band entries in `OpticalBands.py` already include combined ranges
- `Bands.CL_BAND.value` returns "C, L" (comma-separated for display)

#### 8.2 Update HTML Template for Multi-Band Display

**File**: `templates/device_endpoint_frequency_view.html`

**Changes Required**:

1. **Remove Hz Representation**:
   - [x] Remove Hz display under "Minimum Frequency"
   - [x] Remove Hz display under "Maximum Frequency"
   - [x] Keep only THz representation for cleaner UI

2. **Update Optical Band Display**:
   - [x] Change from `{{ band_info.band_name }}-band` to `{{ band_info.band_name }}-Band`
   - [x] This ensures multi-band names display correctly (e.g., "C, L-Band" instead of "CL-band")
   - [x] Dynamic band name automatically adapts to detected band

**No Changes Required**:

- Spectrum Allocation Table logic remains unchanged
- Reference bitmap expansion already works for any band width
- Slot calculation (`standard_slots = bandwidth / granularity`) is bandwidth-agnostic

#### 8.3 Testing Multi-Band Scenarios

**Test Case 1: CL-Band Endpoint (C+L combined)**

Setup:

- `min_frequency`: 188450000000000 Hz (L-band min)
- `max_frequency`: 195937500000000 Hz (C-band max)
- `flex_slots`: 1199 (CL bandwidth / 6.25 GHz)
- `bitmap_value`: 2^1199

Expected Results:

- [ ] Band detection returns "C, L"
- [ ] Wavelength range: 1530-1625 nm
- [ ] Spectrum table shows 1199 standard slots
- [ ] All slots marked AVAILABLE (full bitmap)
- [ ] Optical Band displays as "C, L-Band"

**Test Case 2: SCL-Band Endpoint (S+C+L combined)**

Setup:

- `min_frequency`: 188450000000000 Hz (L-band min)
- `max_frequency`: 205325000000000 Hz (S-band max)
- `flex_slots`: 2701 (SCL bandwidth / 6.25 GHz)
- `bitmap_value`: 2^2701

Expected Results:

- [ ] Band detection returns "S, C, L"
- [ ] Wavelength range: 1460-1625 nm
- [ ] Spectrum table shows 2701 standard slots
- [ ] Optical Band displays as "S, C, L-Band"

**Test Case 3: Partial Multi-Band (device narrower than standard)**

Setup:

- `min_frequency`: 189000000000000 Hz (within L-band)
- `max_frequency`: 195000000000000 Hz (within C-band)
- `flex_slots`: 960 (actual device capability)
- `bitmap_value`: Random allocation pattern

Expected Results:

- [ ] Band detection returns "C, L" (still CL-band)
- [ ] Spectrum table shows full 1199 CL standard slots
- [ ] Slots outside device range (188450-189000 GHz and 195000-195937.5 GHz) marked UNAVAILABLE
- [ ] Device-capable slots show AVAILABLE/IN_USE based on bitmap

**Test Case 4: WHOLE_BAND Support**

Setup:

- `min_frequency`: 188450000000000 Hz (L-band min)
- `max_frequency`: 237925000000000 Hz (O-band max)
- `flex_slots`: 7917 (whole band slots)
- `bitmap_value`: 2^7917

Expected Results:

- [ ] Band detection returns "O, E, S, C, L"
- [ ] Wavelength range: 1260-1625 nm
- [ ] Spectrum table shows 7917 standard slots
- [ ] Optical Band displays as "O, E, S, C, L-Band"
- [ ] Very large table (test scrolling and performance)

#### 8.4 Verify Backward Compatibility

Ensure single-band endpoints still work correctly:

- [ ] C-band only endpoint (191556250000000 - 195937500000000 Hz)
- [ ] Band detection returns "C" (not "C, L" or other multi-band)
- [ ] Spectrum table shows 701 C-band slots
- [ ] Optical Band displays as "C-Band"

### Implementation Summary

**Modified Files**:

1. `helpers.py` - Enhanced `OpticalBandHelper.detect_band()` with multi-band priority logic
2. `device_endpoint_frequency_view.html` - Removed Hz display, updated band name formatting

**Unchanged Files**:

- `app.py` - No changes needed (route logic is bandwidth-agnostic)
- `OpticalBands.py` - Already includes multi-band enums
- `SpectrumHelper.build_spectrum_slot_table()` - Works with any bandwidth
- Database models and SQL - No schema changes required

### Key Benefits

1. **Flexibility**: System automatically adapts from narrow single-band to ultra-wide multi-band
2. **Standards Compliance**: Always visualizes full ITU standard range, even if device is narrower
3. **Real-World Alignment**: Supports actual ROADM WSS port capabilities
4. **Modularity**: Uses enum-based band definitions for easy extension
5. **Clean UI**: THz-only display reduces clutter, improves readability

### Expected Outcome

The optical spectrum visualization system will seamlessly handle both single-band and multi-band endpoints. Band detection will prioritize the **narrowest matching band** that contains the endpoint's frequency range (e.g., if endpoint fits within C-band, it will detect "C_BAND" even though wider bands like CL or WHOLE_BAND would also technically contain it). The spectrum allocation table will expand to show all standard slots for the detected operational band, properly marking device capability boundaries with UNAVAILABLE status when the device range is narrower than the standard. The UI will display multi-band names clearly (e.g., "C, L-Band", "S, C, L-Band"), and the THz-only frequency representation will provide a cleaner, more professional interface.

---

## Task 8.1: Fix Band Detection Logic - Prefer Narrowest Band

### Objective

Correct the band detection algorithm to select the **smallest/narrowest band** that contains the endpoint's frequency range, rather than defaulting to wider multi-band options.

### Problem Statement

**Issue**: The original Task 8 implementation prioritized multi-band matches (CL, SCL, WHOLE_BAND) over single-band matches. This caused C-band endpoints to incorrectly expand to WHOLE_BAND, creating unnecessarily large spectrum tables (7917 slots instead of 701).

**Example of Incorrect Behavior**:

- Endpoint: 191556250000000 - 195937500000000 Hz (C-band range)
- Old logic: Matched WHOLE_BAND (priority = 5 bands)
- Result: 7917 slots displayed instead of 701

**Root Cause**: Priority was calculated as `len(band_name.split(', '))`, prioritizing bands with more comma-separated names.

### Solution

Change the sorting algorithm from "most bands covered" to "smallest band width":

**Old Logic** (WRONG):

```python
'priority': len(band_name.split(', '))  # Multi-band has higher priority
band_matches.sort(key=lambda x: x['priority'], reverse=True)  # Descending
```

**New Logic** (CORRECT):

```python
'band_width_hz': band_max_hz - band_min_hz  # Used for sorting
band_matches.sort(key=lambda x: x['band_width_hz'])  # Ascending - prefer narrowest
```

### Implementation

**File**: `helpers.py` - `OpticalBandHelper.detect_band()`

**Changes**:

- [x] Replace `priority` calculation with `band_width_hz` calculation
- [x] Change sort order from descending to ascending
- [x] Update key deletion from `del best_match['priority']` to `del best_match['band_width_hz']`
- [x] Update docstring to clarify "smallest band" logic

**Key Algorithm**:

```python
# Calculate band width (for sorting - we want SMALLEST band)
band_width_hz = band_max_hz - band_min_hz

# Sort by band width (ascending) - prefer narrowest band
band_matches.sort(key=lambda x: x['band_width_hz'])
best_match = band_matches[0]  # Smallest band that contains endpoint
```

### Testing Scenarios

**Test Case 1: C-Band Endpoint (should NOT expand to WHOLE_BAND)**

Setup:

- `min_frequency`: 191556250000000 Hz (C-band min)
- `max_frequency`: 195937500000000 Hz (C-band max)

Expected:

- [x] Band detection returns "C" (NOT "O, E, S, C, L")
- [x] Spectrum table shows 701 slots (NOT 7917)
- [x] UI displays "C-Band"

**Test Case 2: L-Band Endpoint (should NOT expand to CL)**

Setup:

- `min_frequency`: 188450000000000 Hz (L-band min)
- `max_frequency`: 191556250000000 Hz (L-band max)

Expected:

- [ ] Band detection returns "L" (NOT "C, L")
- [ ] Spectrum table shows 498 slots (NOT 1199)
- [ ] UI displays "L-Band"

**Test Case 3: CL-Band Endpoint (genuine multi-band)**

Setup:

- `min_frequency`: 188450000000000 Hz (L-band min)
- `max_frequency`: 195937500000000 Hz (C-band max)

Expected:

- [ ] Band detection returns "C, L" (correct - spans both bands)
- [ ] Spectrum table shows 1199 slots
- [ ] Cannot fit in just C-band or just L-band alone

**Test Case 4: Partial C-Band (narrower than standard)**

Setup:

- `min_frequency`: 191600000000000 Hz (within C-band)
- `max_frequency`: 195900000000000 Hz (within C-band)

Expected:

- [ ] Band detection returns "C" (still C-band)
- [ ] Spectrum table shows 701 standard C-band slots
- [ ] Slots outside device range marked UNAVAILABLE

### Band Width Reference

For sorting purposes:

| Band | Width (Hz) | Width (GHz) | Slots |
|------|------------|-------------|-------|
| L_BAND | 3,106,250,000,000 | 3,106.25 | 498 |
| C_BAND | 4,381,250,000,000 | 4,381.25 | 701 |
| CL_BAND | 7,487,500,000,000 | 7,487.50 | 1199 |
| S_BAND | 9,387,500,000,000 | 9,387.50 | 1501 |
| E_BAND | 15,100,000,000,000 | 15,100.00 | 2416 |
| O_BAND | 17,500,000,000,000 | 17,500.00 | 2800 |
| SCL_BAND | 16,875,000,000,000 | 16,875.00 | 2701 |
| WHOLE_BAND | 49,475,000,000,000 | 49,475.00 | 7917 |

Algorithm will always pick the smallest band that fully contains the endpoint's frequency range.

### Expected Outcome

After this fix:

1. C-band endpoints correctly show 701 slots (not 7917)
2. L-band endpoints correctly show 498 slots (not 1199 or 7917)
3. Multi-band detection only triggers when endpoint genuinely spans multiple bands
4. Visualization is appropriately sized for the actual operational band
5. No unnecessary expansion to wider bands
