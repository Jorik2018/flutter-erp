import 'package:flutter/material.dart';

class TextButtonWidget extends StatelessWidget {
  final Color btnColor;
  final String btnTxt;
  final VoidCallback? btnOnTap;
  final double height;

  const TextButtonWidget({
    super.key,
    required this.btnColor,
    required this.btnTxt,
    this.btnOnTap,
    this.height = 50,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: TextButton(
        style: TextButton.styleFrom(
          backgroundColor: btnColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28.0),
          ),
        ),
        onPressed: btnOnTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
          child: Text(
            btnTxt,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium!.copyWith(fontSize: 18, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
