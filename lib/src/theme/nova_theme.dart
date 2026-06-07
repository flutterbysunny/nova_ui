import 'package:flutter/material.dart';

import '../../nova_ui.dart';

/// Nova UI theme builder — generates a complete [ThemeData] with
/// Nova design tokens pre-applied.
///
/// Usage:
/// ```dart
/// MaterialApp(
///   theme: NovaTheme.light(),
///   darkTheme: NovaTheme.dark(),
///   themeMode: ThemeMode.system,
/// )
/// ```
abstract final class NovaTheme {
  /// Returns a light [ThemeData] with Nova design tokens.
  static ThemeData light({Color? seedColor}) {
    final seed = seedColor ?? NovaColors.indigo;
    final scheme = ColorScheme.fromSeed(
      seedColor: seed,
      brightness: Brightness.light,
    );
    return _build(scheme);
  }

  /// Returns a dark [ThemeData] with Nova design tokens.
  static ThemeData dark({Color? seedColor}) {
    final seed = seedColor ?? NovaColors.indigo;
    final scheme = ColorScheme.fromSeed(
      seedColor: seed,
      brightness: Brightness.dark,
    );
    return _build(scheme);
  }

  static ThemeData _build(ColorScheme scheme) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,

      // Input decoration — matches NovaTextField style
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.surfaceContainerHighest.withValues(alpha:0.3),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: scheme.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: scheme.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: scheme.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: scheme.error),
        ),
      ),

      // ElevatedButton — matches NovaButton filled style
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: scheme.primary,
          foregroundColor: scheme.onPrimary,
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      ),

      // OutlinedButton — matches NovaButton outlined style
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),

      // Card — matches NovaCard defaults
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        color: scheme.surface,
        surfaceTintColor: Colors.transparent,
      ),
    );
  }
}

/// Extension on [BuildContext] for quick access to Nova theme values.
///
/// ```dart
/// // Instead of:
/// Theme.of(context).colorScheme.primary
///
/// // Write:
/// context.novaColors.primary
/// context.novaScheme.surface
/// context.isDark
/// ```
extension NovaThemeContext on BuildContext {
  /// Quick access to [ColorScheme].
  ColorScheme get novaScheme => Theme.of(this).colorScheme;

  /// True if current theme is dark.
  bool get isDark => Theme.of(this).brightness == Brightness.dark;

  /// Primary color shorthand.
  Color get novaPrimary => Theme.of(this).colorScheme.primary;

  /// Surface color shorthand.
  Color get novaSurface => Theme.of(this).colorScheme.surface;

  /// Primary text color shorthand.
  Color get novaTextPrimary => Theme.of(this).colorScheme.onSurface;

  /// Muted text color shorthand.
  Color get novaTextSecondary => Theme.of(this).colorScheme.onSurfaceVariant;
}