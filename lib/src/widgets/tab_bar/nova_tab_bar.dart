import 'package:flutter/material.dart';

/// Defines the visual style of a [NovaTabBar].
enum NovaTabBarStyle {
  /// Pill-shaped selected indicator (default).
  pill,

  /// Underline indicator below selected tab.
  underline,

  /// Solid filled background for selected tab.
  filled,
}

/// A single tab item for [NovaTabBar].
///
/// Example:
/// ```dart
/// NovaTabItem(label: 'Home')
/// NovaTabItem(label: 'Profile', icon: Icons.person_rounded)
/// ```
class NovaTabItem {
  /// Creates a [NovaTabItem].
  const NovaTabItem({
    required this.label,
    this.icon,
    this.badge,
  });

  /// Tab label text.
  final String label;

  /// Optional leading icon.
  final IconData? icon;

  /// Optional badge count shown on tab.
  final int? badge;
}

/// A fully custom styled tab bar for Nova UI.
///
/// Supports pill, underline, and filled styles with
/// smooth animated indicator, icons, and badge support.
/// Does NOT require a [TabController] — manages state internally
/// or can be controlled externally.
///
/// Example:
/// ```dart
/// // Simple tab bar
/// NovaTabBar(
///   tabs: [
///     NovaTabItem(label: 'Home'),
///     NovaTabItem(label: 'Profile'),
///     NovaTabItem(label: 'Settings'),
///   ],
///   onChanged: (i) => setState(() => _tab = i),
/// )
///
/// // With icons
/// NovaTabBar(
///   tabs: [
///     NovaTabItem(label: 'Feed', icon: Icons.home_rounded),
///     NovaTabItem(label: 'Search', icon: Icons.search_rounded),
///     NovaTabItem(label: 'Profile', icon: Icons.person_rounded),
///   ],
///   style: NovaTabBarStyle.filled,
///   onChanged: (i) => setState(() => _tab = i),
/// )
/// ```
class NovaTabBar extends StatefulWidget {
  /// Creates a [NovaTabBar] widget.
  const NovaTabBar({
    super.key,
    required this.tabs,
    required this.onChanged,
    this.selectedIndex = 0,
    this.style = NovaTabBarStyle.pill,
    this.activeColor,
    this.inactiveColor,
    this.activeTextColor,
    this.backgroundColor,
    this.height = 44,
    this.padding,
    this.isScrollable = false,
  });

  /// List of tab items.
  final List<NovaTabItem> tabs;

  /// Called when selected tab changes.
  final void Function(int) onChanged;

  /// Initially selected tab index.
  final int selectedIndex;

  /// Visual style — pill, underline, filled.
  final NovaTabBarStyle style;

  /// Color for active/selected tab background.
  final Color? activeColor;

  /// Color for inactive tabs.
  final Color? inactiveColor;

  /// Color for text/icon of selected tab.
  /// Defaults to white for pill, activeColor for others.
  final Color? activeTextColor;

  /// Background color of the tab bar container.
  final Color? backgroundColor;

  /// Height of the tab bar. Defaults to 44px.
  final double height;

  /// Padding around the tab bar.
  final EdgeInsetsGeometry? padding;

  /// When true, tabs scroll horizontally.
  final bool isScrollable;

  @override
  State<NovaTabBar> createState() => _NovaTabBarState();
}

