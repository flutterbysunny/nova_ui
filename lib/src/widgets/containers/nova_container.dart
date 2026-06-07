import 'package:flutter/material.dart';

/// A flexible styled container for Nova UI.
///
/// Supports tap handling, elevation shortcuts, gradients, borders,
/// and custom sizing — all theme-aware.
///
/// Example:
/// ```dart
/// NovaContainer(
///   onTap: () => print('tapped'),
///   elevation: 4,
///   borderRadius: BorderRadius.circular(16),
///   child: Text('Hello'),
/// )
/// ```
class NovaContainer extends StatelessWidget {
  const NovaContainer({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.color,
    this.borderRadius,
    this.border,
    this.gradient,
    this.boxShadow,
    this.elevation,
    this.onTap,
    this.onLongPress,
    this.width,
    this.height,
    this.clipBehavior = Clip.antiAlias,
    this.alignment,
  }) : assert(
  color == null || gradient == null,
  'Cannot use both color and gradient at the same time.',
  );

  final Widget child;

  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  /// Background color. Cannot be used together with [gradient].
  final Color? color;

  final BorderRadius? borderRadius;
  final Border? border;

  /// Background gradient. Cannot be used together with [color].
  final Gradient? gradient;

  /// Manual shadow list. If provided, overrides [elevation].
  final List<BoxShadow>? boxShadow;

  /// Shorthand elevation — generates a shadow automatically.
  /// Ignored if [boxShadow] is provided.
  final double? elevation;

  /// Makes the container tappable with an ink ripple effect.
  final VoidCallback? onTap;

  final VoidCallback? onLongPress;

  final double? width;
  final double? height;

  /// How to clip content. Defaults to [Clip.antiAlias].
  final Clip clipBehavior;

  final AlignmentGeometry? alignment;

  List<BoxShadow> _buildShadow(double elev) {
    return [
      BoxShadow(
        color: Colors.black.withValues(alpha:0.08 + elev * 0.01),
        blurRadius: elev * 2,
        offset: Offset(0, elev * 0.5),
        spreadRadius: elev * 0.1,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final resolvedShadow = boxShadow ?? (elevation != null ? _buildShadow(elevation!) : null);

    final decoration = BoxDecoration(
      color: gradient == null ? color : null,
      gradient: gradient,
      borderRadius: borderRadius,
      border: border,
      boxShadow: resolvedShadow,
    );

    Widget container = Container(
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      alignment: alignment,
      decoration: decoration,
      clipBehavior: borderRadius != null ? clipBehavior : Clip.none,
      child: child,
    );

    // Wrap with InkWell only when tappable — keeps non-tappable containers lightweight
    if (onTap != null || onLongPress != null) {
      container = Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          onLongPress: onLongPress,
          borderRadius: borderRadius,
          child: container,
        ),
      );
    }

    return container;
  }
}