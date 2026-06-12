import 'package:flutter/material.dart';

/// Defines the source type of an avatar/icon image in [NovaAppBar].
enum NovaAppBarImageType {
  /// Load image from network URL.
  network,

  /// Load image from local asset path.
  asset,

  /// Render an [IconData] icon.
  icon,

  /// Render custom widget directly.
  widget,
}

/// A leading or trailing item for [NovaAppBar] — can be an avatar,
/// icon button, image, or custom widget.
///
/// Example:
/// ```dart
/// // Network avatar
/// NovaAppBarItem(
///   type: NovaAppBarImageType.network,
///   source: 'https://example.com/avatar.jpg',
///   onTap: () => _openProfile(),
/// )
///
/// // Asset image
/// NovaAppBarItem(
///   type: NovaAppBarImageType.asset,
///   source: 'assets/logo.png',
/// )
///
/// // Icon button
/// NovaAppBarItem(
///   type: NovaAppBarImageType.icon,
///   icon: Icons.notifications_outlined,
///   onTap: () => _openNotifications(),
///   badge: 3,
/// )
///
/// // Custom widget (e.g. SVG via flutter_svg)
/// NovaAppBarItem(
///   type: NovaAppBarImageType.widget,
///   child: SvgPicture.asset('assets/icon.svg'),
///   onTap: () {},
/// )
/// ```
class NovaAppBarItem {
  /// Creates a [NovaAppBarItem].
  const NovaAppBarItem({
    this.type = NovaAppBarImageType.icon,
    this.source,
    this.icon,
    this.child,
    this.onTap,
    this.size = 22,
    this.width,        // ← add karo
    this.height,       // ← add karo
    this.isCircle = true,
    this.badge,
    this.tooltip,
    this.fit = BoxFit.cover, // ← add karo
  }) : assert(
  (type == NovaAppBarImageType.network && source != null) ||
      (type == NovaAppBarImageType.asset && source != null) ||
      (type == NovaAppBarImageType.icon && icon != null) ||
      (type == NovaAppBarImageType.widget && child != null),
  'Provide source for network/asset, icon for icon type, '
      'or child for widget type.',
  );

  /// Source type — network, asset, icon, or widget.
  final NovaAppBarImageType type;

  /// URL or asset path. Required for network/asset types.
  final String? source;

  /// Icon data. Required for icon type.
  final IconData? icon;

  /// Custom widget. Required for widget type (e.g. SVG).
  final Widget? child;

  /// Called when this item is tapped.
  final VoidCallback? onTap;

  /// Default size (square) for icons and images. Ignored if
  /// [width]/[height] are provided.
  final double size;

  /// Custom width — overrides [size]. Use for non-square images/logos.
  final double? width;

  /// Custom height — overrides [size]. Use for non-square images/logos.
  final double? height;

  /// When true (default), network/asset images are clipped to a circle.
  /// Set to false for rectangular/logo images.
  final bool isCircle;

  /// Optional notification badge count.
  final int? badge;

  /// Tooltip shown on long press.
  final String? tooltip;

  /// How the image should fit its bounds. Defaults to [BoxFit.cover].
  final BoxFit fit;

  /// Resolved width — uses [width] if set, else [size].
  double get resolvedWidth => width ?? size;

