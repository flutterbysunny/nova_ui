import 'package:flutter/material.dart';

/// Defines the visual style of a [NovaBadge].
enum NovaBadgeVariant {
  /// Solid filled background (default).
  filled,

  /// Transparent background with colored border and text.
  outlined,

  /// Soft tinted background — subtle, less prominent.
  soft,
}

/// Defines the semantic color intent of a [NovaBadge].
enum NovaBadgeColor {
  /// Theme primary color.
  primary,

  /// Green — success/active states.
  success,

  /// Amber — warning/pending states.
  warning,

  /// Red — error/critical states.
  danger,

  /// Neutral grey — inactive/default states.
  neutral,
}

/// A flexible badge widget for Nova UI.
/// Use for notification counts, status labels, tags, and dot indicators.
/// Supports filled, outlined, and soft variants with semantic colors.
///
/// Example:
/// ```dart
/// // Status label
/// NovaBadge(label: 'Active', color: NovaBadgeColor.success)
///
/// // Notification dot
/// NovaBadge(isDot: true, color: NovaBadgeColor.danger)
///
/// // Count badge
/// NovaBadge(count: 5)
///
/// // On top of another widget
/// NovaBadge(
///   count: 3,
///   child: Icon(Icons.notifications),
/// )
/// ```
class NovaBadge extends StatelessWidget {
  /// Creates a [NovaBadge] widget.

  const NovaBadge({
    super.key,
    this.label,
    this.count,
    this.child,
    this.isDot = false,
    this.variant = NovaBadgeVariant.filled,
    this.color = NovaBadgeColor.primary,
    this.icon,
    this.fontSize = 12,
  }) : assert(
  label != null || count != null || isDot,
  'Provide at least one of: label, count, or isDot: true',
  );

  /// Text label shown inside the badge.
  final String? label;

  /// Number shown inside the badge. Values above 99 show as "99+".
  final int? count;

  /// When true, renders a small colored dot with no text.
  final bool isDot;

  /// When provided, badge is positioned on top-right of this widget.
  final Widget? child;

  /// Visual style — filled, outlined, soft.
  final NovaBadgeVariant variant;

  /// Semantic color intent.
  final NovaBadgeColor color;

  /// Optional leading icon inside the badge.
  final Widget? icon;

  /// Font size for label/count text.
  final double fontSize;

  // ── Color resolution ──────────────────────────────────────────────

  Color _resolveBase(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    switch (color) {
      case NovaBadgeColor.primary:
        return scheme.primary;
      case NovaBadgeColor.success:
        return const Color(0xFF22C55E);
      case NovaBadgeColor.warning:
        return const Color(0xFFF59E0B);
      case NovaBadgeColor.danger:
        return scheme.error;
      case NovaBadgeColor.neutral:
        return scheme.onSurfaceVariant;
    }
  }

  // ── Badge builder ─────────────────────────────────────────────────

  Widget _buildBadge(BuildContext context, {bool compact = false}) {
    final base = _resolveBase(context);
    final scheme = Theme.of(context).colorScheme;

    // Dot badge
    if (isDot) {
      return Container(
        width: compact ? 8 : 10,
        height: compact ? 8 : 10,
        decoration: BoxDecoration(
          color: base,
          shape: BoxShape.circle,
          border: Border.all(
            color: scheme.surface,
            width: compact ? 1.5 : 2,
          ),
        ),
      );
    }

    // Resolve colors per variant
    final Color bgColor;
    final Color textColor;
    final Border? border;

    switch (variant) {
      case NovaBadgeVariant.filled:
        bgColor = base;
        textColor = Colors.white;
        border = null;
        break;
      case NovaBadgeVariant.outlined:
        bgColor = Colors.transparent;
        textColor = base;
        border = Border.all(color: base, width: 1.5);
        break;
      case NovaBadgeVariant.soft:
        bgColor = base.withValues(alpha: 0.12);
        textColor = base;
        border = null;
        break;
    }

    // Count badge
    if (count != null) {
      final text = count! > 99 ? '99+' : '$count';
      return Container(
        constraints: const BoxConstraints(minWidth: 20, minHeight: 20),
        padding: const EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(99),
          border: border,
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: textColor,
              fontSize: fontSize,
              fontWeight: FontWeight.w700,
              height: 1,
            ),
          ),
        ),
      );
    }

    // Label badge
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(99),
        border: border,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            IconTheme(
              data: IconThemeData(color: textColor, size: fontSize + 2),
              child: icon!,
            ),
            const SizedBox(width: 4),
          ],
          Text(
            label ?? '',
            style: TextStyle(
              color: textColor,
              fontSize: fontSize,
              fontWeight: FontWeight.w600,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Overlay mode — badge on top-right of child
    if (child != null) {
      return Stack(
        clipBehavior: Clip.none,
        children: [
          child!,
          Positioned(
            top: -4,
            right: -4,
            child: _buildBadge(context, compact: true),
          ),
        ],
      );
    }

    return _buildBadge(context);
  }
}