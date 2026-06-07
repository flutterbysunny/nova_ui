import 'package:flutter/material.dart';
import '../../../nova_ui.dart';

/// A pre-styled card widget built on top of [NovaContainer].
///
/// Provides a consistent surface with rounded corners, subtle shadow,
/// and theme-aware background — zero configuration needed.
///
/// Example:
/// ```dart
/// NovaCard(
///   child: ListTile(
///     title: Text('Hello'),
///     subtitle: Text('Nova Card'),
///   ),
/// )
///
/// // Tappable card
/// NovaCard(
///   onTap: () => print('card tapped'),
///   child: Text('Tap me'),
/// )
/// ```
class NovaCard extends StatelessWidget {
  const NovaCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.margin,
    this.elevation = 3,
    this.borderRadius,
    this.color,
    this.onTap,
    this.onLongPress,
    this.width,
    this.height,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;

  /// Shadow depth. Defaults to 3.
  final double elevation;

  final BorderRadius? borderRadius;

  /// Override card background. Defaults to theme surface color.
  final Color? color;

  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return NovaContainer(
      padding: padding,
      margin: margin,
      elevation: elevation,
      width: width,
      height: height,
      color: color ?? colorScheme.surface,
      borderRadius: borderRadius ?? BorderRadius.circular(16),
      onTap: onTap,
      onLongPress: onLongPress,
      child: child,
    );
  }
}