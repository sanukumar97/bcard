import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

Future<FirebaseUser> currentUser() async {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  FirebaseUser user = await _firebaseAuth.currentUser();
  return user;
}