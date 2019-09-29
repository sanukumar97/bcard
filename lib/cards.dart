import 'package:flutter/material.dart';

class CardsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
        children: <Widget>[
          Card(
            child: Text("Sanket Chaudhari")
          ),
          Card(
            child: Text("The Chainsmokers")
          )
        ]
      )
    );
  }
}