#!/usr/bin/env bash
set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$PROJECT_DIR"

mkdir -p "$PROJECT_DIR/backups"

TIMESTAMP="$(date +%Y%m%d_%H%M%S)"
BACKUP_FILE="$PROJECT_DIR/backups/hotel_booking_${TIMESTAMP}.dump"

echo "Starting PostgreSQL backup..."

docker compose exec -T postgres pg_dump -U appuser -d hotel_booking -Fc > "$BACKUP_FILE"

echo "Backup completed successfully:"
echo "$BACKUP_FILE"