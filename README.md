# Flutter Colorful TabBar

A colorful TabBar for Flutter where each tab has a color (inspired by SmartNews app).

![demo](https://raw.githubusercontent.com/datdescartes/flutter_colorful_tab/master/demo.gif)

## Getting Started

Add this to your package's pubspec.yaml file:
```yaml
  dependencies:
    flutter_colorful_tab: {current_version}
```

Import the library in your file:
```dart
import 'package:flutter_colorful_tab/flutter_colorful_tab.dart';
```

Use the flutter_colorful_tab like this: 
```dart
ColorfulTabBar(
  tabs: [
    TabItem(color: Colors.red, title: Text('Home')),
    TabItem(color: Colors.green, title: Text('Favorite')),
    TabItem(color: Colors.orange, title: Text('Search')),
    TabItem(color: Colors.green, title: Text('Settings')),
  ],
  controller: _tabController,
)

// all available parameters of TabItem
  TabItem(
    color: Colors.orange,
    unselectedColor: Colors.orange.shade600,
    title: const Text('Search'),
    labelColor: Colors.black,
    unselectedLabelColor: Colors.yellow,
    labelStyle: const TextStyle(fontWeight: FontWeight.bold),
    unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal),
  ),
```