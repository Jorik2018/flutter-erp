import 'dart:async';

import 'package:flutter_erp/apps/fu_uber/core/Enums/Enums.dart';
import 'package:flutter_erp/apps/fu_uber/core/models/Drivers.dart';
import 'package:flutter_erp/apps/fu_uber/core/models/UserPlaces.dart';
import 'package:flutter_erp/apps/fu_uber/core/Networking/ApiProvider.dart';

class Repository {

  static Future<AuthStatus> isUserAlreadyAuthenticated() async {
    return AuthStatus.Authenticated;
  }

  static Future<int> sendOTP(String phone) async {
    return await ApiProvider.sendOtpToUser(phone);
  }

  static Future<int> verifyOtp(String text) async {
    //just returning 1
    //somehow check the otp
    return await ApiProvider.verifyOtp(text);
  }

  static void getNearbyDrivers(
      StreamController<List<Driver>> nearbyDriverStreamController) {
    nearbyDriverStreamController.sink.add(ApiProvider.getNearbyDrivers());
  }

  static void addFavPlacesToDataBase(List<UserPlaces> data) {
    //
  }

}
