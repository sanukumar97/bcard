import 'package:bcard/screens/IntroPages/splashscreen.dart';
import 'package:bcard/screens/ProfileTab/feedbackDialog.dart';
import 'package:bcard/utilities/Classes/profileClass.dart';
import 'package:bcard/utilities/Constants/randomConstants.dart';
import 'package:bcard/utilities/localStorage.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsDrawer extends StatefulWidget {
  @override
  _SettingsDrawerState createState() => _SettingsDrawerState();
}

class _SettingsDrawerState extends State<SettingsDrawer> {
  void _logOut(BuildContext context) async {
    Navigator.pop(context);
    await AppConfig.logOut();
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SplashScreen(),
      ),
    );
  }

  void _showFeedBackDialog(BuildContext context) {
    String playStoreUrl =
        "https://play.google.com/store/apps/details?id=com.peoplecard.app";
    launch(playStoreUrl);
    /* showDialog(
      context: context,
      builder: (context) => FeedBackDialog(),
    ); */
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
      width: size.width * 0.7,
      color: color1,
      child: ListView(
        children: [
          ListTile(
            leading: GestureDetector(
              child: Icon(
                Icons.arrow_back,
                color: color5,
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            title: Text(
              "Settings",
              style: myTs(color: color5, size: 22),
            ),
          ),
          ListTile(
            title: Text(
              "Username",
              style: myTs(color: color5.withOpacity(0.3), size: 16),
            ),
            subtitle: Text(
              AppConfig.me.name,
              style: myTs(color: color5, size: 16),
            ),
          ),
          Divider(
            color: color5,
            indent: 10,
            endIndent: 10,
            thickness: 0.1,
          ),
          ListTile(
            title: Text(
              "Profile Status",
              style: myTs(color: color5, size: 18),
            ),
            subtitle: RichText(
              text: TextSpan(
                children: <TextSpan>[
                  TextSpan(
                    text: "Public",
                    style: myTs(
                        color: AppConfig.me.businessProfile.profileStatus ==
                                ProfileStatus.public
                            ? color4
                            : color5,
                        size: 15),
                  ),
                  TextSpan(
                    text: " / ",
                    style: myTs(color: color5, size: 15),
                  ),
                  TextSpan(
                    text: "Personal",
                    style: myTs(
                        color: AppConfig.me.businessProfile.profileStatus ==
                                ProfileStatus.requested
                            ? color4
                            : color5,
                        size: 15),
                  ),
                ],
              ),
            ),
            trailing: Switch(
              value: AppConfig.me.businessProfile.profileStatus ==
                  ProfileStatus.requested,
              onChanged: (status) {
                setState(() {
                  AppConfig.me.businessProfile.profileStatus =
                      status ? ProfileStatus.requested : ProfileStatus.public;
                });
                AppConfig.saveChanges();
              },
              activeColor: color4,
              inactiveThumbColor: color4,
              activeTrackColor: color5,
              inactiveTrackColor: color5,
            ),
          ),
          Divider(
            color: color5,
            indent: 10,
            endIndent: 10,
            thickness: 0.1,
          ),
          ListTile(
            onTap: () {
              _logOut(context);
            },
            trailing: Icon(
              Icons.exit_to_app,
              color: color5,
            ),
            title: Text(
              "Logout",
              style: myTs(color: color5, size: 18),
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.pop(context);
              _showFeedBackDialog(context);
            },
            trailing: Icon(
              Icons.feedback,
              color: color5,
            ),
            title: Text(
              "FeedBack",
              style: myTs(color: color5, size: 18),
            ),
          ),
          ListTile(
            onTap: () {
              launch("https://www.sanukumar.com/peoplecard");
              Navigator.pop(context);
            },
            title: Text(
              "People Card",
              style: myTs(color: color5, size: 18),
            ),
          ),
        ],
      ),
    );
  }
}
