import 'dart:core';

class CreateUserModel {
  String _username;
  String _email;
  String _password;
  String _designation;

  CreateUserModel(String username, String email, String password, String designation){
    _username = username;
    _email = email;
    _password = password;
    _designation = designation;
  }

  String get username => _username;
  String get email => _email;
  String get password => _password;
  String get designation => _designation;
}