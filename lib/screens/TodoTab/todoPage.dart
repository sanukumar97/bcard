import 'dart:async';
import 'package:bcard/screens/DiscoverTab/profileDetails.dart';
import 'package:bcard/screens/ProfileTab/settings.dart';
import 'package:bcard/screens/TodoTab/addReminder.dart';
import 'package:bcard/screens/TodoTab/reminderTile.dart';
import 'package:bcard/utilities/Classes/profileClass.dart';
import 'package:bcard/utilities/Classes/reminderClass.dart';
import 'package:bcard/utilities/localStorage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_svg/svg.dart';
import 'package:bcard/utilities/Constants/randomConstants.dart';
import 'package:bcard/utilities/firebaseFunctions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

class TodoPage extends StatefulWidget {
  void addReminder(String reminderId) async {
    Reminder reminder = await FirebaseFunctions.getReminder(reminderId);
    if (reminder != null) __todoPageState._addReminder(reminder);
  }

  void openReminder(String reminderId) {
    __todoPageState._openReminder(reminderId);
  }

  void reload() {
    __todoPageState._reload();
  }

  void pageOpened() {
    __todoPageState._scrollToLatest();
  }

  bool goBack() {
    return __todoPageState._goBack();
  }

  final _TodoPageState __todoPageState = new _TodoPageState();
  @override
  _TodoPageState createState() => __todoPageState;
}

class _TodoPageState extends State<TodoPage> {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  Map<String, List<Reminder>> _reminders = {};
  StreamSubscription _reminderSubscription;
  Reminder _latestReminder;
  List<Reminder> _selectedReminders = [];
  AutoScrollController _autoScrollController =
      new AutoScrollController(axis: Axis.vertical);
  bool _highLightingReminder = false;
  bool _firstRefresh = true;
  bool _profileShown = false;
  Profile _shownProfile;

  void _reload() {
    setState(() {});
  }

  void _openReminder(String reminderId) async {
    int index = -1;
    Reminder reminder;
    for (int i = 0; i < _reminders.keys.length; i++) {
      List<Reminder> reminders = _reminders[_reminders.keys.toList()[i]];
      index = reminders.indexWhere((rem) => rem.id == reminderId);
      if (index >= 0) {
        reminder = reminders[index];
        index = i;
        break;
      }
    }
    if (index >= 0) {
      _autoScrollController.scrollToIndex(index,
          duration: Duration(milliseconds: 1000),
          preferPosition: AutoScrollPosition.begin);
      setState(() {
        _selectedReminders.add(reminder);
        _highLightingReminder = true;
      });
      await Future.delayed(Duration(milliseconds: 1000));
      setState(() {
        _selectedReminders.removeWhere((rem) => rem.id == reminder.id);
        _highLightingReminder = false;
      });
    }
  }

  void _deleteReminder(Reminder reminder) {
    reminder.ref.delete();
  }

  void _addReminder(Reminder reminder) {
    String dt =
        DateTime(reminder.date.year, reminder.date.month, reminder.date.day)
            .toIso8601String();
    DateTime _today = DateTime.now();

    if (_today.isAfter(reminder.date) &&
        _today.difference(reminder.date).inDays > 7)
      return _deleteReminder(reminder);

    if (!reminder.completed && reminder.date.isAfter(_today)) {
      if (_latestReminder == null ||
          _latestReminder.date.isAfter(reminder.date))
        _latestReminder = reminder;
    }

    if (_reminders.containsKey(dt)) {
      _reminders[dt].removeWhere((rem) => rem.id == reminder.id);
      _reminders[dt].add(reminder);
      _reminders[dt].sort((Reminder r1, Reminder r2) {
        if (r1.completed && !r2.completed)
          return 1;
        else if (!r1.completed && r2.completed)
          return -1;
        else if (r1.date.isBefore(_today))
          return 1;
        else if (r1.date.isBefore(_today)) return -1;
        return r1.date.compareTo(r2.date);
      });
    } else {
      _reminders[dt] = <Reminder>[reminder];
    }
    if (_latestReminder != null && _latestReminder.id == reminder.id) {
      _latestReminder = reminder;
      if (_latestReminder.completed) {
        List<String> nextDates = _reminders.keys
            .where((date) => DateTime.parse(date).isAfter(_latestReminder.date))
            .toList();
        nextDates.sort();
        for (var date in nextDates) {
          if (_reminders[date].where((rem) => !rem.completed).isNotEmpty) {
            _latestReminder =
                _reminders[date].firstWhere((rem) => !rem.completed);
            break;
          }
        }
      }
    }
  }

