import 'package:flutter/material.dart';

/// Defines the visual state of a [NovaTimelineItem].
enum NovaTimelineState {
  /// Step is completed — filled colored dot with checkmark.
  completed,

  /// Step is currently active — highlighted dot.
  active,

  /// Step is upcoming — outlined dot.
  pending,

  /// Step has an error — red dot with X.
  error,
}

/// A single event/step in a [NovaTimeline].
///
/// Example:
/// ```dart
/// NovaTimelineItem(
///   title: 'Order Placed',
///   subtitle: 'Jun 10, 2026 — 10:30 AM',
///   state: NovaTimelineState.completed,
/// )
///
/// // With custom icon
/// NovaTimelineItem(
///   title: 'Out for Delivery',
///   subtitle: 'Jun 12, 2026 — 9:00 AM',
///   state: NovaTimelineState.active,
///   icon: Icons.local_shipping_rounded,
/// )
/// ```
class NovaTimelineItem {
  /// Creates a [NovaTimelineItem].
  const NovaTimelineItem({
    required this.title,
    this.subtitle,
    this.state = NovaTimelineState.pending,
    this.icon,
    this.trailing,
    this.content,
  });

  /// Primary title text.
  final String title;

  /// Secondary subtitle/timestamp text.
  final String? subtitle;

  /// Visual state — completed, active, pending, error.
  final NovaTimelineState state;

  /// Optional custom icon shown inside the dot.
  final IconData? icon;

  /// Optional trailing widget (e.g. a badge or button).
  final Widget? trailing;

  /// Optional expanded content shown below the title/subtitle.
  final Widget? content;
}

/// A vertical timeline widget for Nova UI.
///
/// Use for order tracking, activity feeds, and process steps.
/// Connects items with a vertical line, color-coded by state.
///
/// Example:
/// ```dart
/// NovaTimeline(
///   items: [
///     NovaTimelineItem(
///       title: 'Order Placed',
///       subtitle: 'Jun 10, 2026 — 10:30 AM',
///       state: NovaTimelineState.completed,
///     ),
///     NovaTimelineItem(
///       title: 'Order Shipped',
///       subtitle: 'Jun 11, 2026 — 2:15 PM',
///       state: NovaTimelineState.completed,
///     ),
///     NovaTimelineItem(
///       title: 'Out for Delivery',
///       subtitle: 'Jun 12, 2026 — 9:00 AM',
///       state: NovaTimelineState.active,
///       icon: Icons.local_shipping_rounded,
///     ),
///     NovaTimelineItem(
///       title: 'Delivered',
///       state: NovaTimelineState.pending,
///     ),
///   ],
/// )
/// ```
class NovaTimeline extends StatelessWidget {
  /// Creates a [NovaTimeline] widget.
  const NovaTimeline({
    super.key,
    required this.items,
    this.completedColor,
    this.activeColor,
    this.pendingColor,
    this.errorColor,
    this.dotSize = 28,
    this.lineThickness = 2,
    this.spacing = 24,
  });

  /// List of timeline items, in chronological order.
  final List<NovaTimelineItem> items;

  /// Color for completed dots/lines. Defaults to theme primary.
  final Color? completedColor;

  /// Color for the active dot. Defaults to theme primary.
  final Color? activeColor;

  /// Color for pending dots/lines.
  final Color? pendingColor;

  /// Color for error dots.
  final Color? errorColor;

  /// Diameter of each dot. Defaults to 28px.
  final double dotSize;

  /// Thickness of connecting lines. Defaults to 2px.
  final double lineThickness;

  /// Vertical spacing between items. Defaults to 24px.
  final double spacing;

  Color _stateColor(NovaTimelineState state, ColorScheme scheme) {
    switch (state) {
      case NovaTimelineState.completed:
        return completedColor ?? scheme.primary;
      case NovaTimelineState.active:
        return activeColor ?? scheme.primary;
      case NovaTimelineState.pending:
        return pendingColor ?? scheme.onSurface.withValues(alpha: 0.2);
      case NovaTimelineState.error:
        return errorColor ?? scheme.error;
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(items.length, (index) {
        final item = items[index];
        final isLast = index == items.length - 1;
        final color = _stateColor(item.state, scheme);

        // Line color — based on next item's state (or current if last)
        final lineColor = !isLast
            ? _stateColor(items[index + 1].state, scheme)
            : color;
        final showLine = !isLast;
        final lineActive = item.state == NovaTimelineState.completed;

        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Dot + connecting line
              Column(
                children: [
                  _buildDot(item, color, scheme),
                  if (showLine)
                    Expanded(
                      child: Container(
                        width: lineThickness,
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        color: lineActive
                            ? (completedColor ?? scheme.primary)
                            : (pendingColor ??
                            scheme.onSurface.withValues(alpha: 0.15)),
                      ),
                    ),
                ],
              ),

              const SizedBox(width: 14),

              // Content
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    bottom: isLast ? 0 : spacing,
                    top: (dotSize - 18) / 2,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              item.title,
                              style: TextStyle(
                                color: item.state == NovaTimelineState.pending
                                    ? scheme.onSurfaceVariant
                                    : scheme.onSurface,
                                fontSize: 14,
                                fontWeight: item.state ==
                                    NovaTimelineState.active
                                    ? FontWeight.w700
                                    : FontWeight.w600,
                              ),
                            ),
                          ),
                          if (item.trailing != null) item.trailing!,
                        ],
                      ),
                      if (item.subtitle != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          item.subtitle!,
                          style: TextStyle(
                            color: scheme.onSurfaceVariant,
                            fontSize: 12,
                          ),
                        ),
                      ],
                      if (item.content != null) ...[
                        const SizedBox(height: 8),
                        item.content!,
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildDot(NovaTimelineItem item, Color color, ColorScheme scheme) {
    final Widget child;

    switch (item.state) {
      case NovaTimelineState.completed:
        child = Icon(
          Icons.check_rounded,
          size: dotSize * 0.55,
          color: Colors.white,
        );
        break;
      case NovaTimelineState.active:
        child = Icon(
          item.icon ?? Icons.fiber_manual_record_rounded,
          size: dotSize * 0.5,
          color: Colors.white,
        );
        break;
      case NovaTimelineState.error:
        child = Icon(
          Icons.close_rounded,
          size: dotSize * 0.55,
          color: Colors.white,
        );
        break;
      case NovaTimelineState.pending:
        child = item.icon != null
            ? Icon(item.icon, size: dotSize * 0.5, color: color)
            : const SizedBox.shrink();
        break;
    }

    final isFilled = item.state == NovaTimelineState.completed ||
        item.state == NovaTimelineState.active ||
        item.state == NovaTimelineState.error;

    return Container(
      width: dotSize,
      height: dotSize,
      decoration: BoxDecoration(
        color: isFilled ? color : Colors.transparent,
        shape: BoxShape.circle,
        border: Border.all(color: color, width: 2),
        boxShadow: item.state == NovaTimelineState.active
            ? [
          BoxShadow(
            color: color.withValues(alpha: 0.3),
            blurRadius: 8,
            spreadRadius: 2,
          ),
        ]
            : null,
      ),
      child: Center(child: child),
    );
  }
}