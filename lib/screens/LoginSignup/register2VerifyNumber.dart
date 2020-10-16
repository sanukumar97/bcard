import 'package:bcard/screens/LoginSignup/login.dart';
import 'package:bcard/screens/LoginSignup/register3.dart';
import 'package:bcard/utilities/Classes/userClass.dart';
import 'package:bcard/utilities/Constants/randomConstants.dart';
import 'package:bcard/utilities/firebaseFunctions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class VerifyNumberScreen extends StatefulWidget {
  final String phoneNumber;
  final bool isSignup;
  VerifyNumberScreen(this.phoneNumber, this.isSignup);
  @override
  _VerifyNumberScreenState createState() => _VerifyNumberScreenState();
}

class _VerifyNumberScreenState extends State<VerifyNumberScreen> {
  bool _codeSent = false,
      _codeTimeout = false,
      _verificationFailed = false,
      _verificationCompleted = false;
  String errorMessage = "";

  void codeSent(String s, [int k]) {
    print("Code Sent: $s  $k");
    setState(() {
      _codeSent = true;
      _codeTimeout = false;
      _verificationCompleted = false;
      _verificationFailed = false;
    });
  }

  void codeTimeout(String s) {
    print("Code Timeout: $s");
    setState(() {
      _codeTimeout = true;
      _codeSent = false;
      errorMessage = "Cannot retrieve OTP from your device.\nTry Again.";
    });
  }

  void verificationCompleted(AuthCredential cred) async {
    print("Verification Completed: ${cred.providerId}");
    setState(() {
      _verificationCompleted = true;
    });
    await Future.delayed(Duration(milliseconds: 500));
    if (widget.isSignup) {
      Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => UserDetailsPage(
            signInMethod: SignInMethod.number,
            number: widget.phoneNumber,
          ),
        ),
      );
    } else {
      Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LoginPage(
            signInMethod: SignInMethod.number,
            number: widget.phoneNumber,
          ),
        ),
      );
    }
  }

  void verificationFailed(AuthException exp) {
    print("Verification Failed: ${exp.message}");
    setState(() {
      _verificationFailed = true;
      errorMessage =
          "An error occured\nCheck your network connection and try again.";
    });
  }

  @override
  void initState() {
    super.initState();
    FirebaseFunctions.sendOtp(widget.phoneNumber, verificationCompleted,
        verificationFailed, codeSent, codeTimeout);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: Color(0xff16202C),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "VERIFY PHONE NUMBER",
                  textAlign: TextAlign.left,
                  style: myTs(color: Colors.white, size: 20)
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                          text:
                              "We've sent a verification code to your phone number: "),
                      TextSpan(
                        text: "+91 ${widget.phoneNumber}",
                        style: myTs(
                          color: Color(0xff5EB8F3),
                          size: 15,
                        ),
                      ),
                      TextSpan(
                          text:
                              ". \nIt would be auto-retrieved from your device."),
                    ],
                    style: myTs(color: Colors.white, size: 15),
                  ),
                ),
                SizedBox(height: 60),
                _verificationCompleted
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Icon(
                            Icons.check,
                            color: Colors.green,
                          ),
                          Text(
                            "Verification successful",
                            style: myTs(size: 18, color: Colors.white),
                          )
                        ],
                      )
                    : _codeTimeout
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Icon(
                                Icons.error_outline,
                                color: Colors.red,
                              ),
                              Text(
                                "A Timeout occured",
                                style: myTs(size: 18, color: Colors.red),
                              )
                            ],
                          )
                        : _verificationFailed
                            ? Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Icon(
                                    Icons.error_outline,
                                    color: Colors.red,
                                  ),
                                  Text(
                                    "An error occured. Try again",
                                    style: myTs(size: 18, color: Colors.red),
                                  )
                                ],
                              )
                            : _codeSent
                                ? Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      CircularProgressIndicator(),
                                      Text(
                                        "Waiting for OTP",
                                        style:
                                            myTs(size: 18, color: Colors.white),
                                      )
                                    ],
                                  )
                                : SizedBox(),
                SizedBox(height: 30),
                _codeTimeout || _verificationFailed
                    ? RichText(
                        text: TextSpan(
                          text: "Resend Code?",
                          style: myTs(color: Color(0xff5EB8F3)),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              FirebaseFunctions.sendOtp(
                                  widget.phoneNumber,
                                  verificationCompleted,
                                  verificationFailed,
                                  codeSent,
                                  codeTimeout);
                            },
                        ),
                      )
                    : SizedBox()
              ],
            ),
          )),
    );
  }
}
