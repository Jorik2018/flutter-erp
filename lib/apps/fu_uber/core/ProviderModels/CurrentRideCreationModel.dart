import 'package:carousel_slider/carousel_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter_erp/apps/fu_uber/core/Enums/Enums.dart';

class CurrentRideCreationModel extends ChangeNotifier {
  RideType? selectedRideType;
  bool riderFound = false;

  CurrentRideCreationModel() {
    selectedRideType = RideType.Classic;
  }

  String getEstimationFromOriginDestination() {
    return "200";
  }

  carTypeChanged(int index, CarouselPageChangedReason carouselPageChangedReason) {
    selectedRideType = RideType.values[index];
    notifyListeners();
  }

  searchForRides() {
    Future.delayed(Duration(seconds: 5), () {
      riderFound = true;
      notifyListeners();
    });
  }
}
