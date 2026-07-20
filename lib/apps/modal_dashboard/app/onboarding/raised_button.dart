import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../constants/constant.dart';

class OnboardingFormElevatedButton extends StatelessWidget {
  const OnboardingFormElevatedButton({
    super.key,
    required this.text,
    required this.width,
    this.onPressed,
    this.color = AppColors.primary,
    this.textColor = AppColors.white,
    this.showActivityIndicator = false,
    this.height = 46,
  });

  final String text;
  final double width;
  final double height;
  final VoidCallback? onPressed;
  final Color color;
  final Color textColor;
  final bool showActivityIndicator;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: showActivityIndicator ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: textColor,
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: showActivityIndicator
              ? const CupertinoActivityIndicator()
              : Text(text),
        ),
      ),
    );
  }
}
