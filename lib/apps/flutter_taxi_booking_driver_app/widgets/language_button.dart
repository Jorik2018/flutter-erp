import 'package:flutter/material.dart';
import 'package:flutter_erp/apps/flutter_taxi_booking_driver_app/common/my_colors.dart';

class LanguageButton extends StatelessWidget {
  final Color btnColor;
  final Color btnBorderColor;
  final String btnTxt;
  final VoidCallback btnOnTap;
  final bool isShowIcon;

  const LanguageButton({
    super.key,
    this.btnColor = kPrimaryColor,
    this.btnBorderColor = Colors.white,
    required this.btnTxt,
    required this.btnOnTap,
    this.isShowIcon = false,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        SizedBox(
          width: 220,
          height: 49,
          child: TextButton(
            style: TextButton.styleFrom(
              backgroundColor: btnColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24.0),
                side: BorderSide(color: btnBorderColor),
              ),
            ),
            onPressed: btnOnTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                btnTxt,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        if (isShowIcon)
          Positioned(
            right: 10,
            top: 12,
            child: Container(
              height: 25,
              width: 25,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25 / 2),
                color: Colors.white,
              ),
              child: const Center(
                child: Icon(Icons.chevron_right, color: Color(0XFF275687)),
              ),
            ),
          ),
      ],
    );
  }
}
