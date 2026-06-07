import 'package:flutter/material.dart';

/// Defines the visual style of a [NovaButton].
enum NovaButtonVariant {
  /// Solid filled button (default).
  filled,

  /// Transparent button with a border.
  outlined,

  /// Text-only button with no background or border.
  text,
}

/// A customizable button widget for Nova UI.
///
/// Supports filled, outlined, and text variants, optional loading state,
/// disabled state (pass `null` to [onPressed]), and an optional leading icon.
///
/// Example:
/// ```dart
/// NovaButton(
///   text: 'Login',
///   onPressed: () {},
/// )
///
/// NovaButton(
///   text: 'Cancel',
///   variant: NovaButtonVariant.outlined,
///   onPressed: () {},
/// )
/// ```
class NovaButton extends StatelessWidget {
  /// Creates a [NovaButton] widget.
  const NovaButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.variant = NovaButtonVariant.filled,
    this.loading = false,
    this.icon,
    this.height = 52,
    this.width = double.infinity,
    this.backgroundColor,
    this.foregroundColor,
    this.borderRadius = const BorderRadius.all(Radius.circular(12)),
    this.padding,
  });

  /// Button label text.
  final String text;

  /// Called when the button is tapped. Pass `null` to disable the button.
  final VoidCallback? onPressed;

  /// Visual style — filled, outlined, or text.
  final NovaButtonVariant variant;

  /// When `true`, shows a loading spinner and disables taps.
  final bool loading;

  /// Optional icon shown before the text.
  final Widget? icon;
  /// The button's height. Defaults to 52.
  final double height;
  /// The button's width. Defaults to full width.
  final double width;

  /// Override background color. Defaults to theme primary color.
  final Color? backgroundColor;

  /// Override text/icon color. Defaults to white for filled, primary for others.
  final Color? foregroundColor;
  /// Border radius of the button. Defaults to 12px.

  final BorderRadius borderRadius;
  /// Padding inside the button.

  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final primary = colorScheme.primary;
    final isDisabled = onPressed == null || loading;

    final resolvedBg = backgroundColor ?? primary;
    final resolvedFg = foregroundColor ??
        (variant == NovaButtonVariant.filled ? Colors.white : primary);

    final content = loading
        ? SizedBox(
      height: 20,
      width: 20,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        color: resolvedFg,
      ),
    )
        : Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null) ...[
          IconTheme(
            data: IconThemeData(color: resolvedFg, size: 18),
            child: icon!,
          ),
          const SizedBox(width: 8),
        ],
        Text(
          text,
          style: TextStyle(
            color: resolvedFg,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      ],
    );

    switch (variant) {
      case NovaButtonVariant.filled:
        return SizedBox(
          height: height,
          width: width,
          child: ElevatedButton(
            onPressed: isDisabled ? null : onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: resolvedBg,
              foregroundColor: resolvedFg,
              padding: padding,
              shape: RoundedRectangleBorder(borderRadius: borderRadius),
              elevation: isDisabled ? 0 : 2,
            ),
            child: content,
          ),
        );

      case NovaButtonVariant.outlined:
        return SizedBox(
          height: height,
          width: width,
          child: OutlinedButton(
            onPressed: isDisabled ? null : onPressed,
            style: OutlinedButton.styleFrom(
              foregroundColor: resolvedFg,
              padding: padding,
              shape: RoundedRectangleBorder(borderRadius: borderRadius),
              side: BorderSide(
                color: isDisabled ? Colors.grey : resolvedBg,
              ),
            ),
            child: content,
          ),
        );

      case NovaButtonVariant.text:
        return SizedBox(
          height: height,
          width: width,
          child: TextButton(
            onPressed: isDisabled ? null : onPressed,
            style: TextButton.styleFrom(
              foregroundColor: resolvedFg,
              padding: padding,
              shape: RoundedRectangleBorder(borderRadius: borderRadius),
            ),
            child: content,
          ),
        );
    }
  }
}