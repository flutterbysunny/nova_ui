import 'package:flutter/material.dart';
import '../../../nova_ui.dart';

/// Defines the visual style/intent of a [NovaDialog].
enum NovaDialogType {
  /// Default — no icon, neutral style.
  info,

  /// Green checkmark — for success confirmations.
  success,

  /// Amber warning icon — for caution prompts.
  warning,

  /// Red icon — for destructive/error actions.
  danger,
}

/// A styled dialog widget for Nova UI.
///
/// Supports info, success, warning, and danger variants.
/// Provides a simple static [show] method for easy usage.
///
/// Example:
/// ```dart
/// // Simple alert
/// NovaDialog.show(
///   context: context,
///   title: 'Done!',
///   message: 'Your data has been saved.',
///   type: NovaDialogType.success,
/// );
///
/// // Confirm dialog
/// NovaDialog.show(
///   context: context,
///   title: 'Delete Account?',
///   message: 'This action cannot be undone.',
///   type: NovaDialogType.danger,
///   confirmText: 'Delete',
///   cancelText: 'Cancel',
///   onConfirm: () => _deleteAccount(),
/// );
/// ```
class NovaDialog extends StatelessWidget {
  const NovaDialog({
    super.key,
    required this.title,
    required this.message,
    this.type = NovaDialogType.info,
    this.confirmText = 'OK',
    this.cancelText,
    this.onConfirm,
    this.onCancel,
    this.barrierDismissible = true,
  });

  /// Dialog heading text.
  final String title;

  /// Dialog body/description text.
  final String message;

  /// Visual intent — info, success, warning, danger.
  final NovaDialogType type;

  /// Confirm button label. Default 'OK'.
  final String confirmText;

  /// Cancel button label. If null, cancel button is not shown.
  final String? cancelText;

  /// Called when confirm button is tapped.
  final VoidCallback? onConfirm;

  /// Called when cancel button is tapped.
  final VoidCallback? onCancel;

  /// Whether tapping outside dismisses the dialog. Default true.
  final bool barrierDismissible;

  // ── Static helper ─────────────────────────────────────────────────

  /// Shows a [NovaDialog] without needing to build it manually.
  static Future<void> show({
    required BuildContext context,
    required String title,
    required String message,
    NovaDialogType type = NovaDialogType.info,
    String confirmText = 'OK',
    String? cancelText,
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
    bool barrierDismissible = true,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (_) => NovaDialog(
        title: title,
        message: message,
        type: type,
        confirmText: confirmText,
        cancelText: cancelText,
        onConfirm: onConfirm,
        onCancel: onCancel,
        barrierDismissible: barrierDismissible,
      ),
    );
  }

  // ── Helpers ───────────────────────────────────────────────────────

  _DialogStyle _resolveStyle(ColorScheme scheme) {
    switch (type) {
      case NovaDialogType.info:
        return _DialogStyle(
          icon: Icons.info_outline_rounded,
          color: scheme.primary,
          bgColor: scheme.primary.withValues(alpha: 0.1),
        );
      case NovaDialogType.success:
        return _DialogStyle(
          icon: Icons.check_circle_outline_rounded,
          color: const Color(0xFF22C55E),
          bgColor: const Color(0xFF22C55E).withValues(alpha: 0.1),
        );
      case NovaDialogType.warning:
        return _DialogStyle(
          icon: Icons.warning_amber_rounded,
          color: const Color(0xFFF59E0B),
          bgColor: const Color(0xFFF59E0B).withValues(alpha: 0.1),
        );
      case NovaDialogType.danger:
        return _DialogStyle(
          icon: Icons.delete_outline_rounded,
          color: scheme.error,
          bgColor: scheme.error.withValues(alpha: 0.1),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final style = _resolveStyle(scheme);

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      backgroundColor: scheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon badge
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: style.bgColor,
                shape: BoxShape.circle,
              ),
              child: Icon(
                style.icon,
                color: style.color,
                size: 32,
              ),
            ),

            const SizedBox(height: 16),

            // Title
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: scheme.onSurface,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(height: 8),

            // Message
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: scheme.onSurfaceVariant,
                fontSize: 14,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 24),

            // Buttons
            if (cancelText != null) ...[
              // Two buttons — stacked
              NovaButton(
                text: confirmText,
                backgroundColor: type == NovaDialogType.danger
                    ? scheme.error
                    : style.color,
                onPressed: () {
                  Navigator.of(context).pop();
                  onConfirm?.call();
                },
              ),
              const SizedBox(height: 10),
              NovaButton(
                text: cancelText!,
                variant: NovaButtonVariant.outlined,
                foregroundColor: scheme.onSurfaceVariant,
                onPressed: () {
                  Navigator.of(context).pop();
                  onCancel?.call();
                },
              ),
            ] else ...[
              // Single confirm button
              NovaButton(
                text: confirmText,
                backgroundColor: style.color,
                onPressed: () {
                  Navigator.of(context).pop();
                  onConfirm?.call();
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Internal style config for each [NovaDialogType].
class _DialogStyle {
  const _DialogStyle({
    required this.icon,
    required this.color,
    required this.bgColor,
  });

  final IconData icon;
  final Color color;
  final Color bgColor;
}