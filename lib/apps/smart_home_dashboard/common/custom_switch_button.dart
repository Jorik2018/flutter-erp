import 'package:flutter/material.dart';

class CustomSwitchButton extends StatelessWidget {
  const CustomSwitchButton({
    super.key,
    required this.activeTrackColor,
    required this.value,
    required this.indicatorActiveColor,
    required this.indicatorInActiveColor,
    required this.animationDuration,
    required this.inActiveTrackColor,
    this.width = 32.0,
    this.onChanged,
    this.indicatorPadding = const EdgeInsets.all(1),
  });

  final bool value;
  final Color indicatorActiveColor;
  final Color indicatorInActiveColor;
  final Color activeTrackColor;
  final Color inActiveTrackColor;
  final double width;
  final Duration animationDuration;
  final EdgeInsets indicatorPadding;
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) {
    final height = width / 2;

    return GestureDetector(
      onTap: () => onChanged?.call(!value),
      child: AnimatedContainer(
        duration: animationDuration,
        width: width,
        height: height,
        padding: indicatorPadding,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(height),
          color: value ? activeTrackColor : inActiveTrackColor,
        ),
        child: Stack(
          children: [
            AnimatedAlign(
              duration: animationDuration,
              curve: Curves.easeInOut,
              alignment:
                  value ? Alignment.centerRight : Alignment.centerLeft,
              child: AnimatedContainer(
                duration: animationDuration,
                width: height,
                height: height,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: value
                      ? indicatorActiveColor
                      : indicatorInActiveColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
