import 'package:bcard/screens/CardDesigns/shareCard.dart';
import 'package:bcard/screens/DiscoverTab/profileOptions.dart';
import 'package:bcard/screens/DiscoverTab/recommendBottomSheet.dart';
import 'package:bcard/screens/ProfileTab/requestCardDialog.dart';
import 'package:bcard/screens/TodoTab/addReminder.dart';
import 'package:bcard/utilities/Classes/locationClass.dart';
import 'package:bcard/utilities/Classes/profileClass.dart';
import 'package:bcard/utilities/Classes/reminderClass.dart';
import 'package:bcard/utilities/Constants/encodersAndDecoders.dart';
import 'package:bcard/utilities/Constants/locationChangeDialog.dart';
import 'package:bcard/utilities/Constants/profileChangeDialog.dart';
import 'package:bcard/utilities/Constants/socialMediaChangeDialog.dart';
import 'package:bcard/utilities/Constants/threeDots.dart';
import 'package:bcard/utilities/firebaseFunctions.dart';
import 'package:bcard/utilities/Constants/randomConstants.dart';
import 'package:bcard/utilities/localStorage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:bcard/screens/CardDesigns/verticalCardDesign.dart';
import 'package:bcard/screens/CardDesigns/horizantalCardDesign.dart';
import 'package:url_launcher/url_launcher.dart';

class DiscoverProfileCardDetails extends StatefulWidget {
  final Profile _profile;
  DiscoverProfileCardDetails(this._profile);
  @override
  _DiscoverProfileCardDetailsState createState() =>
      _DiscoverProfileCardDetailsState();
}

