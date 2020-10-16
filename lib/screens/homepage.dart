import 'package:bcard/screens/ChatTab/chatPage.dart';
import 'package:bcard/screens/LibraryTab/cardsPage.dart';
import 'package:bcard/screens/NotificationTab/notificationPage.dart';
import 'package:bcard/utilities/Classes/profileClass.dart';
import 'package:flutter/services.dart';
import 'DiscoverTab/discoverPage.dart';
import 'package:bcard/screens/ProfileTab/profilePage.dart';
import 'package:bcard/screens/TodoTab/todoPage.dart';
import 'package:bcard/utilities/connectivity.dart';
import 'package:bcard/utilities/Constants/randomConstants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 2;
  DiscoverPage _discoverPage = new DiscoverPage();
  CardPage _cardPage = new CardPage();
  ProfilePage _profilePage = new ProfilePage();
  NotificationPage _notificationPage;
  TodoPage _todoPage = new TodoPage();
  ChatPage _chatPage;
  bool _newNotification = false;
  bool _insideChatPage = false;

  void addReminder(String reminderId) {
    _todoPage.addReminder(reminderId);
  }

  void newNotification() {
    if (_currentIndex != 3)
      setState(() {
        _newNotification = true;
      });
  }

  void goBack() {
    if (_insideChatPage) {
      _chatPage.goBack();
    } else {
      switch (_currentIndex) {
        case 0:
          if (_discoverPage.goBack()) {
            setState(() {
              _currentIndex = 2;
            });
          }
          break;
        case 1:
          if (_cardPage.goBack()) {
            setState(() {
              _currentIndex = 2;
            });
          }
          break;
        case 2:
          if (_profilePage.goBack()) {
            SystemNavigator.pop();
          }
          break;
        case 3:
          if (_notificationPage.goBack()) {
            setState(() {
              _currentIndex = 2;
            });
          }
          break;
        case 4:
          if (_todoPage.goBack()) {
            setState(() {
              _currentIndex = 2;
            });
          }
          break;
        default:
      }
    }
  }

  void _reloadChatPage() {
    _chatPage.reload();
  }

  void _closeChat() {
    setState(() {
      _insideChatPage = false;
    });
  }

  void _goToTodoPage(String reminderId) {
    setState(() {
      _currentIndex = 4;
    });
    _todoPage.openReminder(reminderId);
  }

  void _openChat({String recieverProfileId}) {
    setState(() {
      _insideChatPage = true;
      _chatPage.openedChat();
      _reloadAllTabs();
    });
    if (recieverProfileId != null) _chatPage.startChat(recieverProfileId);
  }

  void _reloadAllTabs() {
    _discoverPage.reload();
    _cardPage.reload();
    _profilePage.reload();
    _notificationPage.reload();
    _todoPage.reload();
  }

  void _newMessage(ProfileType profileType) {
    if (!_insideChatPage) {
      setState(() {
        setNewMessage(profileType, true);
        _reloadAllTabs();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    openChat = _openChat;
    goBackFromChatPage = _closeChat;
    reloadChatPage = _reloadChatPage;
    goToTodoPage = _goToTodoPage;
    _notificationPage = new NotificationPage(newNotification, addReminder);
    _chatPage = new ChatPage(_newMessage);
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
              _discoverPage,
              _cardPage,
              _profilePage,
              _notificationPage,
              _todoPage,
              _chatPage
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (value) {
              setState(() {
                if (_insideChatPage)
                  _insideChatPage = false;
                else if (_currentIndex == 0 && value == 0) {
                  _discoverPage.goBack();
                } else if (_currentIndex == 1 && value == 1) {
                  _cardPage.goBack();
                } else if (_currentIndex == 3 && value == 3) {
                  _notificationPage.goBack();
                }
                _currentIndex = value;
                if (value == 3 && _newNotification) _newNotification = false;
                if (value == 4) _todoPage.pageOpened();
              });
            },
            backgroundColor: color1,
            fixedColor: color1,
            type: BottomNavigationBarType.fixed,
            iconSize: 20,
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
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
                title: Text(
                  "Discover",
                  style: myTs(color: color5, size: 12),
                ),
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  "assets/icons/cards_ns.svg",
                  height: 20,
                  width: 20,
                ),
                activeIcon: SvgPicture.asset(
                  "assets/icons/cards.svg",
                  height: 20,
                  width: 20,
                ),
                title: Text(
                  "Cards",
                  style: myTs(color: color5, size: 12),
                ),
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  "assets/icons/profile_ns1.svg",
                  height: 30,
                  width: 30,
                ),
                activeIcon: SvgPicture.asset(
                  "assets/icons/profile1.svg",
                  height: 30,
                  width: 30,
                ),
                title: Text(
                  "",
                  style: myTs(color: color5, size: 1),
                ),
              ),
              BottomNavigationBarItem(
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
                title: Text(
                  "Notification",
                  style: myTs(color: color5, size: 12),
                ),
              ),
              BottomNavigationBarItem(
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
                title: Text(
                  "To do",
                  style: myTs(color: color5, size: 12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
