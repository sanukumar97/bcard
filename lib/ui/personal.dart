import 'package:bcard/presentation/custom_icons_icons.dart';
import 'package:flutter/material.dart';

class Personal extends StatefulWidget {
  @override
  PersonalState createState() => PersonalState();
}

class PersonalState extends State<Personal> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ListView(physics: ClampingScrollPhysics(),shrinkWrap: true,children: <Widget>[
                Center(child: ProfileStats())
              ])]));
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
                ClipOval(
                  child: Material(
                    color: Colors.black12, // button color
                    child: InkWell(
                      child: SizedBox(
                          width: 60,
                          height: 60,
                          child: Icon(
                            CustomIcons.group_12,
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
            Column(
              children: <Widget>[
                ClipOval(
                  child: Material(
                    color: Colors.black12, // button color
                    child: InkWell(
                      child: SizedBox(
                          width: 60,
                          height: 60,
                        child: Image.asset('assets/icons/focus.png'),
                      ),
                      onTap: () {},
                    ),
                  ),
                ),
                Text(
                    "Focus Mode", style: TextStyle(fontWeight: FontWeight.bold))
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
                        child: Image.asset('assets/icons/card.png'),
                      ),
                      onTap: () {},
                    ),
                  ),
                ),
                Text("Card Visitors",
                    style: TextStyle(fontWeight: FontWeight.bold))
              ],
            )
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
                        child: Image.asset('assets/icons/web.png'),
                      ),
                      onTap: () {},
                    ),
                  ),
                ),
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
                        child: Image.asset('assets/icons/social.png'),
                      ),
                      onTap: () {},
                    ),
                  ),
                ),
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
                        child: Image.asset('assets/icons/email.png'),
                      ),
                      onTap: () {},
                    ),
                  ),
                ),
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
                        child: Image.asset('assets/icons/location.png'),
                      ),
                      onTap: () {},
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

/*class ProfileTags extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.bottomCenter,
        child: Container(
      height: 50.0,
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
        )
    ));
  }
}*/