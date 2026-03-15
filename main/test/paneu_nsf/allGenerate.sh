#!/bin/bash

echo "========================================="
echo " Step 1: Removing existing containers..."
echo "========================================="
bash allRemove.sh

echo ""
echo "========================================="
echo " Step 2: Creating all TPs (1-15)..."
echo "========================================="
bash allTPs.sh

echo ""
echo "========================================="
echo " Step 3: Creating all RDMs (1-45)..."
echo "========================================="
bash allRDMs.sh

echo ""
echo "========================================="
echo " Step 4: Fixing connectivity with Mascara"
echo "========================================="
bash ../fixConnectivity.sh

echo ""
echo "========================================="
echo " All 60 devices are up and ready."
echo "========================================="
