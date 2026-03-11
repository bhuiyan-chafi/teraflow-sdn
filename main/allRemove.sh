#!/bin/bash

# ============================================================
# allRemove.sh — Stop and remove all 20 TPs and 40 RDMs
# Blocks until all containers are fully stopped and removed.
# ============================================================

echo "Stopping and removing all TP containers (TP1–TP20)..."
for container in TP{1..20}; do
  echo "  Stopping $container..."
  sudo docker stop -t 1 "$container"
  sudo docker rm "$container"
done

echo "Stopping and removing all RDM containers (RDM1–RDM40)..."
for container in RDM{1..40}; do
  echo "  Stopping $container..."
  sudo docker stop -t 1 "$container"
  sudo docker rm "$container"
done

echo "Done. All containers removed."
