import '../models/user.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

dynamic loginUser(BuildContext context, CreateUserModel createUserModel) async {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  
  try {
    AuthResult result = await _firebaseAuth.signInWithEmailAndPassword(
      email: createUserModel.email,
      password: createUserModel.password
    );

    Navigator.pop(context);
    print(result.user.uid);

    return null;

  } catch(e) {

    Navigator.pop(context);
    return e.message;
  }
}

dynamic createUser(BuildContext context, CreateUserModel createUserModel) async {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  
  try {
    AuthResult result = await _firebaseAuth.createUserWithEmailAndPassword(
      email: createUserModel.email,
      password: createUserModel.password
    );

    Navigator.pop(context);
    print(result.user.uid);

    Firestore.instance.collection("user").document().setData({
      "uid": result.user.uid,
      "username": createUserModel.username,
      "email": createUserModel.email,
      "designation": createUserModel.designation
    });

    if(!result.user.isEmailVerified){
      result.user.sendEmailVerification();
    }



    return null;

  } catch(e) {

    Navigator.pop(context);
    return e.message;
  }
}