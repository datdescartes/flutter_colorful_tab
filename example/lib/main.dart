import 'package:flutter/material.dart';
import 'package:flutter_colorful_tab/flutter_colorful_tab.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Colorful Tab Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const MyHomePage(title: 'Colorful Tab Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(vsync: this, length: 5);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget _pageView(int index) {
    return ListView.builder(
      itemCount: 30,
      itemBuilder: (context, i) => Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(child: Text('Tab ${index + 1} - item no $i')),
        ),
      ),
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
            ColorfulTabBar(
              tabs: [
                TabItem(
                    title: const Row(children: [
                      Icon(Icons.home_outlined),
                      SizedBox(width: 8),
                      Text('Home')
                    ]),
                    color: Colors.red.shade600),
                TabItem(
                    title: const Row(children: [
                      Icon(Icons.favorite_outline),
                      SizedBox(width: 8),
                      Text('Favorite')
                    ]),
                    color: Colors.orange.shade600),
                TabItem(
                    title: const Row(children: [
                      Icon(Icons.search_outlined),
                      SizedBox(width: 8),
                      Text('Search')
                    ]),
                    color: Colors.lime.shade600),
                TabItem(
                    title: const Row(children: [
                      Icon(Icons.settings_outlined),
                      SizedBox(width: 8),
                      Text('Settings')
                    ]),
                    color: Colors.blue.shade600),
                TabItem(
                    title: const Row(children: [
                      Icon(Icons.devices_other_outlined),
                      SizedBox(width: 8),
                      Text('Others')
                    ]),
                    color: Colors.purple.shade600),
              ],
              controller: _tabController,
            ),
            ColorfulTabBar(
              indicatorHeight: 6,
              verticalTabPadding: 0.0,
              labelStyle:
                  const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              selectedHeight: 48,
              unselectedHeight: 40,
              tabs: [
                TabItem(
                  color: Colors.red,
                  title: const Text('Tab 1 - Home'),
                  labelColor: Colors.black,
                  unselectedLabelColor: Colors.yellow.shade600,
                ),
                TabItem(
                    color: Colors.green, title: const Text('Tab 2 - Favorite')),
                TabItem(
                  color: Colors.orange,
                  title: const Text('Tab 3 - Search'),
                  labelColor: Colors.black,
                  unselectedLabelColor: Colors.yellow.shade600,
                  labelStyle: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                  unselectedLabelStyle: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.normal),
                ),
                TabItem(
                    color: Colors.blue, title: const Text('Tab 4 - Settings')),
                TabItem(
                    color: Colors.purple, title: const Text('Tab 5 - Others')),
              ],
              controller: _tabController,
            ),
            ColorfulTabBar(
              selectedHeight: 64,
              unselectedHeight: 48,
              tabs: [
                TabItem(
                    title: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.home_outlined),
                          SizedBox(width: 8),
                          Text('Home')
                        ]),
                    color: Colors.red.shade600),
                TabItem(
                    title: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.favorite_outline),
                          SizedBox(width: 8),
                          Text('Favorite')
                        ]),
                    color: Colors.red.shade600),
                TabItem(
                    title: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.search_outlined),
                          SizedBox(width: 8),
                          Text('Search')
                        ]),
                    color: Colors.lime.shade600),
                TabItem(
                    title: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.settings_outlined),
                          SizedBox(width: 8),
                          Text('Settings')
                        ]),
                    color: Colors.blue.shade600),
                TabItem(
                    title: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.devices_other_outlined),
                          SizedBox(width: 8),
                          Text('Others')
                        ]),
                    color: Colors.purple.shade600),
              ],
              controller: _tabController,
            ),
            ColorfulTabBar(
              alignment: TabAxisAlignment.start,
              tabs: [
                TabItem(
                    title: const Icon(Icons.home_outlined),
                    color: Colors.red.shade600),
                TabItem(
                    title: const Icon(Icons.favorite_outline),
                    color: Colors.orange.shade600),
                TabItem(
                    title: const Icon(Icons.search_outlined),
                    color: Colors.lime.shade600),
                TabItem(
                    title: const Icon(Icons.settings_outlined),
                    color: Colors.blue.shade600),
                TabItem(
                    title: const Icon(Icons.devices_other_outlined),
                    color: Colors.purple.shade600),
              ],
              controller: _tabController,
            ),
            ColorfulTabBar(
              alignment: TabAxisAlignment.end,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white30,
              tabs: [
                TabItem(
                    title: const Icon(Icons.home_outlined),
                    color: Colors.blue.shade600,
                    unselectedColor: Colors.blue.shade400),
                TabItem(
                    title: const Icon(Icons.favorite_outline),
                    color: Colors.blue.shade600,
                    unselectedColor: Colors.blue.shade300),
                TabItem(
                    title: const Icon(Icons.search_outlined),
                    color: Colors.blue.shade600,
                    unselectedColor: Colors.blue.shade300),
                TabItem(
                    title: const Icon(Icons.settings_outlined),
                    color: Colors.blue.shade600,
                    unselectedColor: Colors.blue.shade300),
                TabItem(
                    title: const Icon(Icons.devices_other_outlined),
                    color: Colors.blue.shade600,
                    unselectedColor: Colors.blue.shade300),
              ],
              controller: _tabController,
            ),
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
