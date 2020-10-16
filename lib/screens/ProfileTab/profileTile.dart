import 'package:bcard/utilities/Classes/profileClass.dart';
import 'package:bcard/utilities/Constants/randomConstants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:bcard/utilities/Constants/logoBox.dart';

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
                        size: 12,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Text(
                  _profile.occupation ?? "Occupation",
                  overflow: TextOverflow.ellipsis,
                  style: myTs(color: textColor ?? color5, size: 11),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
