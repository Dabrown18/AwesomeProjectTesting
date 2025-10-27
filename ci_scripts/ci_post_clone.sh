#!/bin/sh
set -euo pipefail

# Keep this lightweight. Most installs happen in pre-xcodebuild.
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
cd "$REPO_ROOT"

echo "[CI] Post-clone hook running in $REPO_ROOT"
# You can place cache priming or quick checks here if you want.
echo "[CI] Post-clone complete"
