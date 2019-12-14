import 'package:bcard/ui/myprofile.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        elevation: 0.0,
        title: Text("Profile"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: (){
              _scaffoldKey.currentState.openEndDrawer();
            },
          )
        ],
      ),
      body: MyProfile(),
      endDrawer: Drawer(
        child: ListView(
          children: <Widget>[
            Container(
              height: 63.0,
              child: DrawerHeader(
                child: Text(
                  "Settings",
                  style: TextStyle(
                    fontSize: 20.0
                  ),
                ),
                decoration: BoxDecoration(
                  
                ),
              ),
            ),
            ListTile(
              title: Text(
                "Invite Friends"
              ),
              onTap:(){}
            ),
            ListTile(
              title: Text(
                "Card Preference"
              ),
              onTap:(){}
            ),
            ListTile(
              title: Text(
                "Security"
              ),
              onTap:(){}
            ),
            ListTile(
              title: Text(
                "About"
              ),
              onTap:(){}
            ),
            ListTile(
              title: Text(
                "Help"
              ),
              onTap:(){}
            ),
            ListTile(
              title: Text(
                "Log Out"
              ),
              onTap:(){}
            )
          ],
        ),
      ),
    );
  }
}