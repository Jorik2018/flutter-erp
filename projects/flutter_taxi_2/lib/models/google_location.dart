import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleLocation {
  final String placeId;
  final LatLng position;
  final String areaDetails;

  GoogleLocation(this.placeId, this.position, this.areaDetails);

  GoogleLocation.named({required this.placeId, required this.position, required this.areaDetails});
}
