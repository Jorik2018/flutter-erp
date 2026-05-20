import 'package:flutter/material.dart' hide Page;
import 'package:flutter_erp/apps/flutter_app/models/trip_model.dart';
import 'package:flutter_erp/apps/flutter_app/page.dart';
import 'package:flutter_erp/apps/flutter_app/trip_view.dart';

class TripListTabItem extends StatelessWidget {
  const TripListTabItem({ this.page, this.data });

  static const double height = 210.0;
  final Page? page;
  final TripInfo? data;

  @override
  Widget build(BuildContext context) {
    return  Card(
      child:  Padding(
        padding: const EdgeInsets.all(16.0),
        child:  Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          //mainAxisSize: MainAxisSize.min,
          children: <Widget>[
      
             TripListItem(data!)
          ],
        ),
      ),
    );
  }
}