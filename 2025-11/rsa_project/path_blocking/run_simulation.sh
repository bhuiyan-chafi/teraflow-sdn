#!/bin/bash
# Run the simulator in the background and redirect output to a text file

echo "Starting simulation in the background..."

# Generate a timestamp and ensure results directory exists
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
OUTPUT_DIR="results"
mkdir -p "$OUTPUT_DIR"
OUTPUT_FILE="${OUTPUT_DIR}/${TIMESTAMP}.txt"

# Run the python script using nohup to keep it running even if the terminal closes.
# We use 'python3 -W ignore' to suppress the LibreSSL/urllib3 warnings specific to macOS.
# Standard output and standard error are redirected to the timestamped text file
nohup python3 -u -W ignore simulator.py > "$OUTPUT_FILE" 2>&1 &

PID=$!
echo "Simulation is running with Process ID (PID): $PID"
echo "Results and logs are being appended to: path_blocking/$OUTPUT_FILE"
echo "You can monitor the progress in real-time by running:"
echo "tail -f path_blocking/$OUTPUT_FILE"
