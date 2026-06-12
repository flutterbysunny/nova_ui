import 'package:flutter/material.dart';

/// Defines the trend direction for a [NovaStatCard].
enum NovaStatTrend {
  /// Value increased — green up arrow.
  up,

  /// Value decreased — red down arrow.
  down,

  /// No change — neutral indicator.
  neutral,
}

/// A metric/statistic display card for Nova UI.
///
/// Use for dashboards — shows a label, large value, optional trend
/// indicator with percentage change, and an icon.
///
/// Example:
/// ```dart
/// // Simple stat
/// NovaStatCard(
///   label: 'Total Revenue',
///   value: '\$24,500',
///   icon: Icons.attach_money_rounded,
/// )
///
/// // With trend
/// NovaStatCard(
///   label: 'Active Users',
///   value: '1,204',
///   trend: NovaStatTrend.up,
///   trendValue: '+12.5%',
///   icon: Icons.people_outline_rounded,
/// )
///
/// // Downward trend
/// NovaStatCard(
///   label: 'Bounce Rate',
///   value: '34.2%',
///   trend: NovaStatTrend.down,
///   trendValue: '-2.1%',
///   icon: Icons.trending_down_rounded,
///   iconColor: Colors.orange,
/// )
/// ```
class NovaStatCard extends StatelessWidget {
  /// Creates a [NovaStatCard] widget.
  const NovaStatCard({
    super.key,
    required this.label,
    required this.value,
    this.icon,
    this.iconColor,
    this.trend,
    this.trendValue,
    this.subtitle,
    this.onTap,
    this.width,
  });

  /// Small label text above the value (e.g. 'Total Revenue').
  final String label;

  /// Large primary value (e.g. '\$24,500').
  final String value;

  /// Optional icon shown in a colored badge.
  final IconData? icon;

  /// Override icon background/foreground color. Defaults to theme primary.
  final Color? iconColor;

  /// Trend direction — up, down, or neutral.
  final NovaStatTrend? trend;

  /// Trend percentage text (e.g. '+12.5%').
  final String? trendValue;

  /// Optional subtitle below the trend (e.g. 'vs last month').
  final String? subtitle;

  /// Called when the card is tapped.
  final VoidCallback? onTap;

  /// Fixed width. If null, expands to fill available space.
  final double? width;

  // ── Trend resolution ──────────────────────────────────────────────

  Color _trendColor() {
    switch (trend) {
      case NovaStatTrend.up:
        return const Color(0xFF22C55E);
      case NovaStatTrend.down:
        return const Color(0xFFEF4444);
      case NovaStatTrend.neutral:
      case null:
        return const Color(0xFF94A3B8);
    }
  }

  IconData _trendIcon() {
    switch (trend) {
      case NovaStatTrend.up:
        return Icons.arrow_upward_rounded;
      case NovaStatTrend.down:
        return Icons.arrow_downward_rounded;
      case NovaStatTrend.neutral:
      case null:
        return Icons.remove_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final resolvedIconColor = iconColor ?? scheme.primary;

    final content = Container(
      width: width,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header row — icon + label
          Row(
            children: [
              if (icon != null) ...[
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: resolvedIconColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, size: 18, color: resolvedIconColor),
                ),
                const SizedBox(width: 10),
              ],
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    color: scheme.onSurfaceVariant,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Value
          Text(
            value,
            style: TextStyle(
              color: scheme.onSurface,
              fontSize: 24,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.5,
            ),
          ),

          // Trend row
          if (trend != null || subtitle != null) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                if (trend != null && trendValue != null) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: _trendColor().withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _trendIcon(),
                          size: 11,
                          color: _trendColor(),
                        ),
                        const SizedBox(width: 2),
                        Text(
                          trendValue!,
                          style: TextStyle(
                            color: _trendColor(),
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 6),
                ],
                if (subtitle != null)
                  Expanded(
                    child: Text(
                      subtitle!,
                      style: TextStyle(
                        color: scheme.onSurfaceVariant,
                        fontSize: 11,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
              ],
            ),
          ],
        ],
      ),
    );

    if (onTap == null) return content;

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: content,
      ),
    );
  }
}

/// A responsive grid of [NovaStatCard]s.
///
/// Example:
/// ```dart
/// NovaStatGrid(
///   crossAxisCount: 2,
///   cards: [
///     NovaStatCard(label: 'Revenue', value: '\$24.5K', icon: Icons.attach_money_rounded),
///     NovaStatCard(label: 'Orders', value: '342', icon: Icons.shopping_bag_outlined),
///     NovaStatCard(label: 'Users', value: '1.2K', icon: Icons.people_outline_rounded),
///     NovaStatCard(label: 'Growth', value: '12.4%', icon: Icons.trending_up_rounded),
///   ],
/// )
/// ```
class NovaStatGrid extends StatelessWidget {
  /// Creates a [NovaStatGrid] widget.
  const NovaStatGrid({
    super.key,
    required this.cards,
    this.crossAxisCount = 2,
    this.spacing = 12,
    this.childAspectRatio = 1.3,
  });

  /// List of [NovaStatCard] widgets.
  final List<NovaStatCard> cards;

  /// Number of columns. Defaults to 2.
  final int crossAxisCount;

  /// Spacing between cards. Defaults to 12px.
  final double spacing;

  /// Width/height ratio of each card. Defaults to 1.3.
  final double childAspectRatio;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: spacing,
        mainAxisSpacing: spacing,
        childAspectRatio: childAspectRatio,
      ),
      itemCount: cards.length,
      itemBuilder: (context, index) => cards[index],
    );
  }
}