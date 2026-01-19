#!/bin/bash
set -e

# Wait for DB to be ready
until pg_isready -h db -U rsa_user -d rsa_db; do
  echo "Waiting for database to be ready..."
  sleep 2
done

echo "Database is ready. Executing SQL files in order..."

# Execute SQL files
psql -h db -U rsa_user -d rsa_db -f /sql/devices.sql
psql -h db -U rsa_user -d rsa_db -f /sql/device_endpoints.sql
psql -h db -U rsa_user -d rsa_db -f /sql/optical_links.sql

echo "SQL files executed successfully!"
