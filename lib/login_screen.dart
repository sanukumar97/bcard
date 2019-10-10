import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

final FirebaseAuth mAuth = FirebaseAuth.instance;

class LoginScreenScaffold extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LoginScreen()
    );
  }
}

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  String _email;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
        children: <Widget>[
          new TextFormField(
            maxLines: 1,
            keyboardType: TextInputType.emailAddress,
            autofocus: false,
            decoration: new InputDecoration(
                hintText: 'Email',
                icon: new Icon(
                  Icons.mail,
                  color: Colors.grey,
                )),
            validator: (value) => value.isEmpty ? 'Email can\'t be empty' : null,
            onSaved: (value) => {
              print(value)
            },
          ),
          TextFormField(
            controller: passwordController,
          ),
          RaisedButton(
            onPressed: (){
              signUpWithEmailPassword();
            },
            child: Text("Submit")
          )
        ],
      )
    );
  }

  void signUpWithEmailPassword() async {
    FirebaseUser user;
    try {
      print(_email);
    } catch(e) {
      print(e);
    } finally {
      print("User created");
    }
  }
}