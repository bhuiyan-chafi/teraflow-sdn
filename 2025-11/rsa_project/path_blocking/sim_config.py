# Configuration for Confidence Interval based simulation
# Stopping criteria: CI <= 5% of blocking probability at 95% confidence level
# OR maximum 10^4 independent trials reached

# NODES = ["TPcalifornia", "TPcolorado", "TPflorida", "TPgeorgia", "TPillinois", "TPmaryland", "TPmichigan",
#              "TPmissouri", "TPnewyork", "TPpennsylvania", "TPtennessee", "TPtexas", "TPvirginia", "TPwashington"]
NODES = ["TPlondon", "TPparis", "TPfrankfurt", "TPamsterdam", "TPmadrid", "TProme", "TPberlin",
         "TPwarsaw", "TPstockholm", "TPathens", "TPvienna", "TPprague", "TPbrussels", "TPmilan",
         "TPzurich", "TPdublin", "TPglasgow", "TPcopenhagen", "TPhamburg", "TPmunich", "TPbudapest",
         "TPbelgrade", "TPbarcelona", "TPlyon", "TPbordeaux", "TPstrasbourg", "TPoslo"]
BIT_RATE = [100, 400, 800]
ERLANGS = [50, 100, 150, 200, 300, 400, 500]

# CI-based stopping parameters
MAX_TRIALS = 10000  # Maximum number of independent trials (10^4)
# Minimum trials before checking CI (for statistical validity)
MIN_TRIALS = 100
CI_THRESHOLD = 0.05  # 5% relative CI threshold
Z_VALUE = 1.96       # 95% confidence level

HOLDING_TIME = 60.0
TRANSIENT_UNIT = 5.0  # Warm-up factor (e.g., 10 * HOLDING_TIME)
