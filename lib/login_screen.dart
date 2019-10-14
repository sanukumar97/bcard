import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

final FirebaseAuth mAuth = FirebaseAuth.instance;

class LoginSignUpPage extends StatefulWidget 

  @override
  State<StatefulWidget> createState() => new _LoginSignUpPageState();

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