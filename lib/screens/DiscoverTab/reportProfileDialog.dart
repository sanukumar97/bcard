import 'package:bcard/utilities/Classes/profileClass.dart';
import 'package:bcard/utilities/Classes/reportClass.dart';
import 'package:bcard/utilities/firebaseFunctions.dart';
import 'package:bcard/utilities/Constants/randomConstants.dart';
import 'package:bcard/utilities/localStorage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/cupertino.dart';

class ReportProfileDialog extends StatelessWidget {
  final Profile profile;
  TextEditingController _controller = new TextEditingController();
  ReportProfileDialog(this.profile);

  void _report(BuildContext context) {
    if (_controller.value.text.isNotEmpty) {
      Report report = new Report(
          profile.id, AppConfig.currentProfile.id, _controller.value.text);
      FirebaseFunctions.reportProfile(report);
      appToast("Profile Reported.", context, color: color4);
      Navigator.pop(context);
    } else {
      appToast("Add some report message", context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      backgroundColor: color2,
      titlePadding: EdgeInsets.only(bottom: 5, left: 15, top: 20),
      title: Text(
        "Report ${profile.name ?? "this Profile"}",
        style: myTs(color: color5, size: 20, fontWeight: FontWeight.bold),
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      content: TextFormField(
        controller: _controller,
        style: myTs(color: color5, size: 16),
        minLines: 8,
        maxLines: 8,
        decoration: InputDecoration(
          hintText: "Report Profile",
          hintStyle: myTs(color: color5.withOpacity(0.3), size: 16),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
        ),
      ),
      actionsPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      actions: [
        GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            margin: EdgeInsets.symmetric(horizontal: 5),
            child: Text(
              "Cancel",
              style: myTs(color: color5, size: 16),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            _report(context);
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            margin: EdgeInsets.symmetric(horizontal: 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: color3,
            ),
            child: Text(
              "Report",
              style: myTs(color: color5, size: 16),
            ),
          ),
        ),
      ],
    );
  }
}
