import 'package:bcard/utilities/Classes/libraryClass.dart';
import 'package:bcard/utilities/Classes/profileClass.dart';
import 'package:bcard/utilities/Constants/logoBox.dart';
import 'package:bcard/utilities/Constants/randomConstants.dart';
import 'package:flutter/material.dart';

class AddProfileToLibraryBottomSheet extends StatefulWidget {
  final List<Profile> profiles;
  final Library library;
  final Function(Profile) profileAdded, profileRemoved;

  AddProfileToLibraryBottomSheet(
      this.profiles, this.library, this.profileAdded, this.profileRemoved);
  @override
  _AddProfileToLibraryBottomSheetState createState() =>
      _AddProfileToLibraryBottomSheetState();
}

class _AddProfileToLibraryBottomSheetState
    extends State<AddProfileToLibraryBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color2,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(8),
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Text(
              "Add Profiles",
              style: myTs(color: color5, size: 18),
            ),
          ),
          widget.profiles.isNotEmpty
              ? ListView.separated(
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  addAutomaticKeepAlives: false,
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  primary: true,
                  itemCount: widget.profiles.length,
                  separatorBuilder: (context, index) => SizedBox(height: 15),
                  itemBuilder: (context, i) {
                    bool _profilePresent = widget.library.profileIds
                        .contains(widget.profiles[i].id);
                    return Row(
                      children: [
                        Expanded(
                          child: ProfileTile(
                            widget.profiles[i],
                            /* logoHeight: size.width * 0.15,
                              logoWidth: size.width * 0.15, */
                          ),
                        ),
                        RaisedButton(
                          child: Text(_profilePresent ? "Remove" : "Add"),
                          onPressed: () {
                            setState(() {
                              if (_profilePresent) {
                                widget.library
                                    .removeProfile([widget.profiles[i].id]);
                                widget.profileRemoved(widget.profiles[i]);
                              } else {
                                widget.library
                                    .addProfile(widget.profiles[i].id);
                                widget.profileAdded(widget.profiles[i]);
                              }
                            });
                          },
                          color: _profilePresent
                              ? color5.withOpacity(0.3)
                              : color4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ],
                    );
                  },
                )
              : Container(
                  alignment: Alignment.center,
                  height: double.maxFinite,
                  child: Text(
                    "No Profiles present in Recent Tab",
                    textAlign: TextAlign.center,
                  ),
                ),
        ],
      ),
    );
  }
}

class ProfileTile extends StatelessWidget {
  final Profile _profile;
  final Color textColor;
  ProfileTile(this._profile, {this.textColor});
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
      child: Row(
        children: [
          Container(
            margin: EdgeInsets.only(right: 15),
            child: Container(
              decoration: BoxDecoration(
                color: color5.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: logoBox(false, _profile.logoUrl, _profile.profileType,
                  size.width * 0.15, size.width * 0.15),
            ),
          ),
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  child: Text(
                    _profile.name ?? _profile.companyName ?? "Name",
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                    style: myTs(
                        color: textColor ?? color5,
                        size: 18,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Text(
                  _profile.occupation ?? "Occupation",
                  overflow: TextOverflow.ellipsis,
                  style: myTs(color: textColor ?? color5, size: 16),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