class _NovaTabBarState extends State<NovaTabBar>
    with SingleTickerProviderStateMixin {
  late int _selectedIndex;
  late AnimationController _controller;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.selectedIndex;
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    _controller.forward();
  }

  @override
  void didUpdateWidget(NovaTabBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedIndex != widget.selectedIndex) {
      setState(() => _selectedIndex = widget.selectedIndex);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTabTap(int index) {
    if (index == _selectedIndex) return;
    setState(() => _selectedIndex = index);
    _controller
      ..reset()
      ..forward();
    widget.onChanged(index);
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final active = widget.activeColor ?? scheme.primary;
    final inactive = widget.inactiveColor ??
        scheme.onSurface.withValues(alpha: 0.5);

    // Pill = white default, underline/filled = activeColor default
    final activeText = widget.activeTextColor ??
        (widget.style == NovaTabBarStyle.pill ? Colors.white : active);

    switch (widget.style) {
      case NovaTabBarStyle.pill:
        return _buildPill(scheme, active, inactive, activeText);
      case NovaTabBarStyle.underline:
        return _buildUnderline(scheme, active, inactive, activeText);
      case NovaTabBarStyle.filled:
        return _buildFilled(scheme, active, inactive, activeText);
    }
  }

  // ── Pill style ────────────────────────────────────────────────────

  Widget _buildPill(
      ColorScheme scheme,
      Color active,
      Color inactive,
      Color activeText,
      ) {
    final bg = widget.backgroundColor ??
        scheme.onSurface.withValues(alpha: 0.06);

    return Container(
      height: widget.height,
      padding: widget.padding ?? const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
      ),
      child: widget.isScrollable
          ? SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: _pillRow(scheme, active, inactive, activeText),
      )
          : _pillRow(scheme, active, inactive, activeText),
    );
  }

  Widget _pillRow(
      ColorScheme scheme,
      Color active,
      Color inactive,
      Color activeText,
      ) {
    return Row(
      mainAxisSize: widget.isScrollable ? MainAxisSize.min : MainAxisSize.max,
      children: widget.tabs.asMap().entries.map((entry) {
        final i = entry.key;
        final tab = entry.value;
        final isSelected = i == _selectedIndex;

        return Expanded(
          flex: widget.isScrollable ? 0 : 1,
          child: GestureDetector(
            onTap: () => _onTabTap(i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: widget.height - 8,
              padding: EdgeInsets.symmetric(
                horizontal: widget.isScrollable ? 20 : 8,
              ),
              decoration: BoxDecoration(
                color: isSelected ? active : Colors.transparent,
                borderRadius: BorderRadius.circular(999),
                boxShadow: isSelected
                    ? [
                  BoxShadow(
                    color: active.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
                    : null,
              ),
              child: Center(
                child: _tabContent(
                  tab,
                  isSelected,
                  // ✅ selected = activeText, unselected = inactive
                  isSelected ? activeText : inactive,
                  inactive,
                  scheme,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  // ── Underline style ───────────────────────────────────────────────

  Widget _buildUnderline(
      ColorScheme scheme,
      Color active,
      Color inactive,
      Color activeText,
      ) {
    final bg = widget.backgroundColor ?? Colors.transparent;

    return Container(
      height: widget.height,
      decoration: BoxDecoration(
        color: bg,
        border: Border(
          bottom: BorderSide(
            color: scheme.onSurface.withValues(alpha: 0.1),
          ),
        ),
      ),
      child: widget.isScrollable
          ? SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: _underlineRow(active, inactive, activeText, scheme),
      )
          : _underlineRow(active, inactive, activeText, scheme),
    );
  }

  Widget _underlineRow(
      Color active,
      Color inactive,
      Color activeText,
      ColorScheme scheme,
      ) {
    return Row(
      mainAxisSize: widget.isScrollable ? MainAxisSize.min : MainAxisSize.max,
      children: widget.tabs.asMap().entries.map((entry) {
        final i = entry.key;
        final tab = entry.value;
        final isSelected = i == _selectedIndex;

        return Expanded(
          flex: widget.isScrollable ? 0 : 1,
          child: GestureDetector(
            onTap: () => _onTabTap(i),
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                _tabContent(
                  tab,
                  isSelected,
                  isSelected ? activeText : inactive,
                  inactive,
                  scheme,
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  height: 2,
                  width: isSelected ? 24 : 0,
                  decoration: BoxDecoration(
                    color: active,
                    borderRadius: BorderRadius.circular(99),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  // ── Filled style ──────────────────────────────────────────────────

  Widget _buildFilled(
      ColorScheme scheme,
      Color active,
      Color inactive,
      Color activeText,
      ) {
    final bg = widget.backgroundColor ?? scheme.surfaceContainerHighest;

    return Container(
      height: widget.height,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: widget.isScrollable
          ? SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: _filledRow(active, inactive, activeText, scheme),
      )
          : _filledRow(active, inactive, activeText, scheme),
    );
  }

  Widget _filledRow(
      Color active,
      Color inactive,
      Color activeText,
      ColorScheme scheme,
      ) {
    return Row(
      mainAxisSize: widget.isScrollable ? MainAxisSize.min : MainAxisSize.max,
      children: widget.tabs.asMap().entries.map((entry) {
        final i = entry.key;
        final tab = entry.value;
        final isSelected = i == _selectedIndex;

        return Expanded(
          flex: widget.isScrollable ? 0 : 1,
          child: GestureDetector(
            onTap: () => _onTabTap(i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                color: isSelected ? scheme.surface : Colors.transparent,
                borderRadius: BorderRadius.circular(9),
                boxShadow: isSelected
                    ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ]
                    : null,
              ),
              child: _tabContent(
                tab,
                isSelected,
                isSelected ? activeText : inactive,
                inactive,
                scheme,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  // ── Shared tab content ────────────────────────────────────────────

  Widget _tabContent(
      NovaTabItem tab,
      bool isSelected,
      Color color,
      Color inactive,
      ColorScheme scheme,
      ) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (tab.icon != null) ...[
                  Icon(tab.icon, size: 16, color: color),
                  const SizedBox(width: 6),
                ],
                Text(
                  tab.label,
                  style: TextStyle(
                    color: color,
                    fontSize: 13,
                    fontWeight:
                    isSelected ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ),

        // Badge
        if (tab.badge != null && tab.badge! > 0)
          Positioned(
            top: 4,
            right: 0,
            child: Container(
              padding:
              const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
              decoration: BoxDecoration(
                color: scheme.error,
                borderRadius: BorderRadius.circular(99),
              ),
              child: Text(
                tab.badge! > 99 ? '99+' : '${tab.badge}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
      ],
    );
  }
}