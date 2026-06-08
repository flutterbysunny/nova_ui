import 'package:flutter/material.dart';

/// Defines the size of a [NovaAvatar].
enum NovaAvatarSize {
  /// 28px — for dense lists, comments.
  xs,

  /// 36px — for compact list tiles.
  sm,

  /// 48px — default, most common use case.
  md,

  /// 64px — for profile headers.
  lg,

  /// 88px — for full profile screens.
  xl,
}

/// A flexible avatar widget for Nova UI.
///
/// Displays a network image, asset image, icon, or initials —
/// with automatic fallback if image fails to load.
///
/// Example:
/// ```dart
/// // Network image
/// NovaAvatar(imageUrl: 'https://example.com/photo.jpg')
///
/// // Initials fallback
/// NovaAvatar(name: 'John Doe')
///
/// // Icon fallback
/// NovaAvatar(icon: Icons.person)
///
/// // With online indicator
/// NovaAvatar(
///   imageUrl: 'https://example.com/photo.jpg',
///   showOnlineIndicator: true,
/// )
///
/// // Tappable
/// NovaAvatar(
///   name: 'Jane',
///   onTap: () => Navigator.push(...),
/// )
/// ```
class NovaAvatar extends StatelessWidget {
  /// Creates a [NovaAvatar] widget.

  const NovaAvatar({
    super.key,
    this.imageUrl,
    this.assetPath,
    this.name,
    this.icon,
    this.size = NovaAvatarSize.md,
    this.customSize,
    this.backgroundColor,
    this.foregroundColor,
    this.borderColor,
    this.borderWidth = 0,
    this.showOnlineIndicator = false,
    this.isOnline = true,
    this.onTap,
  });

  /// Network image URL. Falls back to [name] initials or [icon] on error.
  final String? imageUrl;

  /// Asset image path. Falls back to [name] initials or [icon] on error.
  final String? assetPath;

  /// Name used to generate initials (e.g. 'John Doe' → 'JD').
  final String? name;

  /// Icon shown when no image or name is provided.
  final IconData? icon;

  /// Predefined size. Ignored if [customSize] is set.
  final NovaAvatarSize size;

  /// Custom diameter in pixels. Overrides [size].
  final double? customSize;

  /// Background color. Auto-generated from name if not provided.
  final Color? backgroundColor;

  /// Foreground color for initials/icon.
  final Color? foregroundColor;

  /// Optional border color around the avatar.
  final Color? borderColor;

  /// Border width. Defaults to 0 (no border).
  final double borderWidth;

  /// When true, shows a small colored dot indicating online status.
  final bool showOnlineIndicator;

  /// Whether the online indicator is green (true) or grey (false).
  final bool isOnline;

  /// Called when the avatar is tapped.
  final VoidCallback? onTap;

  // ── Helpers ───────────────────────────────────────────────────────

  double get _diameter => customSize ?? _sizeMap[size]!;

  static const Map<NovaAvatarSize, double> _sizeMap = {
    NovaAvatarSize.xs: 28,
    NovaAvatarSize.sm: 36,
    NovaAvatarSize.md: 48,
    NovaAvatarSize.lg: 64,
    NovaAvatarSize.xl: 88,
  };

  /// Extracts initials from name — 'John Doe' → 'JD', 'John' → 'J'.
  String _initials() {
    if (name == null || name!.trim().isEmpty) return '?';
    final parts = name!.trim().split(RegExp(r'\s+'));
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return (parts[0][0] + parts[parts.length - 1][0]).toUpperCase();
  }

  /// Generates a consistent color from the name string.
  Color _colorFromName() {
    if (name == null) return const Color(0xFF6366F1);
    final colors = [
      const Color(0xFF6366F1), // indigo
      const Color(0xFF8B5CF6), // violet
      const Color(0xFF06B6D4), // cyan
      const Color(0xFF22C55E), // green
      const Color(0xFFF59E0B), // amber
      const Color(0xFFEF4444), // red
      const Color(0xFFEC4899), // pink
      const Color(0xFF14B8A6), // teal
    ];
    final index = name!.codeUnits.fold(0, (a, b) => a + b) % colors.length;
    return colors[index];
  }

  @override
  Widget build(BuildContext context) {
    final diameter = _diameter;
    final fontSize = diameter * 0.35;
    final resolvedBg = backgroundColor ?? _colorFromName();
    final resolvedFg = foregroundColor ?? Colors.white;
    final indicatorSize = diameter * 0.28;

    Widget avatar = Container(
      width: diameter,
      height: diameter,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: resolvedBg,
        border: borderWidth > 0 && borderColor != null
            ? Border.all(color: borderColor!, width: borderWidth)
            : null,
      ),
      clipBehavior: Clip.antiAlias,
      child: _buildContent(resolvedFg, fontSize, diameter),
    );

    // Wrap with InkWell if tappable
    if (onTap != null) {
      avatar = GestureDetector(
        onTap: onTap,
        child: avatar,
      );
    }

    // Online indicator overlay
    if (!showOnlineIndicator) return avatar;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        avatar,
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            width: indicatorSize,
            height: indicatorSize,
            decoration: BoxDecoration(
              color: isOnline
                  ? const Color(0xFF22C55E)
                  : const Color(0xFF94A3B8),
              shape: BoxShape.circle,
              border: Border.all(
                color: Theme.of(context).colorScheme.surface,
                width: 2,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContent(Color fg, double fontSize, double diameter) {
    // Network image
    if (imageUrl != null) {
      return Image.network(
        imageUrl!,
        width: diameter,
        height: diameter,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _fallback(fg, fontSize),
        loadingBuilder: (_, child, progress) {
          if (progress == null) return child;
          return _shimmerPlaceholder();
        },
      );
    }

    // Asset image
    if (assetPath != null) {
      return Image.asset(
        assetPath!,
        width: diameter,
        height: diameter,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _fallback(fg, fontSize),
      );
    }

    return _fallback(fg, fontSize);
  }

  /// Initials or icon fallback.
  Widget _fallback(Color fg, double fontSize) {
    if (name != null && name!.trim().isNotEmpty) {
      return Center(
        child: Text(
          _initials(),
          style: TextStyle(
            color: fg,
            fontSize: fontSize,
            fontWeight: FontWeight.w700,
            height: 1,
          ),
        ),
      );
    }

    return Center(
      child: Icon(
        icon ?? Icons.person_rounded,
        color: fg,
        size: fontSize * 1.4,
      ),
    );
  }

  /// Shimmer-like grey placeholder while network image loads.
  Widget _shimmerPlaceholder() {
    return Container(color: const Color(0xFFE2E8F0));
  }
}