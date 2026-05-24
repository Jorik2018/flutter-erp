import 'package:flutter/material.dart';
import '../constants.dart';

class DefaultButton extends StatelessWidget {
  const DefaultButton({
    super.key,
    this.imageSrc,
    required this.text,
    this.onPressed,
  });

  final String? imageSrc;
  final String text;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFE8F0F9),
        foregroundColor: Colors.black,
        padding: EdgeInsets.symmetric(
          vertical: kDefaultPadding,
          horizontal: kDefaultPadding * 2.5,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        elevation: 0,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (imageSrc != null) ...[
            Image.asset(imageSrc!, height: 40),
            SizedBox(width: kDefaultPadding),
          ],
          Text(text),
        ],
      ),
    );
  }
}