import 'package:bcard/utilities/Classes/MessageClasses/textMessageClass.dart';
import 'package:bcard/utilities/Constants/randomConstants.dart';
import 'package:bcard/utilities/firebaseFunctions.dart';
import 'package:bcard/utilities/localStorage.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

class FeedBackDialog extends StatelessWidget {
  TextEditingController _controller = new TextEditingController();

  void _submit(BuildContext context) {
    if (_controller.value.text.isNotEmpty) {
      TextMessage message = new TextMessage(
          AppConfig.currentProfile.id, adminProfileId, _controller.value.text);
      FirebaseFunctions.sendMessage(message);
      Navigator.pop(context);
    } else {
      appToast("Please enter some feedback message", context,
          gravity: Toast.BOTTOM);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: color2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      actionsPadding: EdgeInsets.symmetric(horizontal: 10),
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Feedback",
            style: myTs(color: color5, size: 24),
          ),
          SizedBox(width: 15),
          Icon(
            Icons.feedback,
            color: color5,
          ),
        ],
      ),
      content: TextFormField(
        controller: _controller,
        minLines: 5,
        maxLines: 7,
        style: myTs(color: color5, size: 16),
        decoration: InputDecoration(
          hintText: "Enter Feedback message...",
          hintStyle: myTs(color: color5.withOpacity(0.5), size: 16),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
        ),
      ),
      actions: [
        FlatButton(
          onPressed: () {
            _submit(context);
          },
          child: Text(
            "Submit",
            style: myTs(color: color4, size: 18),
          ),
        ),
      ],
    );
  }
}
