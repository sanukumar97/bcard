import 'package:bcard/utilities/Classes/profileClass.dart';
import 'package:bcard/utilities/Constants/randomConstants.dart';
import 'package:bcard/utilities/localStorage.dart';
import 'package:flutter/material.dart';

Widget logoBox(bool isMine, String logoUrl, ProfileType profileType,
    double logoHeight, double logoWidth) {
  if ((!isMine && logoUrl != null) ||
      (isMine && AppConfig.imageAvailable(2, profileType)))
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: isMine
          ? Image.memory(
              AppConfig.getImageBytes(2, profileType),
              fit: BoxFit.fill,
              height: logoHeight,
              width: logoWidth,
            )
          : Image.network(
              logoUrl,
              fit: BoxFit.fill,
              height: logoHeight,
              width: logoWidth,
            ),
    );
  else
    return Container(
      height: logoHeight,
      width: logoWidth,
      alignment: Alignment.center,
      child: Text(
        "Logo",
        style: myTs(color: Colors.grey, size: 18),
      ),
    );
}
