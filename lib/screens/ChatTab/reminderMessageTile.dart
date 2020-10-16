import 'package:bcard/utilities/Classes/MessageClasses/reminderMessageClass.dart';
import 'package:bcard/utilities/Classes/profileClass.dart';
import 'package:bcard/utilities/Classes/reminderClass.dart';
import 'package:bcard/utilities/Constants/encodersAndDecoders.dart';
import 'package:bcard/utilities/Constants/logoBox.dart';
import 'package:bcard/utilities/Constants/randomConstants.dart';
import 'package:bcard/utilities/firebaseFunctions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:bcard/utilities/localStorage.dart';
import 'package:shimmer/shimmer.dart';

class ReminderMessageTile extends StatefulWidget {
  final ReminderMessage reminderMessage;
  final Profile profile;
  ReminderMessageTile(this.reminderMessage, this.profile);
  @override
  _ReminderMessageTileState createState() => _ReminderMessageTileState();
}

class _ReminderMessageTileState extends State<ReminderMessageTile> {
  Reminder _reminder;
  bool _loaded = false;

  void _getReminder() async {
    _reminder =
        await FirebaseFunctions.getReminder(widget.reminderMessage.reminderId);
    setState(() {
      _loaded = true;
    });
    if (_reminder == null) {
      widget.reminderMessage.ref?.delete();
    }
  }

  @override
  void initState() {
    super.initState();
    _getReminder();
  }

  @override
  Widget build(BuildContext context) {
    print(AppConfig.me.businessDocId);
    print(AppConfig.me.personalDocId);
    bool _iAmSender =
        AppConfig.currentProfile.id == widget.reminderMessage.senderProfileId;
    if (_reminder != null || !_loaded)
      return Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: LinearGradient(
            colors: [
              Color(0xff865e37),
              Color(0xffc1976b),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: ListTile(
          leading: logoBox(
              false,
              _iAmSender
                  ? AppConfig.currentProfile.logoUrl
                  : widget.profile.logoUrl,
              widget.profile.profileType,
              40,
              40),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RichText(
                text: TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                      text: _iAmSender
                          ? AppConfig.currentProfile.name ??
                              AppConfig.currentProfile.companyName ??
                              "Name"
                          : widget.profile?.name ??
                              widget.profile?.companyName ??
                              "Name",
                      style: myTs(
                          color: color5, size: 18, fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: "   " +
                          timeString(TimeOfDay.fromDateTime(
                              widget.reminderMessage.date)),
                      style: myTs(color: color5.withOpacity(0.5), size: 12),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: SvgPicture.asset(
                  "assets/icons/followup_ns2.svg",
                  height: 25,
                  width: 25,
                ),
                onPressed: null,
              ),
            ],
          ),
          /* TextSpan(
                text: "   " +
                    timeString(
                        TimeOfDay.fromDateTime(widget.reminderMessage.date)),
                style: myTs(color: Colors.grey.withOpacity(0.5), size: 12),
              ), */
          subtitle: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _loaded
                  ? Container(
                      constraints: BoxConstraints(minHeight: 60),
                      width: double.maxFinite,
                      margin: EdgeInsets.symmetric(vertical: 10),
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Color(0xfffff9C7),
                      ),
                      child: Text(
                        _reminder.description,
                        style: myTs(color: color1, size: 15),
                      ),
                    )
                  : Shimmer.fromColors(
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: color5,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        height: 100,
                      ),
                      baseColor: color5.withOpacity(0.6),
                      highlightColor: color5.withOpacity(0.2),
                    ),
              _reminderStatusWidget(),
            ],
          ),
        ),
      );
    else
      return SizedBox();
  }

  Widget _reminderStatusWidget() {
    void _setStatus(ReminderMessageStatus status) {
      widget.reminderMessage.ref.updateData({"status": status.index});
    }

    return Container(
      margin: EdgeInsets.only(bottom: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          GestureDetector(
            onTap: () {
              _setStatus(ReminderMessageStatus.itsDone);
            },
            child: Container(
              height: 25,
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.5),
                color: color1,
              ),
              child: Text(
                "Its done",
                style: myTs(
                    color: widget.reminderMessage.status ==
                            ReminderMessageStatus.itsDone
                        ? color4
                        : color5,
                    size: 15),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              _setStatus(ReminderMessageStatus.willDo);
            },
            child: Container(
              height: 25,
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.5),
                color: color1,
              ),
              child: Text(
                "Will Do",
                style: myTs(
                    color: widget.reminderMessage.status ==
                            ReminderMessageStatus.willDo
                        ? color4
                        : color5,
                    size: 15),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              _setStatus(ReminderMessageStatus.notNow);
            },
            child: Container(
              height: 25,
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.5),
                color: color1,
              ),
              child: Text(
                "Not Now",
                style: myTs(
                    color: widget.reminderMessage.status ==
                            ReminderMessageStatus.notNow
                        ? color4
                        : color5,
                    size: 15),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