class _DiscoverProfileCardDetailsState
    extends State<DiscoverProfileCardDetails> {
  bool _cardAccepted = false, _cardRequested = false;
  bool _loading = false;
  //List<Reminder> _reminders = [];
  //TODO added above comment for v2.0

  void _requestProfile() async {
    setState(() {
      _loading = true;
    });
    if (_cardRequested && !_cardAccepted) {
      _cardRequested =
          await FirebaseFunctions.deRequestProfile(widget._profile);
    } else if (!_cardRequested) {
      _cardRequested = (await showDialog<bool>(
            context: context,
            builder: (context) => Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              backgroundColor: Colors.transparent,
              child: RequestCardDialog(profile: widget._profile),
            ),
          ) ??
          false);
      //_cardRequested = await FirebaseFunctions.requestProfile(widget._profile);
    }
    setState(() {
      _loading = false;
    });
  }

  Widget _card(Size size) {
    if (widget._profile.cardStructure == CardStructure.horizantal)
      return HorizantalCard(widget._profile, false, () {}, (s) {},
          isMine: false, cardWidth: size.width - 30);
    else
      return VerticalCard(widget._profile, false, () {}, (s) {},
          isMine: false, cardHeight: (size.width - 30) * 11 / 7);
  }

  void _fetchReminders() async {
    /* _reminders =
        await FirebaseFunctions.getRemindersLinkedToProfile(widget._profile.id);
    if (this.mounted) setState(() {}); */
    //TODO added above comment for v2.0
  }

  void _blockProfile() async {
    await AppConfig.blockProfile(widget._profile.id);
    appToast("Profile Blocked", context, color: color4);
    Navigator.pop(context);
    setState(() {});
  }

  void _unblockProfile() async {
    setState(() {
      _loading = true;
    });
    await AppConfig.unblockProfile(widget._profile.id);
    appToast("Profile Unblocked", context, color: color4);
    setState(() {
      _loading = false;
    });
  }

  void _recommendProfile() {
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
          RecommendBottomSheet(widget._profile, profileIds.toList()),
    );
  }

  @override
  void initState() {
    super.initState();
    _fetchReminders();
    _cardAccepted =
        AppConfig.me.acceptedProfiles.contains(widget._profile.id) ||
            widget._profile.profileStatus == ProfileStatus.public;
    _cardRequested =
        AppConfig.me.requestedProfiles.contains(widget._profile.id);
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    bool _profileBlocked =
        AppConfig.me.cardLibraries[3].profileIds.contains(widget._profile.id);
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RichText(
                      text: TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                            text: "Beginner",
                            style: myTs(
                              color: widget._profile.profileLevel ==
                                      ProfileLevel.beginner
                                  ? color4
                                  : color5,
                              size: 12,
                            ),
                          ),
                          TextSpan(
                            text: " / ",
                            style: myTs(
                              color: color5,
                              size: 12,
                            ),
                          ),
                          TextSpan(
                            text: "Intermediate",
                            style: myTs(
                              color: widget._profile.profileLevel ==
                                      ProfileLevel.intermediate
                                  ? color4
                                  : color5,
                              size: 12,
                            ),
                          ),
                          TextSpan(
                            text: " / ",
                            style: myTs(
                              color: color5,
                              size: 12,
                            ),
                          ),
                          TextSpan(
                            text: "Professional",
                            style: myTs(
                              color: widget._profile.profileLevel ==
                                      ProfileLevel.professional
                                  ? color4
                                  : color5,
                              size: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (context) => DiscoverProfileSearchOptions(
                            widget._profile,
                            blockProfile: _blockProfile,
                            allowBlockAndReport: true,
                          ),
                        );
                      },
                      child: Container(
                        height: 20,
                        alignment: Alignment.center,
                        padding:
                            EdgeInsets.symmetric(horizontal: 5, vertical: 0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: color3,
                        ),
                        child: threedots(),
                      ),
                    ),
                  ],
                ),
              ),
              _card(size),
            ] +
            (_profileBlocked
                ? <Widget>[
                    SizedBox(height: 10),
                    Text(
                      "This profile is blocked!",
                      style: myTs(color: color5, size: 18),
                    ),
                    GestureDetector(
                      onTap: _unblockProfile,
                      child: Opacity(
                        opacity: _loading ? 0.5 : 1,
                        child: Container(
                          height: 45,
                          alignment: Alignment.center,
                          margin: EdgeInsets.symmetric(
                              horizontal: 15, vertical: 20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: _cardRequested ? color1 : color4,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Unblock",
                                style: myTs(
                                    color: _cardRequested ? color5 : color1,
                                    size: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ]
                : <Widget>[
                    _requestedBody,
                    Container(
                      height: 20,
                      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: widget._profile.tags.length,
                        separatorBuilder: (context, index) =>
                            SizedBox(width: 10),
                        itemBuilder: (context, i) {
                          return Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 0),
                            //margin: EdgeInsets.symmetric(horizontal: 5),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(3),
                              color: color3,
                            ),
                            child: Text(
                              "#" + widget._profile.tags[i],
                              style: myTs(color: color5, size: 13),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 15),
                    _acceptedBody,
                  ]),
      ),
    );
  }

  Widget get _requestedBody {
    if (!_cardAccepted)
      return GestureDetector(
        onTap: () {
          _requestProfile();
        },
        child: Opacity(
          opacity: _loading ? 0.5 : 1,
          child: Container(
            height: 45,
            alignment: Alignment.center,
            margin: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: _cardRequested ? color1 : color4,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  _cardRequested ? "Requested" : "Send Invite",
                  style: myTs(
                      color: _cardRequested ? color5 : color1,
                      size: 16,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      );
    else
      return SizedBox();
  }

  Widget get _acceptedBody {
    /* Widget _reminderBody(Reminder reminder) {
      void _markAsDone(bool value) {
        reminder.ref.update({"completed": value});
        setState(() {
          reminder.completed = value;
        });
      }

      var size = MediaQuery.of(context).size;

      return Container(
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Container(
                //margin: EdgeInsets.only(right: 10),
                height: Checkbox.width * 1.5,
                width: Checkbox.width * 1.5,
                color: color1,
                child: Theme(
                  data: ThemeData(
                    unselectedWidgetColor: Colors.transparent,
                  ),
                  child: Checkbox(
                    value: reminder.completed,
                    onChanged: (val) {
                      _markAsDone(val);
                      setState(() {
                        reminder.completed = val;
                      });
                    },
                    activeColor: color1,
                    checkColor: color4,
                  ),
                ),
              ),
            ),
            SizedBox(width: 15),
            Container(
              width: size.width - 45 - Checkbox.width * 1.5,
              child: Text(
                reminder.description,
                style: myTs(color: color5, size: 15),
              ),
            ),
          ],
        ),
      );
    } */
    //TODO added above comment for v2.0

    if (_cardAccepted)
      return Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          GridView.count(
            crossAxisCount: 4,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            children: [
              GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) => ProfileChangeDialog(
                      data: widget._profile.mobile,
                      action: (String s) {
                        Uri _mobileUri = new Uri(scheme: "tel", path: s);
                        launch(_mobileUri.toString());
                      },
                      editable: false,
                      save: (List<String> updatedData) {},
                      validator: (s) {
                        return null;
                      },
                      iconPath: "assets/icons/mobile.svg",
                      maxSize: 3,
                      maxLength: 10,
                      hintText: "Add Mobile Number",
                      keyboardType: TextInputType.number,
                      noDataPresent: "No Mobile Numbers Added",
                    ),
                  );
                },
                child: Container(
                  height: 80,
                  child: Column(
                    children: [
                      SvgPicture.asset(
                        "assets/icons/mobile.svg",
                        height: 50,
                        width: 50,
                      ),
                      SizedBox(height: 7),
                      Text(
                        "Mobile",
                        style: myTs(color: color5, size: 12),
                      )
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) => ProfileChangeDialog(
                      data: widget._profile.phone,
                      action: (String s) {
                        Uri _phoneUri = new Uri(scheme: "tel", path: s);
                        launch(_phoneUri.toString());
                      },
                      editable: false,
                      save: (List<String> updatedData) {},
                      validator: (s) {
                        return null;
                      },
                      iconPath: "assets/icons/phone.svg",
                      maxSize: 3,
                      maxLength: 10,
                      hintText: "Add Phone Number",
                      keyboardType: TextInputType.number,
                      noDataPresent: "No Phone Numbers Added",
                    ),
                  );
                },
                child: Container(
                  height: 80,
                  child: Column(
                    children: [
                      SvgPicture.asset(
                        "assets/icons/phone.svg",
                        height: 50,
                        width: 50,
                      ),
                      SizedBox(height: 7),
                      Text(
                        "Phone",
                        style: myTs(color: color5, size: 12),
                      )
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) => ProfileChangeDialog(
                      data: widget._profile.email,
                      action: (String s) {
                        Uri _emailUri = new Uri(scheme: "mailto", path: s);
                        launch(_emailUri.toString());
                      },
                      editable: false,
                      save: (List<String> updatedData) {},
                      validator: (s) {
                        return null;
                      },
                      iconPath: "assets/icons/email.svg",
                      maxSize: 3,
                      maxLength: null,
                      hintText: "Add Email ID",
                      keyboardType: TextInputType.emailAddress,
                      noDataPresent: "No Email IDs Added",
                    ),
                  );
                },
                child: Container(
                  height: 80,
                  child: Column(
                    children: [
                      SvgPicture.asset(
                        "assets/icons/email.svg",
                        height: 50,
                        width: 50,
                      ),
                      SizedBox(height: 7),
                      Text(
                        "E-mail",
                        style: myTs(color: color5, size: 12),
                      )
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => SocialMediaChangeDialog(
                        data: widget._profile.socialMedia,
                        save: (List<String> updatedData) {},
                        editable: false,
                        action: (String s) {
                          if (s != null && s.isNotEmpty) {
                            int index = widget._profile.socialMedia
                                .indexWhere((handle) => handle == s);
                            String url = addHandleHeader(s, index);
                            Uri _httpUri = new Uri(scheme: "https", path: url);
                            launch(_httpUri.toString());
                          }
                        },
                        validator: (s) {
                          return null;
                        },
                        iconPaths: List.generate(
                            5, (i) => "assets/icons/sm${i + 1}.svg"),
                        maxLength: null,
                        hintTexts: [
                          "Add Instagram Handle",
                          "Add WhatsApp Number(+XX)",
                          "Add Behance Handle",
                          "Add LinkedIn Handle",
                          "Add Facebook Handle",
                        ],
                        keyboardType: TextInputType.name),
                  );
                },
                child: Container(
                  height: 80,
                  child: Column(
                    children: [
                      SvgPicture.asset(
                        "assets/icons/socialMedia.svg",
                        height: 50,
                        width: 50,
                      ),
                      SizedBox(height: 7),
                      Text(
                        "Social Media",
                        style: myTs(color: color5, size: 12),
                      )
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) => LocationChangeDialog(
                      data: widget._profile.locations,
                      action: (Location location) async {
                        /* LatLng currLoc = await AppLocation.currentLocation;
                        String mapOptions = [
                          'saddr=${currLoc.latitude},${currLoc.longitude}',
                          'daddr=${location.coordinates.latitude},${location.coordinates.longitude}',
                          'dir_action=navigate'
                        ].join('&');

                        //final url = 'https://www.google.com/maps?$mapOptions'; */
                        String query = Uri.encodeComponent(location.address);
                        final url =
                            "https://www.google.com/maps/search/?api=1&query=$query";
                        launch(url);
                      },
                      editable: false,
                      save: (List<Location> updatedData) {},
                      validator: (s) {
                        return null;
                      },
                      iconPath: "assets/icons/location.svg",
                      maxSize: 3,
                      maxLength: null,
                      hintText: "Add Address",
                      keyboardType: TextInputType.streetAddress,
                      noDataPresent: "No Locations Added",
                    ),
                  );
                },
                child: Container(
                  height: 80,
                  child: Column(
                    children: [
                      SvgPicture.asset(
                        "assets/icons/location.svg",
                        height: 50,
                        width: 50,
                      ),
                      SizedBox(height: 7),
                      Text(
                        "Location",
                        style: myTs(color: color5, size: 12),
                      )
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) => ProfileChangeDialog(
                      data: widget._profile.website,
                      action: (String s) {
                        Uri _httpUri = new Uri(scheme: "http", path: s);
                        launch(_httpUri.toString());
                      },
                      editable: false,
                      save: (List<String> updatedData) {},
                      validator: (s) {
                        return null;
                      },
                      iconPath: "assets/icons/website.svg",
                      maxSize: 3,
                      maxLength: null,
                      hintText: "Add Website",
                      keyboardType: TextInputType.url,
                      noDataPresent: "No Websites Added",
                    ),
                  );
                },
                child: Container(
                  height: 80,
                  child: Column(
                    children: [
                      SvgPicture.asset(
                        "assets/icons/website.svg",
                        height: 50,
                        width: 50,
                      ),
                      SizedBox(height: 7),
                      Text(
                        "Website",
                        style: myTs(color: color5, size: 12),
                      )
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => ShareDialog(widget._profile),
                  );
                },
                child: Container(
                  height: 80,
                  child: Column(
                    children: [
                      SvgPicture.asset(
                        "assets/icons/share1.svg",
                        height: 50,
                        width: 50,
                      ),
                      SizedBox(height: 7),
                      Text(
                        "Share",
                        style: myTs(color: color5, size: 12),
                      )
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  _recommendProfile();
                },
                child: Container(
                  height: 80,
                  child: Column(
                    children: [
                      SvgPicture.asset(
                        "assets/icons/recommend.svg",
                        height: 50,
                        width: 50,
                      ),
                      SizedBox(height: 7),
                      Text(
                        "Recommend",
                        style: myTs(color: color5, size: 12),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
          /* GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AddReminderDialog(
                  profilesAdded: [widget._profile],
                  onAddition: (Reminder reminder) {
                    setState(() {
                      _reminders.add(reminder);
                    });
                    _fetchReminders();
                  },
                ),
              );
            },
            child: Container(
              width: double.maxFinite,
              margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              decoration: BoxDecoration(
                color: color3,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.add,
                    color: color5.withOpacity(0.3),
                  ),
                  Text(
                    "To-do",
                    style: TextStyle(color: color5.withOpacity(0.3)),
                  ),
                ],
              ),
            ),
          ), */
          //TODO added above comment for v2.0
          /* ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: _reminders.length,
            itemBuilder: (context, i) => _reminderBody(_reminders[i]),
          ), */
          //TODO added above comment for v2.0
        ],
      );
    else
      return SizedBox();
  }
}
