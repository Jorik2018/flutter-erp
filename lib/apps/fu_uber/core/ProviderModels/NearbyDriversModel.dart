import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_erp/apps/fu_uber/core/models/Drivers.dart';
import 'package:flutter_erp/apps/fu_uber/core/repository/Repository.dart';

class NearbyDriversModel extends ChangeNotifier {

  late List<Driver> nearbyDrivers;
  
  final nearbyDriverStreamController = StreamController<List<Driver>>();

  get nearbyDriverList => nearbyDrivers;

  Stream<List<Driver>> get dataStream => nearbyDriverStreamController.stream;

  NearbyDriversModel() {
    //We will be listening to the nearbyDrivers events like, there location Updates etc.
    //using streams maybe..
    Repository.getNearbyDrivers(nearbyDriverStreamController);

    dataStream.listen((list) {
      nearbyDrivers = list;
      notifyListeners();
    });
  }

  void closeStream() {
    nearbyDriverStreamController.close();
  }
}
