# HabitLoop

A free, open-source, local-first habit tracker built with Flutter for Android.

Track your daily habits, build streaks, and see your progress over time — all data stays on your device.

## Features

- **Daily habit tracking** — tap to complete, long-press to edit, swipe to delete
- **Streak tracking** — current streak + all-time best streak per habit
- **History view** — contribution grid showing your completion pattern
- **Statistics** — overview of today's progress and overall stats
- **Reminders** — per-habit notification reminders at your chosen time
- **8 color themes** — Forest, Terracotta, Ocean, Plum (light & dark variants)
- **Dark mode** — Auto / Light / Dark toggle, follows system setting
- **Export & Import** — back up your data via clipboard
- **Remove Ads** — optional one-time purchase
- **Privacy first** — all data stored locally, no accounts, no servers

## Screenshots

> Screenshots coming soon.

## Getting Started

### Prerequisites

- [Flutter SDK](https://flutter.dev/docs/get-started/install)
- Android Studio (for Android SDK and emulator)
- Git

### Setup

```bash
# Clone the repository
git clone https://github.com/ShahabAhmed01/HabitLoop.git
cd HabitLoop

# Get dependencies
flutter pub get

# Run on emulator or device
flutter run
```

### Running Tests

```bash
flutter test
```

## Architecture

```
lib/
├── main.dart                    # App entry, theme provider, bottom nav
├── screens/
│   ├── home_screen.dart         # Habit list, tap-to-complete, streaks
│   ├── add_edit_habit_screen.dart  # Create/edit habits with icon, color, frequency
│   ├── history_screen.dart      # Per-habit completion grid + streak cards
│   ├── stats_screen.dart        # Overall statistics
│   ├── settings_screen.dart     # Theme, dark mode, export/import, ads
│   └── theme_picker_screen.dart # Color theme selection
├── models/
│   ├── habit.dart               # Habit data model
│   └── completion.dart          # Completion data model
├── database/
│   └── database_helper.dart     # SQLite database layer (sqflite)
├── services/
│   ├── ad_service.dart          # Google AdMob integration
│   ├── purchase_service.dart    # In-app purchase (remove ads)
│   └── notification_service.dart # Local notifications
└── utils/
    ├── streak_utils.dart        # Streak calculation logic
    └── app_themes.dart          # Theme definitions (4 light + 4 dark)
```

## Tech Stack

- **Flutter** 3.44.6
- **sqflite** — local SQLite database
- **flutter_local_notifications** — per-habit reminders
- **google_mobile_ads** — ad integration (test IDs for development)
- **in_app_purchase** — one-time remove-ads purchase
- **shared_preferences** — theme and settings persistence

## License

MIT License — see [LICENSE](LICENSE) for details.

## Privacy

HabitLoop is a local-first app. Your habit data never leaves your device. See the [Privacy Policy](docs/privacy-policy.md) for full details.

> The official Play Store build includes ads via Google AdMob. The ad SDK collects anonymous device identifiers for ad targeting. You can opt out via the in-app Privacy Options.
