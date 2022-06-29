import 'package:bcard/screens/NotificationTab/notificationPage.dart';
import 'package:bcard/screens/ProfileTab/profilePageDetails.dart';
import 'package:bcard/screens/ProfileTab/settings.dart';
import 'package:bcard/utilities/Classes/NotificationClasses/notificationClass.dart';
import 'package:bcard/utilities/Classes/profileClass.dart';
import 'package:bcard/utilities/Constants/randomConstants.dart';
import 'package:bcard/utilities/localStorage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProfilePage extends StatefulWidget {
  final Function(Profile) showProfile;

  ProfilePage(this.showProfile);

  final _ProfilePageState _profilePageState = new _ProfilePageState();

  void reload() {
    _profilePageState._reload();
  }

  @override
  _ProfilePageState createState() => _profilePageState;

  bool goBack() {
    return _profilePageState.goBack();
  }
}

class _ProfilePageState extends State<ProfilePage> {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  int _currentIndex = AppConfig.currentSelectedProfile;
  bool _edit = false;
  bool _searchDialogOpen = false;

  void _searchDialogOpened() {
    _searchDialogOpen = true;
  }

  void _searchDialogClosed() {
    _searchDialogOpen = false;
  }

  bool goBack() {
    if (_edit) {
      _stopEditing();
      return false;
    } else if (_searchDialogOpen) {
      Navigator.pop(context);
      return false;
    } else {
      return true;
    }
  }

  void _reload() {
    setState(() {});
  }

  void showErrorMessage(String message) {
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _startEditing() {
    setState(() {
      _edit = true;
    });
  }

  void _stopEditing() {
    setState(() {
      _edit = false;
    });
    AppConfig.saveChanges();
  }

  void _showNotificationBottomSheet() {
    void _newNotification() {}
    void _addReminder(String reminderId) {}

    if (!FocusScope.of(context).hasPrimaryFocus &&
        FocusScope.of(context).focusedChild != null) {
      print("Has Focus");
      FocusManager.instance.primaryFocus.unfocus();
    }
    showModalBottomSheet(
      context: context,
      backgroundColor: color2,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.6,
        decoration: BoxDecoration(
          color: color2,
          borderRadius: BorderRadius.circular(20),
        ),
        child: NotificationPage(
            _newNotification, _addReminder, widget.showProfile),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
    );
    AppConfig.newNotification.value = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: color2,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: _edit
          ? GestureDetector(
              onTap: () {
                _stopEditing();
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                width: double.maxFinite,
                height: 30,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: color4,
                ),
                child: Text(
                  "Save",
                  style: myTs(
                      color: color2, size: 18, fontWeight: FontWeight.bold),
                ),
              ),
            )
          : null,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        leading: _edit
            ? IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: color5,
                ),
                onPressed: () {
                  _stopEditing();
                },
              )
            : GestureDetector(
                onTap: () {
                  if (!FocusScope.of(context).hasPrimaryFocus &&
                      FocusScope.of(context).focusedChild != null) {
                    print("Has Focus");
                    FocusManager.instance.primaryFocus.unfocus();
                  }
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
        actions: _edit
            ? <Widget>[]
            : <Widget>[
                /* Stack(
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
                ), */
                //TODO added above comment for v2.0

                //TODO Below icon is added for v2.0
                ValueListenableBuilder<Map<String, List<AppNotification>>>(
                  valueListenable: AppConfig.notifications,
                  builder: (context, notifications, child) {
                    return IconButton(
                      icon: Stack(
                        children: [
                          ValueListenableBuilder<bool>(
                            valueListenable: AppConfig.newNotification,
                            builder: (context, newNotification, child) {
                              if (newNotification)
                                return SvgPicture.asset(
                                  "assets/icons/notification1_with_dot.svg",
                                  height: 20,
                                  width: 20,
                                );
                              else
                                return SvgPicture.asset(
                                  "assets/icons/notification1.svg",
                                  height: 20,
                                  width: 20,
                                );
                            },
                          ),
                          /* AppConfig.newNotification
                              ? Positioned(
                                  top: 0,
                                  right: 0,
                                  child: Container(
                                    height: 8,
                                    width: 8,
                                    decoration: BoxDecoration(
                                      color: color4,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                )
                              : SizedBox(), */
                        ],
                      ),
                      onPressed: () {
                        _showNotificationBottomSheet();
                      },
                    );
                  },
                ),
              ],
      ),
      body: Container(
        decoration: _edit
            ? null
            : BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    color1,
                    Color(0xff335F7E),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  tileMode: TileMode.clamp,
                ),
                borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(35)),
              ),
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /* Padding(
                padding: EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _currentIndex = 0;
                          AppConfig.currentSelectedProfile = 0;
                        });
                      },
                      child: Container(
                        height: 70,
                        child: Column(
                          children: [
                            _currentIndex == 0
                                ? SvgPicture.asset(
                                    "assets/icons/business.svg",
                                    height: 40,
                                    width: 40,
                                  )
                                : SvgPicture.asset(
                                    "assets/icons/business_ns.svg",
                                    height: 40,
                                    width: 40,
                                  ),
                            SizedBox(height: 7),
                            Text(
                              "Business",
                              style: myTs(color: color5, size: 12),
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 25),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _currentIndex = 1;
                          AppConfig.currentSelectedProfile = 1;
                        });
                      },
                      child: Container(
                        height: 70,
                        child: Column(
                          children: [
                            _currentIndex == 1
                                ? SvgPicture.asset(
                                    "assets/icons/personal.svg",
                                    height: 40,
                                    width: 40,
                                  )
                                : SvgPicture.asset(
                                    "assets/icons/personal_ns.svg",
                                    height: 40,
                                    width: 40,
                                  ),
                            SizedBox(height: 7),
                            Text(
                              "Personal",
                              style: myTs(color: color5, size: 12),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ), */
              //TODO Commented above part for v2.0, Here only one type of profile is present
              SizedBox(height: 15),
              _nextBody(),
            ],
          ),
        ),
      ),
      drawer: SettingsDrawer(),
    );
  }

  Widget _nextBody() {
    return ProfilePageDetails(
      AppConfig.me.businessProfile,
      _startEditing,
      _edit,
      showErrorMessage,
      _searchDialogOpened,
      _searchDialogClosed,
    );

    //TODO For v2.0, above return statement is added and below if-else condition is commented

    /* if (_currentIndex == 0) {
      return ProfilePageDetails(
          AppConfig.me.businessProfile, _startEditing, _edit, showErrorMessage);
    } else {
      return ProfilePageDetails(
          AppConfig.me.personalProfile, _startEditing, _edit, showErrorMessage);
    } */
  }
}
