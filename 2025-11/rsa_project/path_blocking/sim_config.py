# We will populate all 18 Transponder nodes here once confirmed
NSF_NODES = [
    "TPcalifornia", "TPillinois", "TPmissouri", "TPnewyork", "TPtexas",
    "TPindiana", "TPohio", "TPmassachusetts", "TParizona", "TPwashington",
    "TPgeorgia", "TPtennessee", "TPpennsylvania", "TPmichigan",
    "TPcolorado", "TPflorida", "TPmaryland", "TPvirginia"
]
PANEU_NODES = []
BIT_RATE = [100]
# 18 nodes * 3 ports = 27 theoretical max connections
# Testing 10 to 50 Erlangs as requested
ERLANGS = [1, 2, 4]

N_REQ = 10000      # Re-adjusted for statistical significance
HOLDING_TIME = 30.0  # To be discussed
TRANSIENT_UNIT = 5.0  # Warm-up factor (e.g., 10 * HOLDING_TIME)
Z_VALUE = 1.96
