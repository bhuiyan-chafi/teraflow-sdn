# Configuration for Confidence Interval based simulation
# Stopping criteria: CI <= 10% of blocking probability at 95% confidence level

# NODES = ["TPcalifornia", "TPcolorado", "TPflorida", "TPgeorgia", "TPillinois", "TPmaryland", "TPmichigan",
#              "TPmissouri", "TPnewyork", "TPpennsylvania", "TPtennessee", "TPtexas", "TPvirginia", "TPwashington"]
NODES = ["TPlondon", "TPparis", "TPfrankfurt", "TPamsterdam", "TPmadrid", "TProme", "TPberlin",
         "TPwarsaw", "TPstockholm", "TPathens", "TPvienna", "TPprague", "TPbrussels", "TPmilan",
         "TPzurich", "TPdublin", "TPglasgow", "TPcopenhagen", "TPhamburg", "TPmunich", "TPbudapest",
         "TPbelgrade", "TPbarcelona", "TPlyon", "TPbordeaux", "TPstrasbourg", "TPoslo"]
BIT_RATE = [400]
ERLANGS = [80]

# CI-based stopping parameters
MAX_REQUESTS = 1000000  # Maximum number of independent trials (10^4)
# Minimum trials before checking CI (for statistical validity)
MIN_REQUESTS = 1000
CI_THRESHOLD = 0.10  # 5% relative CI threshold
Z_VALUE = 1.96       # 95% confidence level

HOLDING_TIME = 60.0
TRANSIENT_UNIT = 10.0  # Warm-up factor (e.g., 10 * HOLDING_TIME)
