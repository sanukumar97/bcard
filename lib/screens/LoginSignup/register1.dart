import 'package:bcard/screens/LoginSignup/login.dart';
import 'package:bcard/screens/LoginSignup/register2VerifyNumber.dart';
import 'package:bcard/screens/LoginSignup/register3.dart';
import 'package:bcard/utilities/Classes/userClass.dart';
import 'package:bcard/utilities/connectivity.dart';
import 'package:bcard/utilities/Constants/randomConstants.dart';
import 'package:bcard/utilities/firebaseFunctions.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => new _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  bool _signUp = true;
  TextEditingController _numberController = new TextEditingController();
  String _numberErrorMessage;
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  void _showErrorMessage(String message) {
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: myTs(color: Colors.white),
        ),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    AppConnectivity.context = context;
    return SafeArea(
      child: new Scaffold(
        key: _scaffoldKey,
        backgroundColor: Color(0xffE8E5F1),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                alignment: Alignment.center,
                height: size.height * 0.5,
                child: Image.asset(
                  "assets/images/bck1.png",
                  fit: BoxFit.fill,
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 30),
                  Container(
                    height: 45,
                    child: Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Color(0xff2680EB), width: 1.0),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          width: size.width * 0.6,
                          margin:
                              EdgeInsets.symmetric(horizontal: 0, vertical: 2),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _signUp = true;
                                });
                              },
                              child: Container(
                                width: size.width * 0.3,
                                height: 45,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: _signUp
                                      ? Colors.white
                                      : Colors.transparent,
                                ),
                                child: Text(
                                  "Sign Up",
                                  style: myTs(
                                          color: Color(0xff2680EB), size: 18)
                                      .copyWith(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _signUp = false;
                                });
                              },
                              child: Container(
                                width: size.width * 0.3,
                                height: 45,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: !_signUp
                                      ? Colors.white
                                      : Colors.transparent,
                                ),
                                child: Text(
                                  "Login",
                                  style: myTs(
                                          color: Color(0xff2680EB), size: 18)
                                      .copyWith(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 25),
                  Container(
                    width: size.width * 0.6,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.white,
                    ),
                    padding: EdgeInsets.all(5),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _numberController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              hintText: (_signUp ? "Sign Up" : "Login") +
                                  " with Phone Number",
                              hintStyle: myTs(size: 12, color: Colors.grey),
                              hintMaxLines: 2,
                              //errorText: _numberErrorMessage,
                              border: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              focusedErrorBorder: InputBorder.none,
                              isDense: true,
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          child: IconButton(
                            icon: Icon(
                              Icons.arrow_forward_ios,
                              color: Color(0xff2680EB),
                              size: 20,
                            ),
                            onPressed: () async {
                              String s = _numberController.value.text;
                              if (s.isEmpty) {
                                _numberErrorMessage = "Enter Phone Number";
                                _showErrorMessage(_numberErrorMessage);
                              } else if (!RegExp(r'^[0-9]+$').hasMatch(s)) {
                                _numberErrorMessage = "Number not valid";
                                _showErrorMessage(_numberErrorMessage);
                              } else if (s.length != 10) {
                                _numberErrorMessage =
                                    "Should be 10 digit number";
                                _showErrorMessage(_numberErrorMessage);
                              } else if (_signUp &&
                                  (await FirebaseFunctions.checkNumberExists(
                                      s))) {
                                _numberErrorMessage =
                                    "Phone number already exists";
                                _showErrorMessage(_numberErrorMessage);
                              } else {
                                _numberErrorMessage = null;
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        VerifyNumberScreen(s, _signUp),
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 25),
                  GestureDetector(
                    onTap: () async {
                      auth.User _user =
                          await FirebaseFunctions.googleSignIn();
                      if (_user != null) {
                        if (_signUp) {
                          if (await FirebaseFunctions.checkEmailExists(
                              _user.email)) {
                            _showErrorMessage(
                                "Email already exists! Please Log In.");
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UserDetailsPage(
                                  signInMethod: SignInMethod.google,
                                  email: _user.email,
                                  name: _user.displayName,
                                  number: _user.phoneNumber,
                                ),
                              ),
                            );
                          }
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginPage(
                                signInMethod: SignInMethod.google,
                                email: _user.email,
                                number: _user.phoneNumber,
                              ),
                            ),
                          );
                        }
                      }
                    },
                    child: Container(
                      height: 60,
                      child: SvgPicture.asset(
                        _signUp
                            ? "assets/images/googleSignUp.svg"
                            : "assets/images/googleLogin.svg",
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
