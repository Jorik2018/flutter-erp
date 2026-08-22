import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import 'package:flutter_erp/apps/flutter_taxi_app_3/models/user_location.dart';

class UserLocationController {
  static Future<LatLng?> getCurrentLocation() async {
    final location = Location();

    // 1. Comprobar si el servicio de ubicación está activo.
    var serviceEnabled = await location.serviceEnabled();

    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();

      if (!serviceEnabled) {
        return null;
      }
    }

    // 2. Comprobar permisos.
    var permission = await location.hasPermission();

    if (permission == PermissionStatus.denied) {
      permission = await location.requestPermission();

      if (permission != PermissionStatus.granted &&
          permission != PermissionStatus.grantedLimited) {
        return null;
      }
    }

    if (permission == PermissionStatus.deniedForever) {
      return null;
    }

    // 3. Obtener ubicación.
    final position = await location.getLocation();

    final latitude = position.latitude;
    final longitude = position.longitude;

    if (latitude == null || longitude == null) {
      return null;
    }

    return LatLng(latitude, longitude);
  }

  static Future<List<UserLocation>> getSavedLocations() async {
    return [
      UserLocation.named(
        name: 'Home',
        locationType: UserLocationType.Home,
        position: const LatLng(0, 0),
        minutesFar: 52,
      ),
      UserLocation.named(
        name: 'Innov8',
        locationType: UserLocationType.Office,
        position: const LatLng(0, 0),
        minutesFar: 36,
      ),
    ];
  }
}
