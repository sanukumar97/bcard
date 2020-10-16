import 'dart:async';
import 'package:bcard/screens/ChatTab/chatHead.dart';
import 'package:bcard/screens/ChatTab/profileChatPage.dart';
import 'package:bcard/screens/DiscoverTab/profileDetails.dart';
import 'package:bcard/utilities/Classes/MessageClasses/messageClass.dart';
import 'package:bcard/utilities/Classes/profileClass.dart';
import 'package:bcard/utilities/Constants/logoBox.dart';
import 'package:bcard/utilities/Constants/randomConstants.dart';
import 'package:bcard/utilities/firebaseFunctions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:bcard/screens/ChatTab/helperClasses.dart';
import 'package:bcard/utilities/localStorage.dart';

class ChatPage extends StatefulWidget {
  final Function(ProfileType) newMessage;

  ChatPage(this.newMessage);

  void startChat(String recieverProfileId) {
    __chatPageState.startChat(recieverProfileId);
  }

  void goBack() {
    __chatPageState.goBack();
  }

  void openedChat() {
    __chatPageState.openedChat();
  }

  void reload() {
    __chatPageState.reload();
  }

  final _ChatPageState __chatPageState = new _ChatPageState();
  @override
  _ChatPageState createState() => __chatPageState;
}

class _ChatPageState extends State<ChatPage> {
  StreamSubscription<QuerySnapshot> _messageStream;
  bool _insideChat = false;
  String _currentChatProfileId;
  Map<String, Profile> _profiles = {};
  AllMessages _messages;
  bool _profileShown = false;
  Profile _shownProfile;

  void reload() {
    setState(() {});
  }

  void openedChat() {
    List<String> newMessageIds = [];
    _messages.messages.forEach((pm) {
      pm.messages.forEach((dm) {
        dm.messages.forEach((mes) {
          String _myId = [
            AppConfig.me.businessDocId,
            AppConfig.me.personalDocId
          ].contains(mes.senderProfileId)
              ? mes.senderProfileId
              : mes.recieverProfileId;
          if (AppConfig.currentProfile.id == _myId &&
              !AppConfig.messagesRead.contains(mes.id)) {
            setNewMessage(AppConfig.currentProfile.profileType, false);
            newMessageIds.add(mes.id);
          }
        });
      });
    });
    AppConfig.addMessageRead(newMessageIds);
  }

  void _subscribeStream() {
    _messageStream = FirebaseFunctions.chatStream.listen((qs) {
      qs.documentChanges.forEach((doc) {
        if ([AppConfig.me.businessDocId, AppConfig.me.personalDocId]
                .contains(doc.document.data["recieverProfileId"]) ||
            [AppConfig.me.businessDocId, AppConfig.me.personalDocId]
                .contains(doc.document.data["senderProfileId"])) {
          Message message = getMessage(doc.document);
          _messages.addMessage(message);
          if (AppConfig.messagesRead.isNotEmpty &&
              !AppConfig.messagesRead.contains(message.id)) {
            String _myId = [
              AppConfig.me.businessDocId,
              AppConfig.me.personalDocId
            ].contains(message.senderProfileId)
                ? message.senderProfileId
                : message.recieverProfileId;
            widget.newMessage(AppConfig.me.businessDocId == _myId
                ? ProfileType.business
                : ProfileType.personal);
          }
        }
      });
      if (this.mounted) setState(() {});
    });
  }

  void startChat(String recieverProfileId) {
    setState(() {
      _insideChat = true;
      _currentChatProfileId = recieverProfileId;
    });
    _getProfile();
  }

  void _getProfile({String profileId}) async {
    if (!_profiles.containsKey(profileId ?? _currentChatProfileId)) {
      Profile profile = await FirebaseFunctions.getProfile(
          profileId ?? _currentChatProfileId);
      _profiles.addAll({profileId ?? _currentChatProfileId: profile});
      if (this.mounted) setState(() {});
    }
  }

