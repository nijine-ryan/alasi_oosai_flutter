import 'package:flutter/material.dart';

/// Global theme-mode notifier. Import this anywhere to read or change the app theme.
final ValueNotifier<ThemeMode> appThemeMode = ValueNotifier(ThemeMode.light);
