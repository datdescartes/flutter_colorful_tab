# flutter_colorful_tab

A colorful TabBar for Flutter.

![demo](https://raw.githubusercontent.com/datdescartes/flutter_colorful_tab/master/demo.gif)

## Getting Started

Add package from github by adding the following to your pubspec.yaml, pub publication is added later.
````
  dependencies:
    flutter_colorful_tab: "^0.0.1"
````
Import the library in your file:
````
import 'package:flutter_colorful_tab/flutter_colorful_tab.dart';
````
Use the flutter_colorful_tab like this: 
````
ColorfulTabBar(
  tabs: [
    TabItem(color: Colors.red.shade600, title: Text('Home')),
    TabItem(color: Colors.green.shade600, title: Text('Favorite')),
    TabItem(color: Colors.orange.shade600, title: Text('Search')),
    TabItem(color: Colors.green.shade600, title: Text('Settings')),
  ],
  controller: _tabController,
)
````