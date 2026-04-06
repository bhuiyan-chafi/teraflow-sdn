#!/bin/bash
# Run the simulator in the background and redirect output to a text file

echo "Starting simulation in the background..."

# Generate a timestamp
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
OUTPUT_FILE="${TIMESTAMP}.txt"

# Run the python script using nohup to keep it running even if the terminal closes.
# Standard output and standard error are redirected to the timestamped text file
nohup python3 simulator.py > "$OUTPUT_FILE" 2>&1 &

PID=$!
echo "Simulation is running with Process ID (PID): $PID"
echo "Results and logs are being appended to: path_blocking/$OUTPUT_FILE"
echo "You can monitor the progress in real-time by running:"
echo "tail -f path_blocking/$OUTPUT_FILE"
