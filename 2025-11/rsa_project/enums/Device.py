from enum import Enum


class Constants(Enum):
    DEVICE_TYPE = "DEVICE_TYPE"
    AVAILABLE = "AVAILABLE"
    UNAVAILABLE = "UNAVAILABLE"
    IN_USE = "IN_USE"


class DeviceType(Enum):
    OPTICAL_TRANSPONDER = "optical-transponder"
    OPTICAL_ROADM = "optical-roadm"
