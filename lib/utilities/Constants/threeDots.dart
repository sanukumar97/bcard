import 'package:bcard/utilities/Constants/randomConstants.dart';
import 'package:flutter/material.dart';

Widget threedots() {
  return Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(
        height: 8,
        width: 8,
        margin: EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
          color: color6,
          shape: BoxShape.circle,
        ),
      ),
      Container(
        height: 8,
        width: 8,
        margin: EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
          color: color6,
          shape: BoxShape.circle,
        ),
      ),
      Container(
        height: 8,
        width: 8,
        margin: EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
          color: color6,
          shape: BoxShape.circle,
        ),
      ),
    ],
  );
}
