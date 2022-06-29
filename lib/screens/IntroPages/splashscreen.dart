import 'package:bcard/screens/homepage.dart';
import 'package:bcard/screens/IntroPages/introPage.dart';
import 'package:bcard/utilities/Constants/flutterMobileVision.dart';
import 'package:bcard/utilities/Constants/randomConstants.dart';
import 'package:bcard/utilities/connectivity.dart';
import 'package:bcard/utilities/firebaseFunctions.dart';
import 'package:bcard/utilities/firebaseMessaging.dart';
import 'package:bcard/utilities/localStorage.dart';
import 'package:bcard/utilities/location.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:bcard/screens/LoginSignup/register1.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SplashScreen extends StatelessWidget {
  String profileId;

  Future<void> initDynamicLink() async {
    final PendingDynamicLinkData data =
        await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri deepLink = data?.link;

    if (deepLink != null) {
      String param = deepLink.queryParameters["param"];
      profileId = param;
      print("${deepLink.queryParameters}");
    }
    FirebaseDynamicLinks.instance.onLink(
      onSuccess: (PendingDynamicLinkData linkData) async {
        final Uri deepLink = linkData?.link;
        if (deepLink != null) {
          String param = deepLink.queryParameters["param"];
          profileId = param;
          print("$profileId");
          openProfile(profileId);
        }
      },
      onError: (OnLinkErrorException e) async {
        print('onLinkError $e');
      },
    );
  }

  void init(BuildContext context) async {
    await initDynamicLink();
    await FirebaseFunctions.init();
    await AppMessaging.init();
    await ScanCard.init();
    AppLocation.init();
    await AppConnectivity.init();
    await AppConfig.init();
    if (AppConfig.isLoggedIn && AppConfig.me != null) {
      Navigator.pop(context);
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => HomePage(initialProfileId: profileId),
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
