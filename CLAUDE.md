# CLAUDE.md

## Project Overview

- Project name: `alai_oosai`
- Stack: Flutter, Dart `^3.11.1`
- Primary targets present: Android, iOS, macOS, Linux, Windows, Web
- Current app shape: mobile-first Flutter application with an OTP-based auth entry flow and a post-auth shell containing Home, Announcement, and Report sections.

The codebase is still in an early product stage. Most screens are UI-driven, several features use static sample data, and infrastructure is intentionally light. Treat this as a feature-first Flutter app rather than a heavily abstracted architecture.

## Current Runtime Entry

- Main entrypoint: `lib/main.dart`
- `MyApp` configures `MaterialApp`
- Initial screen is `LoginSendOtpScreen`
- `MainNavigationPage` exists as the authenticated shell with a `PageView` and `NavigationBar`

This means the app currently starts in the auth flow, not directly in the tab shell.

## High-Level Architecture

The repository follows a simple feature-oriented layout:

- `lib/core/`
  - Cross-cutting constants and navigation helpers.
- `lib/features/`
  - Feature modules grouped by domain: `auth`, `announcement`, `home`, `report`.
- `lib/widgets/`
  - Reusable app-wide UI widgets shared across features.

Inside features, the dominant pattern is:

- `data/`
  - Models, sample data, and simple services.
- `presentation/`
  - Screens and UI widgets.

There is currently no formal state-management framework such as Riverpod, Bloc, or Provider in `pubspec.yaml`. State is mostly local widget state, and data flow is direct.

## Important Files

- `lib/main.dart`
  - App bootstrap, theme, auth-first root, authenticated navigation shell.
- `lib/core/constants/app_constants.dart`
  - Shared color palette.
- `lib/core/constants/env_config.dart`
  - Hardcoded API base URL.
- `lib/core/navigation/app_navigator.dart`
  - Custom route wrapper with transition presets.
- `lib/features/auth/data/auth_service.dart`
  - HTTP OTP request logic.
- `lib/features/announcement/data/announcement_data.dart`
  - Static announcement content and remote media URLs.
- `lib/features/report/data/report_data.dart`
  - Static report list content.
- `lib/widgets/app_header.dart`
  - Shared top header used by the home flow.

## Feature Notes

### Auth

- Entry screen is `LoginSendOtpScreen`.
- Navigation currently uses `MaterialPageRoute` directly in auth screens.
- `AuthService` calls `POST {baseUrl}/auth/register-send-otp`.
- `EnvConfig.baseUrl` is set to `http://192.168.1.2:3000`.

Implication:

- API configuration is local-network specific and not environment-safe yet.
- If you change auth behavior, update both UI flow and the service layer together.

### Home

- Home is mostly presentational.
- It relies on shared theme constants and local sample data.
- The page uses shared widgets such as `AppHeader`.

### Announcement

- Announcement content is currently static.
- Models live in `data/` and presentation renders grouped media items.
- Some items reference remote image/video URLs directly in source.

Implication:

- Avoid treating announcement data as production-backed unless you add a real data source.

### Report

- Reports are rendered from local data.
- `ReportsScreen` includes placeholder callbacks for view and download.
- PDF viewing and downloading are not implemented yet.

## UI and Styling Conventions

- The app uses `ThemeData` with `useMaterial3: true`.
- Shared colors live in `AppColors` under `lib/core/constants/app_constants.dart`.
- Styling is mostly inline within widgets rather than centralized in custom theme extensions.
- Shared UI elements are extracted into `lib/widgets/` or feature-local `presentation/widgets/` folders.

When making UI changes:

- Reuse `AppColors` before adding new hardcoded colors.
- Prefer existing shared widgets where they fit.
- Keep feature-specific widgets inside the feature unless they are reused across domains.

## Navigation Conventions

- Two navigation approaches currently coexist:
  - Direct `Navigator.push(... MaterialPageRoute(...))`
  - Custom `AppPageRoute` from `lib/core/navigation/app_navigator.dart`

Guideline:

- Do not introduce a third navigation pattern.
- If touching an existing flow, stay consistent with that flow's current style unless you are intentionally normalizing navigation across the app.

## Data and Networking Conventions

- Networking uses the `http` package directly.
- There is no repository abstraction or API client layer yet.
- Environment configuration is a plain Dart constant, not build-time flavoring or secure config.
- A mix of real service code and static seed/sample data exists across features.

Guideline:

- Keep networking changes small and explicit.
- Centralize endpoint/base URL edits through `EnvConfig` unless you are deliberately refactoring configuration.
- If you add more API calls, match the existing simplicity unless the task explicitly requires an architecture upgrade.

## Testing and Quality Status

- Linting is configured through `flutter_lints` in `analysis_options.yaml`.
- `get_errors` currently reports no analyzer errors in `lib/` and `test/`.
- The existing widget test is stale.

Current known test issue:

- `test/widget_test.dart` still contains the default Flutter counter smoke test.
- It fails against the current app because `MyApp` now boots into the auth flow and no counter UI exists.

Practical guidance:

- Do not rely on the current test suite as a correctness signal without updating this test first.
- If you change app boot flow or major UI structure, update widget tests in the same task where practical.

## Commands

Use these as the default project commands from the repository root:

```bash
flutter pub get
flutter analyze
flutter test
flutter run
```

Platform-specific builds can use standard Flutter commands, for example:

```bash
flutter build apk
flutter build ios
flutter build web
```

## Repository Facts Worth Preserving

- Feature-first organization is already established; continue using it.
- Shared constants and navigation helpers belong in `lib/core/`.
- Reusable cross-feature UI belongs in `lib/widgets/`.
- Screen-specific UI belongs in each feature's `presentation/` subtree.
- The codebase currently favors directness over abstraction.

## Guidance for Future Changes

When adding or modifying code in this repository:

1. Start by locating the relevant feature folder under `lib/features/`.
2. Preserve the existing feature boundary instead of moving code into generic folders prematurely.
3. Keep changes minimal and local unless the task is explicitly architectural.
4. Reuse `AppColors`, existing shared widgets, and current route patterns.
5. Update tests when changing entry flow, navigation, or visible screen text.
6. Call out hardcoded configuration or placeholder logic if your change depends on it.

## Things To Watch Out For

- `EnvConfig.baseUrl` points to a private LAN IP and may not work on other machines or simulators.
- `AuthService` currently uses `print`, indicating development-stage debugging.
- README is still the default Flutter template and does not document the app.
- Reports contain TODO actions for view/download behavior.
- The repository includes generated platform folders and build output; avoid editing generated files unless the task explicitly requires it.

## Suggested Working Style For Agents

- Read the target feature and its sibling widgets before editing.
- Prefer focused edits over broad cleanup passes.
- Do not add new heavy dependencies or state-management frameworks without a clear requirement.
- If you introduce a shared pattern, apply it consistently within the touched area.
- If a change exposes missing infrastructure, document the limitation rather than silently assuming it exists.

## Good First Follow-Ups

- Replace the stale default widget test with an auth-screen smoke test.
- Move environment configuration away from a hardcoded local IP.
- Expand README to reflect the actual product and setup.
- Decide whether to standardize on `AppPageRoute` or direct `MaterialPageRoute` usage.
- Implement report view/download behavior when the product requirements are defined.