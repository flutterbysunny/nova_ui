import 'package:flutter/material.dart';

/// A consistent, theme-aware list item widget for Nova UI.
///
/// Wraps a leading widget (avatar/icon), title, subtitle, and trailing
/// widget with consistent spacing, tap ripple, and divider support.
///
/// Example:
/// ```dart
/// // Simple
/// NovaListTile(
///   title: 'John Doe',
///   subtitle: 'Software Engineer',
///   leading: NovaAvatar(name: 'John Doe'),
///   onTap: () {},
/// )
///
/// // With trailing chevron
/// NovaListTile(
///   title: 'Settings',
///   leadingIcon: Icons.settings_outlined,
///   showChevron: true,
///   onTap: () {},
/// )
///
/// // With trailing widget + divider
/// NovaListTile(
///   title: 'Notifications',
///   subtitle: 'Push notifications enabled',
///   leadingIcon: Icons.notifications_outlined,
///   trailing: NovaSwitch(value: true, onChanged: (v) {}),
///   showDivider: true,
/// )
/// ```
class NovaListTile extends StatelessWidget {
  /// Creates a [NovaListTile] widget.
  const NovaListTile({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.leadingIcon,
    this.trailing,
    this.showChevron = false,
    this.onTap,
    this.onLongPress,
    this.enabled = true,
    this.showDivider = false,
    this.dense = false,
    this.titleColor,
    this.subtitleColor,
    this.padding,
  });

  /// Primary title text.
  final String title;

  /// Secondary subtitle text shown below title.
  final String? subtitle;

  /// Leading widget — typically [NovaAvatar] or an icon container.
  /// Takes priority over [leadingIcon] if both provided.
  final Widget? leading;

  /// Simple leading icon — shown in a rounded container.
  /// Ignored if [leading] is provided.
  final IconData? leadingIcon;

  /// Trailing widget — e.g. [NovaSwitch], [NovaBadge], or text.
  final Widget? trailing;

  /// When true and [trailing] is null, shows a chevron arrow.
  final bool showChevron;

  /// Called when the tile is tapped.
  final VoidCallback? onTap;

  /// Called when the tile is long pressed.
  final VoidCallback? onLongPress;

  /// When false, tile is non-interactive and visually dimmed.
  final bool enabled;

  /// When true, shows a divider below the tile.
  final bool showDivider;

  /// When true, uses reduced vertical padding.
  final bool dense;

  /// Override title text color.
  final Color? titleColor;

  /// Override subtitle text color.
  final Color? subtitleColor;

  /// Override content padding.
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isInteractive = (onTap != null || onLongPress != null) && enabled;

    final resolvedTitleColor = titleColor ??
        (enabled ? scheme.onSurface : scheme.onSurface.withValues(alpha: 0.4));
    final resolvedSubtitleColor = subtitleColor ??
        (enabled
            ? scheme.onSurfaceVariant
            : scheme.onSurfaceVariant.withValues(alpha: 0.4));

    Widget? resolvedLeading = leading;
    if (resolvedLeading == null && leadingIcon != null) {
      resolvedLeading = Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: scheme.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          leadingIcon,
          size: 20,
          color: enabled ? scheme.primary : scheme.primary.withValues(alpha: 0.4),
        ),
      );
    }

    Widget? resolvedTrailing = trailing;
    if (resolvedTrailing == null && showChevron) {
      resolvedTrailing = Icon(
        Icons.chevron_right_rounded,
        size: 20,
        color: scheme.onSurfaceVariant.withValues(alpha: enabled ? 1 : 0.4),
      );
    }

    final content = Padding(
      padding: padding ??
          EdgeInsets.symmetric(
            horizontal: 16,
            vertical: dense ? 8 : 12,
          ),
      child: Row(
        children: [
          if (resolvedLeading != null) ...[
            resolvedLeading,
            const SizedBox(width: 14),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: resolvedTitleColor,
                    fontSize: dense ? 14 : 15,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtitle!,
                    style: TextStyle(
                      color: resolvedSubtitleColor,
                      fontSize: dense ? 12 : 13,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
          if (resolvedTrailing != null) ...[
            const SizedBox(width: 12),
            resolvedTrailing,
          ],
        ],
      ),
    );

    Widget tile = content;

    if (isInteractive) {
      tile = Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          onLongPress: onLongPress,
          child: content,
        ),
      );
    }

    if (!showDivider) return tile;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        tile,
        Divider(
          height: 1,
          color: scheme.onSurface.withValues(alpha: 0.08),
          indent: resolvedLeading != null ? 70 : 16,
        ),
      ],
    );
  }
}

/// A group of [NovaListTile]s wrapped in a [NovaCard]-like container
/// with consistent dividers between items.
///
/// Example:
/// ```dart
/// NovaListGroup(
///   title: 'Account',
///   children: [
///     NovaListTile(title: 'Edit Profile', showChevron: true, onTap: () {}),
///     NovaListTile(title: 'Privacy', showChevron: true, onTap: () {}),
///     NovaListTile(title: 'Security', showChevron: true, onTap: () {}),
///   ],
/// )
/// ```
class NovaListGroup extends StatelessWidget {
  /// Creates a [NovaListGroup] widget.
  const NovaListGroup({
    super.key,
    required this.children,
    this.title,
    this.borderRadius,
  });

  /// Optional section title shown above the group.
  final String? title;

  /// List of [NovaListTile] widgets.
  final List<Widget> children;

  /// Border radius of the group container. Defaults to 16px.
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (title != null) ...[
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 8),
            child: Text(
              title!.toUpperCase(),
              style: TextStyle(
                color: scheme.onSurfaceVariant,
                fontSize: 11,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.6,
              ),
            ),
          ),
        ],
        Container(
          decoration: BoxDecoration(
            color: scheme.surface,
            borderRadius: borderRadius ?? BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: children,
          ),
        ),
      ],
    );
  }
}