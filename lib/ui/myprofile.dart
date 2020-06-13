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
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Container(
            color: Colors.white,
            child: ListView(
              shrinkWrap: true,
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
                                ),
                              ),
                              onTap: () {
                                setState(
                                  () {
                                    _iconColor1 = Colors.black;
                                    _iconColor2 = Colors.grey;
                                    _iconColor3 = Colors.grey;
                                    selectedWidgetMarker =
                                        WidgetMarker.firsMeet;
                                  },
                                );
                              },
                            ),
                          ),
                        ),
                        Text("First Meet"),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.all(5.0),
                    ),
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
                                ),
                              ),
                              onTap: () {
                                setState(
                                  () {
                                    _iconColor2 = Colors.black;
                                    _iconColor1 = Colors.grey;
                                    _iconColor3 = Colors.grey;
                                    selectedWidgetMarker =
                                        WidgetMarker.business;
                                  },
                                );
                              },
                            ),
                          ),
                        ),
                        Text("Business"),
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
                                ),
                              ),
                              onTap: () {
                                setState(
                                  () {
                                    _iconColor3 = Colors.black;
                                    _iconColor2 = Colors.grey;
                                    _iconColor1 = Colors.grey;
                                    selectedWidgetMarker =
                                        WidgetMarker.personal;
                                  },
                                );
                              },
                            ),
                          ),
                        ),
                        Text("Personal"),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 30),
                ProfilePicture(),
                ProfileInfo(),
                SizedBox(height: 30),
                Expanded(
                  child: getCustomContainer(),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: new Container(
          width: double.infinity,
          padding: EdgeInsets.only(bottom: 10),
          color: Colors.white,
          height: 57,
          child: Row(
            children: <Widget>[
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemCount: 3,
                  itemBuilder: (context, index) {
                    return Card(
                      color: Color(0xffE5E8EE),
                      child: Container(
                        padding: EdgeInsets.all(8.0),
                        child: Center(
                          child: Text("#HashTag $index"),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Card(
                color: Color(0xffE5E8EE),
                child: Container(
                  child: Center(
                    child: IconButton(
                      icon: Icon(Icons.add),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
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

class ProfilePicture extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Card(
          color: Colors.grey[100],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Container(
            height: 120.0,
            width: 120.0,
            decoration: new BoxDecoration(
              image: new DecorationImage(
                /*image: new NetworkImage(
                    'https://firebasestorage.googleapis.com/v0/b/bcard-8a11b.appspot.com/o/new.jpg?alt=media&token=6f09631f-c466-42f7-a008-cca024419d80'),*/
                fit: BoxFit.cover,
              ),
              shape: BoxShape.circle,
            ),
          ),
        ),
      ],
    );
  }
}

class ProfileInfo extends StatelessWidget {
  final FocusNode myFocusNodeName = FocusNode();
  TextEditingController changeNameController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Column(
              children: <Widget>[
                Text(
                  "Sanket Chaudhari",
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(
              width: 5,
            ),
            GestureDetector(
              child: Material(
                child: InkWell(
                  child: SizedBox(
                    child: Image.asset(
                      'assets/icons/edit.png',
                      height: 13,
                      width: 13,
                      scale: 1,
                    ),
                  ),
                  onTap: () {
                    _showDialog(context);
                  },
                ),
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Column(
              children: <Widget>[
                Text(
                  "Developer",
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(
              width: 5,
            ),
            GestureDetector(
              child: Material(
                child: InkWell(
                  child: SizedBox(
                    child: Image.asset(
                      'assets/icons/edit.png',
                      height: 13,
                      width: 13,
                      scale: 1,
                    ),
                  ),
                  onTap: () {},
                ),
              ),
            ),
          ],
        )
      ],
    );
  }

  _showDialog(BuildContext context) async {
    await showDialog(
      context: context,
      child: new AlertDialog(
        contentPadding: const EdgeInsets.all(16.0),
        content: new Row(
          children: <Widget>[
            new Expanded(
              child: new TextField(
                autofocus: true,
                decoration: new InputDecoration(
                  labelText: 'Name',
                  hintText: 'Name',
                  hintStyle:
                      TextStyle(fontFamily: "WorkSansSemiBold", fontSize: 17.0),
                ),
                style: TextStyle(
                    //TODO: Styles of an app should be generic and should be defined in a file
                    fontFamily: "WorkSansSemiBold",
                    fontSize: 16.0,
                    color: Colors.black),
              ),
            )
          ],
        ),
        actions: <Widget>[
          new FlatButton(
              child: const Text('CANCEL'),
              onPressed: () {
                Navigator.pop(context);
              }),
          new FlatButton(
            child: const Text('OPEN'),
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ],
      ),
    );
  }
}
