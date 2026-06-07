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
  /// Creates a [NovaCard] widget.

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
  /// Background color. Defaults to theme surface.

  final Widget child;
  /// Inner spacing. Defaults to 16px all sides.

  final EdgeInsetsGeometry padding;
  /// Outer spacing around the card.

  final EdgeInsetsGeometry? margin;

  /// Shadow depth. Defaults to 3.
  final double elevation;
  /// Border radius. Defaults to 16px.

  final BorderRadius? borderRadius;

  /// Override card background. Defaults to theme surface color.
  final Color? color;
  /// Called when the card is tapped.

  final VoidCallback? onTap;
  /// Called when the card is tapped.
  final VoidCallback? onLongPress;
  /// Width of the card.

  final double? width;
  /// Height of the card.

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