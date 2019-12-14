import 'package:flutter/material.dart';

class Personal extends StatefulWidget {
  @override
  PersonalState createState() => PersonalState();
}

class PersonalState extends State<Personal> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: ListView(
            children: <Widget>[
              SizedBox(
                  height: 30
              ),
              ProfilePicture(),
              ProfileInfo(),
              SizedBox(
                  height: 30
              ),
              ProfileStats()
            ]
        )
    );
  }
}

class ProfilePicture extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
      Card(
        color: Colors.grey[100],
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        child: Container(
          height: 120.0,
          width: 120.0,
          decoration: new BoxDecoration(
            image: new DecorationImage(
              image: new NetworkImage('https://firebasestorage.googleapis.com/v0/b/bcard-8a11b.appspot.com/o/new.jpg?alt=media&token=6f09631f-c466-42f7-a008-cca024419d80'),
              fit: BoxFit.cover,
            ),
            shape: BoxShape.circle,
          ),
        ),
      ),
    ]);
  }
}

class ProfileInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text("Sanket Chaudhari",
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
        Text("(Developer)",
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold))
      ],
    );
  }
}

class ProfileStats extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Column(
              children: <Widget>[
                CircleAvatar(
                    backgroundColor: Colors.black12,
                    radius: 30.0,
                    child: Text("1024",
                        style: TextStyle(fontSize: 20.0, color: Colors.black))),
                Text("Connections",
                    style: TextStyle(fontWeight: FontWeight.bold))
              ],
            ),
            Column(
              children: <Widget>[
                ClipOval(
                  child: Material(
                    color: Colors.black12, // button color
                    child: InkWell(
                      child: SizedBox(
                          width: 60,
                          height: 60,
                          child: Icon(
                            Icons.face,
                            size: 40.0,
                          )),
                      onTap: () {},
                    ),
                  ),
                ),
                Text("Focus Mode",
                    style: TextStyle(fontWeight: FontWeight.bold))
              ],
            ),
            Column(
              children: <Widget>[
                ClipOval(
                  child: Material(
                    color: Colors.black12, // button color
                    child: InkWell(
                      child: SizedBox(
                          width: 60,
                          height: 60,
                          child: Icon(
                            Icons.remove_red_eye,
                            size: 40.0,
                          )),
                      onTap: () {},
                    ),
                  ),
                ),
                Text("Connections",
                    style: TextStyle(fontWeight: FontWeight.bold))
              ],
            ),
          ],
        ),
        SizedBox(height: 30),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Column(
              children: <Widget>[
                ClipOval(
                  child: Material(
                    color: Colors.black12, // button color
                    child: InkWell(
                      child: SizedBox(
                          width: 60,
                          height: 60,
                          child: Icon(
                            Icons.face,
                            size: 40.0,
                          )),
                      onTap: () {},
                    ),
                  ),
                ),
                Text("Focus Mode",
                    style: TextStyle(fontWeight: FontWeight.bold))
              ],
            ),
            Column(
              children: <Widget>[
                ClipOval(
                  child: Material(
                    color: Colors.black12, // button color
                    child: InkWell(
                      child: SizedBox(
                          width: 60,
                          height: 60,
                          child: Icon(
                            Icons.face,
                            size: 40.0,
                          )),
                      onTap: () {},
                    ),
                  ),
                ),
                Text("Social",
                    style: TextStyle(fontWeight: FontWeight.bold))
              ],
            ),
            Column(
              children: <Widget>[
                ClipOval(
                  child: Material(
                    color: Colors.black12, // button color
                    child: InkWell(
                      child: SizedBox(
                          width: 60,
                          height: 60,
                          child: Icon(
                            Icons.mail,
                            size: 40.0,
                          )),
                      onTap: () {},
                    ),
                  ),
                ),
                Text("E-Mail",
                    style: TextStyle(fontWeight: FontWeight.bold))
              ],
            ),
            Column(
              children: <Widget>[
                ClipOval(
                  child: Material(
                    color: Colors.black12, // button color
                    child: InkWell(
                      child: SizedBox(
                          width: 60,
                          height: 60,
                          child: Icon(
                            Icons.location_on,
                            size: 40.0,
                          )),
                      onTap: () {},
                    ),
                  ),
                ),
                Text("Location",
                    style: TextStyle(fontWeight: FontWeight.bold))
              ],
            ),
          ],
        ),
      ],
    );
  }
}