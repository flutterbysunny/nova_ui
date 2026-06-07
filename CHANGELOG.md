# Changelog

All notable changes to this project will be documented in this file.


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
