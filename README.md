# alai_oosai

Alai Oosai is a Flutter application with an OTP-based authentication flow and a post-login shell for home content, announcements, and reports.

## Stack

- Flutter
- Dart `^3.11.1`
- Material 3
- `http` for API calls

Supported platform folders are present for Android, iOS, macOS, Linux, Windows, and Web.

## Current App Flow

The app currently starts in the authentication flow.

- Entry point: `lib/main.dart`
- Initial screen: `LoginSendOtpScreen`
- Post-auth shell: `MainNavigationPage`

The authenticated shell uses a `PageView` with three sections:

- Home
- Announcement
- Report

## Project Structure

```text
lib/
	core/
		constants/
		navigation/
	features/
		announcement/
		auth/
		home/
		report/
	widgets/
	main.dart
```

### Folder Responsibilities

- `lib/core/`: shared constants and navigation helpers.
- `lib/features/`: feature-specific code grouped by domain.
- `lib/widgets/`: reusable widgets shared across multiple features.

Within a feature, the current pattern is:

- `data/`: models, sample data, and simple services.
- `presentation/`: screens and UI widgets.

## Features

### Auth

- OTP-based entry flow.
- Auth screens currently navigate with `MaterialPageRoute`.
- OTP sending is implemented in `lib/features/auth/data/auth_service.dart`.

### Home

- Presentational landing area after authentication.
- Uses shared widgets like `AppHeader`.
- Uses local sample data for content sections.

### Announcement

- Renders grouped announcement content.
- Uses static seed data.
- Some media URLs are hardcoded remote assets.

### Report

- Shows a list of reports from local data.
- View and download actions are still placeholders.

## Development Setup

### Prerequisites

- Flutter SDK installed and available on `PATH`
- Dart SDK matching the Flutter toolchain
- Xcode for iOS/macOS work on macOS
- Android Studio or Android SDK tools for Android builds

### Install Dependencies

```bash
flutter pub get
```

### Run the App

```bash
flutter run
```

### Quality Checks

```bash
flutter analyze
flutter test
```

### Common Builds

```bash
flutter build apk
flutter build ios
flutter build web
```

## Configuration

Runtime API configuration is currently hardcoded in `lib/core/constants/env_config.dart`.

Current value:

```dart
static const String baseUrl = 'http://192.168.1.2:3000';
```

This is a local network address and may not work on other machines, simulators, or CI environments.

## Architecture Notes

- The project is intentionally lightweight and feature-first.
- There is no state-management package such as Riverpod, Bloc, or Provider configured.
- Networking is done directly with the `http` package.
- Styling is mostly inline, with shared colors defined in `lib/core/constants/app_constants.dart`.
- Two navigation patterns currently exist: direct `MaterialPageRoute` usage and the custom `AppPageRoute` helper in `lib/core/navigation/app_navigator.dart`.

## Current Limitations

- The existing widget test is still the default Flutter counter smoke test and does not match the current app.
- Announcement and report features still rely on static data.
- Report view and download flows are not implemented yet.
- The environment configuration is not flavor-based or secure.

## Recommended Next Improvements

1. Replace the stale widget test with an auth-flow smoke test.
2. Move API configuration to a safer environment-specific setup.
3. Decide whether to standardize navigation on `MaterialPageRoute` or `AppPageRoute`.
4. Implement real report viewing and downloading behavior.

## Reference

Project-specific contributor guidance is documented in `CLAUDE.md`.
