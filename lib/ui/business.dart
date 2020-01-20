import 'package:bcard/presentation/custom_icons_icons.dart';
import 'package:flutter/material.dart';

class Business extends StatefulWidget {
  @override
  BusinessState createState() => BusinessState();
}

class BusinessState extends State<Business> {
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