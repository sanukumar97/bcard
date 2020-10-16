import 'package:bcard/utilities/Classes/profileClass.dart';
import 'package:bcard/utilities/Constants/logoBox.dart';
import 'package:bcard/utilities/Constants/randomConstants.dart';
import 'package:flutter/material.dart';

class LibraryProfile extends StatelessWidget {
  final Profile _profile;
  final double logoHeight, logoWidth;
  LibraryProfile(this._profile, {this.logoHeight, this.logoWidth});
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: Row(
        children: [
          Container(
            margin: EdgeInsets.only(right: 15),
            child: Container(
              decoration: BoxDecoration(
                color: color5.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: logoBox(
                  false,
                  _profile.logoUrl,
                  _profile.profileType,
                  logoHeight ?? size.width * 0.23,
                  logoWidth ?? size.width * 0.23),
            ),
          ),
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  _profile.companyName ?? "Company Name",
                  style: myTs(color: color5, size: 18),
                ),
                Text(
                  _profile.occupation ?? "Occupation",
                  style: myTs(color: color5, size: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
