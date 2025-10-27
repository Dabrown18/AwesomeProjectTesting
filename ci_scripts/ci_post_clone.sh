mkdir -p ci_scripts
cat > ci_scripts/ci_post_clone.sh <<'SH'
#!/bin/sh
set -euo pipefail

echo "Xcode Cloud, post clone starting"

# Install JS deps
if [ -f "package-lock.json" ]; then
  echo "npm ci"
  npm ci
elif [ -f "yarn.lock" ]; then
  echo "yarn install"
  yarn install --frozen-lockfile || yarn install
fi

# Install iOS Pods
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

echo "post clone complete"
SH

# Make sure the file uses LF endings and is executable
dos2unix ci_scripts/ci_post_clone.sh 2>/dev/null || true
git add ci_scripts/ci_post_clone.sh
git update-index --chmod=+x ci_scripts/ci_post_clone.sh
git commit -m "Xcode Cloud, add post clone script for JS deps and CocoaPods"
git push
