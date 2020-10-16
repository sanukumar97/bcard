import 'dart:math';
import 'package:bcard/screens/CardDesigns/verticalCardDesign.dart';
import 'package:bcard/screens/CardDesigns/horizantalCardDesign.dart';
import 'package:bcard/screens/CardDesigns/shareCard.dart';
import 'package:bcard/screens/ProfileTab/requestCardDialog.dart';
import 'package:bcard/utilities/Classes/locationClass.dart';
import 'package:bcard/utilities/Classes/profileClass.dart';
import 'package:bcard/utilities/Constants/locationChangeDialog.dart';
import 'package:bcard/utilities/Constants/profileChangeDialog.dart';
import 'package:bcard/utilities/Constants/randomConstants.dart';
import 'package:bcard/utilities/Constants/socialMediaChangeDialog.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:showcaseview/showcaseview.dart';

class ProfilePageDetails extends StatefulWidget {
  final Function startEditing;
  bool _edit;
  final Function(String) showErrorMessage;
  final Profile _profile;
  ProfilePageDetails(
      this._profile, this.startEditing, this._edit, this.showErrorMessage);

  @override
  _ProfilePageDetailsState createState() => _ProfilePageDetailsState();
}

class _ProfilePageDetailsState extends State<ProfilePageDetails> {
  GlobalKey _tagHint = new GlobalKey();

  void _shareCardDialog() {
    showDialog(
      context: context,
      builder: (context) => ShareDialog(widget._profile),
    );
  }

  void _requestCardDialog() {
    showDialog(
      context: context,
      builder: (context) => RequestCardDialog(),
    );
  }

  void cardStructureChanged() {
    setState(() {});
  }

