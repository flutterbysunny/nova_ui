import 'package:flutter/material.dart';

/// Defines the visual style of a [NovaLoader].
enum NovaLoaderType {
  /// Circular spinning indicator (default).
  circular,

  /// Horizontal linear progress bar.
  linear,

  /// Three bouncing dots animation.
  dots,
}

/// A themed loading indicator widget for Nova UI.
///
/// Supports circular, linear, and dots variants.
/// All colors are automatically driven by the theme.
///
/// Example:
/// ```dart
/// // Circular (default)
/// NovaLoader()
///
/// // Linear
/// NovaLoader(type: NovaLoaderType.linear)
///
/// // Dots
/// NovaLoader(type: NovaLoaderType.dots)
///
/// // Custom color + size
/// NovaLoader(color: Colors.white, size: 32)
/// ```
class NovaLoader extends StatefulWidget {
  const NovaLoader({
    super.key,
    this.type = NovaLoaderType.circular,
    this.color,
    this.size = 24,
    this.strokeWidth = 2.5,
    this.width,
  });

  /// Visual style — circular, linear, or dots.
  final NovaLoaderType type;

  /// Override loader color. Defaults to theme primary.
  final Color? color;

  /// Size of circular loader or dot size. Default 24.
  final double size;

  /// Stroke width for circular loader. Default 2.5.
  final double strokeWidth;

  /// Width for linear loader. Defaults to full width.
  final double? width;

  @override
  State<NovaLoader> createState() => _NovaLoaderState();
}

class _NovaLoaderState extends State<NovaLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0.3, end: 1.0).animate(
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
    final color = widget.color ?? Theme.of(context).colorScheme.primary;

    switch (widget.type) {
      case NovaLoaderType.circular:
        return SizedBox(
          width: widget.size,
          height: widget.size,
          child: CircularProgressIndicator(
            strokeWidth: widget.strokeWidth,
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        );

      case NovaLoaderType.linear:
        return SizedBox(
          width: widget.width ?? double.infinity,
          child: LinearProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(color),
            backgroundColor: color.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(99),
            minHeight: 4,
          ),
        );

      case NovaLoaderType.dots:
        return SizedBox(
          height: widget.size,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(3, (i) {
              // Each dot starts animation with a delay
              return AnimatedBuilder(
                animation: _controller,
                builder: (context, _) {
                  final delay = i * 0.2;
                  final animValue = ((_controller.value - delay) % 1.0)
                      .clamp(0.0, 1.0);
                  final opacity = Tween<double>(begin: 0.3, end: 1.0)
                      .transform(
                      animValue < 0.5 ? animValue * 2 : (1 - animValue) * 2)
                      .clamp(0.3, 1.0);
                  final scale = Tween<double>(begin: 0.6, end: 1.0)
                      .transform(
                      animValue < 0.5 ? animValue * 2 : (1 - animValue) * 2)
                      .clamp(0.6, 1.0);

                  return Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: widget.size * 0.15),
                    child: Transform.scale(
                      scale: scale,
                      child: Opacity(
                        opacity: opacity,
                        child: Container(
                          width: widget.size * 0.35,
                          height: widget.size * 0.35,
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        );
    }
  }
}