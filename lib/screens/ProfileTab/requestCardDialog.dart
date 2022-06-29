import 'package:bcard/screens/ProfileTab/profileTile.dart';
import 'package:bcard/utilities/Classes/profileClass.dart';
import 'package:bcard/utilities/Constants/randomConstants.dart';
import 'package:bcard/utilities/firebaseFunctions.dart';
import 'package:bcard/utilities/localStorage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';

class RequestCardDialog extends StatefulWidget {
  final Profile profile;
  RequestCardDialog({this.profile});
  @override
  _RequestCardDialogState createState() => _RequestCardDialogState();
}

class _RequestCardDialogState extends State<RequestCardDialog>
    with TickerProviderStateMixin {
  TextEditingController _controller = new TextEditingController(),
      _messageController = new TextEditingController();
  PageController _pageController;
  List<Profile> _profiles = [];
  bool _loading = false, _noProfilesFound = false, _sending = false;
  Profile _selectedProfile;
  int _page = 0;

  void _searchProfiles() async {
    setState(() {
      _loading = true;
      _profiles.clear();
    });
    for (int i = 0; i < 4; i++) {
      List<DocumentSnapshot> docs =
          await FirebaseFunctions.discoverProfiles([_controller.value.text], i);
      if (docs.isNotEmpty) {
        docs.forEach((doc) {
          print(doc.data()["profileType"]);
          if (!AppConfig.me.cardLibraries[3].profileIds
                  .contains(doc.data()["id"]) &&
              !_profiles.any((pf) => pf.id == doc.data()["id"]))
            _profiles.add(new Profile.fromJson(doc.data()));
        });
        setState(() {
          _loading = false;
          _noProfilesFound = false;
        });
      }
    }
    setState(() {
      _noProfilesFound = _profiles.isEmpty;
      _loading = false;
    });
  }

  void _selectProfile(Profile profile) {
    setState(() {
      _selectedProfile = profile;
      _pageController.animateToPage(1,
          duration: Duration(milliseconds: 500), curve: Curves.ease);
    });
  }

  void _sendRequest() async {
    if (_messageController.value.text.isNotEmpty) {
      setState(() {
        _sending = true;
      });
      if (_selectedProfile.profileStatus == ProfileStatus.requested) {
        await FirebaseFunctions.requestProfile(
            _selectedProfile, _messageController.value.text);
      }
      /* TextMessage textMessage = new TextMessage(AppConfig.currentProfile.id,
          _selectedProfile.id, _messageController.value.text);
      await FirebaseFunctions.sendMessage(textMessage); */
      //TODO Added above comment for v2.0 as there is no chat option in v2.0
      setState(() {
        _sending = false;
      });
      appToast("Request Sent", context, color: color4);
      Navigator.pop(context, true);
    } else {
      appToast("Add some message", context);
    }
  }

  void _notNowTapped() async {
    if (_selectedProfile.profileStatus == ProfileStatus.requested) {
      await FirebaseFunctions.requestProfile(_selectedProfile, "");
      appToast("Request Sent", context, color: color4);
    }
    Navigator.pop(context, true);
  }

  void _openProfile(Profile profile) {
    Navigator.pop(context);
    openProfile(profile.id);
  }

  @override
  void initState() {
    super.initState();
    if (widget.profile != null) {
      _selectedProfile = widget.profile;
      _page = 1;
    }
    _pageController = new PageController(initialPage: _page);
    _pageController.addListener(() {
      if (_pageController.page.toInt().toDouble() == _pageController.page) {
        setState(() {
          _page = _pageController.page.toInt();
        });
      }
    });
    _controller.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color2,
        borderRadius: BorderRadius.circular(25),
      ),
      child: PageView(
        controller: _pageController,
        physics: NeverScrollableScrollPhysics(),
        children: [
          _searchProileWidget(),
          _sendRequestWidget(),
        ],
      ),
    );
  }

  Widget _searchProileWidget() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.only(top: 10, bottom: 7),
          child: Text(
            "Search New Connections",
            style: myTs(color: color5, size: 16),
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(width: 0.4, color: color1),
            color: color3,
          ),
          child: TextFormField(
            controller: _controller,
            onChanged: (s) {},
            style: myTs(color: color5, size: 15),
            decoration: InputDecoration(
              suffixIconConstraints:
                  BoxConstraints(maxHeight: 20, maxWidth: 20),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              focusedErrorBorder: InputBorder.none,
              isDense: true,
              hintText: "Search by username",
              hintStyle: myTs(color: color5, size: 15),
            ),
          ),
        ),
        GestureDetector(
          onTap: _searchProfiles,
          child: Container(
            alignment: Alignment.center,
            width: double.maxFinite,
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: BoxDecoration(
              color: color4,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              "Search",
              style: myTs(color: color2, size: 15, fontWeight: FontWeight.bold),
            ) /* SvgPicture.asset(
                          "assets/icons/search.svg",
                          fit: BoxFit.contain,
                        ) */
            ,
          ),
        ),
        Divider(
          thickness: 0.5,
          indent: 15,
          endIndent: 15,
          color: color1.withOpacity(0.4),
        ),
        Container(
          //height: 150,
          child: _profiles.isEmpty || _loading || _noProfilesFound
              ? Container(
                  alignment: Alignment.center,
                  child: Text(
                    _loading
                        ? "Searching Profiles"
                        : _noProfilesFound
                            ? "No Profiles Found !"
                            : "",
                    style: myTs(color: color5, size: 18),
                  ),
                )
              : ListView.separated(
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  addAutomaticKeepAlives: false,
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  primary: true,
                  itemCount: _profiles.length,
                  separatorBuilder: (context, index) => SizedBox(height: 15),
                  itemBuilder: (context, i) {
                    return GestureDetector(
                      onTap: () {
                        _openProfile(_profiles[i]);
                      },
                      child: Row(
                        children: [
                          Expanded(
                            child: ProfileTile(
                              _profiles[i],
                              /* logoHeight: size.width * 0.15,
                              logoWidth: size.width * 0.15, */
                            ),
                          ),
                          _profiles[i].profileStatus == ProfileStatus.requested
                              ? RaisedButton(
                                  child: Text(
                                    "Connect",
                                    style: myTs(color: color4),
                                  ),
                                  onPressed: () {
                                    _selectProfile(_profiles[i]);
                                  },
                                  color: color3,
                                  elevation: 0.0,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8)),
                                )
                              : SizedBox(),
                        ],
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _sendRequestWidget() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            alignment: Alignment.centerLeft,
            child: Text(
              "Introduce Yourself! 👋",
              style: myTs(color: color5, size: 18),
            ),
          ),
          SizedBox(height: 15),
          Container(
            alignment: Alignment.centerLeft,
            child: Text(
              "On People's Card, every time you connect with anoher member, we break the ice by introducing you through a message.",
              style: myTs(color: Colors.grey.withOpacity(0.7), size: 12),
            ),
          ),
          Divider(
            thickness: 0.1,
            color: color5.withOpacity(0.5),
          ),
          Container(
            child: TextFormField(
              controller: _messageController,
              style: myTs(color: color5, size: 16),
              cursorColor: color5,
              minLines: 5,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: "Type a message",
                hintStyle: myTs(color: Colors.grey.withOpacity(0.7), size: 16),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
              ),
            ),
          ),
          Spacer(),
          Divider(
            thickness: 0.1,
            color: color5.withOpacity(0.5),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: _notNowTapped,
                child: Text(
                  "Not Now",
                  style: myTs(color: color5.withOpacity(0.5), size: 14),
                ),
              ),
              GestureDetector(
                onTap: _sendRequest,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: color3,
                  ),
                  child: Text(
                    "Sounds Good",
                    style: myTs(
                        color: color5, size: 14, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
