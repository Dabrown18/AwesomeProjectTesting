#!/bin/sh
set -euo pipefail

# Always run from the repo root
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
cd "$REPO_ROOT"

echo "[CI] Pre-xcodebuild starting in $REPO_ROOT"

# 1) JavaScript dependencies
if [ -f "package-lock.json" ]; then
  echo "[CI] npm ci"
  npm ci
elif [ -f "yarn.lock" ]; then
  echo "[CI] yarn install"
  yarn install --frozen-lockfile || yarn install
else
  echo "[CI] No JS lockfile found, skipping JS install"
fi

# 2) iOS CocoaPods
if [ -d "ios" ]; then
  cd ios
  if [ -f "Gemfile" ]; then
    echo "[CI] Bundler + CocoaPods"
    gem install bundler --no-document || true
    bundle install
    bundle exec pod install --repo-update
  else
    echo "[CI] CocoaPods"
    pod install --repo-update
  fi
else
  echo "[CI] ERROR: ios directory not found"
  exit 1
fi

echo "[CI] Pre-xcodebuild complete ✅"
