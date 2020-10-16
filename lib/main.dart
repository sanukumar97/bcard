import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:bcard/screens/IntroPages/splashscreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    return MaterialApp(
      title: 'BCard',
      home: SplashScreen(),
      theme: ThemeData(
        fontFamily: "Helvetica",
        primaryColor: Colors.white,
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
