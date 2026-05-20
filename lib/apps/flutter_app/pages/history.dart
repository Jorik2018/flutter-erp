import 'package:flutter/material.dart';
import 'package:flutter_erp/apps/flutter_app/TripList.dart';
import 'package:flutter_erp/apps/flutter_app/trip_data.dart';

class HistoryPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        appBar:  AppBar(
          title:  Text("History"),
        ),
        body:  TripList(dummyTrips)
      );
  }

}