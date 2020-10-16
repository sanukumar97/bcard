import 'package:bcard/utilities/Classes/libraryClass.dart';
import 'package:bcard/utilities/Constants/randomConstants.dart';
import 'package:flutter/material.dart';

class LibraryFilterBottomSheet extends StatelessWidget {
  final LibraryType _currentLibraryType;
  final Function(LibraryType) _libraryTypeChoosen;
  LibraryFilterBottomSheet(this._currentLibraryType, this._libraryTypeChoosen);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      decoration: BoxDecoration(
        color: color2,
        borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              alignment: Alignment.topRight,
              margin: EdgeInsets.symmetric(vertical: 15, horizontal: 5),
              child: Icon(
                Icons.close,
                color: color5,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              _libraryTypeChoosen(LibraryType.other);
              Navigator.pop(context);
            },
            child: Container(
              alignment: Alignment.centerLeft,
              color: Colors.transparent,
              margin: EdgeInsets.symmetric(vertical: 10),
              child: Text(
                "My Customised Libraries",
                style: myTs(
                    color: _currentLibraryType == LibraryType.other
                        ? color4
                        : color5,
                    size: 18),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              _libraryTypeChoosen(LibraryType.recent);
              Navigator.pop(context);
            },
            child: Container(
              alignment: Alignment.centerLeft,
              color: Colors.transparent,
              margin: EdgeInsets.symmetric(vertical: 10),
              child: Text(
                "Recent",
                style: myTs(
                    color: _currentLibraryType == LibraryType.recent
                        ? color4
                        : color5,
                    size: 18),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              _libraryTypeChoosen(LibraryType.starred);
              Navigator.pop(context);
            },
            child: Container(
              alignment: Alignment.centerLeft,
              color: Colors.transparent,
              margin: EdgeInsets.symmetric(vertical: 10),
              child: Text(
                "Starred",
                style: myTs(
                    color: _currentLibraryType == LibraryType.starred
                        ? color4
                        : color5,
                    size: 18),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              _libraryTypeChoosen(LibraryType.scanned);
              Navigator.pop(context);
            },
            child: Container(
              alignment: Alignment.centerLeft,
              color: Colors.transparent,
              margin: EdgeInsets.symmetric(vertical: 10),
              child: Text(
                "Scanned",
                style: myTs(
                    color: _currentLibraryType == LibraryType.scanned
                        ? color4
                        : color5,
                    size: 18),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              _libraryTypeChoosen(LibraryType.blocked);
              Navigator.pop(context);
            },
            child: Container(
              alignment: Alignment.centerLeft,
              color: Colors.transparent,
              margin: EdgeInsets.symmetric(vertical: 10),
              child: Text(
                "Blocked",
                style: myTs(
                    color: _currentLibraryType == LibraryType.blocked
                        ? color4
                        : color5,
                    size: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
