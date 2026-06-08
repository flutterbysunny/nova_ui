import 'package:flutter/material.dart';

/// Defines the visual intent of a [NovaToast].
enum NovaToastType {
  /// Neutral info — default.
  info,

  /// Green — success message.
  success,

  /// Amber — warning message.
  warning,

  /// Red — error message.
  error,
}

/// Defines the position of a [NovaToast] on screen.
enum NovaToastPosition {
  /// Top of the screen.
  top,

  /// Bottom of the screen (default).
  bottom,
}

/// A lightweight toast notification for Nova UI.
///
/// Shows a styled message overlay that auto-dismisses after [duration].
/// Use the static [show] method — no widget tree changes needed.
///
/// Example:
/// ```dart
/// // Simple toast
/// NovaToast.show(context: context, message: 'Saved!')
///
/// // Success
/// NovaToast.show(
///   context: context,
///   message: 'Profile updated successfully.',
///   type: NovaToastType.success,
/// )
///
/// // Error at top
/// NovaToast.show(
///   context: context,
///   message: 'Something went wrong.',
///   type: NovaToastType.error,
///   position: NovaToastPosition.top,
/// )
/// ```
class NovaToast {
  /// Shows a toast notification.
  static void show({
    required BuildContext context,
    required String message,
    NovaToastType type = NovaToastType.info,
    NovaToastPosition position = NovaToastPosition.bottom,
    Duration duration = const Duration(seconds: 3),
    IconData? icon,
  }) {
    final overlay = Overlay.of(context);
    late OverlayEntry entry;

    entry = OverlayEntry(
      builder: (_) => _NovaToastWidget(
        message: message,
        type: type,
        position: position,
        duration: duration,
        icon: icon,
        onDismiss: () => entry.remove(),
      ),
    );

    overlay.insert(entry);
  }
}

/// Internal animated toast widget.
class _NovaToastWidget extends StatefulWidget {
  const _NovaToastWidget({
    required this.message,
    required this.type,
    required this.position,
    required this.duration,
    required this.onDismiss,
    this.icon,
  });

  final String message;
  final NovaToastType type;
  final NovaToastPosition position;
  final Duration duration;
  final VoidCallback onDismiss;
  final IconData? icon;

  @override
  State<_NovaToastWidget> createState() => _NovaToastWidgetState();
}

class _NovaToastWidgetState extends State<_NovaToastWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacity;
  late Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _opacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _slide = Tween<Offset>(
      begin: widget.position == NovaToastPosition.top
          ? const Offset(0, -0.3)
          : const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    // Animate in
    _controller.forward();

    // Auto dismiss
    Future.delayed(widget.duration, () async {
      if (mounted) {
        await _controller.reverse();
        widget.onDismiss();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  _ToastStyle _resolveStyle() {
    switch (widget.type) {
      case NovaToastType.info:
        return _ToastStyle(
          bg: const Color(0xFF1E293B),
          text: Colors.white,
          icon: widget.icon ?? Icons.info_outline_rounded,
          iconColor: const Color(0xFF818CF8),
        );
      case NovaToastType.success:
        return _ToastStyle(
          bg: const Color(0xFF166534),
          text: Colors.white,
          icon: widget.icon ?? Icons.check_circle_outline_rounded,
          iconColor: const Color(0xFF86EFAC),
        );
      case NovaToastType.warning:
        return _ToastStyle(
          bg: const Color(0xFF854D0E),
          text: Colors.white,
          icon: widget.icon ?? Icons.warning_amber_rounded,
          iconColor: const Color(0xFFFDE68A),
        );
      case NovaToastType.error:
        return _ToastStyle(
          bg: const Color(0xFF991B1B),
          text: Colors.white,
          icon: widget.icon ?? Icons.error_outline_rounded,
          iconColor: const Color(0xFFFCA5A5),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final style = _resolveStyle();
    final isTop = widget.position == NovaToastPosition.top;

    return Positioned(
      top: isTop ? MediaQuery.of(context).padding.top + 16 : null,
      bottom: isTop ? null : MediaQuery.of(context).padding.bottom + 16,
      left: 16,
      right: 16,
      child: Material(
        color: Colors.transparent,
        child: SlideTransition(
          position: _slide,
          child: FadeTransition(
            opacity: _opacity,
            child: GestureDetector(
              onTap: () async {
                await _controller.reverse();
                widget.onDismiss();
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: style.bg,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Icon(style.icon, color: style.iconColor, size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        widget.message,
                        style: TextStyle(
                          color: style.text,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      Icons.close_rounded,
                      color: style.text.withValues(alpha: 0.5),
                      size: 16,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Internal style config for each [NovaToastType].
class _ToastStyle {
  const _ToastStyle({
    required this.bg,
    required this.text,
    required this.icon,
    required this.iconColor,
  });

  final Color bg;
  final Color text;
  final IconData icon;
  final Color iconColor;
}