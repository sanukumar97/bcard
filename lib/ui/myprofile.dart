import 'package:flutter/material.dart';

class MyProfile extends StatefulWidget {
  @override
  _MyProfileState createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        ProfileMode(),
        SizedBox(
          height: 30
        ),
        ProfilePicture(),
        ProfileInfo(),
        SizedBox(
          height: 30
        ),
        ProfileStats()
      ],
    );
  }
}

class ProfileMode extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: 15.0
      ),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Column(
            children: <Widget>[
              CircleAvatar(
                backgroundColor: Colors.black12,
                child: IconButton(
                  color: Colors.black,
                  icon: Icon(Icons.view_headline),
                  onPressed: (){},
                )
              ),
              Text("First Meet")
            ],
          ),
          Padding(
            padding: EdgeInsets.all(10.0)
          ),
          Column(
            children: <Widget>[
              CircleAvatar(
                backgroundColor: Colors.black12,
                child: IconButton(
                  color: Colors.black,
                  icon: Icon(Icons.business),
                  onPressed: (){},
                )
              ),
              Text("Business")
            ],
          ),
          Padding(
            padding: EdgeInsets.all(10.0)
          ),
          Column(
            children: <Widget>[
              CircleAvatar(
                backgroundColor: Colors.black12,
                child: IconButton(
                  color: Colors.black,
                  icon: Icon(Icons.person_outline),
                  onPressed: (){},
                )
              ),
              Text("Personal")
            ],
          )
        ],
      ),
    );
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
            borderRadius: BorderRadius.circular(10.0)
          ),
          child: SizedBox(
            width: 120,
            height: 120,
            child: Center(
              child: Text("Avatar")
            ),
          ),
        ),
      ]
    );
  }
}

class ProfileInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(
          "Sanket Chaudhari",
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold
          )
        ),
        Text(
          "(Developer)",
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold
          )
        )
      ],
    );
  }
}

class ProfileStats extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Column(
          children: <Widget>[
            CircleAvatar(
              backgroundColor: Colors.black12,
              radius: 35.0,
              child: Text(
                "1024",
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.black
                )
              )
            ),
            Text(
              "Connections",
              style: TextStyle(
                fontWeight: FontWeight.bold
              )
            )
          ],
        ),
        Column(
          children: <Widget>[
            CircleAvatar(
              backgroundColor: Colors.black12,
              radius: 35.0,
              child: Icon(
                Icons.face,
                color: Colors.black,
                size: 50.0
              )
            ),
            Text(
              "Focus Mode",
              style: TextStyle(
                fontWeight: FontWeight.bold
              )
            )
          ],
        ),
        Column(
          children: <Widget>[
            CircleAvatar(
              backgroundColor: Colors.black12,
              radius: 35.0,
              child: Icon(
                Icons.remove_red_eye,
                color: Colors.black,
                size: 50.0
              )
            ),
            Text(
              "Connections",
              style: TextStyle(
                fontWeight: FontWeight.bold
              )
            )
          ],
        )
      ],
    );
  }
}