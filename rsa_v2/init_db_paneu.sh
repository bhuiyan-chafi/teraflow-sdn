#!/bin/bash
set -e

# Wait for DB to be ready
until pg_isready -h db -U rsa_user -d rsa_db; do
  echo "Waiting for database to be ready..."
  sleep 2
done

echo "Database is ready. Executing SQL files in order..."

# Execute SQL files for normal topo
psql -h db -U rsa_user -d rsa_db -f /sql/paneu_topo/devices.sql
psql -h db -U rsa_user -d rsa_db -f /sql/paneu_topo/device_endpoints.sql
psql -h db -U rsa_user -d rsa_db -f /sql/paneu_topo/optical_links.sql
psql -h db -U rsa_user -d rsa_db -f /sql/paneu_topo/optical_links_parallel.sql
echo "SQL files executed successfully!"
