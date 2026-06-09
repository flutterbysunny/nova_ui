import 'package:flutter/material.dart';

/// A single item in a [NovaDropdown].
///
/// Example:
/// ```dart
/// NovaDropdownItem(value: 'flutter', label: 'Flutter')
/// NovaDropdownItem(value: 'dart', label: 'Dart', icon: Icons.code)
/// ```
class NovaDropdownItem<T> {
  /// Creates a [NovaDropdownItem].
  const NovaDropdownItem({
    required this.value,
    required this.label,
    this.icon,
    this.enabled = true,
  });

  /// The value this item represents.
  final T value;

  /// Display label for this item.
  final String label;

  /// Optional leading icon.
  final IconData? icon;

  /// When false, item is shown but not selectable.
  final bool enabled;
}

/// A styled dropdown selector for Nova UI.
///
/// Wraps Flutter's [DropdownButtonFormField] with consistent
/// Nova design system styling, label, validation, and icon support.
///
/// Example:
/// ```dart
/// NovaDropdown<String>(
///   label: 'Country',
///   hintText: 'Select a country',
///   items: [
///     NovaDropdownItem(value: 'in', label: 'India'),
///     NovaDropdownItem(value: 'us', label: 'United States'),
///   ],
///   onChanged: (v) => setState(() => _country = v),
/// )
/// ```
class NovaDropdown<T> extends StatelessWidget {
  /// Creates a [NovaDropdown] widget.
  const NovaDropdown({
    super.key,
    required this.items,
    required this.onChanged,
    this.value,
    this.label,
    this.hintText,
    this.prefixIcon,
    this.validator,
    this.enabled = true,
    this.borderRadius,
  });

  /// List of selectable items.
  final List<NovaDropdownItem<T>> items;

  /// Called when the selected value changes.
  final void Function(T?) onChanged;

  /// Currently selected value.
  final T? value;

  /// Floating label shown above the dropdown.
  final String? label;

  /// Placeholder shown when no value is selected.
  final String? hintText;

  /// Optional leading icon inside the dropdown.
  final Widget? prefixIcon;

  /// Validation function used inside a [Form] widget.
  final String? Function(T?)? validator;

  /// When false, dropdown is non-interactive and visually dimmed.
  final bool enabled;

  /// Border radius. Defaults to 12px.
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final radius = borderRadius ?? BorderRadius.circular(12);

    final border = OutlineInputBorder(
      borderRadius: radius,
      borderSide: BorderSide(color: scheme.outline),
    );

    final focusedBorder = OutlineInputBorder(
      borderRadius: radius,
      borderSide: BorderSide(color: scheme.primary, width: 2),
    );

    final errorBorder = OutlineInputBorder(
      borderRadius: radius,
      borderSide: BorderSide(color: scheme.error),
    );

    final disabledBorder = OutlineInputBorder(
      borderRadius: radius,
      borderSide: BorderSide(
        color: scheme.outline.withValues(alpha: 0.3),
      ),
    );

    return DropdownButtonFormField<T>(
      value: value,
      onChanged: enabled ? onChanged : null,
      validator: validator,
      borderRadius: radius,
      dropdownColor: scheme.surface,
      icon: Icon(
        Icons.keyboard_arrow_down_rounded,
        color: enabled ? scheme.onSurfaceVariant : scheme.onSurface.withValues(alpha: 0.3),
      ),
      style: TextStyle(
        color: enabled
            ? scheme.onSurface
            : scheme.onSurface.withValues(alpha: 0.4),
        fontSize: 15,
      ),
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        hintStyle: TextStyle(color: scheme.onSurfaceVariant),
        prefixIcon: prefixIcon,
        filled: true,
        fillColor: enabled
            ? scheme.surfaceContainerHighest.withValues(alpha: 0.3)
            : scheme.onSurface.withValues(alpha: 0.05),
        enabledBorder: border,
        focusedBorder: focusedBorder,
        errorBorder: errorBorder,
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: radius,
          borderSide: BorderSide(color: scheme.error, width: 2),
        ),
        disabledBorder: disabledBorder,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
      items: items.map((item) {
        return DropdownMenuItem<T>(
          value: item.value,
          enabled: item.enabled,
          child: Row(
            children: [
              if (item.icon != null) ...[
                Icon(
                  item.icon,
                  size: 18,
                  color: item.enabled
                      ? scheme.onSurface
                      : scheme.onSurface.withValues(alpha: 0.3),
                ),
                const SizedBox(width: 10),
              ],
              Text(
                item.label,
                style: TextStyle(
                  color: item.enabled
                      ? scheme.onSurface
                      : scheme.onSurface.withValues(alpha: 0.3),
                  fontSize: 15,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}