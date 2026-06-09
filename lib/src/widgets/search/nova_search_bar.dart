import 'package:flutter/material.dart';

/// A styled search input widget for Nova UI.
///
/// Provides a consistent search bar with clear button, loading state,
/// debounce support, and theme-aware styling.
///
/// Example:
/// ```dart
/// // Simple search bar
/// NovaSearchBar(
///   onChanged: (query) => _search(query),
/// )
///
/// // With controller
/// NovaSearchBar(
///   controller: _searchController,
///   hintText: 'Search users...',
///   onChanged: (query) => _search(query),
///   onSubmitted: (query) => _submitSearch(query),
/// )
///
/// // With loading state
/// NovaSearchBar(
///   isLoading: _isSearching,
///   onChanged: (query) => _search(query),
/// )
/// ```
class NovaSearchBar extends StatefulWidget {
  /// Creates a [NovaSearchBar] widget.
  const NovaSearchBar({
    super.key,
    this.controller,
    this.hintText = 'Search...',
    this.onChanged,
    this.onSubmitted,
    this.onClear,
    this.isLoading = false,
    this.autofocus = false,
    this.enabled = true,
    this.borderRadius,
    this.backgroundColor,
    this.debounce,
    this.textInputAction = TextInputAction.search,
  });

  /// Controller to read or set the search field value.
  final TextEditingController? controller;

  /// Placeholder text. Defaults to 'Search...'.
  final String hintText;

  /// Called on every keystroke. Use [debounce] to throttle calls.
  final void Function(String)? onChanged;

  /// Called when user submits via keyboard.
  final void Function(String)? onSubmitted;

  /// Called when the clear button is tapped.
  final VoidCallback? onClear;

  /// When true, shows a loading spinner instead of search icon.
  final bool isLoading;

  /// Whether the field gets focus immediately.
  final bool autofocus;

  /// When false, field is non-interactive.
  final bool enabled;

  /// Border radius. Defaults to 12px.
  final BorderRadius? borderRadius;

  /// Override background color.
  final Color? backgroundColor;

  /// Debounce duration — delays [onChanged] calls.
  final Duration? debounce;

  /// Keyboard action button. Defaults to search.
  final TextInputAction textInputAction;

  @override
  State<NovaSearchBar> createState() => _NovaSearchBarState();
}

class _NovaSearchBarState extends State<NovaSearchBar> {
  late TextEditingController _controller;
  bool _hasText = false;
  // ignore: cancel_subscriptions
  dynamic _debounceTimer;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _hasText = _controller.text.isNotEmpty;
    _controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  void _onTextChanged() {
    final hasText = _controller.text.isNotEmpty;
    if (hasText != _hasText) {
      setState(() => _hasText = hasText);
    }

    if (widget.onChanged != null) {
      if (widget.debounce != null) {
        _debounceTimer?.cancel();
        Future.delayed(widget.debounce!, () {
          if (mounted) widget.onChanged!(_controller.text);
        });
      } else {
        widget.onChanged!(_controller.text);
      }
    }
  }

  void _onClear() {
    _controller.clear();
    setState(() => _hasText = false);
    widget.onClear?.call();
    widget.onChanged?.call('');
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final radius = widget.borderRadius ?? BorderRadius.circular(12);
    final bg = widget.backgroundColor ??
        scheme.surfaceContainerHighest.withValues(alpha: 0.4);

    return TextField(
      controller: _controller,
      autofocus: widget.autofocus,
      enabled: widget.enabled,
      textInputAction: widget.textInputAction,
      onSubmitted: widget.onSubmitted,
      style: TextStyle(
        color: widget.enabled
            ? scheme.onSurface
            : scheme.onSurface.withValues(alpha: 0.4),
        fontSize: 15,
      ),
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: TextStyle(
          color: scheme.onSurfaceVariant,
          fontSize: 15,
        ),
        filled: true,
        fillColor: bg,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),

        // Leading icon — search or loading
        prefixIcon: widget.isLoading
            ? Padding(
          padding: const EdgeInsets.all(12),
          child: SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: scheme.primary,
            ),
          ),
        )
            : Icon(
          Icons.search_rounded,
          color: scheme.onSurfaceVariant,
          size: 20,
        ),

        // Trailing clear button
        suffixIcon: _hasText
            ? IconButton(
          icon: Icon(
            Icons.close_rounded,
            color: scheme.onSurfaceVariant,
            size: 18,
          ),
          onPressed: _onClear,
        )
            : null,

        // Borders
        border: OutlineInputBorder(
          borderRadius: radius,
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: radius,
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: radius,
          borderSide: BorderSide(color: scheme.primary, width: 2),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: radius,
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}