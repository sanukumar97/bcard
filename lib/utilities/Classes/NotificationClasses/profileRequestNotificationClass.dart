import 'package:bcard/utilities/Classes/NotificationClasses/notificationClass.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileRequestNotification extends AppNotification {
  RequestStatus status;
  String senderUserId;

  ProfileRequestNotification(String senderProfileId, String recieverProfileId,
      this.senderUserId, this.status) {
    this.notificationType = NotificationType.profileRequest;
    this.senderProfileId = senderProfileId;
    this.recieverProfileId = recieverProfileId;
    this.date = DateTime.now();
  }

  ProfileRequestNotification.fromJson(DocumentSnapshot doc) {
    this.ref = doc.reference;
    this.id = doc.data["id"];
    this.notificationType = NotificationType.profileRequest;
    this.senderProfileId = doc.data["senderProfileId"];
    this.recieverProfileId = doc.data["recieverProfileId"];
    this.senderUserId = doc.data["senderUserId"];
    this.date = DateTime.parse(doc.data["date"].toString());
    this.status =
        RequestStatus.values[int.parse(doc.data["status"].toString())];
  }

  Map<String, dynamic> toJson() => {
        "id": this.id,
        "notificationType": this.notificationType.index,
        "senderProfileId": this.senderProfileId,
        "recieverProfileId": this.recieverProfileId,
        "senderUserId": this.senderUserId,
        "date": this.date.toIso8601String(),
        "status": this.status.index,
      };
}

enum RequestStatus { accepted, rejected, requested }
