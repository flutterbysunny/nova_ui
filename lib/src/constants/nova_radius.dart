import 'package:flutter/material.dart';

/// Nova UI border radius tokens.
///
/// Provides both [BorderRadius] (for Container/decoration)
/// and [Radius] (for individual corners) variants.
///
/// ```dart
/// borderRadius: NovaRadius.md          // BorderRadius.circular(12)
/// borderRadius: NovaRadius.full        // pill/stadium shape
/// radius: NovaRadius.asMd              // Radius.circular(12)
/// ```
abstract final class NovaRadius {
  // ── BorderRadius ─────────────────────────────────────────────────

  /// 4px — subtle rounding, for chips and small badges.
  static const BorderRadius xs = BorderRadius.all(Radius.circular(4));

  /// 8px — small components, tooltips.
  static const BorderRadius sm = BorderRadius.all(Radius.circular(8));

  /// 12px — buttons, text fields, cards.
  static const BorderRadius md = BorderRadius.all(Radius.circular(12));

  /// 16px — large cards, bottom sheets.
  static const BorderRadius lg = BorderRadius.all(Radius.circular(16));

  /// 24px — dialogs, modals.
  static const BorderRadius xl = BorderRadius.all(Radius.circular(24));

  /// 999px — fully pill/stadium shaped.
  static const BorderRadius full = BorderRadius.all(Radius.circular(999));

  // ── Radius (single corner) ───────────────────────────────────────

  /// Radius.circular(4)
  static const Radius asXs = Radius.circular(4);

  /// Radius.circular(8)
  static const Radius asSm = Radius.circular(8);

  /// Radius.circular(12)
  static const Radius asMd = Radius.circular(12);

  /// Radius.circular(16)
  static const Radius asLg = Radius.circular(16);

  /// Radius.circular(24)
  static const Radius asXl = Radius.circular(24);

  // ── Directional helpers ──────────────────────────────────────────

  /// Only top corners rounded — for bottom sheets, snackbars.
  static BorderRadius topMd = const BorderRadius.only(
    topLeft: Radius.circular(12),
    topRight: Radius.circular(12),
  );

  /// Only bottom corners rounded.
  static BorderRadius bottomMd = const BorderRadius.only(
    bottomLeft: Radius.circular(12),
    bottomRight: Radius.circular(12),
  );

  /// Only top corners rounded — large variant for drawers.
  static BorderRadius topLg = const BorderRadius.only(
    topLeft: Radius.circular(24),
    topRight: Radius.circular(24),
  );
}