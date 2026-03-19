# HandstandTimer

## Project Structure

```text
lib/
├── main.dart
├── app/
│   ├── app.dart
│   ├── router.dart
│   └── theme.dart
├── core/
│   ├── constants/
│   │   └── app_constants.dart
│   └── models/
│       └── handstand_session.dart
├── features/
│   ├── timer/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │       └── screens/
│   │           └── timer_screen.dart
│   ├── stats/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │       └── screens/
│   │           └── stats_screen.dart
│   └── settings/
│       ├── data/
│       ├── domain/
│       └── presentation/
│           └── screens/
│               └── settings_screen.dart
└── shared/
    └── presentation/
        └── screens/
            └── shell_screen.dart
```

## Running the App

```bash
flutter pub get
flutter run
```
