#!/bin/bash

# Skrypt budujący aplikację CyberBezpieczni

echo "🚀 Rozpoczynam proces budowania..."

# 1. Czyszczenie i pobieranie zależności
echo "📦 Pobieranie zależności..."
flutter clean
flutter pub get

# 2. Budowanie wersji Web (do szybkiego podglądu)
echo "🌐 Budowanie wersji Web..."
flutter build web --release

# 3. Budowanie APK (Android)
echo "🤖 Budowanie APK (Android)..."
flutter build apk --release

# 4. Budowanie App Bundle (Android - dla Google Play)
echo "📦 Budowanie App Bundle (Android)..."
flutter build appbundle --release

# 5. Budowanie iOS (wymaga macOS i zainstalowanego Xcode)
if [[ "$OSTYPE" == "darwin"* ]]; then
    echo "🍎 Wykryto macOS. Budowanie dla iOS..."
    flutter build ios --release --no-codesign
else
    echo "⚠️  Pomiinięto budowanie iOS (wymagany macOS)."
fi

echo "✅ Proces zakończony! Pliki wynikowe znajdziesz w folderze build/."
