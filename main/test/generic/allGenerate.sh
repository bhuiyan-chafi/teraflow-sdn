#!/bin/bash

echo "========================================="
echo " Step 1: Removing existing containers..."
echo "========================================="
bash allRemove.sh

echo ""
echo "========================================="
echo " Step 2: Creating all TPs (1-6)..."
echo "========================================="
bash allTPs.sh

echo ""
echo "========================================="
echo " Step 3: Creating all RDMs (1-10)..."
echo "========================================="
bash allRDMs.sh

# Fix connectivity with Mascara (must run AFTER all containers are up,
# because Docker re-adds raw DROP rules on every new container start)
echo ""
echo "========================================="
echo " Step 4: Fixing connectivity with Mascara"
echo "========================================="
bash "$(dirname "$0")/../../fixConnectivity.sh"

echo ""
echo "========================================="
echo " All 16 devices are up and ready."
echo "========================================="
