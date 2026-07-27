import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:dio/dio.dart';
import 'dart:convert';

const apiKey = "AIzaSyBhDflq5iJrXIcKpeq0IzLQPQpOboX91lY";

class GoogleMapsServices {
  final Dio _dio = Dio();
  
  Future<String> getRouteCoordinates(LatLng l1, LatLng l2) async {
    String url =
        "https://maps.googleapis.com/maps/api/directions/json?origin=${l1.latitude},${l1.longitude}&destination=${l2.latitude},${l2.longitude}&key=$apiKey";
    Response response = await _dio.get(url);
    Map values = response.data is String ? jsonDecode(response.data) : response.data;
    return values["routes"][0]["overview_polyline"]["points"];
  }
}
