from enum import Enum


class ITUStandards(Enum):
    ANCHOR_FREQUENCY = 193100000000000  # in Hz
    SLOT_GRANULARITY = 6250000000  # in Hz
    SLOT_WIDTH = 12500000000  # in Hz
