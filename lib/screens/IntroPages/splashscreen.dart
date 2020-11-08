import 'package:bcard/screens/homepage.dart';
import 'package:bcard/screens/IntroPages/introPage.dart';
import 'package:bcard/utilities/connectivity.dart';
import 'package:bcard/utilities/firebaseFunctions.dart';
import 'package:bcard/utilities/firebaseMessaging.dart';
import 'package:bcard/utilities/localStorage.dart';
import 'package:bcard/utilities/location.dart';
import 'package:flutter/material.dart';
import 'package:bcard/screens/LoginSignup/register1.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SplashScreen extends StatelessWidget {
  void init(BuildContext context) async {
    await FirebaseFunctions.init();
    await AppMessaging.init();
    AppLocation.init();
    await AppConnectivity.init();
    await AppConfig.init();
    if (AppConfig.isLoggedIn && AppConfig.me != null) {
      Navigator.pop(context);
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => HomePage(),
        ),
      );
    } else {
      Navigator.pop(context);
      if (AppConfig.firstInstallDone) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => RegistrationPage(),
          ),
        );
      } else {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => IntroSliderPage(),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    init(context);
    AppConnectivity.context = context;
    return SafeArea(
      child: Scaffold(
        body: Container(
          alignment: Alignment.center,
          color: Color(0xff16202C),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.3,
            width: MediaQuery.of(context).size.width * 0.4,
            child: SvgPicture.asset(
              "assets/images/Logo.svg",
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}
