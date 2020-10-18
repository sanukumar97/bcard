import 'package:firebase_messaging/firebase_messaging.dart';

class AppMessaging {
  static final FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();
  static void init() {
    _firebaseMessaging.requestNotificationPermissions();
    _firebaseMessaging.configure(
      //Called when app is in foreground
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        //_showItemDialog(message);
      },
      onBackgroundMessage: null, //myBackgroundMessageHandler,
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        //_navigateToItemDetail(message);
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        //_navigateToItemDetail(message);
      },
    );
  }
}
