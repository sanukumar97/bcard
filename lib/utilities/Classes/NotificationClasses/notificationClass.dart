import 'package:bcard/utilities/Classes/NotificationClasses/profileRequestNotificationClass.dart';
import 'package:bcard/utilities/Classes/NotificationClasses/profileVisitedNotificationClass.dart';
import 'package:bcard/utilities/Classes/NotificationClasses/recommendNotificationClass.dart';
import 'package:bcard/utilities/Classes/NotificationClasses/reminderNotificationClass.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class AppNotification {
  String id;
  NotificationType notificationType;
  String senderProfileId, recieverProfileId;
  DateTime date;
  DocumentReference ref;

  static AppNotification getNotification(DocumentSnapshot doc) {
    NotificationType _type = NotificationType
        .values[int.parse(doc.data["notificationType"].toString())];
    switch (_type) {
      case NotificationType.profileRequest:
        return ProfileRequestNotification.fromJson(doc);
        break;
      case NotificationType.recommend:
        return RecommendNotification.fromJson(doc);
        break;
      case NotificationType.visit:
        return ProfileVisitedNotification.fromJson(doc);
        break;
      case NotificationType.reminder:
        return ReminderNotification.fromJson(doc);
        break;
      default:
        return null;
    }
  }
}

enum NotificationType { profileRequest, recommend, reminder, visit }
