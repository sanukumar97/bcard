import 'package:bcard/ui/business.dart';
import 'package:bcard/ui/firstmeet.dart';
import 'package:bcard/ui/personal.dart';
import 'package:flutter/material.dart';

enum WidgetMarker { firsMeet, business, personal }

class MyProfile extends StatefulWidget {
  @override
  _MyProfileState createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  WidgetMarker selectedWidgetMarker = WidgetMarker.firsMeet;
  Color _iconColor1=Colors.black;
  Color _iconColor2=Colors.grey;
  Color _iconColor3=Colors.grey;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Column(
                children: <Widget>[
                  CircleAvatar(
                      backgroundColor: Colors.black12,
                      child: IconButton(
                        icon: Icon(Icons.view_headline, color: _iconColor1),
                        onPressed: () {
                          setState(() {
                            _iconColor1 = Colors.black;
                            _iconColor2 = Colors.grey;
                            _iconColor3 = Colors.grey;
                            selectedWidgetMarker = WidgetMarker.firsMeet;
                          });
                        },
                      )),
                  Text("First Meet")
                ],
              ),
              Padding(padding: EdgeInsets.all(10.0)),
              Column(
                children: <Widget>[
                  CircleAvatar(
                      backgroundColor: Colors.black12,
                      child: IconButton(
                        icon: Icon(Icons.business, color: _iconColor2),
                        onPressed: () {
                          setState(() {
                            _iconColor2 = Colors.black;
                            _iconColor1 = Colors.grey;
                            _iconColor3 = Colors.grey;
                            selectedWidgetMarker = WidgetMarker.business;
                          });
                        },
                      )),
                  Text("Business")
                ],
              ),
              Padding(padding: EdgeInsets.all(10.0)),
              Column(
                children: <Widget>[
                  CircleAvatar(
                      backgroundColor: Colors.black12,
                      child: IconButton(
                        icon: Icon(Icons.person_outline, color: _iconColor3),
                        onPressed: () {
                          setState(() {
                            _iconColor3 = Colors.black;
                            _iconColor2 = Colors.grey;
                            _iconColor1 = Colors.grey;
                            selectedWidgetMarker = WidgetMarker.personal;
                          });
                        },
                      )),
                  Text("Personal")
                ],
              )
            ],
          ),
          Container(
            child: getCustomContainer(),
          )
        ],
      ),
    );
  }

  Widget getCustomContainer() {
    switch (selectedWidgetMarker) {
      case WidgetMarker.firsMeet:
        return getFirstMeetContainer();
      case WidgetMarker.business:
        return getBusinessContainer();
      case WidgetMarker.personal:
        return getPersonalContainer();
    }
    return getFirstMeetContainer();
  }

  Widget getFirstMeetContainer() {
    return FirstMeet();
  }

  Widget getBusinessContainer() {
    return Business();
  }

  Widget getPersonalContainer() {
    return Personal();
  }
}