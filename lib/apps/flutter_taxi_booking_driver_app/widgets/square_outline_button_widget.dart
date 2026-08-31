import 'package:flutter/material.dart';

class SqaureOutlineButtonWidget extends StatelessWidget {
  final String btnTxt;
  final VoidCallback btnOnTap;
  final Color borderColor;
  final Color? textColor;
  final IconData btnIcon;
  final bool iconShow;

  const SqaureOutlineButtonWidget({
    super.key,
    required this.btnTxt,
    required this.btnOnTap,
    required this.borderColor,
    this.textColor,
    required this.btnIcon,
    this.iconShow = true,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: btnOnTap,
      style: OutlinedButton.styleFrom(
        shape: const StadiumBorder(),
        side: BorderSide(color: borderColor, width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          if (iconShow) Icon(btnIcon, size: 20, color: const Color(0xff979797)),
          const SizedBox(width: 2),
          Text(
            btnTxt,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium!.copyWith(fontSize: 15, color: textColor),
          ),
        ],
      ),
    );
  }
}
