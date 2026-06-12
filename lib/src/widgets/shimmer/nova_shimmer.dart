import 'package:flutter/material.dart';

/// Defines the shape of a [NovaShimmer] placeholder.
enum NovaShimmerShape {
  /// Rounded rectangle — for text lines, cards, images.
  rectangle,

  /// Perfect circle — for avatars, icons.
  circle,
}

/// A shimmer loading placeholder widget for Nova UI.
///
/// Displays an animated gradient shimmer effect while content is loading.
/// Use [NovaShimmer] for individual placeholders, or [NovaShimmer.list]
/// for repeating list skeletons.
///
/// Example:
/// ```dart
/// // Simple rectangle placeholder
/// NovaShimmer(width: 200, height: 16)
///
/// // Circle avatar placeholder
/// NovaShimmer.circle(size: 48)
///
/// // Full card skeleton
/// NovaShimmer.card()
///
/// // List skeleton
/// NovaShimmer.list(itemCount: 5)
/// ```
class NovaShimmer extends StatefulWidget {
  /// Rectangle shimmer — for text, images, cards.
  const NovaShimmer({
    super.key,
    this.width = double.infinity,
    this.height = 16,
    this.borderRadius,
    this.margin,
  }) : shape = NovaShimmerShape.rectangle,
        size = null;

  /// Circle shimmer — for avatars, profile pictures.
  const NovaShimmer.circle({
    super.key,
    this.size = 48,
    this.margin,
  }) : shape = NovaShimmerShape.circle,
        width = null,
        height = null,
        borderRadius = null;

  /// Pre-built card skeleton — title + subtitle + action.
  static Widget card({EdgeInsetsGeometry? margin}) {
    return _NovaShimmerCard(margin: margin);
  }

  /// Pre-built list skeleton — repeating rows of avatar + text.
  static Widget list({
    int itemCount = 4,
    EdgeInsetsGeometry? padding,
  }) {
    return _NovaShimmerList(itemCount: itemCount, padding: padding);
  }

  /// Shape of the shimmer placeholder.
  final NovaShimmerShape shape;

  /// Width for rectangle shimmer.
  final double? width;

  /// Height for rectangle shimmer.
  final double? height;

  /// Size (width + height) for circle shimmer.
  final double? size;

  /// Border radius for rectangle shimmer. Defaults to 8px.
  final BorderRadius? borderRadius;

  /// Outer spacing.
  final EdgeInsetsGeometry? margin;

  @override
  State<NovaShimmer> createState() => _NovaShimmerState();
}

class _NovaShimmerState extends State<NovaShimmer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();

    _animation = Tween<double>(begin: -1.5, end: 1.5).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final baseColor = isDark
        ? const Color(0xFF2A2D3E)
        : const Color(0xFFE8ECF0);

    final highlightColor = isDark
        ? const Color(0xFF3D4160)
        : const Color(0xFFF5F7FA);

    final isCircle = widget.shape == NovaShimmerShape.circle;
    final resolvedWidth = isCircle ? widget.size! : widget.width;
    final resolvedHeight = isCircle ? widget.size! : widget.height;
    final resolvedRadius = isCircle
        ? BorderRadius.circular(999)
        : (widget.borderRadius ?? BorderRadius.circular(8));

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, _) {
        return Container(
          width: resolvedWidth,
          height: resolvedHeight,
          margin: widget.margin,
          decoration: BoxDecoration(
            borderRadius: resolvedRadius,
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                baseColor,
                highlightColor,
                baseColor,
              ],
              stops: [
                (_animation.value - 0.3).clamp(0.0, 1.0),
                _animation.value.clamp(0.0, 1.0),
                (_animation.value + 0.3).clamp(0.0, 1.0),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ── Pre-built skeletons ───────────────────────────────────────────────

/// Internal card skeleton widget.
class _NovaShimmerCard extends StatelessWidget {
  const _NovaShimmerCard({this.margin});

  /// Outer spacing.
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      margin: margin,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Title line
          NovaShimmer(width: double.infinity, height: 18),
          SizedBox(height: 10),
          // Subtitle line — shorter
          NovaShimmer(width: 180, height: 13),
          SizedBox(height: 6),
          NovaShimmer(width: 120, height: 13),
          SizedBox(height: 20),
          // Action button placeholder
          NovaShimmer(width: double.infinity, height: 44,
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
        ],
      ),
    );
  }
}

/// Internal list skeleton widget.
class _NovaShimmerList extends StatelessWidget {
  const _NovaShimmerList({
    required this.itemCount,
    this.padding,
  });

  /// Number of skeleton rows to show.
  final int itemCount;

  /// Padding around the list.
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(itemCount, (i) {
          return const Padding(
            padding:  EdgeInsets.only(bottom: 16),
            child: Row(
              children: [
                // Avatar circle
                NovaShimmer.circle(size: 44),
                SizedBox(width: 12),
                // Text lines
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      NovaShimmer(width: double.infinity, height: 14),
                      SizedBox(height: 8),
                      NovaShimmer(width: 140, height: 12),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}