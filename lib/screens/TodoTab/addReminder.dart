import 'dart:math';
import 'package:bcard/screens/TodoTab/selectProfile.dart';
import 'package:bcard/utilities/Classes/profileClass.dart';
import 'package:bcard/utilities/Classes/reminderClass.dart';
import 'package:flutter_svg/svg.dart';
import 'package:bcard/utilities/Constants/randomConstants.dart';
import 'package:bcard/utilities/firebaseFunctions.dart';
import 'package:bcard/utilities/localStorage.dart';
import 'package:flutter/material.dart';
import 'package:bcard/utilities/Constants/logoBox.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AddReminderDialog extends StatefulWidget {
  final Function(Reminder) onAddition;
  final List<Profile> profilesAdded;
  AddReminderDialog({this.onAddition, this.profilesAdded});
  @override
  _AddReminderDialogState createState() => _AddReminderDialogState();
}

class _AddReminderDialogState extends State<AddReminderDialog> {
  List<Profile> _cards = [], _profilesPinned = [];
  DateTime _date;
  TextEditingController _controller = new TextEditingController();
  FocusNode _node = new FocusNode();

  void _selectDate() async {
    DateTime _today = DateTime.now();
    DateTime _dt = await showDatePicker(
      context: context,
      initialDate: _date ?? _today,
      firstDate: _today,
      lastDate: _today.add(Duration(days: 30 * 12)),
      currentDate: _date,
      initialEntryMode: DatePickerEntryMode.calendar,
      initialDatePickerMode: DatePickerMode.day,
    );
    if (_dt != null) {
      TimeOfDay _time =
          await showTimePicker(context: context, initialTime: TimeOfDay.now());
      if (_time != null) {
        setState(() {
          _date = new DateTime(
              _dt.year, _dt.month, _dt.day, _time.hour, _time.minute, 0, 0, 0);
        });
      }
    }
  }

  void _addCard() async {
    void profileSelected(List<Profile> selectedProfiles) {
      _cards.clear();
      setState(() {
        _cards = List.from(selectedProfiles);
      });
    }

    Set<String> profileIds = new Set<String>();
    AppConfig.me.cardLibraries.forEach((lib) {
      profileIds.addAll(lib.profileIds);
    });
    showDialog(
      context: context,
      builder: (context) =>
          SelectProfileDialog(profileIds.toList(), profileSelected, _cards),
    );
  }

  void _pinProfile() async {
    void profileSelected(List<Profile> selectedProfiles) {
      _profilesPinned.clear();
      setState(() {
        _profilesPinned = List.from(selectedProfiles);
      });
    }

    Set<String> profileIds = new Set<String>();
    AppConfig.me.cardLibraries.forEach((lib) {
      profileIds.addAll(lib.profileIds);
    });
    showDialog(
      context: context,
      builder: (context) => SelectProfileDialog(
          profileIds.toList(), profileSelected, _profilesPinned),
    );
  }

  bool _validate() {
    if (_date == null) {
      appToast("Select a date for the reminder", context);
      return false;
    } else if (_controller.value.text.isEmpty) {
      appToast("Add some details to the reminder", context);
      return false;
    } else {
      return true;
    }
  }

  void _onDone() async {
    if (_validate()) {
      List<String> cardIds = _cards.map<String>((prf) => prf.id).toList(),
          profilesPinned =
              _profilesPinned.map<String>((prf) => prf.id).toList();
      List<Reminder> reminders = [];
      profilesPinned.forEach((prf) {
        reminders.add(new Reminder(_date, AppConfig.currentProfile.id,
            _controller.value.text.trim(), cardIds, false, prf));
      });
      if (reminders.isEmpty)
        reminders.add(new Reminder(_date, AppConfig.currentProfile.id,
            _controller.value.text.trim(), cardIds, false, null));
      await FirebaseFunctions.addReminders(reminders);
      if (widget.onAddition != null) {
        widget.onAddition(reminders.last);
      }
      Navigator.pop(context);
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.profilesAdded != null) {
      _cards = List<Profile>.from(widget.profilesAdded);
    }
  }

  @override
  Widget build(BuildContext context) {
    String _cardsString = "";
    if (_cards.isNotEmpty) {
      _cards.forEach((prf) {
        _cardsString += (prf.name ?? "Name") + ", ";
      });
      _cardsString = _cardsString.substring(0, _cardsString.length - 2);
    }
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      scrollable: true,
      backgroundColor: color2,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: _addCard,
            child: Container(
              margin: EdgeInsets.all(15),
              padding: EdgeInsets.all(5),
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(width: 0.4, color: color1),
                color: color3,
              ),
              child: _cards.isNotEmpty
                  ? Text(
                      _cardsString,
                      overflow: TextOverflow.ellipsis,
                      style: myTs(color: color5, size: 15),
                    )
                  : Row(
                      children: [
                        Icon(
                          Icons.add,
                          color: color5,
                        ),
                        SizedBox(width: 10),
                        Text(
                          "Add Card",
                          style: myTs(color: color5, size: 15),
                        )
                      ],
                    ),
            ),
          ),
          Divider(
            thickness: 0.5,
            indent: 15,
            endIndent: 15,
            color: color1.withOpacity(0.4),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 15),
            child: TextFormField(
              controller: _controller,
              focusNode: _node,
              minLines: 10,
              maxLines: 10,
              style: myTs(color: color5, size: 15),
              decoration: InputDecoration(
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  focusedErrorBorder: InputBorder.none,
                  hintText: "Add Reminder...",
                  hintStyle: myTs(color: color5, size: 15)),
            ),
          ),
          Divider(
            thickness: 0.5,
            indent: 15,
            endIndent: 15,
            color: color1.withOpacity(0.4),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Row(
              children: [
                IconButton(
                  icon: SvgPicture.asset("assets/icons/clock.svg"),
                  onPressed: _selectDate,
                  iconSize: 35,
                ),
                IconButton(
                  icon: SvgPicture.asset("assets/icons/recommend2.svg"),
                  color: color1,
                  onPressed: _pinProfile,
                  iconSize: 35,
                ),
                Builder(
                  builder: (context) {
                    List<Profile> _dispCard = _profilesPinned.sublist(
                        0, min(4, _profilesPinned.length));
                    return Container(
                      width: _dispCard.length * 30.0 -
                          ((_dispCard.length - 1) * 20.0),
                      height: 30.0,
                      child: Stack(
                        children: List<Widget>.generate(_dispCard.length, (i) {
                          return Positioned(
                            left: max(0, i) * 10.0,
                            child: ClipOval(
                              child: logoBox(false, _dispCard[i].logoUrl,
                                  _dispCard[i].profileType, 30.0, 30.0),
                            ),
                          );
                        }).reversed.toList(),
                      ),
                    );
                  },
                ),
                Spacer(),
                GestureDetector(
                  onTap: _onDone,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: color3,
                    ),
                    child: Text(
                      "Done",
                      style: myTs(color: color5, size: 18),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
