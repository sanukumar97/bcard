import 'package:flutter/material.dart';

void showLoading(BuildContext context, String message){
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context){
      return Dialog(
        child: new Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(4.0),
            ),
            CircularProgressIndicator(),
            Padding(
              padding: EdgeInsets.all(4.0),
            ),
            Text(message),
            Padding(
              padding: EdgeInsets.all(4.0),
            ),
          ],
        )
      );
    }
  );
}