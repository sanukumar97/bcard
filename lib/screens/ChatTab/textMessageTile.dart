

import 'package:bcard/utilities/Classes/MessageClasses/textMessageClass.dart';
import 'package:bcard/utilities/Classes/profileClass.dart';
import 'package:bcard/utilities/Constants/encodersAndDecoders.dart';
import 'package:bcard/utilities/Constants/logoBox.dart';
import 'package:bcard/utilities/Constants/randomConstants.dart';
import 'package:bcard/utilities/localStorage.dart';
import 'package:flutter/material.dart';

class TextMessageTile extends StatelessWidget {
  final TextMessage textMessage;
  final Profile profile;
  TextMessageTile(this.textMessage, this.profile);
  @override
  Widget build(BuildContext context) {
    bool _iAmSender =
        AppConfig.currentProfile.id == textMessage.senderProfileId;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        leading: logoBox(false, profile.logoUrl, profile.profileType, 40, 40),
        title: RichText(
          text: TextSpan(
            children: <TextSpan>[
              TextSpan(
                text: _iAmSender
                    ? AppConfig.currentProfile.name ??
                        AppConfig.currentProfile.companyName ??
                        "Name"
                    : profile?.name ?? profile?.companyName ?? "Name",
                style:
                    myTs(color: color5, size: 18, fontWeight: FontWeight.bold),
              ),
              TextSpan(
                text: "   " +
                    timeString(TimeOfDay.fromDateTime(textMessage.date)),
                style: myTs(color: Colors.grey.withOpacity(0.5), size: 12),
              ),
            ],
          ),
        ),
        subtitle: Text(
          textMessage.text,
          style: myTs(color: color5, size: 15),
        ),
      ),
    );
  }
}
