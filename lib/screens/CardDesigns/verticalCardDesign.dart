import 'dart:io';
import 'package:bcard/utilities/Classes/profileClass.dart';
import 'package:bcard/utilities/Constants/logoBox.dart';
import 'package:bcard/utilities/Constants/profileBackgroundChangeDialog.dart';
import 'package:bcard/utilities/Constants/textFieldDialog.dart';
import 'package:bcard/utilities/connectivity.dart';
import 'package:bcard/utilities/Constants/randomConstants.dart';
import 'package:bcard/utilities/firebaseFunctions.dart';
import 'package:bcard/utilities/localStorage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class VerticalCard extends StatefulWidget {
  final Profile _profile;
  final bool _edit;
  Function cardStructureChanged;
  final Function(String) showErrorMessage;
  final bool isMine;
  final double cardHeight;
  VerticalCard(this._profile, this._edit, this.cardStructureChanged,
      this.showErrorMessage,
      {this.cardHeight, this.isMine = true});
  @override
  _VerticalCardState createState() => _VerticalCardState();
}

class _VerticalCardState extends State<VerticalCard> {
  final double _aspectRatio = 7 / 11;

  void uploadLogo() async {
    if (AppConnectivity.isConnected) {
      File image = await ImagePicker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        int bytes = await image.length();
        if (bytes / 1024 <= 1024) {
          image = await ImageCropper.cropImage(
            sourcePath: image.path,
            aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
            compressFormat: ImageCompressFormat.png,
            cropStyle: CropStyle.rectangle,
          );
          if (image != null) {
            String name = AppConfig.me.userId +
                profileTypeNames[widget._profile.profileType] +
                "Logo";
            widget._profile.logoUrl =
                await FirebaseFunctions.uploadImage(image, name);
            await AppConfig.saveUrls(
                widget._profile.logoUrl, 2, widget._profile.profileType);
            setState(() {});
          }
        } else {
          appToast("Maximum size is 1MB", context);
        }
      }
    } else {
      widget.showErrorMessage("Connect to Internet to edit!");
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double cardHeight = widget.cardHeight ?? size.height * 0.50;
    double cardWidth = cardHeight * _aspectRatio;
    double logoSize = cardWidth * 0.5 * 5 / 7;
    bool _hasCover = widget._profile.coverUrl != null;

    return Card(
      elevation: 5.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        height: cardHeight,
        width: cardWidth,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.grey.withOpacity(0.4),
          image: widget.isMine
              ? (widget._profile.coverUrl != null &&
                      AppConfig.imageAvailable(0, widget._profile.profileType)
                  ? DecorationImage(
                      fit: BoxFit.cover,
                      image: MemoryImage(
                        AppConfig.getImageBytes(0, widget._profile.profileType),
                      ),
                    )
                  : widget._profile.backgroundImageUrl != null &&
                          AppConfig.imageAvailable(
                              1, widget._profile.profileType)
                      ? DecorationImage(
                          fit: BoxFit.cover,
                          image: MemoryImage(
                            AppConfig.getImageBytes(
                                1, widget._profile.profileType),
                          ),
                        )
                      : AppConfig.defaultVerticalCardDesign != null
                          ? DecorationImage(
                              fit: BoxFit.fill,
                              image: NetworkImage(
                                  AppConfig.defaultVerticalCardDesign),
                            )
                          : null)
              : (widget._profile.coverUrl != null
                  ? DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(widget._profile.coverUrl),
                    )
                  : widget._profile.backgroundImageUrl != null
                      ? DecorationImage(
                          fit: BoxFit.cover,
                          image:
                              NetworkImage(widget._profile.backgroundImageUrl),
                        )
                      : AppConfig.defaultVerticalCardDesign != null
                          ? DecorationImage(
                              fit: BoxFit.fill,
                              image: NetworkImage(
                                  AppConfig.defaultVerticalCardDesign),
                            )
                          : null),
        ),
        child: Stack(
          children: (widget._edit
                  ? <Widget>[
                      Positioned(
                        left: 10,
                        top: 10,
                        child: GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (context) =>
                                  ProfileBackGroundChangeDialog(
                                widget._profile.backgroundImageUrl,
                                widget._profile.coverUrl,
                                (String backgroundUrl,
                                    String coverUrl,
                                    CardStructure cardStructure,
                                    ProfileStatus profileStatus) async {
                                  if (widget._profile.backgroundImageUrl !=
                                      backgroundUrl) {
                                    widget._profile.backgroundImageUrl =
                                        backgroundUrl;
                                    await AppConfig.saveUrls(backgroundUrl, 1,
                                        widget._profile.profileType);
                                  }
                                  if (widget._profile.coverUrl != coverUrl) {
                                    widget._profile.coverUrl = coverUrl;
                                    await AppConfig.saveUrls(coverUrl, 0,
                                        widget._profile.profileType);
                                  }
                                  widget._profile.cardStructure = cardStructure;
                                  widget._profile.profileStatus = profileStatus;
                                  widget.cardStructureChanged();
                                },
                                widget._profile.cardStructure,
                                widget._profile.profileStatus,
                              ),
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 2, horizontal: 7),
                            decoration: BoxDecoration(
                              color: color4,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "Edit Background",
                                  style: myTs(
                                    color: color5,
                                    size: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(width: 2),
                                Icon(
                                  Icons.edit,
                                  color: color5,
                                  size: 15,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ]
                  : <Widget>[]) +
              (_hasCover && !widget._edit
                  ? <Widget>[]
                  : <Widget>[
                      Positioned(
                        left: cardWidth * 0.5 / 7,
                        bottom: cardHeight * 0.25 + 10,
                        child: GestureDetector(
                          onTap: widget._edit
                              ? () {
                                  showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (context) => MyTextFieldDialog(
                                      (String s, Color c) {
                                        setState(() {
                                          widget._profile.companyName = s;
                                          widget._profile.companyNameColor = c;
                                        });
                                      },
                                      widget._profile.companyName,
                                      "Company Name",
                                      20,
                                      color: widget._profile.companyNameColor,
                                    ),
                                  );
                                }
                              : null,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                                  Text(
                                    widget._profile.companyName ??
                                        "Company Name",
                                    style: myTs(
                                        color: widget._profile.companyNameColor,
                                        size: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ] +
                                (widget._edit
                                    ? <Widget>[
                                        SizedBox(width: 5),
                                        Container(
                                          height: 15,
                                          width: 15,
                                          child: SvgPicture.asset(
                                            "assets/icons/edit.svg",
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                      ]
                                    : <Widget>[]),
                          ),
                        ),
                      ),
                      Positioned(
                        left: cardWidth * 0.5 / 7,
                        bottom: cardHeight * 0.25 - 15,
                        child: GestureDetector(
                          onTap: widget._edit
                              ? () {
                                  showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (context) => MyTextFieldDialog(
                                      (String s, Color c) {
                                        setState(() {
                                          widget._profile.occupation = s;
                                          widget._profile.occupationColor = c;
                                        });
                                      },
                                      widget._profile.occupation,
                                      "Occupation",
                                      20,
                                      color: widget._profile.occupationColor,
                                    ),
                                  );
                                }
                              : null,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                                  Text(
                                    widget._profile.occupation ?? "Occupation",
                                    style: myTs(
                                      color: widget._profile.occupationColor,
                                      size: 18,
                                    ),
                                  ),
                                ] +
                                (widget._edit
                                    ? <Widget>[
                                        SizedBox(width: 5),
                                        Container(
                                          height: 15,
                                          width: 15,
                                          child: SvgPicture.asset(
                                            "assets/icons/edit.svg",
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                      ]
                                    : <Widget>[]),
                          ),
                        ),
                      ),
                      Positioned(
                        left: cardWidth * 0.5 / 7,
                        bottom: cardHeight * 0.25 - 40,
                        child: GestureDetector(
                          onTap: widget._edit
                              ? () {
                                  showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (context) => MyTextFieldDialog(
                                      (String s, Color c) {
                                        setState(() {
                                          widget._profile.name = s;
                                          widget._profile.nameColor = c;
                                        });
                                      },
                                      widget._profile.name,
                                      "Your Name",
                                      20,
                                      color: widget._profile.nameColor,
                                    ),
                                  );
                                }
                              : null,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                                  Text(
                                    widget._profile.name ?? "Your Name",
                                    style: myTs(
                                        color: widget._profile.nameColor,
                                        size: 18,
                                        fontStyle: FontStyle.italic),
                                  ),
                                ] +
                                (widget._edit
                                    ? <Widget>[
                                        SizedBox(width: 5),
                                        Container(
                                          height: 25,
                                          child: Container(
                                            height: 15,
                                            width: 15,
                                            child: SvgPicture.asset(
                                              "assets/icons/edit.svg",
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                        ),
                                      ]
                                    : <Widget>[]),
                          ),
                        ),
                      ),
                      Positioned(
                        left: cardWidth * 0.5 / 7,
                        top: cardHeight * (0.5 - 1 / 14),
                        child: Container(
                          height: logoSize,
                          width: logoSize,
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.4),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Stack(
                            children: <Widget>[
                                  logoBox(
                                      widget.isMine,
                                      widget._profile.logoUrl,
                                      widget._profile.profileType,
                                      logoSize,
                                      logoSize),
                                ] +
                                (widget._edit
                                    ? <Widget>[
                                        Positioned(
                                          left: 2,
                                          top: 2,
                                          child: GestureDetector(
                                            onTap: () {
                                              uploadLogo();
                                            },
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 2, horizontal: 5),
                                              decoration: BoxDecoration(
                                                color: color4,
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                              ),
                                              child: Text(
                                                "Edit",
                                                style: myTs(
                                                  color: color5,
                                                  size: 12,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ]
                                    : <Widget>[]),
                          ),
                        ),
                      ),
                    ]),
        ),
      ),
    );
  }
}
