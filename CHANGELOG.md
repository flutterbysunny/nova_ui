# Changelog

All notable changes to this project will be documented in this file.

## 1.0.4

### New Widgets
- `NovaToast` — animated overlay notifications with info/success/warning/error types, top/bottom position, auto-dismiss
- `NovaBottomSheet` — styled modal bottom sheet with drag handle, title, subtitle, and actions list support

## 1.0.3

### New Widgets
- `NovaShimmer` — animated skeleton loading placeholder with circle, rectangle, card, and list presets
- `NovaAvatar` — network/asset/initials/icon avatar with online indicator, border, and size variants
- `NovaChip` — filter/tag chips with filled/outlined/soft variants, icon, delete, and selected state
- `NovaChipGroup` — single and multi select chip group

## 1.0.2

### New Widgets
- `NovaLoader` — circular, linear, dots variants with theme-aware colors
- `NovaDialog` — info/success/warning/danger alert and confirm dialogs with static `show()` helper
- `NovaBadge` — status labels, notification counts, dot indicators, overlay badges with filled/outlined/soft variants


## 1.0.1

### New Widgets
- `NovaCard` — pre-styled card with elevation and tap support

### Improvements
- `NovaButton` — added `variant` (filled/outlined/text), `icon`, disabled state via `onPressed: null`
- `NovaTextField` — converted to `StatefulWidget`, added `label`, `maxLines`, `enabled`, `textInputAction`, `onFieldSubmitted`, auto password visibility toggle
- `NovaContainer` — added `onTap`, `onLongPress`, `elevation` shorthand, `width`, `height`, `clipBehavior`

### Design System
- `NovaColors` — semantic theme-aware methods (`primary(context)`, `surface(context)`, etc.), raw `MaterialColor` swatches (`indigo`, `slate`, `green`, `amber`, `red`)
- `NovaSpacing` — added gap widgets (`gapMd`, `gapLg`), `EdgeInsets` helpers (`paddingPage`, `paddingH()`, `paddingHV()`)
- `NovaRadius` — added `full` (pill shape), `Radius` variants (`asMd`, `asLg`), directional helpers (`topLg`, `bottomMd`)
- `NovaTheme` — new class: `NovaTheme.light()` / `NovaTheme.dark()` for one-line `MaterialApp` theme setup
- `NovaThemeContext` — `BuildContext` extension: `context.isDark`, `context.novaPrimary`, `context.novaTextSecondary`

### Bug Fixes
- `CardTheme` → `CardThemeData` (Flutter 3.19+ compatibility)

## 1.0.0

- Initial release
- `NovaButton`, `NovaTextField`, `NovaContainer`
- `NovaColors`, `NovaSpacing`, `NovaRadius`

## 1.0.0

### Added

* NovaContainer
* NovaButton
* NovaTextField
* NovaColors
* NovaRadius
* NovaSpacing

### Initial Release

First stable release of Nova UI.
