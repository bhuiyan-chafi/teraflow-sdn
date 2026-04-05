# We will populate all 18 Transponder nodes here once confirmed
NSF_NODES = ["TPcalifornia", "TPillinois", "TPmissouri", "TPnewyork", "TPtexas", "TPindiana", "TPohio", "TPmassachusetts", "TParizona", "TPwashington", "TPgeorgia", "TPtennessee", "TPpennsylvania", "TPmichigan", "TPcolorado", "TPflorida", "TPmaryland", "TPvirginia"
             ]
PANEU_NODES = []
BIT_RATE = [100]
# 18 nodes * 3 ports =54/2=27 theoretical max connections
# Testing 10 to 50 Erlangs as requested
ERLANGS = [36]

N_REQ = 10000      # Re-adjusted for statistical significance
HOLDING_TIME = 60.0  # To be discussed
TRANSIENT_UNIT = 2.0  # Warm-up factor (e.g., 10 * HOLDING_TIME)
Z_VALUE = 1.96
