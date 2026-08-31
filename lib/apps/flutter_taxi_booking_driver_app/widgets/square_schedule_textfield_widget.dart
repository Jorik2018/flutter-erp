import 'package:flutter/material.dart';
import 'package:flutter_erp/apps/flutter_taxi_booking_driver_app/common/my_colors.dart';
import 'package:flutter_erp/apps/flutter_taxi_booking_driver_app/widgets/flat_button_widget.dart';

class SquareScheduleTextFieldWidget extends StatelessWidget {
  final double myHeight;
  final String hintText;
  final EdgeInsetsGeometry myMargin;
  final VoidCallback onScheduleTap;
  final VoidCallback onWhereToTap;

  const SquareScheduleTextFieldWidget({
    super.key,
    this.myHeight = 51,
    this.myMargin = const EdgeInsets.all(0),
    required this.hintText,
    required this.onScheduleTap,
    required this.onWhereToTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: myHeight,
      child: Stack(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            margin: myMargin,
            height: myHeight,
            decoration: BoxDecoration(
              color: kShareCodeBg,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Row(
              children: <Widget>[
                Opacity(
                  opacity: 0.64,
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: GestureDetector(
                      onTap: onWhereToTap,
                      child: Text(
                        hintText,
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: kLoginBlack,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 8),
              child: TextButtonWidget(
                btnTxt: "Schedule",
                height: 38,
                btnOnTap: onScheduleTap,
                btnColor: kAccentColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
