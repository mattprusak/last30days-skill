#!/usr/bin/env bash
# Run last30days and output to Prusak Vault/Research/Last30Days/<date>_<topic>/
set -euo pipefail

if [ $# -lt 1 ]; then
  echo "Usage: run-to-vault.sh <topic> [extra args...]"
  exit 1
fi

TOPIC="$1"
shift

# Slugify topic: lowercase, spaces to hyphens, strip non-alphanum
SLUG=$(echo "$TOPIC" | tr '[:upper:]' '[:lower:]' | tr ' ' '-' | sed 's/[^a-z0-9-]//g' | sed 's/--*/-/g')
DATE=$(date +%Y-%m-%d)
VAULT_DIR="$HOME/Vaults/Prusak Vault/Research/Last30Days/${DATE}_${SLUG}"

mkdir -p "$VAULT_DIR"

# Load credentials
source ~/.openclaw/credentials/xai.env 2>/dev/null || true
export SCRAPECREATORS_API_KEY="${SCRAPECREATORS_API_KEY:-$(grep SCRAPECREATORS_API_KEY ~/.config/last30days/.env 2>/dev/null | cut -d= -f2)}"
export XAI_API_KEY
export SETUP_COMPLETE=true
export LAST30DAYS_OUTPUT_DIR="$VAULT_DIR"

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
python3 "$SCRIPT_DIR/last30days.py" "$TOPIC" "$@"

echo ""
echo "Output: $VAULT_DIR"
