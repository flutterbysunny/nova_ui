# Nova UI

<p align="center">
  <img src="https://raw.githubusercontent.com/flutterbysunny/nova_ui/main/assets/banner.png" 
       alt="Nova UI Banner" 
       width="100%" />
</p>

[![pub package](https://img.shields.io/pub/v/nova_ui.svg)](https://pub.dev/packages/nova_ui)
[![pub points](https://img.shields.io/pub/points/nova_ui)](https://pub.dev/packages/nova_ui/score)
[![likes](https://img.shields.io/pub/likes/nova_ui)](https://pub.dev/packages/nova_ui)
[![MIT License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

A modern Flutter UI framework with reusable widgets, design system components, and beautiful developer-friendly APIs.

---

## Preview

<p align="center">
  <img src="https://raw.githubusercontent.com/flutterbysunny/nova_ui/main/assets/preview.png" 
       alt="Nova UI Widget Preview" 
       width="100%" />
</p>

---

## Features

- **NovaButton** — filled, outlined, text variants · loading state · icon support · disabled state
- **NovaTextField** — label · validation · password toggle · multiline · theme-aware borders
- **NovaContainer** — tappable · elevation shorthand · gradient · clip support
- **NovaCard** — zero-config card with shadow and rounded corners
- **NovaLoader** — circular, linear, dots loading indicators
- **NovaDialog** — info/success/warning/danger alert and confirm dialogs
- **NovaBadge** — status labels · notification counts · dot indicators · overlay badges
- **NovaShimmer** — animated skeleton loading placeholders
- **NovaAvatar** — network/asset/initials/icon avatar with online indicator
- **NovaChip** — filter/tag chips with group support
- **NovaToast** — animated overlay notifications with auto-dismiss
- **NovaBottomSheet** — styled modal bottom sheet with actions support
- **NovaTheme** — one-line light/dark theme setup
- **NovaColors** — semantic theme-aware colors + raw swatches
- **NovaSpacing** — spacing scale + gap widgets + EdgeInsets helpers
- **NovaRadius** — border radius tokens + directional helpers
- Null safety · Material 3 · Dark mode · All platforms

---

## Installation

```yaml
dependencies:
  nova_ui: ^1.0.4
```

```bash
flutter pub get
```

---

## Quick Start

```dart
import 'package:nova_ui/nova_ui.dart';

// 1. Setup theme
MaterialApp(
  theme: NovaTheme.light(),
  darkTheme: NovaTheme.dark(),
  themeMode: ThemeMode.system,
)

// 2. Use widgets
NovaButton(
  text: 'Login',
  onPressed: () {},
)

NovaTextField(
  label: 'Email',
  hintText: 'you@example.com',
  validator: (v) => v!.isEmpty ? 'Required' : null,
)

NovaCard(
  onTap: () {},
  child: Text('Hello Nova UI'),
)
```

---

## Widgets

### NovaButton

```dart
// Filled (default)
NovaButton(text: 'Submit', onPressed: () {})

// Outlined
NovaButton(
  text: 'Cancel',
  variant: NovaButtonVariant.outlined,
  onPressed: () {},
)

// Loading
NovaButton(text: 'Saving...', loading: true, onPressed: () {})

// Disabled
NovaButton(text: 'Unavailable', onPressed: null)

// With icon
NovaButton(
  text: 'Upload',
  icon: Icon(Icons.upload),
  onPressed: () {},
)
```

### NovaTextField

```dart
// Basic
NovaTextField(label: 'Name', hintText: 'Enter your name')

// Password — auto visibility toggle
NovaTextField(
  label: 'Password',
  obscureText: true,
)

// With validation (inside Form widget)
NovaTextField(
  label: 'Email',
  validator: (v) => v!.contains('@') ? null : 'Invalid email',
)

// Multiline
NovaTextField(label: 'Bio', maxLines: 4)
```

### NovaContainer

```dart
// Tappable
NovaContainer(
  onTap: () {},
  elevation: 4,
  borderRadius: NovaRadius.lg,
  child: Text('Tap me'),
)

// Gradient
NovaContainer(
  height: 120,
  borderRadius: NovaRadius.xl,
  gradient: LinearGradient(colors: [Colors.purple, Colors.blue]),
  child: Center(child: Text('Gradient')),
)
```

### NovaCard

```dart
// Zero config
NovaCard(child: Text('Simple card'))

// Tappable
NovaCard(
  onTap: () {},
  child: ListTile(title: Text('Tap to open')),
)
```

### NovaLoader

```dart
// Circular (default)
const NovaLoader()

// Linear progress bar
NovaLoader(type: NovaLoaderType.linear)

// Dots animation
NovaLoader(type: NovaLoaderType.dots, size: 32)

// Custom color
NovaLoader(color: Colors.white)
```

### NovaDialog

```dart
// Simple alert
NovaDialog.show(
  context: context,
  title: 'Done!',
  message: 'Your profile has been saved.',
  type: NovaDialogType.success,
)

// Confirm dialog
NovaDialog.show(
  context: context,
  title: 'Delete Account?',
  message: 'This action cannot be undone.',
  type: NovaDialogType.danger,
  confirmText: 'Delete',
  cancelText: 'Cancel',
  onConfirm: () => _deleteAccount(),
)
```

### NovaBadge

```dart
// Status label
NovaBadge(label: 'Active', color: NovaBadgeColor.success)

// Dot indicator
NovaBadge(isDot: true, color: NovaBadgeColor.danger)

// Count
NovaBadge(count: 5)

// Overlay on icon
NovaBadge(count: 12, child: Icon(Icons.notifications))
```

### NovaShimmer

```dart
// Rectangle placeholder
const NovaShimmer(width: 200, height: 16)

// Circle — avatar placeholder
const NovaShimmer.circle(size: 48)

// Card skeleton
NovaShimmer.card()

// List skeleton
NovaShimmer.list(itemCount: 5)

// Real world usage
isLoading
  ? NovaShimmer.list(itemCount: 4)
  : ListView.builder(...)
```

### NovaAvatar

```dart
// Initials — auto color from name
NovaAvatar(name: 'John Doe')   // → 'JD'

// Network image with fallback
NovaAvatar(
  imageUrl: 'https://example.com/photo.jpg',
  name: 'John Doe',
)

// Online indicator
NovaAvatar(
  name: 'John',
  showOnlineIndicator: true,
  isOnline: true,
)

// Sizes
NovaAvatar(name: 'JD', size: NovaAvatarSize.xs)  // 28px
NovaAvatar(name: 'JD', size: NovaAvatarSize.lg)  // 64px
```

### NovaChip

```dart
// Simple tag
NovaChip(label: 'Flutter')

// Variants
NovaChip(label: 'Soft', variant: NovaChipVariant.soft)
NovaChip(label: 'Outlined', variant: NovaChipVariant.outlined)

// Deletable
NovaChip(
  label: 'Remove',
  onDeleted: () => _removeTag(),
)

// Single select group
NovaChipGroup(
  chips: ['All', 'Active', 'Completed'],
  selectedIndex: _tab,
  onChanged: (i) => setState(() => _tab = i),
)

// Multi select group
NovaChipGroup.multi(
  chips: ['Flutter', 'Dart', 'Firebase'],
  selectedIndexes: _filters,
  onMultiChanged: (i) => setState(() => _filters = i),
)
```

### NovaToast

```dart
// Simple info
NovaToast.show(
  context: context,
  message: 'Changes saved.',
)

// Success
NovaToast.show(
  context: context,
  message: 'Profile updated!',
  type: NovaToastType.success,
)

// Error — top position
NovaToast.show(
  context: context,
  message: 'Something went wrong.',
  type: NovaToastType.error,
  position: NovaToastPosition.top,
)
```

### NovaBottomSheet

```dart
// Custom content
NovaBottomSheet.show(
  context: context,
  title: 'Edit Profile',
  child: Column(
    children: [
      NovaTextField(label: 'Name'),
      NovaSpacing.gapMd,
      NovaButton(text: 'Save', onPressed: () {}),
    ],
  ),
)

// Actions list
NovaBottomSheet.showActions(
  context: context,
  title: 'Options',
  actions: [
    NovaSheetAction(
      label: 'Share',
      icon: Icons.share_rounded,
      onTap: () {},
    ),
    NovaSheetAction(
      label: 'Delete',
      icon: Icons.delete_outline_rounded,
      isDestructive: true,
      onTap: () {},
    ),
  ],
)
```

---

## Design System

### NovaTheme

```dart
MaterialApp(
  theme: NovaTheme.light(),
  darkTheme: NovaTheme.dark(),
  themeMode: ThemeMode.system,
)

// Custom brand color
MaterialApp(
  theme: NovaTheme.light(seedColor: Colors.teal),
  darkTheme: NovaTheme.dark(seedColor: Colors.teal),
)
```

### NovaColors

```dart
// Semantic — theme-aware (dark mode automatic)
color: NovaColors.primary(context)
color: NovaColors.surface(context)
color: NovaColors.textSecondary(context)
color: NovaColors.success(context)

// Raw swatches
color: NovaColors.indigo[500]
color: NovaColors.slate[200]
```

### NovaSpacing

```dart
// Raw values
SizedBox(height: NovaSpacing.md)   // 16px
SizedBox(width: NovaSpacing.sm)    // 8px

// Gap widgets (vertical)
NovaSpacing.gapSm    // 8px
NovaSpacing.gapMd    // 16px
NovaSpacing.gapLg    // 24px

// EdgeInsets helpers
padding: NovaSpacing.paddingMd       // all sides 16px
padding: NovaSpacing.paddingPage     // h:24 v:16
padding: NovaSpacing.paddingH(20)    // horizontal only
```

### NovaRadius

```dart
borderRadius: NovaRadius.sm     // 8px
borderRadius: NovaRadius.md     // 12px
borderRadius: NovaRadius.lg     // 16px
borderRadius: NovaRadius.full   // pill shape
```

### BuildContext Extensions

```dart
context.isDark              // bool
context.novaPrimary         // Color
context.novaSurface         // Color
context.novaTextPrimary     // Color
context.novaTextSecondary   // Color
context.novaScheme          // ColorScheme
```

---

## Roadmap

| Version | Widgets | Status |
|---------|---------|--------|
| 1.0.0 | `NovaButton`, `NovaTextField`, `NovaContainer` | ✅ Released |
| 1.0.1 | `NovaCard`, `NovaTheme`, Dark mode | ✅ Released |
| 1.0.2 | README, LICENSE, Pub score 160/160 | ✅ Released |
| 1.0.3 | `NovaLoader`, `NovaDialog`, `NovaBadge` | ✅ Released |
| 1.0.4 | `NovaShimmer`, `NovaAvatar`, `NovaChip` | ✅ Released |
| 1.0.5 | `NovaToast`, `NovaBottomSheet` | ✅ Released |
| 1.0.6 | `NovaDropdown`, `NovaCheckbox`, `NovaSwitch` | 🔜 Coming Soon |

---

## Contributing

Contributions are welcome! Please open an issue first to discuss changes.

## License

[MIT](LICENSE) © 2026 flutterbysunny