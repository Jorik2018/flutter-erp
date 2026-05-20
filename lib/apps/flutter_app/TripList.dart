import 'package:flutter/material.dart';
import 'package:flutter_erp/apps/flutter_app/models/trip_model.dart';
import 'trip_view.dart';

class TripList extends StatelessWidget {

  final List<TripInfo> _trips;

  TripList(this._trips);

  @override
  Widget build(BuildContext context) {
    return  ListView(
          padding:  EdgeInsets.symmetric(vertical: 8.0),
          children: _buildList()
        );
  }

  List<TripListItem> _buildList() {
    return _trips.map((contact) =>  TripListItem(contact))
                    .toList();
  }

  int length(){
    return _trips.length;
  }

}