# Copyright 2022-2025 ETSI SDG TeraFlowSDN (TFS) (https://tfs.etsi.org/)
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

"""
[CHAFI-THESIS-START]
RSA (Routing and Spectrum Assignment) Helper Module for Parallel Optical Controller.

This module contains helper functions for RSA computation, including:
- Bandwidth calculation based on bitrate and modulation format
- Slot calculation for flex-grid spectrum allocation

Formula: B_n = (R_b / log2(M)) * (1 + alpha)
Where:
    - B_n = Nyquist bandwidth (same unit as R_b)
    - R_b = Bit rate (e.g., Gbps)
    - M = Number of symbols in modulation constellation
    - alpha = Roll-off factor (typically 0.1 to 0.5)
[CHAFI-THESIS-END]
"""

import math
import logging

# [CHAFI-THESIS-START] - Configure logging
logging.basicConfig(
    level=logging.DEBUG,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s',
    datefmt='%Y-%m-%d %H:%M:%S'
)
LOGGER = logging.getLogger(__name__)
# [CHAFI-THESIS-END]


# [CHAFI-THESIS-START] - Import ITU Standards
# Note: In the Docker container, the path is different, so we handle both cases
try:
    from common.ITUStandards import (
        ITUStandards,
        SupportedModulationFormat,
        FrequencyMeasurementUnit
    )
except ImportError:
    # Fallback for local development
    import sys
    sys.path.append('/var/teraflow')
    from common.ITUStandards import (
        ITUStandards,
        SupportedModulationFormat,
        FrequencyMeasurementUnit
    )
# [CHAFI-THESIS-END]


# [CHAFI-THESIS-START] - Default RSA Parameters
DEFAULT_MODULATION = "QAM_16"  # Default modulation format (16-QAM)
DEFAULT_ROLL_OFF_FACTOR = 0.2  # Roll-off factor (alpha) for Nyquist bandwidth
# [CHAFI-THESIS-END]


def get_required_bandwidth(bitrate: float,
                           modulation: str = DEFAULT_MODULATION,
                           roll_off_factor: float = DEFAULT_ROLL_OFF_FACTOR) -> dict:
    """
    [CHAFI-PARALLEL-OPTICAL] Calculate the required bandwidth and slots for a lightpath.

    Formula: B_n = (R_b / log2(M)) * (1 + alpha)

    Args:
        bitrate: Bit rate R_b (assumed in Gbps for now)
        modulation: Modulation format name (default: "QAM_16")
        roll_off_factor: Roll-off factor alpha (default: 0.2)

    Returns:
        dict containing:
            - bitrate: Input bitrate
            - modulation: Modulation format used
            - symbols_m: Number of symbols M
            - bits_per_symbol: log2(M)
            - roll_off_factor: Alpha value used
            - nyquist_bandwidth: B_n in same unit as bitrate (GHz if Gbps)
            - slot_granularity_ghz: ITU slot granularity in GHz
            - required_slots: Number of flex-grid slots needed
            - required_slots_ceil: Ceiling of required slots (integer)
    """
    # LOGGER.info("[CHAFI-RSA] ========== BANDWIDTH CALCULATION ==========")
    # LOGGER.info("[CHAFI-RSA] Input bitrate (R_b): {} Gbps".format(bitrate))
    # LOGGER.info("[CHAFI-RSA] Modulation format: {}".format(modulation))
    # LOGGER.info(
    #     "[CHAFI-RSA] Roll-off factor (alpha): {}".format(roll_off_factor))

    # [CHAFI-THESIS] Step 1: Get number of symbols M from modulation format
    symbols_m = SupportedModulationFormat.get_symbols(modulation)
    # LOGGER.info("[CHAFI-RSA] Number of symbols (M): {}".format(symbols_m))

    # [CHAFI-THESIS] Step 2: Calculate bits per symbol = log2(M)
    bits_per_symbol = math.log2(symbols_m)
    # LOGGER.info(
    #     "[CHAFI-RSA] Bits per symbol (log2(M)): {}".format(bits_per_symbol))

    # [CHAFI-THESIS] Step 3: Calculate Nyquist bandwidth
    # Formula: B_n = (R_b / log2(M)) * (1 + alpha)
    nyquist_bandwidth = (bitrate / bits_per_symbol) * (1 + roll_off_factor)
    # LOGGER.info(
    #     "[CHAFI-RSA] Nyquist bandwidth (B_n): {:.4f} GHz".format(nyquist_bandwidth))

    # [CHAFI-THESIS] Step 4: Get slot granularity from ITU Standards
    # SLOT_GRANULARITY is in Hz, convert to GHz for calculation
    slot_granularity_hz = ITUStandards.SLOT_GRANULARITY.value  # 6.25 GHz in Hz
    slot_granularity_ghz = slot_granularity_hz / FrequencyMeasurementUnit.GHz.value
    # LOGGER.info(
    #     "[CHAFI-RSA] Slot granularity: {} GHz".format(slot_granularity_ghz))

    # [CHAFI-THESIS] Step 5: Calculate required slots
    # required_slots = B_n / slot_granularity
    required_slots = nyquist_bandwidth / slot_granularity_ghz
    required_slots_ceil = math.ceil(required_slots)
    # LOGGER.info(
    #     "[CHAFI-RSA] Required slots (exact): {:.4f}".format(required_slots))
    # LOGGER.info(
    #     "[CHAFI-RSA] Required slots (ceiling): {}".format(required_slots_ceil))
    # LOGGER.info("[CHAFI-RSA] =============================================")

    # [CHAFI-THESIS] Return all computed values
    return {
        "bitrate": bitrate,
        "modulation": modulation,
        "symbols_m": symbols_m,
        "bits_per_symbol": bits_per_symbol,
        "roll_off_factor": roll_off_factor,
        "nyquist_bandwidth": nyquist_bandwidth,
        "slot_granularity_ghz": slot_granularity_ghz,
        "required_slots": required_slots,
        "required_slots_ceil": required_slots_ceil
    }


# [CHAFI-THESIS-START] - Test function for standalone execution
if __name__ == "__main__":
    # Test with sample values
    print("\n" + "=" * 60)
    print("RSA Helper Module - Test Run")
    print("=" * 60 + "\n")

    # Test case 1: 100 Gbps with 16-QAM
    result1 = get_required_bandwidth(bitrate=100, modulation="QAM_16")
    print("\nTest 1 - 100 Gbps with 16-QAM:")
    print("  Required slots: {}".format(result1['required_slots_ceil']))

    # Test case 2: 400 Gbps with 16-QAM
    result2 = get_required_bandwidth(bitrate=400, modulation="QAM_16")
    print("\nTest 2 - 400 Gbps with 16-QAM:")
    print("  Required slots: {}".format(result2['required_slots_ceil']))

    # Test case 3: 800 Gbps with 16-QAM
    result3 = get_required_bandwidth(bitrate=800, modulation="QAM_16")
    print("\nTest 3 - 800 Gbps with 16-QAM:")
    print("  Required slots: {}".format(result3['required_slots_ceil']))

    # Test case 4: 100 Gbps with QPSK
    result4 = get_required_bandwidth(bitrate=100, modulation="QPSK")
    print("\nTest 4 - 100 Gbps with QPSK:")
    print("  Required slots: {}".format(result4['required_slots_ceil']))

    print("\n" + "=" * 60)
# [CHAFI-THESIS-END]
