import 'package:bcard/utilities/Classes/MessageClasses/imageMessageClass.dart';
import 'package:bcard/utilities/Classes/MessageClasses/reminderMessageClass.dart';
import 'package:bcard/utilities/Classes/MessageClasses/textMessageClass.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class Message {
  String id, senderProfileId, recieverProfileId;
  DateTime date;
  bool seen;
  MessageType type;
  DocumentReference ref;
  Message(this.senderProfileId, this.recieverProfileId) {
    this.date = DateTime.now();
    this.seen = false;
  }

  Message.fromJson(DocumentSnapshot doc) {
    this.ref = doc.reference;
    this.id = doc.data()["id"];
    this.type = MessageType.values[int.parse(doc.data()["type"].toString())];
    this.senderProfileId = doc.data()["senderProfileId"];
    this.recieverProfileId = doc.data()["recieverProfileId"];
    this.date = DateTime.parse(doc.data()["date"].toString());
    this.seen = doc.data()["seen"];
  }

  Map<String, dynamic> toJson() => {
        "id": this.id,
        "type": this.type.index,
        "senderProfileId": this.senderProfileId,
        "recieverProfileId": this.recieverProfileId,
        "date": this.date.toIso8601String(),
        "seen": this.seen,
      };
}

Message getMessage(DocumentSnapshot doc) {
  MessageType _type =
      MessageType.values[int.parse(doc.data()["type"].toString())];
  switch (_type) {
    case MessageType.text:
      return TextMessage.fromJson(doc);
      break;
    case MessageType.image:
      return ImageMessage.fromJson(doc);
      break;
    case MessageType.reminder:
      return ReminderMessage.fromJson(doc);
      break;
    default:
      return null;
  }
}

enum MessageType { text, image, reminder }
