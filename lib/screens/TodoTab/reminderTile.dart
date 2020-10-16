import 'package:bcard/screens/TodoTab/reminderOptions.dart';
import 'package:bcard/utilities/Classes/profileClass.dart';
import 'package:bcard/utilities/Classes/reminderClass.dart';
import 'package:bcard/utilities/Constants/encodersAndDecoders.dart';
import 'package:bcard/utilities/Constants/randomConstants.dart';
import 'package:bcard/utilities/firebaseFunctions.dart';
import 'package:bcard/utilities/localStorage.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ReminderTile extends StatefulWidget {
  final Reminder reminder;
  final double height, width;
  final Function(Widget bottomSheet) showBottomSheet;
  final Function(Profile) openProfile;
  final bool isTop;
  bool selected;
  ReminderTile(this.reminder, this.height, this.width, this.showBottomSheet,
      this.isTop, this.openProfile,
      {this.selected});
  @override
  _ReminderTileState createState() => _ReminderTileState();
}

class _ReminderTileState extends State<ReminderTile> {
  bool _loaded = false;
  List<Profile> _profiles = [];

  void _getProfiles() async {
    int len = widget.reminder.cardIds.length;
    List<String> _tempList = [];
    for (int i = 0; i < len; i++) {
      _tempList.add(widget.reminder.cardIds[i]);
      if (_tempList.length == 10) {
        _profiles.addAll(await FirebaseFunctions.getProfiles(_tempList));
        _tempList.clear();
      }
    }
    if (_tempList.isNotEmpty) {
      _profiles.addAll(await FirebaseFunctions.getProfiles(_tempList));
      _tempList.clear();
    }
    setState(() {
      _loaded = true;
    });
  }

  void _markAsDone(bool value) async {
    setState(() {
      widget.reminder.completed = value;
    });
    await Future.delayed(Duration(milliseconds: 1000));
    widget.reminder.ref?.updateData({"completed": value});
  }

  void _openOptions() {
    Set<String> profileIds = new Set<String>();
    AppConfig.me.cardLibraries.forEach((lib) {
      profileIds.addAll(lib.profileIds);
    });
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(15),
        ),
      ),
      barrierColor: Colors.black54,
      backgroundColor: color2,
      isScrollControlled: true,
      enableDrag: true,
      builder: (context) =>
          ReminderOptionBottomSheet(widget.reminder, profileIds.toList()),
    );
    /* widget.showBottomSheet(
        ReminderOptionBottomSheet(widget.reminder, profileIds.toList())); */
  }

  @override
  void didUpdateWidget(ReminderTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _getProfiles();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: _loaded
          ? Container(
              height: widget.height,
              width: widget.width,
              constraints: BoxConstraints(
                minHeight: widget.height,
              ),
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              decoration: BoxDecoration(
                color: widget.reminder.color,
                borderRadius: BorderRadius.circular(10),
              ),
              foregroundDecoration: BoxDecoration(
                color: (widget.selected ?? false)
                    ? color4.withOpacity(0.4)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 50,
                        width: widget.width - 30 - Checkbox.width * 1.5 - 45,
                        margin: EdgeInsets.only(bottom: widget.isTop ? 5 : 0),
                        child: PageView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _profiles.isEmpty ? 1 : _profiles.length,
                          itemBuilder: (context, i) {
                            if (_profiles.isEmpty)
                              return Text(
                                "My Reminder",
                                style: myTs(
                                    color: color5,
                                    size: 15,
                                    fontWeight: FontWeight.bold),
                              );
                            return GestureDetector(
                              onTap: () {
                                widget.openProfile(_profiles[i]);
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _profiles[i].name ?? "Name",
                                    style: myTs(
                                        color: color5,
                                        size: 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    _profiles[i].occupation ?? "Occupation",
                                    style: myTs(color: color5, size: 10),
                                  ),
                                  widget.isTop
                                      ? Container(
                                          height: 20,
                                          margin: EdgeInsets.only(right: 5),
                                          child: ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            itemCount: _profiles[i].tags.length,
                                            itemBuilder: (context, j) {
                                              return GestureDetector(
                                                child: Container(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 0),
                                                  margin: EdgeInsets.symmetric(
                                                      vertical: 2,
                                                      horizontal: 2),
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    color: color3,
                                                  ),
                                                  child: Text(
                                                    "#" + _profiles[i].tags[j],
                                                    style: myTs(
                                                        color: color5,
                                                        size: 12),
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        )
                                      : SizedBox(),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      Spacer(),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: Container(
                          height: Checkbox.width * 1.5,
                          width: Checkbox.width * 1.5,
                          color: color1,
                          child: Theme(
                            data: ThemeData(
                              unselectedWidgetColor: Colors.transparent,
                            ),
                            child: Checkbox(
                              value: widget.reminder.completed,
                              onChanged: (val) {
                                _markAsDone(val);
                                setState(() {
                                  widget.reminder.completed = val;
                                });
                              },
                              activeColor: color1,
                              checkColor: color4,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      GestureDetector(
                        child: Icon(
                          Icons.more_vert,
                          color: color5,
                          size: 25,
                        ),
                        onTap: _openOptions,
                      ),
                    ],
                  ),
                  Container(
                    height: widget.height - (widget.isTop ? 90 : 85),
                    alignment: Alignment.topLeft,
                    child: SingleChildScrollView(
                      primary: true,
                      physics: BouncingScrollPhysics(),
                      child: Text(
                        widget.reminder.description,
                        softWrap: true,
                        maxLines: 8,
                        overflow: TextOverflow.ellipsis,
                        style: myTs(color: color5, size: 15),
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.bottomRight,
                    child: Text(
                      timeString(
                        TimeOfDay.fromDateTime(widget.reminder.date),
                      ),
                      style: myTs(color: color5.withOpacity(0.4), size: 12),
                    ),
                  ),
                ],
              ),
            )
          : Shimmer.fromColors(
              child: Container(
                decoration: BoxDecoration(
                  color: color5,
                  borderRadius: BorderRadius.circular(10),
                ),
                height: widget.height,
                width: widget.width,
              ),
              baseColor: color5.withOpacity(0.6),
              highlightColor: color5.withOpacity(0.2),
            ),
    );
  }
}
