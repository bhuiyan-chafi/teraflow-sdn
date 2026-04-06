# We will populate all 14 Transponder nodes here once confirmed
NSF_NODES = ["TPcalifornia", "TPcolorado", "TPflorida", "TPgeorgia", "TPillinois", "TPmaryland", "TPmichigan",
             "TPmissouri", "TPnewyork", "TPpennsylvania", "TPtennessee", "TPtexas", "TPvirginia", "TPwashington"]
PANEU_NODES = []
BIT_RATE = [100]
# 14 nodes * 14 ports = 196/2=98 [max topological lightpath]
ERLANGS = [30, 35, 40, 45, 50, 60, 80, 100, 200, 300]

N_REQ = 5000  # Re-adjusted for statistical significance
HOLDING_TIME = 60.0  # To be discussed
TRANSIENT_UNIT = 10.0  # Warm-up factor (e.g., 10 * HOLDING_TIME)
Z_VALUE = 1.96
