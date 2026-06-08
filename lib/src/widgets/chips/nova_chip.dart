import 'package:flutter/material.dart';

/// Defines the visual style of a [NovaChip].
enum NovaChipVariant {
  /// Solid filled background (default).
  filled,

  /// Transparent background with colored border.
  outlined,

  /// Soft tinted background — subtle style.
  soft,
}

/// Defines the semantic color of a [NovaChip].
enum NovaChipColor {
  /// Theme primary color.
  primary,

  /// Green — success/active states.
  success,

  /// Amber — warning/pending states.
  warning,

  /// Red — error/critical states.
  danger,

  /// Neutral grey — inactive/default states.
  neutral,
}

/// A flexible chip widget for Nova UI.
///
/// Use for filters, tags, categories, and selections.
/// Supports filled, outlined, and soft variants with semantic colors,
/// optional icons, delete button, and selectable state.
///
/// Example:
/// ```dart
/// // Simple tag
/// NovaChip(label: 'Flutter')
///
/// // Filter chip — selectable
/// NovaChip(
///   label: 'Design',
///   selected: _selected,
///   onTap: () => setState(() => _selected = !_selected),
/// )
///
/// // Deletable tag
/// NovaChip(
///   label: 'React',
///   onDeleted: () => _removTag('React'),
/// )
///
/// // With leading icon
/// NovaChip(
///   label: 'Verified',
///   icon: Icons.verified_rounded,
///   color: NovaChipColor.success,
/// )
/// ```
class NovaChip extends StatelessWidget {
  /// Creates a [NovaChip] widget.

  const NovaChip({
    super.key,
    required this.label,
    this.variant = NovaChipVariant.soft,
    this.color = NovaChipColor.primary,
    this.icon,
    this.avatar,
    this.onTap,
    this.onDeleted,
    this.selected = false,
    this.enabled = true,
    this.fontSize = 13,
  });

  /// Text label shown inside the chip.
  final String label;

  /// Visual style — filled, outlined, soft.
  final NovaChipVariant variant;

  /// Semantic color intent.
  final NovaChipColor color;

  /// Optional leading icon.
  final IconData? icon;

  /// Optional leading avatar widget — overrides [icon].
  final Widget? avatar;

  /// Called when chip is tapped.
  final VoidCallback? onTap;

  /// When provided, shows an × delete button on the right.
  final VoidCallback? onDeleted;

  /// When true, chip shows selected/active visual state.
  final bool selected;

  /// When false, chip is non-interactive and visually dimmed.
  final bool enabled;

  /// Font size for the label. Defaults to 13.
  final double fontSize;

  // ── Color resolution ──────────────────────────────────────────────

  Color _resolveBase(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    switch (color) {
      case NovaChipColor.primary:
        return scheme.primary;
      case NovaChipColor.success:
        return const Color(0xFF22C55E);
      case NovaChipColor.warning:
        return const Color(0xFFF59E0B);
      case NovaChipColor.danger:
        return scheme.error;
      case NovaChipColor.neutral:
        return scheme.onSurfaceVariant;
    }
  }

