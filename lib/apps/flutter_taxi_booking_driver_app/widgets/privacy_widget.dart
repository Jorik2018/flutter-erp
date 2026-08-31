import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_erp/apps/flutter_taxi_booking_driver_app/common/my_colors.dart';

class PrivacyWidget extends StatelessWidget {
  final String myTitle;
  final String mydeisc;

  const PrivacyWidget({
    super.key,
    required this.myTitle,
    required this.mydeisc,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              myTitle,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                fontWeight: FontWeight.w500,
                color: kPrimaryColor,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 3),
            SizedBox(
              width: MediaQuery.of(context).size.width / 1.8,
              child: Text(
                mydeisc,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: kTextLoginfaceid,
                  fontSize: 15,
                ),
              ),
            ),
          ],
        ),
        Transform.scale(
          scale: 1,
          child: CupertinoSwitch(
            activeTrackColor: const Color(0XFF275687),
            value: false,
            onChanged: (bool value) {
              // TODO: manejar cambio
            },
          ),
        ),
      ],
    );
  }
}
