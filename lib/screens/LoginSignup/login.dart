import 'package:bcard/screens/homepage.dart';
import 'package:bcard/utilities/Classes/userClass.dart';
import 'package:bcard/utilities/Constants/randomConstants.dart';
import 'package:bcard/utilities/firebaseFunctions.dart';
import 'package:bcard/utilities/localStorage.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  final SignInMethod signInMethod;
  final String number, email;
  LoginPage({this.number, this.email, @required this.signInMethod});
  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  Color _fontColor = Color(0xff4D4F50);
  TextEditingController _numberController, _passwordController;
  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool _passwordHidden = true;
  bool _logging = false;

  @override
  void initState() {
    super.initState();
    _numberController = new TextEditingController(
        text: widget.signInMethod == SignInMethod.google
            ? widget.email
            : widget.number);
    _passwordController = new TextEditingController();
  }

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
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: SafeArea(
        child: new Scaffold(
          key: _scaffoldKey,
          backgroundColor: Color(0xffF7F1E5),
          appBar: AppBar(
            elevation: 0.0,
            backgroundColor: Colors.transparent,
            leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context)),
          ),
          extendBodyBehindAppBar: true,
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    alignment: Alignment.center,
                    height: size.height * 0.5,
                    child: Image.asset(
                      "assets/images/bck3.png",
                      fit: BoxFit.fill,
                    ),
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        TextFormField(
                          controller: _numberController,
                          validator: (s) {
                            if (widget.signInMethod == SignInMethod.number) {
                              if (s.isEmpty) {
                                return "Enter Phone Number";
                              } else if (!RegExp(r'^[0-9]+$').hasMatch(s)) {
                                return "Number not valid";
                              } else if (s.length != 10) {
                                return "Should be 10 digit number";
                              } else
                                return null;
                            } else {
                              if (RegExp(
                                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                  .hasMatch(s))
                                return null;
                              else
                                return "Email not valid";
                            }
                          },
                          decoration: InputDecoration(
                            isDense: true,
                            labelText:
                                widget.signInMethod == SignInMethod.number
                                    ? "Phone Number"
                                    : "Email",
                            labelStyle: myTs(color: _fontColor),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xff70A7ED)),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            disabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xff70A7ED)),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.red),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xff70A7ED)),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.red),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _passwordController,
                                validator: (s) {
                                  if (s.length < 8)
                                    return "Password length should be atleast 8";
                                  else
                                    return null;
                                },
                                obscureText: _passwordHidden,
                                decoration: InputDecoration(
                                  isDense: true,
                                  labelText: "Password",
                                  labelStyle: myTs(color: _fontColor),
                                  border: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Color(0xff70A7ED)),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  disabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Color(0xff70A7ED)),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Color(0xff70A7ED)),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      Icons.remove_red_eye,
                                      color: _passwordHidden
                                          ? Colors.grey
                                          : Color(0xff70A7ED),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _passwordHidden = !_passwordHidden;
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 30),
                        GestureDetector(
                          onTap: _logging
                              ? null
                              : () async {
                                  if (_formKey.currentState.validate()) {
                                    setState(() {
                                      _logging = true;
                                    });
                                    SignInError error =
                                        await FirebaseFunctions.loginUser(
                                            widget.signInMethod,
                                            _passwordController.value.text,
                                            email: widget.email,
                                            number: widget.number);
                                    if (error == null) {
                                      await AppConfig.init();
                                      Navigator.pop(context);
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => HomePage(),
                                        ),
                                      );
                                    } else if (error ==
                                        SignInError.noUserExist) {
                                      _showErrorMessage(
                                          "No User exists with these credentials");
                                    } else if (error ==
                                        SignInError.passwordIncorrect) {
                                      _showErrorMessage(
                                          "The Password entered is incorrect");
                                    } else if (error == SignInError.unKnown) {
                                      _showErrorMessage(
                                          "An error occured, please try again");
                                    }
                                    setState(() {
                                      _logging = false;
                                    });
                                  }
                                },
                          child: Opacity(
                            opacity: _logging ? 0.2 : 1,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              alignment: Alignment.center,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              width: 130,
                              child: Text(
                                "Login",
                                style: myTs(color: Colors.black, size: 18)
                                    .copyWith(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
