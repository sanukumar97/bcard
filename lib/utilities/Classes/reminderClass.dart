import 'package:bcard/utilities/Constants/encodersAndDecoders.dart';
import 'package:bcard/utilities/Constants/randomConstants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Reminder {
  String id, ownerId, description;
  DateTime date;
  List<String> cardIds;
  String pinnedProfile;
  bool completed;
  Color color;
  DocumentReference ref;

  Reminder(this.date, this.ownerId, this.description, this.cardIds,
      this.completed, this.pinnedProfile) {
    color = color3;
  }

  Reminder.fromJson(DocumentSnapshot doc) {
    this.ref = doc.reference;
    this.id = doc.data["id"];
    this.date = DateTime.parse(doc.data["date"].toString());
    this.ownerId = doc.data["ownerId"];
    this.description = doc.data["description"];
    this.cardIds = List<String>.generate(
        doc.data["cardIds"].length, (i) => doc.data["cardIds"][i]);
    this.completed = doc.data["completed"] ?? false;
    this.pinnedProfile = doc.data["pinnedProfile"];
    this.color = colorDecoder(doc.data["color"].toString());
  }

  Map<String, dynamic> toJson() => {
        "id": this.id,
        "date": this.date.toIso8601String(),
        "ownerId": this.ownerId,
        "description": this.description,
        "cardIds": this.cardIds,
        "completed": this.completed,
        "pinnedProfile": this.pinnedProfile,
        "color": colorEncoder(this.color),
      };
}
