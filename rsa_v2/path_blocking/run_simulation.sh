#!/bin/bash

# This script runs the RSA simulation with configurable parameters using environment variables.
# Usage: ./run_simulation.sh [PATH_STRATEGY] [SPECTRUM_STRATEGY] [PATH_TYPE] [LINK_STUDY] [LOG_NAME]

# Default values if not provided
P_STRAT=${1:-"first-fit"} # Path Strategy: 'first-fit', 'last-fit', 'random'
S_STRAT=${2:-"first-fit"} # Spectrum Strategy: 'first-fit', 'last-fit', 'random'
P_TYPE=${3:-"dijkstra"} # Path Type: 'dijkstra', 'additional', 'both'
L_STUDY=${4:-"True"} # Link Study: True, Flase
LOG_NAME=${5:-"NSF_$(date +%Y%m%d_%H%M%S)"}

# Ensure results directory exists
mkdir -p results

echo "------------------------------------------------------------"
echo "🚀 Initializing Simulation Scenario"
echo "------------------------------------------------------------"
echo "🔹 Path Strategy:     $P_STRAT"
echo "🔹 Spectrum Strategy: $S_STRAT"
echo "🔹 Path Type:         $P_TYPE"
echo "🔹 Link Study:        $L_STUDY"
echo "🔹 Output Log:        results/$LOG_NAME.txt"
echo "------------------------------------------------------------"

# Export variables for Python to pick up via os.environ
export PATH_STRATEGY=$P_STRAT
export SPECTRUM_STRATEGY=$S_STRAT
export PATH_TYPE=$P_TYPE
export LINK_STUDY=$L_STUDY

# Run simulation in background
nohup python3 -u -W ignore simulator.py > "results/$LOG_NAME.txt" 2>&1 &

PID=$!
echo "✅ Simulation started in background (PID: $PID)"
echo "📈 Use 'tail -f results/$LOG_NAME.txt' to monitor progress."
echo "------------------------------------------------------------"
