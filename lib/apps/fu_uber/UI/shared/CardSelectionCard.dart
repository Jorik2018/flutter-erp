import 'package:flutter/material.dart';
import 'package:flutter_erp/apps/fu_uber/core/models/CarTypeMenu.dart';
import 'package:flutter_erp/apps/fu_uber/core/Utils/BasicShapeUtils.dart';

class CarSelectionCard extends StatelessWidget {

  final CarTypeMenu carTypeMenu;

  const CarSelectionCard({Key? key, required this.carTypeMenu})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Material(
        shape: ShapeUtils.rounderCard,
        elevation: 1,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  carTypeMenu!.image,
                  fit: BoxFit.fitHeight,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                carTypeMenu!.rideType.toString(),
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                carTypeMenu!.info,
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
              ),
            )
          ],
        ),
      ),
    );
  }
}
