#!/usr/bin/env bash
set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$PROJECT_DIR"

BACKUP_FILE="${1:-}"

if [[ -z "$BACKUP_FILE" ]]; then
  echo "Usage: bash scripts/restore.sh <backup-file>"
  exit 1
fi

if [[ ! -f "$BACKUP_FILE" ]]; then
  echo "Error: Backup file not found: $BACKUP_FILE"
  exit 1
fi

echo "Checking PostgreSQL connection..."
docker compose exec -T postgres pg_isready -U appuser -d hotel_booking

echo "Recreating the restore test database..."
docker compose exec -T postgres psql -U appuser -d postgres 
  -c "SELECT pg_terminate_backend(pid) FROM pg_stat_activity WHERE datname = 'hotel_booking_restore' AND pid <> pg_backend_pid();"

docker compose exec -T postgres psql -U appuser -d postgres 
  -c "DROP DATABASE IF EXISTS hotel_booking_restore;"

docker compose exec -T postgres psql -U appuser -d postgres 
  -c "CREATE DATABASE hotel_booking_restore OWNER appuser;"

echo "Restoring backup into hotel_booking_restore..."
docker compose exec -T postgres pg_restore 
  -U appuser -d hotel_booking_restore 
  --no-owner --no-privileges < "$BACKUP_FILE"

echo "Verifying restored tables..."
docker compose exec -T postgres psql -U appuser -d hotel_booking_restore 
  -c "SELECT 'hotel_bookings' AS table_name, COUNT(*) AS row_count FROM hotel_bookings UNION ALL SELECT 'booking_events', COUNT(*) FROM booking_events;"

echo "Restore test completed successfully."