import 'dart:io';
import 'package:bcard/utilities/Classes/profileClass.dart';
import 'package:bcard/utilities/connectivity.dart';
import 'package:bcard/utilities/Constants/randomConstants.dart';
import 'package:bcard/utilities/firebaseFunctions.dart';
import 'package:bcard/utilities/localStorage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ProfileBackGroundChangeDialog extends StatefulWidget {
  CardStructure cardStructure;
  String backgroundUrl;
  String coverUrl;
  ProfileStatus profileStatus;
  Function(String, String, CardStructure, ProfileStatus) onSaved;

  ProfileBackGroundChangeDialog(this.backgroundUrl, this.coverUrl, this.onSaved,
      this.cardStructure, this.profileStatus);
  @override
  _ProfileBackGroundChangeDialogState createState() =>
      _ProfileBackGroundChangeDialogState(this.backgroundUrl, this.coverUrl,
          this.cardStructure, this.profileStatus);
}

class _ProfileBackGroundChangeDialogState
    extends State<ProfileBackGroundChangeDialog> {
  CardStructure cardStructure;
  String backgroundUrl;
  String coverUrl;
  ProfileStatus profileStatus;
  _ProfileBackGroundChangeDialogState(this.backgroundUrl, this.coverUrl,
      this.cardStructure, this.profileStatus);
  bool isHorizontal;
  List<String> urls;
  List<String> horizUrls = AppConfig.horizantalCardDesigns,
      vertUrls = AppConfig.verticalCardDesigns;
  ScrollController _scrollController = new ScrollController();
  bool _imageUploading = false;

  void uploadImage() async {
    if (AppConnectivity.isConnected && AppConfig.firstSyncDone) {
      setState(() {
        _imageUploading = true;
      });
      File image = await ImagePicker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        int bytes = await image.length();
        if (bytes / 1024 <= 1024) {
          image = await ImageCropper.cropImage(
            sourcePath: image.path,
            aspectRatio: isHorizontal
                ? CropAspectRatio(ratioX: 11, ratioY: 7)
                : CropAspectRatio(ratioX: 7, ratioY: 11),
            compressFormat: ImageCompressFormat.png,
            cropStyle: CropStyle.rectangle,
          );
          if (image != null) {
            String name = AppConfig.me.userId +
                profileTypeNames[AppConfig.me.businessProfile.profileType] +
                "Cover";

            coverUrl = await FirebaseFunctions.uploadImage(image, name);
            setState(() {
              _imageUploading = false;
            });
          }
        } else {
          appToast("Maximum size is 1MB", context);
        }
      }
      setState(() {
        _imageUploading = false;
      });
    } else {
      appToast("Connect to Internet to edit!", context);
    }
  }

  void deleteCoverUrl() {
    setState(() {
      coverUrl = null;
    });
  }

  @override
  void initState() {
    super.initState();
    isHorizontal = widget.cardStructure == CardStructure.horizantal;
    urls = isHorizontal ? horizUrls : vertUrls;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async => false,
      child: AlertDialog(
        scrollable: true,
        contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        backgroundColor: color1,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 10, left: 15, right: 15),
              alignment: Alignment.centerLeft,
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(
                  Icons.arrow_back,
                  color: color5,
                ),
              ),
            ),
            /* Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      if (!isHorizontal) {
                        setState(() {
                          cardStructure = CardStructure.horizantal;
                          isHorizontal = true;
                          urls = horizUrls;
                        });
                      }
                    },
                    child: Container(
                      width: double.maxFinite,
                      height: 30,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Horizontal",
                            style: myTs(
                                color: isHorizontal ? color4 : color5,
                                size: 15),
                          ),
                          SizedBox(width: 5),
                          Container(
                            height: 14,
                            width: 22,
                            color: isHorizontal ? color4 : color5,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 0.5,
                  height: 30,
                  color: color5.withOpacity(0.5),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      if (isHorizontal) {
                        setState(() {
                          cardStructure = CardStructure.vertical;
                          isHorizontal = false;
                          urls = vertUrls;
                        });
                      }
                    },
                    child: Container(
                      width: double.maxFinite,
                      height: 30,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Vertical",
                            style: myTs(
                                color: !isHorizontal ? color4 : color5,
                                size: 15),
                          ),
                          SizedBox(width: 5),
                          Container(
                            height: 22,
                            width: 14,
                            color: !isHorizontal ? color4 : color5,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ), */
            //TODO Commented above widget for v2.0

            Container(
              height: size.width * 0.6 * 11 / 7 + 20,
              width: size.width * 0.6 + 20,
              padding: EdgeInsets.all(20),
              child: Container(
                height: size.width * 0.5 * (isHorizontal ? 7 / 11 : 11 / 7),
                width: size.width * 0.5,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: backgroundUrl == null
                      ? Container(
                          color: Colors.grey.withOpacity(0.4),
                          child: Center(
                            child: Text(
                              "No Background selected",
                              textAlign: TextAlign.center,
                              style: myTs(color: color5),
                            ),
                          ),
                        )
                      : Image.network(backgroundUrl, fit: BoxFit.contain),
                ),
              ),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back_ios, color: color5),
                  onPressed: () {
                    int i = urls.indexWhere((url) => url == backgroundUrl);
                    if (i > 0) {
                      double d = isHorizontal ? 55 : 35;
                      _scrollController.animateTo((i - 1) * d + 10,
                          duration: Duration(milliseconds: 200),
                          curve: Curves.ease);
                      setState(() {
                        backgroundUrl = urls[i - 1];
                      });
                    }
                  },
                ),
                Expanded(
                  child: Container(
                    height: isHorizontal ? 35 : 55,
                    child: ListView.builder(
                      controller: _scrollController,
                      itemCount: urls.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, i) {
                        bool isSelected = backgroundUrl == urls[i];
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              backgroundUrl = urls[i];
                            });
                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 5),
                            decoration: BoxDecoration(
                              border: isSelected
                                  ? Border.all(color: color4, width: 1.5)
                                  : null,
                            ),
                            height: isHorizontal ? 35 : 55,
                            width: isHorizontal ? 55 : 35,
                            child: Image.network(urls[i]),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.arrow_forward_ios, color: color5),
                  onPressed: () {
                    int i = urls.indexWhere((url) => url == backgroundUrl);
                    if (i >= 0 && i != urls.length - 1) {
                      double d = isHorizontal ? 55 : 35;
                      _scrollController.animateTo((i + 1) * d + 10,
                          duration: Duration(milliseconds: 200),
                          curve: Curves.ease);
                      setState(() {
                        backgroundUrl = urls[i + 1];
                      });
                    }
                  },
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: Divider(
                    thickness: 0.1,
                    color: color5,
                    indent: 20,
                    endIndent: 5,
                  ),
                ),
                Text(
                  "OR",
                  style: myTs(color: Colors.grey, size: 12),
                ),
                Expanded(
                  child: Divider(
                    thickness: 0.1,
                    color: color5,
                    indent: 5,
                    endIndent: 20,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: coverUrl == null
                      ? Column(
                          children: [
                            GestureDetector(
                                onTap: () {
                                  uploadImage();
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 5),
                                  decoration: BoxDecoration(
                                    color: color3,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: SvgPicture.asset(
                                            "assets/icons/uploadCardIcon.svg"),
                                      ),
                                      SizedBox(width: 5),
                                      Text(
                                        "Upload Card",
                                        style: myTs(color: color5, size: 15),
                                      )
                                    ],
                                  ),
                                )),
                            Text(
                              "Maximum size: 1MB",
                              style: myTs(color: color4, size: 10),
                            ),
                          ],
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: 30,
                              child: _imageUploading
                                  ? CircularProgressIndicator()
                                  : Image.network(
                                      coverUrl,
                                      loadingBuilder:
                                          (context, child, loadingProgress) {
                                        if (loadingProgress == null)
                                          return child;
                                        return CircularProgressIndicator();
                                      },
                                    ),
                            ),
                            SizedBox(width: 10),
                            IconButton(
                              icon: Icon(
                                Icons.close,
                                color: Colors.redAccent,
                                size: 25,
                              ),
                              onPressed: () {
                                deleteCoverUrl();
                              },
                            ),
                          ],
                        ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (!_imageUploading) {
                            widget.onSaved(backgroundUrl, coverUrl,
                                cardStructure, profileStatus);
                            Navigator.pop(context);
                          }
                        },
                        child: Container(
                          alignment: Alignment.topCenter,
                          margin: EdgeInsets.symmetric(horizontal: 5),
                          padding:
                              EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                          decoration: BoxDecoration(
                            color:
                                color3.withOpacity(_imageUploading ? 0.1 : 1),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Done",
                                style: myTs(
                                    color: color5
                                        .withOpacity(_imageUploading ? 0.1 : 1),
                                    size: 15),
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                    ],
                  ),
                ),
                SizedBox(width: 10),
              ],
            ),
            SizedBox(height: 10),

            /* Divider(
              color: color5,
              indent: 10,
              endIndent: 10,
              thickness: 0.1,
            ), */
            //TODO Commented above widget for v2.0

            /* Column(
              children: [
                Container(
                  alignment: Alignment.center,
                  child: Text(
                    "Profile Status",
                    style: myTs(color: color5, size: 15),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Public",
                            style: myTs(color: color5, size: 12),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 5),
                          Text(
                            "Every one can see your profile details",
                            textAlign: TextAlign.center,
                            style: myTs(color: color6, size: 8),
                          ),
                        ],
                      ),
                    ),
                    Switch(
                      value: profileStatus == ProfileStatus.requested,
                      onChanged: (status) {
                        setState(() {
                          profileStatus = status
                              ? ProfileStatus.requested
                              : ProfileStatus.public;
                        });
                      },
                      activeColor: color4,
                      inactiveThumbColor: color4,
                      activeTrackColor: color5,
                      inactiveTrackColor: color5,
                    ),
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Requested",
                            style: myTs(color: color5, size: 12),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 5),
                          Text(
                            "Request required to see your profile details",
                            textAlign: TextAlign.center,
                            style: myTs(color: color6, size: 8),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ), */
            //TODO Commented above widget for v2.0
          ],
        ),
      ),
    );
  }
}
