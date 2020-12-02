import 'package:flutter/material.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:tangram/map_view.dart';
import 'package:tangram/tileview.dart';
import 'package:tangram/user_info.dart';
import 'package:tangram/users_explore.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _selectedIndex = 0;
  List<Widget> children = [
    MapView(),
    // TileView(),
    UserInfo(
      username: 'cKKe',
      isUser: true,
    ),
  ];

  // final pages = [
  //   Center(
  //     child: Text('Tangram'),
  //   ),
  //   Column(
  //     children: [
  //       Text('Mosaic Based'),
  //       Text('Intimate'),
  //       Text('Viral'),
  //       Text('No recommendation algorithm'),
  //     ],
  //   )
  // ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      // darkTheme: ThemeData(
      //   brightness: Brightness.dark,
      //   /* dark theme settings */
      // ),
      // themeMode: ThemeMode.dark,
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.yellow,
        accentColor: Colors.yellow[500],
        toggleableActiveColor: Colors.yellow[500],
        textSelectionColor: Colors.yellow[200],
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (value) => setState(() {
            _selectedIndex = value;
          }),
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.dashboard), title: Text('Explore')),
            BottomNavigationBarItem(
                icon: Icon(Icons.person), title: Text('Profile')),
          ],
        ),
        body: children[_selectedIndex],
        // body: Builder(
        //   builder: (context) => LiquidSwipe(pages: pages),
        // ),
      ),
    );
  }
}
