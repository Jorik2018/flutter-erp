import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_erp/apps/wonders/logic/common/http_client.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:flutter_erp/apps/fluter_uber_clone/DataHandler/appData.dart';
import 'package:flutter_erp/apps/fluter_uber_clone/models/address.dart';
import 'package:flutter_erp/apps/fluter_uber_clone/models/allUsers.dart';
import 'package:flutter_erp/apps/fluter_uber_clone/models/directionDetails.dart';
import 'package:firebase_auth/firebase_auth.dart';

var mapkey = '';

class ApiMethods {
  static Future<String> seachCoordinateAddress(
    Position position,
    context,
  ) async {
    String placeAddress = "";
    String addressNo;
    String addressPla;
    String addressDetail;
    //  String addressDetail2;
    String url =
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$mapkey";
    var response = await HttpClient.get(url);
    if (response.success) {
      final data = jsonDecode(response.body!);
      //  placeAddress = response["results"][0]["formatted_address"];
      addressNo = data["results"][0]["address_components"][0]["long_name"];
      addressPla = data["results"][0]["address_components"][1]["long_name"];
      addressDetail = data["results"][0]["address_components"][2]["short_name"];
      // addressDetail2 = response["results"][0]["address_components"][3]["long_name"];
      placeAddress = addressNo + "," + addressPla + ", " + addressDetail;
      Address userPickUpAddress = Address();
      userPickUpAddress.longitude = position.longitude;
      userPickUpAddress.latitude = position.latitude;
      userPickUpAddress.placeName = placeAddress;

      Provider.of<AppData>(
        context,
        listen: false,
      ).updatePickUplocation(userPickUpAddress);
    }
    return placeAddress;
  }

  static Future<DirectionDetails?> obtainDirections(
    LatLng initialPosition,
    LatLng finalPosition,
  ) async {
    String directionUrl =
        "https://maps.googleapis.com/maps/api/directions/json?origin=${initialPosition.latitude},${initialPosition.longitude}&destination=${finalPosition.latitude},${finalPosition.longitude}&key=$mapkey";

    var response = await HttpClient.get(directionUrl);
    if (!response.success) {
      return null;
    }
    final res = jsonDecode(response.body!);

    DirectionDetails directionDetails = DirectionDetails();
    directionDetails.encodedPoints =
        res["routes"][0]["overview_polyline"]["points"];
    directionDetails.distanceText =
        res["routes"][0]["legs"][0]["distance"]["text"];
    directionDetails.distanceValue =
        res["routes"][0]["legs"][0]["distance"]["value"];

    directionDetails.durationText =
        res["routes"][0]["legs"][0]["duration"]["text"];
    directionDetails.durationValue =
        res["routes"][0]["legs"][0]["duration"]["value"];

    print(res["routes"]);
    return directionDetails;
  }

  static int calculateFares(DirectionDetails directionDetails) {
    //in term of USD
    double timeTraveledFare = (directionDetails.durationValue! / 60) * 0.20;
    double distanceTraveledFare =
        (directionDetails.distanceValue! / 1000) * 0.20;
    double totalFareAmount = timeTraveledFare + distanceTraveledFare;

    //1$ = 450 Naira, convert to Naira
    double convertToNigeriatotalFarAmt = totalFareAmount * 450;

    return convertToNigeriatotalFarAmt.truncate();
  }

  static void getCurrentOnlineUserInfo() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) return;

    String userId = user.uid;

    DatabaseReference databaseReference = FirebaseDatabase.instance
        .ref()
        .child('users')
        .child(userId);

    DatabaseEvent event = await databaseReference.once();

    DataSnapshot dataSnapshot = event.snapshot;

    if (dataSnapshot.value != null) {
      //currentUser = Users.fromSnapshot(dataSnapshot);
    }
  }
}
