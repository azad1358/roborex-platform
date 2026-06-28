#!/usr/bin/env bash
# Off-site backup for roborex-platform.
#
# Dumps PostgreSQL logically and mirrors the MinIO object store plus the dumps
# to a remote S3-compatible bucket (e.g. Cloudflare R2) using rclone.
#
# Configure the rclone remotes once with `rclone config`:
#   - MINIO_REMOTE: type s3, provider Minio, endpoint http://127.0.0.1:9000
#   - RCLONE_REMOTE: type s3, provider Cloudflare (R2) or Backblaze (B2)
#
# Override any setting via the environment; PostgreSQL credentials are read
# from docker/.env.
set -Eeuo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
ENV_FILE="${ENV_FILE:-$REPO_ROOT/docker/.env}"

# --- Configuration (override via environment) --------------------------------
MINIO_REMOTE="${MINIO_REMOTE:-minio}"        # rclone remote for local MinIO
RCLONE_REMOTE="${RCLONE_REMOTE:-r2}"         # rclone remote for off-site bucket
RCLONE_BUCKET="${RCLONE_BUCKET:-roborex-data}"
BACKUP_DIR="${BACKUP_DIR:-/opt/roborex-data/backups}"
POSTGRES_CONTAINER="${POSTGRES_CONTAINER:-postgres}"
RETENTION_DAYS="${RETENTION_DAYS:-14}"
# -----------------------------------------------------------------------------

log() { printf '%s %s\n' "$(date '+%Y-%m-%dT%H:%M:%S%z')" "$*"; }

require() {
  command -v "$1" >/dev/null 2>&1 || { log "ERROR: '$1' is not installed"; exit 1; }
}

require rclone
require docker

if [[ -f "$ENV_FILE" ]]; then
  set -a
  # shellcheck disable=SC1090
  source "$ENV_FILE"
  set +a
else
  log "ERROR: env file not found at $ENV_FILE"
  exit 1
fi

: "${POSTGRES_USER:?POSTGRES_USER missing in $ENV_FILE}"
: "${POSTGRES_DB:?POSTGRES_DB missing in $ENV_FILE}"

mkdir -p "$BACKUP_DIR"

# --- 1. PostgreSQL logical dump ----------------------------------------------
stamp="$(date +%F-%H%M%S)"
dump_file="$BACKUP_DIR/db-$stamp.sql.gz"
log "Dumping PostgreSQL database '$POSTGRES_DB' -> $dump_file"
docker exec "$POSTGRES_CONTAINER" \
  pg_dump -U "$POSTGRES_USER" "$POSTGRES_DB" | gzip > "$dump_file"

log "Pruning dumps older than $RETENTION_DAYS days"
find "$BACKUP_DIR" -name 'db-*.sql.gz' -type f -mtime "+$RETENTION_DAYS" -delete

# --- 2. Mirror MinIO objects off-site ----------------------------------------
log "Mirroring MinIO objects -> $RCLONE_REMOTE:$RCLONE_BUCKET/minio"
rclone sync "$MINIO_REMOTE:" "$RCLONE_REMOTE:$RCLONE_BUCKET/minio" --fast-list

# --- 3. Mirror database dumps off-site ---------------------------------------
log "Mirroring dumps -> $RCLONE_REMOTE:$RCLONE_BUCKET/postgres"
rclone sync "$BACKUP_DIR" "$RCLONE_REMOTE:$RCLONE_BUCKET/postgres" --fast-list

log "Backup completed successfully"
