import 'package:flutter/material.dart';

/// Defines the visual style of a [NovaCheckbox].
enum NovaCheckboxShape {
  /// Rounded rectangle (default).
  rounded,

  /// Perfect circle.
  circle,

  /// Sharp corners.
  square,
}

/// A styled checkbox widget for Nova UI.
///
/// Supports rounded, circle, and square shapes with theme-aware
/// colors, label, sublabel, and indeterminate state.
///
/// Example:
/// ```dart
/// // Simple checkbox
/// NovaCheckbox(
///   value: _checked,
///   label: 'Accept terms',
///   onChanged: (v) => setState(() => _checked = v!),
/// )
///
/// // With sublabel
/// NovaCheckbox(
///   value: _checked,
///   label: 'Marketing emails',
///   sublabel: 'Receive updates about new features',
///   onChanged: (v) => setState(() => _checked = v!),
/// )
///
/// // Circle shape
/// NovaCheckbox(
///   value: _checked,
///   label: 'Remember me',
///   shape: NovaCheckboxShape.circle,
///   onChanged: (v) => setState(() => _checked = v!),
/// )
/// ```
class NovaCheckbox extends StatelessWidget {
  /// Creates a [NovaCheckbox] widget.
  const NovaCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    this.label,
    this.sublabel,
    this.shape = NovaCheckboxShape.rounded,
    this.activeColor,
    this.enabled = true,
    this.tristate = false,
  });

  /// Whether the checkbox is checked.
  final bool? value;

  /// Called when the checkbox value changes.
  final void Function(bool?) onChanged;

  /// Primary label shown beside the checkbox.
  final String? label;

  /// Secondary smaller text shown below [label].
  final String? sublabel;

  /// Shape of the checkbox. Defaults to rounded.
  final NovaCheckboxShape shape;

  /// Override check color. Defaults to theme primary.
  final Color? activeColor;

  /// When false, checkbox is non-interactive and visually dimmed.
  final bool enabled;

  /// When true, supports checked/unchecked/indeterminate states.
  final bool tristate;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final color = activeColor ?? scheme.primary;
    final hasLabel = label != null || sublabel != null;

    Widget checkbox = _NovaCheckboxBox(
      value: value,
      onChanged: enabled ? onChanged : null,
      color: color,
      shape: shape,
      tristate: tristate,
      enabled: enabled,
    );

    if (!hasLabel) return checkbox;

    return GestureDetector(
      onTap: enabled
          ? () {
        if (tristate) {
          if (value == null) {
            onChanged(false);
          } else if (value == false) {
            onChanged(true);
          } else {
            onChanged(null);
          }
        } else {
          onChanged(!(value ?? false));
        }
      }
          : null,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          checkbox,
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 2),
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
                        fontSize: 15,
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
                        fontSize: 13,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Internal custom checkbox box widget.
class _NovaCheckboxBox extends StatelessWidget {
  const _NovaCheckboxBox({
    required this.value,
    required this.color,
    required this.shape,
    required this.tristate,
    required this.enabled,
    this.onChanged,
  });

  final bool? value;
  final void Function(bool?)? onChanged;
  final Color color;
  final NovaCheckboxShape shape;
  final bool tristate;
  final bool enabled;

  BorderRadius get _borderRadius {
    switch (shape) {
      case NovaCheckboxShape.rounded:
        return BorderRadius.circular(6);
      case NovaCheckboxShape.circle:
        return BorderRadius.circular(999);
      case NovaCheckboxShape.square:
        return BorderRadius.circular(2);
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isChecked = value == true;
    final isIndeterminate = tristate && value == null;
    final resolvedColor = enabled ? color : color.withValues(alpha: 0.4);
    final borderColor = isChecked || isIndeterminate
        ? resolvedColor
        : scheme.outline.withValues(alpha: enabled ? 1 : 0.4);

    return GestureDetector(
      onTap: onChanged != null
          ? () {
        if (tristate) {
          if (value == null) {
            onChanged!(false);
          } else if (value == false) {
            onChanged!(true);
          } else {
            onChanged!(null);
          }
        } else {
          onChanged!(!(value ?? false));
        }
      }
          : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 22,
        height: 22,
        decoration: BoxDecoration(
          color: isChecked || isIndeterminate
              ? resolvedColor
              : Colors.transparent,
          borderRadius: _borderRadius,
          border: Border.all(color: borderColor, width: 2),
        ),
        child: isIndeterminate
            ? Icon(
          Icons.remove_rounded,
          size: 14,
          color: scheme.onPrimary,
        )
            : isChecked
            ? Icon(
          Icons.check_rounded,
          size: 14,
          color: scheme.onPrimary,
        )
            : null,
      ),
    );
  }
}

/// A group of [NovaCheckbox] widgets.
///
/// Example:
/// ```dart
/// NovaCheckboxGroup(
///   items: ['Flutter', 'Dart', 'Firebase'],
///   selectedItems: _selected,
///   onChanged: (items) => setState(() => _selected = items),
/// )
/// ```
class NovaCheckboxGroup extends StatelessWidget {
  /// Creates a [NovaCheckboxGroup] widget.
  const NovaCheckboxGroup({
    super.key,
    required this.items,
    required this.selectedItems,
    required this.onChanged,
    this.shape = NovaCheckboxShape.rounded,
    this.activeColor,
    this.spacing = 12,
  });

  /// List of item labels.
  final List<String> items;

  /// Currently selected item labels.
  final List<String> selectedItems;

  /// Called when selection changes.
  final void Function(List<String>) onChanged;

  /// Shape applied to all checkboxes.
  final NovaCheckboxShape shape;

  /// Color applied to all checkboxes.
  final Color? activeColor;

  /// Vertical spacing between items. Defaults to 12.
  final double spacing;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items.asMap().entries.map((entry) {
        final label = entry.value;
        final isSelected = selectedItems.contains(label);

        return Padding(
          padding: EdgeInsets.only(
            bottom: entry.key < items.length - 1 ? spacing : 0,
          ),
          child: NovaCheckbox(
            value: isSelected,
            label: label,
            shape: shape,
            activeColor: activeColor,
            onChanged: (_) {
              final updated = List<String>.from(selectedItems);
              isSelected ? updated.remove(label) : updated.add(label);
              onChanged(updated);
            },
          ),
        );
      }).toList(),
    );
  }
}