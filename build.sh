#!/bin/bash
echo "Installing Flutter SDK..."
git clone https://github.com/flutter/flutter.git -b stable
export PATH="$PATH:`pwd`/flutter/bin"

echo "Enabling Web..."
flutter config --enable-web

echo "Getting Dependencies..."
flutter pub get

echo "Building Web App..."
flutter build web --release
