import 'package:bcard/utilities/Classes/NotificationClasses/notificationClass.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ReminderNotification extends AppNotification {
  String reminderId;

  ReminderNotification(
      String senderProfileId, String recieverProfileId, this.reminderId) {
    this.notificationType = NotificationType.reminder;
    this.senderProfileId = senderProfileId;
    this.recieverProfileId = recieverProfileId;
    this.date = DateTime.now();
  }

  ReminderNotification.fromJson(DocumentSnapshot doc) {
    this.ref = doc.reference;
    this.id = doc.data()["id"];
    this.notificationType = NotificationType.reminder;
    this.senderProfileId = doc.data()["senderProfileId"];
    this.recieverProfileId = doc.data()["recieverProfileId"];
    this.date = DateTime.parse(doc.data()["date"].toString());
    this.reminderId = doc.data()["reminderId"];
  }

  Map<String, dynamic> toJson() => {
        "id": this.id,
        "notificationType": this.notificationType.index,
        "senderProfileId": this.senderProfileId,
        "recieverProfileId": this.recieverProfileId,
        "date": this.date.toIso8601String(),
        "reminderId": this.reminderId,
      };
}
