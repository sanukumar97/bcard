import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class AppLocation {
  static Location _location;

  static void init() {
    _location = new Location();
  }

  static Future<LatLng> get currentLocation async {
    /* if (await _location.serviceEnabled()) {
      if (await _location.hasPermission() == PermissionStatus.granted) {
        LocationData locationData = await _location.getLocation();
        if (_location != null) {
          return LatLng(locationData.latitude, locationData.longitude);
        } else
          return null;
      } else {
        _location.requestPermission();
        return null;
      }
    } else {
      _location.requestService();
      return null;
    } */
    return null;
  }
}
