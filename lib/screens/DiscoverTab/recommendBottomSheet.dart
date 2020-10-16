import 'package:bcard/screens/DiscoverTab/profileTile.dart';
import 'package:bcard/utilities/Classes/NotificationClasses/recommendNotificationClass.dart';
import 'package:bcard/utilities/Classes/profileClass.dart';
import 'package:bcard/utilities/firebaseFunctions.dart';
import 'package:bcard/utilities/Constants/randomConstants.dart';
import 'package:bcard/utilities/localStorage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shimmer/shimmer.dart';

class RecommendBottomSheet extends StatefulWidget {
  final Profile profile;
  final List<String> profileIds;
  RecommendBottomSheet(this.profile, this.profileIds);
  @override
  _RecommendBottomSheetState createState() => _RecommendBottomSheetState();
}

class _RecommendBottomSheetState extends State<RecommendBottomSheet> {
  TextEditingController _controller1 = new TextEditingController();

  List<Profile> _queryProfiles = [];
  List<Profile> _allProfiles = [];
  bool _loaded = false;

  void _sendRecommendation(Profile profile) async {
    RecommendNotification recommend = new RecommendNotification(
        AppConfig.currentProfile.id, profile.id, widget.profile.id);
    FirebaseFunctions.sendRecommendation(recommend);
    appToast("Recommendation Sent", context, color: color4);
    Navigator.pop(context);
  }

  void _getProfiles() async {
    List<String> _temp = [];
    for (int i = 0; i < widget.profileIds.length; i++) {
      _temp.add(widget.profileIds[i]);
      if (_temp.length == 10) {
        var list = await FirebaseFunctions.getProfiles(_temp);
        _allProfiles.addAll(list);
        setState(() {
          _queryProfiles.addAll(list);
        });
        _temp.clear();
      }
    }
    if (_temp.isNotEmpty) {
      var list = await FirebaseFunctions.getProfiles(_temp);
      _allProfiles.addAll(list);
      setState(() {
        _queryProfiles.addAll(list);
        _loaded = true;
      });
      _temp.clear();
    }
  }

  void _query(String query) {
    setState(() {
      _queryProfiles = _allProfiles.where((prf) {
        return (prf.name ?? "").toLowerCase().contains(query.toLowerCase()) ||
            (prf.occupation ?? "").toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  @override
  void initState() {
    super.initState();
    _getProfiles();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.only(left: 15, right: 15, top: 15),
      decoration: BoxDecoration(
        color: color2,
        borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: size.height * 0.5,
            child: _shareWidget(),
          ),
        ],
      ),
    );
  }

  Widget _shareWidget() {
    var size = MediaQuery.of(context).size;
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          margin: EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: color3,
          ),
          child: TextFormField(
            controller: _controller1,
            onChanged: (s) {
              _query(s);
            },
            style: myTs(color: color5),
            decoration: InputDecoration(
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              focusedErrorBorder: InputBorder.none,
              isDense: true,
              hintText: "Search Profiles",
              hintStyle: myTs(color: color5.withOpacity(0.3)),
            ),
          ),
        ),
        Container(
          height: size.height * 0.4,
          child: ListView.separated(
            shrinkWrap: true,
            physics: BouncingScrollPhysics(),
            addAutomaticKeepAlives: false,
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            primary: true,
            itemCount:
                _loaded ? _queryProfiles.length : widget.profileIds.length,
            separatorBuilder: (context, index) => SizedBox(height: 15),
            itemBuilder: (context, i) {
              if (_loaded && _queryProfiles.length > i) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      color: Colors.transparent,
                      child: DiscoverProfileTile(
                        _queryProfiles[i],
                        textColor: color5,
                      ),
                    ),
                    IconButton(
                      icon: SvgPicture.asset(
                        "assets/icons/recommend.svg",
                        fit: BoxFit.contain,
                      ),
                      onPressed: () {
                        _sendRecommendation(_queryProfiles[i]);
                      },
                      color: color5,
                    )
                  ],
                );
              } else
                return Shimmer.fromColors(
                  child: Container(
                    decoration: BoxDecoration(
                      color: color5,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    height: size.width * 0.25,
                    width: double.maxFinite,
                  ),
                  baseColor: color5.withOpacity(0.6),
                  highlightColor: color5.withOpacity(0.2),
                );
            },
          ),
        ),
      ],
    );
  }
}
