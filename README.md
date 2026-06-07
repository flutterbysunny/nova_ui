# Nova UI

A modern Flutter UI framework with reusable widgets and clean APIs.

Nova UI helps developers build beautiful Flutter applications faster with production-ready UI components.

## Features

* NovaButton
* NovaTextField
* NovaContainer
* Design System Constants
* Clean APIs
* Lightweight
* Null Safety Support

## Installation

Add Nova UI to your pubspec.yaml:

```yaml
dependencies:
  nova_ui: ^1.0.0
```

Run:

```bash
flutter pub get
```

## Usage

Import package:

```dart
import 'package:nova_ui/nova_ui.dart';
```

### NovaButton

```dart
NovaButton(
  text: 'Login',
  onPressed: () {},
)
```

### NovaTextField

```dart
NovaTextField(
  hintText: 'Email',
)
```

### NovaContainer

```dart
NovaContainer(
  padding: EdgeInsets.all(16),
  child: Text('Nova UI'),
)
```

## Included Widgets

### Components

* NovaButton
* NovaTextField
* NovaContainer

### Design System

* NovaColors
* NovaRadius
* NovaSpacing

## Roadmap

### Version 1.1.0

* NovaCard
* NovaLoader
* NovaDialog

### Version 1.2.0

* NovaToast
* NovaBottomSheet
* NovaShimmer

## Contributing

Contributions are welcome.

## License

MIT License
