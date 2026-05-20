import 'package:flutter/material.dart';
import 'package:flutter_erp/apps/flutter_app/models/trip_model.dart';

class TripListItem extends StatelessWidget {
  final TripInfo _trip;

  TripListItem(this._trip);

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
      Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
        Expanded(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.black45,
                  ),
                  child: Text(
                    _trip.completed!,
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                )
              ]),
        ),
        Text(
          _trip.date!,
          style: TextStyle(color: Colors.grey, fontSize: 14.0),
        ),
      ]),
      Container(
          padding: const EdgeInsets.symmetric(vertical: 25.0),
          child: Column(children: <Widget>[
            Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Icon(Icons.send),
                  Expanded(
                      child: Row(children: <Widget>[
                    Text(
                      _trip.pickupLocation!,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ])),
                ]),
            Row(children: <Widget>[
              Icon(Icons.send),
              Text(
                _trip.destLocation!,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ])
          ])),
      Row(children: <Widget>[
        Expanded(
            child: Container(
                child: Row(children: <Widget>[
          Icon(
            Icons.timer,
            color: Colors.grey,
          ),
          Text(_trip.time!,
              style: TextStyle(color: Colors.grey, fontSize: 14.0)),
          Icon(Icons.local_car_wash, color: Colors.grey),
          Text(_trip.className!,
              style: TextStyle(color: Colors.grey, fontSize: 14.0)),
        ]))),
        Icon(Icons.credit_card, color: Colors.grey),
        Text(_trip.payBy!,
            style: TextStyle(color: Colors.grey, fontSize: 14.0)),
      ])
    ]);
  }
}
