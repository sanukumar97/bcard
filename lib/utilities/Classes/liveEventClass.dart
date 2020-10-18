import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LiveEvent {
  String profileId, liveTag;
  LatLng location;
  DocumentReference ref;

  LiveEvent(this.profileId, this.liveTag, this.location);

  LiveEvent.fromJson(DocumentSnapshot doc) {
    ref = doc.reference;
    this.profileId = doc.data()["profileId"].toString();
    this.liveTag = doc.data()["liveTag"].toString();
    GeoPoint loc = doc.data()["location"];
    this.location = LatLng(loc.latitude, loc.longitude);
  }

  Map<String, dynamic> toJson() => {
        "profileId": this.profileId,
        "liveTag": this.liveTag,
        "location": GeoPoint(this.location.latitude, this.location.longitude),
      };
}
