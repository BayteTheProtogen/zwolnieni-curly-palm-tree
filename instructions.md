# Instrukcja Obsługi i Budowania - CyberBezpieczni

Aplikacja edukacyjna w stylu Duolingo, ucząca seniorów cyberbezpieczeństwa.

## 🛠 Wymagania
- **Flutter SDK**: wersja 3.10.0 lub nowsza.
- **Dart SDK**: wersja 3.0.0 lub nowsza.
- **Java JDK**: wersja 11 lub nowsza (dla Androida).
- **Xcode**: (tylko dla iOS, wymagany macOS).

## 🚀 Szybki Start

1. **Pobierz zależności**:
   ```bash
   flutter pub get
   ```

2. **Uruchom w trybie debugowania**:
   ```bash
   flutter run
   ```

## 📦 Budowanie wersji produkcyjnej

Możesz użyć dołączonego skryptu pomocniczego:
```bash
chmod +x build.sh
./build.sh
```

Lub ręcznie:
- **Android APK**: `flutter build apk --release`
- **Android App Bundle**: `flutter build appbundle --release`
- **iOS**: `flutter build ios --release` (wymaga macOS i Xcode)

## 📁 Struktura Projektu
- `lib/models/`: Modele danych lekcji i zadań.
- `lib/providers/`: Zarządzanie stanem aplikacji (XP, Streaki, Tryb Seniora).
- `lib/screens/`: Główne ekrany (Mapa lekcji, Onboarding, Lekcja, Profil).
- `lib/widgets/`: Komponenty UI, w tym animowana maskotka.
- `lib/data/`: Treści edukacyjne i definicje modułów.

## ⚙️ Funkcje specjalne
- **Tryb Seniora**: Można go aktywować w ustawieniach (zwiększa czcionki o 40%).
- **Wysoki Kontrast**: Ułatwia czytanie osobom słabowidzącym.
- **Magic Move**: Aplikacja używa animacji Hero do płynnych przejść maskotki między ekranami.

## 🧪 Testy
Aby uruchomić testy jednostkowe i widgetów:
```bash
flutter test
```