  /// Resolved height — uses [height] if set, else [size].
  double get resolvedHeight => height ?? size;
}
/// A flexible, theme-aware app bar for Nova UI.
///
/// Supports a title, leading/trailing avatars or icons from network,
/// asset, [IconData], or custom widgets (e.g. SVG) — with optional
/// badges, tap handlers, and tooltips.
///
/// Example:
/// ```dart
/// // Simple
/// NovaAppBar(title: 'Home')
///
/// // With profile avatar + actions
/// NovaAppBar(
///   title: 'Dashboard',
///   leading: NovaAppBarItem(
///     type: NovaAppBarImageType.network,
///     source: 'https://i.pravatar.cc/150',
///     onTap: () => _openProfile(),
///   ),
///   actions: [
///     NovaAppBarItem(
///       type: NovaAppBarImageType.icon,
///       icon: Icons.notifications_outlined,
///       badge: 3,
///       onTap: () {},
///     ),
///     NovaAppBarItem(
///       type: NovaAppBarImageType.icon,
///       icon: Icons.settings_outlined,
///       onTap: () {},
///     ),
///   ],
/// )
/// ```
class NovaAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// Creates a [NovaAppBar] widget.
  const NovaAppBar({
    super.key,
    this.title,
    this.titleWidget,
    this.subtitle,
    this.leading,
    this.actions,
    this.showBackButton = false,
    this.onBackPressed,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation = 0,
    this.centerTitle = false,
    this.bottom,
  });

  /// App bar title text.
  final String? title;

  /// Custom title widget — overrides [title].
  final Widget? titleWidget;

  /// Optional subtitle shown below the title.
  final String? subtitle;

  /// Leading item — typically a user avatar or logo.
  final NovaAppBarItem? leading;

  /// Trailing action items — icons, avatars, etc.
  final List<NovaAppBarItem>? actions;

  /// When true, shows a back arrow before [leading].
  final bool showBackButton;

  /// Called when back button is tapped. Defaults to [Navigator.pop].
  final VoidCallback? onBackPressed;

  /// Background color. Defaults to theme surface.
  final Color? backgroundColor;

  /// Foreground color for title/icons. Defaults to theme onSurface.
  final Color? foregroundColor;

  /// Shadow elevation. Defaults to 0 (flat).
  final double elevation;

  /// Whether to center the title.
  final bool centerTitle;

  /// Optional bottom widget (e.g. a [NovaTabBar] or [NovaSearchBar]).
  final PreferredSizeWidget? bottom;



  @override
  Size get preferredSize => Size.fromHeight(
    kToolbarHeight + (subtitle != null ? 12 : 0) + (bottom?.preferredSize.height ?? 0),
  );

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final fg = foregroundColor ?? scheme.onSurface;
    final bg = backgroundColor ?? scheme.surface;

    return AppBar(
      backgroundColor: bg,
      foregroundColor: fg,
      elevation: elevation,
      centerTitle: centerTitle,
      scrolledUnderElevation: elevation == 0 ? 0 : null,
      automaticallyImplyLeading: false,
      bottom: bottom,

      // Leading — back button + custom leading item
      leading: (showBackButton || leading != null)
          ? _buildLeading(context, fg)
          : null,
      leadingWidth: _leadingWidth(),

      // Title
      title: titleWidget ?? _buildTitle(fg, scheme),

      // Actions
      actions: actions != null
          ? [
        ...actions!.map((item) => _buildActionItem(context, item, fg)),
        const SizedBox(width: 4),
      ]
          : null,
    );
  }

  double? _leadingWidth() {
    if (leading == null) return null;

    final diameter = leading!.resolvedWidth < leading!.resolvedHeight
        ? leading!.resolvedWidth
        : leading!.resolvedHeight;

    return diameter + 20; // image size + padding
  }

  Widget _buildLeading(BuildContext context, Color fg) {
    if (showBackButton && leading != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back_ios_new_rounded, size: 18, color: fg),
            onPressed: onBackPressed ?? () => Navigator.of(context).maybePop(),
          ),
          _buildItem(context, leading!, fg),
          const SizedBox(width: 8),
        ],
      );
    }

    if (showBackButton) {
      return IconButton(
        icon: Icon(Icons.arrow_back_ios_new_rounded, size: 18, color: fg),
        onPressed: onBackPressed ?? () => Navigator.of(context).maybePop(),
      );
    }

    // Just leading item with left padding
    return Padding(
      padding: const EdgeInsets.only(left: 16),
      child: _buildItem(context, leading!, fg),
    );
  }

  Widget _buildTitle(Color fg, ColorScheme scheme) {
    if (title == null) return const SizedBox.shrink();

    if (subtitle == null) {
      return Text(
        title!,
        style: TextStyle(
          color: fg,
          fontSize: 17,
          fontWeight: FontWeight.w700,
        ),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title!,
          style: TextStyle(
            color: fg,
            fontSize: 17,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          subtitle!,
          style: TextStyle(
            color: scheme.onSurfaceVariant,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildActionItem(BuildContext context, NovaAppBarItem item, Color fg) {
    return Padding(
      padding: const EdgeInsets.only(right: 4),
      child: _buildItem(context, item, fg),
    );
  }

  Widget _buildItem(BuildContext context, NovaAppBarItem item, Color fg) {
    final scheme = Theme.of(context).colorScheme;
    Widget content;

    switch (item.type) {
      case NovaAppBarImageType.network:
        if (item.isCircle) {
          final diameter = item.resolvedWidth < item.resolvedHeight
              ? item.resolvedWidth
              : item.resolvedHeight;

          content = Container(
            width: diameter,
            height: diameter,
            decoration: const BoxDecoration(shape: BoxShape.circle),
            clipBehavior: Clip.antiAlias,
            child: Image.network(
              item.source!,
              width: diameter,
              height: diameter,
              fit: item.fit,
              errorBuilder: (_, __, ___) => _fallbackAvatar(item, scheme),
              loadingBuilder: (_, child, progress) {
                if (progress == null) return child;
                return Container(
                  width: diameter,
                  height: diameter,
                  color: scheme.surfaceContainerHighest,
                );
              },
            ),
          );
        } else {
          content = ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(
              width: item.resolvedWidth,
              height: item.resolvedHeight,
              child: Image.network(
                item.source!,
                fit: item.fit,
                errorBuilder: (_, __, ___) => _fallbackAvatar(item, scheme),
              ),
            ),
          );
        }
        break;

      case NovaAppBarImageType.asset:
        if (item.isCircle) {
          final diameter = item.resolvedWidth < item.resolvedHeight
              ? item.resolvedWidth
              : item.resolvedHeight;

          content = ClipOval(
            child: SizedBox(
              width: diameter,
              height: diameter,
              child: Image.asset(
                item.source!,
                fit: item.fit,
                errorBuilder: (_, __, ___) => _fallbackAvatar(item, scheme),
              ),
            ),
          );
        } else {
          content = ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(
              width: item.resolvedWidth,
              height: item.resolvedHeight,
              child: Image.asset(
                item.source!,
                fit: item.fit,
                errorBuilder: (_, __, ___) => _fallbackAvatar(item, scheme),
              ),
            ),
          );
        }
        break;

      case NovaAppBarImageType.icon:
        content = Icon(item.icon, size: item.size, color: fg);
        break;

      case NovaAppBarImageType.widget:
        content = SizedBox(
          width: item.resolvedWidth,
          height: item.resolvedHeight,
          child: item.child,
        );
        break;
    }

    Widget wrapped = content;

    // Badge overlay
    if (item.badge != null && item.badge! > 0) {
      wrapped = Stack(
        clipBehavior: Clip.none,
        children: [
          content,
          Positioned(
            top: -2,
            right: -4,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
              constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
              decoration: BoxDecoration(
                color: scheme.error,
                borderRadius: BorderRadius.circular(99),
                border: Border.all(color: scheme.surface, width: 1.5),
              ),
              child: Center(
                child: Text(
                  item.badge! > 99 ? '99+' : '${item.badge}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    }

    if (item.onTap == null) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: wrapped,
      );
    }

    final button = InkWell(
      onTap: item.onTap,
      borderRadius: BorderRadius.circular(item.isCircle ? 999 : 8),
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: wrapped,
      ),
    );

    if (item.tooltip != null) {
      return Tooltip(message: item.tooltip!, child: button);
    }

    return button;
  }

  /// Fallback avatar with person icon when image fails to load.
  Widget _fallbackAvatar(NovaAppBarItem item, ColorScheme scheme) {
    final diameter = item.isCircle
        ? (item.resolvedWidth < item.resolvedHeight
        ? item.resolvedWidth
        : item.resolvedHeight)
        : null;

    return Container(
      width: diameter ?? item.resolvedWidth,
      height: diameter ?? item.resolvedHeight,
      decoration: BoxDecoration(
        color: scheme.primary.withValues(alpha: 0.15),
        shape: item.isCircle ? BoxShape.circle : BoxShape.rectangle,
        borderRadius: item.isCircle ? null : BorderRadius.circular(8),
      ),
      child: Icon(
        Icons.person_rounded,
        size: (diameter ?? item.resolvedWidth) * 0.6,
        color: scheme.primary,
      ),
    );
  }
}