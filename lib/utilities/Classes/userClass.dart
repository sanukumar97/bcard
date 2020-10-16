import 'package:bcard/utilities/Classes/libraryClass.dart';
import 'package:bcard/utilities/Classes/profileClass.dart';

class User {
  String userId, number, name, email;
  String businessDocId, personalDocId;
  Profile businessProfile;
  Profile personalProfile;
  List<Library> cardLibraries;
  List<String> requestedProfiles, acceptedProfiles, profilesVisited;
  User(this.email, this.name, this.number, this.userId) {
    this.cardLibraries = [
      new Library("Recent", [], [], LibraryType.recent),
      new Library("Starred", [], [], LibraryType.starred),
      new Library("Scanned", [], [], LibraryType.scanned),
      new Library("Blocked", [], [], LibraryType.blocked),
    ];
    this.requestedProfiles = [];
    this.acceptedProfiles = [];
    this.profilesVisited = [];
  }

  User.fromJson(Map<String, dynamic> data) {
    this.email = data['email'];
    this.name = data['name'];
    this.number = data['number'];
    this.userId = data['userId'];
    this.businessDocId = data["businessDocId"];
    this.personalDocId = data["personalDocId"];
    this.cardLibraries = List<Library>.generate(
      data["cardLibraries"].length,
      (i) => Library.fromJson(data["cardLibraries"][i]),
    );
    this.requestedProfiles = data["requestedProfiles"] != null
        ? List<String>.generate(
            data["requestedProfiles"].length,
            (i) => data["requestedProfiles"][i],
          )
        : [];
    this.acceptedProfiles = data["acceptedProfiles"] != null
        ? List<String>.generate(
            data["acceptedProfiles"].length,
            (i) => data["acceptedProfiles"][i],
          )
        : [];
    this.profilesVisited = data["profilesVisited"] != null
        ? List<String>.generate(
            data["profilesVisited"].length,
            (i) => data["profilesVisited"][i],
          )
        : [];
  }

  Map<String, dynamic> toJson() => {
        "email": this.email,
        "name": this.name,
        "number": this.number,
        "userId": this.userId,
        "businessDocId": this.businessDocId,
        "personalDocId": this.personalDocId,
        "cardLibraries": List<Map<String, dynamic>>.generate(
            this.cardLibraries.length, (i) => this.cardLibraries[i].toJson()),
        "acceptedProfiles": this.acceptedProfiles,
        "requestedProfiles": this.requestedProfiles,
        "profilesVisited": this.profilesVisited,
      };

  @override
  String toString() {
    return "${this.userId},${this.number},${this.name},${this.email},${this.businessDocId},${this.personalDocId}";
  }
}

enum SignInMethod { number, google }

enum SignInError { passwordIncorrect, noUserExist, unKnown }
