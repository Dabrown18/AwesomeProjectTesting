#!/bin/sh
set -euo pipefail

# always start at repo root
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
cd "$REPO_ROOT"

echo "Xcode Cloud, post clone starting in $REPO_ROOT"

# Install JS deps at repo root
if [ -f "package-lock.json" ]; then
  echo "npm ci"
  npm ci
elif [ -f "yarn.lock" ]; then
  echo "yarn install"
  yarn install --frozen-lockfile || yarn install
else
  echo "No lockfile found, skipping JS install"
fi

# Install iOS Pods
if [ -d "ios" ]; then
  cd ios
  if [ -f "Gemfile" ]; then
    echo "bundle exec pod install"
    gem install bundler --no-document || true
    bundle install
    bundle exec pod install --repo-update
  else
    echo "pod install"
    pod install --repo-update
  fi
else
  echo "Expected ios directory at $REPO_ROOT/ios, not found"
  exit 1
fi

echo "post clone complete"
