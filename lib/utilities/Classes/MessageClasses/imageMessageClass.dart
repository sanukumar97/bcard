
import 'package:bcard/utilities/Classes/MessageClasses/messageClass.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ImageMessage extends Message {
  String imageUrl;

  ImageMessage(String senderProfileId, String recieverProfileId, this.imageUrl)
      : super(senderProfileId, recieverProfileId) {
    this.type = MessageType.image;
  }

  ImageMessage.fromJson(DocumentSnapshot doc) : super.fromJson(doc) {
    this.imageUrl = doc.data["imageUrl"];
  }

  Map<String, dynamic> toJson() {
    var data = super.toJson();
    data.addAll({"imageUrl": this.imageUrl});
    return data;
  }
}