  void goBack() {
    if (_insideChat) {
      if (_profileShown) {
        setState(() {
          _profileShown = false;
          _shownProfile = null;
        });
      } else {
        setState(() {
          _insideChat = false;
          _currentChatProfileId = null;
        });
      }
    } else
      goBackFromChatPage();
  }

  void _openProfile(Profile profile) {
    setState(() {
      _profileShown = true;
      _shownProfile = profile;
    });
  }

  void _refresh() {
    setState(() {
      _messages.clear();
      _profiles.clear();
    });
    _messageStream.cancel();
    _subscribeStream();
  }

  @override
  void initState() {
    super.initState();
    _messages = AllMessages(_getProfile);
    _subscribeStream();
  }

  @override
  void dispose() {
    _messageStream.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color2,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: color5,
          ),
          onPressed: goBack,
        ),
        title: _title,
        actions: _actions,
        backgroundColor: color1,
        elevation: 0.0,
      ),
      body: _insideChat
          ? _profileShown && _shownProfile != null
              ? DiscoverProfileCardDetails(_shownProfile)
              : ProfileChatPage(
                  _profiles[_currentChatProfileId],
                  _messages
                          .getProfileMessages(_currentChatProfileId)
                          ?.messages ??
                      [])
          : _body,
    );
  }

  Widget get _body {
    List<ProfileMessages> chatheads = _messages.messages
        .where(
          (pm) => pm.messages.any(
            (dm) => dm.messages.any(
              (msg) =>
                  msg.senderProfileId == AppConfig.currentProfile.id ||
                  msg.recieverProfileId == AppConfig.currentProfile.id,
            ),
          ),
        )
        .toList();
    if (chatheads.isEmpty) {
      return Container(
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.1),
        alignment: Alignment.center,
        child: Text(
          "No Chats Available on your ${AppConfig.currentProfile.profileType == ProfileType.business ? "Business" : "Personal"} profile",
          textAlign: TextAlign.center,
          style: myTs(color: color5, size: 18),
        ),
      );
    } else
      return RefreshIndicator(
        onRefresh: () async {
          _refresh();
        },
        child: ListView.builder(
          itemCount: chatheads.length,
          itemBuilder: (BuildContext context, int i) {
            Message _lastMessage;
            if (chatheads[i].messages.isNotEmpty) {
              _lastMessage = chatheads[i].messages.last.messages.lastWhere(
                    (msg) =>
                        msg.senderProfileId == AppConfig.currentProfile.id ||
                        msg.recieverProfileId == AppConfig.currentProfile.id,
                    orElse: () => null,
                  );
            }
            if (_lastMessage == null)
              return SizedBox();
            else
              return GestureDetector(
                onTap: () {
                  startChat(chatheads[i].profileId);
                },
                child: ChatHead(
                  _profiles[chatheads[i].profileId],
                  _lastMessage,
                ),
              );
          },
        ),
      );
  }

  Widget get _title {
    if (_insideChat) {
      if (_profiles.containsKey(_currentChatProfileId)) {
        Profile profile = _profiles[_currentChatProfileId];
        return GestureDetector(
          onTap: () {
            _openProfile(profile);
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                profile?.name ?? "Name",
                style: myTs(color: color5, size: 18),
              ),
              Text(
                profile?.occupation ?? "Occupation",
                style: myTs(color: color5, size: 15),
              ),
            ],
          ),
        );
      } else
        return null;
    } else
      return Text(
        "Chats",
        style: myTs(color: color5, size: 18),
      );
  }

  List<Widget> get _actions {
    if (_insideChat &&
        _profiles.containsKey(_currentChatProfileId) &&
        _profiles[_currentChatProfileId].logoUrl != null)
      return <Widget>[
        Container(
          padding: EdgeInsets.all(10),
          width: 55,
          margin: EdgeInsets.symmetric(horizontal: 5),
          decoration: BoxDecoration(shape: BoxShape.circle),
          child: ClipOval(
            child: logoBox(false, _profiles[_currentChatProfileId].logoUrl,
                _profiles[_currentChatProfileId].profileType, 40.0, 40.0),
          ),
        ),
      ];
    else
      return <Widget>[];
  }
}
