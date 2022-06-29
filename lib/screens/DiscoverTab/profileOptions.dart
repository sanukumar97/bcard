import 'package:bcard/screens/CardDesigns/shareCard.dart';
import 'package:bcard/screens/DiscoverTab/recommendBottomSheet.dart';
import 'package:bcard/screens/DiscoverTab/reportProfileDialog.dart';
import 'package:bcard/utilities/Classes/libraryClass.dart';
import 'package:bcard/utilities/Classes/profileClass.dart';
import 'package:bcard/utilities/Constants/createCategoryDialog.dart';
import 'package:bcard/utilities/Constants/randomConstants.dart';
import 'package:bcard/utilities/localStorage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DiscoverProfileSearchOptions extends StatefulWidget {
  final Profile _profile;
  final bool allowBlockAndReport;
  final Function() blockProfile;
  DiscoverProfileSearchOptions(this._profile,
      {this.blockProfile, this.allowBlockAndReport = false});

  @override
  _DiscoverProfileSearchOptionsState createState() =>
      _DiscoverProfileSearchOptionsState();
}

class _DiscoverProfileSearchOptionsState
    extends State<DiscoverProfileSearchOptions> {
  bool _selectLibrary = false;
  List<Library> _libraryList = [];

  void _recommendProfile() {
    Set<String> profileIds = new Set<String>();
    AppConfig.me.cardLibraries.forEach((lib) {
      profileIds.addAll(lib.profileIds);
    });
    Navigator.pop(context);
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

  void _shareCardDialog() {
    Navigator.pop(context);
    showDialog(
      context: context,
      builder: (context) => ShareDialog(widget._profile),
    );
  }

  void _reportProfile() {
    Navigator.pop(context);
    showDialog(
      context: context,
      builder: (context) => ReportProfileDialog(widget._profile),
    );
  }

  @override
  void initState() {
    super.initState();
    _libraryList = List.from(AppConfig.me.cardLibraries);
  }

  @override
  Widget build(BuildContext context) {
    bool _inRecent =
        AppConfig.me.cardLibraries[0].profileIds.contains(widget._profile.id);
    if (_selectLibrary) {
      return Container(
        color: color2,
        padding: EdgeInsets.only(left: 15, right: 15, top: 15),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 30,
                alignment: Alignment.centerLeft,
                child: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    setState(() {
                      _selectLibrary = false;
                    });
                  },
                  color: color5,
                ),
              ),
              ListTile(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => CreateCategoryDialog(
                      (String name) async {
                        Library library = await AppConfig.addLibrary(name);
                        setState(() {
                          _libraryList.add(library);
                        });
                      },
                    ),
                  );
                },
                title: Text(
                  "Create Category",
                  style: myTs(color: color5, size: 16),
                ),
                trailing: SvgPicture.asset(
                  "assets/icons/add.svg",
                  height: 30,
                  width: 30,
                  fit: BoxFit.contain,
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: _libraryList.length,
                itemBuilder: (context, i) {
                  bool _inLibrary = AppConfig.me.cardLibraries[i].profileIds
                      .contains(widget._profile.id);
                  return ListTile(
                    onTap: _inLibrary
                        ? () {
                            setState(() {
                              AppConfig.me.cardLibraries[i]
                                  .removeProfile([widget._profile.id]);
                            });
                          }
                        : () {
                            setState(() {
                              AppConfig.me.cardLibraries[i]
                                  .addProfile(widget._profile.id);
                            });
                          },
                    title: Text(
                      _libraryList[i].name,
                      style:
                          myTs(color: _inLibrary ? color4 : color5, size: 16),
                    ),
                    trailing: _inLibrary
                        ? Icon(
                            Icons.check,
                            color: color4,
                          )
                        : null,
                  );
                },
              ),
            ],
          ),
        ),
      );
    } else {
      return Container(
        color: color2,
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              onTap: _inRecent
                  ? null
                  : () {
                      AppConfig.me.cardLibraries[0]
                          .addProfile(widget._profile.id);
                      Navigator.pop(context);
                    },
              title: Text(
                _inRecent ? "Saved" : "Save",
                style: myTs(color: _inRecent ? color4 : color5, size: 16),
              ),
              trailing: _inRecent
                  ? Icon(
                      Icons.check,
                      color: color4,
                    )
                  : null,
            ),
            ListTile(
              onTap: () {
                setState(() {
                  _selectLibrary = true;
                });
              },
              title: Text(
                "Save to Library",
                style: myTs(color: color5, size: 16),
              ),
              trailing: Icon(
                Icons.arrow_forward,
                color: color5,
              ),
            ),
            /* ListTile(
              onTap: _recommendProfile,
              title: Text(
                "Recommend",
                style: myTs(color: color5, size: 16),
              ),
            ),
            ListTile(
              onTap: _shareCardDialog,
              title: Text(
                "Share",
                style: myTs(color: color5, size: 16),
              ),
              trailing: Icon(
                Icons.share,
                color: color5,
              ),
            ), */
            widget.allowBlockAndReport
                ? ListTile(
                    onTap: widget.blockProfile,
                    title: Text(
                      "Block Profile",
                      style: myTs(color: color5, size: 16),
                    ),
                    trailing: Icon(
                      Icons.block,
                      color: color5,
                    ),
                  )
                : SizedBox(),
            widget.allowBlockAndReport
                ? ListTile(
                    onTap: _reportProfile,
                    title: Text(
                      "Report Profile",
                      style: myTs(color: color5, size: 16),
                    ),
                    trailing: Icon(
                      Icons.report,
                      color: color5,
                    ),
                  )
                : SizedBox(),
          ],
        ),
      );
    }
  }
}
