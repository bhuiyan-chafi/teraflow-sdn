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
ITU-T Standards for Optical Networks.

This module contains ITU-T G.694.1 standards for optical spectrum allocation,
including frequency bands, wavelength ranges, slot granularity, and slot counts.

[CHAFI-THESIS-START]
"""

from enum import Enum


class ITUStandards(Enum):
    """ITU-T G.694.1 core standards for flex-grid optical networks."""
    ANCHOR_FREQUENCY = 193100000000000  # 193.1 THz in Hz (ITU anchor)
    CHANNEL_WIDTH = 12500000000         # 12.5 GHz in Hz (fixed grid)
    SLOT_GRANULARITY = 6250000000       # 6.25 GHz in Hz (flex grid)


class Bands(Enum):
    """Optical band names according to ITU-T classifications."""
    O_BAND = "O"
    E_BAND = "E"
    S_BAND = "S"
    C_BAND = "C"
    L_BAND = "L"
    CL_BAND = "C, L"
    SCL_BAND = "S, C, L"
    WHOLE_BAND = "O, E, S, C, L"


class FrequencyMeasurementUnit(Enum):
    """Frequency unit conversion factors to Hz."""
    KHz = 1000
    MHz = 1000000
    GHz = 1000000000
    THz = 1000000000000


class Lambdas(Enum):
    """
    Wavelength ranges for each optical band in nanometers (nm).

    [CHAFI-THESIS] SIMPLIFIED FOR TESTING - Dummy contiguous ranges.
    Real values commented out for reference.
    """
    # Single bands (dummy contiguous values for testing)
    # Real: O_BAND = (1260, 1360), E_BAND = (1360, 1460), etc.
    O_BAND = (1550, 1552)      # Dummy: highest freq band
    E_BAND = (1552, 1554)
    S_BAND = (1554, 1556)
    C_BAND = (1556, 1558)
    L_BAND = (1558, 1560)      # Dummy: lowest freq band
    # Multi-band combinations
    CL_BAND = (1556, 1560)     # C + L
    SCL_BAND = (1554, 1560)    # S + C + L
    WHOLE_BAND = (1550, 1560)  # All bands


class FreqeuncyRanges(Enum):
    """
    Frequency ranges for each optical band in Hz.

    [CHAFI-THESIS] SIMPLIFIED FOR TESTING - 20 slots per band (125 GHz each).
    Each band = 20 slots × 6.25 GHz = 125 GHz = 125,000,000,000 Hz
    Contiguous bands starting at 193.0 THz for easy debugging.

    Real ITU-T G.694.1 values commented out for reference.
    """
    # Single bands (min_hz, max_hz) - 20 slots each = 125 GHz
    # Real: O_BAND = (220425000000000, 237925000000000)  # 2800 slots
    # Real: E_BAND = (205325000000000, 220425000000000)  # 2416 slots
    # Real: S_BAND = (195937500000000, 205325000000000)  # 1501 slots
    # Real: C_BAND = (191556250000000, 195937500000000)  # 701 slots
    # Real: L_BAND = (188450000000000, 191556250000000)  # 498 slots
    # 193.000 - 193.125 THz (20 slots)
    L_BAND = (193000000000000, 193125000000000)
    # 193.125 - 193.250 THz (20 slots)
    C_BAND = (193125000000000, 193250000000000)
    # 193.250 - 193.375 THz (20 slots)
    S_BAND = (193250000000000, 193375000000000)
    # 193.375 - 193.500 THz (20 slots)
    E_BAND = (193375000000000, 193500000000000)
    # 193.500 - 193.625 THz (20 slots)
    O_BAND = (193500000000000, 193625000000000)
    # Multi-band combinations
    CL_BAND = (193000000000000, 193250000000000)   # L + C = 40 slots
    SCL_BAND = (193000000000000, 193375000000000)  # S + C + L = 60 slots
    WHOLE_BAND = (193000000000000, 193625000000000)  # All = 100 slots


class Slots(Enum):
    """
    Number of 6.25 GHz slots per optical band.

    [CHAFI-THESIS] SIMPLIFIED FOR TESTING - 20 slots per single band.
    Calculated as: (max_freq - min_freq) / SLOT_GRANULARITY

    Real values commented out for reference.
    """
    # Single bands - 20 slots each for testing
    # Real: O_BAND = 2800, E_BAND = 2416, S_BAND = 1501, C_BAND = 701, L_BAND = 498
    O_BAND = 20
    E_BAND = 20
    S_BAND = 20
    C_BAND = 20
    L_BAND = 20
    # Multi-band combinations
    # Real: CL_BAND = 1199, SCL_BAND = 2701, WHOLE_BAND = 7917
    CL_BAND = 40      # L + C
    SCL_BAND = 60     # S + C + L
    WHOLE_BAND = 100  # All 5 bands


class SlotStatus(Enum):
    """Slot availability status flags for spectrum allocation display."""
    AVAILABLE = "AVAILABLE"      # Free slot within device capability
    UNAVAILABLE = "UNAVAILABLE"  # Outside device frequency capability
    IN_USE = "IN_USE"            # Allocated slot (bitmap bit = 0)


# [CHAFI-THESIS-START] - Supported Modulation Formats for RSA
class SupportedModulationFormat(Enum):
    """
    Supported modulation formats with their symbol counts (M).

    The value represents M (number of symbols in the constellation).
    To get bits per symbol, use: log2(M)

    Formula context: B_n = (R_b / log2(M)) * (1 + alpha)
    Where:
        - B_n = Nyquist bandwidth
        - R_b = Bit rate
        - M = Number of symbols (this enum value)
        - alpha = Roll-off factor
    """
    BPSK = 2        # 1 bit/symbol
    QPSK = 4        # 2 bits/symbol
    QAM_8 = 8       # 3 bits/symbol
    QAM_16 = 16     # 4 bits/symbol
    QAM_32 = 32     # 5 bits/symbol
    QAM_64 = 64     # 6 bits/symbol
    QAM_128 = 128   # 7 bits/symbol
    QAM_256 = 256   # 8 bits/symbol

    @classmethod
    def get_symbols(cls, modulation_name: str) -> int:
        """
        Get the number of symbols (M) for a given modulation format name.

        Args:
            modulation_name: Name of the modulation (e.g., "QAM_16", "QPSK")

        Returns:
            Number of symbols M, or 16 (QAM_16) as default if not found
        """
        try:
            return cls[modulation_name].value
        except KeyError:
            # Default to 16-QAM if modulation not found
            return cls.QAM_16.value

    @classmethod
    def get_bits_per_symbol(cls, modulation_name: str) -> float:
        """
        Get the bits per symbol (log2(M)) for a given modulation format.

        Args:
            modulation_name: Name of the modulation (e.g., "QAM_16", "QPSK")

        Returns:
            Bits per symbol = log2(M)
        """
        import math
        m = cls.get_symbols(modulation_name)
        return math.log2(m)
# [CHAFI-THESIS-END]


# [CHAFI-THESIS-END]
