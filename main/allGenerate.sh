#!/bin/bash

# ============================================================
# allGenerate.sh — Full setup: remove existing, then create
#                  all 20 TPs and 40 RDMs.
# The terminal will block until everything is complete.
# ============================================================

# Step 1: Remove all existing containers
echo "========================================="
echo " Step 1: Removing existing containers..."
echo "========================================="
bash "$(dirname "$0")/allRemove.sh"

# Step 2: Start all TPs
echo ""
echo "========================================="
echo " Step 2: Creating all TPs (TP1–TP20)..."
echo "========================================="
bash "$(dirname "$0")/allTPs.sh"

# Step 3: Start all RDMs
echo ""
echo "========================================="
echo " Step 3: Creating all RDMs (RDM1–RDM40)..."
echo "========================================="
bash "$(dirname "$0")/allRDMs.sh"

# Step 4: Fix connectivity with Mascara (must run AFTER all containers are up,
#         because Docker re-adds raw DROP rules on every new container start)
echo ""
echo "========================================="
echo " Step 4: Fixing connectivity with Mascara"
echo "========================================="
bash "$(dirname "$0")/../fixConnectivity.sh"

echo ""
echo "========================================="
echo " All 60 devices are up and ready."
echo "========================================="
