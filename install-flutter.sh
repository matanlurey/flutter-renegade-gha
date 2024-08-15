#!/usr/bin/env sh

set -e

# Cloning a forked repo fails with obscure errors without pretending to be
# a known version of Flutter. https://github.com/flutter/flutter/issues/148569.
FAKE_FLUTTER_VERISON="3.24.0"

# Remove any existing Flutter SDK.
rm -rf flutter

# Clone the Flutter SDK.
git clone --depth 1 --branch \
  try-crash-driver-ci \
  https://github.com/matanlurey/flutter

# If we are running on Github actions, we have extra steps.
if [ -n "$GITHUB_ACTIONS" ]; then
  # Install the Flutter SDK.
  flutter config --clear-features --no-analytics --no-cli-animations
else
  # Set an alias for local users.
  alias dart=./flutter/bin/dart
  alias flutter=./flutter/bin/flutter
  flutter config --clear-features
fi

# Print the version of Flutter.
flutter --version

# Edit the version file to pretend to be a known version of Flutter.
# ./flutter/bin/cache/flutter.version.json
# change flutterVersion": "0.0.0-unknown"
#     to flutterVersion": "$FAKE_FLUTTER_VERISON"
sed -i "s/0.0.0-unknown/${FAKE_FLUTTER_VERISON}/g" ./flutter/bin/cache/flutter.version.json

# Download dependencies.
flutter update-packages
