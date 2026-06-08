import 'package:flutter/material.dart';

/// A styled bottom sheet widget for Nova UI.
///
/// Provides a consistent, theme-aware bottom sheet with drag handle,
/// optional title/subtitle, and flexible content area.
/// Use the static [show] method for easy usage.
///
/// Example:
/// ```dart
/// // Simple bottom sheet
/// NovaBottomSheet.show(
///   context: context,
///   child: Text('Hello!'),
/// );
///
/// // With title
/// NovaBottomSheet.show(
///   context: context,
///   title: 'Options',
///   child: Column(...),
/// );
///
/// // Actions bottom sheet
/// NovaBottomSheet.showActions(
///   context: context,
///   title: 'Sort By',
///   actions: [
///     NovaSheetAction(label: 'Newest', icon: Icons.schedule, onTap: () {}),
///     NovaSheetAction(label: 'Oldest', icon: Icons.history, onTap: () {}),
///   ],
/// );
/// ```
class NovaBottomSheet {
  /// Shows a custom content bottom sheet.
  static Future<T?> show<T>({
    required BuildContext context,
    required Widget child,
    String? title,
    String? subtitle,
    bool isDismissible = true,
    bool showDragHandle = true,
    bool isScrollControlled = true,
    double? maxHeightFactor,
    EdgeInsetsGeometry? padding,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isDismissible: isDismissible,
      isScrollControlled: isScrollControlled,
      backgroundColor: Colors.transparent,
      builder: (_) => _NovaBottomSheetContent(
        title: title,
        subtitle: subtitle,
        showDragHandle: showDragHandle,
        maxHeightFactor: maxHeightFactor ?? 0.9,
        padding: padding,
        child: child,
      ),
    );
  }

  /// Shows an actions list bottom sheet.
  static Future<T?> showActions<T>({
    required BuildContext context,
    required List<NovaSheetAction> actions,
    String? title,
    String? subtitle,
    bool isDismissible = true,
    bool showDragHandle = true,
  }) {
    return show<T>(
      context: context,
      title: title,
      subtitle: subtitle,
      isDismissible: isDismissible,
      showDragHandle: showDragHandle,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: actions.map((action) {
          return _NovaSheetActionTile(action: action);
        }).toList(),
      ),
    );
  }
}

/// Internal bottom sheet content wrapper.
class _NovaBottomSheetContent extends StatelessWidget {
  const _NovaBottomSheetContent({
    required this.child,
    required this.maxHeightFactor,
    this.title,
    this.subtitle,
    this.showDragHandle = true,
    this.padding,
  });

  final Widget child;
  final String? title;
  final String? subtitle;
  final bool showDragHandle;
  final double maxHeightFactor;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    final hasHeader = title != null || subtitle != null;

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * maxHeightFactor,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: scheme.surface,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Drag handle
            if (showDragHandle)
              Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 12, bottom: 8),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: scheme.onSurface.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(99),
                  ),
                ),
              ),

            // Header
            if (hasHeader)
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (title != null)
                      Text(
                        title!,
                        style: TextStyle(
                          color: scheme.onSurface,
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        subtitle!,
                        style: TextStyle(
                          color: scheme.onSurfaceVariant,
                          fontSize: 13,
                        ),
                      ),
                    ],
                    const SizedBox(height: 16),
                    Divider(
                      color: scheme.onSurface.withValues(alpha: 0.08),
                      height: 1,
                    ),
                  ],
                ),
              ),

            // Content
            Flexible(
              child: SingleChildScrollView(
                padding: padding ??
                    EdgeInsets.fromLTRB(
                      20,
                      hasHeader ? 12 : 4,
                      20,
                      bottomPadding + 20,
                    ),
                child: child,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// An action item for [NovaBottomSheet.showActions].
///
/// Example:
/// ```dart
/// NovaSheetAction(
///   label: 'Share',
///   icon: Icons.share_rounded,
///   onTap: () => _share(),
/// )
///
/// // Destructive action
/// NovaSheetAction(
///   label: 'Delete',
///   icon: Icons.delete_outline_rounded,
///   isDestructive: true,
///   onTap: () => _delete(),
/// )
/// ```
class NovaSheetAction {
  /// Creates a [NovaSheetAction].
  const NovaSheetAction({
    required this.label,
    required this.onTap,
    this.icon,
    this.trailing,
    this.isDestructive = false,
    this.enabled = true,
  });

  /// Action label text.
  final String label;

  /// Called when the action is tapped.
  final VoidCallback onTap;

  /// Optional leading icon.
  final IconData? icon;

  /// Optional trailing widget (e.g. a checkmark or badge).
  final Widget? trailing;

  /// When true, label and icon are shown in red.
  final bool isDestructive;

  /// When false, action is non-interactive and dimmed.
  final bool enabled;
}

/// Internal action tile widget.
class _NovaSheetActionTile extends StatelessWidget {
  const _NovaSheetActionTile({required this.action});

  final NovaSheetAction action;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final color = action.isDestructive
        ? scheme.error
        : action.enabled
        ? scheme.onSurface
        : scheme.onSurface.withValues(alpha: 0.3);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: action.enabled
            ? () {
          Navigator.of(context).pop();
          action.onTap();
        }
            : null,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 4),
          child: Row(
            children: [
              if (action.icon != null) ...[
                Icon(action.icon, color: color, size: 22),
                const SizedBox(width: 16),
              ],
              Expanded(
                child: Text(
                  action.label,
                  style: TextStyle(
                    color: color,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              if (action.trailing != null) action.trailing!,
            ],
          ),
        ),
      ),
    );
  }
}