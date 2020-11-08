import 'package:firebase_messaging/firebase_messaging.dart';

class AppMessaging {
  static final FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();
  static Future<void> init() async {
    await _firebaseMessaging.requestNotificationPermissions();
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
    _getTokenId();
  }

  static void _getTokenId() async {
    await Future.delayed(Duration(seconds: 15));
    String token = await _firebaseMessaging.getToken();
    print(token);
  }
}
