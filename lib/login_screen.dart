import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

final FirebaseAuth mAuth = FirebaseAuth.instance;
class LoginSignUpPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => new _LoginSignUpPageState();

}

class _LoginSignUpPageState extends State<LoginSignUpPage>{
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Container(
        child: ListView(
          children: <Widget>[
            Form(
              key: _formKey,
              child: ListView(
                children: <Widget>[
                  TextFormField(
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                  ),
                ],
              )
            )
          ],
        )
      ),
    );
  }
}