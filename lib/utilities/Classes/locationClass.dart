import 'package:google_maps_flutter/google_maps_flutter.dart';

class Location {
  LatLng coordinates;
  String address;

  Location(this.coordinates, this.address);

  Location.fromJson(Map<dynamic, dynamic> data) {
    String loc = data["coordinates"].toString();
    this.coordinates = new LatLng(
        double.parse(loc.split(",")[0]), double.parse(loc.split(",")[1]));
    this.address = data["address"];
  }

  Map<String, dynamic> toJson() => {
        "coordinates":
            "${this.coordinates.latitude},${this.coordinates.longitude}",
        "address": this.address,
      };
}
