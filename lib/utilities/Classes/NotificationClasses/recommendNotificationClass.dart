import 'package:bcard/utilities/Classes/NotificationClasses/notificationClass.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RecommendNotification extends AppNotification {
  String recommendedProfileId;

  RecommendNotification(String senderProfileId, String recieverProfileId,
      this.recommendedProfileId) {
    this.notificationType = NotificationType.recommend;
    this.senderProfileId = senderProfileId;
    this.recieverProfileId = recieverProfileId;
    this.date = DateTime.now();
  }

  RecommendNotification.fromJson(DocumentSnapshot doc) {
    this.ref = doc.reference;
    this.id = doc.data()["id"];
    this.notificationType = NotificationType.recommend;
    this.senderProfileId = doc.data()["senderProfileId"];
    this.recieverProfileId = doc.data()["recieverProfileId"];
    this.date = DateTime.parse(doc.data()["date"].toString());
    this.recommendedProfileId = doc.data()["recommendedProfileId"];
  }

  Map<String, dynamic> toJson() => {
        "id": this.id,
        "notificationType": this.notificationType.index,
        "senderProfileId": this.senderProfileId,
        "recieverProfileId": this.recieverProfileId,
        "date": this.date.toIso8601String(),
        "recommendedProfileId": this.recommendedProfileId,
      };
}
