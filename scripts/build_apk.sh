#!/bin/bash
flutter pub get &&
flutter pub run build_runner build --delete-conflicting-outputs &&
flutter build apk --no-sound-null-safety --target-platform android-arm64