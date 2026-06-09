import 'package:flutter/material.dart';

/// Defines the size of a [NovaSwitch].
enum NovaSwitchSize {
  /// Small — 36x20px.
  sm,

  /// Medium — 48x26px (default).
  md,

  /// Large — 56x30px.
  lg,
}

/// A styled toggle switch widget for Nova UI.
///
/// Supports label, sublabel, sizes, and custom colors.
/// Fully theme-aware with smooth animation.
///
/// Example:
/// ```dart
/// // Simple switch
/// NovaSwitch(
///   value: _enabled,
///   onChanged: (v) => setState(() => _enabled = v),
/// )
///
/// // With label
/// NovaSwitch(
///   value: _notifications,
///   label: 'Push Notifications',
///   onChanged: (v) => setState(() => _notifications = v),
/// )
///
/// // With sublabel
/// NovaSwitch(
///   value: _darkMode,
///   label: 'Dark Mode',
///   sublabel: 'Switch between light and dark theme',
///   onChanged: (v) => setState(() => _darkMode = v),
/// )
/// ```
class NovaSwitch extends StatelessWidget {
  /// Creates a [NovaSwitch] widget.
  const NovaSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    this.label,
    this.sublabel,
    this.size = NovaSwitchSize.md,
    this.activeColor,
    this.enabled = true,
    this.labelPosition = NovaSwitchLabelPosition.right,
  });

  /// Whether the switch is on.
  final bool value;

  /// Called when the switch is toggled.
  final void Function(bool) onChanged;

  /// Primary label shown beside the switch.
  final String? label;

  /// Secondary smaller text shown below [label].
  final String? sublabel;

  /// Size of the switch. Defaults to [NovaSwitchSize.md].
  final NovaSwitchSize size;

  /// Override active/on color. Defaults to theme primary.
  final Color? activeColor;

  /// When false, switch is non-interactive and visually dimmed.
  final bool enabled;

  /// Position of the label — left or right of the switch.
  final NovaSwitchLabelPosition labelPosition;

  // ── Size resolution ───────────────────────────────────────────────

  double get _width {
    switch (size) {
      case NovaSwitchSize.sm:
        return 36;
      case NovaSwitchSize.md:
        return 48;
      case NovaSwitchSize.lg:
        return 56;
    }
  }

  double get _height {
    switch (size) {
      case NovaSwitchSize.sm:
        return 20;
      case NovaSwitchSize.md:
        return 26;
      case NovaSwitchSize.lg:
        return 30;
    }
  }

  double get _thumbSize {
    switch (size) {
      case NovaSwitchSize.sm:
        return 14;
      case NovaSwitchSize.md:
        return 20;
      case NovaSwitchSize.lg:
        return 24;
    }
  }

  double get _fontSize {
    switch (size) {
      case NovaSwitchSize.sm:
        return 13;
      case NovaSwitchSize.md:
        return 15;
      case NovaSwitchSize.lg:
        return 16;
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final color = activeColor ?? scheme.primary;
    final hasLabel = label != null || sublabel != null;

    final switchWidget = _NovaSwitchTrack(
      value: value,
      onChanged: enabled ? onChanged : null,
      width: _width,
      height: _height,
      thumbSize: _thumbSize,
      activeColor: enabled ? color : color.withValues(alpha: 0.4),
      inactiveColor: enabled
          ? scheme.onSurface.withValues(alpha: 0.2)
          : scheme.onSurface.withValues(alpha: 0.1),
    );

    if (!hasLabel) return switchWidget;

    final labelWidget = Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (label != null)
            Text(
              label!,
              style: TextStyle(
                color: enabled
                    ? scheme.onSurface
                    : scheme.onSurface.withValues(alpha: 0.4),
                fontSize: _fontSize,
                fontWeight: FontWeight.w500,
              ),
            ),
          if (sublabel != null) ...[
            const SizedBox(height: 2),
            Text(
              sublabel!,
              style: TextStyle(
                color: enabled
                    ? scheme.onSurfaceVariant
                    : scheme.onSurfaceVariant.withValues(alpha: 0.4),
                fontSize: _fontSize - 2,
              ),
            ),
          ],
        ],
      ),
    );

    return GestureDetector(
      onTap: enabled ? () => onChanged(!value) : null,
      child: Row(
        children: labelPosition == NovaSwitchLabelPosition.right
            ? [switchWidget, const SizedBox(width: 12), labelWidget]
            : [labelWidget, const SizedBox(width: 12), switchWidget],
      ),
    );
  }
}

/// Defines the position of the label relative to the switch.
enum NovaSwitchLabelPosition {
  /// Label on the right (default).
  right,

  /// Label on the left — switch on the right edge.
  left,
}

/// Internal animated switch track.
class _NovaSwitchTrack extends StatelessWidget {
  const _NovaSwitchTrack({
    required this.value,
    required this.width,
    required this.height,
    required this.thumbSize,
    required this.activeColor,
    required this.inactiveColor,
    this.onChanged,
  });

  final bool value;
  final void Function(bool)? onChanged;
  final double width;
  final double height;
  final double thumbSize;
  final Color activeColor;
  final Color inactiveColor;

  @override
  Widget build(BuildContext context) {
    final padding = (height - thumbSize) / 2;
    final travelDistance = width - thumbSize - padding * 2;

    return GestureDetector(
      onTap: onChanged != null ? () => onChanged!(!value) : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: value ? activeColor : inactiveColor,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Stack(
          children: [
            AnimatedPositioned(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              left: value ? padding + travelDistance : padding,
              top: padding,
              child: Container(
                width: thumbSize,
                height: thumbSize,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x33000000),
                      blurRadius: 4,
                      offset: Offset(0, 1),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}