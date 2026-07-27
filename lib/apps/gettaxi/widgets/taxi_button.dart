import 'package:flutter/material.dart';

class TaxiButton extends StatelessWidget {
  const TaxiButton({required this.title, required this.onPressed});

  final String title;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,

      child: Container(
        height: 44,
        child: Center(child: Text(title, style: TextStyle(fontSize: 18))),
      ),
    );
  }
}
