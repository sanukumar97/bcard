import 'dart:math';
import 'package:bcard/screens/TodoTab/reminderProfileTile.dart';
import 'package:bcard/utilities/Classes/profileClass.dart';
import 'package:bcard/utilities/Constants/randomConstants.dart';
import 'package:bcard/utilities/firebaseFunctions.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class SelectProfileDialog extends StatefulWidget {
  final List<String> profileIds;
  final Function(List<Profile> selectedProfileIds) profilesSelected;
  final List<Profile> selectedProfileIds;
  SelectProfileDialog(
      this.profileIds, this.profilesSelected, this.selectedProfileIds);
  @override
  _SelectProfileDialogState createState() => _SelectProfileDialogState();
}

class _SelectProfileDialogState extends State<SelectProfileDialog> {
  TextEditingController _controller = new TextEditingController();
  Set<String> _selectedProfileIds = new Set<String>();
  List<Profile> _allProfiles = [], _queryProfiles = [];
  bool _loaded = false;

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

  void _onTap(String id) {
    if (_selectedProfileIds.isNotEmpty) {
      setState(() {
        if (_selectedProfileIds.contains(id))
          _selectedProfileIds.remove(id);
        else
          _selectedProfileIds.add(id);
      });
    } else {
      _selectedProfileIds.add(id);
      _onDone();
    }
  }

  void _onLongPress(String id) {
    if (_selectedProfileIds.isEmpty) {
      setState(() {
        _selectedProfileIds.add(id);
      });
    }
  }

  void _onDone() {
    widget.profilesSelected(_selectedProfileIds
        .map<Profile>((id) => _allProfiles.firstWhere((prf) => prf.id == id))
        .toList());
    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();
    _selectedProfileIds
        .addAll(widget.selectedProfileIds.map<String>((prf) => prf.id));
    _getProfiles();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return AlertDialog(
      backgroundColor: color2,
      contentPadding: EdgeInsets.only(left: 15, right: 15, top: 15),
      actionsPadding: EdgeInsets.only(left: 15, right: 15, bottom: 15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(width: 0.4, color: color1),
              color: color3,
            ),
            child: TextFormField(
              controller: _controller,
              onChanged: (s) {
                _query(s);
              },
              decoration: InputDecoration(
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                focusedErrorBorder: InputBorder.none,
                isDense: true,
                hintText: "Search Profiles",
                hintStyle: myTs(color: color5.withOpacity(0.3), size: 15),
              ),
            ),
          ),
          Divider(
            thickness: 0.5,
            indent: 15,
            endIndent: 15,
            color: color1.withOpacity(0.4),
          ),
          Container(
            height: min(MediaQuery.of(context).size.height * 0.75,
                widget.profileIds.length * 75.0),
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
                  bool _selected =
                      _selectedProfileIds.contains(_queryProfiles[i].id);
                  return GestureDetector(
                    onTap: () => _onTap(_queryProfiles[i].id),
                    onLongPress: () => _onLongPress(_queryProfiles[i].id),
                    child: Stack(
                      children: <Widget>[
                            Container(
                              color: Colors.transparent,
                              width: double.maxFinite,
                              child: ReminderProfileTile(_queryProfiles[i]),
                            ),
                          ] +
                          (_selected
                              ? <Widget>[
                                  Container(
                                    height: size.width * 0.15,
                                    width: double.maxFinite,
                                    decoration: BoxDecoration(
                                      color: color4.withOpacity(0.4),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ]
                              : <Widget>[]),
                    ),
                  );
                } else
                  return Shimmer.fromColors(
                    child: Container(
                      decoration: BoxDecoration(
                        color: color5,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      height: size.width * 0.15,
                      width: double.maxFinite,
                    ),
                    baseColor: color5.withOpacity(0.6),
                    highlightColor: color5.withOpacity(0.2),
                  );
              },
            ),
          ),
        ],
      ),
      actions: [
        GestureDetector(
          onTap: _onDone,
          child: Container(
            alignment: Alignment.bottomRight,
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: color3,
            ),
            child: Text(
              "Done",
              style: myTs(color: color5, size: 16),
            ),
          ),
        )
      ],
    );
  }
}
