import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final String label;
  final Icon? icon;
  final VoidCallback? onPressed;

  const RoundedButton({
    super.key,
    this.icon,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120,
      child: icon != null
          ? TextButton.icon(
              onPressed: onPressed,
              icon: icon!,
              label: Text(label),
              style: TextButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            )
          : TextButton(
              onPressed: onPressed,
              style: TextButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(label),
            ),
    );
  }
}
