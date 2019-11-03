
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:bcard/register.dart';
import 'package:bcard/homepage.dart';
import 'package:bcard/utils/current_user.dart';

class SplashScreen extends StatefulWidget {

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  FirebaseUser user;

  String switchTo;

  void init(context) async {
    FirebaseUser user = await currentUser();
    Future.delayed(Duration(seconds: 1), (){
      if(user != null){
          switchTo = "home";
      } else {
        switchTo = "login";
      }
      if(switchTo == "home"){
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage()
          ),
          (Route<dynamic> route) => false
        );
      }
      else if(switchTo == "login"){
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => LoginPage()
          ),
          (Route<dynamic> route) => false
        );
      }  
    });
  }

  @override
  void initState() {
    switchTo = "";
    init(context);
    context;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildSplashScreen()
    );
    
  }

  Widget _buildSplashScreen(){
    return Container(
      color: Colors.white,
      child: Center(
        child: Text(
          "BCard",
          style: TextStyle(
            fontSize: 20.0
          )
        )
      )
    );
  }
}