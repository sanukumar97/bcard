import 'dart:async';
import 'package:bcard/screens/DiscoverTab/profileDetails.dart';
import 'package:bcard/screens/ProfileTab/settings.dart';
import 'package:bcard/utilities/Classes/NotificationClasses/notificationClass.dart';
import 'package:bcard/utilities/Classes/NotificationClasses/profileRequestNotificationClass.dart';
import 'package:bcard/utilities/Classes/NotificationClasses/profileVisitedNotificationClass.dart';
import 'package:bcard/utilities/Classes/NotificationClasses/recommendNotificationClass.dart';
import 'package:bcard/utilities/Classes/NotificationClasses/reminderNotificationClass.dart';
import 'package:bcard/utilities/Classes/profileClass.dart';
import 'package:bcard/utilities/Constants/encodersAndDecoders.dart';
import 'package:bcard/utilities/Constants/randomConstants.dart';
import 'package:bcard/utilities/firebaseFunctions.dart';
import 'package:bcard/utilities/localStorage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:bcard/screens/NotificationTab/profileRequestNotification.dart';
import 'package:bcard/screens/NotificationTab/profileVisitedNotification.dart';
import 'package:bcard/screens/NotificationTab/recommendNotification.dart';
import 'package:bcard/screens/NotificationTab/reminderNotification.dart';

class NotificationPage extends StatefulWidget {
  final Function newNotification;
  final Function(String) addReminder;
  NotificationPage(this.newNotification, this.addReminder);

  bool goBack() {
    return __notificationPageState._goback();
  }

  void reload() {
    __notificationPageState._reload();
  }

  _NotificationPageState __notificationPageState = new _NotificationPageState();
  @override
  _NotificationPageState createState() => __notificationPageState;
}

class _NotificationPageState extends State<NotificationPage> {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  StreamSubscription _requestStream;
  Map<String, List<AppNotification>> _notifications = {};
  bool _showProfile = false;
  Profile _shownProfile;
  int _totNotifications = 0;

  bool _goback() {
    if (_showProfile) {
      setState(() {
        _showProfile = false;
        _shownProfile = null;
      });
      return false;
    } else {
      return true;
    }
  }

  void _reload() {
    setState(() {});
  }

  void _subscribeStream() {
    _totNotifications = 0;
    _requestStream = FirebaseFunctions.notificationStream.listen((qs) {
      qs.documentChanges.forEach((doc) {
        if ([
          AppConfig.me.businessDocId,
          AppConfig.me.personalDocId,
        ].contains(doc.document.data["recieverProfileId"])) {
          AppNotification _notification =
              AppNotification.getNotification(doc.document);
          if (!AppConfig.notificationsRead.contains(_notification.id)) {
            widget.newNotification();
            AppConfig.addNotificationRead(_notification.id);
          }
          addNotification(_notification);
        }
      });
      setState(() {
        _sort();
      });
    });
  }

  void addNotification(AppNotification notification) {
    String dt = DateTime(notification.date.year, notification.date.month,
            notification.date.day)
        .toIso8601String();
    if (notification.notificationType == NotificationType.reminder) {
      widget.addReminder((notification as ReminderNotification).id);
    }
    if (_notifications.containsKey(dt)) {
      _notifications[dt].removeWhere((not) => not.id == notification.id);
      _notifications[dt].add(notification);
      _notifications[dt].sort((AppNotification n1, AppNotification n2) {
        return -1 * n1.date.compareTo(n2.date);
      });
    } else {
      _notifications[dt] = <AppNotification>[notification];
    }
    _totNotifications += 1;
  }

  void _sort() {
    var entries = _notifications.entries.toList();
    entries.sort((MapEntry<String, List<AppNotification>> day1,
        MapEntry<String, List<AppNotification>> day2) {
      return -1 * day1.key.compareTo(day2.key);
    });
    _notifications =
        new Map<String, List<AppNotification>>.fromEntries(entries);
  }

  void _showNotificationProfile(Profile profile) {
    setState(() {
      _showProfile = true;
      _shownProfile = profile;
    });
  }

  void _showNotificationReminder(String reminderId) {
    goToTodoPage(reminderId);
  }

  void _handleError(AppNotification notification) {
    for (var key in _notifications.keys) {
      _notifications[key].removeWhere((not) => not.id == notification.id);
    }
    setState(() {});
  }

  void _refresh() {
    _requestStream.cancel();
    setState(() {
      _notifications.clear();
    });
    _subscribeStream();
  }

  @override
  void initState() {
    super.initState();
    _subscribeStream();
  }

  @override
  void dispose() {
    _requestStream.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: SettingsDrawer(),
      appBar: AppBar(
        automaticallyImplyLeading: true,
        leading: _showProfile && _shownProfile != null
            ? IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: color5,
                ),
                onPressed: _goback,
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
        title: Text(
          "Notifications",
          style: myTs(color: color5, size: 18, fontWeight: FontWeight.bold),
        ),
        backgroundColor: color1,
        elevation: 0.0,
        actions: [
          Stack(
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
          ),
        ],
      ),
      backgroundColor: color2,
      body: IndexedStack(
        index: _showProfile ? 1 : 0,
        children: <Widget>[
              _notifications.isNotEmpty
                  ? RefreshIndicator(
                      onRefresh: () async {
                        _refresh();
                      },
                      child: ListView.builder(
                        addAutomaticKeepAlives: true,
                        physics: AlwaysScrollableScrollPhysics(),
                        itemCount: _notifications.length,
                        itemBuilder: (context, i) {
                          return _dayTile(
                            _notifications.keys.toList()[i],
                            _notifications.values.toList()[i],
                          );
                        },
                      ),
                    )
                  : Center(
                      child: Text(
                        "No New Notification",
                        style: myTs(color: color5, size: 20),
                      ),
                    ),
            ] +
            (_showProfile
                ? <Widget>[DiscoverProfileCardDetails(_shownProfile)]
                : <Widget>[]),
      ),
    );
  }

  Widget _dayTile(String _date, List<AppNotification> notifications) {
    DateTime date = DateTime.parse(_date);
    String _dateString = dateString(date);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          alignment: Alignment.centerLeft,
          margin: EdgeInsets.only(left: 15, right: 15, top: 15),
          child: Text(
            _dateString,
            style: myTs(color: color5, size: 16),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          addAutomaticKeepAlives: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: notifications.length,
          itemBuilder: (context, i) {
            return _notificationTile(notifications[i]);
          },
        ),
      ],
    );
  }

  Widget _notificationTile(AppNotification notification) {
    if (notification != null) {
      switch (notification.notificationType) {
        case NotificationType.profileRequest:
          return ProfileRequestTile(notification as ProfileRequestNotification,
              _showNotificationProfile, _handleError);
          break;
        case NotificationType.visit:
          return ProfileVisitedTile(notification as ProfileVisitedNotification,
              _showNotificationProfile);
          break;
        case NotificationType.reminder:
          return ReminderNotificationTile(
              notification as ReminderNotification, _showNotificationReminder);
          break;
        case NotificationType.recommend:
          return ProfileRecommendationTile(
              notification as RecommendNotification, _showNotificationProfile);
          break;
        default:
          return Container();
      }
    } else
      return Container();
  }
}
