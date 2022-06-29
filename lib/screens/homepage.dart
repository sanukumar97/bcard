//import 'package:bcard/screens/ChatTab/chatPage.dart';
import 'package:bcard/screens/LibraryTab/cardsPage.dart';
//import 'package:bcard/screens/NotificationTab/notificationPage.dart';
import 'package:bcard/utilities/Classes/profileClass.dart';
import 'package:flutter/services.dart';
import 'package:bcard/screens/ProfileTab/profilePage.dart';
//import 'package:bcard/screens/TodoTab/todoPage.dart';
import 'package:bcard/utilities/connectivity.dart';
import 'package:bcard/utilities/Constants/randomConstants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class HomePage extends StatefulWidget {
  final String initialProfileId;

  HomePage({this.initialProfileId});
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 1;
  //DiscoverPage _discoverPage = new DiscoverPage();
  //TODO added above comment for v2.0
  CardPage _cardPage;
  ProfilePage _profilePage;
  //NotificationPage _notificationPage;
  //TODO added above comment for v2.0
  //TodoPage _todoPage;
  //TODO added above comment for v2.0
  //ChatPage _chatPage;
  //TODO added above comment for v2.0
  bool _newNotification = false;
  bool _insideChatPage = false;

  void addReminder(String reminderId) {
    //_todoPage.addReminder(reminderId);
    //TODO added above comment for v2.0
  }

  void newNotification() {
    /* if (_currentIndex != 3)
      setState(() {
        _newNotification = true;
      }); */
    //TODO added above comment for v2.0
  }

  void goBack() {
    if (_insideChatPage) {
      //_chatPage.goBack();
      //TODO added above comment for v2.0
    } else {
      //TODO swap 1 and 2 indexes wherever necessary, by testing all types of test cases, This was done for v2.0
      switch (_currentIndex) {
        /* case 0:
          if (_discoverPage.goBack()) {
            setState(() {
              _currentIndex = 1;
            });
          }
          break; */
        //TODO added above comment for v2.0
        case 0:
          if (_cardPage.goBack()) {
            setState(() {
              _currentIndex = 1;
            });
          }
          break;
        case 1:
          if (_profilePage.goBack()) {
            SystemNavigator.pop();
          }
          break;
        /* case 3:
          if (_notificationPage.goBack()) {
            setState(() {
              _currentIndex = 2;
            });
          }
          break; */
        //TODO added above comment for v2.0
        /* case 4:
          if (_todoPage.goBack()) {
            setState(() {
              _currentIndex = 2;
            });
          }
          break; */
        //TODO added above comment for v2.0
        default:
      }
    }
  }

  void _reloadChatPage() {
    //_chatPage.reload();
    //TODO added above comment for v2.0
  }

  void _closeChat() {
    /* setState(() {
      _insideChatPage = false;
    }); */
    //TODO added above comment for v2.0
  }

  /* void _goToTodoPage(String reminderId) {
    setState(() {
      _currentIndex = 4;
    });
    _todoPage.openReminder(reminderId);
  } */
  //TODO added above comment for v2.0

  void _openChat({String recieverProfileId}) {
    /* setState(() {
      _insideChatPage = true;
      _chatPage.openedChat();
      _reloadAllTabs();
    });
    if (recieverProfileId != null) _chatPage.startChat(recieverProfileId); */
    //TODO added above comment for v2.0
  }

  void _reloadAllTabs() {
    //_discoverPage.reload();
    //TODO added above comment for v2.0
    _cardPage.reload();
    _profilePage.reload();
    //_notificationPage.reload();
    //TODO added above comment for v2.0
    //_todoPage.reload();
    //TODO added above comment for v2.0
  }

  void _newMessage(ProfileType profileType) {
    /* if (!_insideChatPage) {
      setState(() {
        setNewMessage(profileType, true);
        _reloadAllTabs();
      });
    } */
    //TODO added above comment for v2.0
  }

  void _openProfile(String profileId) {
    setState(() {
      _currentIndex = 0;
      _cardPage.openProfile(profileId);
    });
  }

  @override
  void initState() {
    super.initState();
    if (widget.initialProfileId != null) {
      _currentIndex = 0;
    }
    _cardPage = new CardPage(initialProfileId: widget.initialProfileId);
    _profilePage = new ProfilePage((Profile profile) {
      _openProfile(profile.id);
    });
    openChat = _openChat;
    goBackFromChatPage = _closeChat;
    reloadChatPage = _reloadChatPage;
    openProfile = _openProfile;
    //goToTodoPage = _goToTodoPage;
    //TODO added above comment for v2.0
    //_notificationPage = new NotificationPage(newNotification, addReminder);
    //TODO added above comment for v2.0
    //_chatPage = new ChatPage(_newMessage);
    //TODO added above comment for v2.0
    //_todoPage = new TodoPage();
    //TODO added above comment for v2.0
  }

  @override
  Widget build(BuildContext context) {
    AppConnectivity.context = context;
    return WillPopScope(
      onWillPop: () async {
        goBack();
        return false;
      },
      child: SafeArea(
        child: Scaffold(
          body: IndexedStack(
            index: _insideChatPage ? 5 : _currentIndex,
            children: [
              //_discoverPage,
              //TODO added above comment for v2.0
              _cardPage,
              _profilePage,
              //_notificationPage,
              //TODO added above comment for v2.0
              //_todoPage,
              //TODO added above comment for v2.0
              //_chatPage
              //TODO added above comment for v2.0
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (value) {
              setState(() {
                if (_insideChatPage)
                  _insideChatPage = false;
                /* else if (_currentIndex == 0 && value == 0) {
                  _discoverPage.goBack();
                } */
                //TODO added above comment for v2.0
                else if (_currentIndex == 0 && value == 0) {
                  _cardPage.goBack();
                }
                /* else if (_currentIndex == 3 && value == 3) {
                  _notificationPage.goBack();
                } */
                //TODO added above comment for v2.0
                _currentIndex = value;
                //if (value == 3 && _newNotification) _newNotification = false;
                //TODO added above comment for v2.0
                //if (value == 4) _todoPage.pageOpened();
                //TODO added above comment for v2.0
              });
            },
            backgroundColor: color1,
            //fixedColor: color1,
            selectedItemColor: color4,
            unselectedItemColor: color5,
            type: BottomNavigationBarType.fixed,
            iconSize: 20,
            showUnselectedLabels: true,
            items: <BottomNavigationBarItem>[
              /* BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  "assets/icons/discover_ns.svg",
                  height: 20,
                  width: 20,
                ),
                activeIcon: SvgPicture.asset(
                  "assets/icons/discover.svg",
                  height: 20,
                  width: 20,
                ),
                label: "Discover",
              ), */
              //TODO added above comment for v2.0

              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  "assets/icons/cards1_ns.svg",
                  height: 25,
                  width: 25,
                ),
                activeIcon: SvgPicture.asset(
                  "assets/icons/cards1.svg",
                  height: 25,
                  width: 25,
                ),
                label: "Card Library",
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  "assets/icons/profile2_ns.svg",
                  height: 25,
                  width: 25,
                ),
                activeIcon: SvgPicture.asset(
                  "assets/icons/profile2.svg",
                  height: 25,
                  width: 25,
                ),
                label: "Home",
              ),
              /* BottomNavigationBarItem(
                icon: Stack(
                  children: [
                    SvgPicture.asset(
                      "assets/icons/notification_ns.svg",
                      height: 20,
                      width: 20,
                    ),
                    _newNotification
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
                        : SizedBox(),
                  ],
                ),
                activeIcon: SvgPicture.asset(
                  "assets/icons/notification.svg",
                  height: 20,
                  width: 20,
                ),
                label: "Notification",
              ), */
              //TODO added above comment for v2.0
              /* BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  "assets/icons/todo_ns.svg",
                  height: 20,
                  width: 20,
                ),
                activeIcon: SvgPicture.asset(
                  "assets/icons/todo.svg",
                  height: 20,
                  width: 20,
                ),
                label: "To do",
              ), */
              //TODO added above comment for v2.0
            ],
          ),
        ),
      ),
    );
  }
}
