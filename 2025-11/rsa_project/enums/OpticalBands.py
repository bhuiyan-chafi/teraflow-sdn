#   Bands.py
#   Author: Chafiullah Bhuiyan
#   Date: 2026-01-08
#   Description: We are delcaring all the optical bands here except the U band. But this modularity ensures that we can add any band in the future.

from enum import Enum


class Bands(Enum):
    O_BAND = "O"
    E_BAND = "E"
    S_BAND = "S"
    C_BAND = "C"
    L_BAND = "L"
    CL_BAND = "C, L"
    SCL_BAND = "S, C, L"
    WHOLE_BAND = "O, E, S, C, L"


class FrequencyMeasurementUnit(Enum):
    KHz = 1000
    MHz = 1000000
    GHz = 1000000000
    THz = 1000000000000


class Lambdas(Enum):
    # frequencies in nm
    O_BAND = (1260, 1360)
    E_BAND = (1360, 1460)
    S_BAND = (1460, 1530)
    C_BAND = (1530, 1565)
    L_BAND = (1565, 1625)
    # if supports multiple band
    CL_BAND = (1530, 1625)
    SCL_BAND = (1460, 1625)
    WHOLE_BAND = (1260, 1625)


class FreqeuncyRanges(Enum):
    # frequencies in Hz
    # ranges after 6.25 GHz quantization
    O_BAND = (237925000000000, 220425000000000)
    E_BAND = (220425000000000, 205325000000000)
    S_BAND = (205325000000000, 195937500000000)
    C_BAND = (195937500000000, 191556250000000)
    L_BAND = (191556250000000, 188450000000000)
    # if supports multiple band
    CL_BAND = (195937500000000, 188450000000000)
    SCL_BAND = (205325000000000, 188450000000000)
    WHOLE_BAND = (237925000000000, 188450000000000)


class Slots(Enum):
    # with slot granularity of 6.25 GHz = 0.00625 THz
    # no edge scaling (it's better to remove first and last slot as sharp edges)
    O_BAND = 2800
    E_BAND = 2416
    S_BAND = 1501
    C_BAND = 701
    L_BAND = 498
    # if supports multiple band
    CL_BAND = 1199
    SCL_BAND = 2701
    WHOLE_BAND = 7917
