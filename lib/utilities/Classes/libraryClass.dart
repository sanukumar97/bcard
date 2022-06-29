import 'package:bcard/utilities/localStorage.dart';

class Library {
  List<String> _profileIds;
  List<DateTime> _additionTime;
  LibraryType libraryType;
  String name;
  DateTime dateCreated;

  List<String> get profileIds => _profileIds;

  Library(this.name, this._profileIds, this._additionTime, this.libraryType) {
    dateCreated = DateTime.now();
  }

  Library.fromJson(Map<dynamic, dynamic> data) {
    this.name = data["name"];
    this._profileIds = List<String>.generate(
        data["profileIds"].length, (i) => data["profileIds"][i]);
    this.dateCreated = data["dateCreated"] != null
        ? DateTime.parse(data["dateCreated"])
        : DateTime.now();
    this._additionTime = List<DateTime>.generate(data["additionTime"].length,
        (i) => DateTime.parse(data["additionTime"][i].toString()));
    this.libraryType =
        LibraryType.values[int.parse(data["libraryType"].toString())];
  }

  Map<String, dynamic> toJson() => {
        "name": this.name,
        "libraryType": this.libraryType.index,
        "dateCreated": this.dateCreated.toIso8601String(),
        "profileIds": this._profileIds,
        "additionTime": List<String>.generate(this._additionTime.length,
            (i) => this._additionTime[i].toIso8601String()),
      };

  void addProfile(String profileId) {
    if (profileId != null) {
      int i = _profileIds.indexWhere((e) => e == profileId);
      if (i >= 0) {
        this._additionTime[i] = DateTime.now();
        AppConfig.libraryUpdated();
      } else {
        this._profileIds.add(profileId);
        this._additionTime.add(DateTime.now());
        AppConfig.libraryUpdated();
      }
    }
  }

  void removeProfile(List<String> profileIds) {
    bool changeHappened = false;
    profileIds.forEach((id) {
      int index = _profileIds.indexWhere((profileId) => id == profileId);
      if (index >= 0) {
        _profileIds.removeAt(index);
        _additionTime.removeAt(index);
        changeHappened = true;
      }
    });
    if (changeHappened) {
      AppConfig.libraryUpdated();
    }
  }

  List<DateTime> get additionTime => _additionTime;
}

enum LibraryType { recent, starred, scanned, blocked, other }
