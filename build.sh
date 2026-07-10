#!/bin/bash
echo "Installing Flutter SDK..."
if [ ! -d "flutter" ]; then
  git clone https://github.com/flutter/flutter.git -b stable
fi
export PATH="$PATH:`pwd`/flutter/bin"

echo "Enabling Web..."
flutter config --enable-web

echo "Getting Dependencies..."
flutter pub get

echo "Building Web App..."
flutter build web --release --no-tree-shake-icons
