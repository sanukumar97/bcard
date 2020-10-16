import 'dart:convert';
import 'package:bcard/utilities/Classes/libraryClass.dart';
import 'package:bcard/utilities/Classes/profileClass.dart';
import 'package:bcard/utilities/Classes/userClass.dart';
import 'package:bcard/utilities/connectivity.dart';
import 'package:bcard/utilities/Constants/randomConstants.dart';
import 'package:bcard/utilities/firebaseFunctions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class AppConfig {
  static SharedPreferences _preferences;
  static User me;
  static bool firstSyncDone = false;
  static List<String> imageList;
  static List<String> discoverTagList = [], liveTagList = [];
  static String _myLiveTag;
  static bool _amILive;
  static List<String> notificationsRead = [];
  static List<String> messagesRead = [];
  static int _currentSelectedProfile;
  static List<String> horizantalCardDesigns = [], verticalCardDesigns = [];
  static String defaultHorizantalCardDesign, defaultVerticalCardDesign;

  static Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
    if (isLoggedIn) {
      me = _getCurrentUser();
      _currentSelectedProfile =
          _preferences.getInt("currentSelectedProfile") ?? 0;
      imageList =
          _preferences.getStringList("imageList") ?? List.filled(6, null);
      discoverTagList = _preferences.getStringList("discoverTagList") ?? [];
      liveTagList = _preferences.getStringList("liveTagList") ?? [];
      _myLiveTag = _preferences.getString("myLiveTag");
      _amILive = _preferences.getBool("amILive");
      notificationsRead = _preferences.getStringList("notificationsRead") ?? [];
      messagesRead = _preferences.getStringList("messagesRead") ?? [];
      if (AppConnectivity.isConnected) {
        await AppConfig.getCardDesigns();
        AppConfig.synchroniseChangesToServer();
        AppConfig.synchroniseChangesFromServer();
      }
    }
  }

  static Future<void> getCardDesigns() async {
    List<DocumentSnapshot> docs = await FirebaseFunctions.getCardDesigns();
    docs.forEach((doc) {
      if (doc.data["type"].toString() == "default") {
        AppConfig.defaultHorizantalCardDesign =
            doc.data["horizantalCardDesign"];
        AppConfig.defaultVerticalCardDesign = doc.data["verticalCardDesign"];
      } else if (doc.data["type"].toString() == "customised") {
        AppConfig.horizantalCardDesigns =
            doc.data["horizantalCardDesigns"] != null
                ? new List<String>.generate(
                    doc.data["horizantalCardDesigns"].length,
                    (i) => doc.data["horizantalCardDesigns"][i])
                : [];
        AppConfig.verticalCardDesigns = doc.data["verticalCardDesigns"] != null
            ? new List<String>.generate(doc.data["verticalCardDesigns"].length,
                (i) => doc.data["verticalCardDesigns"][i])
            : [];
      }
    });
  }

  static bool get firstInstallDone {
    return _preferences.getBool("firstInstallDone") ?? false;
  }

  static set firstInstallDone(bool value) {
    _preferences.setBool("firstInstallDone", value);
  }

  static set currentSelectedProfile(int index) {
    _currentSelectedProfile = index;
    reloadChatPage();
    _preferences.setInt("currentSelectedProfile", index);
  }

  static get currentSelectedProfile => _currentSelectedProfile;

  static Profile get currentProfile {
    return _currentSelectedProfile == 0
        ? me.businessProfile
        : me.personalProfile;
  }

  static Future<void> synchroniseChangesFromServer() async {
    DocumentReference ref =
        Firestore.instance.collection("users").document(AppConfig.me.userId);
    DocumentSnapshot doc = await ref.get();
    AppConfig.me.requestedProfiles = doc.data["requestedProfiles"] != null
        ? List<String>.generate(
            doc.data["requestedProfiles"].length,
            (i) => doc.data["requestedProfiles"][i],
          )
        : [];
    AppConfig.me.acceptedProfiles = doc.data["acceptedProfiles"] != null
        ? List<String>.generate(
            doc.data["acceptedProfiles"].length,
            (i) => doc.data["acceptedProfiles"][i],
          )
        : [];
    AppConfig.saveUserChanges();
  }

  static void synchroniseChangesToServer() async {
    if (AppConfig.isLoggedIn) {
      DocumentSnapshot businessDoc =
          await FirebaseFunctions.getUserBusinessProfileDoc(
              AppConfig.me.businessDocId);
      DocumentSnapshot personalDoc =
          await FirebaseFunctions.getUserBusinessProfileDoc(
              AppConfig.me.personalDocId);
      Map<String, dynamic> businessData, personalData;
      if (businessDoc != null && businessDoc.exists) {
        AppConfig.me.businessProfile.ref = businessDoc.reference;
        businessData = AppConfig.me.businessProfile
            .tobeUpdatedData(Profile.fromJson(businessDoc.data));
        print("Update Personal Data: $businessData");
        if (businessData.isNotEmpty) {
          businessDoc.reference.updateData(businessData);
        }
      }
      if (personalDoc != null && personalDoc.exists) {
        AppConfig.me.personalProfile.ref = personalDoc.reference;
        personalData = AppConfig.me.personalProfile
            .tobeUpdatedData(Profile.fromJson(personalDoc.data));
        print("Update Personal Data: $personalData");
        if (personalData.isNotEmpty) {
          personalDoc.reference.updateData(personalData);
        }
      }
    }
    AppConfig.firstSyncDone = true;
  }

  static Future<Library> addLibrary(String name) async {
    Library library = new Library(name, [], [], LibraryType.other);
    AppConfig.me.cardLibraries.add(library);
    saveUserChanges();
    FirebaseFunctions.updateUserData(AppConfig.me.userId, {
      "cardLibraries": List<Map<String, dynamic>>.generate(
          AppConfig.me.cardLibraries.length,
          (i) => AppConfig.me.cardLibraries[i].toJson())
    });
    return library;
  }

  static Future<void> libraryUpdated() async {
    AppConfig.saveUserChanges();
    await FirebaseFunctions.updateUserData(AppConfig.me.userId, {
      "cardLibraries": List<Map<String, dynamic>>.generate(
          AppConfig.me.cardLibraries.length,
          (i) => AppConfig.me.cardLibraries[i].toJson())
    });
  }

  static Future<void> deleteLibraries(List<String> names) async {
    AppConfig.me.cardLibraries.removeWhere((lib) => names.contains(lib.name));
    libraryUpdated();
  }

  static Future<void> deleteProfilesFromLibrary(
      List<String> profileIds, Library library) async {
    int index = AppConfig.me.cardLibraries
        .indexWhere((lib) => lib.name == library.name);
    if (index >= 0) {
      AppConfig.me.cardLibraries[index].removeProfile(profileIds);
      libraryUpdated();
    }
  }

  static Future<void> addRequestedProfile(String id) async {
    AppConfig.me.requestedProfiles.add(id);
    saveUserChanges();
    await FirebaseFunctions.updateUserData(AppConfig.me.userId, {
      "requestedProfiles": AppConfig.me.requestedProfiles,
    });
  }

  static Future<void> addVisitedProfile(String profileId) async {
    AppConfig.me.profilesVisited.add(profileId);
    saveUserChanges();
    await FirebaseFunctions.updateUserData(AppConfig.me.userId, {
      "profilesVisited": AppConfig.me.profilesVisited,
    });
  }

  static set myLiveTag(String s) {
    _myLiveTag = s;
    _preferences.setString("myLiveTag", _myLiveTag);
  }

  static get myLiveTag => _myLiveTag;

  static set amILive(bool val) {
    _amILive = val;
    _preferences.setBool("amILive", _amILive);
  }

  static get amILive => _amILive ?? false;

  static Future<void> blockProfile(String profileId) async {
    List<String> blockedProfileIds = AppConfig.me.cardLibraries[3].profileIds;
    AppConfig.me.acceptedProfiles.remove(profileId);
    if (!blockedProfileIds.contains(profileId)) {
      AppConfig.me.cardLibraries[3].addProfile(profileId);
    }
  }

  static Future<void> unblockProfile(String profileId) async {
    AppConfig.me.cardLibraries[3].removeProfile([profileId]);
  }

  static Future<void> addNotificationRead(String id) async {
    if (!AppConfig.notificationsRead.contains(id)) {
      AppConfig.notificationsRead.add(id);
      await _preferences.setStringList(
          "notificationsRead", AppConfig.notificationsRead);
    }
  }

  static Future<void> addMessageRead(List<String> newMessageIds) async {
    AppConfig.messagesRead.addAll(newMessageIds);
    await _preferences.setStringList("messagesRead", AppConfig.messagesRead);
  }

  static void saveDiscoverTagList(List<String> list) async {
    AppConfig.discoverTagList = list;
    await _preferences.setStringList("discoverTagList", list);
  }

  static void saveLiveTagList(List<String> list) async {
    AppConfig.liveTagList = list;
    await _preferences.setStringList("liveTagList", list);
  }

  static List<int> getImageBytes(int index, ProfileType profileType) {
    if (profileType == ProfileType.business) {
      return imageList[index] != null ? base64.decode(imageList[index]) : null;
    } else {
      return imageList[3 + index] != null
          ? base64.decode(imageList[3 + index])
          : null;
    }
  }

  static bool imageAvailable(int index, ProfileType profileType) {
    if (profileType == ProfileType.business) {
      return imageList[index] != null;
    } else {
      return imageList[3 + index] != null;
    }
  }

  static bool get isLoggedIn {
    if (_preferences != null) {
      return _preferences.getString("user") != null;
    }
    return false;
  }

  static Future<void> registerUserLocally(User user) async {
    String userString = jsonEncode(user.toJson()),
        _busProfString = jsonEncode(user.businessProfile.toJson()),
        _persProfString = jsonEncode(user.personalProfile.toJson());
    await _preferences.setString("user", userString);
    await _preferences.setString("businessProfile", _busProfString);
    await _preferences.setString("personalProfile", _persProfString);
    imageList = List.filled(6, null);
    imageList[0] =
        await AppConfig.saveImageLocally(user.businessProfile.coverUrl);
    imageList[1] = await AppConfig.saveImageLocally(
        user.businessProfile.backgroundImageUrl);
    imageList[2] =
        await AppConfig.saveImageLocally(user.businessProfile.logoUrl);
    imageList[3] =
        await AppConfig.saveImageLocally(user.personalProfile.coverUrl);
    imageList[4] = await AppConfig.saveImageLocally(
        user.personalProfile.backgroundImageUrl);
    imageList[5] =
        await AppConfig.saveImageLocally(user.personalProfile.logoUrl);
    await _preferences.setStringList("imageList", imageList);
  }

  static User _getCurrentUser() {
    User user = new User.fromJson(jsonDecode(_preferences.getString("user")));
    user.businessProfile =
        Profile.fromJson(jsonDecode(_preferences.getString("businessProfile")));
    user.personalProfile =
        Profile.fromJson(jsonDecode(_preferences.getString("personalProfile")));
    return user;
  }

  static void saveUserChanges() async {
    String userString = jsonEncode(AppConfig.me.toJson());
    await _preferences.setString("user", userString);
  }

  static void saveChanges() async {
    if (!listEqual(imageList, _preferences.getStringList("imageList"))) {
      await _preferences.setStringList("imageList", imageList);
    }
    if (AppConfig.me.businessProfile.updated) {
      String _busProfString = jsonEncode(AppConfig.me.businessProfile.toJson());
      await _preferences.setString("businessProfile", _busProfString);
    }
    if (AppConfig.me.personalProfile.updated) {
      String _persProfString =
          jsonEncode(AppConfig.me.personalProfile.toJson());
      await _preferences.setString("personalProfile", _persProfString);
    }

    if (AppConnectivity.isConnected &&
        (AppConfig.me.businessProfile.updated ||
            AppConfig.me.personalProfile.updated)) {
      AppConfig.synchroniseChangesToServer();
      AppConfig.me.businessProfile.updated = false;
      AppConfig.me.personalProfile.updated = false;
    }
  }

  static Future<void> logOut() async {
    await _preferences.clear();
    await _preferences.setBool("firstInstallDone", true);
    await _preferences.reload();
  }

  static Future<String> saveImageLocally(String url) async {
    if (url != null && url.isNotEmpty) {
      var response = await http.get(url);
      String imageString = base64.encode(response.bodyBytes);
      return imageString;
    } else
      return null;
  }

  static Future<void> saveUrls(
      String url, int index, ProfileType profileType) async {
    if (profileType == ProfileType.business) {
      imageList[index] = await saveImageLocally(url);
    } else {
      imageList[3 + index] = await saveImageLocally(url);
    }
  }

  /* static Future<User> _getCurrentUser() async {
    User user = await FirebaseFunctions.getCurrentUser(
      _preferences.getString("number") != null
          ? SignInMethod.number
          : SignInMethod.google,
      email: _preferences.getString("email"),
      number: _preferences.getString("number"),
    );
    if (user != null) {
      user.businessProfile =
          await FirebaseFunctions.getUserBusinessProfile(user.businessDocId);
      user.personalProfile =
          await FirebaseFunctions.getUserPersonalProfile(user.personalDocId);
    }
    return user;
  } */
}
