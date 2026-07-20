import 'package:flutter/material.dart';

import '../../constants/colors.dart';
import '../common/vertical_spacer.dart';
import 'raised_button.dart';

class OnboardingFormLeftView extends StatelessWidget {
  const OnboardingFormLeftView({
    super.key,
    required this.imageAsset,
    required this.title,
    required this.imageWidth,
    required this.imageHeight,
    required this.buttonWidth,
    required this.buttonTitle,
    required this.onButtonPressed,
    this.buttonColor = AppColors.black,
    this.titleTextColor = AppColors.black,
    this.buttonTextColor = AppColors.white,
    this.bottomOffset = 88,
  });

  final String imageAsset;
  final String title;
  final double imageWidth;
  final String buttonTitle;
  final double imageHeight;
  final double buttonWidth;
  final double bottomOffset;

  final VoidCallback? onButtonPressed;

  final Color buttonColor;
  final Color titleTextColor;
  final Color buttonTextColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: imageWidth,
      height: imageHeight,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(imageAsset, fit: BoxFit.cover),
          Positioned(
            left: 0,
            right: 0,
            bottom: bottomOffset,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: titleTextColor.withValues(alpha: 0.8),
                    ),
                  ),
                ),
                const VerticalSpacer(space: 32),
                OnboardingFormElevatedButton(
                  width: buttonWidth,
                  onPressed: onButtonPressed,
                  color: buttonColor.withValues(alpha: 0.8),
                  text: buttonTitle,
                  textColor: buttonTextColor,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
