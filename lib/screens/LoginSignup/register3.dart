import 'package:bcard/screens/homepage.dart';
import 'package:bcard/utilities/Classes/userClass.dart';
import 'package:bcard/utilities/Constants/randomConstants.dart';
import 'package:bcard/utilities/firebaseFunctions.dart';
import 'package:bcard/utilities/localStorage.dart';
import 'package:flutter/material.dart';

class UserDetailsPage extends StatefulWidget {
  final SignInMethod signInMethod;
  final String number, email, name;
  UserDetailsPage(
      {this.number, this.email, this.name, @required this.signInMethod});
  @override
  _UserDetailsPageState createState() => new _UserDetailsPageState();
}

class _UserDetailsPageState extends State<UserDetailsPage> {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  Color _fontColor = Color(0xff4D4F50);
  TextEditingController _nameController,
      _emailController,
      _passwordController,
      _confirmPasswordController;
  bool _passwordHidden = true, _confirmPasswordHidden = true;
  bool _registering = false;

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
  void initState() {
    super.initState();
    _nameController = new TextEditingController(text: widget.name);
    _emailController = new TextEditingController(text: widget.email);
    _passwordController = new TextEditingController();
    _confirmPasswordController = new TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: SafeArea(
        child: new Scaffold(
          backgroundColor: Color(0xffE6EbEF),
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
            elevation: 0.0,
            backgroundColor: Colors.transparent,
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
                    height: size.height * 0.4,
                    child: Image.asset(
                      "assets/images/bck2.png",
                      fit: BoxFit.fill,
                    ),
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Sign Up",
                            style: myTs(color: _fontColor, size: 25)
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(height: 10),
                        TextFormField(
                          controller: _nameController,
                          validator: (s) {
                            if (s.isEmpty)
                              return "Name cannot be empty";
                            else
                              return null;
                          },
                          decoration: InputDecoration(
                            isDense: true,
                            labelText: "Company/User Name",
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
                        TextFormField(
                          controller: _emailController,
                          validator: (s) {
                            if (s.isEmpty ||
                                (s.isNotEmpty &&
                                    RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                        .hasMatch(s)))
                              return null;
                            else
                              return "Email not valid";
                          },
                          decoration: InputDecoration(
                            isDense: true,
                            labelText: "Email (Optional)",
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
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _confirmPasswordController,
                                validator: (s) {
                                  if (_passwordController.value.text != s)
                                    return "Passwords do not match!";
                                  else
                                    return null;
                                },
                                obscureText: _confirmPasswordHidden,
                                decoration: InputDecoration(
                                  isDense: true,
                                  labelText: "Confirm Password",
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
                                      color: _confirmPasswordHidden
                                          ? Colors.grey
                                          : Color(0xff70A7ED),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _confirmPasswordHidden =
                                            !_confirmPasswordHidden;
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 25),
                        GestureDetector(
                          onTap: _registering
                              ? null
                              : () async {
                                  if (_formKey.currentState.validate()) {
                                    setState(() {
                                      _registering = true;
                                    });
                                    if (await FirebaseFunctions
                                        .checkEmailExists(
                                            _emailController.value.text)) {
                                      _showErrorMessage(
                                          "Email already exists! Please Log In.");
                                    } else {
                                      User user = new User(
                                          _emailController.value.text,
                                          _nameController.value.text,
                                          widget.number,
                                          null);
                                      await FirebaseFunctions.registerUser(
                                          user, _passwordController.value.text);
                                      AppConfig.me = user;
                                      Navigator.pop(context);
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => HomePage(),
                                        ),
                                      );
                                      setState(() {
                                        _registering = false;
                                      });
                                    }
                                  }
                                },
                          child: Opacity(
                            opacity: _registering ? 0.2 : 1,
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
                                "Next",
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
