import 'package:flutter/material.dart';

/// A styled text input widget for Nova UI.
///
/// Wraps Flutter's [TextFormField] with consistent Nova design system styling.
/// Supports validation, labels, icons, password toggle, and multiline input.
///
/// Example:
/// ```dart
/// NovaTextField(
///   label: 'Email',
///   hintText: 'you@example.com',
///   prefixIcon: Icon(Icons.email),
///   keyboardType: TextInputType.emailAddress,
///   validator: (v) => v!.isEmpty ? 'Required' : null,
/// )
/// ```
class NovaTextField extends StatefulWidget {
  const NovaTextField({
    super.key,
    this.controller,
    this.label,
    this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.textInputAction,
    this.validator,
    this.onChanged,
    this.onFieldSubmitted,
    this.focusNode,
    this.maxLines = 1,
    this.enabled = true,
    this.autofocus = false,
  });

  /// Controller to read or set the field's value programmatically.
  final TextEditingController? controller;

  /// Floating label shown above the field when focused.
  final String? label;

  /// Placeholder text shown when the field is empty.
  final String? hintText;

  /// Widget shown at the start of the field (e.g. an icon).
  final Widget? prefixIcon;

  /// Widget shown at the end of the field.
  /// If [obscureText] is true and no suffixIcon is provided,
  /// a show/hide toggle is added automatically.
  final Widget? suffixIcon;

  /// If true, input is hidden (for passwords). Adds a visibility toggle.
  final bool obscureText;

  final TextInputType keyboardType;

  /// Controls the keyboard's action button (e.g. next, done, search).
  final TextInputAction? textInputAction;

  /// Validation function used inside a [Form] widget.
  final String? Function(String?)? validator;

  /// Called on every keystroke.
  final void Function(String)? onChanged;

  /// Called when the user submits via the keyboard action button.
  final void Function(String)? onFieldSubmitted;

  final FocusNode? focusNode;

  /// Number of lines. Use > 1 for multiline/textarea style input.
  final int maxLines;

  /// When false, field is non-interactive and visually dimmed.
  final bool enabled;

  final bool autofocus;

  @override
  State<NovaTextField> createState() => _NovaTextFieldState();
}

class _NovaTextFieldState extends State<NovaTextField> {
  late bool _obscured;

  @override
  void initState() {
    super.initState();
    _obscured = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    // Auto password toggle only if caller hasn't provided their own suffixIcon
    final resolvedSuffixIcon = widget.obscureText && widget.suffixIcon == null
        ? IconButton(
      icon: Icon(
        _obscured ? Icons.visibility_off : Icons.visibility,
        color: colorScheme.onSurfaceVariant,
      ),
      onPressed: () => setState(() => _obscured = !_obscured),
    )
        : widget.suffixIcon;

    return TextFormField(
      controller: widget.controller,
      focusNode: widget.focusNode,
      obscureText: _obscured,
      keyboardType: widget.maxLines > 1 ? TextInputType.multiline : widget.keyboardType,
      textInputAction: widget.textInputAction,
      validator: widget.validator,
      onChanged: widget.onChanged,
      onFieldSubmitted: widget.onFieldSubmitted,
      maxLines: _obscured ? 1 : widget.maxLines,
      enabled: widget.enabled,
      autofocus: widget.autofocus,
      style: TextStyle(
        color: widget.enabled
            ? colorScheme.onSurface
            : colorScheme.onSurface.withOpacity(0.4),
      ),
      decoration: InputDecoration(
        labelText: widget.label,
        hintText: widget.hintText,
        prefixIcon: widget.prefixIcon,
        suffixIcon: resolvedSuffixIcon,

        // Border styles — all driven by theme
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: colorScheme.outline,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: colorScheme.primary,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: colorScheme.error,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: colorScheme.error,
            width: 2,
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: colorScheme.outline.withOpacity(0.3),
          ),
        ),

        filled: true,
        fillColor: widget.enabled
            ? colorScheme.surfaceContainerHighest.withOpacity(0.3)
            : colorScheme.onSurface.withOpacity(0.05),

        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
    );
  }
}