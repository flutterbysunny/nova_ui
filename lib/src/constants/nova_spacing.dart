import 'package:flutter/material.dart';

/// Nova UI spacing scale — consistent spacing tokens.
///
/// Based on a 4px base unit. Use these everywhere instead of
/// hardcoded numbers to keep visual rhythm consistent.
///
/// ```dart
/// // Raw values
/// SizedBox(height: NovaSpacing.md)   // 16px
/// SizedBox(width: NovaSpacing.sm)    // 8px
///
/// // EdgeInsets helpers
/// padding: NovaSpacing.paddingMd     // all sides 16px
/// padding: NovaSpacing.paddingH(24)  // horizontal only
/// ```
abstract final class NovaSpacing {
  // ── Scale ────────────────────────────────────────────────────────

  /// 4px
  static const double xs = 4;

  /// 8px
  static const double sm = 8;

  /// 12px
  static const double smMd = 12;

  /// 16px
  static const double md = 16;

  /// 20px
  static const double mdLg = 20;

  /// 24px
  static const double lg = 24;

  /// 32px
  static const double xl = 32;

  /// 40px
  static const double xxl = 40;

  /// 48px
  static const double xxxl = 48;

  // ── EdgeInsets presets ───────────────────────────────────────────

  /// All sides 4px
  static const EdgeInsets paddingXs = EdgeInsets.all(xs);

  /// All sides 8px
  static const EdgeInsets paddingSm = EdgeInsets.all(sm);

  /// All sides 16px
  static const EdgeInsets paddingMd = EdgeInsets.all(md);

  /// All sides 24px
  static const EdgeInsets paddingLg = EdgeInsets.all(lg);

  /// All sides 32px
  static const EdgeInsets paddingXl = EdgeInsets.all(xl);

  /// Horizontal 16px, vertical 8px — common for list tiles & chips.
  static const EdgeInsets paddingCard =
  EdgeInsets.symmetric(horizontal: md, vertical: sm);

  /// Horizontal 24px, vertical 16px — standard screen/page padding.
  static const EdgeInsets paddingPage =
  EdgeInsets.symmetric(horizontal: lg, vertical: md);

  // ── Dynamic helpers ──────────────────────────────────────────────

  /// Symmetric horizontal padding.
  static EdgeInsets paddingH(double value) =>
      EdgeInsets.symmetric(horizontal: value);

  /// Symmetric vertical padding.
  static EdgeInsets paddingV(double value) =>
      EdgeInsets.symmetric(vertical: value);

  /// Custom horizontal + vertical padding.
  static EdgeInsets paddingHV(double h, double v) =>
      EdgeInsets.symmetric(horizontal: h, vertical: v);

  // ── SizedBox helpers ─────────────────────────────────────────────

  /// Vertical gap of 4px.
  static const Widget gapXs = SizedBox(height: xs);

  /// Vertical gap of 8px.
  static const Widget gapSm = SizedBox(height: sm);

  /// Vertical gap of 16px.
  static const Widget gapMd = SizedBox(height: md);

  /// Vertical gap of 24px.
  static const Widget gapLg = SizedBox(height: lg);

  /// Vertical gap of 32px.
  static const Widget gapXl = SizedBox(height: xl);

  /// Horizontal gap of 8px.
  static const Widget gapSmH = SizedBox(width: sm);

  /// Horizontal gap of 16px.
  static const Widget gapMdH = SizedBox(width: md);
}