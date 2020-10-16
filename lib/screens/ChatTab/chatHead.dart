import 'package:bcard/utilities/Classes/MessageClasses/messageClass.dart';
import 'package:bcard/utilities/Classes/MessageClasses/textMessageClass.dart';
import 'package:bcard/utilities/Classes/profileClass.dart';
import 'package:bcard/utilities/Constants/logoBox.dart';
import 'package:bcard/utilities/Constants/randomConstants.dart';
import 'package:flutter/material.dart';

class ChatHead extends StatelessWidget {
  final Profile _profile;
  final Message _lastMessage;
  ChatHead(this._profile, this._lastMessage);
  @override
  Widget build(BuildContext context) {
    String _messageText;
    if (_lastMessage.type == MessageType.text)
      _messageText = (_lastMessage as TextMessage).text ?? "";
    else if (_lastMessage.type == MessageType.image)
      _messageText = "Image";
    else if (_lastMessage.type == MessageType.reminder)
      _messageText = "Reminder";

    var size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Row(
        children: [
          Container(
            margin: EdgeInsets.only(right: 15),
            child: Container(
              decoration: BoxDecoration(
                color: color5.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: logoBox(false, _profile?.logoUrl, _profile?.profileType,
                  size.width * 0.23, size.width * 0.23),
            ),
          ),
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        text: _profile?.name ?? _profile?.companyName ?? "Name",
                        style: myTs(color: color5, size: 20),
                      ),
                      /* TextSpan(
                        text: _profile?.occupation ?? "Occupation",
                        style: myTs(color: color5, size: 13),
                      ), */
                    ],
                  ),
                ),
                _lastMessage != null
                    ? Container(
                        width: size.width * 0.77 - 45,
                        child: Text(
                          _messageText,
                          style: myTs(color: color5, size: 13),
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                        ),
                      )
                    : SizedBox(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
