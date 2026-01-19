# Using Python Enums in Jinja2 Templates

## Problem Statement

**Question:** Is it possible to use Python classes/enums in HTML templates?

**Answer:** Not directly. Jinja2 templates cannot import Python modules. However, we can bridge Python classes to templates using:

1. Custom Jinja2 filters (recommended)
2. Passing enum values through route context
3. Template global variables

## Our Solution: Custom Jinja2 Filters

### Implementation

We created custom filters in `app.py` that use the `FrequencyMeasurementUnit` enum from `OpticalBands.py`:

```python
from enums.OpticalBands import FrequencyMeasurementUnit

@app.template_filter('hz_to_thz')
def hz_to_thz_filter(value_hz):
    """Convert Hz to THz using FrequencyMeasurementUnit enum"""
    if value_hz is None:
        return None
    return value_hz / FrequencyMeasurementUnit.THz.value

@app.template_filter('hz_to_ghz')
def hz_to_ghz_filter(value_hz):
    """Convert Hz to GHz using FrequencyMeasurementUnit enum"""
    if value_hz is None:
        return None
    return value_hz / FrequencyMeasurementUnit.GHz.value

@app.template_filter('format_hz')
def format_hz_filter(value_hz):
    """Format Hz with thousand separators"""
    if value_hz is None:
        return 'N/A'
    return "{:,.0f}".format(value_hz)
```

### Usage in Templates

#### Before (Hardcoded Conversion)

```html
<!-- Manual conversion with magic numbers -->
<p>{{ "{:,.0f}".format(endpoint.min_frequency * 1e9) }} Hz</p>
<p>{{ "{:.3f}".format(endpoint.min_frequency / 1000) }} THz</p>
```

**Problems:**

- Magic numbers (1e9, 1000) scattered in templates
- No connection to OpticalBands.py standards
- Assumed database stored GHz (incorrect!)
- Error-prone and inconsistent

#### After (Using Filters)

```html
<!-- Using custom filters with enum -->
<p>{{ endpoint.min_frequency | format_hz }} Hz</p>
<p>{{ "{:.3f}".format(endpoint.min_frequency | hz_to_thz) }} THz</p>
<p>{{ "{:,.2f}".format((endpoint.max_frequency - endpoint.min_frequency) | hz_to_ghz) }} GHz</p>
```

**Benefits:**

- Uses `FrequencyMeasurementUnit` enum values
- Single source of truth
- Correct assumption (database stores Hz)
- Consistent across all templates
- Easy to maintain

## Database Storage Convention

### Current State

**All frequencies stored in Hz (Hertz)**

Example from `device_endpoints.sql`:

```sql
INSERT INTO endpoints (..., min_frequency, max_frequency, ...)
VALUES (..., 191556250000, 195937500000, ...);
```

Values:

- `191556250000` Hz = 191556.25 GHz = 191.556 THz (C-band minimum)
- `195937500000` Hz = 195937.5 GHz = 195.938 THz (C-band maximum)

### Why Hz?

| Unit | Storage Size | Precision | Readability |
|------|-------------|-----------|-------------|
| Hz | Large integer | Exact | Poor |
| GHz | Float | Rounding errors | Good |
| THz | Float | Rounding errors | Good |

**Decision:** Store in Hz for precision, display in GHz/THz for readability.

## OpticalBands.py Integration

### Enum Structure

```python
class FrequencyMeasurementUnit(Enum):
    KHz = 1000
    MHz = 1000000
    GHz = 1000000000       # 1e9
    THz = 1000000000000    # 1e12
```

### Conversion Logic

**Hz → THz:**

```python
# In filter
value_hz / FrequencyMeasurementUnit.THz.value
# Equivalent to: value_hz / 1e12

# Example: 191556250000 / 1e12 = 191.556 THz
```

**Hz → GHz:**

```python
# In filter
value_hz / FrequencyMeasurementUnit.GHz.value
# Equivalent to: value_hz / 1e9

# Example: 191556250000 / 1e9 = 191556.25 GHz
```

**Bandwidth Calculation:**

```python
# In template
(endpoint.max_frequency - endpoint.min_frequency) | hz_to_ghz
# (195937500000 - 191556250000) / 1e9 = 4381.25 GHz
```

## Complete Example

### Backend (app.py)

```python
from enums.OpticalBands import FrequencyMeasurementUnit

# Register filters
@app.template_filter('hz_to_thz')
def hz_to_thz_filter(value_hz):
    return value_hz / FrequencyMeasurementUnit.THz.value if value_hz else None

@app.template_filter('hz_to_ghz')
def hz_to_ghz_filter(value_hz):
    return value_hz / FrequencyMeasurementUnit.GHz.value if value_hz else None

@app.template_filter('format_hz')
def format_hz_filter(value_hz):
    return "{:,.0f}".format(value_hz) if value_hz else 'N/A'
```

### Template (device_endpoint_frequency_view.html)

