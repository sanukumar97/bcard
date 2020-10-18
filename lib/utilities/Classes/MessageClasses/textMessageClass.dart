import 'package:bcard/utilities/Classes/MessageClasses/messageClass.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TextMessage extends Message {
  String text;

  TextMessage(String senderProfileId, String recieverProfileId, this.text)
      : super(senderProfileId, recieverProfileId) {
    this.type = MessageType.text;
  }

  TextMessage.fromJson(DocumentSnapshot doc) : super.fromJson(doc) {
    this.text = doc.data()["text"];
  }

  Map<String, dynamic> toJson() {
    var data = super.toJson();
    data.addAll({"text": this.text});
    return data;
  }
}