  void _subscribeReminderStream() {
    _reminderSubscription = FirebaseFunctions.reminderStream.listen((qs) {
      qs.docChanges.forEach((doc) {
        if (doc.type != DocumentChangeType.removed) {
          Reminder reminder = new Reminder.fromJson(doc.doc);

          if ([AppConfig.me.businessDocId, AppConfig.me.personalDocId].any(
            (id) {
              return id == reminder.ownerId || id == reminder.pinnedProfile;
            },
          )) {
            _addReminder(reminder);
          }
        }
      });
      setState(() {
        _sort();
      });
      if (_firstRefresh) {
        _scrollToLatest();
        _firstRefresh = false;
      }
    });
  }

  void _sort() {
    var entries = _reminders.entries.toList();
    entries.sort((MapEntry<String, List<Reminder>> day1,
        MapEntry<String, List<Reminder>> day2) {
      return day1.key.compareTo(day2.key);
    });
    _reminders = new Map<String, List<Reminder>>.fromEntries(entries);
  }

  void _showBottomSheet(Widget bottomSheet) {
    _scaffoldKey.currentState
        .showBottomSheet((context) => bottomSheet, elevation: 100.0);
  }

  Future<void> _refresh() async {
    _firstRefresh = true;
    await _reminderSubscription.cancel();
    setState(() {
      _reminders.clear();
      _latestReminder = null;
    });
    _subscribeReminderStream();
  }

  void _deleteReminders() {
    _selectedReminders.forEach((rem) {
      rem.ref.delete();
      String dt = DateTime(rem.date.year, rem.date.month, rem.date.day)
          .toIso8601String();
      _reminders[dt].removeWhere((r) => r.id == rem.id);
      if (_reminders[dt].isEmpty) {
        _reminders.remove(dt);
      }
    });
    setState(() {
      _selectedReminders.clear();
    });
  }

  void _scrollToLatest() {
    DateTime _today = DateTime.now();
    String dt =
        DateTime(_today.year, _today.month, _today.day).toIso8601String();
    var dts = _reminders.keys.toList();
    int index = -1;
    for (int i = 0; i < dts.length; i++) {
      if (dts[i].compareTo(dt) >= 0) {
        index = i;
        break;
      }
    }
    if (index >= 0) {
      _autoScrollController.scrollToIndex(index,
          duration: Duration(milliseconds: 1000),
          preferPosition: AutoScrollPosition.begin);
    }
  }

  void _openProfile(Profile profile) {
    setState(() {
      _profileShown = true;
      _shownProfile = profile;
    });
  }

  bool _goBack() {
    if (_profileShown) {
      setState(() {
        _profileShown = false;
        _shownProfile = null;
      });
      return false;
    } else {
      return true;
    }
  }

  @override
  void initState() {
    super.initState();
    _subscribeReminderStream();
  }

