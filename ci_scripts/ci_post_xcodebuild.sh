#!/bin/sh
set -euo pipefail

echo "[CI] Post-xcodebuild hook running"
# Place any post-processing here. Examples:
#   - Verify artifacts
#   - Print tool versions for debugging
pod --version || true
node -v || true
npm -v || true
echo "[CI] Post-xcodebuild complete"
