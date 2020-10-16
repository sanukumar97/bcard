import 'package:bcard/screens/CardDesigns/verticalCardDesign.dart';
import 'package:bcard/screens/CardDesigns/horizantalCardDesign.dart';
import 'package:bcard/utilities/Classes/profileClass.dart';
import 'package:bcard/utilities/Constants/randomConstants.dart';
import 'package:bcard/utilities/localStorage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';
import 'dart:ui' as ui;

class ShareDialog extends StatelessWidget {
  final Profile _profile;
  ShareDialog(this._profile);
  List<double> _tagWidths = [];

  static GlobalKey _previewContainer = GlobalKey();

  void _shareCard(BuildContext context) async {
    RenderRepaintBoundary boundary =
        _previewContainer.currentContext.findRenderObject();
    ui.Image image = await boundary.toImage();
    final directory = (await getExternalStorageDirectory()).path;
    ByteData byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List pngBytes = byteData.buffer.asUint8List();
    String name = '$directory/${DateTime.now().toIso8601String()}.png';
    File imgFile = new File(name);
    await imgFile.writeAsBytes(pngBytes);
    Share.shareFiles([name],
            subject: 'Screenshot + Share',
            text:
                "Heyy, ${AppConfig.me.name} recommend you a connection. \n\n Install the app from: https://play.google.com/store/apps/details?id=com.peoplecard.app")
        .catchError((e) {
      print("Error while sharing card $e");
      appToast("An Error occured", context);
    });
  }

  void _setTagWidths(Size size) {
    BoxConstraints constraints = BoxConstraints(
      maxWidth: size.width - 30,
    );
    TextStyle style = myTs(color: color5, size: 13);
    _profile.tags.forEach((tag) {
      _tagWidths.add(getTextWidth("#" + tag, style, constraints, 20));
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    _setTagWidths(size);
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        color: color2.withOpacity(0.2),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(color: Colors.transparent),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: color2,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  RepaintBoundary(
                    key: _previewContainer,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          padding:
                              EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                          child: RichText(
                            text: TextSpan(
                              children: <TextSpan>[
                                TextSpan(
                                  text: "Beginner",
                                  style: myTs(
                                    color: _profile.profileLevel ==
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
                                  style: myTs(
                                    color: _profile.profileLevel ==
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
                                  style: myTs(
                                    color: _profile.profileLevel ==
                                            ProfileLevel.professional
                                        ? color4
                                        : color5,
                                    size: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        _profile.cardStructure == CardStructure.horizantal
                            ? HorizantalCard(_profile, false, () {}, (s) {})
                            : VerticalCard(_profile, false, () {}, (s) {}),
                        SizedBox(height: 5),
                        _customTagsGridView(size),
                        SizedBox(height: 10),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(bottom: 15, top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 20),
                            padding: EdgeInsets.symmetric(
                                horizontal: 15, vertical: 5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: color3,
                            ),
                            child: Text(
                              "Cancel",
                              style: myTs(color: color5, size: 16),
                            ),
                          ),
                          onTap: () {
                            Navigator.pop(context);
                          },
                        ),
                        GestureDetector(
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 0),
                            padding: EdgeInsets.symmetric(
                                horizontal: 15, vertical: 5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: color3,
                            ),
                            child: Text(
                              "Share",
                              style: myTs(color: color5, size: 16),
                            ),
                          ),
                          onTap: () {
                            _shareCard(context);
                          },
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(color: Colors.transparent),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _customTagsGridView(Size size) {
    List<Widget> rows = [];
    double currentRowLengthUsed = 0.0;
    double maxLength = size.width - 30;
    List<Widget> children = [];
    for (int i = 0; i < _profile.tags.length; i++) {
      if (currentRowLengthUsed + _tagWidths[i] + 25.0 < maxLength) {
        children.add(
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
            margin: EdgeInsets.symmetric(horizontal: 2.5, vertical: 2.5),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(3),
              color: color3,
            ),
            child: Text(
              "#" + _profile.tags[i],
              style: myTs(color: color5, size: 13),
            ),
          ),
        );
        currentRowLengthUsed += _tagWidths[i] + 25.0;
      } else {
        children.add(Spacer());
        rows.add(
          new Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: new List<Widget>.from(children),
          ),
        );
        i -= 1;
        children.clear();
        currentRowLengthUsed = 0.0;
      }
    }
    children.add(Spacer());
    rows.add(
      new Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: new List<Widget>.from(children),
      ),
    );
    return new Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: rows,
    );
  }
}
