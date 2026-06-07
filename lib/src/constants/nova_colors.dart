import 'package:flutter/material.dart';

/// Nova UI color palette — semantic + raw color tokens.
///
/// Semantic colors (like [primary], [error]) automatically adapt
/// to light/dark mode via [BuildContext]. Raw color swatches
/// (like [indigo], [slate]) are always available as static constants.
///
/// Usage:
/// ```dart
/// // Semantic — theme-aware
/// color: NovaColors.primary(context)
/// color: NovaColors.surface(context)
///
/// // Raw swatch — always the same
/// color: NovaColors.indigo[600]
/// ```
abstract final class NovaColors {
  // ── Raw swatches ────────────────────────────────────────────────

  /// Indigo swatch — Nova's default brand color family.
  static const MaterialColor indigo = MaterialColor(
    0xFF6366F1,
    <int, Color>{
      50:  Color(0xFFEEF2FF),
      100: Color(0xFFE0E7FF),
      200: Color(0xFFC7D2FE),
      300: Color(0xFFA5B4FC),
      400: Color(0xFF818CF8),
      500: Color(0xFF6366F1),
      600: Color(0xFF4F46E5),
      700: Color(0xFF4338CA),
      800: Color(0xFF3730A3),
      900: Color(0xFF312E81),
    },
  );

  /// Slate swatch — used for neutrals, text, surfaces.
  static const MaterialColor slate = MaterialColor(
    0xFF64748B,
    <int, Color>{
      50:  Color(0xFFF8FAFC),
      100: Color(0xFFF1F5F9),
      200: Color(0xFFE2E8F0),
      300: Color(0xFFCBD5E1),
      400: Color(0xFF94A3B8),
      500: Color(0xFF64748B),
      600: Color(0xFF475569),
      700: Color(0xFF334155),
      800: Color(0xFF1E293B),
      900: Color(0xFF0F172A),
    },
  );

  /// Green swatch — for success states.
  static const MaterialColor green = MaterialColor(
    0xFF22C55E,
    <int, Color>{
      50:  Color(0xFFF0FDF4),
      100: Color(0xFFDCFCE7),
      200: Color(0xFFBBF7D0),
      400: Color(0xFF4ADE80),
      500: Color(0xFF22C55E),
      600: Color(0xFF16A34A),
      700: Color(0xFF15803D),
    },
  );

  /// Amber swatch — for warning states.
  static const MaterialColor amber = MaterialColor(
    0xFFF59E0B,
    <int, Color>{
      50:  Color(0xFFFFFBEB),
      100: Color(0xFFFEF3C7),
      400: Color(0xFFFBBF24),
      500: Color(0xFFF59E0B),
      600: Color(0xFFD97706),
      700: Color(0xFFB45309),
    },
  );

  /// Red swatch — for error/danger states.
  static const MaterialColor red = MaterialColor(
    0xFFEF4444,
    <int, Color>{
      50:  Color(0xFFFEF2F2),
      100: Color(0xFFFEE2E2),
      400: Color(0xFFF87171),
      500: Color(0xFFEF4444),
      600: Color(0xFFDC2626),
      700: Color(0xFFB91C1C),
    },
  );

  // ── Semantic — theme-aware ───────────────────────────────────────

  /// Brand primary color — adapts to theme's colorScheme.primary.
  static Color primary(BuildContext context) =>
      Theme.of(context).colorScheme.primary;

  /// On-primary color (text/icons on primary bg).
  static Color onPrimary(BuildContext context) =>
      Theme.of(context).colorScheme.onPrimary;

  /// Surface color — cards, sheets, dialogs.
  static Color surface(BuildContext context) =>
      Theme.of(context).colorScheme.surface;

  /// Background color — page/scaffold background.
  static Color background(BuildContext context) =>
      Theme.of(context).colorScheme.surface;

  /// Primary text color.
  static Color textPrimary(BuildContext context) =>
      Theme.of(context).colorScheme.onSurface;

  /// Secondary/muted text color.
  static Color textSecondary(BuildContext context) =>
      Theme.of(context).colorScheme.onSurfaceVariant;

  /// Border/outline color.
  static Color outline(BuildContext context) =>
      Theme.of(context).colorScheme.outline;

  /// Semantic error color.
  static Color error(BuildContext context) =>
      Theme.of(context).colorScheme.error;

  /// Semantic success color — green regardless of theme.
  static Color success(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? green[400]! : green[600]!;
  }

  /// Semantic warning color — amber regardless of theme.
  static Color warning(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? amber[400]! : amber[600]!;
  }
}