import 'package:bcard/presentation/custom_icons_icons.dart';
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
  Color _iconColor1 = Colors.black;
  Color _iconColor2 = Colors.grey;
  Color _iconColor3 = Colors.grey;

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
                  ClipOval(
                    child: Material(
                      color: Colors.black12, // button color
                      child: InkWell(
                        child: SizedBox(
                            width: 40,
                            height: 40,
                            child: Icon(
                              CustomIcons.first_meet,
                              color: _iconColor1,
                              size: 35.0,
                            )),
                        onTap: () {
                          setState(() {
                            _iconColor1 = Colors.black;
                            _iconColor2 = Colors.grey;
                            _iconColor3 = Colors.grey;
                            selectedWidgetMarker = WidgetMarker.firsMeet;
                          });
                        },
                      ),
                    ),
                  ),
                  Text("First Meet")
                ],
              ),
              Padding(padding: EdgeInsets.all(5.0)),
              Column(
                children: <Widget>[
                  ClipOval(
                    child: Material(
                      color: Colors.black12, // button color
                      child: InkWell(
                        child: SizedBox(
                            width: 40,
                            height: 40,
                            child: Icon(
                              CustomIcons.group_9,
                              size: 35.0,
                              color: _iconColor2,
                            )),
                        onTap: () {
                          setState(() {
                            _iconColor2 = Colors.black;
                            _iconColor1 = Colors.grey;
                            _iconColor3 = Colors.grey;
                            selectedWidgetMarker = WidgetMarker.business;
                          });
                        },
                      ),
                    ),
                  ),
                  Text("Business")
                ],
              ),
              Padding(padding: EdgeInsets.all(5.0)),
              Column(
                children: <Widget>[
                  ClipOval(
                    child: Material(
                      color: Colors.black12, // button color
                      child: InkWell(
                        child: SizedBox(
                            width: 40,
                            height: 40,
                            child: Icon(
                              CustomIcons.group_8,
                              color: _iconColor3,
                              size: 35.0,
                            )),
                        onTap: () {
                          setState(() {
                            _iconColor3 = Colors.black;
                            _iconColor2 = Colors.grey;
                            _iconColor1 = Colors.grey;
                            selectedWidgetMarker = WidgetMarker.personal;
                          });
                        },
                      ),
                    ),
                  ),
                  Text("Personal")
                ],
              )
            ],
          ),
          Container(
            child: getCustomContainer(),
          ),
          /*Container(
            height: 25.0,
              child: Row(children: <Widget>[
                Column(children: <Widget>[
                  Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                          height: 25.0,
                          //alignment: Alignment.bottomCenter,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return Container(
                                margin: const EdgeInsets.symmetric(horizontal: 1.0),
                                color: Colors.tealAccent,
                                height: 10.0,
                                child: Text('$index'),
                              );
                            },
                          )))
                ]),
                Column(children: <Widget>[
                  IconButton(icon: Icon(Icons.add))
                ],)
          ]))*/
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