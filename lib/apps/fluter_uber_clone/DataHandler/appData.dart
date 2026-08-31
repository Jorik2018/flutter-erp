import 'package:flutter/cupertino.dart';
import 'package:flutter_erp/apps/fluter_uber_clone/models/address.dart';

class AppData extends ChangeNotifier {
  Address? pickUpLocation, dropOfflocation;

  void updatePickUplocation(Address pickUpAddress) {
    pickUpLocation = pickUpAddress;
    notifyListeners();
  }

  void updateDropOfflocation(Address dropOffAddress) {
    dropOfflocation = dropOffAddress;
    notifyListeners();
  }
}
