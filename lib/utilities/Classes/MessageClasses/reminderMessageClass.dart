import 'package:bcard/utilities/Classes/MessageClasses/messageClass.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ReminderMessage extends Message {
  String reminderId;
  ReminderMessageStatus status;

  ReminderMessage(
      String senderProfileId, String recieverProfileId, this.reminderId)
      : super(senderProfileId, recieverProfileId) {
    this.type = MessageType.reminder;
    this.status = ReminderMessageStatus.none;
  }

  ReminderMessage.fromJson(DocumentSnapshot doc) : super.fromJson(doc) {
    this.reminderId = doc.data()["reminderId"];
    this.status =
        ReminderMessageStatus.values[int.parse(doc.data()["status"].toString())];
  }

  Map<String, dynamic> toJson() {
    var data = super.toJson();
    data.addAll({
      "reminderId": this.reminderId,
      "status": this.status.index,
    });
    return data;
  }
}

enum ReminderMessageStatus { itsDone, willDo, notNow, none }
