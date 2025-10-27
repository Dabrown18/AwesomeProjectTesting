#!/bin/sh
set -euo pipefail

echo "Xcode Cloud: post-clone setup"

# 1) install JS deps
if [ -f "package-lock.json" ]; then
  echo "Installing JS deps with npm ci"
  npm ci
elif [ -f "yarn.lock" ]; then
  echo "Installing JS deps with yarn"
  yarn install --frozen-lockfile || yarn install
else
  echo "No lockfile found, skipping JS install"
fi

# 2) install iOS pods
cd ios

# If you use a Gemfile with a specific Cocoapods version, prefer bundler
if [ -f "Gemfile" ]; then
  echo "Installing Ruby gems via bundler"
  gem install bundler --no-document || true
  bundle install
  echo "Running pod install via bundler"
  bundle exec pod install --repo-update
else
  echo "Running pod install"
  pod install --repo-update
fi

echo "Post-clone complete"
