import 'package:bcard/screens/TodoTab/reminderProfileTile.dart';
import 'package:bcard/utilities/Classes/MessageClasses/reminderMessageClass.dart';
import 'package:bcard/utilities/Classes/profileClass.dart';
import 'package:bcard/utilities/Classes/reminderClass.dart';
import 'package:bcard/utilities/Constants/encodersAndDecoders.dart';
import 'package:flutter_svg/svg.dart';
import 'package:bcard/utilities/Constants/randomConstants.dart';
import 'package:bcard/utilities/firebaseFunctions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shimmer/shimmer.dart';

class ReminderOptionBottomSheet extends StatefulWidget {
  final Reminder reminder;
  final List<String> profileIds;
  ReminderOptionBottomSheet(this.reminder, this.profileIds);
  @override
  _ReminderOptionBottomSheetState createState() =>
      _ReminderOptionBottomSheetState();
}

class _ReminderOptionBottomSheetState extends State<ReminderOptionBottomSheet>
    with SingleTickerProviderStateMixin {
  TextEditingController _controller1 = new TextEditingController(),
      _controller2 = new TextEditingController();
  TabController _tabController;
  List<List<Profile>> _queryProfiles = [[], []];
  List<Profile> _allProfiles = [];
  bool _loaded = false;

  void _selectColor(Color color) {
    widget.reminder.ref.update({"color": colorEncoder(color)});
    Navigator.pop(context);
  }

  void _sendReminder(Profile profile) async {
    Reminder reminder = new Reminder(
        widget.reminder.date,
        widget.reminder.ownerId,
        widget.reminder.description,
        widget.reminder.cardIds,
        false,
        profile.id);
    await FirebaseFunctions.addReminders([reminder]);
    appToast("Reminder Shared", context, color: color4);
  }

  void _followUpReminder(Profile profile) async {
    ReminderMessage reminderMessage = new ReminderMessage(
        widget.reminder.ownerId, profile.id, widget.reminder.id);
    await FirebaseFunctions.sendMessage(reminderMessage);
    appToast("Follow-up Message Sent", context, color: color4);
  }

  void _getProfiles() async {
    List<String> _temp = [];
    for (int i = 0; i < widget.profileIds.length; i++) {
      _temp.add(widget.profileIds[i]);
      if (_temp.length == 10) {
        var list = await FirebaseFunctions.getProfiles(_temp);
        _allProfiles.addAll(list);
        setState(() {
          _queryProfiles[0].addAll(list);
          _queryProfiles[1].addAll(list);
        });
        _temp.clear();
      }
    }
    if (_temp.isNotEmpty) {
      var list = await FirebaseFunctions.getProfiles(_temp);
      _allProfiles.addAll(list);
      setState(() {
        _queryProfiles[0].addAll(list);
        _queryProfiles[1].addAll(list);
        _loaded = true;
      });
      _temp.clear();
    }
  }

  void _query(String query, int i) {
    setState(() {
      _queryProfiles[i] = _allProfiles.where((prf) {
        return (prf.name ?? "").toLowerCase().contains(query.toLowerCase()) ||
            (prf.occupation ?? "").toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });
    _getProfiles();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return DefaultTabController(
      length: 3,
      child: Container(
        padding: EdgeInsets.only(left: 15, right: 15, top: 5),
        decoration: BoxDecoration(
          color: color2,
          borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            TabBar(
              controller: _tabController,
              tabs: <Tab>[
                Tab(
                  icon: SvgPicture.asset(
                    "assets/icons/color.svg",
                    fit: BoxFit.contain,
                    height: 20,
                    width: 20,
                  ),
                  text: "Colour",
                ),
                Tab(
                  icon: SvgPicture.asset(
                    _tabController.index == 1
                        ? "assets/icons/share.svg"
                        : "assets/icons/share_ns.svg",
                    fit: BoxFit.contain,
                    height: 20,
                    width: 20,
                  ),
                  text: "Share",
                ),
                Tab(
                  icon: SvgPicture.asset(
                    _tabController.index == 2
                        ? "assets/icons/followup.svg"
                        : "assets/icons/followup_ns.svg",
                    fit: BoxFit.contain,
                    height: 20,
                    width: 20,
                  ),
                  text: "Follow-up",
                ),
              ],
              labelStyle: myTs(color: color4, size: 15),
              unselectedLabelStyle: myTs(color: color5, size: 15),
              indicatorColor: Colors.transparent,
              labelColor: color4,
              unselectedLabelColor: color5,
            ),
            Divider(
              thickness: 0.5,
              color: Colors.grey.withOpacity(0.4),
              height: 2,
            ),
            Container(
              height: size.height * 0.5,
              child: TabBarView(
                controller: _tabController,
                physics: BouncingScrollPhysics(),
                children: <Widget>[
                  _colorWidget(),
                  _shareWidget(),
                  _followUpWidget(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _colorWidget() {
    var size = MediaQuery.of(context).size;
    return Container(
      height: size.height * 0.4,
      child: GridView.count(
        crossAxisCount: 3,
        shrinkWrap: true,
        children: reminderColors
            .map<Widget>(
              (color) => GestureDetector(
                onTap: () {
                  _selectColor(color);
                },
                child: Container(
                  width: (size.width - 15) / 3 - 20,
                  height: (size.width - 15) / 3 - 20,
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: color,
                    border: Border.all(width: 0.2),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _shareWidget() {
    var size = MediaQuery.of(context).size;
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          margin: EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: color3,
          ),
          child: TextFormField(
            controller: _controller1,
            onChanged: (s) {
              _query(s, 0);
            },
            style: myTs(color: color5),
            decoration: InputDecoration(
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              focusedErrorBorder: InputBorder.none,
              isDense: true,
              hintText: "Search Profiles",
              hintStyle: myTs(color: color5.withOpacity(0.3)),
            ),
          ),
        ),
        Container(
          height: size.height * 0.4,
          child: ListView.separated(
            shrinkWrap: true,
            physics: BouncingScrollPhysics(),
            addAutomaticKeepAlives: false,
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            primary: true,
            itemCount:
                _loaded ? _queryProfiles[0].length : widget.profileIds.length,
            separatorBuilder: (context, index) => SizedBox(height: 15),
            itemBuilder: (context, i) {
              if (_loaded && _queryProfiles[0].length > i) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      color: Colors.transparent,
                      child: ReminderProfileTile(
                        _queryProfiles[0][i],
                        textColor: color5,
                      ),
                    ),
                    IconButton(
                      icon: SvgPicture.asset(
                        "assets/icons/send.svg",
                        fit: BoxFit.contain,
                      ),
                      onPressed: () {
                        _sendReminder(_queryProfiles[0][i]);
                      },
                      color: color5,
                    )
                  ],
                );
              } else
                return Shimmer.fromColors(
                  child: Container(
                    decoration: BoxDecoration(
                      color: color5,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    height: size.width * 0.25,
                    width: double.maxFinite,
                  ),
                  baseColor: color5.withOpacity(0.6),
                  highlightColor: color5.withOpacity(0.2),
                );
            },
          ),
        ),
      ],
    );
  }

  Widget _followUpWidget() {
    var size = MediaQuery.of(context).size;
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          margin: EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: color3,
          ),
          child: TextFormField(
            controller: _controller2,
            onChanged: (s) {
              _query(s, 1);
            },
            style: myTs(color: color5),
            decoration: InputDecoration(
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              focusedErrorBorder: InputBorder.none,
              isDense: true,
              hintText: "Search Profiles",
              hintStyle: myTs(color: color5.withOpacity(0.3)),
            ),
          ),
        ),
        Container(
          height: size.height * 0.4,
          child: ListView.separated(
            shrinkWrap: true,
            physics: BouncingScrollPhysics(),
            addAutomaticKeepAlives: false,
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            primary: true,
            itemCount:
                _loaded ? _queryProfiles[1].length : widget.profileIds.length,
            separatorBuilder: (context, index) => SizedBox(height: 15),
            itemBuilder: (context, i) {
              if (_loaded && _queryProfiles[1].length > i) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      color: Colors.transparent,
                      child: ReminderProfileTile(
                        _queryProfiles[1][i],
                        textColor: color5,
                      ),
                    ),
                    IconButton(
                      icon: SvgPicture.asset(
                        "assets/icons/send.svg",
                        fit: BoxFit.contain,
                      ),
                      onPressed: () {
                        _followUpReminder(_queryProfiles[1][i]);
                      },
                      color: color5,
                    )
                  ],
                );
              } else
                return Shimmer.fromColors(
                  child: Container(
                    decoration: BoxDecoration(
                      color: color5,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    height: size.width * 0.25,
                    width: double.maxFinite,
                  ),
                  baseColor: color5.withOpacity(0.6),
                  highlightColor: color5.withOpacity(0.2),
                );
            },
          ),
        ),
      ],
    );
  }
}