  @override
  void dispose() {
    _reminderSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    Reminder _dummyReminder;
    if (_latestReminder == null) {
      _dummyReminder = new Reminder(
          DateTime.now(),
          AppConfig.currentProfile.id,
          "Hey!👋\nNo Reminders Added yet !\nAdd Reminders from below button.",
          [],
          false,
          null);
    }
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: color2,
      drawer: SettingsDrawer(),
      appBar: AppBar(
        automaticallyImplyLeading: true,
        leading: _profileShown && _shownProfile != null
            ? IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: color5,
                ),
                onPressed: _goBack,
              )
            : GestureDetector(
                onTap: () {
                  _scaffoldKey.currentState.openDrawer();
                },
                child: Container(
                  padding: EdgeInsets.all(10.5),
                  child: SvgPicture.asset(
                    "assets/images/Logo.svg",
                    fit: BoxFit.contain,
                  ),
                ),
              ),
        backgroundColor: color1,
        elevation: 0.0,
        actions: [
          _selectedReminders.isEmpty || _highLightingReminder
              ? Stack(
                  children: [
                    IconButton(
                      icon: Container(
                        height: 35,
                        width: 35,
                        child: SvgPicture.asset(
                          "assets/icons/chat.svg",
                          fit: BoxFit.contain,
                        ),
                      ),
                      onPressed: () {
                        openChat();
                      },
                    ),
                    newMessage
                        ? Positioned(
                            top: 8,
                            right: 8,
                            child: Container(
                              height: 8,
                              width: 8,
                              decoration: BoxDecoration(
                                color: color4,
                                shape: BoxShape.circle,
                              ),
                            ),
                          )
                        : SizedBox()
                  ],
                )
              : IconButton(
                  icon: Icon(Icons.delete_outline),
                  color: Colors.red,
                  onPressed: _deleteReminders,
                ),
        ],
      ),
      floatingActionButton: IconButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AddReminderDialog(),
          );
        },
        icon: SvgPicture.asset(
          "assets/icons/add2.svg",
          height: 40,
          width: 40,
          fit: BoxFit.contain,
        ),
        iconSize: 40,
      ),
      body: _profileShown && _shownProfile != null
          ? DiscoverProfileCardDetails(_shownProfile)
          : RefreshIndicator(
              onRefresh: _refresh,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _latestReminder != null
                      ? GestureDetector(
                          onLongPress: () {
                            _onLongPress(_latestReminder);
                          },
                          onTap: () {
                            _onTap(_latestReminder);
                          },
                          child: ReminderTile(
                            _latestReminder,
                            160,
                            MediaQuery.of(context).size.width - 20,
                            _showBottomSheet,
                            true,
                            _openProfile,
                            selected: _selectedReminders
                                .any((rem) => rem.id == _latestReminder.id),
                          ),
                        )
                      : ReminderTile(
                          _dummyReminder,
                          160,
                          MediaQuery.of(context).size.width - 20,
                          _showBottomSheet,
                          true,
                          _openProfile,
                        ),
                  Expanded(
                    child: ListView.builder(
                      controller: _autoScrollController,
                      physics: AlwaysScrollableScrollPhysics(),
                      itemCount: _reminders.length + 1,
                      /* (_reminders.isEmpty ? 1 : 0) */
                      itemBuilder: (context, i) {
                        if (_reminders.isEmpty)
                          return SizedBox(height: size.height * 0.6);
                        else if (i == _reminders.length)
                          return SizedBox(height: size.height * 0.6);
                        return AutoScrollTag(
                          key: ValueKey(_reminders.keys.toList()[i]),
                          controller: _autoScrollController,
                          index: i,
                          child: _dayTile(_reminders.keys.toList()[i],
                              _reminders.values.toList()[i]),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  void _onLongPress(Reminder reminder) {
    if (_selectedReminders.isEmpty) {
      setState(() {
        _selectedReminders.add(reminder);
      });
    }
  }

  void _onTap(Reminder reminder) {
    if (_selectedReminders.isNotEmpty) {
      if (_selectedReminders.contains(reminder)) {
        setState(() {
          _selectedReminders.remove(reminder);
        });
      } else {
        setState(() {
          _selectedReminders.add(reminder);
        });
      }
    }
  }

  Widget _dayTile(String _date, List<Reminder> reminders) {
    DateTime date = DateTime.parse(_date), _today = DateTime.now();
    var size = MediaQuery.of(context).size;
    String _dateString;
    if (date.year == _today.year &&
        date.month == _today.month &&
        date.day == _today.day) {
      _dateString = "Today";
    } else {
      _dateString = date.day.toString() +
          "/" +
          date.month.toString() +
          "/" +
          date.year.toString();
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          alignment: Alignment.centerLeft,
          margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: Text(
            _dateString,
            style: myTs(color: color5, size: 16),
          ),
        ),
        Container(
          height: 140,
          alignment: Alignment.centerLeft,
          child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            physics: BouncingScrollPhysics(),
            itemCount: reminders.length,
            itemBuilder: (context, i) {
              bool selected =
                  _selectedReminders.any((rem) => rem.id == reminders[i].id);
              return GestureDetector(
                onLongPress: () {
                  _onLongPress(reminders[i]);
                },
                onTap: () {
                  _onTap(reminders[i]);
                },
                child: ReminderTile(
                  reminders[i],
                  130,
                  size.width * 0.7,
                  _showBottomSheet,
                  false,
                  _openProfile,
                  selected: selected,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
