# CPR

Wear OS app for help during the cardiopulmonary resurrection

## Pre-requisites
1. [Android Studio](https://developer.android.com/studio) or [Visual Studio Code](https://code.visualstudio.com/)
2. Wear OS device or emulator
3. [Flutter framework](https://flutter.dev/docs/get-started/install)

Everything should be configured, and you must be able to run an app on your Wear OS device or emulator. If you have any problems, please refer to the official documentation.

Windows platform is highly suggested as Linux could cause problems if your hard disk is encrypted, other than it works better in terms of graphical performance.

## Getting Started

1. Clone the repository
```
git clone https://github.com/Tommaso-Sgroi/CPR-companion.git
```

2. Open the project in Android Studio or VSCode

3. Run the project on your Wear OS device or emulator

## Test

1. Local browser
```
flutter run -d chrome
```

2. Build an APK to install on your Wear OS device / Android device
```
flutter build apk --release
```

## License
This code is released under Affero GPL v3.0 license. You can find the full license text [here](https://www.gnu.org/licenses/agpl-3.0.html).