```html
<div class="row">
  <div class="col-md-6">
    <h6 class="text-primary">Minimum Frequency</h6>
    <!-- Display in Hz with formatting -->
    <p class="mb-1"><strong>Hz:</strong> {{ endpoint.min_frequency | format_hz }} Hz</p>
    <!-- Display in THz using enum conversion -->
    <p><strong>THz:</strong> {{ "{:.3f}".format(endpoint.min_frequency | hz_to_thz) }} THz</p>
  </div>
  <div class="col-md-6">
    <h6 class="text-primary">Maximum Frequency</h6>
    <p class="mb-1"><strong>Hz:</strong> {{ endpoint.max_frequency | format_hz }} Hz</p>
    <p><strong>THz:</strong> {{ "{:.3f}".format(endpoint.max_frequency | hz_to_thz) }} THz</p>
  </div>
</div>
<hr>
<div class="row">
  <div class="col-md-6">
    <h6 class="text-primary">Frequency Range</h6>
    <!-- Calculate bandwidth and convert to GHz -->
    <p><strong>Bandwidth:</strong> 
      {{ "{:,.2f}".format((endpoint.max_frequency - endpoint.min_frequency) | hz_to_ghz) }} GHz
    </p>
  </div>
</div>
```

### Output

```
Minimum Frequency
Hz: 191,556,250,000,000 Hz
THz: 191.556 THz

Maximum Frequency
Hz: 195,937,500,000,000 Hz
THz: 195.938 THz

Frequency Range
Bandwidth: 4,381.25 GHz
```

## Filter Chaining

Jinja2 allows filter chaining for complex operations:

```html
<!-- Calculate bandwidth in GHz with formatting -->
{{ "{:,.2f}".format((endpoint.max_frequency - endpoint.min_frequency) | hz_to_ghz) }}

<!-- Flow: 
  1. Subtract frequencies (in Hz)
  2. Apply hz_to_ghz filter (divide by 1e9)
  3. Format with 2 decimals and thousand separators
-->
```

## Alternative Approach: Context Variables

### Method 2: Pass Enum to Template

```python
# In route
@app.route('/endpoint-details/<uuid:endpoint_id>')
def endpoint_details(endpoint_id):
    return render_template(
        'device_endpoint_frequency_view.html',
        endpoint=endpoint,
        FreqUnit=FrequencyMeasurementUnit  # Pass enum class
    )
```

```html
<!-- In template -->
<p>{{ endpoint.min_frequency / FreqUnit.THz.value }} THz</p>
```

**Downside:** Verbose, requires passing enum to every route

### Method 3: Global Template Variable

```python
# In app.py
@app.context_processor
def inject_enums():
    return dict(FreqUnit=FrequencyMeasurementUnit)
```

```html
<!-- Available in all templates -->
<p>{{ endpoint.min_frequency / FreqUnit.GHz.value }} GHz</p>
```

**Downside:** Less semantic than filters, clutters namespace

## Best Practices

### ✅ Do

1. Use custom filters for unit conversions
2. Reference enum values in filter implementations
3. Keep conversion logic in backend (filters)
4. Store precise values in database (Hz)
5. Display user-friendly units in templates (GHz, THz)

### ❌ Don't

1. Hardcode conversion factors in templates
2. Try to import Python modules in Jinja2
3. Store display units in database
4. Duplicate conversion logic across templates
5. Assume database units without verification

## Testing Filters

### Python Shell

```python
from app import app

with app.app_context():
    # Test filter
    from app import hz_to_thz_filter
    result = hz_to_thz_filter(191556250000)
    print(result)  # 191.55625
    
    # Verify against enum
    from enums.OpticalBands import FrequencyMeasurementUnit
    expected = 191556250000 / FrequencyMeasurementUnit.THz.value
    print(expected)  # 191.55625
    
    assert result == expected  # Pass!
```

### Template Testing

```html
<!-- Add debug output temporarily -->
<p>Database value: {{ endpoint.min_frequency }}</p>
<p>Hz: {{ endpoint.min_frequency | format_hz }}</p>
<p>GHz: {{ endpoint.min_frequency | hz_to_ghz }}</p>
<p>THz: {{ endpoint.min_frequency | hz_to_thz }}</p>
```

Expected output:

```
Database value: 191556250000
Hz: 191,556,250,000,000
GHz: 191556.25
THz: 191.55625
```

## Summary

**Question:** Can we use Python enums in HTML templates?  
**Answer:** Yes, through custom Jinja2 filters!

**Implementation:**

1. Create filters in `app.py` that use enum values
2. Register with `@app.template_filter` decorator
3. Apply in templates using pipe syntax: `{{ value | filter_name }}`

**Benefits:**

- Modular design (enum changes propagate automatically)
- Single source of truth (OpticalBands.py)
- Clean template syntax
- Type-safe conversions
- Easy to test and maintain

**Result:** Templates now properly use `FrequencyMeasurementUnit` enum for all frequency conversions, eliminating magic numbers and ensuring consistency with ITU-T standards.
