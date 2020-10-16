import 'dart:io';
import 'package:bcard/utilities/Classes/MessageClasses/messageClass.dart';
import 'package:bcard/utilities/Classes/NotificationClasses/profileRequestNotificationClass.dart';
import 'package:bcard/utilities/Classes/NotificationClasses/profileVisitedNotificationClass.dart';
import 'package:bcard/utilities/Classes/NotificationClasses/recommendNotificationClass.dart';
import 'package:bcard/utilities/Classes/NotificationClasses/reminderNotificationClass.dart';
import 'package:bcard/utilities/Classes/liveEventClass.dart';
import 'package:bcard/utilities/Classes/profileClass.dart';
import 'package:bcard/utilities/Classes/reminderClass.dart';
import 'package:bcard/utilities/Classes/reportClass.dart';
import 'package:bcard/utilities/Classes/userClass.dart';
import 'package:bcard/utilities/localStorage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseFunctions {
  static FirebaseAuth _firebaseAuth;
  static Firestore _firestore;
  static FirebaseStorage _firebaseStorage;

  static void init() {
    _firebaseAuth = FirebaseAuth.instance;
    _firestore = Firestore.instance;
    _firebaseStorage = FirebaseStorage.instance;
  }

  static Future<String> uploadImage(File image, String name) async {
    var data = await image.readAsBytes();
    StorageUploadTask task = _firebaseStorage.ref().child(name).putData(data);
    StorageTaskSnapshot snapshot = await task.onComplete;
    return (await snapshot.ref.getDownloadURL()).toString();
  }

  static Future<bool> deleteImage(String url) async {
    StorageReference ref = await _firebaseStorage.getReferenceFromUrl(url);
    await ref.delete().catchError((e) {
      print("Error in deleting image: $e");
    });
    return true;
  }

  static Future<User> getCurrentUser(SignInMethod signInMethod,
      {String number, String email}) async {
    if (signInMethod == SignInMethod.number) {
      QuerySnapshot qs = await _firestore
          .collection("users")
          .where("number", isEqualTo: number)
          .getDocuments();
      if (qs.documents.isNotEmpty) {
        for (var doc in qs.documents) {
          if (doc.data["number"] == number) {
            return User.fromJson(doc.data);
          }
        }
      }
    } else if (signInMethod == SignInMethod.google) {
      QuerySnapshot qs = await _firestore
          .collection("users")
          .where("email", isEqualTo: email)
          .getDocuments();
      if (qs.documents.isNotEmpty) {
        for (var doc in qs.documents) {
          if (doc.data["email"] == email) {
            return User.fromJson(doc.data);
          }
        }
      }
    }
    return null;
  }

  static Future<DocumentSnapshot> getUserBusinessProfileDoc(
      String documentId) async {
    DocumentSnapshot ds =
        await _firestore.collection("profiles").document(documentId).get();
    return ds;
  }

  static Future<DocumentSnapshot> getUserPersonalProfileDoc(
      String documentId) async {
    DocumentSnapshot ds =
        await _firestore.collection("profiles").document(documentId).get();
    return ds;
  }

  static void sendOtp(
      String number,
      Function(AuthCredential cred) verficationCompleted,
      Function(AuthException exp) verificationFailed,
      Function(String s, [int k]) codeSent,
      Function(String s) codeTimeout) {
    _firebaseAuth.verifyPhoneNumber(
        phoneNumber: "+91" + number,
        timeout: Duration(seconds: 30),
        verificationCompleted: (AuthCredential cred) async {
          await _firebaseAuth.signInWithCredential(cred);
          verficationCompleted(cred);
        },
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeTimeout);
  }

  static Future<bool> checkNumberExists(String number) async {
    QuerySnapshot qs = await _firestore
        .collection("users")
        .where("number", isEqualTo: number)
        .getDocuments();
    if (qs.documents.isNotEmpty) {
      for (var doc in qs.documents) {
        if (doc.data["number"].toString() == number) return true;
      }
    }
    return false;
  }

  static Future<bool> checkEmailExists(String email) async {
    QuerySnapshot qs = await _firestore
        .collection("users")
        .where("email", isEqualTo: email)
        .getDocuments();
    if (qs.documents.isNotEmpty) {
      for (var doc in qs.documents) {
        if (doc.data["email"].toString() == email) return true;
      }
    }
    return false;
  }

  static Future<FirebaseUser> googleSignIn() async {
    await GoogleSignIn().signOut();
    final GoogleSignInAccount googleSignInAccount =
        await GoogleSignIn().signIn();

    if (googleSignInAccount == null) {
      return null;
    }

    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount?.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final AuthResult authResult =
        await _firebaseAuth.signInWithCredential(credential);

    final FirebaseUser user = authResult.user;
    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    final FirebaseUser currentUser = await _firebaseAuth.currentUser();
    assert(user.uid == currentUser.uid);
    print("Signed in with Google");

    return user;
  }

  static Future<void> registerUser(User user, String password) async {
    DocumentReference _ref = _firestore.collection("users").document();
    user.userId = _ref.documentID;
    DocumentReference businessRef =
        _firestore.collection("profiles").document();
    DocumentReference personalRef =
        _firestore.collection("profiles").document();
    Profile businessProfile = new Profile(user.name, CardStructure.horizantal,
        ProfileType.business, businessRef.documentID);
    Profile personalProfile = new Profile(user.name, CardStructure.vertical,
        ProfileType.personal, personalRef.documentID);
    user.businessProfile = businessProfile;
    user.personalProfile = personalProfile;

    user.businessDocId = businessRef.documentID;
    user.personalDocId = personalRef.documentID;
    AppConfig.me = user;

    var data = user.toJson();
    data.addAll({"password": password});
    await _ref.setData(data);

    data = businessProfile.toJson();
    await businessRef.setData(data);

    data = personalProfile.toJson();
    await personalRef.setData(data);

    await AppConfig.registerUserLocally(user);
  }

  static Future<SignInError> loginUser(
      SignInMethod signInMethod, String password,
      {String email, String number}) async {
    if (signInMethod == SignInMethod.number) {
      if (number == null) return SignInError.unKnown;
      QuerySnapshot qs = await _firestore
          .collection("users")
          .where("number", isEqualTo: number)
          .getDocuments();
      if (qs.documents.isNotEmpty) {
        for (var doc in qs.documents) {
          if (doc.data["number"] == number) {
            if (doc.data["password"] == password) {
              User user = User.fromJson(doc.data);
              DocumentSnapshot businessDoc = await _firestore
                      .collection("profiles")
                      .document(user.businessDocId)
                      .get(),
                  personalDoc = await _firestore
                      .collection("profiles")
                      .document(user.personalDocId)
                      .get();
              user.businessProfile = Profile.fromJson(businessDoc.data);
              user.personalProfile = Profile.fromJson(personalDoc.data);
              await AppConfig.registerUserLocally(user);
              AppConfig.me = user;
              return null;
            } else
              return SignInError.passwordIncorrect;
          }
        }
      }
      return SignInError.noUserExist;
    } else if (signInMethod == SignInMethod.google) {
      if (email == null) return SignInError.unKnown;
      QuerySnapshot qs = await _firestore
          .collection("users")
          .where("email", isEqualTo: email)
          .getDocuments();
      if (qs.documents.isNotEmpty) {
        for (var doc in qs.documents) {
          if (doc.data["email"] == email) {
            if (doc.data["password"] == password) {
              User user = User.fromJson(doc.data);
              DocumentSnapshot businessDoc = await _firestore
                      .collection("profiles")
                      .document(user.businessDocId)
                      .get(),
                  personalDoc = await _firestore
                      .collection("profiles")
                      .document(user.personalDocId)
                      .get();
              user.businessProfile = Profile.fromJson(businessDoc.data);
              user.personalProfile = Profile.fromJson(personalDoc.data);
              await AppConfig.registerUserLocally(user);
              AppConfig.me = user;
              return null;
            } else
              return SignInError.passwordIncorrect;
          }
        }
      }
      return SignInError.noUserExist;
    } else {
      return SignInError.unKnown;
    }
  }

  static Future<void> updateUserData(
      String userId, Map<String, dynamic> data) async {
    DocumentReference ref = _firestore.collection("users").document(userId);
    await ref.updateData(data).catchError((e) {
      print("User Doc not found: $e");
    });
  }

  static Future<void> logOut() async {
    await _firebaseAuth.signOut();
    await GoogleSignIn().signOut();
  }

  static Future<List<DocumentSnapshot>> discoverProfiles(
      List<String> searchTags, int i) async {
    QuerySnapshot qs;
    Query q = _firestore.collection("profiles");
    switch (i) {
      case 0:
        q = q.where("tags", arrayContainsAny: searchTags);
        break;
      case 1:
        q = q.where("userName", whereIn: searchTags);
        break;
      case 2:
        q = q.where("companyName", whereIn: searchTags);
        break;
      case 3:
        q = q.where("occupation", whereIn: searchTags);
        break;
    }
    qs = await q.getDocuments(source: Source.server);
    return qs?.documents ?? [];
  }

  static Future<List<Profile>> getProfiles(List<String> profileIds) async {
    if (profileIds.length > 10) profileIds = profileIds.sublist(0, 10);
    QuerySnapshot qs = await _firestore
        .collection("profiles")
        .where("id", whereIn: profileIds)
        .getDocuments();
    return qs.documents
        .map<Profile>((doc) => Profile.fromJson(doc.data))
        .toList();
  }

  static Future<bool> requestProfile(Profile profile) async {
    if (!AppConfig.me.requestedProfiles.contains(profile.id) &&
        !AppConfig.me.acceptedProfiles.contains(profile.id)) {
      ProfileRequestNotification request = new ProfileRequestNotification(
          AppConfig.currentProfile.id,
          profile.id,
          AppConfig.me.userId,
          RequestStatus.requested);
      DocumentReference ref = _firestore.collection("notifications").document();
      request.id = ref.documentID;
      await ref.setData(request.toJson());
      await AppConfig.addRequestedProfile(profile.id);
      return true;
    } else
      return false;
  }

  static Future<bool> deRequestProfile(Profile profile) async {
    if (AppConfig.me.requestedProfiles.contains(profile.id) &&
        !AppConfig.me.acceptedProfiles.contains(profile.id)) {
      AppConfig.me.requestedProfiles.remove(profile.id);
      await FirebaseFunctions.updateUserData(AppConfig.me.userId, {
        "requestedProfiles": AppConfig.me.requestedProfiles,
      });
      QuerySnapshot qs = await _firestore
          .collection("notifications")
          .where("notificationType", isEqualTo: 0)
          .where("senderProfileId",
              whereIn: [AppConfig.me.businessDocId, AppConfig.me.personalDocId])
          .where("status", isEqualTo: 2)
          .limit(1)
          .getDocuments();
      if (qs.documents.isNotEmpty) {
        qs.documents.first.reference.delete();
        return false;
      } else
        return true;
    } else
      return true;
  }

  static Future<void> visitProfile(String profileId) async {
    //if (!AppConfig.me.profilesVisited.contains(profileId)) {
    // AppConfig.addVisitedProfile(profileId);
    ProfileVisitedNotification profileVisited =
        new ProfileVisitedNotification(AppConfig.currentProfile.id, profileId);
    DocumentReference ref = _firestore.collection("notifications").document();
    profileVisited.id = ref.documentID;
    await ref.setData(profileVisited.toJson());
    //}
  }

  static Stream<QuerySnapshot> get notificationStream {
    return _firestore
        .collection("notifications")
        .orderBy("date", descending: true)
        .snapshots();
  }

  static Stream<QuerySnapshot> get reminderStream {
    return _firestore.collection("reminders").snapshots();
  }

  static Stream<QuerySnapshot> get chatStream {
    return _firestore
        .collection("messages")
        .orderBy("date", descending: true)
        .snapshots();
  }

  static Future<bool> acceptRequest(ProfileRequestNotification request) async {
    bool error = false;
    await request.ref.updateData({
      "status": RequestStatus.accepted.index,
    }).catchError((e) {
      print(e);
      error = true;
    });
    if (!error) {
      DocumentReference ref =
          _firestore.collection("users").document(request.senderUserId);
      DocumentSnapshot doc = await ref.get();
      List<String> _acceptedProfiles = doc.data["acceptedProfiles"] != null
          ? List<String>.generate(
              doc.data["acceptedProfiles"].length,
              (i) => doc.data["acceptedProfiles"][i],
            )
          : [];
      List<String> _requestedProfiles = doc.data["requestedProfiles"] != null
          ? List<String>.generate(
              doc.data["requestedProfiles"].length,
              (i) => doc.data["requestedProfiles"][i],
            )
          : [];
      _requestedProfiles.remove(request.recieverProfileId);
      if (!_acceptedProfiles.contains(request.recieverProfileId)) {
        _acceptedProfiles.add(request.recieverProfileId);
        await ref.updateData({
          "acceptedProfiles": _acceptedProfiles,
          "requestedProfiles": _requestedProfiles
        }).catchError((e) {
          print("User Doc not found: $e");
        });
      }
    }
    return error;
  }

  static Future<bool> rejectRequest(ProfileRequestNotification request) async {
    bool error = false;
    await request.ref.updateData({
      "status": RequestStatus.rejected.index,
    }).catchError((e) {
      print(e);
      error = true;
    });
    return error;
  }

  static Future<List<String>> addReminders(List<Reminder> reminders) async {
    List<String> remIds = [];
    for (int i = 0; i < reminders.length; i++) {
      DocumentReference reminderRef =
          _firestore.collection("reminders").document();
      reminders[i].id = reminderRef.documentID;
      remIds.add(reminders[i].id);
      reminderRef.setData(reminders[i].toJson());
      if (reminders[i].pinnedProfile != null) {
        DocumentReference notifRef =
            _firestore.collection("notifications").document();
        ReminderNotification reminderNotification = new ReminderNotification(
            AppConfig.currentProfile.id,
            reminders[i].pinnedProfile,
            reminders[i].id);
        reminderNotification.id = notifRef.documentID;
        notifRef.setData(reminderNotification.toJson());
      }
    }
    return remIds;
  }

  static Future<void> sendRecommendation(
      RecommendNotification recommend) async {
    DocumentReference ref = _firestore.collection("notifications").document();
    recommend.id = ref.documentID;
    await ref.setData(recommend.toJson());
  }

  static Future<Profile> getProfile(String profileId) async {
    DocumentSnapshot doc =
        await _firestore.collection("profiles").document(profileId).get();
    if (doc.exists) {
      Profile _profile = new Profile.fromJson(doc.data);
      return _profile;
    } else
      return null;
  }

  static Future<String> getUserName(String userId) async {
    DocumentSnapshot ds = await _firestore
        .collection("users")
        .document(userId)
        .get()
        .catchError((e) {
      print(e);
    });
    return ds.exists ? ds.data["name"].toString() : "";
  }

  static Future<Reminder> getReminder(String reminderId) async {
    DocumentSnapshot ds = await _firestore
        .collection("reminders")
        .document(reminderId)
        .get()
        .catchError((e) {
      print(e);
    });
    return ds.exists ? Reminder.fromJson(ds) : null;
  }

  static Future<List<Reminder>> getRemindersLinkedToProfile(
      String profileId) async {
    QuerySnapshot qs = await _firestore
        .collection("reminders")
        .where("ownerId", isEqualTo: AppConfig.currentProfile.id)
        .where("cardIds", arrayContains: profileId)
        .getDocuments();
    return new List<Reminder>.generate(
        qs.documents.length, (i) => new Reminder.fromJson(qs.documents[i]));
  }

  static Future<void> sendMessage(Message message) async {
    DocumentReference ref = _firestore.collection("messages").document();
    message.id = ref.documentID;
    ref.setData(message.toJson());
  }

  static Future<DocumentReference> setLiveEvent(LiveEvent event) async {
    event.ref = _firestore.collection("liveEvents").document();
    await event.ref.setData(event.toJson());
    return event.ref;
  }

  static Future<List<DocumentSnapshot>> getLiveEvents(List<String> tags) async {
    QuerySnapshot qs = await _firestore
        .collection("liveEvents")
        .where("liveTag", whereIn: tags)
        .getDocuments();
    return qs.documents;
  }

  static Future<List<DocumentSnapshot>> getCardDesigns() async {
    QuerySnapshot qs =
        await _firestore.collection("cardDesigns").getDocuments();
    return qs.documents;
  }

  static Future<void> reportProfile(Report report) async {
    _firestore.collection("profileReports").add(report.toJson());
  }

  /* static Future<void> setCardDesigns() async {
    _firestore.collection("cardDesigns").add({
      "horizantalCardDesigns": hrzCardDesign,
      "verticalCardDesigns": vertCardDesign,
    });
  }
 */
  /* static Future<void> setAdminProfile() async {
    Profile profile = new Profile(
        "admin", CardStructure.horizantal, ProfileType.business, "admin");
    _firestore
        .collection("profiles")
        .document("admin")
        .setData(profile.toJson());
  } */
}
