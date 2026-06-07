# Nova UI

[![pub package](https://img.shields.io/pub/v/nova_ui.svg)](https://pub.dev/packages/nova_ui)
[![pub points](https://img.shields.io/pub/points/nova_ui)](https://pub.dev/packages/nova_ui/score)
[![likes](https://img.shields.io/pub/likes/nova_ui)](https://pub.dev/packages/nova_ui)
[![MIT License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

A modern Flutter UI framework with reusable widgets, design system components, and beautiful developer-friendly APIs.

---

## Features

- **NovaButton** — filled, outlined, text variants · loading state · icon support · disabled state
- **NovaTextField** — label · validation · password toggle · multiline · theme-aware borders
- **NovaContainer** — tappable · elevation shorthand · gradient · clip support
- **NovaCard** — zero-config card with shadow and rounded corners
- **NovaTheme** — one-line light/dark theme setup
- **NovaColors** — semantic theme-aware colors + raw swatches
- **NovaSpacing** — spacing scale + gap widgets + EdgeInsets helpers
- **NovaRadius** — border radius tokens + directional helpers
- Null safety · Material 3 · Dark mode · All platforms

---

## Installation

```yaml
dependencies:
  nova_ui: ^1.0.1
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

### BuildContext extensions

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

| Version | Widgets |
|---------|---------|
| 1.0.2   | `NovaLoader`, `NovaDialog` |
| 1.0.3   | `NovaToast`, `NovaBottomSheet` |
| 1.0.4   | `NovaShimmer`, `NovaAvatar` |

---

## Contributing

Contributions are welcome! Please open an issue first to discuss changes.

## License

[MIT](LICENSE) © 2026 flutterbysunny