import 'package:bcard/ui/register.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ShareCardPage extends StatelessWidget {
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        child: Center(
          child: RaisedButton(
            child: Text("Log Out"),
            onPressed: () {
              auth.signOut();
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginPage(),
                  ),
                  (Route<dynamic> route) => false);
            },
          ),
        ),
      ),
    );
  }
}
