# Flutter Colorful TabBar

A colorful TabBar for Flutter.

![demo](https://raw.githubusercontent.com/datdescartes/flutter_colorful_tab/master/demo.gif)

## Getting Started

Add package from github by adding the following to your pubspec.yaml, pub publication is added later.
````
  dependencies:
    flutter_colorful_tab: "^0.0.2"
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