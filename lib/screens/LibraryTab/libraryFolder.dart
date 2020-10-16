import 'package:bcard/utilities/Classes/libraryClass.dart';
import 'package:bcard/utilities/Constants/encodersAndDecoders.dart';
import 'package:bcard/utilities/Constants/randomConstants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';


class LibraryFolder extends StatelessWidget {
  final Library library;
  final int index;
  final bool selected;
  LibraryFolder(this.library, this.index, this.selected);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    EdgeInsets margin1() {
      if (index % 2 == 0) {
        return EdgeInsets.only(
          left: (size.width * 0.17 - 15) / 2,
          right: (size.width * 0.17 - 15) / 2,
        );
      } else {
        return EdgeInsets.only(
          left: (size.width * 0.17 - 15) / 2,
          right: (size.width * 0.17 - 15) / 2,
        );
      }
    }

    EdgeInsets margin2() {
      if (index % 2 == 0) {
        return EdgeInsets.only(left: 15);
      } else {
        return EdgeInsets.only(right: 15);
      }
    }

    return Container(
      margin: margin2(),
      foregroundDecoration: BoxDecoration(
        color: selected ? color4.withOpacity(0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            alignment: Alignment.centerLeft,
            child: Text(
              library.name,
              style: myTs(color: color5, size: 16),
            ),
          ),
          Container(
            margin: margin1(),
            height: size.width * 0.33,
            width: size.width * 0.33,
            child: Stack(
              children: [
                SvgPicture.asset(
                  library.profileIds.isEmpty
                      ? "assets/icons/foldermty.svg"
                      : "assets/icons/folder.svg",
                  fit: BoxFit.contain,
                ),
                Positioned(
                  child: Container(
                    alignment: Alignment.bottomCenter,
                    padding: EdgeInsets.only(bottom: 10),
                    child: Text(
                      dateString(library.dateCreated),
                      style: myTs(color: color5, size: 12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