  @override
  Widget build(BuildContext context) {
    final base = _resolveBase(context);
    final isDisabled = !enabled;

    // Selected state overrides variant — always filled
    final effectiveVariant = selected ? NovaChipVariant.filled : variant;

    // Resolve colors
    final Color bgColor;
    final Color textColor;
    final Border? border;

    switch (effectiveVariant) {
      case NovaChipVariant.filled:
        bgColor = isDisabled ? base.withValues(alpha: 0.4) : base;
        textColor = Colors.white;
        border = null;
        break;
      case NovaChipVariant.outlined:
        bgColor = Colors.transparent;
        textColor = isDisabled ? base.withValues(alpha: 0.4) : base;
        border = Border.all(
          color: isDisabled ? base.withValues(alpha: 0.3) : base,
          width: 1.5,
        );
        break;
      case NovaChipVariant.soft:
        bgColor = isDisabled
            ? base.withValues(alpha: 0.05)
            : base.withValues(alpha: 0.12);
        textColor = isDisabled ? base.withValues(alpha: 0.4) : base;
        border = null;
        break;
    }

    Widget chipContent = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Avatar — overrides icon
        if (avatar != null) ...[
          SizedBox(
            width: 20,
            height: 20,
            child: ClipOval(child: avatar!),
          ),
          SizedBox(width: fontSize * 0.4),
        ]
        // Leading icon
        else if (icon != null) ...[
          Icon(icon, size: fontSize + 2, color: textColor),
          SizedBox(width: fontSize * 0.4),
        ],

        // Label
        Text(
          label,
          style: TextStyle(
            color: textColor,
            fontSize: fontSize,
            fontWeight: FontWeight.w500,
            height: 1.2,
          ),
        ),

        // Selected checkmark
        if (selected) ...[
          SizedBox(width: fontSize * 0.4),
          Icon(
            Icons.check_rounded,
            size: fontSize + 2,
            color: textColor,
          ),
        ],

        // Delete button
        if (onDeleted != null && !selected) ...[
          SizedBox(width: fontSize * 0.3),
          GestureDetector(
            onTap: isDisabled ? null : onDeleted,
            child: Icon(
              Icons.close_rounded,
              size: fontSize + 2,
              color: textColor.withValues(alpha: 0.7),
            ),
          ),
        ],
      ],
    );

    Widget chip = AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: EdgeInsets.symmetric(
        horizontal: fontSize * 0.92,
        vertical: fontSize * 0.46,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(999),
        border: border,
      ),
      child: chipContent,
    );

    if (onTap != null && !isDisabled) {
      chip = GestureDetector(
        onTap: onTap,
        child: chip,
      );
    }

    return chip;
  }
}

/// A group of [NovaChip] widgets with single or multi select support.
///
/// Example:
/// ```dart
/// // Single select
/// NovaChipGroup(
///   chips: ['Flutter', 'React', 'Vue'],
///   selectedIndex: _selected,
///   onChanged: (i) => setState(() => _selected = i),
/// )
///
/// // Multi select
/// NovaChipGroup.multi(
///   chips: ['Design', 'Code', 'Testing'],
///   selectedIndexes: _selected,
///   onChanged: (indexes) => setState(() => _selected = indexes),
/// )
/// ```
class NovaChipGroup extends StatelessWidget {
  /// Single select chip group.
  const NovaChipGroup({
    super.key,
    required this.chips,
    required this.onChanged,
    this.selectedIndex = 0,
    this.color = NovaChipColor.primary,
    this.spacing = 8,
    this.runSpacing = 8,
  })  : isMulti = false,
        selectedIndexes = const [],
        onMultiChanged = null;

  /// Multi select chip group.
  const NovaChipGroup.multi({
    super.key,
    required this.chips,
    required List<int> this.selectedIndexes,
    required void Function(List<int>) this.onMultiChanged,
    this.color = NovaChipColor.primary,
    this.spacing = 8,
    this.runSpacing = 8,
  })  : isMulti = true,
        selectedIndex = 0,
        onChanged = null;

  /// List of chip labels.
  final List<String> chips;

  /// Selected index for single select mode.
  final int selectedIndex;

  /// Selected indexes for multi select mode.
  final List<int> selectedIndexes;

  /// Called when selection changes in single select mode.
  final void Function(int)? onChanged;

  /// Called when selection changes in multi select mode.
  final void Function(List<int>)? onMultiChanged;

  /// Color applied to all chips.
  final NovaChipColor color;

  /// Horizontal spacing between chips.
  final double spacing;

  /// Vertical spacing between chip rows.
  final double runSpacing;

  /// Whether this is a multi select group.
  final bool isMulti;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: spacing,
      runSpacing: runSpacing,
      children: List.generate(chips.length, (i) {
        final isSelected =
            isMulti ? selectedIndexes.contains(i) : selectedIndex == i;

        return NovaChip(
          label: chips[i],
          selected: isSelected,
          color: color,
          onTap: () {
            if (isMulti && onMultiChanged != null) {
              final updated = List<int>.from(selectedIndexes);
              isSelected ? updated.remove(i) : updated.add(i);
              onMultiChanged!(updated);
            } else {
              onChanged?.call(i);
            }
          },
        );
      }),
    );
  }
}
