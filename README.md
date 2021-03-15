# Flutter Colorful TabBar

A colorful TabBar for Flutter where each tab has a color (inspired by SmartNews app).

![demo](https://raw.githubusercontent.com/datdescartes/flutter_colorful_tab/master/demo.gif)

## Getting Started

Add this to your package's pubspec.yaml file:
````
  dependencies:
    flutter_colorful_tab: "^0.1.0"
````

Import the library in your file:
````
import 'package:flutter_colorful_tab/flutter_colorful_tab.dart';
````

Use the flutter_colorful_tab like this: 
````
ColorfulTabBar(
  tabs: [
    TabItem(color: Colors.red, title: Text('Home')),
    TabItem(color: Colors.green, title: Text('Favorite')),
    TabItem(color: Colors.orange, title: Text('Search')),
    TabItem(color: Colors.green, title: Text('Settings')),
  ],
  controller: _tabController,
)
````