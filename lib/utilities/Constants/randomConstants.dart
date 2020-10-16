import 'package:bcard/utilities/Classes/profileClass.dart';
import 'package:bcard/utilities/localStorage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:toast/toast.dart';

final String adminProfileId = "admin";

Function({String recieverProfileId}) openChat;
Function() goBackFromChatPage;
Function() reloadChatPage;
Function(String reminderId) goToTodoPage;
bool _newMessageBus = false, _newMessagePers = false;

bool get newMessage {
  if (AppConfig.currentProfile.profileType == ProfileType.business)
    return _newMessageBus;
  else
    return _newMessagePers;
}

void setNewMessage(ProfileType profileType, bool val) {
  print("done");
  if (profileType == ProfileType.business)
    _newMessageBus = val;
  else
    _newMessagePers = val;
}

TextStyle myTs(
        {Color color,
        double size,
        FontWeight fontWeight,
        FontStyle fontStyle}) =>
    TextStyle(
        color: color,
        fontSize: size,
        fontWeight: fontWeight,
        fontStyle: fontStyle);

Color color1 = Color(0xff16202C),
    color2 = Color(0xff1D2733),
    color3 = Color(0xff2B394A),
    color4 = Color(0xff5EB8F3),
    color5 = Color(0xffffffff),
    color6 = Color(0xffE5E8EE);

final List<Color> reminderColors = [
  Color(0xff2b394a),
  Color(0xff02552b),
  Color(0xffeeb0a3),
  Color(0xff4a4a2b),
  Color(0xff503a65),
  Color(0xff84c8d5),
  Color(0xfffdcfe9),
  Color(0xff01a698),
  Color(0xfff45c51),
];

void appToast(String message, BuildContext context,
    {Color color, int gravity}) {
  Toast.show(
    message,
    context,
    backgroundRadius: 20,
    gravity: gravity ?? Toast.CENTER,
    duration: Toast.LENGTH_LONG,
    backgroundColor: color ?? Colors.red,
    textColor: color5,
  );
}

double getTextWidth(
    String text, TextStyle style, BoxConstraints constraints, double height) {
  RenderParagraph renderParagraph = new RenderParagraph(
    TextSpan(
      text: text,
      style: style,
    ),
    textDirection: TextDirection.ltr,
  );
  renderParagraph.layout(constraints);
  return renderParagraph.getMaxIntrinsicWidth(height).ceilToDouble();
}
