import 'package:flutter/material.dart';
import 'package:flutter_colorful_tab/flutter_colorful_tab.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Colorful Tab Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Colorful Tab Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(vsync: this, length: 5);
    super.initState();
  }

  Widget _pageView(int index) {
    return Center(
        child: Card(
      child: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Center(
          child: Text('Page ${index + 1}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ),
      ),
    ));
  }

  TabItem _buildTabItem(IconData icon, String text, Color color) => TabItem(
        title: Row(
          children: [
            Icon(icon),
            SizedBox(width: 8),
            Text(text),
          ],
        ),
        color: color,
      );

  Widget _buildTabBar() {
    return ColorfulTabBar(
      tabs: [
        _buildTabItem(Icons.home_outlined, 'Home', Colors.red.shade600),
        _buildTabItem(
            Icons.favorite_outline, 'Favorite', Colors.orange.shade600),
        _buildTabItem(
            Icons.dashboard_outlined, 'Dashboard', Colors.green.shade600),
        _buildTabItem(Icons.search_outlined, 'Search', Colors.lime.shade600),
        _buildTabItem(
            Icons.settings_outlined, 'Settings', Colors.purple.shade600),
      ],
      controller: _tabController,
    );
  }

  Widget _buildTabBar2() {
    return ColorfulTabBar(
      tabs: [
        TabItem(color: Colors.red.shade600, title: Text('Home')),
        TabItem(color: Colors.green.shade600, title: Text('Favorite')),
        TabItem(color: Colors.orange.shade600, title: Text('Search')),
        TabItem(color: Colors.green.shade600, title: Text('Settings')),
      ],
      controller: _tabController,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _buildTabBar(),
            Expanded(
              child: TabBarView(
                  controller: _tabController,
                  children: List.generate(5, (index) => _pageView(index))),
            ),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
