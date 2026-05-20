import 'dart:convert';
import 'dart:core';
import 'dart:math' as Math;

import 'package:flutter_erp/apps/fu_uber/core/models/google_places/places_autocomplete_response.dart';
import 'package:flutter_erp/apps/fu_uber/core/models/google_places/prediction.dart';
import 'package:flutter_erp/apps/fu_uber/core/models/google_places/structured_formatting.dart';
import 'package:flutter_erp/apps/fu_uber/core/constants/Constants.dart';
import 'package:flutter_erp/apps/fu_uber/core/Utils/LogUtils.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart'; // 👈 se mantiene SOLO para modelos
import 'package:http/http.dart' as http;
import 'package:vector_math/vector_math.dart';
import 'package:geocoding/geocoding.dart' as geocoding;

class MapRepository {

  static const TAG = "MapRepository";

  final http.Client _client = http.Client();

  // =========================
  // DIRECTIONS
  // =========================
  Future<String> getRouteCoordinates(LatLng l1, LatLng l2) async {
    try {
      final url =
          "https://maps.googleapis.com/maps/api/directions/json"
          "?origin=${l1.latitude},${l1.longitude}"
          "&destination=${l2.latitude},${l2.longitude}"
          "&key=${Constants.anotherApiKey}";

      final response = await _client.get(Uri.parse(url));

      if (response.statusCode != 200) {
        throw Exception("HTTP ${response.statusCode}");
      }

      final values = jsonDecode(response.body);

      return values["routes"][0]["overview_polyline"]["points"];
    } catch (e) {
      ProjectLog.logIt(TAG, "getRouteCoordinates ERROR", e.toString());
      return "";
    }
  }

  // =========================
  // AUTOCOMPLETE (SIN LIB OBSOLETA)
  // =========================
  Future<PlacesAutocompleteResponse> getAutoCompleteResponse(
      String search) async {
    try {
      final url =
          "https://maps.googleapis.com/maps/api/place/autocomplete/json"
          "?input=$search"
          "&key=${Constants.mapApiKey}"
          "&components=country:pe";

      final response = await _client.get(Uri.parse(url));

      if (response.statusCode != 200) {
        throw Exception("HTTP ${response.statusCode}");
      }

      final data = jsonDecode(response.body);

      // 👇 adaptamos respuesta manualmente al modelo esperado
      final predictions = (data["predictions"] as List).map((e) {
        return Prediction(
          description: e["description"],
          placeId: e["place_id"],
          structuredFormatting: StructuredFormatting(
            mainText: e["structured_formatting"]?["main_text"] ?? "",
            secondaryText:
                e["structured_formatting"]?["secondary_text"] ?? "",
          ),
        );
      }).toList();

      return PlacesAutocompleteResponse(
        predictions: predictions,
        status: data["status"],
      );
    } catch (e) {
      ProjectLog.logIt(TAG, "getAutoCompleteResponse ERROR", e.toString());

      return PlacesAutocompleteResponse(
        predictions: [],
        status: "ERROR",
      );
    }
  }

  // =========================
  // REVERSE GEOCODING
  // =========================
  Future<String> getPlaceNameFromLatLng(LatLng latLng) async {
    try {
      final placemark = await geocoding.placemarkFromCoordinates(
          latLng.latitude, latLng.longitude);

      return placemark[0].name! +
          ", " +
          placemark[0].locality! +
          ", " +
          placemark[0].country!;
    } catch (e) {
      ProjectLog.logIt(TAG, "getPlaceName ERROR", e.toString());
      return "No work on web";
    }
  }

  // =========================
  // FORWARD GEOCODING
  // =========================
  Future<LatLng> getLatLngFromAddress(String address) async {
    try {
      final list = await geocoding.locationFromAddress(address);

      return LatLng(list[0].latitude, list[0].longitude);
    } catch (e) {
      ProjectLog.logIt(TAG, "getLatLngFromAddress ERROR", e.toString());
      return const LatLng(0, 0);
    }
  }

  // =========================
  // MIDPOINT (FIXED)
  // =========================
  LatLng getMidPointBetween(LatLng one, LatLng two) {
    double lat1 = radians(one.latitude);
    double lon1 = radians(one.longitude);
    double lat2 = radians(two.latitude);
    double lon2 = radians(two.longitude);

    double dLon = lon2 - lon1;

    double Bx = Math.cos(lat2) * Math.cos(dLon);
    double By = Math.cos(lat2) * Math.sin(dLon);

    double lat3 = Math.atan2(
        Math.sin(lat1) + Math.sin(lat2),
        Math.sqrt((Math.cos(lat1) + Bx) * (Math.cos(lat1) + Bx) + By * By));

    double lon3 = lon1 + Math.atan2(By, Math.cos(lat1) + Bx);

    // 👇 FIX: convertir a grados
    return LatLng(degrees(lat3), degrees(lon3));
  }
}