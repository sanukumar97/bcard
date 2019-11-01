import 'package:flutter/material.dart';

import 'package:bcard/splashscreen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BCard',
      home: SplashScreen(),
      // home: DefaultTabController(
      //   length: 5,
      //   child: HomePage()
      // ),
      debugShowCheckedModeBanner: false,
    );
  }
}
