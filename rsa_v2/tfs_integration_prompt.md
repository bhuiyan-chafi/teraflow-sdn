# TeraFlowSDN Integration Prompt: Optical Controller & RSA

You can copy and paste the detailed technical prompt below into your IDE to jumpstart the integration into the TeraFlowSDN (TFS) codebase.

---

## Context: Goal & Features Summary

The objective is to implement a robust, WDM-aware Routing and Spectrum Allocation (RSA) engine within the TeraFlowSDN `OpticalController`. The implementation must support spectrum sharing on fiber links (WDM) while maintaining strict port isolation for transponders.

### Core Logic to Port

#### 1. OTN-Aware Topology (OCH/OMS)

The system must distinguish between two primary link types based on their endpoint metadata:

- OCH (Optical Channel): Transponder-to-ROADM links. These are strictly single-use per port.
- OMS (Optical Multiplex Section): ROADM-to-ROADM (fiber) links. These support spectrum sharing and are reusable until all slots are occupied.
- ERROR/MISMATCH: Explicitly flag and log links where endpoint OTN types are inconsistent.

#### 2. Spectrum Management (Bitmaps)

- Represent spectrum availability using 35-bit binary strings (bitmaps) for C-band (and optionally L-band).
- `1` indicates a FREE slot; `0` indicates a USED slot.
- Initial/Empty capacity for a standard link is $(2^{35} - 1)$ = `34359738367`.

#### 3. WDM-Aware Pathfinding (Filtered Dijkstra)

The topology graph must filter links dynamically during path computation:

- OCH Links: Include in the graph ONLY if status is `FREE`.
- OMS Links: Include in the graph if status is `FREE` OR `USED` (Exclude only if `FULL`).
- This allows the shortest path algorithm (Dijkstra) to "re-use" existing fiber trunks while avoiding blocked transponder ports.

#### 4. RSA Calculation Algorithm

- Strict Path Availability: To calculate path-wide availability, perform a bitwise `AND` across the `c_slot` bitmaps of every link in the path.
- Parallel Link Handling: If a hop consists of parallel links, first intersect the bitmaps of all links in that parallel group before intersecting with the path-wide result.
- Contiguous Slot Selection (First-Fit): Identify a sequence of contiguous `1`s in the final path bitmap that matches the required bandwidth (e.g., $12.5\,GHz$ slots).
- Mask Generation: Generate a bitmask where `1`s represent the newly reserved slots.

#### 5. Path Commitment & Idempotency

- Surgical Reservation: Use unique identifiers (UUIDs) for physical links.
- Slot Update: Reserve slots via `new_val = current_val & ~mask`.
- Status Promotion:
  - Mark `OCH` as `USED`.
  - Mark `OMS` as `FULL` only if both C and L bands reach 0 availability.
- Database Safety: Ensure idempotent insertions using `ON CONFLICT DO NOTHING` for initial topology loading.

---

### Instructions for Global System Study

"I have presented the core logic for a WDM-aware RSA system. Please perform the following steps:

1. Analyze `OpticalController`: Study the current implementation of the `OpticalController` in this TeraFlowSDN codebase.
2. Mapping: Identify where the pathfinding (Dijkstra), spectrum tracking, and service commitment logic currently reside.
3. Gap Analysis: Compare the current TFS implementation with the WDM logic, Path finding, parallel path handling, and spectrum tracking logic described above (specifically link re-use for OMS vs. strict filtering for OCH).
4. Implementation Strategy: Propose how to integrate these WDM-aware features while maintaining compatibility with the existing TFS framework."
