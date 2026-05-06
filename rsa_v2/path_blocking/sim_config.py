import os
# Configuration for Confidence Interval based simulation
# Stopping criteria: CI <= 5% or 10% of blocking probability at 95% confidence level

# NSF 14-node topology (legacy):
# NODES = ["RDMwa", "RDMca1", "RDMca2", "RDMut", "RDMco", "RDMne", "RDMtx",
#          "RDMil", "RDMmi", "RDMpa", "RDMny", "RDMnj", "RDMma", "RDMga"]

# Pan-EU 27-node topology:
NODES = [
    "RDMdublin", "RDMglasgow", "RDMlondon", "RDMoslo", "RDMstockholm",
    "RDMcopenhagen", "RDMhamburg", "RDMamsterdam", "RDMbrussels", "RDMparis",
    "RDMbordeaux", "RDMlyon", "RDMstrasbourg", "RDMfrankfurt", "RDMberlin",
    "RDMwarsaw", "RDMprague", "RDMmunich", "RDMzurich", "RDMvienna",
    "RDMbudapest", "RDMmilan", "RDMrome", "RDMbarcelona",
    "RDMmadrid", "RDMathens", "RDMbelgrade",
]
BIT_RATES = [100, 200, 400]
BIT_RATE_PROBS = [0.5, 0.25, 0.25]
ERLANGS = [250, 350, 450, 550, 650, 750, 850, 950, 1050, 1150]

# CI-based stopping parameters
MAX_REQUESTS = 2000000  # Maximum number of independent trials (10^4)
# Minimum trials before checking CI (for statistical validity)
MIN_REQUESTS = 1000
CI_THRESHOLD = 0.1  # 10% relative CI threshold
Z_VALUE = 1.96       # 95% confidence level

HOLDING_TIME = 60.0
TRANSIENT_UNIT = 10.0  # Warm-up factor (e.g., 10 * HOLDING_TIME)

# Path selection options: 'dijkstra', 'additional', 'both'
# Path selection strategy: 'first-fit', 'last-fit', 'random', 'highest-slot'
# SPECTRUM_STRATEGY : 'first-fit', 'last-fit', 'random'
PATH_STRATEGY = os.environ.get('PATH_STRATEGY', 'first-fit')
SPECTRUM_STRATEGY = os.environ.get('SPECTRUM_STRATEGY', 'first-fit')
PATH_TYPE = os.environ.get('PATH_TYPE', 'dijkstra')
PARALLELPATH_STRATEGY = os.environ.get('PARALLELPATH_STRATEGY', 'none')
LINK_STUDY = os.environ.get('LINK_STUDY', 'True').lower() == 'true'
