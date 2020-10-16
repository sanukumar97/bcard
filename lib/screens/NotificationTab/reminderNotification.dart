import 'package:bcard/utilities/Classes/NotificationClasses/reminderNotificationClass.dart';
import 'package:bcard/utilities/Classes/profileClass.dart';
import 'package:bcard/utilities/Classes/reminderClass.dart';
import 'package:bcard/utilities/Constants/encodersAndDecoders.dart';
import 'package:bcard/utilities/Constants/randomConstants.dart';
import 'package:bcard/utilities/firebaseFunctions.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:bcard/utilities/Constants/logoBox.dart';

class ReminderNotificationTile extends StatefulWidget {
  final ReminderNotification reminder;
  final Function(String reminderId) showNotificationReminder;
  ReminderNotificationTile(this.reminder, this.showNotificationReminder);
  @override
  _ReminderNotificationTileState createState() =>
      _ReminderNotificationTileState();
}

class _ReminderNotificationTileState extends State<ReminderNotificationTile> {
  Profile _senderprofile;
  bool _loaded = false;
  Reminder _reminder;

  void _getDetails() async {
    _senderprofile =
        await FirebaseFunctions.getProfile(widget.reminder.senderProfileId);
    _reminder = await FirebaseFunctions.getReminder(widget.reminder.reminderId);
    if (_reminder == null) {
      widget.reminder.ref?.delete();
    }
    setState(() {
      _loaded = true;
    });
  }

  @override
  void initState() {
    super.initState();
    _getDetails();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    if (_reminder != null || !_loaded)
      return GestureDetector(
        onTap: _loaded
            ? () {
                widget.showNotificationReminder(widget.reminder.reminderId);
              }
            : null,
        child: Container(
          height: 90,
          margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: _loaded
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: color5.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: logoBox(
                          false,
                          _senderprofile?.logoUrl,
                          _senderprofile?.profileType,
                          size.width * 0.23,
                          size.width * 0.23),
                    ),
                    SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          RichText(
                            text: TextSpan(
                              children: <TextSpan>[
                                TextSpan(
                                  text: _senderprofile?.name ?? "Name",
                                  style: myTs(
                                    color: color5,
                                    size: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                TextSpan(
                                  text:
                                      " (${_senderprofile?.occupation ?? "Occupation"})",
                                  style: myTs(
                                    color: color5,
                                    size: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          RichText(
                            text: TextSpan(
                              children: <TextSpan>[
                                TextSpan(
                                  text: "Shared Reminder",
                                  style: myTs(
                                    color: color4,
                                    size: 16,
                                  ),
                                ),
                                TextSpan(
                                  text: " with you",
                                  style: myTs(
                                    color: color5,
                                    size: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            alignment: Alignment.bottomRight,
                            child: Text(
                              timeString(
                                TimeOfDay.fromDateTime(widget.reminder.date),
                              ),
                              style: myTs(
                                color: color5.withOpacity(0.3),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              : Shimmer.fromColors(
                  child: Container(
                    decoration: BoxDecoration(
                      color: color5,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    height: 204,
                    width: double.maxFinite,
                  ),
                  baseColor: color5.withOpacity(0.6),
                  highlightColor: color5.withOpacity(0.2),
                ),
        ),
      );
    else
      return SizedBox();
  }
}
