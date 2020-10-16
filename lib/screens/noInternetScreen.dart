import 'package:flutter/material.dart';

class NoInternetScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child:
            Text("No Internet found!!\nPlease check your internet connection"),
      ),
    );
  }
}
