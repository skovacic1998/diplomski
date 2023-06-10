import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: const Text('Navigation Drawer')),
        body: const Center(
          child: Text('Hello World!'),
        ),
        drawer: const NavigationDrawer(),
      ),
    );
  }
}

class NavigationDrawer extends StatefulWidget {
  const NavigationDrawer({super.key});

  @override
  State<NavigationDrawer> createState() => _NavigationDrawerState();
}

class _NavigationDrawerState extends State<NavigationDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.black,
            ),
            child: Text('Da vidimo kak to zgleda'),
          ),
          ListTile(
            title: const Text('Prvi page'),
            onTap: (){
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Drugi page'),
            onTap: () {
              Navigator.pop(context);
            },
          )
        ],
      ),
    );
  }

  void onPressed() {
  }
}