  void _changeProfileLevel(ProfileLevel level) {
    setState(() {
      widget._profile.profileLevel = level;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              if (!widget._edit) {
                widget.startEditing();
                setState(() {
                  widget._edit = true;
                });
              }
            },
            child: widget._profile.cardStructure == CardStructure.horizantal
                ? HorizantalCard(widget._profile, widget._edit,
                    cardStructureChanged, widget.showErrorMessage)
                : VerticalCard(widget._profile, widget._edit,
                    cardStructureChanged, widget.showErrorMessage),
          ),
          SizedBox(height: 35),
          widget._edit
              ? GridView.count(
                  crossAxisCount: 3,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    GestureDetector(
                      onTap: _updateMobile,
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
                      onTap: _updatePhone,
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
                      onTap: _updateEmail,
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
                      onTap: _updateLocation,
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
                      onTap: _updateWebsites,
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
                      onTap: _updateSocialMedia,
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
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: _requestCardDialog,
                      child: Container(
                        height: 94,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SvgPicture.asset(
                              "assets/icons/reqCard.svg",
                              height: 50,
                              width: 50,
                            ),
                            SizedBox(height: 7),
                            Text(
                              "Request Card",
                              style: myTs(color: color5, size: 12),
                            )
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        height: 94,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SvgPicture.asset(
                              "assets/icons/scanCard.svg",
                              height: 50,
                              width: 50,
                            ),
                            SizedBox(height: 7),
                            Text(
                              "Scan Card",
                              style: myTs(color: color5, size: 12),
                            ),
                            SizedBox(height: 7),
                            Text(
                              "Coming soon",
                              style: myTs(color: color4, size: 12),
                            ),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: _shareCardDialog,
                      child: Container(
                        height: 94,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SvgPicture.asset(
                              "assets/icons/shareCard.svg",
                              height: 50,
                              width: 50,
                            ),
                            SizedBox(height: 7),
                            Text(
                              "Share Card",
                              style: myTs(color: color5, size: 12),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
          //SizedBox(height: 20),
          widget._edit
              ? Container(
                  height: 30,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: min(12, widget._profile.tags.length + 1),
                    itemBuilder: (context, index) {
                      int i =
                          widget._profile.tags.length == 12 ? index : index - 1;
                      if (i == -1) {
                        return ShowCaseWidget(
                          builder: Builder(
                            builder: (context) => Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                    Showcase(
                                      key: _tagHint,
                                      shapeBorder: null,
                                      disableAnimation: true,
                                      overlayColor: color3,
                                      showcaseBackgroundColor: color3,
                                      textColor: color5,
                                      description: "Add #tag for better reach",
                                      showArrow: true,
                                      child: GestureDetector(
                                        onTap: () {
                                          showDialog(
                                            context: context,
                                            barrierDismissible: false,
                                            builder: (context) =>
                                                ProfileChangeDialog(
                                              data: widget._profile.tags,
                                              hintText: "Add a tag",
                                              iconPath: null,
                                              keyboardType: TextInputType.text,
                                              maxLength: null,
                                              maxSize: 12,
                                              save: (List<String> s) {
                                                setState(() {
                                                  widget._profile.tags = s
                                                      .map<String>((e) =>
                                                          e.toLowerCase())
                                                      .toList();
                                                });
                                              },
                                              validator: (s) {
                                                return null;
                                              },
                                              icon: Container(
                                                height: 50,
                                                width: 50,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: color2,
                                                ),
                                                alignment: Alignment.center,
                                                child: Text(
                                                  "#",
                                                  style: myTs(
                                                      color: color5, size: 30),
                                                ),
                                              ),
                                              noDataPresent: null,
                                            ),
                                          );
                                        },
                                        child: Container(
                                          width: 70,
                                          padding: EdgeInsets.all(5),
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 5),
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            color: color4,
                                          ),
                                          child: Icon(
                                            Icons.add,
                                            color: color1,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ] +
                                  (widget._profile.tags.isEmpty
                                      ? <Widget>[
                                          GestureDetector(
                                            child: Container(
                                              alignment: Alignment.center,
                                              child: Icon(
                                                Icons.help_outline,
                                                color: color6,
                                                size: 20,
                                              ),
                                            ),
                                            onTap: () {
                                              ShowCaseWidget.of(context)
                                                  .startShowCase([_tagHint]);
                                            },
                                          ),
                                        ]
                                      : <Widget>[]),
                            ),
                          ),
                        );
                      }
                      return GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) => ProfileChangeDialog(
                              data: widget._profile.tags,
                              hintText: "Add a tag",
                              iconPath: null,
                              keyboardType: TextInputType.text,
                              maxLength: null,
                              maxSize: 5,
                              save: (List<String> s) {
                                setState(() {
                                  widget._profile.tags = s;
                                });
                              },
                              validator: (s) {
                                return null;
                              },
                              editIndex: i,
                              icon: Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: color2,
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  "#",
                                  style: myTs(color: color5, size: 30),
                                ),
                              ),
                              noDataPresent: null,
                            ),
                          );
                        },
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                          margin: EdgeInsets.symmetric(horizontal: 5),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: color3,
                          ),
                          child: Text(
                            "#" + widget._profile.tags[i],
                            style: myTs(color: color5, size: 15),
                          ),
                        ),
                      );
                    },
                  ),
                )
              : SizedBox(),
          SizedBox(height: 15),
          widget._edit
              ? Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                  child: RichText(
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              _changeProfileLevel(ProfileLevel.beginner);
                            },
                          text: "Beginner",
                          style: myTs(
                            color: widget._profile.profileLevel ==
                                    ProfileLevel.beginner
                                ? color4
                                : color5,
                            size: 14,
                          ),
                        ),
                        TextSpan(
                          text: " / ",
                          style: myTs(
                            color: color5,
                            size: 14,
                          ),
                        ),
                        TextSpan(
                          text: "Intermediate",
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              _changeProfileLevel(ProfileLevel.intermediate);
                            },
                          style: myTs(
                            color: widget._profile.profileLevel ==
                                    ProfileLevel.intermediate
                                ? color4
                                : color5,
                            size: 14,
                          ),
                        ),
                        TextSpan(
                          text: " / ",
                          style: myTs(
                            color: color5,
                            size: 14,
                          ),
                        ),
                        TextSpan(
                          text: "Professional",
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              _changeProfileLevel(ProfileLevel.professional);
                            },
                          style: myTs(
                            color: widget._profile.profileLevel ==
                                    ProfileLevel.professional
                                ? color4
                                : color5,
                            size: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : SizedBox(),
          SizedBox(height: 60),
        ],
      ),
    );
  }

  void _updateMobile() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => ProfileChangeDialog(
        data: widget._profile.mobile,
        save: (List<String> updatedData) {
          widget._profile.mobile = updatedData;
        },
        validator: (s) {
          if (s.isEmpty)
            return "Enter Mobile Number";
          else if (s.isNotEmpty && !RegExp(r'^[0-9]+$').hasMatch(s))
            return "Not Valid";
          else if (s.isNotEmpty && s.length < 10)
            return "Not a 10-digit number";
          else
            return null;
        },
        iconPath: "assets/icons/mobile.svg",
        maxSize: 3,
        maxLength: 10,
        hintText: "Add Mobile Number",
        keyboardType: TextInputType.number,
        noDataPresent: null,
      ),
    );
  }

  void _updatePhone() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => ProfileChangeDialog(
        data: widget._profile.phone,
        save: (List<String> updatedData) {
          widget._profile.phone = updatedData;
        },
        validator: (s) {
          if (s.isEmpty)
            return "Enter Phone Number";
          else if (s.isNotEmpty && !RegExp(r'^[0-9]+$').hasMatch(s))
            return "Not Valid";
          /* else if (s.isNotEmpty && s.length < 10)
                                return "Not a 10-digit number"; */
          else
            return null;
        },
        iconPath: "assets/icons/phone.svg",
        maxSize: 3,
        maxLength: null,
        hintText: "Add Phone Number",
        keyboardType: TextInputType.number,
        noDataPresent: null,
      ),
    );
  }

  void _updateEmail() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => ProfileChangeDialog(
        data: widget._profile.email,
        save: (List<String> updatedData) {
          widget._profile.email = updatedData;
        },
        validator: (s) {
          if (s.isEmpty)
            return "Enter Email ID";
          else if (s.isNotEmpty &&
              !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                  .hasMatch(s))
            return "Not Valid";
          else
            return null;
        },
        iconPath: "assets/icons/email.svg",
        maxSize: 3,
        maxLength: null,
        hintText: "Add Email ID",
        keyboardType: TextInputType.emailAddress,
        noDataPresent: null,
      ),
    );
  }

  void _updateWebsites() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => ProfileChangeDialog(
        data: widget._profile.website,
        save: (List<String> updatedData) {
          widget._profile.website = updatedData;
        },
        validator: (s) {
          if (s.isEmpty)
            return "Enter Website";
          else if (s.isNotEmpty && !Uri.parse(s).isAbsolute)
            return "Not Valid";
          else
            return null;
        },
        iconPath: "assets/icons/website.svg",
        maxSize: 3,
        maxLength: null,
        hintText: "Add Website",
        keyboardType: TextInputType.url,
        noDataPresent: null,
      ),
    );
  }

  void _updateLocation() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => LocationChangeDialog(
        data: widget._profile.locations,
        save: (List<Location> updatedData) {
          widget._profile.locations = updatedData;
        },
        validator: (s) {
          if (s.isEmpty)
            return "Enter Address";
          else
            return null;
        },
        iconPath: "assets/icons/location.svg",
        maxSize: 3,
        maxLength: null,
        hintText: "Add Address",
        keyboardType: TextInputType.streetAddress,
        noDataPresent: null,
      ),
    );
  }

  void _updateSocialMedia() {
    showDialog(
      context: context,
      builder: (context) => SocialMediaChangeDialog(
          data: widget._profile.socialMedia,
          save: (List<String> updatedData) {
            widget._profile.socialMedia = updatedData;
          },
          validator: (s) {
            return null;
          },
          iconPaths: List.generate(5, (i) => "assets/icons/sm${i + 1}.svg"),
          maxLength: null,
          hintTexts: [
            "Add Instagram Handle",
            "Add Behance Handle",
            "Add LinkedIn Handle",
            "Add Facebook Handle",
            "Add Medium Handle",
          ],
          keyboardType: TextInputType.name),
    );
  }
}
