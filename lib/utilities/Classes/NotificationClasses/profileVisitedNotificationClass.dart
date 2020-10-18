import 'package:bcard/utilities/Classes/NotificationClasses/notificationClass.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileVisitedNotification extends AppNotification {
  ProfileVisitedNotification(String senderProfileId, String recieverProfileId) {
    this.notificationType = NotificationType.visit;
    this.senderProfileId = senderProfileId;
    this.recieverProfileId = recieverProfileId;
    this.date = DateTime.now();
  }

  ProfileVisitedNotification.fromJson(DocumentSnapshot doc) {
    this.ref = doc.reference;
    this.id = doc.data()["id"];
    this.notificationType = NotificationType.visit;
    this.senderProfileId = doc.data()["senderProfileId"];
    this.recieverProfileId = doc.data()["recieverProfileId"];
    this.date = DateTime.parse(doc.data()["date"].toString());
  }

  Map<String, dynamic> toJson() => {
        "id": this.id,
        "notificationType": this.notificationType.index,
        "senderProfileId": this.senderProfileId,
        "recieverProfileId": this.recieverProfileId,
        "date": this.date.toIso8601String(),
      };
}
