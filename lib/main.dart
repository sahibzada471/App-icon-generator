import 'package:flutter/material.dart';

import 'App_icon.dart';
import 'Images_set.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Second(),
    );
  }
}

class Second extends StatefulWidget {
  const Second({super.key});

  @override
  State<Second> createState() => _SecondState();
}

class _SecondState extends State<Second> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this); // 2 tabs
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(
              Icons.window_sharp,
            ),
            SizedBox(
              width: 10,
            ),
            Text("App Icon Generator"),
          ],
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(
              child: Row(
                children: [
                  Icon(Icons.image),
                  SizedBox(width: 10),
                  Text(
                    "App Icon",
                    style: TextStyle(fontSize: 19),
                  ),
                ],
              ),
            ),
            Tab(
              child: Row(
                children: [
                  Icon(Icons.window),
                  SizedBox(width: 10),
                  Text(
                    "Splash Icon",
                    style: TextStyle(fontSize: 19),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
           // Tab 1 Content: App Icon
          AppIcons(),
          // Tab 2 Content: Image Sets
          ImageScreen()
        ],
      ),
    );
  }
}
