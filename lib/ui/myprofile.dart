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
        ProfilePicture(),
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
    return SizedBox(
      height: 100,
      width: 100,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0)
        ),
        child: SizedBox(
          width: 100,
          height: 100,
          child: Center(
            child: Text("Blah")
          ),
        ),
      ),
    );
  }
}