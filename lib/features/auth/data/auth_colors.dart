import 'package:flutter/material.dart';

/// All auth module color tokens — light mode default, dark mode available.
/// Use [AuthColors.of(context)] in widgets for automatic theme switching.
/// Use static constants only when you explicitly need a fixed color.

class AuthColors {
  AuthColors._();

  // ── Brand (same in both modes) ────────────────────────────────────────────
  static const primary = Color(0xFF4299F0);
  static const primaryLabel = Color(0xFF60A5FA);
  static const gradientStart = Color(0xFF4299F0);
  static const gradientEnd = Color(0xFF2563EB);
  static const secondary = Color(0xFF34D399);

  // ── Light mode ────────────────────────────────────────────────────────────
  static const backgroundLight = Color(0xFFF6F7F8);
  static const surfaceLight = Color(0xFFFFFFFF);
  static const surfaceLowLight = Color(0xFFF1F5F9);
  static const surfaceContainerLight = Color(0xFFF1F5F9);
  static const surfaceHighLight = Color(0xFFE2E8F0);
  static const surfaceBorderLight = Color(0xFFE2E8F0);
  static const onSurfaceLight = Color(0xFF0F172A);
  static const onSurfaceVariantLight = Color(0xFF64748B);
  static const onSurfaceMutedLight = Color(0xFF94A3B8);
  static const outlineLight = Color(0xFFCBD5E1);
  static const outlineVariantLight = Color(0xFFE2E8F0);
  static const inputBgLight = Color(0xFFF8FAFC);
  static const inputPlaceholderLight = Color(0xFFCBD5E1);
  static const focusRingLight = Color(0xFF4299F0);

  // ── Dark mode ─────────────────────────────────────────────────────────────
  static const backgroundDark = Color(0xFF020617);
  static const surfaceDark = Color(0xFF0F172A);
  static const surfaceLowDark = Color(0xFF0A0F1E);
  static const surfaceContainerDark = Color(0xFF1E293B);
  static const surfaceHighDark = Color(0xFF334155);
  static const surfaceBorderDark = Color(0xFF1E293B);
  static const onSurfaceDark = Color(0xFFF8FAFC);
  static const onSurfaceVariantDark = Color(0xFF94A3B8);
  static const onSurfaceMutedDark = Color(0xFF475569);
  static const outlineDark = Color(0xFF334155);
  static const outlineVariantDark = Color(0xFF1E293B);
  static const inputBgDark = Color(0xFF020617);
  static const inputPlaceholderDark = Color(0xFF334155);
  static const focusRingDark = Color(0xFF3B82F6);

  // ── Convenience: returns light or dark set based on context ──────────────
  static AuthThemeColors of(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? AuthThemeColors.dark : AuthThemeColors.light;
  }

  // ── Legacy static aliases (light mode values) ─────────────────────────────
  // Kept so existing widgets that use AuthColors.surface etc. compile
  // without changes — they will always use light mode values.
  // Migrate widgets to AuthColors.of(context).surface when needed.
  static const background = backgroundLight;
  static const surface = surfaceLight;
  static const surfaceLow = surfaceLowLight;
  static const surfaceContainer = surfaceContainerLight;
  static const surfaceHigh = surfaceHighLight;
  static const surfaceBorder = surfaceBorderLight;
  static const onSurface = onSurfaceLight;
  static const onSurfaceVariant = onSurfaceVariantLight;
  static const onSurfaceMuted = onSurfaceMutedLight;
  static const outline = outlineLight;
  static const outlineVariant = outlineVariantLight;
  static const inputBg = inputBgLight;
  static const inputPlaceholder = inputPlaceholderLight;
  static const focusRing = focusRingLight;
}

// ── Theme-aware color set ─────────────────────────────────────────────────────
// Use via AuthColors.of(context) in build methods.

class AuthThemeColors {
  final Color background;
  final Color surface;
  final Color surfaceLow;
  final Color surfaceContainer;
  final Color surfaceHigh;
  final Color surfaceBorder;
  final Color onSurface;
  final Color onSurfaceVariant;
  final Color onSurfaceMuted;
  final Color outline;
  final Color outlineVariant;
  final Color inputBg;
  final Color inputPlaceholder;
  final Color focusRing;

  const AuthThemeColors._({
    required this.background,
    required this.surface,
    required this.surfaceLow,
    required this.surfaceContainer,
    required this.surfaceHigh,
    required this.surfaceBorder,
    required this.onSurface,
    required this.onSurfaceVariant,
    required this.onSurfaceMuted,
    required this.outline,
    required this.outlineVariant,
    required this.inputBg,
    required this.inputPlaceholder,
    required this.focusRing,
  });

  static const light = AuthThemeColors._(
    background: AuthColors.backgroundLight,
    surface: AuthColors.surfaceLight,
    surfaceLow: AuthColors.surfaceLowLight,
    surfaceContainer: AuthColors.surfaceContainerLight,
    surfaceHigh: AuthColors.surfaceHighLight,
    surfaceBorder: AuthColors.surfaceBorderLight,
    onSurface: AuthColors.onSurfaceLight,
    onSurfaceVariant: AuthColors.onSurfaceVariantLight,
    onSurfaceMuted: AuthColors.onSurfaceMutedLight,
    outline: AuthColors.outlineLight,
    outlineVariant: AuthColors.outlineVariantLight,
    inputBg: AuthColors.inputBgLight,
    inputPlaceholder: AuthColors.inputPlaceholderLight,
    focusRing: AuthColors.focusRingLight,
  );

  static const dark = AuthThemeColors._(
    background: AuthColors.backgroundDark,
    surface: AuthColors.surfaceDark,
    surfaceLow: AuthColors.surfaceLowDark,
    surfaceContainer: AuthColors.surfaceContainerDark,
    surfaceHigh: AuthColors.surfaceHighDark,
    surfaceBorder: AuthColors.surfaceBorderDark,
    onSurface: AuthColors.onSurfaceDark,
    onSurfaceVariant: AuthColors.onSurfaceVariantDark,
    onSurfaceMuted: AuthColors.onSurfaceMutedDark,
    outline: AuthColors.outlineDark,
    outlineVariant: AuthColors.outlineVariantDark,
    inputBg: AuthColors.inputBgDark,
    inputPlaceholder: AuthColors.inputPlaceholderDark,
    focusRing: AuthColors.focusRingDark,
  );
}
