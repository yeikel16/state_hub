# StateHub 🏠

[![style: very good analysis][very_good_analysis_badge]][very_good_analysis_link]
[![License: MIT][license_badge]][license_link]

A modern property search application built with Flutter, featuring a responsive design optimized for mobile, web, and desktop platforms.

🌐 **Live Demo**: [https://state-hub-smoky.vercel.app/home](https://state-hub-smoky.vercel.app/home)

---

## Features ✨

- 🔍 **Property Search & Filtering**: Search properties by name and filter by city
- ⭐ **Favorites Management**: Save and manage your favorite properties with persistent in memory storage
- 🏡 **Property Details**: View detailed information about each property
- 🎨 **Theming**: Multiple color schemes with light, dark, and system theme modes
- 🌍 **Internationalization**: Full support for English and Spanish
- 📱 **Responsive Design**: Optimized layouts for mobile, tablet, and desktop
- ♾️ **Infinite Scroll**: Smooth pagination for browsing properties
- 🚀 **Cross-Platform**: Runs on iOS, Android, Web, Windows, macOS, and Linux

---

## Tech Stack 🛠️

- **Framework**: Flutter
- **State Management**: BLoC (flutter_bloc, hydrated_bloc)
- **Routing**: GoRouter
- **Dependency Injection**: GetIt + Injectable
- **Networking**: Dio
- **Local Storage**: Hive
- **UI Components**:
  - FlexColorScheme (Theming)
  - CachedNetworkImage (Image caching)
  - InfiniteScrollPagination (Pagination)
  - ResponsiveBuilder (Responsive layouts)

---

## Getting Started 🚀

### Prerequisites

- Flutter SDK (latest stable version)
- Dart SDK

### Installation

1. Clone the repository
2. Install dependencies:
   ```sh
   flutter pub get
   ```

3. Generate code:
   ```sh
   dart run build_runner build --delete-conflicting-outputs
   ```

4. Run the app:
   ```sh
   flutter run
   ```

_StateHub works on iOS, Android, Web, and Desktop (Windows, macOS, Linux)._

---

## Supported Languages 🌐

- 🇺🇸 English (default)
- 🇪🇸 Spanish

### Adding a New Language

1. Add a new `.arb` file in `lib/l10n/arb/` (e.g., `app_fr.arb` for French)
2. Copy the content from `app_en.arb` and translate the values
3. Run the generator:
   ```sh
   flutter gen-l10n --arb-dir="lib/l10n/arb"
   ```

---

## Running Tests 🧪

```sh
flutter test
```

---

## Project Structure 📁

```
lib/
├── app/                    # App-level configuration
│   ├── language/          # Language Cubit
│   ├── routes/            # GoRouter configuration
│   ├── theme/             # Theme Cubit & FlexColorScheme
│   └── view/              # Main App widget
├── l10n/                  # Internationalization files
├── src/
│   ├── data/              # Models & Repositories
│   ├── dependencies.dart  # Dependency injection setup
│   ├── features/          # Feature modules
│   │   ├── favorites/     # Favorites feature
│   │   ├── home/          # Home feature
│   │   ├── properties/    # Properties feature (BLoC, widgets)
│   │   ├── property_details/  # Property details feature
│   │   └── settings/      # Settings feature
│   └── widgets/           # Shared widgets
└── bootstrap.dart         # App initialization
```

---

[license_badge]: https://img.shields.io/badge/license-MIT-blue.svg
[license_link]: https://opensource.org/licenses/MIT
[very_good_analysis_badge]: https://img.shields.io/badge/style-very_good_analysis-B22C89.svg
[very_good_analysis_link]: https://pub.dev/packages/very_good_analysis
